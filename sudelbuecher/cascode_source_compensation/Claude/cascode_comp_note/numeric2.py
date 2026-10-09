import numpy as np, sympy as sp
exec(open('derive.py').read().split('for name,eqs')[0])
Yrs=s*Cc/(1+s*Rz*Cc)  # optional series R in the indirect path
D=[ - vs*(gmc+s*Cs) - Yrs*(vs-vo), gm1*vin + gmc*vs - vx*(G1+s*C1), gm2*vx+vo*(G2+s*CL)+Yrs*(vo-vs)]
Cm=[gm1*vin - vs*(gmc+s*Cs) - s*Cc*(vs-vo), gmc*vs - vx*(G1+s*C1), gm2*vx+vo*(G2+s*CL)+s*Cc*(vo-vs)]
sym={str(x):x for x in [gm1,gm2,gmc,G1,G2,C1,CL,Cc,Cs,Rz]}
base=dict(g_m1=100e-6,g_m2=300e-6,g_mc=200e-6,G_1=1/10e6,G_2=1/100e3,C_1=500e-15,C_L=2e-12,C_c=1e-12,C_s=150e-15,R_z=1e-3)
models={'a':(A,[vx,vo]),'b':(B,[vx,vo]),'c':(Cm,[vx,vo,vs]),'d':(D,[vx,vo,vs])}
TF={k:tf(*v) for k,v in models.items()}
f=np.logspace(2,10,20000)
def evalm(k,**ch):
    P=dict(base); P.update(ch); sub={sym[a]:v for a,v in P.items()}
    n,d=TF[k]; nc=np.array([float(c.subs(sub)) for c in n.all_coeffs()]); dc=np.array([float(c.subs(sub)) for c in d.all_coeffs()])
    H=np.polyval(nc,2j*np.pi*f)/np.polyval(dc,2j*np.pi*f); H=H/np.sign(H[0].real)
    mag=20*np.log10(abs(H)); ph=np.unwrap(np.angle(H))*180/np.pi
    i=np.argmax(mag<0); pm=180+ph[i]; j=np.argmax(ph<-180); gmar=-mag[j] if j>0 else np.inf
    pk=mag[i:].max() if False else None
    poles=np.roots(dc); cplx=[p for p in poles if abs(p.imag)>1e-6*abs(p)]
    Q=abs(cplx[0])/(2*abs(cplx[0].real)) if cplx else None
    return dict(ugf=f[i]/1e6,pm=pm,gm=gmar,Q=Q,f0=abs(cplx[0])/2/np.pi/1e6 if cplx else None,
                poles=poles/2/np.pi,zeros=np.roots(nc)/2/np.pi if len(nc)>1 else []),(mag,ph)
if __name__=='__main__':
    for k,ch in [('a',{}),('b',{'R_z':1e3}),('c',{}),('d',{}),('d',{'g_mc':1e-3}),('d',{'C_1':1e-12}),('d',{'g_mc':1e-3,'C_1':1e-12}),('d',{'R_z':2e3}),('d',{'R_z':5e3})]:
        r,_=evalm(k,**ch); print(k,ch,'UGF=%.1fMHz PM=%.1f GM=%.1fdB'%(r['ugf'],r['pm'],r['gm']), 'Q=%.2f f0=%.0fMHz'%(r['Q'],r['f0']) if r['Q'] else 'real poles', 'p=',np.round(np.sort_complex(r['poles'])/1e6,2),'z=',np.round(r['zeros']/1e6,1))
