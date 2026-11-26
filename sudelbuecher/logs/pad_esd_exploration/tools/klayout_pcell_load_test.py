import sys, os, pya
p='/foss/pdks/gf180mcuD/libs.tech/klayout/tech/pymacros'
sys.path.insert(0,p)
try:
    from cells import gf180mcu
    gf180mcu(); print('gdsfactory-based library: loaded')
except Exception as e:
    print('gdsfactory-based library: FAILED:', type(e).__name__, str(e)[:120])
try:
    from klayout_api_cells import gf180mcu_klayoutapi
    gf180mcu_klayoutapi(); print('KLayout-API library: loaded')
except Exception as e:
    print('KLayout-API library: FAILED:', type(e).__name__, str(e)[:200])
try:
    from sealring_cells import gf180mcu_sealring
    gf180mcu_sealring(); print('sealring library: loaded')
except Exception as e:
    print('sealring library: FAILED:', type(e).__name__, str(e)[:200])
for name in pya.Library.library_names():
    lib=pya.Library.library_by_name(name)
    print('library', name, ':', sorted(lib.layout().pcell_names()))
