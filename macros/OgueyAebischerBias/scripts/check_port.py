#!/usr/bin/env python3
"""Compare xschem netlists of the GF180 port against the IHP source netlist, device by device.
Exit 1 on any mismatch. Unnamed nets (net<N>) are matched by a consistent bijection per subckt."""
import re, sys, importlib.util
def parse(path):
    txt=open(path).read().replace('\n+',' ')
    subs={}; cur=None
    for line in txt.splitlines():
        t=line.split()
        if not t: continue
        if t[0].lower() in ('.subckt','**.subckt'):
            cur=t[1]; subs[cur]={'ports':t[2:],'dev':{}}; continue
        if t[0].lower() in ('.ends','**.ends'): cur=None; continue
        if cur is None or t[0].startswith('*') or t[0].startswith('.'): continue
        name=t[0]
        if name[0] in 'Xx' and name[1] in 'Mm':
            nets=t[1:5]; model=t[5]; params=dict(re.findall(r'(\w+)=(\S+)',line))
            pol='n' if 'nmos' in model or 'nfet' in model else 'p'
            subs[cur]['dev'][name.upper()]=('fet',pol,nets,model,params)
        elif name[0] in 'Vv':
            subs[cur]['dev'][name.upper()]=('v',None,t[1:3],None,{})
        elif name[0] in 'Xx':
            subs[cur]['dev'][name.upper()]=('x',None,t[1:-1],t[-1],{})
    return subs
def same_nets(a,b,mp,rev):
    for x,y in zip(a,b):
        ax=re.fullmatch(r'net\d+',x); by=re.fullmatch(r'net\d+',y)
        if ax and by:
            if mp.setdefault(x,y)!=y or rev.setdefault(y,x)!=x: return False
        elif x!=y: return False
    return True
def num(s): 
    s=s.lower().rstrip('u'); return float(s)
def main(ihp, gf, variant, sizes_py):
    spec=importlib.util.spec_from_file_location('p',sizes_py); P=importlib.util.module_from_spec(spec); spec.loader.exec_module(P)
    core,start=P.device_table(variant)
    I=parse(ihp); G=parse(gf); bad=0
    pairs=[('OgueyAebischerBias',f'OgueyAebischerBias_{variant}',core),('ToBiasStartup',f'ToBiasStartup_{variant}',start),('reference',f'OgueyAebischerRef_{variant}',None)]
    for si,sg,table in pairs:
        if sg not in G: print('MISSING subckt',sg); bad+=1; continue
        a,b=I[si],G[sg]
        if a['ports']!=b['ports']: print(sg,'port order',a['ports'],'!=',b['ports']); bad+=1
        if set(a['dev'])!=set(b['dev']): print(sg,'device set differs',set(a['dev'])^set(b['dev'])); bad+=1
        mp,rev={},{}
        for n in sorted(a['dev']):
            if n not in b['dev']: continue
            da,db=a['dev'][n],b['dev'][n]
            if da[0]!=db[0] or da[1]!=db[1]: print(sg,n,'type/polarity',da[:2],db[:2]); bad+=1
            if not same_nets(da[2],db[2],mp,rev): print(sg,n,'nets',da[2],'->',db[2]); bad+=1
            if da[0]=='x' and db[3]!=f"{da[3]}_{variant}": print(sg,n,'cell',db[3]); bad+=1
            if da[0]=='fet' and table:
                model,W,L,nf=table[n[1:]]
                pr=db[4]
                if db[3]!=model or abs(num(pr['W'])-W)>1e-6 or abs(num(pr['L'])-L)>1e-6 or int(pr['nf'])!=nf or pr.get('m','1')!='1':
                    print(sg,n,'size/model',db[3],pr.get('W'),pr.get('L'),pr.get('nf'),pr.get('m'),'expected',model,W,L,nf); bad+=1
        print(f"{sg}: {len(b['dev'])} devices compared, ports {b['ports']}")
    print('RESULT:', 'PASS' if bad==0 else f'FAIL ({bad})'); sys.exit(1 if bad else 0)
if __name__=='__main__': main(*sys.argv[1:])
