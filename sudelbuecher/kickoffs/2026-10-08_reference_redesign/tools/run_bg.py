#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Cloud-only sizing harness: GF180 bandgap core bg_core / bg_core_dn (bg_gf.spice), output into an NI-type
NMOS diode (6u/6u) or into the class-AB tree. Sections as run_bias.py on IHP."""
import re, subprocess, tempfile, os, sys
import numpy as np
PDK = os.path.join(os.environ.get("PDK_ROOT", "/foss/pdks"), os.environ.get("PDK", "gf180mcuD"), "libs.tech", "ngspice")
HERE = os.path.dirname(os.path.abspath(__file__))
FILES = ['bias_ref_gf.spice', 'bg_gf.spice']
CORN = [('tt 27C', {}), ('ss 27C', dict(c='ss')), ('ff 27C', dict(c='ff')), ('sf 27C', dict(c='sf')), ('fs 27C', dict(c='fs')),
        ('res ss', dict(r='res_ss')), ('res ff', dict(r='res_ff')), ('bjt ss', dict(b='bjt_ss')), ('bjt ff', dict(b='bjt_ff')),
        ('tt -40C', dict(temp=-40)), ('tt 125C', dict(temp=125)),
        ('ss 3.0V -40C', dict(c='ss', vdd=3.0, temp=-40)), ('ff 3.6V 125C', dict(c='ff', vdd=3.6, temp=125)),
        ('ss 3.0V 125C', dict(c='ss', vdd=3.0, temp=125)), ('ff 3.6V -40C', dict(c='ff', vdd=3.6, temp=-40))]
TEMPS = [-40, -20, 0, 27, 50, 85, 105, 125]

RMODEL = os.environ.get('RMODEL', 'ppolyf_u_3k')
def src(params=''):
    s = ''.join(open(os.path.join(HERE, f)).read() for f in FILES).replace('ppolyf_u_3k', RMODEL)
    return s + '\n' + params + '\n'

def header(c='typical', r='res_typical', b='bjt_typical', temp=27, mm=0, seed=None):
    return (f".include {PDK}/design.ngspice\n.lib {PDK}/sm141064.ngspice {c}\n.lib {PDK}/sm141064.ngspice {r}\n"
            f".lib {PDK}/sm141064.ngspice {b}\n.lib {PDK}/sm141064.ngspice diode_typical\n.temp {temp}\n"
            f".param sw_stat_mismatch={mm}\n" + (f".option seed={seed}\n" if seed else ''))

def net(var='bg_core', vdd=3.3, ac=False, ramp=None, params='', load='diode', **kw):
    v = f"Vvdd vdd 0 pwl(0 0 {ramp} {vdd})\n" if ramp else f"Vvdd vdd 0 dc {vdd}" + (" ac 1\n" if ac else "\n")
    if load == 'diode':
        ld = "Vs iout s 0\nXNI s s 0 0 nfet_03v3 W=6u L=6u nf=1\n"
    else:
        ld = "Vs iout s 0\nRL s 0 {load}\n"
    return header(**kw) + src(params) + v + f"Xc vdd 0 iout {var}\n" + ld

def ngspice(deck, ctl):
    d = tempfile.mkdtemp(dir='/tmp')
    open(d + '/b.cir', 'w').write('* b\n' + deck + '.control\n' + ctl + '.endc\n.end\n')
    o = subprocess.run(['ngspice', '-b', 'b.cir'], cwd=d, capture_output=True, text=True)
    return o.stdout + o.stderr

def results(o):
    out = {}
    for l in o.splitlines():
        if l.startswith('R '):
            t = l.split()
            try:
                out[t[1]] = [float(x) for x in t[2:]] if len(t) > 3 else float(t[2])
            except ValueError:
                pass
    return out

def iout(var='bg_core', **kw):
    o = ngspice(net(var, **kw), "op\necho R iout $&i(vs)\necho R idd $&i(vvdd)\n"
                "echo R g $&v(xc.g)\necho R ea $&v(xc.ea)\necho R eb $&v(xc.eb)\necho R vpc $&v(xc.vpc)\necho R vpg $&v(xc.vpg)\necho R cb $&v(xc.cb)\necho R vpc $&v(xc.vpc)\necho R ks $&v(xc.ks)\n")
    r = results(o)
    if 'iout' not in r:
        raise RuntimeError(o[-2000:])
    return r

def tempsweep(var='bg_core', **kw):
    return [iout(var, temp=t, **kw)['iout'] for t in TEMPS]

def section_temp(var='bg_core', params=''):
    print(f"\n== {var} vs temperature, iout uA  (params: {params or 'file defaults'})")
    print("  " + ''.join(f"{t:>8d}" for t in TEMPS) + "   drift % (vs 27C)")
    for name, c in [('tt 3.3V', {}), ('ss 3.0V', dict(c='ss', vdd=3.0)), ('ff 3.6V', dict(c='ff', vdd=3.6)),
                    ('res ss', dict(r='res_ss')), ('res ff', dict(r='res_ff')), ('bjt ss', dict(b='bjt_ss')), ('bjt ff', dict(b='bjt_ff'))]:
        i = tempsweep(var, params=params, **c)
        i27 = i[TEMPS.index(27)]
        print(f"  {name:10s}" + ''.join(f"{x*1e6:8.3f}" for x in i) + f"   {100*(min(i)/i27-1):+.2f} / {100*(max(i)/i27-1):+.2f}")

def section_corners(var='bg_core', params=''):
    print(f"\n== {var} corners: iout uA, deviation from 5 uA, Idd uA, node voltages")
    for name, c in CORN:
        r = iout(var, params=params, **c)
        print(f"  {name:14s} iout {r['iout']*1e6:7.4f} ({100*(r['iout']/5e-6-1):+6.2f} %)  Idd {-r['idd']*1e6:6.2f}  "
              f"g {r['g']:.3f} ea {r['ea']:.3f} eb {r['eb']:.3f} vpc {r['vpc']:.3f} vpg {r['vpg']:.3f} cb {r['cb']:.3f} ks {r['ks']:.3f}")

def section_line(var='bg_core', params=''):
    print(f"\n== {var} line sensitivity (3.0 -> 3.6 V) %/V, and AC |di/dvdd| / I, %/V")
    for name, c in [('tt 27C', {}), ('ss -40C', dict(c='ss', temp=-40)), ('ff 125C', dict(c='ff', temp=125))]:
        lo, mid, hi = (iout(var, vdd=v, params=params, **c)['iout'] for v in (3.0, 3.3, 3.6))
        ctl = ("ac dec 10 1 1e8\nlet m = mag(i(vs))\n" + ''.join(f"meas ac p{j} find m at={f}\n" for j, f in enumerate([10, 1e3, 1e5, 1e6, 1e7])) +
               "echo R ac " + ' '.join(f"$&p{j}" for j in range(5)) + "\n")
        p = results(ngspice(net(var, ac=True, params=params, **c), ctl))['ac']
        print(f"  {name:10s} dc {100*(hi-lo)/mid/0.6:+.3f} %/V   ac 10Hz/1k/100k/1M/10M: " + ' '.join(f"{100*x/mid:.2f}" for x in p))

def section_startup(var='bg_core', params=''):
    print(f"\n== {var} start-up from 0 V (all nodes 0, uic), ramps 1 us and 1 ms; iout 1 ms after the ramp vs op; t_startup = last time outside +-10 %")
    for name, c in [('tt 27C', {}), ('ss 3.0V -40C', dict(c='ss', temp=-40, vdd=3.0)), ('ff 3.6V 125C', dict(c='ff', temp=125, vdd=3.6)),
                    ('sf -40C', dict(c='sf', temp=-40)), ('fs 125C', dict(c='fs', temp=125)), ('tt -40C', dict(temp=-40)), ('tt 125C', dict(temp=125)),
                    ('ss 3.0V 125C', dict(c='ss', temp=125, vdd=3.0)), ('res ff -40C', dict(r='res_ff', temp=-40)), ('res ss 125C', dict(r='res_ss', temp=125))]:
        d = iout(var, params=params, **c)['iout']
        for tr in (1e-6, 1e-3):
            ts = tr + 1e-3
            ctl = (f".option method=gear abstol=1e-13\n"
                   f"tran {ts/4000} {ts} 0 {ts/2000} uic\nlet ib = abs(i(vs))\nmeas tran ibf find ib at={ts}\n"
                   f"let lo = 0.9*ibf\nlet hi = 1.1*ibf\nmeas tran tlo when ib=lo cross=last\nmeas tran thi when ib=hi cross=last\n"
                   f"echo R res $&ibf $&tlo $&thi\n")
            o = results(ngspice(net(var, ramp=tr, params=params, **c), ctl)).get('res')
            if not o or len(o) < 1:
                txt = 'NO RESULT'
            else:
                ibf = o[0]; tlo = o[1] if len(o) > 1 else 0; thi = o[2] if len(o) > 2 else 0
                tst = max(tlo if tlo > 0 else 0, thi if thi > 0 else 0)
                txt = f"iout {ibf*1e6:7.4f} uA ({100*(ibf/d-1):+6.2f} % vs op)  t_startup {(tst-tr)*1e6:8.1f} us after ramp"
            print(f"  {name:14s} t_r {tr*1e6:6.0f} us: {txt}")

def section_mc(var='bg_core', params='', N=100):
    print(f"\n== {var} mismatch MC, {N} seeds (sw_stat_mismatch=1: MOS, PNP; the PDK has no resistor mismatch)")
    rs = []
    for s in range(1, N + 1):
        rs.append(iout(var, params=params, mm=1, seed=s)['iout'])
    rs = np.array(rs)
    print(f"  mean {rs.mean()*1e6:.4f} uA  sigma {100*rs.std()/rs.mean():.2f} %  min {100*(rs.min()/rs.mean()-1):+.2f} %  max {100*(rs.max()/rs.mean()-1):+.2f} %")

S = {'temp': section_temp, 'corners': section_corners, 'line': section_line, 'startup': section_startup, 'mc': section_mc}
if __name__ == '__main__':
    var = 'bg_core'
    params = ''
    secs = []
    for a in sys.argv[1:]:
        if a.startswith('var='): var = a[4:]
        elif '=' in a: params += f".param {a}\n"
        else: secs.append(a)
    for s in secs or S:
        S[s](var, params)
        sys.stdout.flush()
