#!/usr/bin/env python3
"""Print the cell hierarchy of a Magic .mag file (use statements, with counts, array sizes and device layers)."""
import sys, os, re, collections
d, top = sys.argv[1], sys.argv[2]
maxdepth = int(sys.argv[3]) if len(sys.argv) > 3 else 9
def parse(cell):
    p = os.path.join(d, cell + '.mag')
    uses, layers = [], collections.Counter()
    if not os.path.exists(p): return None, None
    cur = None; arr = {}
    last = None
    for l in open(p, errors='replace'):
        if l.startswith('<< '):
            cur = l.split()[1]
        elif l.startswith('rect ') and cur: layers[cur] += 1
        elif l.startswith('use '):
            last = [l.split()[1], 1]; uses.append(last)
        elif l.startswith('array ') and last:
            a = list(map(int, l.split()[1:])); last[1] = (a[1]-a[0]+1)*(a[4]-a[3]+1)
    return uses, layers
seen = {}
def walk(cell, depth, mult):
    uses, layers = parse(cell)
    if uses is None:
        print('  '*depth + f'{cell} x{mult}  [NO FILE]'); return
    c = collections.Counter()
    for n, k in uses: c[n] += k
    dev = {k: v for k, v in layers.items() if re.search(r'fet|diode|cap|res|mim|esd|sab|pdiff|ndiff|poly', k)}
    print('  '*depth + f'{cell} x{mult}  rects:{sum(layers.values())} ' + ' '.join(f'{k}:{v}' for k, v in sorted(dev.items())))
    if depth >= maxdepth: return
    for n, k in c.items(): walk(n, depth+1, k)
walk(top, 0, 1)
