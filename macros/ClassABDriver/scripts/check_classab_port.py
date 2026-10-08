#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Round trip: compare xschem's netlist of a ported cell with its GF180 sizing subckt
(gf180_sizing.spice), device by device: model, W, L, nf, m and nets. Sub-instances of the
reference listed in FLATTEN are expanded one level (the bias sheets are drawn flat).
Ports are compared by name and order; internal nets by a consistent bijection.
Usage: check_classab_port.py <gf180_sizing.spice> <xschem_netlist.spice> <ref_subckt> <cell> [extra_ports...]
Exit 1 on any mismatch."""
import re, sys
FLATTEN = {'d2s_bias_diodes'}
def parse(path):
    txt = open(path).read().replace('\n+', ' ')
    subs, cur = {}, None
    for line in txt.splitlines():
        t = line.split()
        if not t: continue
        k = t[0].lower()
        if k in ('.subckt', '**.subckt'):
            cur = t[1]; subs[cur] = {'ports': [p for p in t[2:] if '=' not in p], 'dev': {}}; continue
        if k in ('.ends', '**.ends'): cur = None; continue
        if cur is None or t[0][0] in '*.': continue
        mods = [x for x in t if x in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k')]
        kv = dict(re.findall(r'(\w+)=(\S+)', line))
        if t[0][0] in 'Xx' and mods:
            i = t.index(mods[0])
            subs[cur]['dev'][t[0].upper()] = ('dev', mods[0], t[1:i], kv)
        elif t[0][0] in 'Xx':
            pos = [x for x in t[1:] if '=' not in x]
            subs[cur]['dev'][t[0].upper()] = ('x', pos[-1], pos[:-1], kv)
        elif t[0][0] in 'VvIiRrCc':
            subs[cur]['dev'][t[0].upper()] = ('prim', t[0][0].upper(), t[1:3], {})
    return subs
def flatten(subs, name):
    s = subs[name]; out = {}
    for n, d in s['dev'].items():
        if d[0] == 'x' and d[1] in FLATTEN:
            sub = subs[d[1]]; mp = dict(zip(sub['ports'], d[2]))
            for m, e in sub['dev'].items():
                out[m] = (e[0], e[1], [mp.get(x, f'{n}.{x}') for x in e[2]], e[3])
        else:
            out[n] = d
    return {'ports': s['ports'], 'dev': out}
def val(s):
    s = str(s).strip("'{}").lower(); mult = {'u': 1e-6, 'n': 1e-9, 'p': 1e-12, 'm': 1e-3}
    return float(s[:-1]) * mult[s[-1]] if s[-1] in mult else float(s)
def main(refp, netp, ref, cell, *extra):
    R = flatten(parse(refp), ref); G = parse(netp)
    if cell not in G: print('MISSING subckt', cell); sys.exit(1)
    g = G[cell]; bad = 0
    want = R['ports'] + list(extra)
    if g['ports'] != want: print('port order', g['ports'], '!=', want); bad += 1
    if set(R['dev']) != set(g['dev']): print('device set differs:', sorted(set(R['dev']) ^ set(g['dev']))); bad += 1
    mp, rev = {p: p for p in want}, {p: p for p in want}
    for n in sorted(set(R['dev']) & set(g['dev'])):
        a, b = R['dev'][n], g['dev'][n]
        if a[0] != b[0]: print(n, 'type', a[0], b[0]); bad += 1; continue
        if len(a[2]) != len(b[2]): print(n, 'pin count', a[2], b[2]); bad += 1; continue
        pa, pb = list(a[2]), list(b[2])
        if a[1] == 'ppolyf_u_3k' and a[0] == 'dev' and pa[:2] != pb[:2] and pa[:2] == pb[1::-1]:
            pa[:2] = pb[:2] = sorted(pa[:2])  # resistor: P and M are interchangeable
        for x, y in zip(pa, pb):
            if mp.setdefault(x, y) != y or rev.setdefault(y, x) != x:
                print(n, 'nets', a[2], '->', b[2]); bad += 1; break
        if a[0] == 'dev':
            if a[1] != b[1]: print(n, 'model', a[1], b[1]); bad += 1
            ka = {'W': 'W', 'L': 'L', 'nf': 'nf', 'm': 'm'} if a[1] != 'ppolyf_u_3k' else {'r_width': 'r_width', 'r_length': 'r_length'}
            for k in ka:
                va, vb = a[3].get(k, '1'), b[3].get(k, '1')
                if abs(val(va) - val(vb)) > 1e-3 * abs(val(va)):
                    print(n, k, va, '!=', vb); bad += 1
        elif a[0] == 'x':
            if b[1].lower() not in (a[1].lower(), {'unit_r2': 'classabunitr'}.get(a[1].lower(), '')):
                print(n, 'cell', a[1], b[1]); bad += 1
    print(f"{cell} vs {ref}: {len(g['dev'])} devices, ports {g['ports']}")
    print('MISMATCHES:', bad); sys.exit(1 if bad else 0)
if __name__ == '__main__':
    main(*sys.argv[1:])
