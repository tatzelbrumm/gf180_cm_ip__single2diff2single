import run_bg as r, numpy as np, sys
var = sys.argv[1] if len(sys.argv) > 1 else 'bg_core'
rtype = sys.argv[2] if len(sys.argv) > 2 else '3k'
rsh = {'3k': 3000, '2k': 2000, '1k': 1000, 'u': 350}[rtype]
import os; r.RMODEL = {'3k':'ppolyf_u_3k','2k':'ppolyf_u_2k','1k':'ppolyf_u_1k','u':'ppolyf_u'}[rtype]
extra = '' if rtype == '3k' else f".param dummy=0\n"
def run(r1b, r0, temps=r.TEMPS):
    p = f".param r1b={r1b*1e6:.3f}u r1a={1.1*r1b*1e6:.3f}u r0={r0*1e6:.3f}u rc={50*3000/rsh:.1f}u\n"
    return np.array([r.iout(var, temp=t, params=p)['iout'] for t in temps])
# PTAT share scan: R0 sets the PTAT current ~ 53.7 mV / R0 ; R1 the CTAT  ~ 0.648 / R1 ; branch current 2.5 uA
for xp in [0.15, 0.2, 0.25, 0.3, 0.35, 0.4]:
    ip, ic = xp*2.5e-6, (1-xp)*2.5e-6
    R0 = 0.0537/ip; R1 = 0.648/ic
    l0 = R0/rsh*1e-6; l1 = R1/rsh*1e-6
    i = run(l1, l0)
    i27 = i[r.TEMPS.index(27)]
    # rescale both resistors so that i27 = 5 uA, rerun
    k = i27/5e-6
    i = run(l1*k, l0*k)
    i27 = i[r.TEMPS.index(27)]
    print(f"xp {xp:.2f}  R1B {l1*k*1e6:7.1f}u R0 {l0*k*1e6:6.1f}u  i27 {i27*1e6:.3f}  " + ' '.join(f"{100*(x/i27-1):+6.2f}" for x in i))
