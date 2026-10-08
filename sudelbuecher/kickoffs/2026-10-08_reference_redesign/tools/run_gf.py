#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Cloud-only harness: GF180 d2s_mpdda with d2s_bias_lp (ideal fixture). op / dc / loop over corners."""
import subprocess, re, sys, os, itertools, tempfile
PDK = os.path.join(os.environ.get("PDK_ROOT", "/foss/pdks"), os.environ.get("PDK", "gf180mcuD"), "libs.tech", "ngspice")
HERE = os.path.dirname(os.path.abspath(__file__))

def deck(corner="typical", temp=27, vdd=3.3, load="RL vout vref 1k\nCL vout 0 100p", bias="lp", extra="", drv="mpdda_gf.spice"):
    rescorner = {"typical": "res_typical", "ss": "res_ss", "ff": "res_ff", "sf": "res_typical", "fs": "res_typical"}[corner]
    b = {"lp": "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_lp"}.get(bias, bias)
    return f"""* run_gf
.include {PDK}/design.ngspice
.lib {PDK}/sm141064.ngspice {corner}
.lib {PDK}/sm141064.ngspice {rescorner}
.lib {PDK}/sm141064.ngspice moscap_typical
.include {HERE}/units_gf.spice
.include {HERE}/bias_lp_gf.spice
.include {HERE}/{drv}
{extra}
.temp {temp}
Vdd vdd 0 {vdd}
Vddo vddo 0 {vdd}
Vsso vsso 0 0
Vcm vref 0 {vdd/2}
{b}
Vd dp 0 0
Ep vinp vref dp 0 0.5
En vinn vref dp 0 -0.5
Xd vdd 0 vddo vsso vinp vinn vref vout fb vbp vbn vbpc vbnc vabp vabn d2s_mpdda
Lb vout fb 1G
Cb fb inj 1
Vinj inj 0 dc 0 ac 1
{load}
.control
op
print v(vout) v(xd.a) v(xd.b) v(xd.x) v(xd.y) v(xd.l1) v(xd.l2)
let iqp = abs(@m.xd.xop.m0[id])
let iqn = abs(@m.xd.xon.m0[id])
let idd = -i(vdd) - i(vddo)
print iqp iqn idd
ac dec 50 10 1G
let T=-v(vout)/v(fb)
meas ac T0 find vdb(T) at=10
meas ac fc when vdb(T)=0
meas ac pT find vp(T) when vdb(T)=0
let pm=180/pi*pT+180
print pm
dc Vd -0.4 0.4 0.01
let vo = v(vout) - {vdd/2}
wrdata {{DCOUT}} vo
.endc
.end
"""

def run(**kw):
    d = tempfile.mkdtemp(dir="/tmp")
    out = os.path.join(d, "dc.txt")
    txt = deck(**kw).replace("{DCOUT}", out)
    p = os.path.join(d, "t.sp"); open(p, "w").write(txt)
    r = subprocess.run(["ngspice", "-b", p], capture_output=True, text=True, cwd=d)
    res = {}
    for k, v in re.findall(r"^(\S+)\s*=\s*([-0-9.e+]+)", r.stdout, re.M):
        res[k.lower()] = float(v)
    try:
        import numpy as np
        a = np.loadtxt(out)
        vd, vo = a[:, 0], a[:, 1]
        m = abs(vd) <= 0.2001
        g, o = np.polyfit(vd[m], vo[m], 1)
        res["gain"], res["off_mV"] = g, o * 1e3
        res["inl_mV"] = 1e3 * max(abs(vo[m] - g * vd[m] - o))
    except Exception as e:
        res["err"] = str(e) + r.stdout[-2000:] + r.stderr[-2000:]
    return res

def fmt(r):
    keys = ["iqp", "iqn", "idd", "t0", "fc", "pm", "gain", "off_mV", "inl_mV", "v(xd.a)", "v(xd.b)", "v(xd.x)", "v(xd.l1)"]
    s = []
    for k in keys:
        if k in r:
            v = r[k]
            if k in ("iqp", "iqn", "idd"): s.append(f"{k}={v*1e6:.1f}u")
            elif k == "fc": s.append(f"fc={v/1e6:.2f}M")
            else: s.append(f"{k}={v:.4g}")
    if "err" in r: s.append("ERR " + r["err"][:300])
    return " ".join(s)

if __name__ == "__main__":
    what = sys.argv[1] if len(sys.argv) > 1 else "tt"
    if what == "tt":
        print("tt 27 3.3", fmt(run()))
    elif what == "corners":
        for c, t, v in [("typical", 27, 3.3), ("typical", -40, 3.3), ("typical", 125, 3.3), ("ss", -40, 3.0), ("ff", 125, 3.6),
                        ("ss", 27, 3.3), ("ff", 27, 3.3), ("sf", 27, 3.3), ("fs", 27, 3.3), ("ss", 125, 3.0), ("ff", -40, 3.6)]:
            print(f"{c:7s} {t:4d} {v}", fmt(run(corner=c, temp=t, vdd=v)))
    elif what == "loads":
        for name, ld in [("1k||100p", "RL vout vref 1k\nCL vout 0 100p"), ("100p", "CL vout 0 100p"), ("50", "RL vout vref 50\nCL vout 0 10p"), ("1n", "RL vout vref 1k\nCL vout 0 1n")]:
            print(f"{name:9s}", fmt(run(load=ld)))
