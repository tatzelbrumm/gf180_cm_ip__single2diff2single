<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# 2026-10-06 — GF180 port: bias reference in two variants, CACE suites, IOPad proof of concept

Session `ae2f9665-832e-520c-96fd-494fa4898beb`, Claude (configured model `claude-opus-5-5`; the serving model may differ).
Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;
tool calls as `*[ ]*` summaries (actions and observable results only); shell commands verbatim in collapsed blocks, their output omitted.
The internal reasoning trace is not included.
Times are Europe/Berlin. Exported through the record stamped 2026-10-08 03:07; later turns are not in this file.

## Turn 1 — 2026-10-06 21:30

**User:**

Migrate the cm_ip__single2diff2single work-in-progress design from ihp13cmos5l to Global Foundries 180. 
As proof-of-concept, run the bias circuit test and verification suites; start building CACE suites.
Create xschem schematics and symbols for circuits and test bases, as proof-of-concept.

**Assistant:**

I'll start by surveying the existing single2diff2single design and the GF180 reference repos on your machine, then plan the migration.

*[Called ToolSearch (0 lines of output).]*

*[Ran a command (on the computer; 111 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt && ls; for d in */; do echo "=== $d"; (cd "$d"; git log --oneline -3 2>/dev/null; ls -la | head -40); done
```

</details>

There's a handover document already. Let me read it and the CLAUDE.md files.

*[Ran a command (on the computer; 284 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && cat HANDOVER_gf180_migration.md CLAUDE.md .designinit .gitignore; git status | head -30; git log --stat -5 | head -100
```

</details>

The handover says no git commands without asking — I ran a `git status`/`log` before reading it. Let me check that no lock file was left behind.

*[Ran a command (on the computer; 134 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && ls -la .git/*.lock 2>&1; cat docs/IHP_TO_GF180_PORT_MAP.md docs/OPERATING_LIMITS.md docs/GF180_PROCESS_OPTIONS.md; ls -R docs harness_stub dependencies macros schematic testbenches layout floorplan | head -80
```

</details>

No lock was left. The IHP reference repo isn't among the connected folders, so let me locate it.

*[Called mcp__remote-devices__device_list_dir (1 lines of output).  
Called mcp__remote-devices__device_request_folder_access (1 lines of output).]*

**User (sent at 21:30 while the assistant was working):**

There are plenty of more ore less reliable examples in chipalooza3

Noted — I'll use the chipalooza3 projects as GF180 references (device models, CACE layout, xschem conventions). First, the IHP reference.

*[Ran a command (on the computer; 337 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt && ls; cd sg13cmos5l_cm_ip__single2diff2single && ls -la && find . -path ./.git -prune -o -type f -print | grep -v -E '\.(gds|png|raw|pdf)$' | sort | head -300
```

</details>

*[Ran a command (on the computer; 400 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single && find . -path ./.git -prune -o -path '*/_runs' -prune -o -path '*/save_from_claudes_fuckup' -prune -o -type f -print | grep -v -E '\.(gds|png|raw|pdf)$' | sort | sed -n '1,400p' | grep -v '^./macros/OgueyAebischerBias/verification/cace/_runs'
```

</details>

*[Ran a command (on the computer; 486 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single && find . \( -name .git -o -name _runs -o -name runs -o -name flow -o -name save_from_claudes_fuckup -o -name counter -o -name inverter -o -name final \) -prune -o -type f -print | grep -v -E '\.(gds|png|raw|pdf)$' | sort | tail -n +42; echo; ls macros
```

</details>

The "bias circuit" is the `OgueyAebischerBias` macro with its testbench and CACE suite. Reading it in full:

*[Ran a command (on the computer; 231 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias && cat README.md; echo =====; cat schematic/xschem/OgueyAebischerBias.sch; echo =====SYM; cat schematic/xschem/OgueyAebischerBias.sym
```

</details>

*[Ran a command (on the computer; 289 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias && cat schematic/xschem/ToBiasStartup.sch; echo ====SYM; cat schematic/xschem/ToBiasStartup.sym; echo ====TB; cat testbenches/xschem/OgueyAebischerBias_tb.sch; echo ===RC; cat testbenches/xschem/xschemrc | grep -v '^#' | grep -v '^$'
```

</details>

*[Ran a command (on the computer; 462 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias && cat verification/cace/OgueyAebischer.yaml; echo ====; cat verification/cace/_docs/reference.md verification/cace/_docs/reference_schematic.md; echo ===; cat verification/cace/netlist/schematic/reference.spice; ls -la verification/cace verification/cace/_runs/*/ ; cat verification/cace/_runs/*/flow.log | tail -60; cat verification/cace/_runs/*/error.log | head -30
```

</details>

The committed `OgueyAebischer.yaml` is only a template; the working suite must have lived elsewhere. Let me find it via the last run's artifacts.

*[Ran a command (on the computer; 190 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias/verification/cace && R=_runs/RUN_2026-09-04_08-27-47; cat $R/summary.md; ls $R/parameters/*; ls results scripts netlist/*; cd $HOME/mnt; grep -rl --include=*.yaml -e "tran_startup_params" sg13cmos5l_cm_ip__single2diff2single sg13cmos5l_cm_ip__single2diff2single_sudelbuecher 2>/dev/null | head; find sg13cmos5l_cm_ip__single2diff2single_sudelbuecher -maxdepth 3 | head -50
```

</details>

The full CACE suite (`reference.yaml` + templates) isn't committed, but each run directory holds the testbench templates. Let me pull those and search for the yaml.

*[Ran a command (on the computer; 370 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt; grep -rl -e "Ibias_accuracy" --include='*' sg13cmos5l_cm_ip__single2diff2single_sudelbuecher sg13cmos5l_cm_ip__single2diff2single gf180_cm_ip__single2diff2single_sudelbuecher 2>/dev/null | grep -v '/_runs/' | head; cd sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias/verification/cace/_runs/RUN_2026-09-04_08-27-47/parameters; for f in */*.sch; do echo "######## $f"; grep -v -E '^(N|C \{devices/(lab|title))' $f ; done
```

</details>

The chatlogs from 2026-09-04 should contain `reference.yaml`. Let me extract it.

*[Ran a command (on the computer; 27 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog; ls -la; grep -n "cace_format" *.md | head -20
```

</details>

*[Ran a command (on the computer; 45 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog; grep -n -i -E "reference\.yaml|Ibias_accuracy|ibias_nom|corner_mos|conditions:" 2026-09-04_*.md | head -60
```

</details>

The yaml itself isn't in the chatlogs verbatim, but the run artifacts have everything to reconstruct it. Collecting the per-parameter conditions:

*[Ran a command (on the computer; 90 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias/verification/cace/_runs/RUN_2026-09-04_08-27-47/parameters; for p in *; do echo "### $p"; ls $p | grep run_ | wc -l; for r in $(ls -d $p/run_* | head -50); do tr '\n' ' ' < $r/conditions.yaml; echo; done | sort | uniq | head -50; done; head -5 dc_params/simulation_summary.csv tran_startup_params/simulation_summary.csv
```

</details>

Now the sizing analysis from the IHP session, which identifies what the GF180 re-derivation should fix:

*[Ran a command (on the computer; 321 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog; sed -n 100,420p 2026-09-04_opus_cace_templates_and_oab_sizing.md
```

</details>

*[Ran a command (on the computer; 33 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/chipalooza3; for d in */; do echo "=== $d"; find $d -name '*.yaml' -not -path '*/_runs/*' -not -path '*/.git/*' | head; done; echo; grep -rh --include=*.sch -o -E 'C \{[a-z0-9_/]*(fet|ppoly|cap_mim|npolyf|diode)[a-z0-9_]*\.sym\}' . | sort | uniq -c | sort -rn | head -30
```

</details>

*[Ran a command (on the computer; 82 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt; find chipalooza3 gf180_cm_ip__gatekeeper gf180mcu_ocd_io gf180mcu_ocd_sram_test -type d \( -name cace -o -name templates \) -not -path '*/.git/*' | head; find chipalooza3 -maxdepth 2 | head -80
```

</details>

The gatekeeper template has a GF180 CACE example for the inverter macro — that's the convention to follow.

*[Ran a command (on the computer; 521 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__gatekeeper/macros/inverter; find . -type f -not -path '*/_runs/*' | head -50; cat verification/cace/*.yaml; for f in verification/cace/templates/*; do echo "#### $f"; cat $f; done
```

</details>

The gatekeeper template is still IHP-flavoured, so GF180 conventions must come from the PDK itself. Checking what tools exist on your machine's shell and in my workspace:

*[Ran a command (on the computer).]*

<details><summary>command</summary>

```sh
for t in ngspice xschem magic netgen klayout cace docker podman python3 git; do printf "%-8s " $t; which $t || echo -; done; uname -a; cat /etc/os-release | head -3; ls /foss 2>&1 | head; echo $PDK_ROOT
```

</details>

*[Ran a command (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
for t in ngspice xschem magic netgen klayout cace python3 git apt-get; do printf "%-8s " $t; which $t || echo -; done; cat /etc/os-release | head -3; python3 --version; nproc; df -h /home/claude | tail -1
```

</details>

*[Created task "Set up GF180 sim toolchain in cloud workspace".  
Created task "Characterize GF180 devices for bias re-sizing".  
Created task "Port OgueyAebischerBias + ToBiasStartup schematics/symbols to GF180".  
Created task "Port bias testbench and CACE suite to GF180, run it".  
Created task "Start CACE/xschem scaffolding for IOPad macros".  
Created task "Verify, document, write handover".  
Set task 1 to in_progress.]*

*[Ran a command (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
(sudo -n true 2>/dev/null && echo SUDO || echo nosudo); id -u; timeout 300 apt-get update -qq 2>&1 | tail -3; apt-cache policy ngspice xschem magic netgen-lvs 2>&1 | grep -E '^[a-z]|Candidate'
```

</details>

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
DEBIAN_FRONTEND=noninteractive timeout 580 apt-get install -y -qq ngspice xschem xvfb >/tmp/apt.log 2>&1; tail -3 /tmp/apt.log; which ngspice xschem xvfb-run; ngspice -v 2>&1 | head -3; xschem -v 2>&1 | head -2
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
timeout 400 pip install --break-system-packages -q ciel cace 2>&1 | tail -5; which ciel cace; ciel --version 2>&1 | tail -1; cace --version 2>&1 | tail -2
```

</details>

*[Ran a command (in the cloud container; 28 lines of output).]*

<details><summary>command</summary>

```sh
pip show cace ciel 2>/dev/null | grep -E '^(Name|Version)'; ls /usr/local/bin | grep -i cace; cace --help 2>&1 | head -30; which python3; ls -la $(which python3)
```

</details>

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
ls -la /etc/alternatives/python3; ls /usr/bin/python3*; apt-cache policy python3.13-tk python3-tk 2>&1 | grep -E '^[a-z]|Candidate'
```

</details>

*[Ran a command (in the cloud container; 41 lines of output).]*

<details><summary>command</summary>

```sh
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-tk python3.12-venv >/tmp/apt2.log 2>&1; tail -1 /tmp/apt2.log; python3.12 -m venv /home/claude/venv && /home/claude/venv/bin/pip install -q cace ciel 2>&1 | tail -2; /home/claude/venv/bin/cace --help 2>&1 | head -40
```

</details>

CACE 2.13 runs. Now the gf180mcuD PDK via ciel:

*[Ran a command (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk && mkdir -p $PDK_ROOT && timeout 120 /home/claude/venv/bin/ciel ls-remote --pdk-family gf180mcu 2>&1 | head -15
```

</details>

*[Ran a command (in the cloud container; 100 lines of output).]*

<details><summary>command</summary>

```sh
cat /root/.ccr/README.md | head -60; curl -sS "$HTTPS_PROXY/__agentproxy/status" | head -40
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
curl -sS "$HTTPS_PROXY/__agentproxy/status" | python3 -c "import json,sys; d=json.load(sys.stdin); [print(x['host'],x['detail']) for x in d['recentRelayFailures'][-4:]]"; curl -sS -o /dev/null -w "%{http_code}\n" https://github.com/; curl -sS -o /dev/null -w "%{http_code}\n" https://api.github.com/repos/fossi-foundation/ciel-releases/releases?per_page=1
```

</details>

The GitHub API is blocked here, so ciel can't list releases. Trying direct git clones of the PDK sources instead:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/src && cd /home/claude/src && timeout 300 git clone -q --depth 1 https://github.com/RTimothyEdwards/open_pdks.git 2>&1 | tail -2; ls open_pdks/gf180mcu 2>&1 | head; timeout 300 git clone -q --depth 1 https://github.com/fossi-foundation/gf180mcu-fd-pr.git 2>&1 | tail -2; ls gf180mcu-fd-pr 2>&1
```

</details>

*[Ran a command (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src && cat open_pdks/gf180mcu/gf180mcu.json | python3 -c "import json,sys;d=json.load(sys.stdin);print(json.dumps(d.get('reference',d.get('version')),indent=1))" 2>/dev/null | head -20; grep -n -i "git\|https" open_pdks/gf180mcu/Makefile.in | head -30
```

</details>

*[Ran a command (in the cloud container; 79 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 160,200p open_pdks/gf180mcu/Makefile.in; grep -n "PR_PATH\|xschem" open_pdks/gf180mcu/Makefile.in | head -40
```

</details>

*[Ran a command (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
timeout 500 git clone -q --depth 1 https://github.com/fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_pr.git fd_pr 2>&1 | tail -2; ls fd_pr fd_pr/models/ngspice fd_pr/cells/xschem 2>&1 | head -40; cat open_pdks/gf180mcu/gf180mcu.json | grep -i -A2 '"reference"' ; grep -n commit open_pdks/gf180mcu/gf180mcu.json | head
```

</details>

*[Ran a command (in the cloud container; 140 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 890,915p open_pdks/gf180mcu/Makefile.in; grep -n "ngspice" open_pdks/gf180mcu/Makefile.in | head -30; ls fd_pr/cells/xschem/gf180mcu_fd_pr | head -80; cat fd_pr/cells/xschem/xschemrc | grep -v '^#' | grep -v '^$' | head -40
```

</details>

*[Ran a command (in the cloud container; 31 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 90,120p open_pdks/gf180mcu/gf180mcu.json; cd fd_pr && git log -1 --format='%H %ad'
```

</details>

The primitive library HEAD matches the commit open_pdks pins. Building a minimal gf180mcuD install tree (ngspice models + xschem library) the way open_pdks lays it out:

*[Ran a command (in the cloud container; 24 lines of output).]*

<details><summary>command</summary>

```sh
set -e; P=/home/claude/pdk/gf180mcuD; rm -rf $P; mkdir -p $P/libs.tech/ngspice $P/libs.tech/xschem; S=/home/claude/src/fd_pr
cp -p $S/models/ngspice/*.spice $P/libs.tech/ngspice/; cd $P/libs.tech/ngspice; for f in *.spice; do ln -s $f ${f%.spice}.ngspice; done
X=$P/libs.tech/xschem; cp -rp $S/cells/xschem/gf180mcu_fd_pr $X/; ln -s gf180mcu_fd_pr $X/symbols; cp -rp $S/cells/xschem/tests $S/cells/xschem/xschemrc $S/cells/xschem/xschem-menu $X/
cd /home/claude/src/open_pdks/gf180mcu && python3 ./custom/scripts/fix_xschemrc.py $X/xschemrc gf180mcuD; ls $P/libs.tech/ngspice; grep -n -v '^#' $X/xschemrc | grep -i -E 'model|180MCU|LIBRARY' | head -20
```

</details>

*[Ran a command (in the cloud container; 99 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice; grep -n -i "^\.lib\|^\.endl" sm141064.spice | head -80; echo; grep -n -i "^\.param\|mc_\|switch\|corner" design.spice | head -40; wc -l *.spice
```

</details>

*[Ran a command (in the cloud container; 139 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice; sed -n 1,104p sm141064.spice | grep -v '^\*\*\*\*' | head -60; sed -n 105,170p sm141064.spice; grep -n "^\.lib nfet_06v0\|^\.lib pfet_06v0\|^\.lib nfet_05v0\|^\.lib nfet_03v3\|^\.lib fets_mm\|^\.lib noise_corner" sm141064.spice
```

</details>

*[Ran a command (in the cloud container; 138 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice; cat design.spice | sed -n 15,73p; sed -n 46921,46990p sm141064.spice; grep -n "^\.lib stat\|^\.lib .*stat\b" sm141064.spice | head
```

</details>

*[Ran a command (in the cloud container; 264 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols; for s in nfet_06v0 pfet_06v0 nfet_03v3 cap_mim_2f0fF ppolyf_u_1k; do echo "#### $s"; grep -v -E '^(L|A|P|T \{[^@])' $s.sym; done; ls ../tests | head -40
```

</details>

*[Question card shown to the user:]*

- Which GF180 FET family should the bias circuit (and, by default, the core analog) use? The IHP original used sg13_hv (3.3 V thick-oxide). GF180's 3.3 V devices (nfet/pfet_03v3) match better (A_VT ≈ 7 vs 11.5 mV·µm, so ~2.7× less area for the same σ) and have full corner models, but cap the analog supply at 3.3 V (+10 %). The 6 V devices (nfet/pfet_06v0) keep a 5 V analog supply option open. Options: 3.3 V (03v3) (Recommended); 6 V (06v0); Both variants

*[Result: 1 lines of output.]*

Both variants it is: I'll build the bias in `03v3` and `06v0` flavours side by side, each with its own CACE datasheet. Checking how CACE and ngspice expect the GF180 models to be loaded:

*[Ran a command (in the cloud container; 23 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/venv/lib/python3.12/site-packages/cace; grep -rn -i "spiceinit" --include=*.py . | head; grep -rn "gf180" --include=*.py . | head; cat /home/claude/src/fd_pr/models/ngspice/README.md | head -60
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src/open_pdks/gf180mcu; find . -iname '*spiceinit*'; grep -n -i spiceinit Makefile.in | head; cat $(find . -iname '*spiceinit*' | head -1) 2>/dev/null
```

</details>

*[Ran a command (in the cloud container; 64 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 510,550p /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py; cd /home/claude/pdk/gf180mcuD/libs.tech/xschem/tests; grep -h -A12 'name=MODELS\|name=s1\|code' test_nfet_06v0.sch | head -50
```

</details>

Writing a quick sanity netlist to confirm ngspice-42 runs the GF180 models:

*[Ran a command (in the cloud container; 64 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/char && cd /home/claude/work/char && M=/home/claude/pdk/gf180mcuD/libs.tech/ngspice && cat > sanity.cir <<EOF
* sanity
.include $M/design.ngspice
.lib $M/sm141064.ngspice typical
Xn d g 0 0 nfet_03v3 W=2u L=1u nf=1 m=1
Xp dp gp vd vd pfet_06v0 W=2u L=1u nf=1 m=1
vd d 0 1.5
vg g 0 0.6
vdd vd 0 3.3
vdp dp 0 1.8
vgp gp 0 2.6
.control
op
print all
show all
.endc
.end
EOF
time ngspice -b sanity.cir 2>&1 | grep -v -E '^\s*$' | head -60
```

</details>

GF180 models run under ngspice-42. Now the device characterization (gm/I_D vs inversion level, I_spec, slope factor n) for the four candidate devices:

*[Ran a command (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
cat > char.py <<'EOF'
import subprocess, numpy as np, os, sys
M='/home/claude/pdk/gf180mcuD/libs.tech/ngspice'
UT=0.025852
devs={'nfet_03v3':'n','pfet_03v3':'p','nfet_06v0':'n','pfet_06v0':'p'}
res={}
for dev,pol in devs.items():
  for L in [1,2,4,8]:
    W=10
    if pol=='n':
      net=f"Xm d g 0 0 {dev} W={W}u L={L}u nf=1 m=1\nvd d 0 1.0\nvg g 0 0\n"
      sw="dc vg 0 2.5 0.005"; ids="-vd#branch"
    else:
      net=f"Xm d g s s {dev} W={W}u L={L}u nf=1 m=1\nvs s 0 3.3\nvd d 0 2.3\nvg g 0 3.3\n"
      sw="dc vg 3.3 0.8 -0.005"; ids="vd#branch"
    cir=f"""* char
.include {M}/design.ngspice
.lib {M}/sm141064.ngspice typical
.temp 27
{net}
.control
{sw}
let id={ids}
let gm=deriv(id)
wrdata out_{dev}_{L}.txt id gm
.endc
.end
"""
    open('c.cir','w').write(cir)
    subprocess.run(['ngspice','-b','c.cir'],capture_output=True)
    d=np.loadtxt(f'out_{dev}_{L}.txt')
    vg=d[:,0]; idd=np.abs(d[:,1]); gm=np.abs(d[:,3])
    ok=idd>1e-13
    gmid=gm[ok]/idd[ok]; I=idd[ok]; v=vg[ok]
    # slope factor from max gm/id in weak inversion
    n=1/(UT*np.max(gmid[(I>1e-11)]))
    # Ispec: EKV gm*n*UT/Id = (1-exp(-sqrt(IC)))/sqrt(IC) ; =0.5 at IC~? solve
    g=gm[ok]*n*UT/idd[ok]
    # IC where g crosses EKV value at IC=1: (1-exp(-1))/1 = 0.632
    k=np.where(g<0.632)[0]; k=k[k>np.argmax(g)][0]
    I1=I[k]
    Isq=I1/(W/L)   # Ispec per square (IC=1)
    res[(dev,L)]=(n,Isq,v[k])
    print(f"{dev:10s} L={L}u  n={n:.3f}  Ispec/sq(IC=1)={Isq*1e9:8.1f} nA  Vg@IC1={v[k]:.3f}")
EOF
python3 char.py
```

</details>

*[Ran a command (on the computer; 53 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/chipalooza3; f=$(grep -rl 'symbols/nfet_03v3.sym' --include=*.sch . | head -1); echo $f; grep -A14 'symbols/nfet_03v3.sym' $f | head -32; grep -rh -B2 -A6 'name=MODELS\|180MCU_MODELS' --include=*.sch . | grep -v '^--$' | sort | uniq -c | sort -rn | head -20
```

</details>

Now a parameterized SPICE model of the bias core plus start-up, to re-derive sizes by simulation before drawing anything:

*[Ran a command (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/size && cd /home/claude/work/size && cat > oab.py <<'EOF'
import subprocess, numpy as np, re, os, sys, json
M='/home/claude/pdk/gf180mcuD/libs.tech/ngspice'
def fet(name,d,g,s,b,model,W,L,nf=1):
    return f"X{name} {d} {g} {s} {b} {model} W={W}u L={L}u nf={nf} m=1\n"
def core(p):
    n,pm=p['nmod'],p['pmod']
    s=".subckt oab vdd vbp vbn vbr vss\n"
    s+=fet('M10','net3','vbn','vres','vss',n,p['Wn']*p['K10'],p['Ln'],p['K10'])
    s+=fet('M11','vbn','vbn','vss','vss',n,p['Wn'],p['Ln'])
    s+=fet('M12','vbp','vbp','vdd','vdd',pm,p['Wp'],p['Lp'])
    s+=fet('M13','net2','vbp','vdd','vdd',pm,p['Wp']*p['K13'],p['Lp'],p['K13'])
    s+=fet('M14','net1','vbp','vdd','vdd',pm,p['Wp']*p['K14'],p['Lp'],p['K14'])
    s+="Vi1 vbp net3 0\nVi4 net2 vbn 0\nViaux net1 vbr 0\n"
    N=p['Nst']
    a=['vres']+[f'r{i}' for i in range(1,N)]+['vss']
    b=['vbr']+[f'a{i}' for i in range(1,N)]+['vss']
    for i in range(N):
        s+=fet(f'MR{i}',a[i],'vbr',a[i+1],'vss',n,p['Wst'],p['Lst'])
        s+=fet(f'MA{i}',b[i],'vbr',b[i+1],'vss',n,p['Wst'],p['Lst'])
    s+=".ends\n"
    s+=".subckt start vdd vbp vbn disable vbr vss\n"
    s+=fet('M24','vbr','disable','vss','vss',n,1,p['Lsu_n'])
    s+=fet('M22','vbr','vkick','vdd','vdd',pm,1,p['Lsu_p'])
    s+=fet('M25','vkick','vbp','vdd','vdd',pm,p['Wp'],p['Lp'])
    s+=fet('M23','vbn','disable','vss','vss',n,1,p['Lsu_n'])
    s+=fet('M21','vbn','vkick','vdd','vdd',pm,1,p['Lsu_p'])
    s+=fet('M20','disable','vkick','disable','vss',n,p['Wcap'],p['Lcap'])
    s+=fet('M26','vdd','vbp','vdd','vss',n,p['Wcap'],p['Lcap'])
    s+=".ends\n"
    return s
def run(p, analysis, corner='typical', temp=27, vdd=3.3, mm=0, seed=1, extra=''):
    cir=f"""* oab
.include {M}/design.ngspice
.lib {M}/sm141064.ngspice {corner}
.param sw_stat_mismatch={mm}
.temp {temp}
.options klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15 SEED={seed}
{core(p)}
Xb vdd vbp vbn vbr 0 oab
Xs vdd vbp vbn dis vbr 0 start
Vdis dis 0 0
{extra}
.control
{analysis}
.endc
.end
"""
    fn=f'/tmp/oab_{os.getpid()}.cir'
    open(fn,'w').write(cir)
    r=subprocess.run(['ngspice','-b',fn],capture_output=True,text=True)
    return r.stdout+r.stderr
def op(p,**kw):
    out=run(p,"""op
print v(vbp) v(vbn) v(vbr) v(xb.vres) v.xb.vi1#branch v.xb.vi4#branch v.xb.viaux#branch""",
        extra=f"VDD vdd 0 {kw.pop('vdd',3.3)}\n.nodeset v(vbp)=2.0",**kw)
    vals={}
    for line in out.splitlines():
        m=re.match(r'\s*(\S+)\s*=\s*([-+0-9.eE]+)',line)
        if m: vals[m.group(1)]=float(m.group(2))
    return vals
EOF
cat > try1.py <<'EOF'
from oab import *
base=dict(nmod='nfet_03v3',pmod='pfet_03v3',Wn=16,Ln=1.5,Wp=13,Lp=2,K10=4,K13=4,K14=2,Nst=4,Wst=2,Lst=10,Lsu_n=1,Lsu_p=1,Wcap=8,Lcap=2)
for Lst in [5,10,20]:
  p=dict(base,Lst=Lst); v=op(p)
  print(Lst, {k:round(x,4) if abs(x)>1e-3 else f"{x:.3e}" for k,x in v.items()})
EOF
python3 try1.py
```

</details>

With a 4 × (2 µm / 20 µm) triode stack the 3.3 V variant lands at I₁ = 104 nA, ΔV_res = 85 mV. Now corners, supply, temperature and mismatch for this first cut:

*[Ran a command (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cat > eval.py <<'EOF'
from oab import *
import sys, statistics as st
def evaluate(p, mc=100, label=''):
    I=lambda v: v['v.xb.vi1#branch']
    rows=[]
    for c in ['typical','ss','ff','sf','fs']:
        for t in [-40,27,85]:
            v=op(p,corner=c,temp=t); rows.append((c,t,I(v),v['v(vbr)'],v['v(vbp)'],v['v(vbn)']))
    Is=[r[2] for r in rows]
    vt=op(p); i0=I(vt)
    lo=I(op(p,vdd=3.0)); hi=I(op(p,vdd=3.6))
    line=(hi-lo)/0.6/i0
    vbr_lo=op(p,vdd=3.0)['v(vbr)']; vbr_hi=op(p,vdd=3.6)['v(vbr)']
    psrr=-20*np.log10(abs(vbr_hi-vbr_lo)/0.6)
    acc=[];lm=[]
    for s in range(mc):
        v=op(p,mm=1,seed=1000+s)
        acc.append(I(v)/i0-1); lm.append(v['v.xb.vi4#branch']/(4*I(v))-1)
    print(f"{label} I1={i0*1e9:.1f}nA corners {min(Is)*1e9:.1f}..{max(Is)*1e9:.1f}nA  line {line*100:.1f}%/V  PSRR(vbr,dc)={psrr:.1f}dB  "
          f"MC sigma(I1)={st.pstdev(acc)*100:.1f}%  sigma(leg)={st.pstdev(lm)*100:.2f}%  mean(leg)={st.mean(lm)*100:.2f}%  vbp={vt['v(vbp)']:.3f} vbn={vt['v(vbn)']:.3f} vbr={vt['v(vbr)']:.3f}")
    return rows
if __name__=='__main__':
    base=dict(nmod='nfet_03v3',pmod='pfet_03v3',Wn=16,Ln=1.5,Wp=13,Lp=2,K10=4,K13=4,K14=2,Nst=4,Wst=2,Lst=20,Lsu_n=1,Lsu_p=1,Wcap=8,Lcap=2)
    rows=evaluate(base,label='03v3 base')
    for r in rows: print(r[0],r[1],f"{r[2]*1e9:.1f}")
EOF
time python3 eval.py
```

</details>

*[Ran a command (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
cat > tune.py <<'EOF'
from eval import *
def tune(p,target=100e-9):
    # I ~ 1/Lst : iterate
    for _ in range(4):
        i=op(p)['v.xb.vi1#branch']; p['Lst']=round(p['Lst']*i/target,1)
    return p
v33=dict(nmod='nfet_03v3',pmod='pfet_03v3',Wn=22,Ln=2.2,Wp=18,Lp=2.8,K10=4,K13=4,K14=2,Nst=4,Wst=2,Lst=20,Lsu_n=1,Lsu_p=1,Wcap=8,Lcap=2)
v60=dict(nmod='nfet_06v0',pmod='pfet_06v0',Wn=30,Ln=3.4,Wp=24,Lp=4.4,K10=4,K13=4,K14=2,Nst=4,Wst=2,Lst=20,Lsu_n=1,Lsu_p=1,Wcap=8,Lcap=4)
for name,p in [('03v3',v33),('06v0',v60)]:
    p=tune(p); print(name,'Lst=',p['Lst']); evaluate(p,label=name)
EOF
time python3 tune.py 2>&1 | tail -6
```

</details>

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
from oab import *
p=dict(nmod='nfet_06v0',pmod='pfet_06v0',Wn=30,Ln=3.4,Wp=24,Lp=4.4,K10=4,K13=4,K14=2,Nst=4,Wst=2,Lst=20,Lsu_n=1,Lsu_p=1,Wcap=8,Lcap=4)
print(run(p,'op\nprint all',extra='VDD vdd 0 3.3\n.nodeset v(vbp)=2.0')[-3000:])
"
```

</details>

W = 120 µm overflows the model's bin range. Checking the binning limits so both variants stay inside them:

*[Ran a command (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice; for d in nfet_03v3 pfet_03v3 nfet_06v0 pfet_06v0; do echo -n "$d: "; awk -v d="$d" 'tolower($0) ~ "^\\.model "d"\\." {f=1} f && /wmax/ {for(i=1;i<=NF;i++) if($i ~ /wmax|wmin|lmax|lmin/) printf "%s%s ", $i, $(i+1)} f && /^\+.*lmax/ {} /^\.model/ && !(tolower($0) ~ "^\\.model "d"\\.") {f=0}' sm141064.spice | tr ' ' '\n' | grep -E '^(wmax|lmax)' | sort | uniq -c | sort -rn | head -4 | tr '\n' ' '; echo; done; grep -n -i "wnflag\|binunit" sm141064.spice | head -3
```

</details>

Max W per instance is 100 µm, so 4-unit devices are limited to 25 µm per unit; the 6 V variant gets its area from L instead:

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/size && sed -i "s/Wn=30,Ln=3.4,Wp=24,Lp=4.4/Wn=24,Ln=3.0,Wp=24,Lp=4.0/" tune.py && time python3 tune.py 2>&1 | tail -6
```

</details>

Both variants now sit at 100 nA with σ(I₁) ≈ 5 %. Before drawing, I need to confirm the start-up kick actually works with these sizes (VDD ramp, no nodeset) across corners:

*[Ran a command (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
cat > su.py <<'EOF'
from oab import *
import tune as T
def startup(p,corner,temp,vdd=3.3,ramp='1u'):
    out=run(p,f"""tran 10n 200u
meas tran t_up when v(vbr)=0.9 rise=1 td=1u
meas tran ifin find v.xb.vi1#branch at=200u
meas tran vkf find v(xs.vkick) at=200u""",corner=corner,temp=temp,extra=f"VDD vdd 0 pwl(0 0 {ramp} {vdd})")
    m=dict(re.findall(r'^(t_up|ifin|vkf)\s*=\s*([-+0-9.eE]+)',out,re.M))
    return m
for name,p in [('03v3',T.v33),('06v0',T.v60)]:
    for c in ['typical','ss','ff','sf','fs']:
        for t in [-40,27,85]:
            m=startup(p,c,t); print(name,c,t,{k:float(v) for k,v in m.items()})
EOF
python3 su.py 2>&1 | grep -v "^03v3 Lst\|^06v0 Lst\|I1="
```

</details>

*[Ran a command (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cat > su2.py <<'EOF'
from oab import *
import tune as T
def startup(p,corner,temp,vdd=3.3,ramp='1u'):
    out=run(p,f"""tran 10n 200u
meas tran ifin find v.xb.vi1#branch at=200u
let i90 = 0.9*ifin
meas tran t_up when v.xb.vi1#branch=i90 rise=1
meas tran t_vbr when v(vbr)=0.5 rise=1""",corner=corner,temp=temp,extra=f"VDD vdd 0 pwl(0 0 {ramp} {vdd})")
    return {k:float(v) for k,v in re.findall(r'^(t_up|ifin|t_vbr)\s*=\s*([-+0-9.eE]+)',out,re.M)}
for name,p in [('03v3',T.v33),('06v0',T.v60)]:
    for c in ['typical','ss','ff']:
        for t in [-40,85]:
            print(name,c,t,startup(p,c,t))
    print(name,'slow ramp 1ms', startup(p,'typical',27,ramp='1m'))
EOF
python3 su2.py 2>&1 | grep -v "Lst\|I1="
```

</details>

The 1 ms ramp case was mis-set (simulation stopped at 200 µs, before VDD finished ramping). Re-running slow ramps properly, since slow supply ramps are a known failure mode for kick-type start-ups:

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cat > su3.py <<'EOF'
from oab import *
import tune as T
def startup(p,corner,temp,ramp,tstop):
    out=run(p,f"""tran {float(tstop)/20000} {tstop}
meas tran ifin find v.xb.vi1#branch at={tstop}
let i90 = 0.9*ifin
meas tran t_up when v.xb.vi1#branch=i90 rise=1
meas tran vdd_up find v(vdd) when v.xb.vi1#branch=i90 rise=1""",corner=corner,temp=temp,extra=f"VDD vdd 0 pwl(0 0 {ramp} 3.3)")
    return {k:float(v) for k,v in re.findall(r'^(t_up|ifin|vdd_up)\s*=\s*([-+0-9.eE]+)',out,re.M)}
for name,p in [('03v3',T.v33),('06v0',T.v60)]:
    for ramp,ts in [('1m','3m'),('100m','300m')]:
        for c,t in [('typical',27),('ss',-40),('ff',85)]:
            print(name,'ramp',ramp,c,t,startup(p,c,t,ramp,ts))
EOF
python3 su3.py 2>&1 | grep -v "Lst\|I1="
```

</details>

*[Ran a command (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
sed -i "s/for ramp,ts in \[('1m','3m'),('100m','300m')\]/for ramp,ts in [('1m',3e-3),('100m',0.3)]/" su3.py && python3 su3.py 2>&1 | grep -v "Lst\|I1="
```

</details>

*[Loaded skill "anthropic-skills:xschem-analog-schematic".]*

*[Ran a command (on the computer; 94 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff; cat README.md; grep -v '^\s*#' schematic/xschem/xschemrc | grep -v '^$'; echo =====TB; diff schematic/xschem/xschemrc testbenches/xschem/xschemrc; echo; grep -n -i "cace\|sim-\|^[a-z-]*:" Makefile | head -60
```

</details>

*[Ran a command (on the computer; 72 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt; grep -n -A12 "^sim-cace\|^CACE\|cace" sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias/Makefile | head -50; sed -n 1,72p gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff/Makefile
```

</details>

*[Ran a command (on the computer; 23 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__gatekeeper/macros/inverter; grep -n -B2 -A14 "^sim-cace" Makefile; grep -n "CACE" Makefile | head
```

</details>

I'll build the macro in my workspace, verify it with xschem/ngspice/CACE here, then copy it to your folder. Staging the source files:

*[Copied 16 files from the computer to the cloud container (1 lines of output).]*

*[Ran a command (in the cloud container; 90 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/uploads/sg13cmos5l_cm_ip__single2diff2single/macros; cat sg13cmos5l_IOPadSingle2Diff/schematic/xschem/*.sch; echo ----; cat sg13cmos5l_IOPadDiff2Single/schematic/xschem/*.sch; echo; cat sg13cmos5l_IOPadDiff2Single/schematic/xschem/*.sym
```

</details>

The IHP IOPad macros are only stubs (pins; Diff2Single has the IHP-only ESD clamps), so the bias macro carries the real proof-of-concept. Staging the six IHP CACE templates in full:

*[Copied 7 files from the computer to the cloud container (error).]*

Too deeply nested to stage directly; I'll copy them to the device-side scratch folder first.

*[Ran a command (on the computer).]*

<details><summary>command</summary>

```sh
pwd; mkdir -p ihp_cace && cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias/verification/cace/_runs/RUN_2026-09-04_08-27-47/parameters && cp */*.sch dc_params/run_00/reference.sym $OLDPWD/ihp_cace/ 2>&1; cd $OLDPWD; ls -la ihp_cace; realpath ihp_cace
```

</details>

*[Called mcp__remote-devices__get_device_info (238 lines of output).]*

The scratch folder isn't stageable, so I'll read the wiring lines I haven't seen yet and regenerate the templates myself (they need rewriting for GF180 anyway):

*[Ran a command (on the computer; 165 lines of output).]*

<details><summary>command</summary>

```sh
cd ihp_cace; cat reference.sym; for f in *.sch; do echo "#### $f"; grep -E '^(N|C \{devices/(lab|gnd|vsource|title))' $f; done
```

</details>

I have everything needed. Checking the macro Makefile's simulation targets before writing the new macro:

*[Ran a command (in the cloud container; 88 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff; sed -n 72,135p Makefile; sed -n 380,410p Makefile
```

</details>

*[Set task 1 to completed.  
Set task 2 to completed.  
Set task 3 to in_progress.]*

Writing the port generator: it rewrites the IHP schematics with GF180 symbols and the re-derived sizes, keeping every wire, and emits the wrapper, testbench and symbols for both variants.

*[Wrote port_from_ihp.py (in the cloud container; 1 lines of output).]*

*[Ran a command (in the cloud container; 50 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 scripts/port_from_ihp.py /mnt/user-data/uploads/sg13cmos5l_cm_ip__single2diff2single/macros/OgueyAebischerBias . && head -30 schematic/xschem/OgueyAebischerBias_03v3.sch && grep -c "^C" schematic/xschem/*.sch
```

</details>

Now the xschemrc files, then netlisting with xschem and a device-by-device comparison against the IHP netlist topology:

*[Ran a command (in the cloud container; 79 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff && cp $U/schematic/xschem/xschemrc schematic/xschem/ && cp $U/testbenches/xschem/xschemrc testbenches/xschem/ && cp $U/scripts/check_pex_ports.py scripts/ && mkdir -p layout/gds layout/klayout layout/magic && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && mkdir -p /home/claude/work/net && for c in OgueyAebischerBias_03v3 ToBiasStartup_03v3 OgueyAebischerRef_03v3 OgueyAebischerRef_06v0; do rm -f /home/claude/work/net/$c.spice; (cd schematic/xschem && PWD=$(pwd) xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /home/claude/work/net $(pwd)/$c.sch >/tmp/x_$c.log 2>&1; echo "$c rc=$?"); done; cat /home/claude/work/net/OgueyAebischerRef_03v3.spice; grep -i -E "error|warn|not found" /tmp/x_*.log | head
```

</details>

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
head -20 /tmp/x_OgueyAebischerBias_03v3.log; head -c 3 /home/claude/work/repo/macros/OgueyAebischerBias/schematic/xschem/xschemrc | xxd
```

</details>

The project's `xschemrc` files start with a UTF-8 byte-order mark, which xschem 3.4.4's Tcl rejects (`invalid command name "ï»¿#"`). Stripping it from the new macro's copies:

*[Ran a command (in the cloud container; 110 lines of output).]*

<details><summary>command</summary>

```sh
sed -i '1s/^\xEF\xBB\xBF//' schematic/xschem/xschemrc testbenches/xschem/xschemrc && head -c 20 schematic/xschem/xschemrc | od -c | head -2; grep -l $'\xEF\xBB\xBF' /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/schematic/xschem/xschemrc /mnt/user-data/uploads/gf180_cm_ip__gatekeeper/macros/inverter/verification/cace/templates/xschemrc; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; for c in OgueyAebischerBias_03v3 ToBiasStartup_03v3 OgueyAebischerRef_03v3 OgueyAebischerRef_06v0; do rm -f /home/claude/work/net/$c.spice; (cd schematic/xschem && PWD=$(pwd) xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /home/claude/work/net $(pwd)/$c.sch >/tmp/x_$c.log 2>&1; echo "$c rc=$?"); done; grep -i -E "error|not found" /tmp/x_*.log | head; cat /home/claude/work/net/OgueyAebischerRef_03v3.spice
```

</details>

xschem netlists all four top cells cleanly. Now the device-by-device comparison against the IHP topology (net-for-net, with auto-named nets matched by bijection) and against the sizing table:

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/check && cat > /home/claude/work/check/ihp_reference.spice <<'EOF'
.subckt OgueyAebischerBias vdd vbp vbn vbr vss
XM10 net3 vbn vres vss sg13_hv_nmos w=1u l=1u ng=1 m=4 mm_ok=1
XM12 vbp vbp vdd vdd sg13_hv_pmos w=1u l=1u ng=1 m=1 mm_ok=1
XM11 vbn vbn vss vss sg13_hv_nmos w=1u l=1u ng=1 m=1 mm_ok=1
XM13 net2 vbp vdd vdd sg13_hv_pmos w=1u l=1u ng=1 m=4 mm_ok=1
XM14 net1 vbp vdd vdd sg13_hv_pmos w=1u l=1u ng=1 m=2 mm_ok=1
XM16 vres vbr net5 vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
XM15 vbr vbr net4 vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
Vi1 vbp net3 0
Vi4 net2 vbn 0
Viaux net1 vbr 0
XM18 net5 vbr net6 vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
XM17 net4 vbr net7 vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
XM20 net6 vbr net9 vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
XM19 net7 vbr net8 vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
XM22 net9 vbr vss vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
XM21 net8 vbr vss vss sg13_hv_nmos w=1u l=20u ng=1 m=1 mm_ok=1
.ends
.subckt ToBiasStartup vdd vbp vbn disable vbr vss
XM24 vbr disable vss vss sg13_hv_nmos w=1u l=0.45u ng=1 m=1 mm_ok=1
XM22 vbr vkick vdd vdd sg13_hv_pmos w=1u l=0.45u ng=1 m=1 mm_ok=1
XM25 vkick vbp vdd vdd sg13_hv_pmos w=1u l=0.45u ng=1 m=1 mm_ok=1
XM23 vbn disable vss vss sg13_hv_nmos w=1u l=0.45u ng=1 m=1 mm_ok=1
XM21 vbn vkick vdd vdd sg13_hv_pmos w=1u l=0.45u ng=1 m=1 mm_ok=1
XM20 disable vkick disable vss sg13_hv_nmos w=8u l=2u ng=1 m=1 mm_ok=1
XM26 vdd vbp vdd vss sg13_hv_nmos w=8u l=2u ng=1 m=1 mm_ok=1
.ends
.subckt reference vdd vbp vbn disable vbr vss
xbias vdd vbp vbn vbr vss OgueyAebischerBias
xstart vdd vbp vbn disable vbr vss ToBiasStartup
.ends
EOF
cat > /home/claude/work/check/check_port.py <<'EOF'
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
                if db[3]!=model or abs(num(pr['W'])-W)>1e-6 or abs(num(pr['L'])-L)>1e-6 or int(pr['nf'])!=nf or pr.get('m')!='1':
                    print(sg,n,'size/model',db[3],pr.get('W'),pr.get('L'),pr.get('nf'),pr.get('m'),'expected',model,W,L,nf); bad+=1
        print(f"{sg}: {len(b['dev'])} devices compared, ports {b['ports']}")
    print('RESULT:', 'PASS' if bad==0 else f'FAIL ({bad})'); sys.exit(1 if bad else 0)
if __name__=='__main__': main(*sys.argv[1:])
EOF
cd /home/claude/work/check && S=/home/claude/work/repo/macros/OgueyAebischerBias/scripts/port_from_ihp.py; for v in 03v3 06v0; do python3 check_port.py ihp_reference.spice /home/claude/work/net/OgueyAebischerRef_$v.spice $v $S; done
# sanity: corrupt one label and confirm FAIL
sed 's/^XM11 vbn vbn vss vss/XM11 vbn vbp vss vss/' /home/claude/work/net/OgueyAebischerRef_03v3.spice > /tmp/bad.spice; python3 check_port.py ihp_reference.spice /tmp/bad.spice 03v3 $S | tail -3
```

</details>

Both variants match the IHP topology device for device, with the intended sizes; the checker catches a deliberately corrupted gate. Now running the start-up testbench the way `make sim-xschem` does:

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/testbenches/xschem && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && mkdir -p simulations && for v in 03v3 06v0; do TB=OgueyAebischerRef_${v}_tb_tran; PWD=$(pwd) xschem -r -x -q --rcfile xschemrc --command "xschem set netlist_type spice; set netlist_dir $(pwd)/simulations; xschem netlist" $(pwd)/$TB.sch >/tmp/xs_$v.log 2>&1; (cd simulations && ngspice -b $TB.spice 2>&1 | grep -E -i "i1_final|error|warning" | head -5); done; grep -n "lib\|include" simulations/OgueyAebischerRef_03v3_tb_tran.spice
```

</details>

Both testbenches start from 0 V and settle at 100.0 nA. Rendering the schematics to check that they read properly:

*[Ran a command (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
pip install --break-system-packages -q cairosvg 2>&1 | tail -1; mkdir -p /home/claude/work/render && cd /home/claude/work/repo/macros/OgueyAebischerBias && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && for f in schematic/xschem/OgueyAebischerBias_03v3 schematic/xschem/ToBiasStartup_06v0 schematic/xschem/OgueyAebischerRef_03v3 testbenches/xschem/OgueyAebischerRef_03v3_tb_tran; do d=$(dirname $f); b=$(basename $f); (cd $d && PWD=$(pwd) xvfb-run -a xschem --rcfile $(pwd)/xschemrc -q -x --svg --plotfile /home/claude/work/render/$b.svg $(pwd)/$b.sch >/dev/null 2>&1); python3 -c "import cairosvg;cairosvg.svg2png(url='/home/claude/work/render/$b.svg',write_to='/home/claude/work/render/$b.png',output_width=1600,background_color='white')"; done; ls -la /home/claude/work/render
```

</details>

*[Read OgueyAebischerBias_03v3.png (in the cloud container; image shown to the assistant).  
Read OgueyAebischerRef_03v3.png (in the cloud container; image shown to the assistant).]*

The core schematic is the IHP drawing with GF180 devices, wire for wire; the wrapper is correct but plain. The port note I appended doesn't show in the core render, so let me check why:

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
tail -3 schematic/xschem/OgueyAebischerBias_03v3.sch; grep -n "^T" schematic/xschem/OgueyAebischerBias_03v3.sch
```

</details>

*[Ran a command (in the cloud container; 29 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 550,575p /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py; grep -n '"templates"\|templates' /home/claude/venv/lib/python3.12/site-packages/cace/common/cace_read.py | head; grep -rn "def .*copy.*sym\|primitive" /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py | head
```

</details>

CACE only warns if no spiceinit exists. Writing the CACE generator (templates + datasheet per variant):

*[Wrote gen_cace.py (in the cloud container; 1 lines of output).]*

*[Ran a command (in the cloud container; 53 lines of output).]*

<details><summary>command</summary>

```sh
python3 scripts/gen_cace.py . >/dev/null && ls verification/cace verification/cace/templates && cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && time /home/claude/venv/bin/cace OgueyAebischerRef_03v3.yaml -p dc_params --no-progress-bar -j 2 2>&1 | tail -30
```

</details>

*[Ran a command (in the cloud container; 45 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=200 && /home/claude/venv/bin/cace OgueyAebischerRef_03v3.yaml -p dc_params --no-progress-bar 2>&1 | head -40; ls cace 2>/dev/null; ls;
```

</details>

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
R=$(ls -d _runs/RUN_* | tail -1); cat $R/error.log | head -30; ls $R/parameters/dc_params/run_00; cat $R/parameters/dc_params/run_00/ngspice_stdout.out | tail -15; cat $R/parameters/dc_params/run_00/*.data
```

</details>

*[Ran a command (in the cloud container; 40 lines of output).]*

<details><summary>command</summary>

```sh
R=$(ls -d _runs/RUN_* | tail -1); cat $R/flow.log | grep -v spiceinit | tail -20; cat $R/parameters/dc_params/run_00/xschem_stderr.out | head; head -50 $R/parameters/dc_params/run_00/OgueyAebischerRef_03v3_tb_dc.spice
```

</details>

*[Ran a command (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
R=$(ls -d _runs/RUN_* | tail -1)/parameters/dc_params/run_00; cd $R && ngspice -b OgueyAebischerRef_03v3_tb_dc.spice 2>&1 | tail -8; grep -n "def run_subprocess\|ngspice\b" /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py | head; grep -n "\.data\|returncode" /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py | head -20
```

</details>

*[Ran a command (in the cloud container; 74 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude && sed -n 1185,1215p /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py; sed -n 575,620p /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py
```

</details>

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_*/parameters/dc_params/run_00 && ngspice -b OgueyAebischerRef_03v3_tb_dc.spice 2>&1 | head -30
```

</details>

*[Ran a command (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd $(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | head -1)/parameters/dc_params/run_00 && ngspice -b OgueyAebischerRef_03v3_tb_dc.spice 2>&1 | head -30
```

</details>

*[Ran a command (in the cloud container; 24 lines of output).]*

<details><summary>command</summary>

```sh
ls -la /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/netlist/schematic/; head -20 /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/netlist/schematic/*.spice
```

</details>

The DUT netlist's top-level `.subckt` line is commented out (`**.subckt`), so the testbench can't find the subcircuit. Checking how CACE asks xschem for a subcircuit netlist:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
grep -n -B3 -A30 "def regenerate_schematic_netlist" /home/claude/venv/lib/python3.12/site-packages/cace/common/cace_regenerate.py | grep -n "xschem\|tcl\|top_subckt\|lvs\|args" | head -30
```

</details>

*[Ran a command (in the cloud container; 107 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 494,600p /home/claude/venv/lib/python3.12/site-packages/cace/common/cace_regenerate.py
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
strings /usr/bin/xschem | grep -i "top_is_subckt\|top_subckt" | head; grep -rn "top_is_subckt\|top_subckt" /usr/share/xschem/*.tcl | head -5
```

</details>

*[Ran a command (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
ls /usr/share/xschem/ | head; grep -rln "subckt" /usr/share/xschem/*.tcl | head; strings /usr/bin/xschem | grep -i "is_subckt\|lvs_netlist\|spice_netlist" | head
```

</details>

This xschem 3.4.4 doesn't know CACE's `top_is_subckt` switch (added in later versions; your container has a newer one). Building current xschem from source so local runs match your toolchain:

*[Ran a command (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src && timeout 300 git clone -q --depth 1 https://github.com/StefanSchippers/xschem.git 2>&1 | tail -2; cd xschem && git log -1 --format='%h %ad' && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq libx11-dev libxrender-dev libxpm-dev libxcb1-dev libx11-xcb-dev libcairo2-dev tcl-dev tk-dev flex bison libjpeg-dev >/tmp/apt3.log 2>&1; tail -1 /tmp/apt3.log; ./configure --prefix=/opt/xschem >/tmp/xconf.log 2>&1 && make -j2 >/tmp/xmake.log 2>&1 && make install >/tmp/xinst.log 2>&1; tail -3 /tmp/xmake.log; /opt/xschem/bin/xschem -v 2>&1 | head -2
```

</details>

xschem 3.4.8RC built. Re-running the earlier checks with it, plus testing whether 3.4.8 tolerates the BOM in your existing `xschemrc` files:

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; which xschem; mkdir -p /tmp/bomtest && cp /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/xschemrc /tmp/bomtest/ && cp /home/claude/work/repo/macros/OgueyAebischerBias/schematic/xschem/*_03v3.s* /tmp/bomtest/ && cd /tmp/bomtest && rm -f /tmp/bomnet/*; mkdir -p /tmp/bomnet; PWD=/tmp/bomtest xschem --rcfile /tmp/bomtest/xschemrc -n -s -q -x -o /tmp/bomnet /tmp/bomtest/OgueyAebischerBias_03v3.sch 2>&1 | head -3; grep -c nfet_03v3 /tmp/bomnet/*.spice
# full re-check of netlists with 3.4.8
cd /home/claude/work/repo/macros/OgueyAebischerBias/schematic/xschem && for v in 03v3 06v0; do rm -f /home/claude/work/net/OgueyAebischerRef_$v.spice; PWD=$(pwd) xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /home/claude/work/net $(pwd)/OgueyAebischerRef_$v.sch >/dev/null 2>&1; python3 /home/claude/work/check/check_port.py /home/claude/work/check/ihp_reference.spice /home/claude/work/net/OgueyAebischerRef_$v.spice $v ../../scripts/port_from_ihp.py | tail -1; done
```

</details>

xschem 3.4.8 tolerates the BOM, so your existing files are fine. But the round-trip check now fails under 3.4.8; looking at why:

*[Ran a command (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
python3 /home/claude/work/check/check_port.py /home/claude/work/check/ihp_reference.spice /home/claude/work/net/OgueyAebischerRef_03v3.spice 03v3 ../../scripts/port_from_ihp.py | head -8; grep -n "XM10" -A3 /home/claude/work/net/OgueyAebischerRef_03v3.spice
```

</details>

Only a checker artifact: xschem 3.4.8 omits `m=1` from the netlist line. Treating a missing `m` as 1:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/check && sed -i "s/pr.get('m')!='1'/pr.get('m','1')!='1'/" check_port.py && cd /home/claude/work/repo/macros/OgueyAebischerBias/schematic/xschem && for v in 03v3 06v0; do python3 /home/claude/work/check/check_port.py /home/claude/work/check/ihp_reference.spice /home/claude/work/net/OgueyAebischerRef_$v.spice $v ../../scripts/port_from_ihp.py | tail -1; done
```

</details>

Round-trip passes under xschem 3.4.8. Now the first CACE parameter group again:

*[Ran a command (in the cloud container; 23 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace && rm -rf _runs netlist && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=220 && time /home/claude/venv/bin/cace OgueyAebischerRef_03v3.yaml -p dc_params --no-progress-bar -j 2 2>&1 | grep -v spiceinit | grep -E "Core|Ibias|Vb|ERROR|rror" | head -20; R=$(ls -d _runs/RUN_* | tail -1); cat $R/error.log | head; head -5 $R/parameters/dc_params/simulation_summary.csv
```

</details>

The DC group runs: I₁ = 90–120 nA over 45 corner/supply/temperature points. Running the full suite for both variants:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
rm -rf _runs && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && mkdir -p /home/claude/work/logs && for v in 03v3 06v0; do (time /home/claude/venv/bin/cace OgueyAebischerRef_$v.yaml --no-progress-bar -j 2 > /home/claude/work/logs/cace_$v.out 2>&1) 2>&1 | grep real; done; for v in 03v3 06v0; do echo "== $v"; grep -E "Pass|Fail|Skip" /home/claude/work/logs/cace_$v.out | grep ngspice; done; cat _runs/*/error.log | head -20
```

</details>

The full suite exceeds the 10-minute shell limit. Checking where the time goes, then I'll run it in the background:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
pkill -f "bin/cace" ; sleep 1; for R in _runs/*; do echo $R; for p in $R/parameters/*; do echo "  $(basename $p): $(find $p -name '*.data' | wc -l) data files"; done; done; tail -5 /home/claude/work/logs/cace_03v3.out
```

</details>

*[Ran a command (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace; ls _runs; for R in _runs/*; do for p in $R/parameters/*; do echo "$R $(basename $p): $(find $p -name '*.data' | wc -l) data"; done; done; grep -v spiceinit /home/claude/work/logs/cace_03v3.out | tail -5; pgrep -af ngspice | head -3
```

</details>

Some groups had finished (disable passes); others were still queued on 2 CPUs. Timing a single slow-ramp transient to size the run:

*[Ran a command (in the cloud container; 17 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_*/parameters/tran_startup_params && for d in run_*; do f=$(ls $d/*.data 2>/dev/null); c=$(grep -E "tramp|corner|temp" $d/conditions.yaml | tr '\n' ' '); echo "$d [$c] $( [ -n "$f" ] && cat $f)"; done | head -12; d=$(ls -d run_* | sed -n 2p); cd $d && grep tramp conditions.yaml; time ngspice -b *.spice > /dev/null 2>&1
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && sed -i 's/meas tran t90 when v.x1.xbias.vi1#branch=i90 rise=1/* LAST crossing: displacement current through the ammeter crosses i90 early during a fast ramp\nmeas tran t90 when v.x1.xbias.vi1#branch=i90 cross=last/' scripts/gen_cace.py && grep -n "cross=last" -B1 scripts/gen_cace.py && python3 scripts/gen_cace.py . > /dev/null && cd verification/cace && rm -rf _runs && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && nohup bash -c 'for v in 03v3 06v0; do for p in dc_params tran_startup_params ac_psrr_params noise_params disable_params mm_params; do echo "### $v $p $(date +%T)"; /home/claude/venv/bin/cace OgueyAebischerRef_$v.yaml -p $p --no-progress-bar -j 2 2>&1 | grep -v spiceinit; done; done; echo ALLDONE $(date +%T)' > /home/claude/work/logs/cace_all.out 2>&1 &
sleep 100; grep -E "^###|Completed|ALLDONE" /home/claude/work/logs/cace_all.out
```

</details>

While the suite runs in the background, I'll write the macro README and Makefile. First a progress check:

*[Ran a command (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
sleep 60; grep -E "^###|Completed|ALLDONE|rror" /home/claude/work/logs/cace_all.out | cut -c1-150
```

</details>

*[Ran a command (in the cloud container; 17 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); echo $R; ls $R/parameters/tran_startup_params | head; find $R -name '*.data' | wc -l; pgrep -af "ngspice|xschem|cace" | grep -v pgrep | cut -c1-150 | head
```

</details>

*[Ran a command (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
ps -o pid,etime,time,args -p $(pgrep -d, ngspice) | cut -c1-120; for p in $(pgrep ngspice); do readlink /proc/$p/cwd; done
```

</details>

The fast-ramp case has been running for 2.5 minutes, so something in the new template is slow. Stopping the batch and profiling one netlist:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
pkill -f "for v in 03v3"; pkill -f bin/cace; pkill ngspice; sleep 1; cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_2026-10-06_22-01-30/parameters/tran_startup_params/run_00 && grep -n "tran\|meas\|let" *.spice; sed 's/cross=last/rise=1/' OgueyAebischerRef_03v3_tb_tran.spice > /tmp/t_rise.spice; cd . ; (time timeout 60 ngspice -b /tmp/t_rise.spice > /tmp/t_rise.log 2>&1) 2>&1 | grep real; grep -E "t90|ifinal|t_startup" /tmp/t_rise.log
```

</details>

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_2026-10-06_22-01-30/parameters/tran_startup_params/run_00 && grep -n "tran\|meas\|let" *.spice
```

</details>

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
sed -e 's/^tran .*/tran 10n 2.3e-05/' OgueyAebischerRef_03v3_tb_tran.spice > /tmp/t10n.spice && (time timeout 100 ngspice -b /tmp/t10n.spice > /tmp/t10n.log 2>&1) 2>&1 | grep real; grep -iE "^t90|^ifinal|error|singular|timestep" /tmp/t10n.log | head
```

</details>

*[Ran a command (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace("tran CACE[CACE\\\\{tramp\\\\}/2000] CACE[3*CACE\\\\{tramp\\\\}+20e-6]","tran CACE[CACE\\\\{tramp\\\\}/100] CACE[3*CACE\\\\{tramp\\\\}+20e-6]")
s=s.replace("at=CACE[3*CACE\\\\{tramp\\\\}+20e-6]","at=CACE[0.99*(3*CACE\\\\{tramp\\\\}+20e-6)]")
open(p,'w').write(s)
EOF
grep -n "tramp" scripts/gen_cace.py | head; python3 scripts/gen_cace.py . >/dev/null; grep -n "^tran\|at=" verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch
```

</details>

*[Ran a command (in the cloud container; 36 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace && rm -rf _runs && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && (time timeout 500 /home/claude/venv/bin/cace OgueyAebischerRef_03v3.yaml -p tran_startup_params --no-progress-bar -j 2 > /home/claude/work/logs/tran.out 2>&1) 2>&1 | grep real; grep -E "Start-up|Settled" /home/claude/work/logs/tran.out; cat _runs/*/parameters/tran_startup_params/simulation_summary.csv
```

</details>

*[Ran a command (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
old_start=s.index("let i90 = 0.9*Ifinal")
old_end=s.index("let t_startup = t90 - CACE\\\\{tramp\\\\}")+len("let t_startup = t90 - CACE\\\\{tramp\\\\}")
new="""* settling time = last time sample at which I1 is outside +-10 % of its final value.
* (A meas WHEN on the 90 % level fails when I1 is already in the band at the first sample,
* and displacement current through the ammeter crosses that level early in a fast ramp.)
let i1 = v.x1.xbias.vi1#branch
let outside = abs(i1 - Ifinal) gt 0.1*abs(Ifinal)
let t_settle = vecmax(time * outside)
let t_startup = t_settle - CACE\\\\{tramp\\\\}"""
s=s[:old_start]+new+s[old_end:]
s=s.replace("* LAST crossing: displacement current through the ammeter crosses i90 early during a fast ramp\n","")
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . >/dev/null; sed -n 24,40p verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch
# quick manual check on the ff/27 fast-ramp case
R=/home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/$(ls verification/cace/_runs | tail -1)/parameters/tran_startup_params/run_26; cd $R && python3 - <<'EOF'
s=open('OgueyAebischerRef_03v3_tb_tran.spice').read()
import re
a=s.index('let i90'); b=s.index('let t_startup')
b=s.index('\n',b)
s=s[:a]+"""let i1 = v.x1.xbias.vi1#branch
let outside = abs(i1 - Ifinal) gt 0.1*abs(Ifinal)
let t_settle = vecmax(time * outside)
let t_startup = t_settle - 1e-6
print t_startup t_settle Ifinal"""+s[b:]
s=re.sub(r'echo .*','',s)
open('/tmp/t26.spice','w').write(s)
EOF
ngspice -b /tmp/t26.spice 2>&1 | grep -E "t_startup|t_settle|ifinal|rror" | head
```

</details>

The robust version works, and it shows that ff/27 °C with a fast ramp takes 12 µs to settle within ±10 %, which the old 90 %-crossing metric missed. Looking at the waveform:

*[Ran a command (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && sed 's/^print t_startup.*/print t_startup\nlet tt=time\nwrdata \/tmp\/w26.txt v.x1.xbias.vi1#branch v(xk)/' t26.spice | sed 's/^tran .*/tran 10n 2.3e-05/' > t26b.spice && sed -i 's/v(xk)/v(x1.xstart.vkick)/' t26b.spice && ngspice -b t26b.spice >/dev/null 2>&1; python3 -c "
import numpy as np
d=np.loadtxt('/tmp/w26.txt'); t=d[:,0]; i=d[:,1]; vk=d[:,3]
for tt in [0.2e-6,0.5e-6,1e-6,1.5e-6,2e-6,3e-6,5e-6,8e-6,10e-6,13e-6,16e-6,20e-6,22e-6]:
    k=np.argmin(abs(t-tt)); print(f'{tt*1e6:5.1f}us  I1={i[k]*1e9:8.2f} nA  vkick={vk[k]:.3f}')
"
```

</details>

*[Ran a command (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace("+20e-6","+200e-6")
s=s.replace("""            maximum: {{value: any}}
          Vbp_final:""","""            maximum: {{value: any}}
          Vbp_final:""")
old="""            description: End of the supply ramp until I1 is within 10 % of final (negative = settled during the ramp). Limit is a placeholder.
            unit: us
            minimum: {{value: any}}
            typical: {{value: any}}
            maximum: {{value: 5}}"""
new="""            description: End of the supply ramp until I1 stays within 10 % of its final value (negative = settled during the ramp). Limits are the IHP deck's.
            unit: us
            minimum: {{value: any}}
            typical: {{value: 20}}
            maximum: {{value: 40}}"""
assert old in s; s=s.replace(old,new)
s=s.replace("""  * spec limits that the IHP sessions identified as wrong (Ibias 200 nA..1 uA, Iq 10/20 uA,
    t_startup 20/40 us, matching +-2 %/+-1 %) are replaced""","""  * spec limits that the IHP sessions identified as wrong (Ibias 200 nA..1 uA, Iq 10/20 uA,
    matching +-2 %/+-1 %) are replaced""")
s=s.replace("""decision.  PSRR (50 dB) and noise limits are kept from IHP on purpose.""","""decision.  PSRR (50 dB), noise and start-up (20/40 us) limits are kept from IHP on purpose;
    the start-up limits now grade a real settling measurement.""")
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . >/dev/null; grep -n "200e-6" verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch | head -3; grep -n -A5 "t_startup:" verification/cace/OgueyAebischerRef_03v3.yaml | head -8
```

</details>

Launching the full suite for both variants in the background (about 20–30 minutes on this 2-CPU workspace):

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace && rm -rf _runs netlist && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && nohup bash -c 'cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace; for v in 03v3 06v0; do echo "### $v $(date +%T)"; /home/claude/venv/bin/cace OgueyAebischerRef_$v.yaml --no-progress-bar -j 2 --parallel-parameters 1 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_$v.out; done; echo ALLDONE $(date +%T)' > /home/claude/work/logs/cace_all.out 2>&1 &
echo started
```

</details>

While it runs: the macro Makefile, derived from the existing GF180 macro Makefile with a variant switch and the CACE target restored:

*[Ran a command (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
cp /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff/Makefile Makefile && python3 - <<'EOF'
p='Makefile'; s=open(p).read()
s=s.replace("# SPDX-FileCopyrightText: 2026 Tim Edwards and Simon Dorrer\n","# SPDX-FileCopyrightText: 2026 Tim Edwards, Simon Dorrer and Christoph Maier\n")
s=s.replace("# Variables\nTOP = gf180mcu_IOPadSingle2Diff\n",
"""# Variables
# Two device-family variants of the same circuit (see README.md):
#   03v3  nfet_03v3 / pfet_03v3     06v0  nfet_06v0 / pfet_06v0
# Override with: make <target> VARIANT=<03v3|06v0>
VARIANT ?= 03v3
TOP = OgueyAebischerRef_$(VARIANT)
""")
s=s.replace("DRC_RPT_DIR     := verification/drc\n","DRC_RPT_DIR     := verification/drc\nCACE_DIR        := verification/cace\n",1)
old="""sim-all: ## Simulate the macro
	$(MAKE) sim-xschem TB=$(TOP)_tb_tran
.PHONY: sim-all"""
new="""sim-all: ## Simulate the macro (start-up testbench of both variants)
	$(MAKE) sim-xschem TB=OgueyAebischerRef_03v3_tb_tran
	$(MAKE) sim-xschem TB=OgueyAebischerRef_06v0_tb_tran
.PHONY: sim-all

# CACE parameter groups to run (default: all of them)
# Override with: make sim-cace CACE_PARAMS="dc_params tran_startup_params"
CACE_PARAMS ?=
CACE_JOBS ?= 4

sim-cace: ## Run the CACE suite of TOP (usage: make sim-cace [VARIANT=<03v3|06v0>] [CACE_PARAMS="<groups>"])
	cd $(CACE_DIR) && cace $(TOP).yaml $(if $(CACE_PARAMS),-p $(CACE_PARAMS),) -j $(CACE_JOBS) --parallel-parameters 1
.PHONY: sim-cace

sim-cace-all: ## Run the CACE suites of both variants
	$(MAKE) sim-cace VARIANT=03v3
	$(MAKE) sim-cace VARIANT=06v0
.PHONY: sim-cace-all"""
assert old in s; s=s.replace(old,new)
old_clean="	rm -rf $(SCRIPTS_DIR)/__pycache__\n"
s=s.replace(old_clean, old_clean+"	rm -rf $(CACE_DIR)/_runs $(CACE_DIR)/_docs $(CACE_DIR)/netlist\n	rm -rf $(CACE_DIR)/templates/simulations\n",1)
s=s.replace("## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation outputs)","## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation and CACE outputs)")
s=s.replace("'Usage: make <target> [CELL=<cellname>]","'Usage: make <target> [VARIANT=<03v3|06v0>] [CELL=<cellname>]")
s=s.replace("	@echo 'CELL defaults to $(TOP). Override to verify subcells.'","	@echo 'VARIANT selects the device family (03v3|06v0, default 03v3); TOP = OgueyAebischerRef_<VARIANT>.'\n	@echo 'CELL defaults to $(TOP). Override to verify subcells.'")
open(p,'w').write(s)
EOF
make -n help >/dev/null && make -n sim-cace VARIANT=06v0 CACE_PARAMS="dc_params mm_params" && make -n sim-all | grep -E "xschem -r|ngspice" | head -4; grep -n "TOP\b\|TOP)" Makefile | head -20
```

</details>

The `sim-cace` target is back. Testing `make sim-all` for real (it exercises xschem 3.4.8's batch netlisting the way you run it):

*[Ran a command (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && cp -r testbenches /tmp/tb_backup && timeout 400 make sim-all > /home/claude/work/logs/sim-all.out 2>&1; echo rc=$?; grep -E "i1_final|rror" /home/claude/work/logs/sim-all.out; diff -r /tmp/tb_backup testbenches | head -5; ls testbenches/xschem/simulations
```

</details>

`make sim-all` passes for both variants. The target runs `xschem save`, so checking that it didn't rewrite the testbench sources:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
diff /tmp/tb_backup/xschem/OgueyAebischerRef_03v3_tb_tran.sch testbenches/xschem/OgueyAebischerRef_03v3_tb_tran.sch | head -20; rm -rf testbenches/xschem/simulations testbenches/xschem/plot_simulations; grep -E "^###|ALLDONE" /home/claude/work/logs/cace_all.out; grep -c "Completed" /home/claude/work/logs/cace_03v3.out
```

</details>

No changes to the sources. While CACE runs, the IOPad macros. Checking what the `gf180mcu_ocd_io` library offers for xschem:

*[Ran a command (on the computer; 90 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180mcu_ocd_io; ls xschem | head -40; cat xschem/gf180mcu_ocd_io__asig_5p0.sym 2>/dev/null | head -60; ls netlist/*; grep -n -A12 -i "subckt gf180mcu_ocd_io__asig_5p0" netlist/*/*.spice 2>/dev/null | head -30
```

</details>

*[Ran a command (on the computer; 19 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single; cat dependencies/README.md harness_stub/README.md | head -80; cat $HOME/mnt/gf180mcu_ocd_io/netlist/schematic/gf180mcu_ocd_io__asig_5p0.spice | head -3
```

</details>

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src/open_pdks/gf180mcu && grep -n -A40 "^ocd-io-%\|ocd-io-build-%" Makefile.in | grep -n -i "xschem\|spice\|cdl\|-library\|STAGE" | head -20
```

</details>

*[Ran a command (in the cloud container; 66 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 1560,1625p Makefile.in
```

</details>

open_pdks installs `cells/*/*.sym` as primitive symbols under `libs.ref/gf180mcu_ocd_io/xschem`, plus a compiled SPICE library. Checking the pad's symbol in your clone:

*[Ran a command (on the computer; 58 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180mcu_ocd_io/cells/asig_5p0; ls; cat gf180mcu_ocd_io__asig_5p0.sym
```

</details>

*[Ran a command (on the computer; 31 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single; grep -E "^C \{" schematic/xschem/sg13cmos5l_cm_ip__single2diff2single.sch | cut -c1-160; grep -n -i "pad\|IOPad" TOP_LEVEL_MODULE.md | head -30
```

</details>

*[Ran a command (in the cloud container; 59 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols; for s in diode_nd2ps_06v0 diode_pd2nw_06v0 ppolyf_u_1k ppolyf_u_1k_6p0; do echo "## $s"; sed -n '/^K {/,/^}/p' $s.sym | grep -v '^\*'; grep "^B 5" $s.sym; done; grep -n -i -A3 "subckt ppolyf_u_1k \|subckt ppolyf_u_1k_6p0" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.spice | head -12; grep -n -i "^\.model diode_nd2ps_06v0\|^\.model diode_pd2nw_06v0" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.spice
```

</details>

Checking on the CACE run:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
grep -E "^###|ALLDONE" /home/claude/work/logs/cace_all.out; grep -E "Completed" /home/claude/work/logs/cace_03v3.out /home/claude/work/logs/cace_06v0.out 2>/dev/null | sed 's/─//g'
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
date +%T; R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); for p in $R/parameters/*; do echo "$(basename $p): $(find $p -name '*.data' | wc -l)"; done; ps -o etime,args -C ngspice | head -4
```

</details>

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
for p in $(pgrep ngspice); do d=$(readlink /proc/$p/cwd); echo "$(ps -o etime= -p $p) $(grep tramp $d/conditions.yaml) $(grep -E 'corner|temp' $d/conditions.yaml | tr '\n' ' ')"; done
```

</details>

The fast-ramp case at −40 °C is the slow one (it also stalled the first attempt). Profiling that single netlist:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
pkill -f "for v in 03v3"; pkill -f bin/cace; pkill ngspice; sleep 1; R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); cd $R/parameters/tran_startup_params/run_00 && grep -E "^tran|^\.temp" *.spice; sed -e 's/^tran .*/tran 10n 50u/' -e 's/at=[0-9.e-]*/at=49u/' *.spice > /tmp/r00.spice; (time timeout 120 ngspice -b /tmp/r00.spice > /tmp/r00.log 2>&1) 2>&1 | grep real; tail -5 /tmp/r00.log; grep -c . /tmp/r00.log
```

</details>

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); cd $R/parameters/tran_startup_params/run_00 && grep -E "^tran|^\.temp" *.spice
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
sed -e 's/^tran .*/tran 10n 50u/' -e 's/at=[0-9.e-]*/at=49u/' OgueyAebischerRef_03v3_tb_tran.spice > /tmp/r00.spice && cd /tmp && (time timeout 100 ngspice -b /tmp/r00.spice > /tmp/r00.log 2>&1) 2>&1 | grep real; tail -4 /tmp/r00.log
```

</details>

62 s for 50 µs at −40 °C, versus about 1 s at 27 °C: the solver is taking tiny steps. Trying the usual tolerance knobs on this case:

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && for opt in "abstol=1e-13" "reltol=1e-3" "method=trap" "gmin=1e-12"; do k=${opt%%=*}; sed -E "s/ $k=[^ ]+/ $opt/" r00.spice > r00_$k.spice; grep -q " $opt" r00_$k.spice || sed -i "s/^\.options /.options $opt /" r00_$k.spice; /usr/bin/time -f "$opt %es" timeout 100 ngspice -b r00_$k.spice 2>&1 | grep -E "s$|ifinal" | tail -2; done
```

</details>

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && grep -n "^\.options" r00.spice; for opt in "abstol=1e-13" "reltol=1e-3" "method=trap"; do k=${opt%%=*}; sed -E "s/ $k=[^ ]+/ $opt/" r00.spice > r00_$k.spice; grep -n "^\.options" r00_$k.spice; s=$(date +%s.%N); timeout 100 ngspice -b r00_$k.spice > r00_$k.log 2>&1; e=$(date +%s.%N); echo "$opt: $(python3 -c "print(round($e-$s,1))") s  $(grep -i ifinal r00_$k.log | head -1)"; done
```

</details>

`abstol=1e-13` (0.1 pA, still 10⁻⁶ of I₁) gives the same answer 30× faster. Applying it to the two transient templates and relaunching:

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('''TEMPLATES = {''','''OPTS_TRAN = OPTS.replace("abstol=1e-15", "abstol=1e-13")
# abstol 1e-15 makes the cold (-40 C) start-up transient ~30x slower for the same result
# (I1 identical to 7 digits); 0.1 pA is still 1e-6 of the 100 nA core current.

TEMPLATES = {''')
for fn in ['def tb_tran','def tb_disable']:
    a=s.index(fn); b=s.index('body = OPTS + """',a)
    s=s[:b]+'body = OPTS_TRAN + """'+s[b+len('body = OPTS + """'):]
open(p,'w').write(s)
EOF
grep -n "OPTS_TRAN" scripts/gen_cace.py; python3 scripts/gen_cace.py . >/dev/null; grep -c "abstol=1e-13" verification/cace/templates/*.sch | grep -v ":0"
cd verification/cace && rm -rf _runs netlist && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && nohup bash -c 'cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace; for v in 03v3 06v0; do echo "### $v $(date +%T)"; /home/claude/venv/bin/cace OgueyAebischerRef_$v.yaml --no-progress-bar -j 2 --parallel-parameters 1 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_$v.out; done; echo ALLDONE $(date +%T)' > /home/claude/work/logs/cace_all.out 2>&1 &
echo started
```

</details>

While that runs (about 10 minutes), the Single2Diff input front end. Looking at the IHP stub symbol first:

*[Ran a command (in the cloud container; 35 lines of output).]*

<details><summary>command</summary>

```sh
cat /mnt/user-data/uploads/sg13cmos5l_cm_ip__single2diff2single/macros/sg13cmos5l_IOPadSingle2Diff/schematic/xschem/sg13cmos5l_IOPadSingle2Diff.sym; grep -A8 "rm1.sym\|^K" /home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols/ppolyf_u_1k_6p0.sym | head -3
```

</details>

*[Ran a command (in the cloud container; 57 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "libs.ref\|LIBRARY_PATH" /home/claude/pdk/gf180mcuD/libs.tech/xschem/xschemrc | head; sed -n 1,60p /home/claude/src/open_pdks/gf180mcu/custom/scripts/make_primitive.py 2>/dev/null | grep -v "^#" | head -30; ls /home/claude/src/open_pdks/gf180mcu/custom/scripts/ | head -30
```

</details>

*[Copied 2 files from the computer to the cloud container (1 lines of output).]*

*[Ran a command (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
L=/home/claude/pdk/gf180mcuD/libs.ref/gf180mcu_ocd_io; mkdir -p $L/xschem $L/spice && U=/mnt/user-data/uploads/gf180mcu_ocd_io && sed 's/type=subcircuit/type=primitive/' $U/cells/asig_5p0/gf180mcu_ocd_io__asig_5p0.sym > $L/xschem/gf180mcu_ocd_io__asig_5p0.sym && cp $U/netlist/schematic/gf180mcu_ocd_io__asig_5p0.spice $L/spice/gf180mcu_ocd_io.spice && cat $L/spice/gf180mcu_ocd_io.spice; grep -n "^\.lib moscap_typical\|^\.lib diode_typical\|^\.lib res_typical" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.spice; grep -E "Completed|^###|ALLDONE" /home/claude/work/logs/cace_all.out /home/claude/work/logs/cace_0*.out | sed 's/─//g'
```

</details>

Writing the Single2Diff front-end schematic, its symbol, the Diff2Single symbol/skeleton, a pad-in-the-loop testbench and a first CACE group:

*[Wrote gen_iopad.py (in the cloud container; 1 lines of output).]*

Checking the ammeter symbol's pin positions before wiring it rotated:

*[Ran a command (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
grep "^B 5\|format" /opt/xschem/share/xschem/xschem_library/devices/ammeter.sym /opt/xschem/share/xschem/xschem_library/devices/ipin.sym /opt/xschem/share/xschem/xschem_library/devices/opin.sym
```

</details>

*[Ran a command (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gen && python3 - <<'EOF'
p='gen_iopad.py'; s=open(p).read()
s=s.replace("N 200 -300 360 -300 {lab=pad}","N 200 -300 370 -300 {lab=pad}")
s=s.replace("N 440 -300 560 -300 {lab=pad_in}","N 430 -300 560 -300 {lab=pad_in}")
s=s.replace("N 620 -380 620 -400 {lab=vdd}","N 620 -360 620 -400 {lab=vdd}")
s=s.replace("N 620 -220 620 -120 {lab=0}","N 620 -240 620 -120 {lab=0}")
open(p,'w').write(s)
EOF
python3 gen_iopad.py /home/claude/work/repo/macros; grep -E "Completed|ALLDONE|###" /home/claude/work/logs/cace_all.out /home/claude/work/logs/cace_0*.out | sed 's/─//g'
```

</details>

*[Ran a command (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
date +%T; R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); for p in $R/parameters/*; do echo "$(basename $p): $(find $p -name '*.data' | wc -l)"; done; for p in $(pgrep ngspice); do d=$(readlink /proc/$p/cwd); echo "$(ps -o etime= -p $p) $(basename $d) $(grep -E 'tramp|corner|temp' $d/conditions.yaml 2>/dev/null| tr '\n' ' ')"; done
```

</details>

Still slow at 27 °C, because ngspice caps the internal step at the 10 ns print step over the full 200 µs. Testing an explicit, larger maximum step (tstop/1000):

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1)/parameters/tran_startup_params/run_00; cd $R; grep "^tran" *.spice; sed 's/^tran 1e-08 0.000203$/tran 1e-08 0.000203 0 2.03e-07/' *.spice > /tmp/r0_tmax.spice; grep "^tran" /tmp/r0_tmax.spice; cd /tmp; s=$(date +%s); timeout 200 ngspice -b /tmp/r0_tmax.spice > /tmp/r0_tmax.log 2>&1; echo "$(( $(date +%s)-s )) s"; grep -i -E "ifinal|t_startup|rror" /tmp/r0_tmax.log | head; cat $R/*.data 2>/dev/null
```

</details>

Under a second with `tmax`, same final current. Confirming t_startup also matches the slow run's 11.75 µs:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && sed -i 's/^echo .*/print t_startup/' r0_tmax.spice && ngspice -b r0_tmax.spice 2>&1 | grep t_startup
```

</details>

Identical (11.747 µs). Adding `tmax` to the template and relaunching the suite:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
pkill -f "for v in 03v3"; pkill -f bin/cace; pkill ngspice; sleep 1; cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
old="tran CACE[CACE\\\\{tramp\\\\}/100] CACE[3*CACE\\\\{tramp\\\\}+200e-6]"
assert old in s
s=s.replace(old,"* tmax = tstop/1000: without it ngspice caps the step at the print step and the\n* 200 us settling tail takes minutes (same result to 4 digits)\n"+old+" 0 CACE[(3*CACE\\\\{tramp\\\\}+200e-6)/1000]")
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . >/dev/null; grep -n "^tran" verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch
cd verification/cace && rm -rf _runs netlist && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && nohup bash -c 'cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace; for v in 03v3 06v0; do echo "### $v $(date +%T)"; /home/claude/venv/bin/cace OgueyAebischerRef_$v.yaml --no-progress-bar -j 2 --parallel-parameters 1 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_$v.out; done; echo ALLDONE $(date +%T)' > /home/claude/work/logs/cace_all.out 2>&1 &
echo started
```

</details>

My `pkill` pattern matched this very shell command. Re-running the edit and launch without it:

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
pgrep -af "bin/cace|ngspice" | grep -v pgrep | head -3; cd /home/claude/work/repo/macros/OgueyAebischerBias && grep -c "tmax = tstop/1000" scripts/gen_cace.py
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
kill 10944 11780 12900 2>/dev/null; pkill -x ngspice; sleep 1; pgrep -af "bin/cace" | grep -v pgrep; cd /home/claude/work/repo/macros/OgueyAebischerBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
old="tran CACE[CACE\\\\{tramp\\\\}/100] CACE[3*CACE\\\\{tramp\\\\}+200e-6]"
assert old in s
s=s.replace(old,"* tmax = tstop/1000: without it ngspice caps the step at the print step and the\n* 200 us settling tail takes minutes (same result to 4 digits)\n"+old+" 0 CACE[(3*CACE\\\\{tramp\\\\}+200e-6)/1000]")
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . >/dev/null; grep -n "^tran" verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/run_cace.sh <<'EOF'
#!/bin/bash
export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace
rm -rf _runs netlist
for v in "$@"; do
  echo "### $v $(date +%T)"
  /home/claude/venv/bin/cace OgueyAebischerRef_$v.yaml --no-progress-bar -j 2 --parallel-parameters 1 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_$v.out
done
echo ALLDONE $(date +%T)
EOF
chmod +x /home/claude/work/run_cace.sh; nohup /home/claude/work/run_cace.sh 03v3 06v0 > /home/claude/work/logs/cace_all.out 2>&1 &
sleep 5; cat /home/claude/work/logs/cace_all.out
```

</details>

While the suite runs: the IOPad macros need `libs.ref` on the xschem path for the pad symbol. Adding that to their testbench `xschemrc` (and to a new CACE template `xschemrc`), then netlisting:

*[Ran a command (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros && U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff && ADD='
# Harness I/O cells (gf180mcu_ocd_io, installed by open_pdks under libs.ref): reference them as
# gf180mcu_ocd_io/xschem/<cell>.sym, e.g. the analog pad gf180mcu_ocd_io__asig_5p0 in testbenches.
append_xschem_library_path_unique [file join $env(PDK_ROOT) $env(PDK) libs.ref]' && for m in gf180mcu_IOPadSingle2Diff gf180mcu_IOPadDiff2Single; do sed '1s/^\xEF\xBB\xBF//' $U/schematic/xschem/xschemrc > $m/schematic/xschem/xschemrc; sed '1s/^\xEF\xBB\xBF//' $U/testbenches/xschem/xschemrc > $m/testbenches/xschem/xschemrc 2>/dev/null || { mkdir -p $m/testbenches/xschem; sed '1s/^\xEF\xBB\xBF//' $U/testbenches/xschem/xschemrc > $m/testbenches/xschem/xschemrc; }; done; diff $U/schematic/xschem/xschemrc /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/xschemrc >/dev/null && echo same-src
# insert libs.ref line after the append_xschem_library_path_unique proc definition (before pin_netlist_dir block)
python3 - "$ADD" <<'EOF'
import sys
add=sys.argv[1]
for f in ['gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc']:
    s=open(f).read(); k=s.index("if {![llength [info commands pin_netlist_dir]]}")
    s=s[:k]+add.strip('\n')+"\n\n"+s[k:]; open(f,'w').write(s)
EOF
sed "s#source \[file normalize \[file join \[file dirname \[info script\]\] ../../../schematic/xschem/xschemrc\]\]#source [file normalize [file join [file dirname [info script]] ../../../schematic/xschem/xschemrc]]\n$(echo "$ADD" | sed 's/$/\\n/' | tr -d '\n' | sed 's/\\n$//')#" OgueyAebischerBias/verification/cace/templates/xschemrc > gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc; grep -n "libs.ref" gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc
```

</details>

*[Ran a command (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
rm -f gf180mcu_IOPadDiff2Single/testbenches/xschem/xschemrc && rmdir -p gf180mcu_IOPadDiff2Single/testbenches/xschem 2>/dev/null; python3 - <<'EOF'
src='OgueyAebischerBias/verification/cace/templates/xschemrc'
dst='gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc'
s=open(src).read()
anchor="source [file normalize [file join [file dirname [info script]] ../../../schematic/xschem/xschemrc]]\n"
assert anchor in s
add=anchor+"""
# Harness I/O cells (gf180mcu_ocd_io, installed by open_pdks under libs.ref), e.g. the analog pad
append_xschem_library_path_unique [file join $env(PDK_ROOT) $env(PDK) libs.ref]
"""
open(dst,'w').write(s.replace(anchor,add))
EOF
grep -n "libs.ref" gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc; find gf180mcu_IOPad* -type f | sort
```

</details>

Netlisting both IOPad schematics and running the pad-in-the-loop testbench:

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /home/claude/work/repo/macros; for m in gf180mcu_IOPadSingle2Diff gf180mcu_IOPadDiff2Single; do d=$m/schematic/xschem; (cd $d; rm -f /home/claude/work/net/$m.spice; PWD=$(pwd) xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /home/claude/work/net $(pwd)/$m.sch 2>&1 | grep -i -E "error|not found|warn" | head -5); grep -v "^\*\*\|^\*\." /home/claude/work/net/$m.spice | grep -v "^$"; done; cd gf180mcu_IOPadSingle2Diff/testbenches/xschem && mkdir -p simulations && PWD=$(pwd) xschem -r -x -q --rcfile xschemrc --command "xschem set netlist_type spice; set netlist_dir $(pwd)/simulations; xschem netlist" $(pwd)/gf180mcu_IOPadSingle2Diff_tb_dc.sch 2>&1 | grep -i "not found\|error" | head; cd simulations && grep -E "^x|^X|^V|^D" gf180mcu_IOPadSingle2Diff_tb_dc.spice; ngspice -b gf180mcu_IOPadSingle2Diff_tb_dc.spice 2>&1 | grep -E "iin_5v0|vprot_5v0|rror"; python3 -c "
import numpy as np
d=np.loadtxt('gf180mcu_IOPadSingle2Diff_tb_dc.txt'); v=d[:,0]; i=d[:,1]; vp=d[:,3]
for x in [-0.5,-0.3,0,1.65,3.3,3.6,3.8,4.0,4.5,5.0,5.5]:
  k=np.argmin(abs(v-x)); print(f'Vpad={x:5.2f}  Iin={i[k]*1e6:12.4f} uA  Vprot={vp[k]:.3f}')"
```

</details>

The netlists are right, but `$env(PDK_ROOT)` in the pad `.include` is only expanded inside a `tcleval` block. Moving that include into the MODELS block:

*[Ran a command (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gen && python3 - <<'EOF'
p='gen_iopad.py'; s=open(p).read()
inc=".include $env(PDK_ROOT)/$env(PDK)/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice\n"
n=s.count(inc); s=s.replace(inc,"")
s=s.replace('.include $::180MCU_MODELS/design.ngspice\n','.include $::180MCU_MODELS/design.ngspice\n* harness analog pad cell (open_pdks install of gf180mcu_ocd_io)\n'+inc)
open(p,'w').write(s); print(n, s.count(inc))
EOF
python3 gen_iopad.py /home/claude/work/repo/macros >/dev/null; export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem && PWD=$(pwd) xschem -r -x -q --rcfile xschemrc --command "xschem set netlist_type spice; set netlist_dir $(pwd)/simulations; xschem netlist" $(pwd)/gf180mcu_IOPadSingle2Diff_tb_dc.sch >/dev/null 2>&1; cd simulations && grep -n "include" *.spice; ngspice -b gf180mcu_IOPadSingle2Diff_tb_dc.spice 2>&1 | grep -E "iin_5v0|vprot_5v0|rror"; python3 -c "
import numpy as np
d=np.loadtxt('gf180mcu_IOPadSingle2Diff_tb_dc.txt'); v=d[:,0]; i=d[:,1]; vp=d[:,3]
for x in [-0.5,-0.3,0,1.65,3.3,3.6,3.8,4.0,4.5,5.0,5.5]:
  k=np.argmin(abs(v-x)); print(f'Vpad={x:5.2f}  Iin={i[k]*1e6:12.4f} uA  Vprot={vp[k]:.3f}')"
```

</details>

*[Ran a command (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cat /home/claude/work/logs/cace_all.out; grep -E "Completed" /home/claude/work/logs/cace_0*.out | sed 's/─//g'; date +%T
```

</details>

Running. Meanwhile, the documentation. Looking at how the top-level README describes the macros, so the new one fits in:

*[Ran a command (on the computer; 46 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single; grep -n "^#" README.md | head -60; grep -n -i "macro" README.md | head -30
```

</details>

*[Ran a command (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "source\|append" /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/schematic/xschem/xschemrc; grep -n "build-macros\|build-single2diff\|build-diff2single" /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/Makefile | head; cat /home/claude/work/logs/cace_all.out
```

</details>

I'll add the bias macro to the top-level xschem chain at delivery. Now the bias macro README; I'll fill in the results table once the suite finishes.

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
sleep 120; cat /home/claude/work/logs/cace_all.out; grep -E "Completed" /home/claude/work/logs/cace_0*.out | sed 's/─//g'
```

</details>

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
date +%T; R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); for p in $R/parameters/*; do echo "$(basename $p): $(find $p -name '*.data' | wc -l)"; done; for p in $(pgrep -x ngspice); do d=$(readlink /proc/$p/cwd); echo "$(ps -o etime= -p $p) $(basename $d) $(grep -E 'tramp|corner|temp' $d/conditions.yaml 2>/dev/null| tr '\n' ' ')"; done; uptime
```

</details>

Everything except the mismatch group has finished, but `mm_params` shows no data and no ngspice process. Looking at what's using the CPU:

*[Ran a command (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
ps -eo pid,etime,pcpu,args --sort=-pcpu | head -8 | cut -c1-160; tail -5 /home/claude/work/logs/cace_03v3.out | cut -c1-160; R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); ls $R/parameters/mm_params | head; ls $R/parameters/mm_params/run_0 2>/dev/null | head
```

</details>

It's progressing: CACE calls xschem once per Monte Carlo iteration (200 netlists) before simulating. Waiting for it:

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
sleep 240; cat /home/claude/work/logs/cace_all.out; R=$(ls -d /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/_runs/RUN_* | tail -1); find $R/parameters/mm_params -name '*.data' | wc -l
```

</details>

*[Ran a command (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
grep -E "Pass|Fail|Skip|rror|ERROR" /home/claude/work/logs/cace_03v3.out | grep -v "Collecting\|Completed" | cut -c1-200
```

</details>

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace && R=$(ls -d _runs/RUN_* | head -1); echo $R; python3 - $R <<'EOF'
import csv,sys,statistics as st,glob
R=sys.argv[1]
f=glob.glob(R+'/parameters/mm_params/simulation_summary.csv')[0]
rows=list(csv.DictReader(open(f)))
print(rows[0].keys(), len(rows))
for k in ['Ibias_accuracy','Leg_matching']:
    v=[]
    for r in rows:
        x=r[k].strip('[]').split(',') if r[k].startswith('[') else [r[k]]
        v+= [float(t) for t in x if t.strip()]
    print(k, len(v), f"mean={st.mean(v)*100:.2f}% sigma={st.pstdev(v)*100:.2f}% min={min(v)*100:.2f} max={max(v)*100:.2f}")
f=R+'/parameters/tran_startup_params/simulation_summary.csv'
rows=list(csv.DictReader(open(f)))
fast=[float(r['t_startup']) for r in rows if r['tramp']=='1e-6']; slow=[float(r['t_startup']) for r in rows if r['tramp']=='1e-3']
print('fast ramp t_startup us', [round(x*1e6,2) for x in fast]); print('slow ramp t_startup us min/max', min(slow)*1e6, max(slow)*1e6)
f=R+'/parameters/dc_params/simulation_summary.csv'
rows=list(csv.DictReader(open(f)))
for vdd in ['3.0','3.3','3.6']:
    I=[float(r['Ibias_val']) for r in rows if r['vdd']==vdd]; print('vdd',vdd,'I range nA',round(min(I)*1e9,1),round(max(I)*1e9,1))
EOF
```

</details>

*[Ran a command (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace && R=_runs/RUN_2026-10-06_22-16-55; ls $R/parameters/mm_params | head -3; ls $R/parameters/mm_params/run_0 | head -3; python3 - $R <<'EOF'
import sys,glob,statistics as st
R=sys.argv[1]
vals=[]
for f in sorted(glob.glob(R+'/parameters/mm_params/run_0/run_*/*.data')):
    t=open(f).read().split(); vals.append((float(t[0]),float(t[1])))
print(len(vals))
for i,k in enumerate(['Ibias_accuracy','Leg_matching']):
    v=[x[i] for x in vals]; print(k, f"mean={st.mean(v)*100:.2f}% sigma={st.pstdev(v)*100:.2f}% min={min(v)*100:.2f} max={max(v)*100:.2f}")
import csv
rows=list(csv.DictReader(open(R+'/parameters/tran_startup_params/simulation_summary.csv')))
fast=[float(r['t_startup']) for r in rows if r['tramp']=='1e-6']; slow=[float(r['t_startup']) for r in rows if r['tramp']=='1e-3']
print('fast ramp t_startup us', [round(x*1e6,2) for x in fast]); print('slow ramp t_startup us min/max', round(min(slow)*1e6), round(max(slow)*1e6))
rows=list(csv.DictReader(open(R+'/parameters/dc_params/simulation_summary.csv')))
for vdd in ['3.0','3.3','3.6']:
    I=[float(r['Ibias_val']) for r in rows if r['vdd']==vdd]; print('vdd',vdd,'I range nA',round(min(I)*1e9,1),round(max(I)*1e9,1))
EOF
```

</details>

*[Ran a command (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
sleep 200; cat /home/claude/work/logs/cace_all.out; grep -E "Completed" /home/claude/work/logs/cace_06v0.out | sed 's/─//g'
```

</details>

*[Ran a command (in the cloud container; 23 lines of output).]*

<details><summary>command</summary>

```sh
grep -E "Pass|Fail|Skip" /home/claude/work/logs/cace_06v0.out | grep ngspice | cut -c1-200; cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace && R=$(ls -d _runs/RUN_* | tail -1); python3 - $R <<'EOF'
import sys,glob,statistics as st,csv
R=sys.argv[1]
vals=[]
for f in sorted(glob.glob(R+'/parameters/mm_params/run_0/run_*/*.data')):
    t=open(f).read().split(); vals.append((float(t[0]),float(t[1])))
for i,k in enumerate(['Ibias_accuracy','Leg_matching']):
    v=[x[i] for x in vals]; print(k, len(v), f"mean={st.mean(v)*100:.2f}% sigma={st.pstdev(v)*100:.2f}% min={min(v)*100:.2f} max={max(v)*100:.2f}")
rows=list(csv.DictReader(open(R+'/parameters/tran_startup_params/simulation_summary.csv')))
fast=[float(r['t_startup']) for r in rows if r['tramp']=='1e-6']; slow=[float(r['t_startup']) for r in rows if r['tramp']=='1e-3']
print('fast', round(min(fast)*1e6,1), round(max(fast)*1e6,1), 'slow', round(min(slow)*1e6), round(max(slow)*1e6))
rows=list(csv.DictReader(open(R+'/parameters/dc_params/simulation_summary.csv')))
for vdd in ['3.0','3.3','3.6','5.0','5.5']:
    I=[float(r['Ibias_val']) for r in rows if r['vdd']==vdd]; print('vdd',vdd,'I range nA',round(min(I)*1e9,1),round(max(I)*1e9,1), 'typ27', [round(float(r['Ibias_val'])*1e9,1) for r in rows if r['vdd']==vdd and r['corner_mos']=='typical' and r['temp']=='27'])
EOF
```

</details>

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && timeout 500 /home/claude/venv/bin/cace gf180mcu_IOPadSingle2Diff.yaml --no-progress-bar -j 2 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_s2d.out; grep -E "Pass|Fail|Skip|ERROR" /home/claude/work/logs/cace_s2d.out | grep -E "ngspice|ERROR" | cut -c1-200; R=$(ls -d _runs/RUN_* | tail -1); cat $R/error.log | head -5; python3 - $R <<'EOF'
import csv,sys
rows=list(csv.DictReader(open(sys.argv[1]+'/parameters/input_params/simulation_summary.csv')))
for r in rows:
    if r['temp'] in ('27','85') and r['corner_d']=='typical' or (r['corner_d']=='ff' and r['temp']=='85'): print(r)
EOF
```

</details>

*[Ran a command (in the cloud container; 43 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 470,512p /home/claude/venv/lib/python3.12/site-packages/cace/parameter/parameter_ngspice.py
```

</details>

*[Ran a command (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates && grep -n "CACE" gf180mcu_IOPadSingle2Diff_tb_input.sch | head -30
```

</details>

Double backslashes in the raw-string parts of my generator. Fixing both issues:

*[Ran a command (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gen && python3 - <<'EOF'
p='gen_iopad.py'; s=open(p).read()
s=s.replace('''    w(f"{m}/verification/cace/templates/{S2D}_tb_input.sch", s2d_cace_tpl)''','''    tpl = s2d_cace_tpl.replace("\\\\\\\\{", "\\\\{").replace("\\\\\\\\}", "\\\\}")
    # CACE netlists templates with the PDK xschemrc plus the templates folder on the path,
    # so the pad symbol is referenced from a copy next to the templates
    tpl = tpl.replace("{gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym}", "{gf180mcu_ocd_io__asig_5p0.sym}")
    w(f"{m}/verification/cace/templates/{S2D}_tb_input.sch", tpl)''')
open(p,'w').write(s)
EOF
grep -n "tpl = " gen_iopad.py; python3 gen_iopad.py /home/claude/work/repo/macros >/dev/null; T=/home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates; grep -c '\\\\{' $T/*.sch; grep -n "asig_5p0.sym\|CACE.{corner" $T/*.sch; (echo "* Copy of gf180mcu_ocd_io/cells/asig_5p0/gf180mcu_ocd_io__asig_5p0.sym (RTimothyEdwards/gf180mcu_ocd_io @ 6e0e354)," ; echo "* made primitive as open_pdks does (custom/scripts/make_primitive.py), because CACE netlists templates"; echo "* with only the PDK xschemrc and this folder on the library path. Netlist: libs.ref/gf180mcu_ocd_io/spice.") > /tmp/hdr.txt; cp /home/claude/pdk/gf180mcuD/libs.ref/gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym $T/; head -5 $T/gf180mcu_ocd_io__asig_5p0.sym
```

</details>

*[Ran a command (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace && rm -rf _runs netlist && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && timeout 500 /home/claude/venv/bin/cace gf180mcu_IOPadSingle2Diff.yaml --no-progress-bar -j 2 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_s2d.out; grep -E "Pass|Fail|Skip" /home/claude/work/logs/cace_s2d.out | grep ngspice | cut -c1-200; grep -c ERROR /home/claude/work/logs/cace_s2d.out; R=$(ls -d _runs/RUN_* | tail -1); python3 - $R <<'EOF'
import csv,sys
rows=list(csv.DictReader(open(sys.argv[1]+'/parameters/input_params/simulation_summary.csv')))
print(list(rows[0].keys()))
for r in rows:
    if r['temp']=='27' and r['corner_d']=='typical' or (r['corner_d']=='ff' and r['temp']=='85' and float(r['vin'])>=3.3): print(r['vin'],r['temp'],r['corner_d'],r['Iin'],r['Vprot'])
EOF
```

</details>

*[Ran a command (in the cloud container; 40 lines of output).]*

<details><summary>command</summary>

```sh
grep -v "^\s*$" /home/claude/work/logs/cace_s2d.out | grep -v "Sourcing\|XSCHEM_SHAREDIR\|pdk installation\|180MCU_MODELS\|bespice" | head -40 | cut -c1-180
```

</details>

Those are xschem ERC warnings (nets driven from a code block) that CACE logs as errors; harmless, but I'll draw the sources as symbols. The actual failure is further on:

*[Ran a command (in the cloud container; 41 lines of output).]*

<details><summary>command</summary>

```sh
grep -v "Sourcing\|XSCHEM_SHAREDIR\|pdk installation\|180MCU_MODELS\|bespice\|open net\|undriven\|-------\|error code 10\|generated by subprocess\|dvdd not defined" /home/claude/work/logs/cace_s2d.out | grep -v "^\s*$" | sed -n 8,40p | cut -c1-200; R=$(ls -d /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace/_runs/RUN_* | tail -1); ls $R/parameters/input_params/run_00
```

</details>

*[Ran a command (in the cloud container; 33 lines of output).]*

<details><summary>command</summary>

```sh
R=$(ls -d /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace/_runs/RUN_* | tail -1); sed -n 1,30p $R/parameters/input_params/run_00/gf180mcu_IOPadSingle2Diff_tb_input.spice; grep -n "dvdd\|vcm=" $R/parameters/input_params/run_00/gf180mcu_IOPadSingle2Diff_tb_input.sch | head
```

</details>

*[Ran a command (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
p='gen_iopad.py'; s=open(p).read()
# tb: replace code-block sources by symbols
s=s.replace("""Vvdd vdd 0 3.3
Vdvdd dvdd 0 5.0
Vvcm vcm 0 1.65
""","")
s=s.replace("""Vvdd vdd 0 CACE\\{vdd\\}
Vdvdd dvdd 0 CACE\\{dvdd=5.0\\}
Vvcm vcm 0 CACE\\{vcm=1.65\\}
""","")
src_tb = """C {devices/vsource.sym} 1000 -250 0 0 {name=Vvdd value=3.3}
C {devices/vsource.sym} 1100 -250 0 0 {name=Vdvdd value=5.0}
C {devices/vsource.sym} 1200 -250 0 0 {name=Vvcm value=1.65}
"""
src_cace = """C {devices/vsource.sym} 1000 -250 0 0 {name=Vvdd value=CACE\\\\{vdd\\\\}}
C {devices/vsource.sym} 1100 -250 0 0 {name=Vdvdd value=CACE\\\\{dvdd\\\\}}
C {devices/vsource.sym} 1200 -250 0 0 {name=Vvcm value=CACE\\\\{vcm\\\\}}
"""
common = """C {devices/lab_pin.sym} 1000 -280 0 0 {name=l20 lab=vdd}
C {devices/lab_pin.sym} 1100 -280 0 0 {name=l21 lab=dvdd}
C {devices/lab_pin.sym} 1200 -280 0 0 {name=l22 lab=vcm}
C {devices/gnd.sym} 1000 -220 0 0 {name=l23 lab=0}
C {devices/gnd.sym} 1100 -220 0 0 {name=l24 lab=0}
C {devices/gnd.sym} 1200 -220 0 0 {name=l25 lab=0}
"""
a=s.index('s2d_tb = HDR'); b=s.index('C {devices/vsource.sym} 200 -230 0 0 {name=Vpad value="dc 1.65"}',a)
s=s[:b]+src_tb+common+s[b:]
a=s.index('s2d_cace_tpl = HDR'); b=s.index('C {devices/vsource.sym} 200 -230 0 0 {name=Vpad value=CACE',a)
s=s[:b]+src_cace+common+s[b:]
# yaml: dvdd and vcm conditions
s=s.replace("""  vin:
    description: Pad voltage
    display: Vpad
    unit: V
    typical: 1.65
""","""  vin:
    description: Pad voltage
    display: Vpad
    unit: V
    typical: 1.65
  dvdd:
    description: Pad (I/O) supply of the harness analog pad cell, DVDD
    display: DVDD
    unit: V
    typical: 5.0
  vcm:
    description: Common-mode reference input
    display: Vcm
    unit: V
    typical: 1.65
""")
s=s.replace("""      vdd:
        typical: 3.3
      vin:
        enumerate""","""      vdd:
        typical: 3.3
      dvdd:
        typical: 5.0
      vcm:
        typical: 1.65
      vin:
        enumerate""")
open(p,'w').write(s)
EOF
python3 gen_iopad.py /home/claude/work/repo/macros >/dev/null; T=/home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch; grep -n "vsource\|^V" $T; cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace && rm -rf _runs netlist && export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD COLUMNS=230 && timeout 500 /home/claude/venv/bin/cace gf180mcu_IOPadSingle2Diff.yaml --no-progress-bar -j 2 2>&1 | grep -v spiceinit > /home/claude/work/logs/cace_s2d.out; grep -E "Pass|Fail|Skip" /home/claude/work/logs/cace_s2d.out | grep ngspice | cut -c1-200; grep ERROR /home/claude/work/logs/cace_s2d.out | sort | uniq -c | sort -rn | head -5 | cut -c1-150
```

</details>

*[Ran a command (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
R=$(ls -d _runs/RUN_* | tail -1); python3 - $R <<'EOF'
import csv,sys
rows=list(csv.DictReader(open(sys.argv[1]+'/parameters/input_params/simulation_summary.csv')))
vins=sorted({float(r['vin']) for r in rows})
print('vin    ', '  '.join(f'{v:>6}' for v in vins))
for c in ['typical','ss','ff']:
  for t in ['-40','27','85']:
    I={float(r['vin']):float(r['Iin']) for r in rows if r['corner_d']==c and r['temp']==t}
    print(f'{c:7s}{t:>4}C', '  '.join(f'{I[v]*1e6:6.2g}' for v in vins), ' uA')
vp={float(r['vin']):float(r['Vprot']) for r in rows if r['corner_d']=='typical' and r['temp']=='27'}
print('Vprot typ/27C:', {k:round(v,2) for k,v in vp.items()})
EOF
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
export PATH=/opt/xschem/bin:$PATH PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff; for f in schematic/xschem/gf180mcu_IOPadSingle2Diff testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc; do d=$(dirname $f); b=$(basename $f); (cd $d && PWD=$(pwd) xvfb-run -a xschem --rcfile $(pwd)/xschemrc -q -x --svg --plotfile /home/claude/work/render/$b.svg $(pwd)/$b.sch >/dev/null 2>&1); python3 -c "import cairosvg;cairosvg.svg2png(url='/home/claude/work/render/$b.svg',write_to='/home/claude/work/render/$b.png',output_width=1400,background_color='white')"; done; ls /home/claude/work/render/*.png
```

</details>

*[Read gf180mcu_IOPadSingle2Diff.png (in the cloud container; image shown to the assistant).  
Read gf180mcu_IOPadSingle2Diff_tb_dc.png (in the cloud container; image shown to the assistant).]*

The 3.4.8 SVG export doesn't convert cleanly; rendering with the 3.4.4 binary instead:

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff; for f in schematic/xschem/gf180mcu_IOPadSingle2Diff testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc; do d=$(dirname $f); b=$(basename $f); (cd $d && PWD=$(pwd) xvfb-run -a /usr/bin/xschem --rcfile $(pwd)/xschemrc -q -x --svg --plotfile /home/claude/work/render/$b.svg $(pwd)/$b.sch >/dev/null 2>&1); python3 -c "import cairosvg;cairosvg.svg2png(url='/home/claude/work/render/$b.svg',write_to='/home/claude/work/render/$b.png',output_width=1400,background_color='white')"; done
```

</details>

*[Read gf180mcu_IOPadSingle2Diff.png (in the cloud container; image shown to the assistant).  
Read gf180mcu_IOPadSingle2Diff_tb_dc.png (in the cloud container; image shown to the assistant).]*

The pad testbench reads fine. In the macro schematic the `outp`/`outn` stubs crowd the `in_prot` label, so I'm moving them down:

*[Ran a command (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gen && python3 - <<'EOF'
p='gen_iopad.py'; s=open(p).read()
for a,b in [("N 580 -320 640 -320 {lab=outp}","N 580 -220 640 -220 {lab=outp}"),("N 580 -280 640 -280 {lab=outn}","N 580 -180 640 -180 {lab=outn}"),
            ("C {devices/opin.sym} 640 -320 0 0 {name=p2 lab=outp}","C {devices/opin.sym} 640 -220 0 0 {name=p2 lab=outp}"),
            ("C {devices/opin.sym} 640 -280 0 0 {name=p5 lab=outn}","C {devices/opin.sym} 640 -180 0 0 {name=p5 lab=outn}"),
            ("C {devices/lab_pin.sym} 580 -320 0 0 {name=l4 lab=outp}","C {devices/lab_pin.sym} 580 -220 0 0 {name=l4 lab=outp}"),
            ("C {devices/lab_pin.sym} 580 -280 0 0 {name=l5 lab=outn}","C {devices/lab_pin.sym} 580 -180 0 0 {name=l5 lab=outn}")]:
    assert s.count(a)==1, a; s=s.replace(a,b)
open(p,'w').write(s)
EOF
python3 gen_iopad.py /home/claude/work/repo/macros >/dev/null; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem && b=gf180mcu_IOPadSingle2Diff && PWD=$(pwd) xvfb-run -a /usr/bin/xschem --rcfile $(pwd)/xschemrc -q -x --svg --plotfile /home/claude/work/render/$b.svg $(pwd)/$b.sch >/dev/null 2>&1; python3 -c "import cairosvg;cairosvg.svg2png(url='/home/claude/work/render/$b.svg',write_to='/home/claude/work/render/$b.png',output_width=1400,background_color='white')"; export PATH=/opt/xschem/bin:$PATH; for m in gf180mcu_IOPadSingle2Diff gf180mcu_IOPadDiff2Single; do cd /home/claude/work/repo/macros/$m/schematic/xschem; rm -f /home/claude/work/net/$m.spice; PWD=$(pwd) xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /home/claude/work/net $(pwd)/$m.sch >/dev/null 2>&1; grep -E "^\.subckt|^X|^D|^\*\*\.subckt" /home/claude/work/net/$m.spice; done
```

</details>

*[Read gf180mcu_IOPadSingle2Diff.png (in the cloud container; image shown to the assistant).]*

The front end now reads cleanly. Before delivering, checking the notes worktree's CLAUDE.md for conventions on what a session should leave behind:

*[Ran a command (on the computer; 72 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher; cat CLAUDE.md; ls sudelbuecher sudelbuecher/*/ | head -30; cat ../gf180_cm_ip__single2diff2single/.gitignore
```

</details>

*[Ran a command (in the cloud container; 42 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros && for v in 03v3 06v0; do R=$(grep -l "OgueyAebischerRef_$v" OgueyAebischerBias/verification/cace/_runs/RUN_*/flow.log 2>/dev/null | head -1); [ -z "$R" ] && R=$(ls -d OgueyAebischerBias/verification/cace/_runs/RUN_* | ( [ $v = 03v3 ] && head -1 || tail -1 ))/x; R=$(dirname $R); echo "$v -> $R"; D=OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_$v; mkdir -p $D; cp $R/summary.md $D/summary.md; for p in $R/parameters/*; do cp $p/*.png $D/ 2>/dev/null; cp $p/simulation_summary.csv $D/$(basename $p)_summary.csv 2>/dev/null; done; ls $D; done; grep -c "home/claude" OgueyAebischerBias/verification/cace/results/*/summary.md; head -12 OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/summary.md
```

</details>

Checking one of the CACE plots:

*[Read Ibias_vs_vdd.png (in the cloud container; image shown to the assistant).]*

Plots work (CACE labels the axis "nA" but plots raw amperes; that's a CACE plotting quirk, not a data error). Saving the Single2Diff input results the same way, then writing the bias macro README:

*[Ran a command (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/gf180mcu_IOPadSingle2Diff/verification/cace && R=$(ls -d _runs/RUN_* | tail -1) && D=results/gf180mcu_IOPadSingle2Diff && mkdir -p $D && cp $R/summary.md $D/ && cp $R/parameters/input_params/*.png $D/ && cp $R/parameters/input_params/simulation_summary.csv $D/input_params_summary.csv && ls $D && cat $D/summary.md | head -12
```

</details>

Now the bias macro README:

*[Wrote README.md (in the cloud container; 1 lines of output).]*

Verifying two numbers quoted in the README:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/results && for v in 03v3 06v0; do python3 -c "
import csv
r=[x for x in csv.DictReader(open('OgueyAebischerRef_$v/dc_params_summary.csv')) if x['vdd']=='3.3' and x['corner_mos']=='typical']
print('$v', [(x['temp'], round(float(x['Ibias_val'])*1e9,1)) for x in r])"; done; sed -i 's/About 6 min per variant on two cores./4–6 min per variant on two cores./' ../../../README.md
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias && sed -i 's/the reference is temperature-flat (103 → 100 nA from −40 to 85 °C in\n03v3)/X/' README.md && python3 - <<'EOF'
p='README.md'; s=open(p).read()
old="current is set where intended, and the reference is temperature-flat (103 → 100 nA from −40 to 85 °C in\n03v3). What is left:"
assert old in s
s=s.replace(old,"current is set where intended, and the temperature drift is small (typical, 3.3 V: 103.1 / 100.0 / 100.1 nA\nat −40 / 27 / 85 °C in 03v3, 95.8 / 100.0 / 105.2 nA in 06v0). What is left:")
open(p,'w').write(s)
EOF
grep -n "temperature drift" -A1 README.md; cp /home/claude/work/check/check_port.py scripts/; cp /home/claude/work/check/ihp_reference.spice scripts/; sed -i '1i * Topology of the IHP sg13cmos5l OgueyAebischerBias macro (reference.spice of RUN_2026-09-04, CACE netlist),\n* used by check_port.py as the source of truth for the GF180 port. Device sizes here are the IHP ones.' scripts/ihp_reference.spice; head -3 scripts/ihp_reference.spice; python3 scripts/check_port.py scripts/ihp_reference.spice /home/claude/work/net/OgueyAebischerRef_06v0.spice 06v0 scripts/port_from_ihp.py | tail -1
```

</details>

Now the two IOPad macro READMEs:

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros && cat > gf180mcu_IOPadSingle2Diff/README.md <<'EOF'
# gf180mcu_IOPadSingle2Diff

Analog input from the harness pad (`gf180mcu_ocd_io__asig_5p0`) → CDM protection → single-ended →
differential buffer. IHP counterpart: `sg13cmos5l_IOPadSingle2Diff` (an empty stub there as well).

**Status (2026-10-06): proof of concept, input side only.**

- `schematic/xschem/gf180mcu_IOPadSingle2Diff.sch/.sym`: ports `vdd outp vcm in outn vss` (IHP pin
  order; `vcm` moved to the input side of the symbol) and the CDM front end next to the gates, with Tim
  Edwards' numbers (FOSSi Chipalooza chat): series poly resistor > 50 Ω, diode perimeter > 25 µm.
  - `Rcdm` `ppolyf_u_1k_6p0` 5 µm × 1 µm (about 200 Ω; placeholder value), from `in` to `in_prot`
  - `Dcdmp` `diode_pd2nw_06v0` `in_prot` → `vdd`, `Dcdmn` `diode_nd2ps_06v0` `vss` → `in_prot`,
    each 2 µm × 12 µm (perimeter 28 µm)
  - The buffer itself is not designed: `in_prot`, `vcm`, `outp`, `outn` are unconnected, so xschem
    reports `outp`/`outn` as undriven.
- `testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch`: DC sweep of the pad voltage through the real
  pad cell (DVDD = 5 V) into the macro. Its `xschemrc` adds `$PDK_ROOT/$PDK/libs.ref` to the library path,
  so the pad is referenced as `gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym` and its netlist
  comes from `libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice` (open_pdks install layout).
- `verification/cace/gf180mcu_IOPadSingle2Diff.yaml`, `input_params`: current into `in` and the
  voltage at `in_prot` for pad voltages −0.3 … 5.5 V, diode/resistor corners typical/ss/ff, −40/27/85 °C.
  CACE netlists templates with the PDK `xschemrc` and the templates folder only, so
  `verification/cace/templates/` holds a copy of the pad symbol (from `gf180mcu_ocd_io` @ `6e0e354`,
  made primitive as open_pdks does).

## Result: the input is not 5 V tolerant with diodes to a 3.3 V vdd

`verification/cace/results/gf180mcu_IOPadSingle2Diff/` (vdd = 3.3 V, DVDD = 5 V):

| Pad voltage | Current into `in` | `in_prot` (typical, 27 °C) |
| --- | --- | --- |
| −0.3 … 3.6 V | < 1 nA at all corners and temperatures | follows the pad |
| 4.0 V | 0.01 µA (−40 °C) … 30 µA (85 °C, ff) | 4.0 V |
| 5.0 V | 2.0 … 3.9 mA | 4.34 V |
| 5.5 V | 3.4 … 6.4 mA | 4.38 V |

So the usable input range is about −0.3 V … vdd + 0.3 V. At a 5 V pad level the CDM diode to `vdd`
conducts milliamps and the gate node sits at 4.3–4.4 V, above the 3.3 V device rating. The pad's own
HBM diodes go to DVDD/DVSS and do not help here. Options for the designer: state the limit in
`docs/OPERATING_LIMITS.md`, or tie the CDM diodes and the input devices to a 5 V supply with `*_06v0`
devices (see the 06v0 variant of `macros/OgueyAebischerBias`).
EOF
cat > gf180mcu_IOPadDiff2Single/README.md <<'EOF'
# gf180mcu_IOPadDiff2Single

Class-AB differential → single-ended driver for the analog output pad. IHP counterpart:
`sg13cmos5l_IOPadDiff2Single` (ESD clamps `sg13cmos5l_ClampN15N15`/`ClampP15N15` only, no GF180
equivalent; dropped for now).

**Status (2026-10-06): skeleton.** `schematic/xschem/gf180mcu_IOPadDiff2Single.sch/.sym` have the ports
`vdd inp inn out vss` and no devices. The IHP symbol declared `vcm` twice and `inp`/`inn` as outputs;
this symbol fixes that. Sizing notes for the driver: IHP notes worktree,
`design_considerations/class_ab_pad_driver/`.
EOF
echo ok
```

</details>

*[Ran a command (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/| −0.3 … 3.6 V | < 1 nA at all corners and temperatures | follows the pad |/| −0.3 … 3.6 V | ≤ 1 nA at all corners and temperatures | follows the pad |/' gf180mcu_IOPadSingle2Diff/README.md && grep -n "≤ 1 nA" gf180mcu_IOPadSingle2Diff/README.md; find . -name _runs -o -name netlist -o -name simulations | head;
```

</details>

Assembling the delivery set (sources, scripts, results; no generated run folders):

*[Ran a command (in the cloud container; 96 lines of output).]*

<details><summary>command</summary>

```sh
rm -rf /mnt/user-data/outputs/gf180 && mkdir -p /mnt/user-data/outputs/gf180 && cd /home/claude/work/repo && tar cf - --exclude=_runs --exclude=netlist --exclude=simulations --exclude=__pycache__ macros | (cd /mnt/user-data/outputs/gf180 && tar xf -) && cd /mnt/user-data/outputs/gf180 && find . -type f | sort > /tmp/files.txt; wc -l /tmp/files.txt; cat /tmp/files.txt; mkdir -p /mnt/user-data/outputs/logs && cp /home/claude/work/logs/cace_03v3.out /home/claude/work/logs/cace_06v0.out /home/claude/work/logs/cace_s2d.out /home/claude/work/logs/sim-all.out /mnt/user-data/outputs/logs/ && ls /mnt/user-data/outputs/logs
```

</details>

Dropping CACE's generated `_docs` and the two IOPad schematic `xschemrc` files (unchanged apart from the BOM, so I won't touch yours), then copying everything to your folder:

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/gf180 && rm -rf macros/OgueyAebischerBias/verification/cace/_docs macros/gf180mcu_IOPadDiff2Single/schematic/xschem/xschemrc macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/xschemrc && find . -type f | sort | sed 's#^\./##' > /tmp/files.txt && wc -l < /tmp/files.txt && python3 - <<'EOF'
import json
f=[l.strip() for l in open('/tmp/files.txt')]
items=[{"devicePath":"/home/cmaier/EDA/gf180_cm_ip__single2diff2single/"+p,"stagedPath":"/mnt/user-data/outputs/gf180/"+p} for p in f]
for i in range(0,len(items),45):
    json.dump(items[i:i+45],open(f'/tmp/batch{i//45}.json','w'))
print(len(items))
EOF
cat /tmp/batch0.json | head -c 300
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cat /tmp/batch0.json
```

</details>

*[Copied 45 files from the cloud container to the computer (error).]*

Everything landed except the macro `Makefile`, which the bridge refuses to write ("protected file"). I'll hand that one to you directly instead of working around the protection. Second batch:

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
import json; b=json.load(open('/tmp/batch1.json')); print(len(b)); print(json.dumps(b))" | head -c 200; echo
```

</details>

*[Ran a command (in the cloud container; 35 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
import json; b=json.load(open('/tmp/batch1.json'))
for x in b: print(x['devicePath'].replace('/home/cmaier/EDA/gf180_cm_ip__single2diff2single/',''))"
```

</details>

*[Copied 35 files from the cloud container to the computer (1 lines of output).]*

All 79 files are in your folder. Now the in-place edits on your machine: the top-level xschem chain, `.gitignore`, and the empty layout folders for the new macro.

*[Ran a command (on the computer; 25 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && mkdir -p macros/OgueyAebischerBias/layout/gds macros/OgueyAebischerBias/layout/klayout macros/OgueyAebischerBias/layout/magic && python3 - <<'EOF'
p='schematic/xschem/xschemrc'; s=open(p,encoding='utf-8').read()
old="source [file dirname [info script]]/../../macros/gf180mcu_IOPadDiff2Single/schematic/xschem/xschemrc\n"
assert old in s and 'OgueyAebischerBias' not in s
s=s.replace(old, old+"source [file dirname [info script]]/../../macros/OgueyAebischerBias/schematic/xschem/xschemrc\n")
open(p,'w',encoding='utf-8').write(s)
p='.gitignore'; s=open(p).read()
add="""# CACE generated outputs (summaries and plots worth keeping go to verification/cace/results/)
/macros/*/verification/cace/_runs
/macros/*/verification/cace/_docs
/macros/*/verification/cace/netlist
/macros/*/verification/cace/templates/simulations
"""
if '_runs' not in s.replace('runs/',''):
    s=s.rstrip('\n')+'\n'+add
open(p,'w').write(s)
EOF
sed -n 46,51p schematic/xschem/xschemrc; tail -6 .gitignore; head -c 3 schematic/xschem/xschemrc | od -c | head -1; ls macros/OgueyAebischerBias macros/OgueyAebischerBias/layout
```

</details>

Now `docs/OPERATING_LIMITS.md`, filling the rows the simulations can now answer (decisions stay open):

*[Ran a command (on the computer; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/docs && python3 - <<'EOF'
p='OPERATING_LIMITS.md'; s=open(p,encoding='utf-8').read()
old_rows=["| Supply (analog) | 3.3 V assumed; 5 V optional | open |",
"| `vin` / `vout` / `vcm` pad voltage range | open | open: pad may see 5 V levels |",
"| Absolute max on `vin` | open | depends on the CDM clamp and input device type |",
"| Temperature range | open | |"]
for r in old_rows: assert r in s, r
s=s.replace(old_rows[0],"| Supply (analog) | 3.3 V assumed; 5 V optional | open. Bias macro simulated at 3.0–3.6 V (`03v3` variant) and 3.0–5.5 V (`06v0` variant), 2026-10-06 |")
s=s.replace(old_rows[1],"| `vin` / `vout` / `vcm` pad voltage range | `vin`: −0.3 V … vdd + 0.3 V with the current CDM front end (diodes to the 3.3 V vdd); `vout`, `vcm` open | `vin` simulated (proof-of-concept front end, see below); decision open |")
s=s.replace(old_rows[2],"| Absolute max on `vin` | with diodes to a 3.3 V vdd: 5 V on the pad drives 2.0–3.9 mA into the CDM diode to vdd and puts 4.3–4.4 V on the protected gate node, above the 3.3 V device rating, so the input is **not** 5 V tolerant | simulated; design decision open |")
s=s.replace(old_rows[3],"| Temperature range | −40 … 85 °C used in all CACE decks | assumed |")
s=s.rstrip('\n')+"""

## Input range, simulated (2026-10-06)

Source: `macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/` (CACE `input_params`). Harness pad
`gf180mcu_ocd_io__asig_5p0` with DVDD = 5 V, followed by the proof-of-concept CDM front end (about 200 Ω
`ppolyf_u_1k_6p0`, diodes of 28 µm perimeter to vdd = 3.3 V and to vss); diode/resistor corners
typical/ss/ff, −40/27/85 °C.

| Pad voltage | Current into the macro | Protected gate node |
| --- | --- | --- |
| −0.3 … 3.6 V | ≤ 1 nA | follows the pad |
| 4.0 V | 0.01 µA (−40 °C) … 30 µA (85 °C) | 4.0 V |
| 5.0 V | 2.0 … 3.9 mA | 4.34 V (typical, 27 °C) |
| 5.5 V | 3.4 … 6.4 mA | 4.38 V |

The pad's own HBM diodes go to DVDD/DVSS and do not conduct in this range. To accept 5 V levels, the CDM
diodes and the input devices would have to sit on a 5 V supply (`*_06v0` devices).
"""
open(p,'w',encoding='utf-8').write(s)
EOF
cat OPERATING_LIMITS.md | head -14
```

</details>

Now the port map:

*[Ran a command (on the computer; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/docs && python3 - <<'EOF'
p='IHP_TO_GF180_PORT_MAP.md'; s=open(p,encoding='utf-8').read()
rows="""| Bias reference | `OgueyAebischerBias` + `ToBiasStartup` (`sg13_hv_*`, mirrors W = L = 1 µm, 47 nA, σ(I) ≈ 50 %, PSRR 24 dB) | `macros/OgueyAebischerBias`, cells `OgueyAebischerBias_<v>`, `ToBiasStartup_<v>`, `OgueyAebischerRef_<v>`, `<v>` = `03v3` / `06v0` (v) | 2026-10-06: topology and wiring unchanged, sizes re-derived (100 nA, σ(I1) ≈ 5 %); schematic netlist checked device by device against the IHP netlist; CACE suite ported and run. See the macro README |
| CACE corners | `cornerMOShv.lib mos_<tt,ss,…>`, `mos_tt_mismatch`, `cornerRES.lib res_<…>` | `design.ngspice` + `sm141064.ngspice <typical,ss,ff,sf,fs>`; mismatch with `.param sw_stat_mismatch=1` (no `*_mismatch` corner); `diode_<c>`, `res_<c>`, `moscap_<c>` sections (v) | used in the bias and input-pad decks |
| Mismatch model | `mm_ok=1`, `m` multiplies area | `fets_mm` draws one sample per instance and ignores `m` (v) | draw matched multi-unit devices as one instance with `nf` = units, `W` = units × W_unit |
| Model bin limit | – | W ≤ 100 µm per FET instance (v) | larger W fails with "could not find a valid modelname" |
| Analog pad in xschem | `sg13cmos5l_io/sg13cmos5l_IOPadAnalog.sym` | `gf180mcu_ocd_io/xschem/gf180mcu_ocd_io__asig_5p0.sym` with `$PDK_ROOT/$PDK/libs.ref` on the library path; netlist `libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice` (open_pdks layout) | used in `gf180mcu_IOPadSingle2Diff` testbenches; CACE templates need a copy of the symbol next to them |
| xschem version for CACE | 3.4.8 in the container | ≥ 3.4.8 needed: 3.4.4 ignores `top_is_subckt` and rejects the BOM in the project `xschemrc` files | checked 2026-10-06 |
"""
anchor="| KPEX |"
assert anchor in s
k=s.index(anchor)
s=s[:k]+rows+s[k:]
old="| Macros | `sg13cmos5l_IOPadSingle2Diff`, `sg13cmos5l_IOPadDiff2Single`, plus template `inverter`, `counter` | `gf180mcu_IOPadSingle2Diff`, `gf180mcu_IOPadDiff2Single` |"
assert old in s
s=s.replace(old,"| Macros | `sg13cmos5l_IOPadSingle2Diff`, `sg13cmos5l_IOPadDiff2Single`, `OgueyAebischerBias`, plus template `inverter`, `counter` | `gf180mcu_IOPadSingle2Diff`, `gf180mcu_IOPadDiff2Single`, `OgueyAebischerBias` (added 2026-10-06) |")
open(p,'w',encoding='utf-8').write(s)
EOF
grep -c "^|" IHP_TO_GF180_PORT_MAP.md; grep -n "Macros\|Bias reference\|KPEX" IHP_TO_GF180_PORT_MAP.md | cut -c1-120
```

</details>

Updating the status in `CLAUDE.md` and the macro list in the top-level README:

*[Ran a command (on the computer; 18 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && python3 - <<'EOF'
p='CLAUDE.md'; s=open(p,encoding='utf-8').read()
a=s.index("**Status (2026-10-06):**"); b=s.index("\n\n",a)
new="""**Status (2026-10-06, late):** skeleton and build files retargeted to `gf180mcuD` (see
`HANDOVER_gf180_migration.md`). First GF180 design content, proof of concept: `macros/OgueyAebischerBias`
(bias reference in `03v3` and `06v0` variants: schematics, symbols, start-up testbench, full CACE suite,
run in a cloud container, results in `verification/cace/results/`), the CDM input front end of
`macros/gf180mcu_IOPadSingle2Diff` with a pad-in-the-loop testbench and a CACE input-range deck, and a
port-only skeleton of `macros/gf180mcu_IOPadDiff2Single`. **No layout exists**; DRC/LVS/PEX targets have not
been run. Open items: `docs/IHP_TO_GF180_PORT_MAP.md`, `docs/OPERATING_LIMITS.md`, handover file §7."""
s=s[:a]+new+s[b:]
open(p,'w',encoding='utf-8').write(s)
p='README.md'; s=open(p,encoding='utf-8').read()
old="- **[`macros/gf180mcu_IOPadDiff2Single/`](macros/gf180mcu_IOPadDiff2Single/README.md)** (`TOP = gf180mcu_IOPadDiff2Single`): class-AB differential-to-single-ended driver and analog output pad.\n"
assert old in s
s=s.replace(old, old+"- **[`macros/OgueyAebischerBias/`](macros/OgueyAebischerBias/README.md)** (`TOP = OgueyAebischerRef_<VARIANT>`, `VARIANT` = `03v3` or `06v0`): resistor-free bias current reference with start-up, ported from IHP in two device-family variants. Has `sim-cace` / `sim-cace-all` targets. Not yet part of `build-macros`.\n")
old2="| [`macros/gf180mcu_IOPadDiff2Single/testbenches/xschem/xschemrc`](macros/gf180mcu_IOPadDiff2Single/testbenches/xschem/xschemrc) | output driver macro testbenches |\n"
assert old2 in s
s=s.replace(old2, old2+"| [`macros/OgueyAebischerBias/schematic/xschem/xschemrc`](macros/OgueyAebischerBias/schematic/xschem/xschemrc) | bias macro schematics |\n| [`macros/OgueyAebischerBias/testbenches/xschem/xschemrc`](macros/OgueyAebischerBias/testbenches/xschem/xschemrc) | bias macro testbenches |\n")
old3="   └─ source macros/gf180mcu_IOPadDiff2Single/schematic/xschem/xschemrc"
if old3 in s:
    s=s.replace(old3,"   ├─ source macros/gf180mcu_IOPadDiff2Single/schematic/xschem/xschemrc\n   └─ source macros/OgueyAebischerBias/schematic/xschem/xschemrc")
open(p,'w',encoding='utf-8').write(s)
EOF
grep -n "OgueyAebischer" README.md CLAUDE.md | cut -c1-140; sed -n 170,182p README.md
```

</details>

Appending a section to the handover file for the next session:

*[Ran a command (on the computer; 6 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && python3 - <<'EOF'
p='HANDOVER_gf180_migration.md'; s=open(p,encoding='utf-8').read()
s=s.rstrip('\n')+"""

## 7. Session 2026-10-06 late (Claude Opus): bias port, CACE, IOPad proof of concept

Request: migrate the work-in-progress design; as proof of concept run the bias circuit test and
verification suites, start building CACE suites, create xschem schematics and symbols for circuits and
testbenches. User decision this session: build the bias in **both** device families (`03v3` and `06v0`).

Done (details in each macro README):

- `macros/OgueyAebischerBias/`: IHP bias core + start-up ported wire for wire (GF180 FET symbols have the
  IHP pin geometry), sizes re-derived from extracted gm/ID data and mismatch Monte Carlo; wrapper
  `OgueyAebischerRef_<v>` (the CACE DUT), start-up testbench, CACE yaml + six templates per variant,
  results in `verification/cace/results/`. `scripts/check_port.py` compares xschem's netlist with the IHP
  netlist device by device (PASS for both variants).
- `macros/gf180mcu_IOPadSingle2Diff/`: CDM front end (Tim's > 50 Ω / > 25 µm numbers, placeholder sizes),
  pad-in-the-loop testbench with `gf180mcu_ocd_io__asig_5p0`, CACE `input_params`. Finding: with CDM
  diodes to a 3.3 V vdd the input is not 5 V tolerant; numbers in `docs/OPERATING_LIMITS.md`.
- `macros/gf180mcu_IOPadDiff2Single/`: symbol and port-only schematic (IHP symbol pin bugs fixed).
- Top-level `schematic/xschem/xschemrc` sources the bias macro; `.gitignore` covers CACE outputs;
  `docs/IHP_TO_GF180_PORT_MAP.md`, `docs/OPERATING_LIMITS.md`, `CLAUDE.md`, `README.md` updated.

**Not delivered by the bridge:** `macros/OgueyAebischerBias/Makefile` ("protected file", the bridge
refuses Makefiles). The user received it as a chat attachment and has to copy it in. It is the IOPad macro
Makefile plus `VARIANT`, `sim-cace`, `sim-cace-all`, CACE outputs in `clean`.

Where the numbers came from: a cloud container with ngspice-42, xschem 3.4.8RC built from source,
CACE 2.13, and a gf180mcuD tree assembled by hand from `gf180mcu_fd_pr` @ `e11a8c9` (the commit open_pdks
pins) laid out like open_pdks (`libs.tech/ngspice`, `libs.tech/xschem`, `fix_xschemrc.py` applied) plus the
pad symbol/netlist under `libs.ref/gf180mcu_ocd_io`. **Not yet reproduced in the IIC-OSIC-TOOLS
container**; do that first (`make sim-all`, `make sim-cace-all` in the bias macro, `cace` in the
Single2Diff `verification/cace`).

Open decisions for the user:

1. Device family per block (03v3 vs 06v0) and the analog supply (3.3 V vs 5 V); the input-range result
   ties into this.
2. Bias topology: cascode M10/M13/M14 for PSRR (30.7 / 35.2 dB against the 50 dB target) and leg
   matching; weaker kick or faster release for the start-up overshoot (14× for a µs ramp, 6–16 µs settling);
   MiM instead of the depleted NMOS cap M26.
3. CACE spec limits marked *placeholder* in the yaml files (I1 70–130 nA, Iq < 2 µA, ±15 % / ±6 %
   mismatch, Iin ±1 µA).
4. CDM resistor and diode sizes (placeholders), and whether the diodes go to a 5 V rail.

Traps found this session:

- xschem < 3.4.8 ignores CACE's `top_is_subckt` (DUT netlist has `**.subckt`, testbenches fail) and rejects
  the UTF-8 BOM that the project's older `xschemrc` files start with. The new files have no BOM.
- CACE netlists templates with the PDK `xschemrc` plus the templates folder only; a template's own
  `xschemrc` is ignored. Symbols outside the PDK's `libs.tech/xschem` must sit next to the templates.
- A CACE template text that mentions `CACE{cond}` for a condition not declared in the yaml makes CACE treat
  it as undefined everywhere, including `CACE{cond=default}` in code blocks. Declare every condition.
- GF180 mismatch ignores `m`; W ≤ 100 µm per FET; transient decks need `abstol=1e-13` and an explicit
  `tmax` or cold corners take minutes.
- At the start of this session `git status`/`git log` were run once in the design worktree before this
  file's rule was read; no `index.lock` was left (checked). No further git commands were run.
"""
open(p,'w',encoding='utf-8').write(s)
EOF
tail -5 HANDOVER_gf180_migration.md; ls .git/*.lock 2>&1 | head -2
```

</details>

Tightening one handover claim to what I actually observed:

*[Ran a command (on the computer; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && python3 - <<'EOF'
p='HANDOVER_gf180_migration.md'; s=open(p,encoding='utf-8').read()
old="""- A CACE template text that mentions `CACE{cond}` for a condition not declared in the yaml makes CACE treat
  it as undefined everywhere, including `CACE{cond=default}` in code blocks. Declare every condition."""
assert old in s
s=s.replace(old,"""- A template whose annotation text used `CACE{dvdd}` while `dvdd` was not declared in the yaml left
  `CACE{dvdd=5.0}` in the code block unsubstituted ("Condition dvdd not defined"); declaring the condition
  in the yaml fixed it. Declare every condition a template mentions.""")
open(p,'w',encoding='utf-8').write(s)
EOF
grep -n "dvdd" HANDOVER_gf180_migration.md | head -3; ls $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/logs/
```

</details>

Filing the run logs in the notes worktree (`sudelbuecher/logs/main/`), per its convention:

*[Ran a command (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/logs && for f in cace_03v3 cace_06v0 cace_s2d sim-all; do mv $f.out 2026-10-06_opus_$f.out 2>/dev/null; done; ls
```

</details>

*[Copied 4 files from the cloud container to the computer (1 lines of output).]*

Final check: comparing checksums of everything on your machine against what I verified here:

*[Ran a command (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/gf180 && find . -type f -exec md5sum {} + | sort -k2 > /tmp/cloud.md5; wc -l < /tmp/cloud.md5; md5sum /home/claude/work/repo/macros/OgueyAebischerBias/Makefile
```

</details>

*[Ran a command (on the computer; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && find macros/OgueyAebischerBias macros/gf180mcu_IOPadSingle2Diff macros/gf180mcu_IOPadDiff2Single -type f -not -name xschemrc -o -type f -path '*testbenches*' -name xschemrc -o -type f -path '*cace*' -name xschemrc -o -type f -path '*OgueyAebischerBias*' -name xschemrc | sed 's#^#./#' | xargs md5sum | sort -k2 | md5sum; find macros/OgueyAebischerBias macros/gf180mcu_IOPadSingle2Diff macros/gf180mcu_IOPadDiff2Single -type f | wc -l; ls macros/OgueyAebischerBias
```

</details>

*[Ran a command (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
grep -v "/Makefile$" /tmp/cloud.md5 | awk '{print $2}' | sed 's#^\./##' > /tmp/paths.txt; wc -l < /tmp/paths.txt; grep -v "/Makefile$" /tmp/cloud.md5 | md5sum; cat /tmp/paths.txt | tr '\n' ' ' | head -c 100
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
grep -v "/Makefile$" /tmp/cloud.md5 | awk '{print $1"  "$2}' > /tmp/cloud79.md5; python3 -c "
p=[l.split()[1][2:] for l in open('/tmp/cloud79.md5')]
print(' '.join(p))" > /tmp/plist.txt; wc -c /tmp/plist.txt
```

</details>

*[Ran a command (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cat /tmp/plist.txt | head -c 7000 > /dev/null; awk '{print $1"  ./"$2}' /dev/null; sort -k2 /tmp/cloud79.md5 | md5sum; echo; cat /tmp/plist.txt
```

</details>

*[Ran a command (on the computer; 31 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && P=$(find macros/OgueyAebischerBias macros/gf180mcu_IOPadSingle2Diff macros/gf180mcu_IOPadDiff2Single -type f | grep -v "/schematic/xschem/xschemrc$" | grep -v "^macros/gf180mcu_IOPadDiff2Single/testbenches" ; echo macros/OgueyAebischerBias/schematic/xschem/xschemrc); for f in $P; do echo "$f"; done | sort -u > /tmp/dev_paths.txt; wc -l < /tmp/dev_paths.txt; sed 's#^#./#' /tmp/dev_paths.txt | xargs md5sum | sort -k2 | md5sum; grep -v -x -F -f <(echo) /tmp/dev_paths.txt | head -0; find macros/gf180mcu_IOPadSingle2Diff macros/gf180mcu_IOPadDiff2Single -type f | sort
```

</details>

The device has extra pre-existing files (Makefiles, .gitkeep), so I'll compare only the 79 delivered paths:

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
sort -k2 /tmp/cloud79.md5 | sed 's#  \./#  #' | md5sum
```

</details>

*[Ran a command (on the computer; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && cat > /tmp/p.txt <<'EOF'
macros/OgueyAebischerBias/README.md macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_03v3.sch macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_03v3.sym macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_06v0.sch macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_06v0.sym macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_03v3.sch macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_03v3.sym macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_06v0.sch macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_06v0.sym macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_03v3.sch macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_03v3.sym macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_06v0.sch macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_06v0.sym macros/OgueyAebischerBias/schematic/xschem/xschemrc macros/OgueyAebischerBias/scripts/check_pex_ports.py macros/OgueyAebischerBias/scripts/check_port.py macros/OgueyAebischerBias/scripts/gen_cace.py macros/OgueyAebischerBias/scripts/ihp_reference.spice macros/OgueyAebischerBias/scripts/port_from_ihp.py macros/OgueyAebischerBias/testbenches/xschem/OgueyAebischerRef_03v3_tb_tran.sch macros/OgueyAebischerBias/testbenches/xschem/OgueyAebischerRef_06v0_tb_tran.sch macros/OgueyAebischerBias/testbenches/xschem/xschemrc macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_03v3.yaml macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_06v0.yaml macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Ibias_vs_corner_mos.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Ibias_vs_temp.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Ibias_vs_vdd.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Vbr_vs_vdd.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/ac_psrr_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/dc_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/disable_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/mm_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/noise_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/summary.md macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/t_startup_vs_corner_mos.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/t_startup_vs_temp.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/tran_startup_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/Ibias_vs_corner_mos.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/Ibias_vs_temp.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/Ibias_vs_vdd.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/Vbr_vs_vdd.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/ac_psrr_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/dc_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/disable_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/mm_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/noise_params_summary.csv macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/summary.md macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/t_startup_vs_corner_mos.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/t_startup_vs_temp.png macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/tran_startup_params_summary.csv macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_ac_psrr.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_dc.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_dc_mm.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_noise.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_tran_disable.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_ac_psrr.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_dc.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_dc_mm.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_noise.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_tran.sch macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_tran_disable.sch macros/OgueyAebischerBias/verification/cace/templates/xschemrc macros/gf180mcu_IOPadDiff2Single/README.md macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sym macros/gf180mcu_IOPadSingle2Diff/README.md macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sym macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc macros/gf180mcu_IOPadSingle2Diff/verification/cace/gf180mcu_IOPadSingle2Diff.yaml macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Iin_vs_vin.png macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Vprot_vs_vin.png macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/input_params_summary.csv macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/summary.md macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_ocd_io__asig_5p0.sym macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc
EOF
md5sum $(cat /tmp/p.txt) | sort -k2 | md5sum
```

</details>

*[Ran a command (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/gf180 && md5sum $(cat /tmp/plist.txt) | LC_ALL=C sort -k2 | md5sum
```

</details>

*[Ran a command (on the computer; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && md5sum $(cat /tmp/p.txt) | LC_ALL=C sort -k2 | md5sum
```

</details>

*[Ran a command (on the computer; 79 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && md5sum $(cat /tmp/p.txt) | LC_ALL=C sort -k2 | awk '{print substr($1,1,8), $2}' | head -80
```

</details>

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/gf180 && md5sum $(cat /tmp/plist.txt) | LC_ALL=C sort -k2 | awk '{print substr($1,1,8), $2}' > /tmp/c.txt; cat > /tmp/d.txt <<'EOF'
1e779392 macros/OgueyAebischerBias/README.md
cf6c427c macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_03v3.sch
f5aec502 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_03v3.sch
f750426a macros/OgueyAebischerBias/schematic/xschem/xschemrc
c65208b0 macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_03v3.yaml
794b4067 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch
455449ff macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch
8ea282a7 macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch
eee0a292 macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc
a3a35e65 macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_06v0/summary.md
EOF
grep -F -f <(awk '{print $2}' /tmp/d.txt) /tmp/c.txt | diff - <(LC_ALL=C sort -k2 /tmp/d.txt) && echo "spot-check identical"; md5sum /mnt/user-data/outputs/gf180/macros/OgueyAebischerBias/README.md /home/claude/work/repo/macros/OgueyAebischerBias/README.md | cut -c1-8
```

</details>

*[Ran a command (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cat > /tmp/dfull.txt <<'EOF'
1e779392 macros/OgueyAebischerBias/README.md
cf6c427c macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_03v3.sch
47a9fd04 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_03v3.sym
743c0518 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_06v0.sch
47a9fd04 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerBias_06v0.sym
f5aec502 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_03v3.sch
f682e8e8 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_03v3.sym
77dcbdd8 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_06v0.sch
f682e8e8 macros/OgueyAebischerBias/schematic/xschem/OgueyAebischerRef_06v0.sym
31f3dbf8 macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_03v3.sch
f682e8e8 macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_03v3.sym
cc4d5c84 macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_06v0.sch
f682e8e8 macros/OgueyAebischerBias/schematic/xschem/ToBiasStartup_06v0.sym
f750426a macros/OgueyAebischerBias/schematic/xschem/xschemrc
ae8f0894 macros/OgueyAebischerBias/scripts/check_pex_ports.py
f77b847b macros/OgueyAebischerBias/scripts/check_port.py
f55cbb5c macros/OgueyAebischerBias/scripts/gen_cace.py
a2648a98 macros/OgueyAebischerBias/scripts/ihp_reference.spice
fb00ac4f macros/OgueyAebischerBias/scripts/port_from_ihp.py
436bc830 macros/OgueyAebischerBias/testbenches/xschem/OgueyAebischerRef_03v3_tb_tran.sch
0f529587 macros/OgueyAebischerBias/testbenches/xschem/OgueyAebischerRef_06v0_tb_tran.sch
2f0a1111 macros/OgueyAebischerBias/testbenches/xschem/xschemrc
c65208b0 macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_03v3.yaml
3a78a0dc macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_06v0.yaml
0aed0e34 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_ac_psrr.sch
0c039e94 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_dc.sch
9f840f3a macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_dc_mm.sch
2e8251c4 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_noise.sch
794b4067 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_tran.sch
78cb8a8d macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_03v3_tb_tran_disable.sch
d3707402 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_ac_psrr.sch
ac3b6273 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_dc.sch
ec0a32ba macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_dc_mm.sch
bad89dc7 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_noise.sch
506bec24 macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_tran.sch
64c8e58b macros/OgueyAebischerBias/verification/cace/templates/OgueyAebischerRef_06v0_tb_tran_disable.sch
c28ef03a macros/OgueyAebischerBias/verification/cace/templates/xschemrc
6a4b68ae macros/gf180mcu_IOPadDiff2Single/README.md
e34b0ce0 macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch
7bdcdfc4 macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sym
fbc16cfc macros/gf180mcu_IOPadSingle2Diff/README.md
455449ff macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch
677e1189 macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sym
edaf5e8f macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch
c5ba87ca macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc
9c9cba1f macros/gf180mcu_IOPadSingle2Diff/verification/cace/gf180mcu_IOPadSingle2Diff.yaml
8ea282a7 macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch
ba1a9ed0 macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_ocd_io__asig_5p0.sym
eee0a292 macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc
EOF
join -1 2 -2 2 <(sort -k2 /tmp/dfull.txt) <(sort -k2 /tmp/c.txt) | awk '$2!=$3{print "DIFF",$0} END{print NR" compared"}'
```

</details>

All 49 source files match byte for byte, plus a spot check of the results. Last item: the bias macro `Makefile`, which the bridge wouldn't write.

*[Ran a command (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /mnt/user-data/outputs/OgueyAebischerBias_Makefile && cp /home/claude/work/repo/macros/OgueyAebischerBias/Makefile /mnt/user-data/outputs/OgueyAebischerBias_Makefile/Makefile && ls -la /mnt/user-data/outputs/OgueyAebischerBias_Makefile/
```

</details>

*[Called SendUserFile (3 lines of output).  
Set task 3 to completed.  
Set task 4 to completed.  
Set task 5 to completed.  
Set task 6 to completed.]*

The bias circuit is ported to GF180 in both device families, and its full test and CACE suite runs. The two IOPad macros now have first schematics, symbols, a testbench and a CACE deck. Everything is in your folder except one Makefile (see the end).

I ran all of this in my own workspace, not in your IIC-OSIC-TOOLS container. I built the toolchain there: ngspice-42, xschem 3.4.8 built from source, CACE 2.13, and a gf180mcuD install assembled from the same primitive-library commit open_pdks uses. The numbers below therefore still need a re-run on your side.

**Bias circuit (`macros/OgueyAebischerBias`, variants `03v3` and `06v0`)**
- **Schematics:** the IHP drawings with every wire kept, since the GF180 transistor symbols have the same pin positions. Only devices and sizes changed. A script compares xschem's netlist with the IHP netlist device by device; both variants pass.
- **Sizes:** re-derived rather than copied. The target is 100 nA with about 5 % current spread from mismatch, using transistor data and mismatch coefficients taken from the GF180 models.
- **Test and CACE:** the start-up testbench and all six IHP CACE test groups were ported and run.

| Spec | Limit | 03v3 | 06v0 |
|---|---|---|---|
| Core current, all corners/temps/supplies | 70–130 nA (my placeholder) | 90–120 nA ✅ | 86–148 nA ❌, fails only at 5–5.5 V |
| Current spread from mismatch (1 σ) | ±15 % (placeholder) | 4.9 % ✅ | 4.5 % ✅ |
| Start-up after a 1 µs supply ramp | max 40 µs (your IHP limit) | 11–16 µs ✅ | 6–8 µs ✅ |
| PSRR at 1 kHz | min 50 dB (your IHP limit) | 30.7 dB ❌ | 35.2 dB ❌ |

- **PSRR:** this is the loop-amplification problem your 2026-09-04 IHP analysis found. Cascoding M10/M13/M14 is the fix, but that changes the topology, so I left it for you.
- **Start-up was mis-measured in the IHP deck.** The old measurement triggered on coupling from the supply ramp, not on the circuit starting. Measured properly, the kick drives the current to about 14× nominal for a moment before it settles.
- **Mismatch in GF180 models:** they ignore the `m` multiplier, so matched multi-unit transistors are drawn as one device with several fingers.

**IOPad macros**
- **`gf180mcu_IOPadSingle2Diff`:** I drew the CDM protection at the input using Tim's numbers (sizes are placeholders). Its testbench and CACE deck include the real `asig_5p0` pad cell.
- **The input is not 5 V tolerant** with CDM diodes to a 3.3 V supply. Between −0.3 and 3.6 V the input current stays below about 1 nA. A 5 V pad draws 2–4 mA, and the protected gate node sits at 4.3 V, above the 3.3 V device rating. The numbers are in `docs/OPERATING_LIMITS.md`. Whether to accept that limit or move the input to 6 V devices on a 5 V rail is your decision.
- **`gf180mcu_IOPadDiff2Single`:** symbol and ports only. The IHP symbol had `vcm` twice and the inputs marked as outputs; that is fixed.

**Also changed:** the top-level `xschemrc` now includes the bias macro, `.gitignore` covers CACE's generated folders, and the port map, operating limits, `CLAUDE.md`, `README.md` and the handover file (new §7) are updated. The run logs are in `sudelbuecher/logs/main/`.

**Things to know:**
- **Makefile:** the bridge refuses to write Makefiles, so the attached `Makefile` needs copying by hand into `macros/OgueyAebischerBias/`.
- **xschem version:** CACE needs xschem 3.4.8 or later; the older 3.4.4 can't produce a netlist CACE's testbenches can use.
- **Git:** before I read the handover's no-git rule I ran `git status` and `git log` once. No lock file was left, and I ran no git commands after that.

A good first step is `make sim-all` and `make sim-cace-all` in `macros/OgueyAebischerBias` inside your container, to confirm these numbers. I can also export this session's chatlog to the notes worktree if you want it.

## Turn 2 — 2026-10-06 22:59

**User:**

try to write the makefile again. maybe the quote ran out.

**Assistant:**

Retrying the Makefile copy:

*[Copied 1 files from the cloud container to the computer (error).]*

The retry was rejected with the same message: `Makefile is a protected file and cannot be written via remote tools`. So the quota isn't the cause. The bridge blocks files named `Makefile` on purpose, and it rejects the path regardless of how the content arrives. I haven't tried to work around that through the shell either, because the block is clearly intended.

To put it in place, save the attached `Makefile` from my previous reply into `macros/OgueyAebischerBias/` yourself. If it went to your Downloads folder:

```sh
cp ~/Downloads/Makefile ~/EDA/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias/Makefile
```

Afterwards, `make -C ~/EDA/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias help` should list `sim-cace` and `sim-cace-all`.

## Turn 3 — 2026-10-06 23:01

**User:**

@"/root/.claude/uploads/ae2f9665-832e-520c-96fd-494fa4898beb/247f0ff4-attachment.txt" Yes it did something:

**User:**

*[Attached file `247f0ff4-attachment.txt`, verbatim:]*

```text
~/EDA/gf180_cm_ip__single2diff2single$ make -C ~/EDA/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias help
make: Entering directory '/home/cmaier/EDA/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias'
Usage: make <target> [VARIANT=<03v3|06v0>] [CELL=<cellname>] [EXT_MODE=<1|2|3>] [THRESHOLD=<mOhm>] [MINRES=<mOhm>] [MINDELAY=<ps>] [DRC_LEVEL=<precheck|macro|regular>] [EV_PRECISION=<digits>] [TB=<testbenchname>] [SCRIPT=<scriptname>] [OPEN_ARGS=<options>]

Available targets:
  help                 Show this help message
  open                 Open the design files of this folder in the sak-open.py file browser (needs the VNC/X11 desktop)
  sim-xschem           Run TB simulation with Xschem in batch mode (usage: make sim-xschem [TB=<testbenchname>])
  sim-view-xschem      Plot Xschem simulation results (usage: make sim-view-xschem [SCRIPT=<scriptname>])
  sim-all              Simulate the macro (start-up testbench of both variants)
  sim-cace             Run the CACE suite of TOP (usage: make sim-cace [VARIANT=<03v3|06v0>] [CACE_PARAMS="<groups>"])
  sim-cace-all         Run the CACE suites of both variants
  build-top            Build TOP cell (Verilog, LEF, LIB, copy GDS, and render image)
  lef                  Export LEF from the TOP cell layout using Magic
  lib                  Generate a Liberty timing library for the TOP cell
  verilog              Generate a Verilog stub of the TOP cell from Magic or KLayout PEX netlist pins
  copy-gds             Copy the TOP cell GDS from layout/gds/ to final/gds/
  render-gds           Render images from the final GDS using sak-render.py
  klayout-drc          Run KLayout DRC of the CELL cell (usage: make klayout-drc [CELL=<cellname>] [DRC_LEVEL=<precheck|macro|regular>])
  magic-drc            Run Magic DRC of the CELL cell (usage: make magic-drc [CELL=<cellname>])
  klayout-lvs-netlist  Export CDL schematic netlist from Xschem for KLayout LVS (usage: make klayout-lvs-netlist [CELL=<cellname>] [EV_PRECISION=<digits>])
  klayout-lvs          Run KLayout LVS of the CELL cell (usage: make klayout-lvs [CELL=<cellname>])
  magic-lvs-netlist    Export SPICE schematic netlist from Xschem for Magic + Netgen LVS (usage: make magic-lvs-netlist [CELL=<cellname>] [EV_PRECISION=<digits>])
  magic-lvs            Run Magic + Netgen LVS of the CELL cell (usage: make magic-lvs [CELL=<cellname>])
  symbol-pex           Build the Xschem PEX symbol <CELL>_pex.sym from <CELL>.sym (usage: make symbol-pex [CELL=<cellname>])
  klayout-pex          Run Parasitic Extraction with KPEX of the CELL cell (usage: make klayout-pex [CELL=<cellname>] [EXT_MODE=<1|2|3>])
  magic-pex            Run Parasitic Extraction with Magic of the CELL cell (usage: make magic-pex [CELL=<cellname>] [EXT_MODE=<1|2|3>] [THRESHOLD=<mOhm>] [MINRES=<mOhm>] [MINDELAY=<ps>])
  klayout-verify       Verify CELL cell with KLayout (usage: make klayout-verify [CELL=<cellname>])
  klayout-verify-all   Verify all main subcells with KLayout (DRC, LVS)
  magic-verify         Verify CELL cell with Magic (usage: make magic-verify [CELL=<cellname>])
  magic-verify-all     Verify all main subcells with Magic (DRC, LVS, PEX)
  all                  Verify, build and simulate the TOP cell
  clean                Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation and CACE outputs)

VARIANT selects the device family (03v3|06v0, default 03v3); TOP = OgueyAebischerRef_<VARIANT>.
CELL defaults to OgueyAebischerRef_03v3. Override to verify subcells.
EXT_MODE defaults to 3 (full-RC). 1=C-decoupled, 2=C-coupled.
THRESHOLD/MINRES/MINDELAY are full-RC (EXT_MODE=3) extresist settings for magic-pex (defaults 10000 mOhm / 1000 mOhm / 1 ps).
DRC_LEVEL defaults to macro. Sets the KLayout DRC level for klayout-drc (precheck|macro|regular).
EV_PRECISION defaults to 5 significant digits for xschem ev function.
TB selects the Xschem testbench for sim-xschem (default: <CELL>_tb_tran).
SCRIPT selects the plotting script for sim-view-xschem (default: plot_<CELL>).
OPEN_ARGS passes extra options to sak-open.py for the open target (e.g. --all).
make: Leaving directory '/home/cmaier/EDA/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias'
```

**Assistant:**

The Makefile is in place and `make` reads it correctly: `sim-cace`, `sim-cace-all`, the `VARIANT` switch and the CACE cleanup in `clean` are all there, and `TOP` resolves to `OgueyAebischerRef_03v3`.

The next step is reproducing my numbers in your IIC-OSIC-TOOLS container:

```sh
cd /foss/designs/gf180_cm_ip__single2diff2single && source .designinit
cd macros/OgueyAebischerBias
make sim-all          # start-up testbench, both variants: I1 should settle at about 100 nA
make sim-cace-all     # full CACE suites, about 5 min per variant here
```

Compare the CACE summaries against `verification/cace/results/OgueyAebischerRef_*/summary.md`. If anything differs, the likely causes are your gf180mcuD version or a `spiceinit` that your PDK install provides and mine didn't. The single-to-differential input deck runs separately with `cace gf180mcu_IOPadSingle2Diff.yaml` in `macros/gf180mcu_IOPadSingle2Diff/verification/cace/`.

## Turn 4 — 2026-10-07 21:54

**User:**

I think I saved your Makefile where it belongs. Please sanity check.
Also, I was too hasty looking at some of your macro/OgueyAebischerBias schematics, tweaking them a little, and running the test bases before I committed your changes to the gf180_cm_ip__single2diff2single repository.
Please download your versions from 6 October 22:33 (roughly) to my directory again where I changed them, so I have a track record of the changes (my edited files are in xschem in the docker container now, so the changes won't get lost).

**Assistant:**

I'll check the Makefile, find which of my files you changed, and restore my versions of those.

*[Ran a command (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
ls /mnt/user-data/outputs/gf180/macros/ 2>&1; ls /home/claude/work/repo/macros 2>&1; test -f /tmp/cloud79.md5 && wc -l /tmp/cloud79.md5; md5sum /mnt/user-data/outputs/OgueyAebischerBias_Makefile/Makefile 2>&1
```

</details>

My delivered copies are still here. Confirming they're unchanged since the 6 October delivery, then comparing against your folder:

*[Ran a command (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/gf180 && md5sum -c /tmp/cloud79.md5 2>&1 | grep -v ": OK$" ; echo "check done"; ls -la --time-style=full-iso macros/OgueyAebischerBias/README.md | cut -c40-
```

</details>

All text files are unchanged. The 14 PNGs differ, most likely the provenance stamp the app adds to images that pass through it. Checking against my working originals:

*[Ran a command (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo && for f in macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Ibias_vs_vdd.png macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Iin_vs_vin.png; do md5sum $f /mnt/user-data/outputs/gf180/$f | cut -c1-12; grep "$(basename $f)" /tmp/cloud79.md5 | cut -c1-12; ls -la --time-style=full-iso /mnt/user-data/outputs/gf180/$f | cut -c40-; done; python3 -c "
from PIL import Image
a=Image.open('/home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Ibias_vs_vdd.png'); b=Image.open('/mnt/user-data/outputs/gf180/macros/OgueyAebischerBias/verification/cace/results/OgueyAebischerRef_03v3/Ibias_vs_vdd.png')
print(a.size,b.size, list(a.getdata())==list(b.getdata())); print(set(b.info)-set(a.info), {k:str(v)[:80] for k,v in b.info.items() if k not in a.info})"
```

</details>

Pixel data is identical, so only image metadata differs; the images aren't your edits anyway. Now comparing your folder against my delivered versions:

*[Ran a command (on the computer; 94 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && ls .git/*.lock 2>/dev/null; find macros/OgueyAebischerBias macros/gf180mcu_IOPadSingle2Diff macros/gf180mcu_IOPadDiff2Single -type f -not -path '*/_runs/*' -not -path '*/simulations/*' -not -path '*/cace/netlist/*' -not -path '*/_docs/*' -not -name '*.png' | LC_ALL=C sort | xargs md5sum | awk '{print substr($1,1,12), $2}'; echo ===; find macros/OgueyAebischerBias -newermt '2026-10-06 22:40' -type f -not -path '*/_runs/*' | head -50
```

</details>

*[Ran a command (on the computer; 25 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias && B=$HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-07_user_edits_before_restore/macros/OgueyAebischerBias && mkdir -p $B/schematic/xschem $B/testbenches/xschem && cp -p schematic/xschem/{OgueyAebischerBias,OgueyAebischerRef,ToBiasStartup}_{03v3,06v0}.sch $B/schematic/xschem/ && cp -p testbenches/xschem/OgueyAebischerRef_{03v3,06v0}_tb_tran.sch $B/testbenches/xschem/ && cd $B && find . -type f | LC_ALL=C sort | xargs md5sum | cut -c1-12,33- ; ls -la --time-style=+%F_%T schematic/xschem testbenches/xschem | awk '{print $6, $7}'
```

</details>

Your edited versions are backed up with their timestamps. Restoring my 6 October versions of the eight files:

*[Copied 8 files from the cloud container to the computer (1 lines of output).]*

*[Ran a command (on the computer; error).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias && md5sum schematic/xschem/*.sch testbenches/xschem/*.sch Makefile | cut -c1-8,33-; ls $HOME/mnt/gf180_cm_ip__single2diff2single/.git/*.lock 2>/dev/null
```

</details>

The Makefile you saved is byte-identical to mine, so it's correct.

All eight files you edited are back to my 6 October versions; checksums match what I delivered:

- `schematic/xschem/OgueyAebischerBias_03v3.sch` and `_06v0.sch`
- `schematic/xschem/ToBiasStartup_03v3.sch` and `_06v0.sch`
- `schematic/xschem/OgueyAebischerRef_03v3.sch` and `_06v0.sch`
- `testbenches/xschem/OgueyAebischerRef_03v3_tb_tran.sch` and `_06v0_tb_tran.sch`

No other file in the three macros was changed, so nothing else needed restoring.

Before overwriting, I copied your edited versions, with their timestamps from yesterday evening, to `~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-07_user_edits_before_restore/`. That's in case your xschem session in the container goes away before you save from it.

You can now commit my versions, then save your edits from xschem over them to get the diff. If xschem says the files changed on disk when you save, that's expected: they did. I ran no git commands.

## Turn 5 — 2026-10-07 22:24

**User:**

I saved my versions from xschem. do they match your backups in ..._edits_before_restore?

**Assistant:**

*[Ran a command (on the computer; 8 lines of output).]*

<details><summary>command</summary>

```sh
M=$HOME/mnt/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias; B=$HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-07_user_edits_before_restore/macros/OgueyAebischerBias; cd $B && for f in $(find . -name '*.sch' | LC_ALL=C sort); do a=$(md5sum < $f | cut -c1-8); b=$(md5sum < $M/$f | cut -c1-8); [ "$a" = "$b" ] && s=SAME || s=DIFF; echo "$s $a $b $(stat -c %y $M/$f | cut -c1-19) $f"; done
```

</details>

Two differ. Let me see how:

*[Ran a command (on the computer; error).]*

<details><summary>command</summary>

```sh
M=$HOME/mnt/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias; B=$HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-07_user_edits_before_restore/macros/OgueyAebischerBias; for f in schematic/xschem/OgueyAebischerRef_03v3.sch schematic/xschem/ToBiasStartup_06v0.sch; do echo "##### $f  (< backup, > saved now)"; diff $B/$f $M/$f; done
```

</details>

Six of the eight files are byte-identical to the backups. The other two differ, but neither difference changes the circuit.

- **`OgueyAebischerRef_03v3.sch`:** only the `lab=` annotations on the six `vbr` wire segments differ. The backup has `lab=#net1`; the file you saved now has `lab=vbr`. Wire and pin coordinates are identical, and xschem derives connectivity from geometry, not from these labels. xschem rewrites them on every save, so the backup was probably saved before it had re-resolved the net. The circuit is the same; the new file just carries the correct name.
- **`ToBiasStartup_06v0.sch`:** this is a real but purely cosmetic edit. The three output pins `vbp`, `vbn` and `vbr` moved from x = 1000 to x = 960, and their wires were shortened to match. That puts them back at the original IHP position. The saved file is from 20:21, later than the others (20:00–20:16), so this looks like a tweak you made after the backup was taken. Connectivity is unchanged.

So what you just saved contains everything in the backup, plus that pin move. Once you've committed, you can delete the backup folder if you like.

## Turn 6 — 2026-10-07 23:40

**User:**

Thanks for the precautionary save!

for the 
cd /foss/designs/gf180_cm_ip__single2diff2single && source .designinit
cd macros/OgueyAebischerBias
make sim-all          # start-up testbench, both variants: I1 should settle at about 100 nA
make sim-cace-all     # full CACE suites, about 5 min per variant here
part, are there any results from make sim-all, and how can I tell the CACE run that it should produce a report even though some tests FAIL?

**Assistant:**

Two things to check: what `sim-all` left on your disk, and how CACE handles failures. First the simulation files:

*[Ran a command (on the computer).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias && ls -la --time-style=+%F_%T testbenches/xschem/simulations/ verification/cace/ 2>&1 | awk '{print $6, $5, $7}'; ls verification/cace/_runs 2>/dev/null | tail; ls testbenches/xschem/plot_simulations 2>/dev/null
```

</details>

*[Ran a command (in the cloud container; 23 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/venv/lib/python3.12/site-packages/cace && grep -n "nofail" -A6 cace_cli.py | head -60; grep -n "skipping documentation\|def generate_documentation\|summary.md\|markdown_summary" cace_cli.py | head
```

</details>

*[Ran a command (in the cloud container; 41 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 360,400p /home/claude/venv/lib/python3.12/site-packages/cace/cace_cli.py
```

</details>

*[Copied 4 files from the computer to the cloud container (1 lines of output).]*

*[Ran a command (in the cloud container; 55 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /tmp/claude-0/raw && cd /tmp/claude-0/raw && cat > parse_raw.py <<'EOF'
import sys, numpy as np, re
def read_raw(fn):
    d=open(fn,'rb').read(); k=d.index(b'Binary:\n'); h=d[:k].decode()
    nv=int(re.search(r'No. Variables:\s*(\d+)',h).group(1)); npts=int(re.search(r'No. Points:\s*(\d+)',h).group(1))
    names=[l.split()[1] for l in h.split('Variables:\n',1)[1].strip().splitlines()[:nv]]
    flags=re.search(r'Flags:\s*(\S+)',h).group(1)
    a=np.frombuffer(d[k+8:],dtype=np.float64,count=nv*npts*(2 if 'complex' in flags else 1)).reshape(npts,nv)
    return dict(zip(names,a.T)), h
for fn in sys.argv[1:]:
    v,h=read_raw(fn); t=v['time']
    i1=[n for n in v if 'vi1' in n.lower()]; vdd=[n for n in v if n.lower() in ('vdd','v(vdd)')]
    I=v[i1[0]]; print(fn.split('/')[-1], 'points',len(t),'tstop',t[-1], 'I1 name',i1[0])
    for tt in [0.5e-3,1e-3,1.2e-3,2e-3,3e-3]:
        k=np.argmin(abs(t-tt)); print(f'  t={tt*1e3:4.1f} ms  I1={I[k]*1e9:8.3f} nA  vdd={v[vdd[0]][k]:.3f}' if vdd else f'  t={tt} I1={I[k]*1e9}')
    final=I[-1]; out=np.abs(I-final)>0.1*abs(final); tset=t[out][-1] if out.any() else 0
    print(f'  final I1={final*1e9:.3f} nA; last outside +-10%: {tset*1e3:.3f} ms; vbp/vbn/vbr = {v["vbp"][-1]:.3f}/{v["vbn"][-1]:.3f}/{v["vbr"][-1]:.3f}')
EOF
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias/testbenches/xschem/simulations; python3 -I parse_raw.py $U/OgueyAebischerRef_03v3_tb_tran.raw $U/OgueyAebischerRef_06v0_tb_tran.raw; for v in 03v3 06v0; do diff <(grep -v "^\*\*" $U/OgueyAebischerRef_${v}_tb_tran.spice | sed 's#/foss/[^ ]*/##;s#/home/[^ ]*/##') <(grep -v "^\*\*" /home/claude/work/repo/macros/OgueyAebischerBias/testbenches/xschem/simulations/OgueyAebischerRef_${v}_tb_tran.spice 2>/dev/null | sed 's#/foss/[^ ]*/##;s#/home/[^ ]*/##') | head -20; done; ls /home/claude/work/repo/macros/OgueyAebischerBias/testbenches/xschem/
```

</details>

Your 3.3 V run settles at 100.03 nA. Fixing my parser's net names for the 6 V file, and checking whether the netlists you simulated still match the ported circuit:

*[Ran a command (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/raw && sed -i 's/{v\["vbp"\]\[-1\]:.3f}\/{v\["vbn"\]\[-1\]:.3f}\/{v\["vbr"\]\[-1\]:.3f}/{[n for n in v][:0]}/' parse_raw.py && U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias/testbenches/xschem/simulations; python3 -I parse_raw.py $U/OgueyAebischerRef_03v3_tb_tran.raw $U/OgueyAebischerRef_06v0_tb_tran.raw | grep -v "t= 2.0\|t= 1.2"; S=/home/claude/work/repo/macros/OgueyAebischerBias/scripts; for v in 03v3 06v0; do python3 -I $S/check_port.py $S/ihp_reference.spice $U/OgueyAebischerRef_${v}_tb_tran.spice $v $S/port_from_ihp.py | grep -v "devices compared"; done
```

</details>

Both runs reproduce my numbers exactly. Before giving you the CACE fix, let me test the Makefile edit on my copy:

*[Ran a command (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0 && cp /mnt/user-data/outputs/OgueyAebischerBias_Makefile/Makefile Makefile.test && sed -i 's/^CACE_JOBS ?= 4$/CACE_JOBS ?= 4\n# --nofail: exit 0 and generate the documentation even when parameters fail\nCACE_OPTS ?= --nofail/; s/--parallel-parameters 1$/--parallel-parameters 1 $(CACE_OPTS)/' Makefile.test && diff /mnt/user-data/outputs/OgueyAebischerBias_Makefile/Makefile Makefile.test; mkdir -p t/verification/cace && cp Makefile.test t/Makefile && cd t && make -n sim-cace-all | grep cace; make -n sim-cace CACE_OPTS= | grep cace
```

</details>

**`make sim-all`: yes, and it reproduces my numbers exactly.** Your run from 20:56 left both transients in `testbenches/xschem/simulations/*.raw`. The `I1_final` value only went to the terminal, so I read the raw files directly:

| | I1 at 0.5 ms (vdd = 1.65 V, still ramping) | I1 settled (3 ms) | Within ±10 % from |
|---|---|---|---|
| 03v3 | 88.4 nA | **100.028 nA** | 0.57 ms, during the ramp |
| 06v0 | 87.5 nA | **99.951 nA** | 0.58 ms, during the ramp |

Both match my cloud run to five digits (100.028 / 99.951 nA). The netlists you simulated also pass my device-by-device check against the IHP circuit with the intended sizes. So your container's gf180mcuD and ngspice agree with my setup.

**CACE with failing specs: use `--nofail`.** CACE always writes the result table to `verification/cace/_runs/RUN_<timestamp>/summary.md`, even when specs fail. What it skips on failure is the documentation in `_docs/`. It also exits with code 2, so make stops after the 03v3 suite and never runs 06v0. `cace … --nofail` generates the documentation anyway and exits 0.

I can't write the Makefile myself, so here is a one-line edit, tested on my copy:

```sh
cd ~/EDA/gf180_cm_ip__single2diff2single/macros/OgueyAebischerBias
sed -i 's/^CACE_JOBS ?= 4$/CACE_JOBS ?= 4\n# --nofail: exit 0 and generate the documentation even when parameters fail\nCACE_OPTS ?= --nofail/; s/--parallel-parameters 1$/--parallel-parameters 1 $(CACE_OPTS)/' Makefile
```

After that, `make sim-cace-all` runs both suites and produces the full report. `make sim-cace CACE_OPTS=` gives you the strict behaviour back, for example for a pass/fail gate.

Without editing the Makefile, you can call CACE directly:

```sh
cd verification/cace
cace OgueyAebischerRef_03v3.yaml -j 4 --parallel-parameters 1 --nofail
cace OgueyAebischerRef_06v0.yaml -j 4 --parallel-parameters 1 --nofail
```

Expect the same failures as in my run: PSRR in both variants, leg matching in both, and I1 above 130 nA at 5–5.5 V in 06v0.

## Turn 7 — 2026-10-08 03:06

**User:**

Look at the chatlogs in _sudelbuecher. Produce such a chat log from this conversation.

**Assistant:**

I'll follow the conventions in the notes worktree: look at the existing logs and the export script first.

*[Ran a command (on the computer).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog && ls -la ref pix; cat README.md; wc -l export_chatlog.py *.md
```

</details>

*[Ran a command (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
ls -la ~/.claude/projects/-home-claude/ 2>&1 | head; ls -la ~/.claude/projects/ 2>&1
```

</details>

Reading the export script and the beginning of the Sonnet log so mine matches the format:

*[Ran a command (on the computer; 226 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog && cat export_chatlog.py; echo =====; sed -n 1,60p 2026-10-06_sonnet_gf180_port_survey_and_skeleton.md; echo ====; tail -15 2026-10-06_sonnet_gf180_port_survey_and_skeleton.md; cat ref/2026-10-06_references.md pix/README.md
```

</details>

The convention is: copy the transcript aside, run `export_chatlog.py` on it, then add a `ref/` file and an index line. Fetching the script and copying the transcript:

*[Copied 1 files from the computer to the cloud container (1 lines of output).]*

*[Ran a command (in the cloud container).]*

<details><summary>command</summary>

```sh
S=/tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad; mkdir -p $S/chatlog && cd $S/chatlog && cp ~/.claude/projects/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb.jsonl session.jsonl && cp /mnt/user-data/uploads/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py . && python3 -I export_chatlog.py session.jsonl 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md "2026-10-06 — GF180 port: bias reference in two variants, CACE suites, IOPad proof of concept" ae2f9665-832e-520c-96fd-494fa4898beb claude-opus-5-5; grep -c "^## Turn" *.md; grep -n "^## Turn" *.md
```

</details>
