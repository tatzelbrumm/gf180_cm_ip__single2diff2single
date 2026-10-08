# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Small helpers to write xschem sheets and symbols for GF180MCU (gf180mcuD) cells.
Device columns: rails are wires (supply at the top, ground at the bottom), sources and bulks are
wired to their rail, gates and drains get a short stub with a net label. Pins of a block symbol
get a stub and a label in the parent. Pin offsets are those of the gf180mcuD symbols:
nfet_03v3: D (20,-30) G (-20,0) S (20,30) B (20,0); pfet_03v3: S (20,-30) G (-20,0) D (20,30) B (20,0)."""
HDR = "v {xschem version=3.4.8RC file_version=1.3}\nG {}\nK {}\nV {}\nS {}\nF {}\nE {}\n"

def fet_props(name, model, W, L, nf=1, m=1):
    return (f"name={name}\nL={L}\nW={W}\nnf={nf}\nm={m}\n"
            "ad=\"'int((nf+1)/2) * W/nf * 0.18u'\"\npd=\"'2*int((nf+1)/2) * (W/nf + 0.18u)'\"\n"
            "as=\"'int((nf+2)/2) * W/nf * 0.18u'\"\nps=\"'2*int((nf+2)/2) * (W/nf + 0.18u)'\"\n"
            "nrd=\"'0.18u / W'\" nrs=\"'0.18u / W'\"\nsa=0 sb=0 sd=0\n"
            f"model={model}\nspiceprefix=X\n")

class Sheet:
    def __init__(self):
        self.recs, self.n = [], 0
    def _id(self, p):
        self.n += 1; return f"{p}{self.n}"
    def wire(self, x1, y1, x2, y2, lab=""):
        self.recs.append(f"N {x1} {y1} {x2} {y2} {{lab={lab}}}")
    def label(self, x, y, net, right=False):
        self.recs.append(f"C {{devices/lab_pin.sym}} {x} {y} 0 {1 if right else 0} {{name={self._id('l')} sig_type=std_logic lab={net}}}")
    def pin(self, kind, x, y, net, right=False):
        self.recs.append(f"C {{devices/{kind}.sym}} {x} {y} 0 {1 if right else 0} {{name={self._id('p')} lab={net}}}")
    def text(self, s, x, y, size=0.3, layer=None):
        self.recs.append(f"T {{{s}}} {x} {y} 0 0 {size} {size} {{{'layer=%d' % layer if layer else ''}}}")
    def raw(self, s):
        self.recs.append(s.rstrip("\n"))
    def fet(self, kind, name, x, y, d, g, s, b, W, L, nf=1, m=1, top_rail=None, bot_rail=None):
        """kind 'n' or 'p'. Source (and bulk, if it is the same net) wired to the given rail y."""
        model = "nfet_03v3" if kind == "n" else "pfet_03v3"
        self.recs.append(f"C {{symbols/{model}.sym}} {x} {y} 0 0 {{{fet_props(name, model, W, L, nf, m)}}}")
        px = x + 20
        ytop, ybot = y - 30, y + 30
        top, bot = (d, s) if kind == "n" else (s, d)
        # gate: stub and label
        self.wire(x - 20, y, x - 60, y, g); self.label(x - 60, y, g)
        # top / bottom terminals
        for yy, net, rail, sign in ((ytop, top, top_rail, -1), (ybot, bot, bot_rail, 1)):
            if rail is not None and ((kind == "p" and net == s and sign < 0) or (kind == "n" and net == s and sign > 0)):
                self.wire(px, yy, px, rail, net)
            else:
                self.wire(px, yy, px, yy + sign * 20, net); self.label(px, yy + sign * 20, net, right=True)
        # bulk
        rail = top_rail if kind == "p" else bot_rail
        if rail is not None and b == s:
            self.wire(px, y, px + 40, y, b); self.wire(px + 40, y, px + 40, rail, b)
        else:
            self.wire(px, y, px + 40, y, b); self.label(px + 40, y, b, right=True)
    def block(self, sym, name, x, y, pins, conns, props=""):
        """pins: list of (pin, dx, dy) from symbol; conns: pin -> net. Stub of 20 outward, then a label."""
        self.recs.append(f"C {{{sym}}} {x} {y} 0 0 {{name={name}{(' ' + props) if props else ''}}}")
        for p, dx, dy in pins:
            px, py = x + dx, y + dy
            if dx < 0: ex, ey, right = px - 20, py, False
            elif dx > 0: ex, ey, right = px + 20, py, True
            elif dy < 0: ex, ey, right = px, py - 20, True
            else: ex, ey, right = px, py + 20, True
            self.wire(px, py, ex, ey, conns[p]); self.label(ex, ey, conns[p], right=right)
    def write(self, path, title=None):
        s = HDR + "\n".join(self.recs) + "\n"
        if title: s += f"C {{devices/title.sym}} 160 220 0 0 {{name=l0 author=\"Christoph Maier\"}}\n"
        open(path, "w").write(s)

def symbol(path, left, right, top=(), bottom=(), order=None, text=""):
    """left/right/top/bottom: lists of (pin, dir), drawn on a 40 grid. The B 5 lines (= @pinlist order)
    follow `order` (pin names) if given, else left, right, top, bottom.
    Returns [(pin, dx, dy)] in @pinlist order."""
    nlr = max(len(left), len(right), 1)
    h = 20 * nlr + 20
    nt = max(len(top), len(bottom), 1)
    w = max(100, 20 * nt + 40)
    L = [HDR.replace("K {}", 'K {type=subcircuit\nformat="@name @pinlist @symname"\ntemplate="name=x1"\n}')]
    L.append(f"P 4 5 {-w} {-h} {w} {-h} {w} {h} {-w} {h} {-w} {-h} {{}}")
    L.append(f"T {{@symname}} {-w + 30} -14 0 0 0.25 0.25 {{}}")
    L.append(f"T {{@name}} {-w + 30} 6 0 0 0.25 0.25 {{}}")
    if text: L.append(f"T {{{text}}} {-w + 30} 26 0 0 0.15 0.15 {{}}")
    spec = {}
    def col(lst, x0, xl, txtx, flip):
        n = len(lst)
        for i, (p, d) in enumerate(lst):
            y = -20 * (n - 1) + 40 * i
            spec[p] = (f"L 4 {x0} {y} {xl} {y} {{}}", f"B 5 {x0 - 2.5} {y - 2.5} {x0 + 2.5} {y + 2.5} {{name={p} dir={d}}}",
                       f"T {{{p}}} {txtx} {y - 7} 0 {flip} 0.2 0.2 {{}}", (x0, y))
    def row(lst, y0, yl, txty):
        n = len(lst)
        for i, (p, d) in enumerate(lst):
            x = -20 * (n - 1) + 40 * i
            spec[p] = (f"L 4 {x} {y0} {x} {yl} {{}}", f"B 5 {x - 2.5} {y0 - 2.5} {x + 2.5} {y0 + 2.5} {{name={p} dir={d}}}",
                       f"T {{{p}}} {x - 8} {txty} 0 0 0.2 0.2 {{}}", (x, y0))
    col(left, -w - 20, -w, -w + 5, 0)
    col(right, w + 20, w, w - 5, 1)
    row(top, -h - 20, -h, -h + 4)
    row(bottom, h + 20, h, h - 24)
    names = order or [p for p, _ in list(left) + list(right) + list(top) + list(bottom)]
    pins = []
    for p in names:
        l, b, t, xy = spec[p]
        L += [l, b, t]; pins.append((p, xy[0], xy[1]))
    open(path, "w").write("\n".join(L) + "\n")
    return pins

def sym_pins(path):
    """[(pin, dx, dy)] in @pinlist order (B 5 line order) of an existing symbol."""
    import re
    out = []
    for m in re.finditer(r"^B 5 (\S+) (\S+) (\S+) (\S+) \{[^}]*name=(\w+)", open(path).read(), re.M):
        x1, y1, x2, y2 = map(float, m.group(1, 2, 3, 4))
        out.append((m.group(5), int(round((x1 + x2) / 2)), int(round((y1 + y2) / 2))))
    return out

# ---------------------------------------------------------------- CACE templates
def esc(s):
    """CACE{...} -> CACE\\{...\\} as xschem needs it inside a property string."""
    import re
    return re.sub(r"CACE\{([^}]*)\}", r"CACE\\{\1\\}", s)

def vsrc(sheet, name, x, y, value, plus, minus="0", kind="vsource"):
    """vsource / isource symbol at (x, y), pins p (0,-30) and m (0,30), each with a stub and a label."""
    sheet.raw(f"C {{devices/{kind}.sym}} {x} {y} 0 0 {{name={name} value=\"{esc(value)}\"}}")
    sheet.wire(x, y - 30, x, y - 50, plus); sheet.label(x, y - 50, plus, right=True)
    sheet.wire(x, y + 30, x, y + 50, minus); sheet.label(x, y + 50, minus, right=True)

def cace_template(path, title, notes, dut_sym, dut_pins, conns, sources, body, extra_models="", dut_xy=(700, -400)):
    """sources: list of (name, value, plus, minus[, kind]). body: the ngspice .control section and options,
    with CACE{...} written plainly (escaped here)."""
    s = Sheet()
    s.text(title, 60, -1000, 0.45)
    s.text(notes, 60, -950, 0.25)
    s.block(dut_sym, "x1", dut_xy[0], dut_xy[1], dut_pins, conns)
    for i, src in enumerate(sources):
        name, value, plus, minus = src[:4]
        kind = src[4] if len(src) > 4 else "vsource"
        vsrc(s, name, 160 + 120 * i, -100, value, plus, minus, kind)
    s.raw('C {devices/code_shown.sym} 1200 -760 0 0 {name=NGSPICE\nsimulator=ngspice\nonly_toplevel=false\nvalue="\n'
          + esc(".include CACE{DUT_path}\n.temp CACE{temp}\n" + body) + '"}')
    s.raw('C {devices/code_shown.sym} 1200 -900 0 0 {name=MODEL\nonly_toplevel=true\nformat="tcleval( @value )"\nvalue="\n'
          '.include $::180MCU_MODELS/design.ngspice\n'
          + esc(".lib $::180MCU_MODELS/sm141064.ngspice CACE{corner_mos}\n"
                ".lib $::180MCU_MODELS/sm141064.ngspice CACE{corner_res=res_typical}\n"
                ".lib $::180MCU_MODELS/sm141064.ngspice moscap_typical\n"
                ".param sw_stat_mismatch=CACE{mm=0}\n" + extra_models) + '"}')
    s.write(path, title=True)
