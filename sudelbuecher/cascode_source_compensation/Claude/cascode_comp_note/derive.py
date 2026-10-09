import sympy as sp
s,gm1,gm2,gmc,G1,G2,C1,CL,Cc,Cs,Rz,vin=sp.symbols('s g_m1 g_m2 g_mc G_1 G_2 C_1 C_L C_c C_s R_z v_in',positive=True)
vx,vo,vs=sp.symbols('v_x v_o v_s')
def tf(eqs,unk):
    sol=sp.solve(eqs,unk,dict=True)[0]
    H=sp.together(sol[vo]/vin); n,d=sp.fraction(H)
    return sp.Poly(sp.expand(n),s),sp.Poly(sp.expand(d),s)
# (a) plain Miller
Yc=s*Cc
A=[gm1*vin+vx*(G1+s*C1)+Yc*(vx-vo), gm2*vx+vo*(G2+s*CL)+Yc*(vo-vx)]
# (b) Miller + Rz
Yr=s*Cc/(1+s*Rz*Cc)
B=[gm1*vin+vx*(G1+s*C1)+Yr*(vx-vo), gm2*vx+vo*(G2+s*CL)+Yr*(vo-vx)]
# (c) cascode (indirect) compensation: Cc from output to cascode source S
C=[gm1*vin - vs*(gmc+s*Cs) - s*Cc*(vs-vo),   # node S, input current enters S
   gmc*vs - vx*(G1+s*C1),                    # node X fed by ideal current buffer
   gm2*vx+vo*(G2+s*CL)+s*Cc*(vo-vs)]          # output
for name,eqs,unk in [('miller',A,[vx,vo]),('miller_rz',B,[vx,vo]),('cascode',C,[vx,vo,vs])]:
    n,d=tf(eqs,unk)
    print('==',name); print(' num:',sp.factor(n.as_expr())); print(' den coeffs (s^0..):')
    for k,c in enumerate(reversed(d.all_coeffs())): print('   s^%d:'%k, sp.factor(c))
# (d) cascode compensation, Cc to a cascode source that carries NO input current
#     (input current injected at the high-impedance node X instead)
D=[ - vs*(gmc+s*Cs) - s*Cc*(vs-vo),
   gm1*vin + gmc*vs - vx*(G1+s*C1),
   gm2*vx+vo*(G2+s*CL)+s*Cc*(vo-vs)]
n,d=tf(D,[vx,vo,vs]); print('== cascode_noinput'); print(' num:',sp.factor(n.as_expr()))
for k,c in enumerate(reversed(d.all_coeffs())): print('   s^%d:'%k, sp.factor(c))
