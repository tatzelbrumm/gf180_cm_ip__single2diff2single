import numpy as np, scipy.signal as sg
from numeric2 import *
cases=[('a','Miller, no $R_z$',{}),('b','Miller + $R_z=1/g_{m2}$',{'R_z':1/300e-6}),
       ('c','Casc., $C_c$ to folding node',{}),('d','Casc., $C_c$ to non-input source',{}),
       ('aH','Miller, no $R_z$ (heavy drive)',{'g_m2':3e-3}),('bH','Miller + $R_z$ (heavy drive)',{'g_m2':3e-3,'R_z':1/300e-6}),
       ('dH','Casc., non-input (heavy drive)',{'g_m2':3e-3}),('dH2',r'as dH, $g_{mc}=600\,\mu$S',{'g_m2':3e-3,'g_mc':600e-6})]
rows=[]
for tag,lab,ch in cases:
    k=tag[0]; P=dict(base); P.update(ch); sub={sym[a]:v for a,v in P.items()}
    n,d=TF[k]; nc=np.array([float(c.subs(sub)) for c in n.all_coeffs()]); dc=np.array([float(c.subs(sub)) for c in d.all_coeffs()])
    sgn=np.sign(nc[-1]/dc[-1]); nc=nc*sgn
    L=sg.TransferFunction(nc,dc)
    T=sg.TransferFunction(nc,np.polyadd(dc,nc))
    w=2*np.pi*f; _,Tm=sg.freqresp(T,w); peak=20*np.log10(abs(Tm).max()/abs(Tm[0]))
    t=np.linspace(0,400e-9,40001); t,y=sg.step(T,T=t); y=y/y[-1]
    os=(y.max()-1)*100
    out=np.where(abs(y-1)>0.001)[0]; ts=t[out[-1]]*1e9 if len(out) else 0
    r,(mag,ph)=evalm(k,**ch)
    np.savetxt(f'bode_{tag}.dat',np.c_[f[::20],mag[::20],ph[::20]],header='f mag ph',comments='')
    np.savetxt(f'step_{tag}.dat',np.c_[t[::100]*1e9,y[::100]],header='t y',comments='')
    rows.append((tag,lab,r['ugf'],r['pm'],r['gm'],r['Q'],peak,os,ts))
    print('%-3s %-48s UGF=%5.1f PM=%5.1f GM=%5.1f Q=%s peak=%.2fdB OS=%.1f%% ts(0.1%%)=%.1fns'%(tag,lab,r['ugf'],r['pm'],r['gm'],'%.2f'%r['Q'] if r['Q'] else '-',peak,os,ts))
import json; json.dump(rows,open('rows.json','w'))
