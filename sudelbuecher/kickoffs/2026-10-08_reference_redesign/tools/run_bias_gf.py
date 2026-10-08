#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Cloud-only: bias currents of the GF180 bias variants (sensed in the diode drains)."""
import re, subprocess, tempfile, os, sys
PDK = os.path.join(os.environ.get("PDK_ROOT", "/foss/pdks"), os.environ.get("PDK", "gf180mcuD"), "libs.tech", "ngspice")
HERE = os.path.dirname(os.path.abspath(__file__))
NOM = {'bp': 5e-6, 'bn': 5e-6, 'bnc': 2e-6, 'bpc': 2e-6, 'abp': 5e-6, 'abn': 5e-6}
DRAIN = {'bp': 'XBP', 'bn': 'XBN', 'bnc': 'XBNC', 'bpc': 'XBPC', 'abp': 'XRP2', 'abn': 'XRN2'}
INST = {'in': "Iref 0 iref 5u\nXb vdd 0 vddo vsso iref vbp vbn vbpc vbnc vabp vabn d2s_bias_in",
        'out': "Iref iref 0 5u\nXb vdd 0 vddo vsso iref vbp vbn vbpc vbnc vabp vabn d2s_bias_out",
        'oa': "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_oa",
        'bg': "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bg"}
CORN = [('tt 27C', {}), ('ss 27C', dict(c='ss')), ('ff 27C', dict(c='ff')), ('sf 27C', dict(c='sf')), ('fs 27C', dict(c='fs')),
        ('res ss', dict(r='res_ss')), ('res ff', dict(r='res_ff')),
        ('tt -40C', dict(temp=-40)), ('tt 125C', dict(temp=125)),
        ('ss 3.0V -40C', dict(c='ss', vdd=3.0, temp=-40)), ('ff 3.6V 125C', dict(c='ff', vdd=3.6, temp=125))]
FILES = ['bias_ref_gf.spice']
def src():
    s = ''.join(open(os.path.join(HERE, f)).read() for f in FILES)
    m = re.search(r'\.subckt d2s_bias_diodes.*?\.ends d2s_bias_diodes', s, re.S)
    body = m.group(0)
    for k, dev in DRAIN.items():
        body = re.sub(rf'^{dev} (\S+)', lambda mm: f'Vs{k} {mm.group(1)} s{k} 0\n{dev} s{k}', body, flags=re.M)
    return s.replace(m.group(0), body)
def net(var, c='typical', r='res_typical', temp=27, vdd=3.3, extra=''):
    return (f".include {PDK}/design.ngspice\n.lib {PDK}/sm141064.ngspice {c}\n.lib {PDK}/sm141064.ngspice {r}\n"
            f".lib {PDK}/sm141064.ngspice moscap_typical\n.lib {PDK}/sm141064.ngspice bjt_typical\n.temp {temp}\n" + src() +
            f"Vvdd vdd 0 {vdd}\nVvddo vddo 0 {vdd}\nVvsso vsso 0 0\n" + INST[var] + "\n" + extra)
def sense(var, k):
    return f"i(v.xb.xt.xd.vs{k})" if var in ('oa', 'bg') else f"i(v.xb.xd.vs{k})"
def currents(var, **kw):
    ctl = ".control\nop\n" + ''.join(f"echo R {k} $&{sense(var, k)}\n" for k in NOM) + ".endc\n.end\n"
    d = tempfile.mkdtemp(dir='/tmp'); open(d + '/b.cir', 'w').write('* b\n' + net(var, **kw) + ctl)
    o = subprocess.run(['ngspice', '-b', 'b.cir'], cwd=d, capture_output=True, text=True).stdout
    res = {l.split()[1]: abs(float(l.split()[2])) for l in o.splitlines() if l.startswith('R ')}
    if len(res) < 6: raise RuntimeError(o[-1500:])
    return res
if __name__ == '__main__':
    for var in sys.argv[1:] or ['in', 'out']:
        print(f"-- {var}  % deviation from 5/5/2/2/5/5 uA\n  {'corner':15s}" + ''.join(f"{k:>8}" for k in NOM))
        for name, c in CORN:
            i = currents(var, **c)
            print(f"  {name:15s}" + ''.join(f"{100*(i[k]/NOM[k]-1):8.2f}" for k in NOM))
