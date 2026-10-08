<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# 2026-10-06 — GF180 port: bias reference in two variants, CACE suites, IOPad proof of concept; 2026-10-08: class-AB driver, bias and pad enables

Session `ae2f9665-832e-520c-96fd-494fa4898beb`, Claude (configured model `claude-opus-5-5`; the serving model may differ).
Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;
tool calls as `*[ ]*` summaries (actions and observable results only); shell commands verbatim in collapsed blocks, their output omitted.
The internal reasoning trace is not included.
Times are Europe/Berlin. Exported through the record stamped 2026-10-08 22:39; later turns are not in this file.
An automatic context compaction on 2026-10-08 at 19:23 rewrote the transcript: turns 1–7 come from the export made
before it (2026-10-08 03:07), turns 8 onward from the rewritten transcript.

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

## Turn 8 — 2026-10-08 19:22

**User:**

*[This message is reconstructed from the compaction summary, which quoted it; "[y]our" is the summary's bracket, not necessarily the original wording.]*

Even though the class AB buffer amplifier and the bias circuits associated with it are in a temporary place in the IHP process, what about porting these circuits, test setups, and CACE characterization sketch to Global Foundries 180, just as proof-of-concept and smoke test of [y]our schematic drawing and verification flow? In which directories would you store the schematics, test bases, figures, results, logs, and chat log?

**Assistant:**

*[The context was compacted automatically at 19:23. The record of this turn up to that point was replaced by a summary, which is not exported; the turn continues below.]*

*[Ran a command (on the computer; 92 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver && ls; ls net xschem | head -40; for f in net/*.spice improvements/sim/*.spice; do printf "%s %s\n" "$(grep -ciE '^[mx].*sg13' $f)" $f; done 2>/dev/null | head -30; grep -E '^#|^## ' improvements/log.md | head -40; grep -c 'parameter\|- name' verification/cace/d2s_miller_biased.yaml; echo ---; ls $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher; ls $HOME/mnt/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadDiff2Single
```

</details>

*[Ran a command (on the computer; 130 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver && ls -la port_gf180 power_down | head -40; find port_gf180 -type f | head -40; for f in port_gf180/*.md; do echo "== $f"; head -60 "$f"; done; head -30 power_down/*.md 2>/dev/null | head -50; grep -cE '^[mM]' d2s_miller.spice d2s_bias.spice d2s_loadcomp.spice; ls $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/esd_protection
```

</details>

*[Ran a command (on the computer; refused by the user).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver && sed -n 60,200p port_gf180/kickoff_port_gf180.md; echo ----; ls build_verification_suite; ls improvements/sim improvements/sim/tb 2>/dev/null | head -50; cat $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/README.md | head -40; ls $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/esd_protection $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/logs
```

</details>

*[Request interrupted by user for tool use]*

## Turn 9 — 2026-10-08 19:24

**User:**

I'm not too happy where the IHP circuits ended up.

**Assistant:**

Understood, I've stopped. Nothing has been written for this request yet.

Here's what I found before you stopped me. All of the class-AB work lives in the IHP notes worktree, under `sudelbuecher/design_considerations/class_ab_pad_driver/`. Inside that folder, the original driver, `improvements/` (which now holds the real design: d2s_mpdda, the bias variants, `figures/`, `log.md`), `power_down/` and a `port_gf180/` that so far holds only your kickoff file are all side by side. Schematics, simulations, figures and notes are mixed together, and none of it is in the main repo. Your kickoff also says to write the GF180 port into that IHP `port_gf180/` folder. I wouldn't do that unless you say so.

For GF180, I'd keep design and notes apart, the way OgueyAebischerBias is already laid out:

- **Main repo `gf180_cm_ip__single2diff2single`:**
  - Driver: `macros/gf180mcu_IOPadDiff2Single/`. That folder already exists with the port-only placeholder, and the driver is what goes in it.
    - `schematic/xschem/`: d2s_mpdda, units, Miller caps
    - `testbenches/xschem/`: step, loop, dc, thd, noise, op
    - `verification/cace/`: yaml, templates and `results/`, with the CACE plots there
    - `scripts/`
    - a `README.md` with the results table
  - Bias variants: a separate macro, `macros/ClassABBias/` (name open), laid out the same way, because the bias feeds the driver rather than being part of it.
  - Schematic renders: `render/img/`.
- **GF180 notes worktree `_sudelbuecher/sudelbuecher/`:**
  - Run logs: `logs/main/`.
  - Chat log: `chatlog/`, with `ref/` and `pix/`.
  - A running `log.md` for the design reasoning, but no schematics or decks there.

The IHP tree stays untouched. I'd only read from it.

What bothers you most about the IHP placement: that the working design sits in the notes branch rather than the repo, how it's split across improvements/power_down/port_gf180, or something else? Tell me and I'll adjust the layout before I start the port.

## Turn 10 — 2026-10-08 19:33

**User:**

Eventually, all the schematics should be macros in the hierarchy. It's rather obvious that the bias circuits should be separate macros, with their own verification suites, because the bias circuits can be simulated stand-alone.
The ClassAB pad driver could be a macro, but maybe to be characterized in conjunction with a bias circuit. In terms of macro hierarchy, the problem is that the circuit should in part or in its entirety get laid out in custom analog pads, not in the slot as intended by Chipalooza. The analog input and output pads need enable circuits. It probably makes sense to put the enable circuitry into its own sub-macro, unlike the evolved design considerations in the IHP version.

**Assistant:**

Agreed. Here's the hierarchy I'd use for GF180. Every macro gets the OgueyAebischerBias layout: `schematic/xschem`, `testbenches/xschem`, `verification/cace` with `results/`, `scripts`, `README.md`.

**Bias macros, each stand-alone with its own CACE suite**
- `OgueyAebischerBias`: already exists.
- One macro per class-AB bias variant you want to keep (`_in`, `_out`, `_oa`, `_bg`).
- The diode replicas (`d2s_bias_diodes`) as a shared sub-macro, because every variant uses them.
- The ideal fixture (`d2s_bias_lp`) stays a testbench part, not a macro.

**`ClassABDriver`**
- The core: d2s_mpdda with its DDA units and Miller caps. No pads and no enable.
- Its CACE suite runs it twice:
  - with the ideal fixture, so driver specs are judged on their own;
  - with a real bias macro, as a combined deck like the `d2s_miller_biased` wrapper in IHP.
- That way a failure points at either the driver or the bias.

**`PadEnable`, the enable sub-macro**
- For the output pad: enable logic, and the gate clamps that turn OP/ON into ESD clamps when the pad is disabled.
- For the input pad: the matching switch-off for `IOPadSingle2Diff`.
- Own testbench: enable/disable timing, disabled leakage, and the clamp state during an ESD-like pulse.
- One GF180 point helps here: the logic can run on the same 3.3 V (or 5 V) supply as the analog. So the 1.2 V → 3.3 V level shifter that was still open on IHP may simply disappear.

**Pad macros, the layout targets**
- `gf180mcu_IOPadSingle2Diff` and `gf180mcu_IOPadDiff2Single` both exist already. They become the cells that instantiate front end or driver, `PadEnable`, ESD and the CDM resistor.
- They're meant to be drawn as custom cells in the `gf180mcu_ocd_io` pad ring, not in the Chipalooza slot. The pad-level CACE suites test the whole thing through the pad.

Figures, logs and the chat log go where I said before:
- schematic renders in `render/img/`;
- CACE plots in each macro's `verification/cace/results/`;
- run logs in `_sudelbuecher/sudelbuecher/logs/main/`;
- the chat log in `_sudelbuecher/sudelbuecher/chatlog/`.

The IHP tree stays read-only.

I'd start with the diode sub-macro and one bias variant, re-sized for GF180 with its own CACE suite, because it doesn't depend on any open hierarchy decision. Then `ClassABDriver` on the ideal fixture, then `PadEnable`, then the pad wrappers.

One thing decides how the pad macros are cut: should each pad get its own bias, inside the pad cell, or should one bias macro sit outside and feed both pads through routed bias lines?

## Turn 11 — 2026-10-08 19:46

**User:**

Ok, do it! This will give us a macro hierarchy to work with (and to tweak), and to remigrate to the IHP design once we've figured out the details in the GF180 repo.
Ich lasse bitten ...

**Assistant:**

Starting now. Order of work: the diode replicas and the bias variants first, then the driver core on the ideal fixture, then the enable sub-macro, then the two pad wrappers. Each gets its own macro folder in the GF180 repo. Sources are read from the IHP tree and never written to.

*[Called ToolSearch (0 lines of output).  
Loaded skill "anthropic-skills:xschem-analog-schematic".  
Created task "Read IHP class-AB sources (bias, driver, power-down)".  
Created task "Bias macros: diode replicas + bias variants, re-sized for GF180, CACE each".  
Created task "ClassABDriver macro (d2s_mpdda core), testbenches, CACE with ideal and real bias".  
Created task "PadEnable sub-macro and pad wrappers (IOPadDiff2Single, IOPadSingle2Diff)".  
Created task "Deliver to device, update docs/README/handover, logs and chat log; verify".]*

*[Ran a command (on the computer; 63 lines of output).]*

<details><summary>command</summary>

```sh
ls $HOME/mnt; cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver && wc -c port_gf180/kickoff_port_gf180.md improvements/bias.md improvements/log.md improvements/xschem/README.md improvements/sim/* power_down/log.md 2>/dev/null; ls improvements/sim/tb power_down/sim power_down/xschem build_verification_suite
```

</details>

*[Ran a command (on the computer; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver && pwd -P; readlink -f $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher
```

</details>

*[Copied 19 files from the computer to the cloud container (1 lines of output).]*

*[Read the GF180 kickoff and bias notes (in the cloud container; 269 lines of output).]*

<details><summary>command</summary>

```sh
S=/mnt/user-data/uploads/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver; ln -sfn $S /home/claude/ihpab; cat $S/port_gf180/kickoff_port_gf180.md | sed -n 55,200p; cat $S/improvements/bias.md
```

</details>

*[Read IHP bias and driver netlists, check tools (in the cloud container; 249 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/sim; cat d2s_bias_ref.spice d2s_bias_lp.spice d2s_mpdda.spice units.spice ccomp.spice; which ngspice xschem; ls /opt/xschem/bin /home/claude/pdk/gf180mcuD/libs.tech 2>&1 | head
```

</details>

*[Read power-down design log and netlists (in the cloud container; 329 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/power_down; sed -n 1,400p log.md; cat sim/d2s_mpdda_pd.spice; diff <(sed 's/ *$//' ../improvements/sim/d2s_bias_ref.spice) sim/d2s_bias_ref_pd.spice | head -120
```

</details>

*[Review earlier IHP→GF180 schematic porting script (in the cloud container; 208 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/scripts; wc -l *; sed -n 1,200p port_from_ihp.py
```

</details>

*[Ran a command (on the computer; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver; ls improvements/xschem/*.sch improvements/xschem/*.sym improvements/xschem/xschemrc improvements/sim/tb/*.spice verification/cace/*.yaml verification/cace/templates/* verification/cace/scripts/* | sed 's|^|~/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/|' | python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))"
```

</details>

*[Copied 36 files from the computer to the cloud container (1 lines of output).]*

*[Read xschem README and testbench decks (in the cloud container; 343 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements; sed -n 1,200p xschem/README.md; cat sim/tb/tb_mpdda_loop.spice sim/tb/tb_mpdda_dc.spice sim/tb/tb_mpdda_step.spice
```

</details>

*[List GF180 symbols and resistor/cap/pnp models (in the cloud container; 98 lines of output).]*

<details><summary>command</summary>

```sh
P=/home/claude/pdk/gf180mcuD/libs.tech; ls $P/xschem/symbols | head -80; ls $P/ngspice; grep -n "^\.subckt\|^\.SUBCKT" $P/ngspice/sm141064.ngspice | grep -i "ppoly\|pnp\|mim\|cap_" | head -30
```

</details>

*[Inspect high-R poly models and symbols (in the cloud container; 102 lines of output).]*

<details><summary>command</summary>

```sh
P=/home/claude/pdk/gf180mcuD/libs.tech; sed -n 38782,38812p $P/ngspice/sm141064.ngspice; sed -n 38906,38930p $P/ngspice/sm141064.ngspice; grep -n "rsh_ppolyf_u_1k\b\|rsh_ppolyf_u_3k\b\|rsh_ppolyf_u_2k\b" $P/ngspice/sm141064.ngspice | head; cat $P/xschem/symbols/ppolyf_u_3k.sym | head -30; cat $P/xschem/symbols/pnp_05p00x05p00.sym | grep -E "^K|^B 5|format|template"
```

</details>

*[Read pin geometry for needed GF180 symbols (in the cloud container; 32 lines of output).]*

<details><summary>command</summary>

```sh
P=/home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols; for s in ppolyf_u_3k ppolyf_u_1k pfet_03v3 nfet_03v3 cap_mim_2f0fF cap_pmos_03v3; do echo "== $s"; grep -E "^B 5|format=" $P/$s.sym; done; grep -n "nfet_03v3\b" -A3 /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | grep -i "wmax\|lmax\|wmin\|lmin" | sort -u | head
```

</details>

*[Ran a command (on the computer; 87 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && ls; ls macros macros/*; ls scripts 2>/dev/null; find . -newer macros/OgueyAebischerBias/Makefile -type f -not -path './.git/*' | head -30; cat macros/gf180mcu_IOPadDiff2Single/README.md | head -30
```

</details>

*[Request interrupted by user]*

## Turn 12 — 2026-10-08 19:50

**User:**

While you're at it, update the logs from time to time, to preempt compaction.

**Assistant:**

*[Ran a command (on the computer; 22 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && ls logs logs/main chatlog; head -5 MANIFEST.tsv; tail -3 MANIFEST.tsv
```

</details>

*[Write first running-log entry (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /mnt/user-data/outputs/log1 && cat > /mnt/user-data/outputs/log1/2026-10-08_opus_classab_port_log.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Running log — class-AB pad driver, its bias and the pad enables, IHP → GF180 (proof of concept)

Session ae2f9665 (continued), Claude (configured model `claude-opus-5-5`; the serving model may differ).
Newest entries at the bottom. Times are Europe/Berlin. Written to preempt context compaction; the
chat log of the session is `../../chatlog/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md`.

## 2026-10-08 19:46 — task and decisions (Christoph)

Task: port the IHP class-AB buffer (d2s_mpdda), its bias circuits, test setups and CACE sketch to GF180
as a proof of concept and smoke test of the schematic and verification flow. Re-migrate to IHP later.

Hierarchy (agreed 19:33–19:46):

- Every schematic becomes a macro in the hierarchy of the main repo `gf180_cm_ip__single2diff2single`.
- Bias circuits: separate macros, each with its own verification suite (they simulate stand-alone).
- Class-AB driver: a macro, characterized with an ideal bias fixture and with a real bias macro.
- The driver may end up (partly or whole) in custom analog pads, not in the Chipalooza slot.
- Analog input and output pads need enable circuits: the enable goes into its own sub-macro, unlike
  the IHP `power_down/` cells where the switches are spread through every cell.

Where things go:

- Main repo: `macros/<Macro>/{schematic/xschem, testbenches/xschem, verification/cace(+results), scripts, README.md}`,
  laid out like `macros/OgueyAebischerBias`. Schematic renders in `render/img/`.
- Notes worktree: this log and tool output in `sudelbuecher/logs/main/`, the chat log in `sudelbuecher/chatlog/`.
- IHP trees are read only.

## 19:50 — sources read (indexed, not copied)

IHP notes worktree `sudelbuecher/design_considerations/class_ab_pad_driver/`:

- `port_gf180/kickoff_port_gf180.md` (2026-10-06): scope defaults (03v3 devices at 3.3 V; in: diodes, the
  four bias variants, d2s_bias_lp, d2s_mpdda with units and Miller caps), re-derive sizes, PDK facts.
- `improvements/bias.md`, `improvements/xschem/README.md`, `improvements/sim/{d2s_bias_ref,d2s_bias_lp,d2s_mpdda,units,ccomp}.spice`,
  `improvements/sim/tb/tb_mpdda_{dc,loop,step,thd,noise,op}.spice`, `run_bias.py`, results files.
- `power_down/log.md`, `power_down/sim/{d2s_mpdda_pd,d2s_bias_ref_pd}.spice` (switch plan for the enable).
- `verification/cace/d2s_miller_biased.yaml` and templates (the original driver's CACE draft).

Targets carried over: bias currents 5 / 5 / 2 / 2 / 5 / 5 µA (vbp vbn vbpc vbnc vabp vabn), I_Q ≈ 212 µA,
loop T0 ≈ 79 dB / f_c ≈ 1.4 MHz / PM ≈ 72° into 1 kΩ ∥ 100 pF, gain −6 dB (vout − vref = (vinp − vinn)/2).

## 19:55 — plan

Order: diode replicas and bias macros → driver core on the ideal fixture → enable sub-macro → pad wrappers.
Device family 03v3 (kickoff default; 5 V not decided). IHP sheets are hand drawn; the GF180 FET symbols have
the IHP pin geometry, so the sheets are ported by symbol and property substitution (as `OgueyAebischerBias`),
resistors and capacitors re-drawn where their pins differ.
EOF
echo ok
```

</details>

*[Copied 1 files from the cloud container to the computer (1 lines of output).]*

*[Check model include lines from earlier port (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias; grep -rn "\.lib\|\.include\|spiceinit" verification/cace/templates/*03v3*dc* testbenches/xschem/*03v3*.sch | head; ls /home/claude/pdk/gf180mcuD/libs.tech/ngspice/; cat ~/.spiceinit 2>/dev/null; echo $PDK_ROOT
```

</details>

*[Check GF180 FET instance form in netlist (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias; head -20 verification/cace/netlist/schematic/OgueyAebischerRef_03v3.spice; grep -n "subckt nfet_03v3\|model nfet_03v3\|subckt pfet_03v3" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/*.ngspice | head
```

</details>

*[Extract bin limits for 03v3 FET models (in the cloud container; 40 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice; awk '/^.model (nfet|pfet)_03v3\.[0-9]+ /{m=$2} m && /[lw]m(in|ax) *=/{for(i=1;i<=NF;i++) if($i~/^[lw]m(in|ax)/ || $(i)=="=") ; print m, $0; } /^\.model/ && !/03v3/{m=""}' sm141064.ngspice | grep -oE "^\S+|[lw]m(in|ax) *= *[0-9.e-]+" | paste -sd' ' | sed 's/ \(nfet\|pfet\)/\n\1/g' | sort -u | head -40
```

</details>

*[Test whether W per finger binning works (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/classab/sim && cd /home/claude/work/classab/sim && cat > bintest.sp <<'EOF'
* bin test
.include /home/claude/pdk/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
V1 d 0 3.3
V2 g 0 1.2
XM1 d g 0 0 nfet_03v3 L=1u W=400u nf=40
XM2 d g 0 0 nfet_03v3 L=1u W=10u nf=1
.control
op
print -@n.xm1.m0[id] @n.xm2.m0[id]
.endc
.end
EOF
ngspice -b bintest.sp 2>&1 | tail -8; grep -n "subckt nfet_03v3 \|subckt pfet_03v3 " /home/claude/pdk/gf180mcuD/libs.tech/ngspice/*.ngspice
```

</details>

*[Baseline GF180 transliteration of driver, run OP and loop (in the cloud container; 23 lines of output).]*

<details><summary>command</summary>

```sh
cat > units_gf.spice <<'EOF'
* unit_r2 for GF180 03v3: split-tail PMOS pair, ppolyf_u_3k between the sources
.subckt unit_r2 x y gp gn vdd vss vbp rl=50u
XTa sa vbp vdd vdd pfet_03v3 W=5u L=6u nf=1
XTb sb vbp vdd vdd pfet_03v3 W=5u L=6u nf=1
XR sa sb vss ppolyf_u_3k r_width=1u r_length={rl}
XMa y gp sa sa pfet_03v3 W=20u L=1u nf=2
XMb x gn sb sb pfet_03v3 W=20u L=1u nf=2
.ends unit_r2
EOF
cat > bias_lp_gf.spice <<'EOF'
.subckt d2s_bias_lp vdd vss vddo vsso vbp vbn vbpc vbnc vabp vabn iab=5u ibnc=2u
IBP vbp vss 5u
XBP vbp vbp vdd vdd pfet_03v3 W=5u L=6u nf=1
IBN vdd vbn 5u
XBN vbn vbn vss vss nfet_03v3 W=6u L=6u nf=1
IBNC vdd vbnc {ibnc}
XBNC vbnc vbnc vss vss nfet_03v3 W=1u L=8u nf=1
IBPC vbpc vss 2u
XBPC vbpc vbpc vdd vdd pfet_03v3 W=1u L=4u nf=1
IABP vabp vss {iab}
XRP1 n1 n1 vddo vddo pfet_03v3 W=13.32u L=0.6u nf=2
XRP2 vabp vabp n1 vdd pfet_03v3 W=6.66u L=0.6u nf=1
IABN vdd vabn {iab}
XRN1 n2 n2 vsso vsso nfet_03v3 W=8.8u L=1u nf=2
XRN2 vabn vabn n2 vss nfet_03v3 W=4.4u L=1u nf=1
.ends d2s_bias_lp
EOF
cat > mpdda_gf.spice <<'EOF'
.subckt d2s_mpdda vdd vss vddo vsso vinp vinn vref vout vfb vbp vbn vbpc vbnc vabp vabn wc=16u lc=16u rl=50u
XA x y vinp vref vdd vss vbp unit_r2 rl={rl}
XB x y vref vinn vdd vss vbp unit_r2 rl={rl}
XC1 x y vref vfb vdd vss vbp unit_r2 rl={rl}
XC2 x y vref vfb vdd vss vbp unit_r2 rl={rl}
XSX x vbn vss vss nfet_03v3 W=36u L=6u nf=4
XSY y vbn vss vss nfet_03v3 W=36u L=6u nf=4
XCX l1 vbnc x vss nfet_03v3 W=30u L=3u nf=2
XCY b vbnc y vss nfet_03v3 W=30u L=3u nf=2
XPL pl l2 vdd vdd pfet_03v3 W=24u L=4u nf=4
XPR pr l2 vdd vdd pfet_03v3 W=24u L=4u nf=4
XPCL l2 vbpc pl vdd pfet_03v3 W=30u L=3u nf=2
XPCR a vbpc pr vdd pfet_03v3 W=30u L=3u nf=2
XFPL l1 vabp l2 vdd pfet_03v3 W=6.66u L=0.6u nf=1
XFNL l2 vabn l1 vss nfet_03v3 W=4.4u L=1u nf=1
XABP b vabp a vdd pfet_03v3 W=6.66u L=0.6u nf=1
XABN a vabn b vss nfet_03v3 W=4.4u L=1u nf=1
XOP vout a vddo vddo pfet_03v3 W=91.02u L=0.6u nf=14 m=6
XON vout b vsso vsso nfet_03v3 W=96.8u L=1u nf=22 m=3
XCMA vout a vout vout pfet_03v3 W={wc} L={lc} nf=1
XCMB b vout b b pfet_03v3 W={wc} L={lc} nf=1
.ends d2s_mpdda
EOF
cat > tb_op.sp <<'EOF'
* GF180 d2s_mpdda op + loop + dc
.include /home/claude/pdk/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.include units_gf.spice
.include bias_lp_gf.spice
.include mpdda_gf.spice
Vdd vdd 0 3.3
Vddo vddo 0 3.3
Vsso vsso 0 0
Vcm vref 0 1.65
Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_lp
Vp vinp 0 1.65
Vn vinn 0 1.65
Xd vdd 0 vddo vsso vinp vinn vref vout fb vbp vbn vbpc vbnc vabp vabn d2s_mpdda
Lb vout fb 1G
Cb fb inj 1
Vinj inj 0 dc 0 ac 1
RL vout vref 1k
CL vout 0 100p
.control
op
print v(vout) v(a) v(b) v(x) v(y) v(l1) v(l2) v(vbp) v(vbn) v(vbpc) v(vbnc) v(vabp) v(vabn)
print @n.xd.xop.m0[id] @n.xd.xon.m0[id] -i(vdd) -i(vddo)
ac dec 50 10 1G
let T=-v(vout)/v(fb)
meas ac T0 find vdb(T) at=10
meas ac fc when vdb(T)=0
meas ac pT find vp(T) when vdb(T)=0
let pm=180/pi*pT+180
print T0 fc pm
.endc
.end
EOF
ngspice -b tb_op.sp 2>&1 | grep -v "^$" | tail -30
```

</details>

*[Print internal OP nodes and find device names (in the cloud container; 23 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/^print v(vout) v(a).*/print v(vout) v(xd.a) v(xd.b) v(xd.x) v(xd.y) v(xd.l1) v(xd.l2) v(vbp) v(vbn) v(vbpc) v(vbnc) v(vabp) v(vabn)/; s/^print @n.xd.xop.*/listing devices\nprint -i(vddo) -i(vdd)/' tb_op.sp && sed -i 's/^listing devices$/show all > devs.txt/' tb_op.sp && ngspice -b tb_op.sp 2>&1 | grep -E "^v\(|^-i|= " | head -30; grep -i "xop" devs.txt | head -5
```

</details>

*[Build GF180 driver harness and run typical and loads (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cat > run_gf.py <<'EOF'
#!/usr/bin/env python3
"""Cloud-only harness: GF180 d2s_mpdda with d2s_bias_lp (ideal fixture). op / dc / loop over corners."""
import subprocess, re, sys, os, itertools, tempfile
PDK = "/home/claude/pdk/gf180mcuD/libs.tech/ngspice"
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
EOF
python3 run_gf.py tt; python3 run_gf.py loads
```

</details>

*[Tune class-AB replica widths for I_Q target (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
for p in "12u 8u" "12.2u 8u" "12u 7.9u"; do set -- $p; sed -e "s/XRP1 n1 n1 vddo vddo pfet_03v3 W=13.32u/XRP1 n1 n1 vddo vddo pfet_03v3 W=$1/" -e "s/XRN1 n2 n2 vsso vsso nfet_03v3 W=8.8u/XRN1 n2 n2 vsso vsso nfet_03v3 W=$2/" bias_lp_gf.spice > bias_lp_try.spice; sed 's/bias_lp_gf.spice/bias_lp_try.spice/' run_gf.py > run_try.py; echo "$p: $(python3 run_try.py tt)"; done
```

</details>

*[Run driver over PVT corners (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cp bias_lp_try.spice /dev/null; sed -i -e "s/XRP1 n1 n1 vddo vddo pfet_03v3 W=13.32u/XRP1 n1 n1 vddo vddo pfet_03v3 W=12u/" -e "s/XRN1 n2 n2 vsso vsso nfet_03v3 W=8.8u/XRN1 n2 n2 vsso vsso nfet_03v3 W=8u/" bias_lp_gf.spice && rm bias_lp_try.spice run_try.py && python3 run_gf.py corners
```

</details>

*[Check saturation margins at ss/−40 °C/3.0 V (in the cloud container; 84 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
import run_gf, subprocess, os, tempfile
t = run_gf.deck(corner="ss", temp=-40, vdd=3.0).replace("Vd dp 0 0", "Vd dp 0 0.2")
ctl = """.control
op
"""
for u in ["xa","xb","xc1","xc2"]:
    for d in ["xta","xma","xtb","xmb"]:
        ctl += f"print @m.xd.{u}.{d}.m0[vds] @m.xd.{u}.{d}.m0[vdsat] @m.xd.{u}.{d}.m0[id]\n"
for d in ["xsx","xsy","xcx","xcy","xpl","xpr","xpcl","xpcr","xabp","xabn","xfpl","xfnl"]:
    ctl += f"print @m.xd.{d}.m0[vds] @m.xd.{d}.m0[vdsat] @m.xd.{d}.m0[id]\n"
ctl += ".endc\n.end\n"
t = t[:t.index(".control")] + ctl
d = tempfile.mkdtemp(); open(d+"/t.sp","w").write(t)
r = subprocess.run(["ngspice","-b","t.sp"],cwd=d,capture_output=True,text=True)
import re
for l in r.stdout.splitlines():
    if "=" in l and "@m" in l: print(l.strip())
EOF
```

</details>

*[Widen DDA tails to fix headroom at ss/cold/3.0 V (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
cp units_gf.spice units_gf.bak; cp bias_lp_gf.spice bias_lp_gf.bak; for w in 10u 15u 20u; do sed "s/pfet_03v3 W=5u L=6u/pfet_03v3 W=$w L=6u/" units_gf.bak > units_gf.spice; sed "s/XBP vbp vbp vdd vdd pfet_03v3 W=5u/XBP vbp vbp vdd vdd pfet_03v3 W=$w/" bias_lp_gf.bak > bias_lp_gf.spice; echo "== $w"; python3 run_gf.py corners | grep -E "^(typical  +27|ss +-40|ss +125|ff +125)"; done
```

</details>

*[Read IHP run_bias.py measurement approach (in the cloud container; 121 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/sim; sed -n 1,120p run_bias.py
```

</details>

*[Check how CACE invokes xschem rcfile (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/venv/lib/python3.12/site-packages/cace; grep -rn "rcfile\|xschemrc" --include=*.py . | head -20
```

</details>

*[Find CACE DUT netlisting invocation (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/venv/lib/python3.12/site-packages/cace; grep -rn "xschem" --include=*.py common/*.py cace_*.py */*.py | grep -v "^parameter/parameter_ngspice.py:49[0-9]" | grep -i "rcfile\|tcl\|args\|subprocess\|netlist" | head -20
```

</details>

*[Read CACE xschem path handling (in the cloud container; 45 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/venv/lib/python3.12/site-packages/cace; sed -n 575,620p common/cace_regenerate.py; grep -n "def set_xschem_paths" -A40 common/cace_regenerate.py | head -50
```

</details>

*[Write GF180 bias in/out netlists and check current accuracy (in the cloud container; 32 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/classab/sim && rm -f units_gf.bak bias_lp_gf.bak && sed -i 's/XTa sa vbp vdd vdd pfet_03v3 W=20u L=6u nf=1/XTa sa vbp vdd vdd pfet_03v3 W=20u L=6u nf=2/; s/XTb sb vbp vdd vdd pfet_03v3 W=20u L=6u nf=1/XTb sb vbp vdd vdd pfet_03v3 W=20u L=6u nf=2/' units_gf.spice && sed -i 's/XBP vbp vbp vdd vdd pfet_03v3 W=20u L=6u nf=1/XBP vbp vbp vdd vdd pfet_03v3 W=20u L=6u nf=2/' bias_lp_gf.spice && cat units_gf.spice bias_lp_gf.spice | grep -E "XT|XBP|XRP1|XRN1" && cat > bias_ref_gf.spice <<'EOF'
* GF180 03v3 port of d2s_bias_ref.spice (diodes, in, out); sizes re-derived 2026-10-08
.subckt d2s_bias_diodes vdd vss vddo vsso vbp vbn vbpc vbnc vabp vabn
XBP vbp vbp vdd vdd pfet_03v3 W=20u L=6u nf=2
XBN vbn vbn vss vss nfet_03v3 W=6u L=6u nf=1
XBNC vbnc vbnc vss vss nfet_03v3 W=1u L=8u nf=1
XBPC vbpc vbpc vdd vdd pfet_03v3 W=1u L=4u nf=1
XRP1 n1 n1 vddo vddo pfet_03v3 W=12u L=0.6u nf=2
XRP2 vabp vabp n1 vdd pfet_03v3 W=6.66u L=0.6u nf=1
XRN1 n2 n2 vsso vsso nfet_03v3 W=8u L=1u nf=2
XRN2 vabn vabn n2 vss nfet_03v3 W=4.4u L=1u nf=1
.ends d2s_bias_diodes
.subckt d2s_bias_in vdd vss vddo vsso iref vbp vbn vbpc vbnc vabp vabn
XNI iref iref vss vss nfet_03v3 W=6u L=6u nf=1
XNBP vbp iref vss vss nfet_03v3 W=6u L=6u nf=1
XNBPC vbpc iref vss vss nfet_03v3 W=2.4u L=6u nf=1
XNABP vabp iref vss vss nfet_03v3 W=6u L=6u nf=1
XPBN vbn vbp vdd vdd pfet_03v3 W=20u L=6u nf=2
XPBNC vbnc vbp vdd vdd pfet_03v3 W=8u L=6u nf=1
XPABN vabn vbp vdd vdd pfet_03v3 W=20u L=6u nf=2
Xd vdd vss vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_diodes
.ends d2s_bias_in
.subckt d2s_bias_out vdd vss vddo vsso iref vbp vbn vbpc vbnc vabp vabn
XPI iref iref vdd vdd pfet_03v3 W=20u L=6u nf=2
XPBN vbn iref vdd vdd pfet_03v3 W=20u L=6u nf=2
XPBNC vbnc iref vdd vdd pfet_03v3 W=8u L=6u nf=1
XPABN vabn iref vdd vdd pfet_03v3 W=20u L=6u nf=2
XNBP vbp vbn vss vss nfet_03v3 W=6u L=6u nf=1
XNBPC vbpc vbn vss vss nfet_03v3 W=2.4u L=6u nf=1
XNABP vabp vbn vss vss nfet_03v3 W=6u L=6u nf=1
Xd vdd vss vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_diodes
.ends d2s_bias_out
EOF
cat > run_bias_gf.py <<'EOF'
#!/usr/bin/env python3
"""Cloud-only: bias currents of the GF180 bias variants (sensed in the diode drains)."""
import re, subprocess, tempfile, os, sys
PDK = "/home/claude/pdk/gf180mcuD/libs.tech/ngspice"
HERE = os.path.dirname(os.path.abspath(__file__))
NOM = {'bp': 5e-6, 'bn': 5e-6, 'bnc': 2e-6, 'bpc': 2e-6, 'abp': 5e-6, 'abn': 5e-6}
DRAIN = {'bp': 'XBP', 'bn': 'XBN', 'bnc': 'XBNC', 'bpc': 'XBPC', 'abp': 'XRP2', 'abn': 'XRN2'}
INST = {'in': "Iref 0 iref 5u\nXb vdd 0 vddo vsso iref vbp vbn vbpc vbnc vabp vabn d2s_bias_in",
        'out': "Iref iref 0 5u\nXb vdd 0 vddo vsso iref vbp vbn vbpc vbnc vabp vabn d2s_bias_out",
        'oa': "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_oa",
        'bg': "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bg"}
CORN = [('tt 27C', {}), ('ss 27C', dict(c='ss')), ('ff 27C', dict(c='ff')), ('sf 27C', dict(c='sf')), ('fs 27C', dict(c='fs')),
        ('res ss', dict(r='res_ss')), ('res ff', dict(r='res_ff')),
        ('tt -40C', dict(temp=-40)), ('tt 125C', dict(temp=125)),
        ('ss 3.0V -40C', dict(c='ss', vdd=3.0, temp=-40)), ('ff 3.6V 125C', dict(c='ff', vdd=3.6, temp=125))]
FILES = ['bias_ref_gf.spice']
def src():
    s = ''.join(open(os.path.join(HERE, f)).read() for f in FILES)
    m = re.search(r'\.subckt d2s_bias_diodes.*?\.ends d2s_bias_diodes', s, re.S)
    body = m.group(0)
    for k, dev in DRAIN.items():
        body = re.sub(rf'^{dev} (\S+)', lambda mm: f'Vs{k} {mm.group(1)} s{k} 0\n{dev} s{k}', body, flags=re.M)
    return s.replace(m.group(0), body)
def net(var, c='typical', r='res_typical', temp=27, vdd=3.3, extra=''):
    return (f".include {PDK}/design.ngspice\n.lib {PDK}/sm141064.ngspice {c}\n.lib {PDK}/sm141064.ngspice {r}\n"
            f".lib {PDK}/sm141064.ngspice moscap_typical\n.lib {PDK}/sm141064.ngspice bjt_typical\n.temp {temp}\n" + src() +
            f"Vvdd vdd 0 {vdd}\nVvddo vddo 0 {vdd}\nVvsso vsso 0 0\n" + INST[var] + "\n" + extra)
def sense(var, k):
    return f"i(v.xb.xt.xd.vs{k})" if var in ('oa', 'bg') else f"i(v.xb.xd.vs{k})"
def currents(var, **kw):
    ctl = ".control\nop\n" + ''.join(f"echo R {k} $&{sense(var, k)}\n" for k in NOM) + ".endc\n.end\n"
    d = tempfile.mkdtemp(dir='/tmp'); open(d + '/b.cir', 'w').write('* b\n' + net(var, **kw) + ctl)
    o = subprocess.run(['ngspice', '-b', 'b.cir'], cwd=d, capture_output=True, text=True).stdout
    res = {l.split()[1]: abs(float(l.split()[2])) for l in o.splitlines() if l.startswith('R ')}
    if len(res) < 6: raise RuntimeError(o[-1500:])
    return res
if __name__ == '__main__':
    for var in sys.argv[1:] or ['in', 'out']:
        print(f"-- {var}  % deviation from 5/5/2/2/5/5 uA\n  {'corner':15s}" + ''.join(f"{k:>8}" for k in NOM))
        for name, c in CORN:
            i = currents(var, **c)
            print(f"  {name:15s}" + ''.join(f"{100*(i[k]/NOM[k]-1):8.2f}" for k in NOM))
EOF
python3 run_bias_gf.py in out
```

</details>

*[Fix NBPC width; survey symbols used in IHP sheets (in the cloud container; 24 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/XNBPC vbpc \(\S*\) vss vss nfet_03v3 W=2.4u/XNBPC vbpc \1 vss vss nfet_03v3 W=2.5u/' bias_ref_gf.spice && python3 run_bias_gf.py in | sed -n 1,4p; cd /home/claude/ihpab/improvements/xschem; for f in d2s_mpdda unit_r2 d2s_bias_in d2s_bias_out d2s_bias_lp d2s_mpdda_biased tb_mpdda_dc tb_mpdda_loop tb_mpdda_step tb_mpdda_thd tb_mpdda_noise tb_mpdda_op; do echo "== $f: $(grep -o '^C {[^}]*}' $f.sch | sort | uniq -c | tr '\n' ' ')"; done; cat xschemrc
```

</details>

*[Read IHP unit_r2 sheet and symbol (in the cloud container; 128 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/xschem; cat unit_r2.sch; cat unit_r2.sym | head -40
```

</details>

*[List instance names and symbol pins in IHP sheets (in the cloud container; 57 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/xschem; for f in d2s_mpdda d2s_bias_in d2s_bias_out d2s_bias_lp d2s_mpdda_biased; do echo "== $f: $(grep -oP '^C \{[^}]*\} \S+ \S+ \S+ \S+ \{name=\K\S+' $f.sch | tr '\n' ' ')"; done; cat d2s_mpdda.sym | grep "B 5"; grep "B 5" d2s_bias_in.sym d2s_bias_lp.sym d2s_mpdda_biased.sym
```

</details>

*[Inspect labels in d2s_mpdda sheet (in the cloud container; 35 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/xschem; grep -E "lab_wire|ipin|opin|iopin" d2s_mpdda.sch; grep -E "^T " d2s_mpdda.sch | head; grep -c "" d2s_mpdda.sch
```

</details>

*[Read IHP testbench code blocks (in the cloud container; 50 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/xschem; grep -n "code_shown" -A45 tb_mpdda_dc.sch | head -60; grep -n "code_shown" -A12 tb_mpdda_op.sch | head -60
```

</details>

*[Check OAB testbench code block and xschemrc style (in the cloud container; 139 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/repo/macros/OgueyAebischerBias/testbenches/xschem; grep -n "code" -A8 OgueyAebischerRef_03v3_tb_tran.sch | head -30; cat xschemrc; cat ../../schematic/xschem/xschemrc
```

</details>

*[Survey annotation texts in IHP sheets (in the cloud container; 53 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/ihpab/improvements/xschem; grep -h "^T {" d2s_mpdda.sch d2s_bias_in.sch unit_r2.sch d2s_bias_lp.sch d2s_mpdda_biased.sch tb_mpdda_dc.sch | cut -c1-200 | sort -u | head -60
```

</details>

*[Write class-AB porting script and sizing netlist (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/gf/scripts && cat > /home/claude/work/gf/scripts/port_classab_from_ihp.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""
One-time port of the IHP sg13cmos5l class-AB pad driver sheets (hand-edited xschem drawings in
sg13cmos5l_..._sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem)
to GF180MCU (gf180mcuD, 03v3 devices).

Every wire and instance position of the IHP drawings is kept. The GF180 FET symbols have the
sg13_hv pin geometry (D/S at (20,-+30), G at (-20,0), B at (20,0)); rhigh becomes ppolyf_u_3k
(same P/M pins, plus a bulk pin B at (-20,0), which gets a label with the old body= net).
Sizes are NOT copied: they come from the GF180 sizing netlists (gf180_sizing.spice next to this
script), re-derived on 2026-10-08 by simulation (see the macro READMEs).

After this script has run once, the .sch/.sym files are the source of truth.

Usage: port_classab_from_ihp.py <ihp_xschem_dir> <repo_macros_dir>
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
HDR = "v {xschem version=3.4.8RC file_version=1.3}\n"

# ---------------------------------------------------------------- sizes from the GF180 netlist
def size_tables(path):
    tab, cur = {}, None
    for l in open(path):
        t = l.split()
        if not t: continue
        if t[0].lower() == '.subckt': cur = t[1]; tab[cur] = {}; continue
        if t[0].lower() == '.ends': cur = None; continue
        if cur and t[0][0] in 'Xx' and len(t) > 5 and t[5] in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k'):
            kv = dict(re.findall(r'(\w+)=(\S+)', l))
            tab[cur][t[0][1:]] = dict(model=t[5], **kv)
    return tab

def fet_props(name, d):
    return (f"name={name}\nL={d['L']}\nW={d['W']}\nnf={d.get('nf', 1)}\nm={d.get('m', 1)}\n"
            "ad=\"'int((nf+1)/2) * W/nf * 0.18u'\"\n"
            "pd=\"'2*int((nf+1)/2) * (W/nf + 0.18u)'\"\n"
            "as=\"'int((nf+2)/2) * W/nf * 0.18u'\"\n"
            "ps=\"'2*int((nf+2)/2) * (W/nf + 0.18u)'\"\n"
            "nrd=\"'0.18u / W'\" nrs=\"'0.18u / W'\"\n"
            f"sa=0 sb=0 sd=0\nmodel={d['model']}\nspiceprefix=X\n")

def res_props(name, d):
    return f"name={name}\nW={d['r_width']}\nL={d['r_length']}\nmodel={d['model']}\nspiceprefix=X\nm=1\n"

# ---------------------------------------------------------------- xschem record handling
def split_records(text):
    recs, cur, depth, i = [], "", 0, 0
    while i < len(text):
        c = text[i]
        if c == "\\" and i + 1 < len(text):
            cur += text[i:i + 2]; i += 2; continue
        cur += c
        if c == "{": depth += 1
        elif c == "}": depth -= 1
        elif c == "\n" and depth == 0:
            if cur.strip(): recs.append(cur)
            cur = ""
        i += 1
    if cur.strip(): recs.append(cur)
    return recs

def xform(dx, dy, rot, flip):
    if flip: dx = -dx
    for _ in range(rot % 4): dx, dy = -dy, dx
    return dx, dy

CODE_SUBS = [
    (".lib cornerMOShv.lib mos_tt\n.lib cornerRES.lib res_typ\n.lib cornerCAP.lib cap_typ\n", ""),
    ("@n.xd.xop.nsg13_hv_pmos[ids]", "@m.xd.xop.m0[id]"),
    ("@n.xd.xon.nsg13_hv_nmos[ids]", "@m.xd.xon.m0[id]"),
]
MODELS_BLOCK = ('C {devices/code_shown.sym} %d %d 0 0 {name=MODELS\nonly_toplevel=true\nformat="tcleval( @value )"\n'
                'value="\n.include $::180MCU_MODELS/design.ngspice\n.lib $::180MCU_MODELS/sm141064.ngspice typical\n'
                '.lib $::180MCU_MODELS/sm141064.ngspice res_typical\n.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical\n"}\n')

def code_rewrite(rec):
    for a, b in CODE_SUBS: rec = rec.replace(a, b)
    rec = re.sub(r"@n\.(\S+?)\.nsg13_hv_[np]mos\[ids\]", r"@m.\1.m0[id]", rec)
    rec = re.sub(r"@n\.(\S+?)\.nsg13_hv_[np]mos\[vds\]", r"@m.\1.m0[vds]", rec)
    rec = re.sub(r"@n\.(\S+?)\.nsg13_hv_[np]mos\[vdss\]", r"@m.\1.m0[vdsat]", rec)
    return rec

def port_sch(src, dst, sizes, sym_ren, text_subs, note, extra=""):
    out, models_at = [], None
    for r in split_records(open(src).read()):
        if r.startswith("v {"):
            out.append(HDR); continue
        m = re.match(r"^C \{([^}]*)\} (\S+) (\S+) (\S+) (\S+) \{(.*)\}\s*$", r, re.S)
        if m:
            sym, x, y, rot, flip, props = m.groups()
            base = os.path.basename(sym)
            name = re.search(r"name=([^\s}]+)", props).group(1)
            if base in ("sg13_hv_nmos.sym", "sg13_hv_pmos.sym"):
                d = sizes[name]
                out.append(f"C {{symbols/{d['model']}.sym}} {x} {y} {rot} {flip} {{{fet_props(name, d)}}}\n"); continue
            if base == "rhigh.sym":
                d = sizes[name]
                body = re.search(r"body=(\S+)", props).group(1)
                out.append(f"C {{symbols/{d['model']}.sym}} {x} {y} {rot} {flip} {{{res_props(name, d)}}}\n")
                bx, by = xform(-20, 0, int(rot), int(flip))
                out.append(f"C {{devices/lab_pin.sym}} {int(x)+bx} {int(y)+by} 0 0 {{name=lb_{name} sig_type=std_logic lab={body}}}\n")
                continue
            if base in sym_ren:
                out.append(f"C {{{sym_ren[base]}}} {x} {y} {rot} {flip} {{{props}}}\n"); continue
            if base == "title.sym":
                out.append(f"C {{devices/title.sym}} {x} {y} {rot} {flip} {{name=l1 author=\"Christoph Maier\"}}\n"); continue
            if base == "code_shown.sym":
                models_at = (int(float(x)), int(float(y)))
                out.append(code_rewrite(r if r.endswith("\n") else r + "\n")); continue
        if r.startswith("T {"):
            for a, b in text_subs: r = r.replace(a, b)
        out.append(r if r.endswith("\n") else r + "\n")
    if models_at:
        out.append(MODELS_BLOCK % (models_at[0] + 1100, models_at[1]))
    out.append(note + "\n")
    out.append(extra)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    open(dst, "w").write("".join(out))
    print("wrote", dst)

def port_sym(src, dst, text_subs, extra=""):
    t = open(src).read()
    t = re.sub(r"^v \{[^}]*\}\n", HDR, t)
    for a, b in text_subs: t = t.replace(a, b)
    t = t + extra
    open(dst, "w").write(t)
    print("wrote", dst)

# ---------------------------------------------------------------- the cells
NAMES = [("d2s_mpdda_biased", "ClassABDriverBiased"), ("d2s_mpdda", "ClassABDriver"), ("unit_r2", "ClassABUnitR"),
         ("d2s_bias_lp", "ClassABBiasIdeal"), ("d2s_bias_in", "ClassABBiasIn"), ("d2s_bias_out", "ClassABBiasOut")]
TEXT = NAMES + [
    ("rhigh body = vss", "ppolyf_u_3k bulk = vss"), ("rhigh", "ppolyf_u_3k"),
    ("hv PMOS in accumulation", "pfet_03v3 in accumulation"),
    ("BP 5u/6u", "BP 20u/6u"), ("Ta, Tb (5u/6u", "Ta, Tb (20u/6u"),
    ("RP1 (2 x ABP)", "RP1 (12u/0.6u)"), ("RN1 (2 x ABN)", "RN1 (8u/1u)"),
    ("stacked on a 2x diode", "stacked on RP1 12u/0.6u, RN1 8u/1u"),
    ("rl = 50.6u (in unit_r2.sch)", "R = ppolyf_u_3k 1u x 50u (in ClassABUnitR.sch)"),
    ("frozen .subckt defaults: lcas = 3", "fixed sizes: lcas = 3"),
    ("the DDA units at transistor level: d2s_mpdda_flat.sch; with the bias network: d2s_mpdda_bias_flat.sch; block descriptions: README.md",
     "block descriptions: ../../README.md (IHP original: d2s_mpdda.sch in the IHP notes worktree)"),
    ("DUT and bias from the schematics in this directory", "DUT and bias from ../../schematic/xschem and ../../../ClassABBias/schematic/xschem"),
]
SYMREN = {f"{a}.sym": f"{b}.sym" for a, b in NAMES}

def note(cell, ihp):
    return (f"T {{GF180MCU (gf180mcuD) 03v3 port of the IHP sheet {ihp}.sch, 2026-10-08. Wires and placement unchanged;\n"
            f"devices pfet_03v3 / nfet_03v3 / ppolyf_u_3k, sizes re-derived for GF180 (README.md).}} 60 -1420 0 0 0.3 0.3 {{layer=4}}")

def main(ihp, macros):
    tab = size_tables(os.path.join(HERE, "gf180_sizing.spice"))
    flat = lambda *cells: {k: v for c in cells for k, v in tab[c].items()}
    bias_x = os.path.join(macros, "ClassABBias", "schematic", "xschem")
    drv_x = os.path.join(macros, "ClassABDriver", "schematic", "xschem")
    drv_tb = os.path.join(macros, "ClassABDriver", "testbenches", "xschem")
    jobs = [
        ("d2s_bias_lp", bias_x, "ClassABBiasIdeal", flat("d2s_bias_lp")),
        ("d2s_bias_in", bias_x, "ClassABBiasIn", flat("d2s_bias_in", "d2s_bias_diodes")),
        ("d2s_bias_out", bias_x, "ClassABBiasOut", flat("d2s_bias_out", "d2s_bias_diodes")),
        ("unit_r2", drv_x, "ClassABUnitR", flat("unit_r2")),
        ("d2s_mpdda", drv_x, "ClassABDriver", flat("d2s_mpdda")),
        ("d2s_mpdda_biased", drv_x, "ClassABDriverBiased", {}),
    ]
    for ihpname, d, cell, sizes in jobs:
        extra = ""
        if cell == "ClassABDriver":
            # a and b (gates of OP / ON) become ports for the enable sub-macro (PadEnable/DriverEnable)
            extra = ("C {devices/iopin.sym} 2440 -800 0 0 {name=p16 lab=a}\n"
                     "C {devices/iopin.sym} 2440 -400 0 0 {name=p17 lab=b}\n"
                     "T {a, b: gates of OP / ON, ports for the enable switches (PadEnable/DriverEnable)} 2200 -840 0 0 0.25 0.25 {layer=10}\n")
        port_sch(os.path.join(ihp, ihpname + ".sch"), os.path.join(d, cell + ".sch"), sizes, SYMREN, TEXT, note(cell, ihpname), extra)
        sx = ""
        if cell == "ClassABDriver":
            sx = ("L 4 200 -100 220 -100 {}\nT {a} 186 -107 0 1 0.2 0.2 {}\nB 5 217.5 -102.5 222.5 -97.5 {name=a dir=inout}\n"
                  "L 4 200 -20 220 -20 {}\nT {b} 186 -27 0 1 0.2 0.2 {}\nB 5 217.5 -22.5 222.5 -17.5 {name=b dir=inout}\n")
        port_sym(os.path.join(ihp, ihpname + ".sym"), os.path.join(d, cell + ".sym"), NAMES, sx)
    for tb in ["dc", "loop", "step", "thd", "noise", "op"]:
        port_sch(os.path.join(ihp, f"tb_mpdda_{tb}.sch"), os.path.join(drv_tb, f"ClassABDriver_tb_{tb}.sch"), {}, SYMREN,
                 TEXT + [(f"tb_mpdda_{tb}", f"ClassABDriver_tb_{tb}")], note(tb, f"tb_mpdda_{tb}"))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
PYEOF
cd /home/claude/work/classab/sim && { echo "* GF180MCU 03v3 sizing netlists of the class-AB driver and its bias, 2026-10-08 (source of the port)"; cat units_gf.spice bias_lp_gf.spice mpdda_gf.spice bias_ref_gf.spice; } > /home/claude/work/gf/scripts/gf180_sizing.spice; grep -c subckt /home/claude/work/gf/scripts/gf180_sizing.spice
```

</details>

*[Fix note placement and run the port (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/scripts && python3 - <<'EOF'
p='port_classab_from_ihp.py'; s=open(p).read()
s=s.replace('''    out.append(note + "\\n")''','''    ys = [float(v) for v in re.findall(r"^N \\S+ (\\S+) \\S+ (\\S+)", "".join(out), re.M) for v in v] or [0]
    ys += [float(m.group(1)) for m in re.finditer(r"^[CT] \\{.*?\\} \\S+ (\\S+) ", "".join(out), re.M)]
    out.append(note.replace(" 60 -1420 ", f" 60 {int(min(ys)) - 120} ") + "\\n")''')
open(p,'w').write(s)
EOF
grep -n "ys = \|ys +=\|note.replace" port_classab_from_ihp.py; mkdir -p /home/claude/work/gf/macros && python3 port_classab_from_ihp.py /home/claude/ihpab/improvements/xschem /home/claude/work/gf/macros
```

</details>

*[Fix resistor size parsing and rerun port (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/scripts && python3 - <<'EOF'
p='port_classab_from_ihp.py'; s=open(p).read()
s=s.replace("""        if cur and t[0][0] in 'Xx' and len(t) > 5 and t[5] in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k'):
            kv = dict(re.findall(r'(\\w+)=(\\S+)', l))
            tab[cur][t[0][1:]] = dict(model=t[5], **kv)""","""        mods = [x for x in t if x in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k')]
        if cur and t[0][0] in 'Xx' and mods:
            kv = dict(re.findall(r'(\\w+)=(\\S+)', l))
            kv = {k: (v.replace('{rl}', '50u')) for k, v in kv.items()}
            tab[cur][t[0][1:]] = dict(model=mods[0], **kv)""")
open(p,'w').write(s)
EOF
python3 port_classab_from_ihp.py /home/claude/ihpab/improvements/xschem /home/claude/work/gf/macros 2>&1 | tail -3; grep -A3 "ppolyf" /home/claude/work/gf/macros/ClassABDriver/schematic/xschem/ClassABUnitR.sch | head; grep "lb_R" /home/claude/work/gf/macros/ClassABDriver/schematic/xschem/ClassABUnitR.sch
```

</details>

*[Review earlier round-trip checker (in the cloud container; 58 lines of output).]*

<details><summary>command</summary>

```sh
cat /home/claude/work/repo/macros/OgueyAebischerBias/scripts/check_port.py
```

</details>

*[Create macro xschemrc files with sibling paths (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros && OAB=/home/claude/work/repo/macros/OgueyAebischerBias; python3 - <<'EOF'
import re
oab='/home/claude/work/repo/macros/OgueyAebischerBias'
sch=open(oab+'/schematic/xschem/xschemrc').read()
tb=open(oab+'/testbenches/xschem/xschemrc').read()
marker='# Add current directory to xschem library path\n'
def mk(base, lines):
    a,b=base.split(marker); rest=b.split('\n\n',1)[1] if '\n\n' in b else ''
    return a+marker+''.join(f'append_xschem_library_path_unique {l}\n' for l in lines)+'\n'+rest
D='[file dirname [info script]]'
J=lambda p: f'[file join {D} {p}]'
files={
 'ClassABBias/schematic/xschem/xschemrc': [D, J('../../testbenches/xschem')],
 'ClassABBias/testbenches/xschem/xschemrc': [J('../../schematic/xschem'), D],
 'ClassABDriver/schematic/xschem/xschemrc': [D, J('../../testbenches/xschem'), J('../../../ClassABBias/schematic/xschem')],
 'ClassABDriver/testbenches/xschem/xschemrc': [J('../../schematic/xschem'), D, J('../../../ClassABBias/schematic/xschem')],
}
import os
for f,l in files.items():
    os.makedirs(os.path.dirname(f),exist_ok=True); open(f,'w').write(mk(sch if 'schematic' in f else tb, l)); print(f)
EOF
sed -n '/Add current/,/Pin the/p' ClassABDriver/testbenches/xschem/xschemrc
```

</details>

Now the round-trip checker and the first netlisting.

*[Write round-trip checker, netlist ported cells, compare (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/gf/scripts/check_classab_port.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Round trip: compare xschem's netlist of a ported cell with its GF180 sizing subckt
(gf180_sizing.spice), device by device: model, W, L, nf, m and nets. Sub-instances of the
reference listed in FLATTEN are expanded one level (the bias sheets are drawn flat).
Ports are compared by name and order; internal nets by a consistent bijection.
Usage: check_classab_port.py <gf180_sizing.spice> <xschem_netlist.spice> <ref_subckt> <cell> [extra_ports...]
Exit 1 on any mismatch."""
import re, sys
FLATTEN = {'d2s_bias_diodes'}
def parse(path):
    txt = open(path).read().replace('\n+', ' ')
    subs, cur = {}, None
    for line in txt.splitlines():
        t = line.split()
        if not t: continue
        k = t[0].lower()
        if k in ('.subckt', '**.subckt'):
            cur = t[1]; subs[cur] = {'ports': [p for p in t[2:] if '=' not in p], 'dev': {}}; continue
        if k in ('.ends', '**.ends'): cur = None; continue
        if cur is None or t[0][0] in '*.': continue
        mods = [x for x in t if x in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k')]
        kv = dict(re.findall(r'(\w+)=(\S+)', line))
        if t[0][0] in 'Xx' and mods:
            i = t.index(mods[0])
            subs[cur]['dev'][t[0].upper()] = ('dev', mods[0], t[1:i], kv)
        elif t[0][0] in 'Xx':
            pos = [x for x in t[1:] if '=' not in x]
            subs[cur]['dev'][t[0].upper()] = ('x', pos[-1], pos[:-1], kv)
        elif t[0][0] in 'VvIiRrCc':
            subs[cur]['dev'][t[0].upper()] = ('prim', t[0][0].upper(), t[1:3], {})
    return subs
def flatten(subs, name):
    s = subs[name]; out = {}
    for n, d in s['dev'].items():
        if d[0] == 'x' and d[1] in FLATTEN:
            sub = subs[d[1]]; mp = dict(zip(sub['ports'], d[2]))
            for m, e in sub['dev'].items():
                out[m] = (e[0], e[1], [mp.get(x, f'{n}.{x}') for x in e[2]], e[3])
        else:
            out[n] = d
    return {'ports': s['ports'], 'dev': out}
def val(s):
    s = str(s).strip("'{}").lower(); mult = {'u': 1e-6, 'n': 1e-9, 'p': 1e-12, 'm': 1e-3}
    return float(s[:-1]) * mult[s[-1]] if s[-1] in mult else float(s)
def main(refp, netp, ref, cell, *extra):
    R = flatten(parse(refp), ref); G = parse(netp)
    if cell not in G: print('MISSING subckt', cell); sys.exit(1)
    g = G[cell]; bad = 0
    want = R['ports'] + list(extra)
    if g['ports'] != want: print('port order', g['ports'], '!=', want); bad += 1
    if set(R['dev']) != set(g['dev']): print('device set differs:', sorted(set(R['dev']) ^ set(g['dev']))); bad += 1
    mp, rev = {p: p for p in want}, {p: p for p in want}
    for n in sorted(set(R['dev']) & set(g['dev'])):
        a, b = R['dev'][n], g['dev'][n]
        if a[0] != b[0]: print(n, 'type', a[0], b[0]); bad += 1; continue
        if len(a[2]) != len(b[2]): print(n, 'pin count', a[2], b[2]); bad += 1; continue
        for x, y in zip(a[2], b[2]):
            if mp.setdefault(x, y) != y or rev.setdefault(y, x) != x:
                print(n, 'nets', a[2], '->', b[2]); bad += 1; break
        if a[0] == 'dev':
            if a[1] != b[1]: print(n, 'model', a[1], b[1]); bad += 1
            ka = {'W': 'W', 'L': 'L', 'nf': 'nf', 'm': 'm'} if a[1] != 'ppolyf_u_3k' else {'r_width': 'r_width', 'r_length': 'r_length'}
            for k in ka:
                va, vb = a[3].get(k, '1'), b[3].get(k, '1')
                if abs(val(va) - val(vb)) > 1e-3 * abs(val(va)):
                    print(n, k, va, '!=', vb); bad += 1
        elif a[0] == 'x':
            if b[1].lower() not in (a[1].lower(), {'unit_r2': 'classabunitr'}.get(a[1].lower(), '')):
                print(n, 'cell', a[1], b[1]); bad += 1
    print(f"{cell} vs {ref}: {len(g['dev'])} devices, ports {g['ports']}")
    print('MISMATCHES:', bad); sys.exit(1 if bad else 0)
if __name__ == '__main__':
    main(*sys.argv[1:])
PYEOF
cd /home/claude/work/gf/macros; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; XS=/opt/xschem/bin/xschem
nl() { d=$(cd $(dirname $1) && pwd); rm -f /tmp/nl/$(basename $1 .sch).spice; mkdir -p /tmp/nl; (cd $d && PWD=$d $XS --rcfile $d/xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/nl $d/$(basename $1) >/tmp/nl/$(basename $1 .sch).log 2>&1); echo "netlisted $1 -> $(ls /tmp/nl/$(basename $1 .sch).spice 2>&1)"; }
C=/home/claude/work/gf/scripts/check_classab_port.py; S=/home/claude/work/gf/scripts/gf180_sizing.spice
for c in ClassABBias/schematic/xschem/ClassABBiasIdeal ClassABBias/schematic/xschem/ClassABBiasIn ClassABBias/schematic/xschem/ClassABBiasOut ClassABDriver/schematic/xschem/ClassABUnitR ClassABDriver/schematic/xschem/ClassABDriver; do nl $c.sch; done
python3 $C $S /tmp/nl/ClassABBiasIdeal.spice d2s_bias_lp ClassABBiasIdeal; python3 $C $S /tmp/nl/ClassABBiasIn.spice d2s_bias_in ClassABBiasIn; python3 $C $S /tmp/nl/ClassABBiasOut.spice d2s_bias_out ClassABBiasOut; python3 $C $S /tmp/nl/ClassABUnitR.spice unit_r2 ClassABUnitR; python3 $C $S /tmp/nl/ClassABDriver.spice d2s_mpdda ClassABDriver a b
```

</details>

*[Freeze parameters and rerun round-trip checks (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/scripts && sed -i 's/r_length={rl}/r_length=50u/; s/W={wc} L={lc}/W=16u L=16u/; s/ rl={rl}//g; s/ wc=16u lc=16u rl=50u$//; s/ rl=50u$//' gf180_sizing.spice && grep -n "subckt\|rl\|wc" gf180_sizing.spice | head; python3 - <<'EOF'
p='check_classab_port.py'; s=open(p).read()
s=s.replace("""        for x, y in zip(a[2], b[2]):""","""        pa, pb = list(a[2]), list(b[2])
        if a[1] == 'ppolyf_u_3k' and a[0] == 'dev' and pa[:2] != pb[:2] and pa[:2] == pb[1::-1]:
            pa[:2] = pb[:2] = sorted(pa[:2])  # resistor: P and M are interchangeable
        for x, y in zip(pa, pb):""")
open(p,'w').write(s)
EOF
cd ../macros; C=/home/claude/work/gf/scripts/check_classab_port.py; S=/home/claude/work/gf/scripts/gf180_sizing.spice; python3 $C $S /tmp/nl/ClassABUnitR.spice unit_r2 ClassABUnitR; python3 $C $S /tmp/nl/ClassABDriver.spice d2s_mpdda ClassABDriver a b
```

</details>

*[Re-port, netlist all cells, round-trip check (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/scripts && python3 port_classab_from_ihp.py /home/claude/ihpab/improvements/xschem /home/claude/work/gf/macros >/dev/null && cd ../macros && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; XS=/opt/xschem/bin/xschem
cat > /home/claude/work/gf/scripts/nl.sh <<'EOF'
#!/bin/bash
# netlist an xschem sheet with its directory's xschemrc into /tmp/nl (cloud helper)
f=$1; d=$(cd $(dirname $f) && pwd); b=$(basename $f .sch); mkdir -p /tmp/nl; rm -f /tmp/nl/$b.spice
(cd $d && PWD=$d /opt/xschem/bin/xschem --rcfile $d/xschemrc -n -s -q -x --tcl "set top_is_subckt ${TOPSUB:-1}" -o /tmp/nl $d/$b.sch > /tmp/nl/$b.log 2>&1)
[ -s /tmp/nl/$b.spice ] && echo "netlisted $b" || { echo "FAILED $b"; tail -5 /tmp/nl/$b.log; }
EOF
chmod +x /home/claude/work/gf/scripts/nl.sh; N=/home/claude/work/gf/scripts/nl.sh; C=/home/claude/work/gf/scripts/check_classab_port.py; S=/home/claude/work/gf/scripts/gf180_sizing.spice
for c in ClassABBias/schematic/xschem/ClassABBiasIdeal ClassABBias/schematic/xschem/ClassABBiasIn ClassABBias/schematic/xschem/ClassABBiasOut ClassABDriver/schematic/xschem/ClassABUnitR ClassABDriver/schematic/xschem/ClassABDriver ClassABDriver/schematic/xschem/ClassABDriverBiased; do $N $c.sch; done
for p in "ClassABBiasIdeal d2s_bias_lp" "ClassABBiasIn d2s_bias_in" "ClassABBiasOut d2s_bias_out" "ClassABUnitR unit_r2"; do set -- $p; python3 $C $S /tmp/nl/$1.spice $2 $1 | tail -1; done; python3 $C $S /tmp/nl/ClassABDriver.spice d2s_mpdda ClassABDriver a b; grep -i "^x\|subckt" /tmp/nl/ClassABDriverBiased.spice | head -8
```

</details>

*[Sanity-check the checker with tampered netlists (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/nl && sed 's/^XNBP vbp /XNBP vbn /' ClassABBiasIn.spice > tamper.spice && python3 /home/claude/work/gf/scripts/check_classab_port.py /home/claude/work/gf/scripts/gf180_sizing.spice tamper.spice d2s_bias_in ClassABBiasIn | tail -2; sed 's/W=20u L=6u nf=2/W=21u L=6u nf=2/' ClassABBiasIn.spice > tamper2.spice; python3 /home/claude/work/gf/scripts/check_classab_port.py /home/claude/work/gf/scripts/gf180_sizing.spice tamper2.spice d2s_bias_in ClassABBiasIn | tail -1
```

</details>

*[Retry size tamper test (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/nl && grep -m1 "^XBP" ClassABBiasIn.spice; sed 's/^\(XBP .*\)W=20u/\1W=21u/' ClassABBiasIn.spice > tamper2.spice; diff ClassABBiasIn.spice tamper2.spice | head -3; python3 /home/claude/work/gf/scripts/check_classab_port.py /home/claude/work/gf/scripts/gf180_sizing.spice tamper2.spice d2s_bias_in ClassABBiasIn | tail -2
```

</details>

*[Check m on output devices; netlist testbenches (in the cloud container; 47 lines of output).]*

<details><summary>command</summary>

```sh
grep "^XOP\|^XON" /tmp/nl/ClassABDriver.spice | cut -c1-90; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; for t in dc loop step thd noise op; do /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/macros/ClassABDriver/testbenches/xschem/ClassABDriver_tb_$t.sch; done 2>&1 | tail -6; sed -n 1,40p /tmp/nl/ClassABDriver_tb_loop.spice
```

</details>

*[Check GF FET symbol format for m (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
grep -A4 "^format" /home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols/pfet_03v3.sym; grep -A3 "^XOP" /tmp/nl/ClassABDriver.spice
```

</details>

*[Run the six ported driver testbenches (in the cloud container; 35 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/nl; for t in dc loop step thd noise op; do TOPSUB=0 /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/macros/ClassABDriver/testbenches/xschem/ClassABDriver_tb_$t.sch >/dev/null; echo "== $t"; timeout 600 ngspice -b ClassABDriver_tb_$t.spice 2>&1 | grep -E "^[a-z0-9_]+ *= |rror" | head -12; done
```

</details>

*[Inspect THD and OP testbench outputs (in the cloud container; 43 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/nl; ngspice -b ClassABDriver_tb_thd.spice 2>&1 | grep -v "^$" | tail -15; ngspice -b ClassABDriver_tb_op.spice 2>&1 | grep -v "^$" | tail -25
```

</details>

*[Append progress to the running log (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
L=/mnt/user-data/outputs/log1/2026-10-08_opus_classab_port_log.md; cat >> $L <<'EOF'

## 20:05 — GF180 sizing, driver on the ideal fixture (cloud: ngspice-42, gf180mcuD from fd_pr e11a8c9)

Sizing netlists first (cloud scratch, later `macros/ClassABDriver/scripts/gf180_sizing.spice`), started from the
IHP geometry and changed only where GF180 simulation said so:

- Model limits read from `sm141064.ngspice`: 03v3 bins W 0.22–100 µm **per instance, total W, not W/nf**
  (W = 400 µm with nf = 40 gives "could not find a valid modelname"), L 0.28–50 µm. So OP and ON are
  drawn with m: OP 91.02u/0.6u nf=14 m=6 (546.12 µm, as IHP), ON 96.8u/1u nf=22 m=3 (290.4 µm, as IHP).
- Transliterated first try: I_Q 192 µA, T0 92.4 dB, f_c 1.37 MHz, PM 72.3° (IHP 212 µA, 78.9 dB, 1.37 MHz,
  72.4°). The GF 03v3 devices behave much like sg13_hv here.
- I_Q: class-AB replicas RP1 13.32u → 12u/0.6u nf=2 and RN1 8.8u → 8u/1u nf=2 give 212.0 µA.
- Headroom: at ss/−40 °C/3.0 V the DDA tails (5u/6u) had V_DS 0.35 V < V_DSsat 0.43 V; INL 6 mV, offset
  −3 mV within |vd| ≤ 0.2 V. Tails Ta/Tb and the vbp diode BP 5u/6u → 20u/6u nf=2: INL 0.37 mV, offset −0.16 mV.
- Degeneration rhigh 0.5u/50.6u → ppolyf_u_3k 1u/50u (≈ 150 kΩ; TC −0.17 %/K vs rhigh −0.22 %/K).
- Miller capacitors: pfet_03v3 16u/16u in accumulation, as IHP.

Corners (ideal fixture, 1 kΩ ∥ 100 pF): I_Q 198–222 µA; T0 64 dB (ff/3.6 V/125 °C) … 98 dB; PM 68–75°;
offset ≤ 0.58 mV (ff/3.6 V/125 °C). Loads: 100 pF only 105.6 dB / 1.77 MHz / 61.9°; 50 Ω 66.8 dB / 0.23 MHz /
89.2°; 1 kΩ ∥ 1 nF PM 33° (as IHP: the Miller loop is sized for 100 pF).

## 20:20 — bias variants in / out (GF180 netlists)

Same mirror ratios, PMOS sources 20u/6u (copies of BP), NBPC 2.4u → 2.5u (narrow-width error −3.6 % → +0.7 %).
Current errors over MOS/res corners, −40…125 °C, 3.0…3.6 V: in −0.7…+1.8 %, out −0.5…+1.8 % (IHP: ≈ ±1.2 %).

## 20:35 — xschem port of the hand-drawn IHP sheets

`scripts/port_classab_from_ihp.py` (to go into `macros/ClassABDriver/scripts/`): wires and placement kept,
sg13_hv → pfet/nfet_03v3, rhigh → ppolyf_u_3k (+ bulk label vss), sizes from `gf180_sizing.spice`,
code blocks: IHP `.lib` lines → a tcleval MODELS block, `@n.*.nsg13_hv_*[ids]` → `@m.*.m0[id]`.

Cell names: d2s_bias_lp → ClassABBiasIdeal, d2s_bias_in/out → ClassABBiasIn/Out (macro `ClassABBias`);
unit_r2 → ClassABUnitR, d2s_mpdda → ClassABDriver (ports + `a b`, the OP/ON gates, for the enable switches),
d2s_mpdda_biased → ClassABDriverBiased (CACE fixture), tb_mpdda_* → ClassABDriver_tb_* (macro `ClassABDriver`).

Round trip (`scripts/check_classab_port.py`, xschem 3.4.8RC netlist vs gf180_sizing.spice, device by device,
nets by bijection, ports by name and order): MISMATCHES 0 on all five cells. Checker sanity: one moved gate
and one changed W each give MISMATCHES 1.

Ported testbenches, netlisted by xschem and run: dc gain 0.49999, offset 0.017 mV, nonlin 1.5 mV (±1 V),
I_Q 212.8 µA, Idd 297 µA; loop 93.1 dB / 1.40 MHz / 72.7°; step ±0.25 V no overshoot, 2.4 V/µs (10–90 %);
THD 0.145 % (10 kHz, 1 V diff.); noise total 249 µV; op prints all saturation margins.
EOF
echo ok
```

</details>

*[Called mcp__remote-devices__device_list_dir (1 lines of output).  
Copied 1 files from the cloud container to the computer (1 lines of output).]*

*[Locate chat log export script (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
ls /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/ 2>/dev/null; ls /home/claude/work/*.py /home/claude/work/chatlog 2>/dev/null; find / -name export_chatlog.py -not -path "*/proc/*" 2>/dev/null | head
```

</details>

*[Check export script usage (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/; head -40 export_chatlog.py | grep -n "argv\|usage\|Usage\|argparse\|add_argument" ; grep -n "add_argument" export_chatlog.py; ls -la /root/.claude/projects/-home-claude/*.jsonl | tail -3
```

</details>

*[Check existing chat log header (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/; head -3 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md; grep -m3 -n "^# \|Session\|session" 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md | head
```

</details>

*[Export updated chat log (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/; mkdir -p /mnt/user-data/outputs/chat1; python3 export_chatlog.py /root/.claude/projects/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb.jsonl /mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md "2026-10-06 — GF180 port: bias reference in two variants, CACE suites, IOPad proof of concept; class-AB driver port (from 2026-10-08)" ae2f9665-832e-520c-96fd-494fa4898beb claude-opus-5-5 && wc -c /mnt/user-data/outputs/chat1/*.md && grep -c "^## " /mnt/user-data/outputs/chat1/*.md; tail -5 /mnt/user-data/outputs/chat1/*.md | cut -c1-200
```

</details>

*[Inspect compaction boundary records in transcript (in the cloud container; 27 lines of output).]*

<details><summary>command</summary>

```sh
cd /root/.claude/projects/-home-claude/; python3 - <<'EOF'
import json
recs=[json.loads(l) for l in open('ae2f9665-832e-520c-96fd-494fa4898beb.jsonl')]
print(len(recs))
for i,r in enumerate(recs):
    if r.get('type')=='system' or r.get('isCompactSummary') or 'compact' in json.dumps(r)[:400].lower():
        print(i, r.get('type'), r.get('subtype'), r.get('uuid'), r.get('parentUuid'), r.get('logicalParentUuid'), str(r.get('compactMetadata'))[:100])
EOF
grep -n "parentUuid\|def chain\|leaf" /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/export_chatlog.py | head
```

</details>

*[Inspect new partial export turns (in the cloud container; 56 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "^## \|^### \|^\*\*User" /mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md | head -30; sed -n 1,30p /mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md | cut -c1-250
```

</details>

*[Inspect first post-compaction records (in the cloud container; 31 lines of output).]*

<details><summary>command</summary>

```sh
cd /root/.claude/projects/-home-claude/; python3 - <<'EOF'
import json
recs=[json.loads(l) for l in open('ae2f9665-832e-520c-96fd-494fa4898beb.jsonl')]
for i,r in enumerate(recs[:30]):
    a=r.get('attachment') or {}
    m=r.get('message') or {}
    c=m.get('content')
    s=c if isinstance(c,str) else (json.dumps(c)[:80] if c else '')
    print(i, r.get('type'), r.get('isCompactSummary'), r.get('isMeta'), a.get('type') if isinstance(a,dict) else '', str(s)[:80].replace('\n',' '), r.get('timestamp'))
EOF
```

</details>

*[Look for the pre-compaction transcript (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
ls -la /root/.claude/projects/-home-claude/ | head; ls -la /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/session.jsonl; tail -c 600 /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/session.jsonl | head -c 300
```

</details>

*[Read export script (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/; cat export_chatlog.py; diff export_chatlog.py /mnt/user-data/uploads/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py && echo same-as-staged
```

</details>

*[Patch export script for compaction; check old export (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/ && cp export_chatlog.py export_chatlog.pre_compact.py && python3 - <<'EOF'
p='export_chatlog.py'; s=open(p).read()
s=s.replace('''when the session spans more than one day. All other attachment records stay excluded. Refusal detection looks at the head of a result only."""''','''when the session spans more than one day. All other attachment records stay excluded. Refusal detection looks at the head of a result only.
2026-10-08 (same session, after an automatic context compaction): the compaction summary is not a user message and
is not exported. A compaction rewrites the transcript, so the turns before it exist only in an earlier export; for
appending to that export, environment variables (optional):
  CHATLOG_TURN_OFFSET   number of turns already in the earlier export (turn numbers continue after it)
  CHATLOG_BODY_ONLY=1   write the turns only, without the file header
  CHATLOG_COMPACT_USER  text shown as the user message of the turn the compaction interrupted
  CHATLOG_COMPACT_TIME  its time label (e.g. "2026-10-08 19:22")"""''')
s=s.replace('''for r in path:
    if r.get("isMeta"): continue''','''for r in path:
    if r.get("isMeta"): continue
    if r.get("isCompactSummary"):
        new_turn(r)
        if os.environ.get("CHATLOG_COMPACT_TIME"): cur["label"] = os.environ["CHATLOG_COMPACT_TIME"]
        if os.environ.get("CHATLOG_COMPACT_USER"): cur["user"].append(os.environ["CHATLOG_COMPACT_USER"])
        cur["items"].append(("note", f"[The context was compacted automatically at {stamp(r)}. The record of this turn up to that point "
                                     "was replaced by a summary, which is not exported; the turn continues below.]"))
        continue''')
s=s.replace('''multiday = len({t["day"] for t in turns}) > 1
for n, t in enumerate(turns, 1):
    L += [f"## Turn {n} — {t['day'] + ' ' if multiday else ''}{t['time']}", ""]''','''multiday = len({t["day"] for t in turns}) > 1 or bool(os.environ.get("CHATLOG_TURN_OFFSET"))
if os.environ.get("CHATLOG_BODY_ONLY") == "1": L = []
for n, t in enumerate(turns, 1 + int(os.environ.get("CHATLOG_TURN_OFFSET", "0"))):
    L += [f"## Turn {n} — {t.get('label') or ((t['day'] + ' ' if multiday else '') + t['time'])}", ""]''')
open(p,'w').write(s)
EOF
grep -n "Exported through\|^## Turn" 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md | tail -3; md5sum 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md
```

</details>

*[Ran a command (on the computer; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog && md5sum 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md export_chatlog.py; stat -c '%Y %s' 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md export_chatlog.py; grep -n "Exported through" 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md
```

</details>

*[Rebuild combined chat log across compaction (in the cloud container; 50 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/ && md5sum export_chatlog.pre_compact.py && cp 2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md part1_before_compaction.md && cat > rebuild.sh <<'EOF'
#!/bin/bash
# Rebuild the session chat log: turns 1-7 from the export made before the 2026-10-08 19:23 compaction,
# turns 8- from the current (rewritten) transcript.
set -e
cd "$(dirname "$0")"
OUT=/mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md
mkdir -p $(dirname $OUT)
J=/root/.claude/projects/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb.jsonl
export CHATLOG_TURN_OFFSET=7 CHATLOG_BODY_ONLY=1 CHATLOG_COMPACT_TIME="2026-10-08 19:22"
export CHATLOG_COMPACT_USER="$(cat <<'U'
*[This message is reconstructed from the compaction summary, which quoted it; "[y]our" is the summary's bracket, not necessarily the original wording.]*

Even though the class AB buffer amplifier and the bias circuits associated with it are in a temporary place in the IHP process, what about porting these circuits, test setups, and CACE characterization sketch to Global Foundries 180, just as proof-of-concept and smoke test of [y]our schematic drawing and verification flow? In which directories would you store the schematics, test bases, figures, results, logs, and chat log?
U
)"
python3 export_chatlog.py $J /tmp/cont.md x ae2f9665-832e-520c-96fd-494fa4898beb claude-opus-5-5 >/dev/null
LAST=$(grep -o "Exported through the record stamped [0-9-]* [0-9:]*" /dev/null || true)
python3 - "$OUT" <<'P'
import sys, re, json, datetime
from zoneinfo import ZoneInfo
p1 = open('part1_before_compaction.md').read()
cont = open('/tmp/cont.md').read()
recs = [json.loads(l) for l in open('/root/.claude/projects/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb.jsonl')]
last = [r for r in recs if r.get('type') in ('user', 'assistant')][-1]
t = datetime.datetime.fromisoformat(last['timestamp'].replace('Z', '+00:00')).astimezone(ZoneInfo('Europe/Berlin')).strftime('%Y-%m-%d %H:%M')
p1 = p1.replace('# 2026-10-06 — GF180 port: bias reference in two variants, CACE suites, IOPad proof of concept',
                '# 2026-10-06 — GF180 port: bias reference in two variants, CACE suites, IOPad proof of concept; 2026-10-08: class-AB driver, bias and pad enables')
p1 = re.sub(r'Exported through the record stamped [0-9-]+ [0-9:]+; later turns are not in this file\.',
            f'Exported through the record stamped {t}; later turns are not in this file.\n'
            'An automatic context compaction on 2026-10-08 at 19:23 rewrote the transcript: turns 1–7 come from the export made\n'
            'before it (2026-10-08 03:07), turns 8 onward from the rewritten transcript.', p1)
open(sys.argv[1], 'w').write(p1.rstrip() + '\n\n' + cont)
print('written', sys.argv[1], len(open(sys.argv[1]).read().encode()), 'bytes, through', t)
P
EOF
chmod +x rebuild.sh && ./rebuild.sh && grep -n "^## Turn" /mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md | tail -8; sed -n '/^## Turn 8/,/^## Turn 9/p' /mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md | head -40 | cut -c1-200
```

</details>

*[Verify no synthetic records leaked into chat log (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
F=/mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md; grep -c "Called the Read tool\|This session is being continued" $F; cp /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/export_chatlog.py /mnt/user-data/outputs/chat1/; sed -n '/^## Turn 12/,$p' $F | head -30 | cut -c1-160
```

</details>

*[Copied 2 files from the cloud container to the computer (error).]*

Millisecond precision; the md5 already matched, so I retry with the exact mtimes.

*[Copied 2 files from the cloud container to the computer (1 lines of output).]*

*[Render ported driver sheets to PNG (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; mkdir -p /tmp/rend; cd /home/claude/work/gf/macros/ClassABDriver/schematic/xschem && for c in ClassABDriver ClassABUnitR; do PWD=$(pwd) timeout 60 /usr/bin/xschem --rcfile $(pwd)/xschemrc -q -x --svg --plotfile /tmp/rend/$c.svg $(pwd)/$c.sch >/dev/null 2>&1; python3 -c "import cairosvg; cairosvg.svg2png(url='/tmp/rend/$c.svg', write_to='/tmp/rend/$c.png', output_width=2400, background_color='white')"; done; ls -la /tmp/rend
```

</details>

*[Read ClassABDriver.png (in the cloud container; image shown to the assistant).]*

*[Fix text substitution order and re-port (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/scripts && python3 - <<'EOF'
p='port_classab_from_ihp.py'; s=open(p).read()
s=s.replace("TEXT = NAMES + [","TEXT = [")
s=s.replace('''     "DUT and bias from ../../schematic/xschem and ../../../ClassABBias/schematic/xschem"),
]''','''     "DUT and bias from ../../schematic/xschem and ../../../ClassABBias/schematic/xschem"),
] + NAMES''')
s=s.replace('T {a, b: gates of OP / ON, ports for the enable switches (PadEnable/DriverEnable)} 2200 -840','T {a, b: gates of OP / ON,\\nports for the enable\\nswitches (PadEnable)} 2300 -900')
open(p,'w').write(s)
EOF
python3 port_classab_from_ihp.py /home/claude/ihpab/improvements/xschem /home/claude/work/gf/macros >/dev/null && grep -h "fixed sizes\|block descriptions" /home/claude/work/gf/macros/ClassABDriver/schematic/xschem/ClassABDriver.sch | cut -c1-200
```

</details>

*[Ran a command (on the computer; 94 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/macros && ls -R gf180mcu_IOPadSingle2Diff | head -40; grep -E "^C \{" gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch | cut -c1-120; ls gf180mcu_IOPadDiff2Single/schematic/xschem gf180mcu_IOPadDiff2Single/testbenches/xschem gf180mcu_IOPadDiff2Single/scripts; cat gf180mcu_IOPadDiff2Single/Makefile | head -30
```

</details>

*[Write small xschem sheet/symbol helper library (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/gf/macros/PadEnable/{schematic/xschem,testbenches/xschem,scripts,verification/cace} && cat > /home/claude/work/gf/macros/PadEnable/scripts/xsheet.py <<'PYEOF'
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
                self.wire(px, yy, px, yy + sign * 30, net); self.label(px, yy + sign * 30, net, right=True)
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
        if title: s += f"C {{devices/title.sym}} 160 40 0 0 {{name=l0 author=\"Christoph Maier\"}}\n"
        open(path, "w").write(s)

def symbol(path, cellname, left, right, top=(), bottom=(), text=""):
    """left/right/top/bottom: lists of (pin, dir). Box sized to fit; pins on a 20 grid, 40 apart.
    Returns the pin list [(pin, dx, dy)] in @pinlist order (left, right, top, bottom)."""
    nlr = max(len(left), len(right), 1)
    h = 40 * nlr // 2 + 20
    nt = max(len(top), len(bottom), 1)
    w = max(100, 40 * nt // 2 + 40)
    L = [HDR.replace("K {}", f'K {{type=subcircuit\nformat="@name @pinlist @symname"\ntemplate="name=x1"\n}}')]
    L.append(f"P 4 5 {-w} {-h} {w} {-h} {w} {h} {-w} {h} {-w} {-h} {{}}")
    L.append(f"T {{@symname}} {-w + 10} {-h + 6} 0 0 0.25 0.25 {{}}")
    L.append(f"T {{@name}} {-w + 10} {h - 26} 0 0 0.25 0.25 {{}}")
    if text: L.append(f"T {{{text}}} {-w + 10} {-h + 26} 0 0 0.15 0.15 {{}}")
    pins = []
    def col(lst, x0, xl, sign, txtx, flip):
        n = len(lst)
        for i, (p, d) in enumerate(lst):
            y = -20 * (n - 1) + 40 * i
            y = y if n % 2 else y
            L.append(f"L 4 {x0} {y} {xl} {y} {{}}")
            L.append(f"B 5 {x0 - 2.5} {y - 2.5} {x0 + 2.5} {y + 2.5} {{name={p} dir={d}}}")
            L.append(f"T {{{p}}} {txtx} {y - 7} 0 {flip} 0.2 0.2 {{}}")
            pins.append((p, x0, y))
    def row(lst, y0, yl, txty):
        n = len(lst)
        for i, (p, d) in enumerate(lst):
            x = -20 * (n - 1) + 40 * i
            L.append(f"L 4 {x} {y0} {x} {yl} {{}}")
            L.append(f"B 5 {x - 2.5} {y0 - 2.5} {x + 2.5} {y0 + 2.5} {{name={p} dir={d}}}")
            L.append(f"T {{{p}}} {x - 8} {txty} 0 0 0.2 0.2 {{}}")
            pins.append((p, x, y0))
    col(left, -w - 20, -w, -1, -w + 5, 0)
    col(right, w + 20, w, 1, w - 5, 1)
    row(top, -h - 20, -h, -h + 4 + 20)
    row(bottom, h + 20, h, h - 24)
    open(path, "w").write("\n".join(L) + "\n")
    return pins
PYEOF
echo ok
```

</details>

*[Rework symbol writer with explicit pin order (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/PadEnable/scripts && python3 - <<'EOF'
p='xsheet.py'; s=open(p).read()
i=s.index('def symbol(')
s=s[:i]+'''def symbol(path, left, right, top=(), bottom=(), order=None, text=""):
    """left/right/top/bottom: lists of (pin, dir), drawn on a 40 grid. The B 5 lines (= @pinlist order)
    follow `order` (pin names) if given, else left, right, top, bottom.
    Returns [(pin, dx, dy)] in @pinlist order."""
    nlr = max(len(left), len(right), 1)
    h = 20 * nlr + 20
    nt = max(len(top), len(bottom), 1)
    w = max(100, 20 * nt + 40)
    L = [HDR.replace("K {}", 'K {type=subcircuit\\nformat="@name @pinlist @symname"\\ntemplate="name=x1"\\n}')]
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
    open(path, "w").write("\\n".join(L) + "\\n")
    return pins

def sym_pins(path):
    """[(pin, dx, dy)] in @pinlist order (B 5 line order) of an existing symbol."""
    import re
    out = []
    for m in re.finditer(r"^B 5 (\\S+) (\\S+) (\\S+) (\\S+) \\{[^}]*name=(\\w+)", open(path).read(), re.M):
        x1, y1, x2, y2 = map(float, m.group(1, 2, 3, 4))
        out.append((m.group(5), int(round((x1 + x2) / 2)), int(round((y1 + y2) / 2))))
    return out
'''
open(p,'w').write(s)
EOF
python3 -c "import xsheet; print('ok')"
```

</details>

*[Generate PadEnable cells and netlist them (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
cat > gen_padenable.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the PadEnable cells (GF180MCU gf180mcuD, 03v3 devices) once; afterwards the .sch/.sym are
the source of truth. Switch plan from the IHP power_down session (2026-10-06, sg13cmos5l notes worktree,
design_considerations/class_ab_pad_driver/power_down/log.md, 17:10 entry), moved out of the driver and bias
cells into cells of their own:

  EnableInv      en -> en_b, one per pad (the place for a level shifter when the enable comes from 1.2 V logic)
  DriverEnable   disabled: a (OP gate) -> vddo, b (ON gate) -> vsso, vabp -> vdd, vabn -> vss
  BiasRefEnable  transmission gate iin -> iout (enabled); disabled: iout (NMOS input diode's gate line) -> vss
  InputEnable    transmission gate pin -> pout (enabled); disabled: pout parked on vpark by a second gate

All switches are on while disabled and off while enabled; en is active high (0 / vdd).
Usage: gen_padenable.py <PadEnable/schematic/xschem>"""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xsheet import Sheet, symbol

SW = dict(W="1u", L="0.5u")
INV_P, INV_N = dict(W="2u", L="0.5u"), dict(W="1u", L="0.5u")
TG = dict(W="4u", L="0.5u")

def title(s, cell, lines):
    s.text(cell, 60, -560, 0.5)
    for i, l in enumerate(lines):
        s.text(l, 60, -500 + 22 * i, 0.25)
    s.text("GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.", 60, 120, 0.2, 4)

def enable_inv(d):
    pins = symbol(f"{d}/EnableInv.sym", left=[("en", "in")], right=[("en_b", "out")], top=[("vdd", "inout")],
                  bottom=[("vss", "inout")], order=["vdd", "vss", "en", "en_b"])
    s = Sheet()
    title(s, "EnableInv", ["en_b = not en, on vdd / vss. One per pad.",
                           "When the enable comes from 1.2 V logic, a level shifter replaces this cell."])
    s.wire(60, -300, 400, -300, "vdd"); s.wire(60, 0, 400, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -150, "en"); s.pin("opin", 400, -150, "en_b")
    s.fet("p", "MP", 200, -200, "en_b", "en", "vdd", "vdd", top_rail=-300, **INV_P)
    s.fet("n", "MN", 200, -80, "en_b", "en", "vss", "vss", bot_rail=0, **INV_N)
    s.write(f"{d}/EnableInv.sch", title=True)
    return pins

def driver_enable(d):
    order = ["vdd", "vss", "vddo", "vsso", "en", "en_b", "a", "b", "vabp", "vabn"]
    pins = symbol(f"{d}/DriverEnable.sym", left=[("en", "in"), ("en_b", "in")],
                  right=[("a", "inout"), ("vabp", "inout"), ("vabn", "inout"), ("b", "inout")],
                  top=[("vdd", "inout"), ("vddo", "inout")], bottom=[("vss", "inout"), ("vsso", "inout")], order=order)
    s = Sheet()
    title(s, "DriverEnable", ["Disable switches of ClassABDriver, on while en = 0:",
                              "SA: a (gate of OP) to vddo, SB: b (gate of ON) to vsso -- OP and ON off, gates tied to their own rails as in a clamp;",
                              "SABP: vabp to vdd, SABN: vabn to vss -- otherwise ABP / ABN conduct from the a pull-up into the b pull-down.",
                              "SA and SB sit on the output-stage rails vddo / vsso (n-well of SA on vddo, SB in ON's tap ring on vsso)."])
    s.wire(60, -340, 560, -340, "vddo"); s.wire(60, -320, 560, -320, "vdd")
    s.wire(60, 0, 560, 0, "vss"); s.wire(60, 20, 560, 20, "vsso")
    s.pin("iopin", 60, -320, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("iopin", 60, -340, "vddo", right=True); s.pin("iopin", 60, 20, "vsso", right=True)
    for i, (k, n) in enumerate([("ipin", "en"), ("ipin", "en_b")]):
        s.pin(k, 60, -200 + 40 * i, n)
    for i, n in enumerate(["a", "b", "vabp", "vabn"]):
        s.pin("iopin", 640, -220 + 40 * i, n)
    s.fet("p", "SA", 200, -220, "a", "en", "vddo", "vddo", top_rail=-340, **SW)
    s.fet("p", "SABP", 400, -220, "vabp", "en", "vdd", "vdd", top_rail=-320, **SW)
    s.fet("n", "SB", 200, -80, "b", "en_b", "vsso", "vsso", bot_rail=20, **SW)
    s.fet("n", "SABN", 400, -80, "vabn", "en_b", "vss", "vss", bot_rail=0, **SW)
    s.write(f"{d}/DriverEnable.sch", title=True)
    return pins

def bias_ref_enable(d):
    order = ["vdd", "vss", "en", "en_b", "iin", "iout"]
    pins = symbol(f"{d}/BiasRefEnable.sym", left=[("iin", "inout"), ("en", "in"), ("en_b", "in")], right=[("iout", "inout")],
                  top=[("vdd", "inout")], bottom=[("vss", "inout")], order=order)
    s = Sheet()
    title(s, "BiasRefEnable", ["Reference-current switch in front of ClassABBiasIn (NMOS input diode NI):",
                               "TGN / TGP pass iin to iout while en = 1; while en = 0 they open and TDN pulls iout,",
                               "NI's gate line, to vss. The external reference is not relied on to switch off."])
    s.wire(60, -300, 560, -300, "vdd"); s.wire(60, 0, 560, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -180, "en"); s.pin("ipin", 60, -140, "en_b")
    s.pin("iopin", 60, -100, "iin", right=True); s.pin("iopin", 640, -100, "iout")
    s.fet("p", "TGP", 200, -200, "iout", "en_b", "iin", "vdd", top_rail=None, **SW)
    s.fet("n", "TGN", 200, -80, "iin", "en", "iout", "vss", bot_rail=None, **SW)
    s.fet("n", "TDN", 400, -80, "iout", "en_b", "vss", "vss", bot_rail=0, **SW)
    s.write(f"{d}/BiasRefEnable.sch", title=True)
    return pins

def input_enable(d):
    order = ["vdd", "vss", "en", "en_b", "pin", "pout", "vpark"]
    pins = symbol(f"{d}/InputEnable.sym", left=[("pin", "inout"), ("en", "in"), ("en_b", "in")],
                  right=[("pout", "inout"), ("vpark", "in")], top=[("vdd", "inout")], bottom=[("vss", "inout")], order=order)
    s = Sheet()
    title(s, "InputEnable", ["Input switch of an analog input pad, behind the CDM resistor:",
                             "TGN1 / TGP1 pass pin to pout while en = 1; while en = 0 they open and TGN2 / TGP2 park pout on vpark",
                             "(the common-mode reference), so the circuit behind the pad sees a defined input when the pad is off."])
    s.wire(60, -300, 760, -300, "vdd"); s.wire(60, 0, 760, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -180, "en"); s.pin("ipin", 60, -140, "en_b")
    s.pin("iopin", 60, -100, "pin", right=True); s.pin("iopin", 840, -140, "pout"); s.pin("ipin", 840, -100, "vpark")
    s.fet("p", "TGP1", 200, -200, "pout", "en_b", "pin", "vdd", **TG)
    s.fet("n", "TGN1", 200, -80, "pin", "en", "pout", "vss", **TG)
    s.fet("p", "TGP2", 500, -200, "vpark", "en", "pout", "vdd", **TG)
    s.fet("n", "TGN2", 500, -80, "pout", "en_b", "vpark", "vss", **TG)
    s.write(f"{d}/InputEnable.sch", title=True)
    return pins

if __name__ == "__main__":
    d = sys.argv[1]
    for f in (enable_inv, driver_enable, bias_ref_enable, input_enable):
        print(f.__name__, f(d))
PYEOF
python3 gen_padenable.py ../schematic/xschem && cp ../../ClassABBias/schematic/xschem/xschemrc ../schematic/xschem/xschemrc && cp ../../ClassABBias/testbenches/xschem/xschemrc ../testbenches/xschem/xschemrc && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && for c in EnableInv DriverEnable BiasRefEnable InputEnable; do /home/claude/work/gf/scripts/nl.sh ../schematic/xschem/$c.sch; grep -v "^\*\*\|^$\|^\.ends\|^\*\." /tmp/nl/$c.spice | sed 's/ ad=.*m=/ m=/' | grep -v "^+"; done
```

</details>

*[Fix stub collisions and regenerate enable cells (in the cloud container; 26 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/self.wire(px, yy, px, yy + sign \* 30, net); self.label(px, yy + sign \* 30, net, right=True)/self.wire(px, yy, px, yy + sign * 20, net); self.label(px, yy + sign * 20, net, right=True)/' xsheet.py && sed -i 's/, 200, -200, /, 200, -220, /; s/, 400, -220, /, 400, -220, /; s/, 500, -200, /, 500, -220, /; s/, 200, -80, /, 200, -60, /; s/, 400, -80, /, 400, -60, /; s/, 500, -80, /, 500, -60, /' gen_padenable.py && grep -n "s.fet" gen_padenable.py | cut -c1-80 && python3 gen_padenable.py ../schematic/xschem >/dev/null && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && for c in EnableInv DriverEnable BiasRefEnable InputEnable; do /home/claude/work/gf/scripts/nl.sh ../schematic/xschem/$c.sch >/dev/null; grep "^X" /tmp/nl/$c.spice | awk '{print $1,$2,$3,$4,$5,$6}'; done
```

</details>

*[Round-trip check enable cells and render two (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cat > padenable_reference.spice <<'EOF'
* PadEnable reference netlists (GF180MCU 03v3), 2026-10-08: the switch plan of the IHP power_down session
.subckt EnableInv vdd vss en en_b
XMP en_b en vdd vdd pfet_03v3 W=2u L=0.5u nf=1
XMN en_b en vss vss nfet_03v3 W=1u L=0.5u nf=1
.ends
.subckt DriverEnable vdd vss vddo vsso en en_b a b vabp vabn
XSA a en vddo vddo pfet_03v3 W=1u L=0.5u nf=1
XSB b en_b vsso vsso nfet_03v3 W=1u L=0.5u nf=1
XSABP vabp en vdd vdd pfet_03v3 W=1u L=0.5u nf=1
XSABN vabn en_b vss vss nfet_03v3 W=1u L=0.5u nf=1
.ends
.subckt BiasRefEnable vdd vss en en_b iin iout
XTGN iin en iout vss nfet_03v3 W=1u L=0.5u nf=1
XTGP iout en_b iin vdd pfet_03v3 W=1u L=0.5u nf=1
XTDN iout en_b vss vss nfet_03v3 W=1u L=0.5u nf=1
.ends
.subckt InputEnable vdd vss en en_b pin pout vpark
XTGN1 pin en pout vss nfet_03v3 W=4u L=0.5u nf=1
XTGP1 pout en_b pin vdd pfet_03v3 W=4u L=0.5u nf=1
XTGN2 pout en_b vpark vss nfet_03v3 W=4u L=0.5u nf=1
XTGP2 vpark en pout vdd pfet_03v3 W=4u L=0.5u nf=1
.ends
EOF
for c in EnableInv DriverEnable BiasRefEnable InputEnable; do python3 /home/claude/work/gf/scripts/check_classab_port.py padenable_reference.spice /tmp/nl/$c.spice $c $c | tail -1; done; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd ../schematic/xschem; for c in DriverEnable InputEnable; do PWD=$(pwd) timeout 60 /usr/bin/xschem --rcfile $(pwd)/xschemrc -q -x --svg --plotfile /tmp/rend/$c.svg $(pwd)/$c.sch >/dev/null 2>&1; python3 -c "import cairosvg; cairosvg.svg2png(url='/tmp/rend/$c.svg', write_to='/tmp/rend/$c.png', output_width=1600, background_color='white')"; done
```

</details>

*[Read DriverEnable.png (in the cloud container; image shown to the assistant).]*

*[Move title block below the rails (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/PadEnable/scripts && sed -i 's/C {{devices\/title.sym}} 160 40 0 0/C {{devices\/title.sym}} 160 220 0 0/' xsheet.py && sed -i 's/edit the sheet from now on.", 60, 120, 0.2, 4)/edit the sheet from now on.", 60, 120, 0.2, 4)/' gen_padenable.py && python3 gen_padenable.py ../schematic/xschem >/dev/null && grep -c title ../schematic/xschem/DriverEnable.sch
```

</details>

*[Ran a command (on the computer; 36 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && find macros/gf180mcu_IOPadDiff2Single macros/gf180mcu_IOPadSingle2Diff -type f -not -path "*/simulations/*" -not -path "*/_runs/*" -not -path "*/_docs/*" -not -path "*/netlist/*" | sort; ls schematic/xschem docs; ls render 2>/dev/null | head
```

</details>

*[Copied 25 files from the computer to the cloud container (1 lines of output).]*

*[Read pad sheets/symbols and xschemrc chains (in the cloud container; 132 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; cat $U/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sym; cat $U/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch $U/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sym; sed -n '/Add current/,/Pin the/p' $U/schematic/xschem/xschemrc $U/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc
```

</details>

*[Read Single2Diff CACE template and testbench (in the cloud container; 63 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; cat $U/macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch | head -60; grep -n "gf180mcu_IOPadSingle2Diff.sym" -A2 $U/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch
```

</details>

*[Generate Diff2Single pad sheet and netlist it (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/scripts && cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/scripts && cat > gen_iopad_d2s.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes gf180mcu_IOPadDiff2Single.sch/.sym once (2026-10-08); afterwards the sheet is the source of truth.
Block level: ClassABBiasIn (bias tree, fed by iref through BiasRefEnable), ClassABDriver (vfb = out),
DriverEnable and EnableInv (PadEnable macro). Pins of the blocks get a stub and a net label.
Usage: gen_iopad_d2s.py <macros dir>"""
import os, sys
M = sys.argv[1]
sys.path.insert(0, os.path.join(M, "PadEnable", "scripts"))
from xsheet import Sheet, symbol, sym_pins

def P(macro, cell):
    return sym_pins(os.path.join(M, macro, "schematic", "xschem", cell + ".sym"))

d = os.path.join(M, "gf180mcu_IOPadDiff2Single", "schematic", "xschem")
order = ["vdd", "vss", "vddo", "vsso", "inp", "inn", "vref", "out", "iref", "en"]
symbol(os.path.join(d, "gf180mcu_IOPadDiff2Single.sym"),
       left=[("inp", "in"), ("inn", "in"), ("vref", "in"), ("iref", "inout"), ("en", "in")], right=[("out", "inout")],
       top=[("vdd", "inout"), ("vddo", "inout")], bottom=[("vss", "inout"), ("vsso", "inout")], order=order,
       text="class-AB, vout - vref = (inp - inn)/2")
s = Sheet()
s.text("gf180mcu_IOPadDiff2Single: class-AB differential -> single-ended pad driver with enable (PROOF OF CONCEPT, 2026-10-08)", 60, -1160, 0.5)
for i, l in enumerate([
    "Blocks: ClassABBiasIn (macros/ClassABBias): bias tree and the six diodes, fed by iref (5 uA into the pad) through BiasRefEnable.",
    "ClassABDriver (macros/ClassABDriver): matched-pair DDA, folded cascode, class-AB output OP / ON, Miller compensation; vfb = out, so out - vref = (inp - inn)/2.",
    "DriverEnable, EnableInv (macros/PadEnable): en = 0 -> OP / ON gates tied to vddo / vsso, vabp / vabn to vdd / vss, iref cut off and NI's gate line to vss.",
    "Bias enters as a current (iref), never as a voltage. vddo / vsso: output-stage rails (OP, ON and their replicas RP1, RN1).",
    "Not included yet: CDM / ESD network at out (OP and ON are meant to double as the pad clamps, IHP case (a)); a level shifter for a 1.2 V enable."]):
    s.text(l, 60, -1100 + 24 * i, 0.25)
for i, n in enumerate(["vdd", "vss", "vddo", "vsso"]):
    s.pin("iopin", 60, -900 + 20 * i, n, right=True)
for i, n in enumerate(["inp", "inn", "vref"]):
    s.pin("ipin", 60, -800 + 20 * i, n)
s.pin("iopin", 60, -720, "iref", right=True); s.pin("ipin", 60, -700, "en")
s.pin("iopin", 1800, -800, "out")
rails = dict(vdd="vdd", vss="vss", vddo="vddo", vsso="vsso")
bias = ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]
s.block("ClassABBiasIn.sym", "xbias", 800, -500, P("ClassABBias", "ClassABBiasIn"), dict(rails, iref="iref_en", **{b: b for b in bias}))
s.block("BiasRefEnable.sym", "xref", 360, -500, P("PadEnable", "BiasRefEnable"),
        dict(vdd="vdd", vss="vss", en="en", en_b="en_b", iin="iref", iout="iref_en"))
s.block("ClassABDriver.sym", "xdrv", 1400, -560, P("ClassABDriver", "ClassABDriver"),
        dict(rails, vinp="inp", vinn="inn", vref="vref", vout="out", vfb="out", a="a", b="b", **{b: b for b in bias}))
s.block("DriverEnable.sym", "xen", 1400, -160, P("PadEnable", "DriverEnable"),
        dict(rails, en="en", en_b="en_b", a="a", b="b", vabp="vabp", vabn="vabn"))
s.block("EnableInv.sym", "xinv", 360, -160, P("PadEnable", "EnableInv"), dict(vdd="vdd", vss="vss", en="en", en_b="en_b"))
s.write(os.path.join(d, "gf180mcu_IOPadDiff2Single.sch"), title=True)
print("wrote", d)
PYEOF
python3 gen_iopad_d2s.py /home/claude/work/gf/macros && U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/gf180mcu_IOPadDiff2Single; python3 - <<'EOF'
import re
oab='/home/claude/work/gf/macros/ClassABDriver/schematic/xschem/xschemrc'
s=open(oab).read()
marker='# Add current directory to xschem library path\n'
a,b=s.split(marker); rest=b.split('\n\n',1)[1]
D='[file dirname [info script]]'; J=lambda p: f'[file join {D} {p}]'
def mk(lines): return a+marker+''.join(f'append_xschem_library_path_unique {l}\n' for l in lines)+'\n'+rest
sibs=[J('../../../ClassABDriver/schematic/xschem'), J('../../../ClassABBias/schematic/xschem'), J('../../../PadEnable/schematic/xschem')]
base='/home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/'
import os
os.makedirs(base+'testbenches/xschem',exist_ok=True)
open(base+'schematic/xschem/xschemrc','w').write(mk([D, J('../../testbenches/xschem')]+sibs))
open(base+'testbenches/xschem/xschemrc','w').write(mk([J('../../schematic/xschem'), D]+sibs))
EOF
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch; grep -v "^\*\|^+\|^$" /tmp/nl/gf180mcu_IOPadDiff2Single.spice | grep -B1 -A6 "subckt gf180"
```

</details>

*[Copy pad macros into work tree, generate D2S sheet, netlist (in the cloud container; 34 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros; cd /home/claude/work/gf/macros && for m in gf180mcu_IOPadDiff2Single gf180mcu_IOPadSingle2Diff; do (cd $U && find $m -type f) | while read f; do mkdir -p $(dirname $f); cp -n $U/$f $f; done; done; mkdir -p /home/claude/work/gf/orig && cp -r $U/gf180mcu_IOPadDiff2Single $U/gf180mcu_IOPadSingle2Diff /home/claude/work/gf/orig/; cd gf180mcu_IOPadDiff2Single/scripts && python3 gen_iopad_d2s.py /home/claude/work/gf/macros && python3 - <<'EOF'
oab='/home/claude/work/gf/macros/ClassABDriver/schematic/xschem/xschemrc'
s=open(oab).read()
marker='# Add current directory to xschem library path\n'
a,b=s.split(marker); rest=b.split('\n\n',1)[1]
D='[file dirname [info script]]'; J=lambda p: f'[file join {D} {p}]'
def mk(lines): return a+marker+''.join(f'append_xschem_library_path_unique {l}\n' for l in lines)+'\n'+rest
sibs=[J('../../../ClassABDriver/schematic/xschem'), J('../../../ClassABBias/schematic/xschem'), J('../../../PadEnable/schematic/xschem')]
for m in ['gf180mcu_IOPadDiff2Single','gf180mcu_IOPadSingle2Diff']:
    base=f'/home/claude/work/gf/macros/{m}/'
    sb = sibs if 'Diff2' in m else [J('../../../PadEnable/schematic/xschem')]
    open(base+'schematic/xschem/xschemrc','w').write(mk([D, J('../../testbenches/xschem')]+sb))
    open(base+'testbenches/xschem/xschemrc','w').write(mk([J('../../schematic/xschem'), D]+sb))
EOF
diff /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch; grep -v "^\*\|^+\|^$" /tmp/nl/gf180mcu_IOPadDiff2Single.spice | grep -A6 "subckt gf180"
```

</details>

*[Restore Single2Diff xschemrc and add PadEnable path (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff && for f in schematic/xschem/xschemrc testbenches/xschem/xschemrc; do python3 - /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/$f $f <<'EOF'
import sys
s=open(sys.argv[1]).read()
key='append_xschem_library_path_unique [file dirname [info script]]\n'
assert key in s
s=s.replace(key, key+'append_xschem_library_path_unique [file join [file dirname [info script]] ../../../PadEnable/schematic/xschem]\n',1)
open(sys.argv[2],'w').write(s)
EOF
diff /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/$f $f; done; head -c 3 schematic/xschem/xschemrc | xxd | head -1
```

</details>

*[Add input enable to Single2Diff pad and netlist (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cat > scripts/add_input_enable.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""One-time edit (2026-10-08): adds the enable to gf180mcu_IOPadSingle2Diff. InputEnable (PadEnable macro) behind
the CDM network: in_prot -> in_en while en = 1, in_en parked on vcm while en = 0; EnableInv makes en_b.
New port en, last in the port list. Afterwards the sheet is the source of truth.
Usage: add_input_enable.py <macros dir>"""
import os, sys
M = sys.argv[1]
sys.path.insert(0, os.path.join(M, "PadEnable", "scripts"))
from xsheet import Sheet, sym_pins
d = os.path.join(M, "gf180mcu_IOPadSingle2Diff", "schematic", "xschem")
P = lambda cell: sym_pins(os.path.join(M, "PadEnable", "schematic", "xschem", cell + ".sym"))
s = Sheet(); s.n = 100
s.pin("ipin", 60, -200, "en")
s.block("InputEnable.sym", "xinen", 900, -300, P("InputEnable"),
        dict(vdd="vdd", vss="vss", en="en", en_b="en_b", pin="in_prot", pout="in_en", vpark="vcm"))
s.block("EnableInv.sym", "xinv", 1300, -300, P("EnableInv"), dict(vdd="vdd", vss="vss", en="en", en_b="en_b"))
s.text("2026-10-08: enable added. InputEnable (macros/PadEnable) passes in_prot to in_en while en = 1 and parks in_en on vcm\n"
       "while en = 0; EnableInv makes en_b. in_en is where the single-ended -> differential buffer will connect.", 700, -520, 0.25, 4)
sch = os.path.join(d, "gf180mcu_IOPadSingle2Diff.sch")
t = open(sch).read().rstrip("\n")
t = t.replace("The single-ended -> differential buffer is NOT designed yet: in_prot, vcm, outp, outn\nare unconnected",
              "The single-ended -> differential buffer is NOT designed yet: in_en (behind InputEnable), outp, outn\nare unconnected")
open(sch, "w").write(t + "\n" + "\n".join(s.recs) + "\n")
sym = os.path.join(d, "gf180mcu_IOPadSingle2Diff.sym")
t = open(sym).read().rstrip("\n")
t += "\nL 4 -60 -20 -40 -20 {}\nB 5 -62.5 -22.5 -57.5 -17.5 {name=en dir=in }\nT {en} -35 -26 0 0 0.2 0.2 {}\n"
open(sym, "w").write(t)
print("edited", sch, sym)
PYEOF
python3 scripts/add_input_enable.py /home/claude/work/gf/macros && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && /home/claude/work/gf/scripts/nl.sh $(pwd)/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch && grep -v "^\*\|^+\|^$" /tmp/nl/gf180mcu_IOPadSingle2Diff.spice | grep -A8 "subckt gf180"
```

</details>

*[Show full Single2Diff netlist (in the cloud container; 32 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 1,60p /tmp/nl/gf180mcu_IOPadSingle2Diff.spice | cut -c1-150
```

</details>

*[Check xschem log for Single2Diff netlisting (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
head -20 /tmp/nl/gf180mcu_IOPadSingle2Diff.log; head -c 200 /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/xschemrc | od -c | head -3
```

</details>

*[Test netlisting of the original Single2Diff sheet (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch; grep -c MISSING /tmp/nl/gf180mcu_IOPadSingle2Diff.spice; cd /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/schematic/xschem && PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /tmp/nl $(pwd)/gf180mcu_IOPadSingle2Diff.sch 2>&1 | head; ls -la
```

</details>

*[Test whether the BOM breaks xschem 3.4.8 (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /tmp/bomtest && cp /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/schematic/xschem/* /tmp/bomtest/ && chmod u+w /tmp/bomtest/* && cd /tmp/bomtest && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && PWD=/tmp/bomtest /opt/xschem/bin/xschem --rcfile /tmp/bomtest/xschemrc -n -s -q -x -o /tmp/bomtest/o gf180mcu_IOPadSingle2Diff.sch >/tmp/bomtest/log1 2>&1; grep -c MISSING o/*.spice; sed -i '1s/^\xEF\xBB\xBF//' xschemrc; rm -rf o; PWD=/tmp/bomtest /opt/xschem/bin/xschem --rcfile /tmp/bomtest/xschemrc -n -s -q -x -o /tmp/bomtest/o gf180mcu_IOPadSingle2Diff.sch >/tmp/bomtest/log2 2>&1; grep -c MISSING o/*.spice; cat log1 | head -5
```

</details>

*[Make netlist helper BOM-safe via mirror; retry (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/gf/scripts/nl.sh <<'EOF'
#!/bin/bash
# netlist an xschem sheet with its directory's xschemrc into /tmp/nl (cloud helper).
# The cloud xschem/Tcl rejects the UTF-8 BOM some project xschemrc files start with, so the macro tree
# is mirrored to /tmp/gfm with BOMs stripped, and the sheet is netlisted from the mirror.
f=$(readlink -f $1); src=/home/claude/work/gf/macros
rsync -a --delete $src/ /tmp/gfm/macros/
find /tmp/gfm/macros -name xschemrc -exec sed -i '1s/^\xEF\xBB\xBF//' {} +
f=${f/$src//tmp/gfm/macros}
d=$(dirname $f); b=$(basename $f .sch); mkdir -p /tmp/nl; rm -f /tmp/nl/$b.spice
(cd $d && PWD=$d /opt/xschem/bin/xschem --rcfile $d/xschemrc -n -s -q -x --tcl "set top_is_subckt ${TOPSUB:-1}" -o /tmp/nl $d/$b.sch > /tmp/nl/$b.log 2>&1)
if [ -s /tmp/nl/$b.spice ] && ! grep -q "IS MISSING" /tmp/nl/$b.spice; then echo "netlisted $b"; else echo "FAILED $b"; grep -m3 "MISSING" /tmp/nl/$b.spice; tail -3 /tmp/nl/$b.log; fi
EOF
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch && grep -v "^\*\|^+\|^$" /tmp/nl/gf180mcu_IOPadSingle2Diff.spice | grep -A8 "subckt gf180" | cut -c1-120
```

</details>

*[Use cp mirror instead of rsync; retry (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's|^rsync -a --delete $src/ /tmp/gfm/macros/|rm -rf /tmp/gfm/macros; mkdir -p /tmp/gfm; cp -a $src /tmp/gfm/macros|' /home/claude/work/gf/scripts/nl.sh; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; /home/claude/work/gf/scripts/nl.sh /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch && grep -v "^\*\|^+\|^$" /tmp/nl/gf180mcu_IOPadSingle2Diff.spice | grep -A8 "subckt gf180" | cut -c1-120
```

</details>

*[Review OAB CACE generator structure (in the cloud container; 140 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 1,140p /home/claude/work/repo/macros/OgueyAebischerBias/scripts/gen_cace.py
```

</details>

*[Review OAB yaml generator and example datasheet (in the cloud container; 181 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 300,420p /home/claude/work/repo/macros/OgueyAebischerBias/scripts/gen_cace.py; head -60 /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_03v3.yaml
```

</details>

*[Move shared sheet helper to repo-level scripts (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/gf/topscripts && cd /home/claude/work/gf && mv macros/PadEnable/scripts/xsheet.py topscripts/xsheet.py && sed -i 's|sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))|sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "scripts"))|' macros/PadEnable/scripts/gen_padenable.py && sed -i 's|sys.path.insert(0, os.path.join(M, "PadEnable", "scripts"))|sys.path.insert(0, os.path.join(M, "..", "scripts"))|' macros/gf180mcu_IOPadDiff2Single/scripts/gen_iopad_d2s.py macros/gf180mcu_IOPadSingle2Diff/scripts/add_input_enable.py && grep -n "sys.path" macros/*/scripts/*.py; ln -sfn /home/claude/work/gf/topscripts /home/claude/work/gf/scripts_top; ls /home/claude/work/gf
```

</details>

*[Reorganize work tree to mirror repo layout (in the cloud container; 28 lines of output).]*

<details><summary>command</summary>

```sh
rm scripts_top && mv scripts cloud && mv topscripts scripts && mkdir -p macros/ClassABDriver/scripts macros/ClassABBias/scripts && mv cloud/port_classab_from_ihp.py cloud/check_classab_port.py cloud/gf180_sizing.spice macros/ClassABDriver/scripts/ && mv macros/PadEnable/scripts/padenable_reference.spice macros/PadEnable/scripts/ 2>/dev/null; sed -i 's|/home/claude/work/gf/scripts/|/home/claude/work/gf/cloud/|g' cloud/nl.sh; ls -R cloud scripts macros/*/scripts | head -30; python3 macros/gf180mcu_IOPadDiff2Single/scripts/gen_iopad_d2s.py /home/claude/work/gf/macros >/dev/null && echo gen-ok
```

</details>

*[Add CACE template helpers to shared sheet library (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cat >> /home/claude/work/gf/scripts/xsheet.py <<'PYEOF'

# ---------------------------------------------------------------- CACE templates
def esc(s):
    """CACE{...} -> CACE\\{...\\} as xschem needs it inside a property string."""
    import re
    return re.sub(r"CACE\{([^}]*)\}", r"CACE\\{\1\\}", s)

def vsrc(sheet, name, x, y, value, plus, minus="0", kind="vsource"):
    """vsource / isource symbol at (x, y), pins p (0,-30) and m (0,30), each with a stub and a label."""
    sheet.raw(f"C {{devices/{kind}.sym}} {x} {y} 0 0 {{name={name} value=\"{value}\"}}")
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
PYEOF
python3 -c "import sys; sys.path.insert(0,'/home/claude/work/gf/scripts'); import xsheet; print(xsheet.esc('a CACE{x} b CACE{y=1}'))"
```

</details>

*[List library sections in the GF180 model file (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "^\.lib\|^\.LIB" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | head -30
```

</details>

*[List all top-level section names (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "^\.lib [a-z]" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | awk '{print $2}' | sort -u | tr '\n' ' '
```

</details>

*[Check OAB mismatch parameter setup (in the cloud container; 49 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "mm_params" -A40 /home/claude/work/repo/macros/OgueyAebischerBias/verification/cace/OgueyAebischerRef_03v3.yaml | head -50; grep -n "OPTS\b\|OPTS =" -A3 /home/claude/work/repo/macros/OgueyAebischerBias/scripts/gen_cace.py | head
```

</details>

*[Write bias CACE generator and generate suites (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/gf/macros/ClassABBias/scripts/gen_cace.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the CACE datasheets and templates of ClassABBiasIn and ClassABBiasOut (GF180MCU, 2026-10-08), proof of
concept subsets of the IHP run_bias.py checks (improvements/bias.md): bias-current accuracy over PVT, DC line
sensitivity, local mismatch. After the first run, edit the generated files, not this script.
Usage: gen_cace.py <ClassABBias macro dir>"""
import os, sys
MAC = os.path.abspath(sys.argv[1])
sys.path.insert(0, os.path.join(MAC, "..", "..", "scripts"))
from xsheet import cace_template, sym_pins

OPTS = (".options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15 "
        "SEED=CACE[CACE{seed=12345} + CACE{iterations=0}]\n")
LINES = [("bp", "xbp", 5e-6), ("bn", "xbn", 5e-6), ("bpc", "xbpc", 2e-6), ("bnc", "xbnc", 2e-6), ("abp", "xrp2", 5e-6), ("abn", "xrn2", 5e-6)]
OUT = "echo {vals} > CACE{{simpath}}/CACE{{filename}}_CACE{{N}}.data\n"

def errs():
    s = ""
    for k, dev, nom in LINES:
        s += f"let e_{k} = 100*(abs(@m.x1.{dev}.m0[id])/{nom} - 1)\n"
    return s

def templates(cell, iref_plus, iref_minus, tdir):
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", cell + ".sym"))
    conns = dict(vdd="vdd", vss="0", vddo="vdd", vsso="0", iref="iref",
                 **{p: p for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]})
    src = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Iref", "CACE{iref}", iref_plus, iref_minus, "isource")]
    note = (f"{cell} with an ideal reference current CACE{{iref}} {'into' if iref_minus == 'iref' else 'out of'} iref; vddo tied to vdd, vsso to vss.\n"
            "Bias currents are the drain currents of the six diodes inside the DUT: XBP, XBN, XBPC, XBNC, XRP2, XRN2\n"
            "(@m.x1.<dev>.m0[id]); errors in % of 5 / 5 / 2 / 2 / 5 / 5 uA.")
    v = " ".join(f"$&e_{k}" for k, _, _ in LINES)
    cace_template(os.path.join(tdir, f"{cell}_tb_dc.sch"), f"Template: bias currents - {cell}", note, f"{cell}.sym", pins, conns, src,
                  OPTS + ".control\nsave all\nop\n" + errs() + "let Idd = -i(Vvdd)\n" + OUT.format(vals=v + " $&Idd") + ".endc\n")
    line = ".control\nsave all\ndc Vvdd 3.0 3.6 0.3\n"
    for k, dev, nom in [LINES[1], LINES[4]]:
        line += f"let i_{k} = abs(@m.x1.{dev}.m0[id])\nlet s_{k} = 100*(i_{k}[2] - i_{k}[0])/i_{k}[1]/0.6\n"
    cace_template(os.path.join(tdir, f"{cell}_tb_line.sch"), f"Template: DC line sensitivity - {cell}",
                  note + "\nvdd = vddo swept 3.0 ... 3.6 V; sensitivity = (I(3.6) - I(3.0)) / I(3.3) / 0.6 V, in %/V.", f"{cell}.sym", pins, conns,
                  src, OPTS + line + OUT.format(vals="$&s_bn $&s_abp") + ".endc\n")

def spec(name, disp, desc, unit, mn, typ, mx):
    f = lambda x: "{value: %s}" % x
    return (f"      {name}:\n        display: {disp}\n        description: {desc}\n        unit: '{unit}'\n"
            f"        minimum: {f(mn)}\n        typical: {f(typ)}\n        maximum: {f(mx)}\n")

def yaml(cell, desc, iref_desc):
    errspec = "".join(spec(f"e_{k}", f"Error of {k}", f"Deviation of the v{k} diode current from {nom*1e6:g} uA. Limits are placeholders.",
                           "%", -5, 0, 5) for k, _, nom in LINES)
    mmspec = "".join(spec(f"e_{k}", f"Error of {k} - Mismatch", f"Deviation of the v{k} diode current under local mismatch. Limits are placeholders.",
                          "%", -10, 0, 10) for k, _, nom in LINES)
    v6 = ", ".join(f"e_{k}" for k, _, _ in LINES)
    return f"""# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#--------------------------------------------------------------
# CACE circuit characterization file, proof of concept (2026-10-08)
# Port of the IHP improvements/sim/run_bias.py checks (accuracy, supply, mc) to gf180mcuD.
# Generated by ../../scripts/gen_cace.py; edit this file from now on.
#--------------------------------------------------------------

name:           {cell}
description:    {desc}
PDK:            gf180mcuD

cace_format:    5.2

authorship:
  designer:         Christoph Maier
  creation_date:    October 8, 2026
  license:          Apache-2.0

paths:
  root:             ..
  schematic:        ../schematic/xschem
  netlist:          cace/netlist
  documentation:    cace/_docs
  runs:             cace/_runs

pins:
  vdd:
    description: Analog supply (bias and front end)
    type: power
    direction: inout
    Vmin: 3.0
    Vmax: 3.6
  vss:
    description: Analog ground
    type: ground
    direction: inout
  vddo:
    description: Output-stage supply (rail of OP and its replica RP1)
    type: power
    direction: inout
  vsso:
    description: Output-stage ground (rail of ON and its replica RN1)
    type: ground
    direction: inout
  iref:
    description: {iref_desc}
    type: signal
    direction: inout
  vbp:
    description: PMOS gate line, 5 uA diode BP (unit tails)
    type: signal
    direction: output
  vbn:
    description: NMOS gate line, 5 uA diode BN (fold sinks)
    type: signal
    direction: output
  vbpc:
    description: PMOS cascode gate line, 2 uA diode BPC
    type: signal
    direction: output
  vbnc:
    description: NMOS cascode gate line, 2 uA diode BNC
    type: signal
    direction: output
  vabp:
    description: class-AB P line, 5 uA into RP2 on RP1
    type: signal
    direction: output
  vabn:
    description: class-AB N line, 5 uA into RN2 on RN1
    type: signal
    direction: output

default_conditions:
  vdd:
    description: Analog supply voltage (vddo = vdd)
    display: VDD
    unit: V
    typical: 3.3
  iref:
    description: Reference current
    display: Iref
    unit: A
    typical: 5e-6
  corner_mos:
    description: Process corner MOSFET (sm141064.ngspice section)
    display: Corner MOSFET
    typical: typical
  corner_res:
    description: Process corner resistors (sm141064.ngspice section)
    display: Corner resistor
    typical: res_typical
  mm:
    description: Local mismatch switch (sw_stat_mismatch)
    display: Mismatch
    typical: 0
  temp:
    description: Ambient temperature
    display: Temperature
    unit: °C
    typical: 27

parameters:
  dc_params:
    spec:
{errspec}      Idd:
        display: Supply current
        description: Current from vdd (vddo tied to vdd), the reference current not included
        unit: uA
        minimum: {{value: any}}
        typical: {{value: any}}
        maximum: {{value: any}}
    tool:
      ngspice:
        template: {cell}_tb_dc.sch
        format: ascii
        suffix: .data
        variables: [{v6}, Idd]
    plot:
      e_bp_vs_temp:
        type: xyplot
        xaxis: temp
        yaxis: e_bp
        limits: auto
      e_abp_vs_vdd:
        type: xyplot
        xaxis: vdd
        yaxis: e_abp
        limits: auto
      e_bpc_vs_corner_mos:
        type: xyplot
        xaxis: corner_mos
        yaxis: e_bpc
        limits: auto
    conditions:
      vdd:
        enumerate: [3.0, 3.3, 3.6]
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      temp:
        enumerate: [-40, 27, 125]

  line_params:
    spec:
{spec("s_bn", "Line sensitivity of vbn", "DC change of the vbn diode current per volt of vdd = vddo, 3.0 ... 3.6 V. Limits are placeholders.", "%/V", -3, 0, 3)}{spec("s_abp", "Line sensitivity of vabp", "DC change of the vabp diode current per volt of vdd = vddo, 3.0 ... 3.6 V. Limits are placeholders.", "%/V", -3, 0, 3)}    tool:
      ngspice:
        template: {cell}_tb_line.sch
        format: ascii
        suffix: .data
        variables: [s_bn, s_abp]
    conditions:
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      temp:
        enumerate: [-40, 27, 125]

  mm_params:
    spec:
{mmspec}      Idd:
        display: Supply current - Mismatch
        description: Current from vdd under local mismatch
        unit: uA
        minimum: {{value: any}}
        typical: {{value: any}}
        maximum: {{value: any}}
    tool:
      ngspice:
        template: {cell}_tb_dc.sch
        collate: iterations
        format: ascii
        suffix: .data
        variables: [{v6}, Idd]
    conditions:
      iterations:
        description: Iterations to run
        display: Iterations
        minimum: 1
        maximum: 100
        step: linear
        stepsize: 1
      mm:
        typical: 1
"""

if __name__ == "__main__":
    tdir = os.path.join(MAC, "verification", "cace", "templates"); os.makedirs(tdir, exist_ok=True)
    for cell, desc, ird, plus, minus in [
        ("ClassABBiasIn", "Bias of the class-AB driver, variant 1: reference current INTO iref (external PMOS source), GF180MCU 03v3",
         "Reference current input, 5 uA flowing into the pin (NMOS input diode NI)", "0", "iref"),
        ("ClassABBiasOut", "Bias of the class-AB driver, variant 2: reference current OUT of iref (external NMOS sink), GF180MCU 03v3",
         "Reference current output, 5 uA flowing out of the pin (PMOS input diode PI)", "iref", "0")]:
        templates(cell, plus, minus, tdir)
        open(os.path.join(MAC, "verification", "cace", cell + ".yaml"), "w").write(yaml(cell, desc, ird))
        print("wrote", cell)
PYEOF
cd /home/claude/work/gf/macros/ClassABBias && python3 scripts/gen_cace.py . && cp schematic/xschem/xschemrc verification/cace/templates/xschemrc && ls verification/cace verification/cace/templates
```

</details>

*[Run CACE for ClassABBiasIn (in the cloud container; 45 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros && python3 - <<'EOF'
s=open('ClassABBias/schematic/xschem/xschemrc').read()
marker='# Add current directory to xschem library path\n'
a,b=s.split(marker); rest=b.split('\n\n',1)[1]
D='[file dirname [info script]]'; J=lambda p: f'[file join {D} {p}]'
for m,extra in [('ClassABBias',[]),('ClassABDriver',[J('../../../../ClassABBias/schematic/xschem')]),('gf180mcu_IOPadDiff2Single',[J('../../../../ClassABDriver/schematic/xschem'),J('../../../../ClassABBias/schematic/xschem'),J('../../../../PadEnable/schematic/xschem')])]:
    import os; os.makedirs(f'{m}/verification/cace/templates',exist_ok=True)
    open(f'{m}/verification/cace/templates/xschemrc','w').write(a+marker+''.join(f'append_xschem_library_path_unique {l}\n' for l in [J('../../schematic/xschem'), D]+extra)+'\n'+rest)
EOF
cd ClassABBias/verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD && source /home/claude/venv/bin/activate && export PATH=/opt/xschem/bin:$PATH && which xschem && (time timeout 1200 cace ClassABBiasIn.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_biasin.out 2>&1); tail -40 /tmp/cace_biasin.out
```

</details>

*[Quote YAML descriptions and rerun CACE (in the cloud container; 36 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias && sed -i 's/^description:    {desc}$/description:    "{desc}"/; s/        description: {desc}\\n        unit/        description: \x27{desc}\x27\\n        unit/' scripts/gen_cace.py && grep -n 'description:    "{desc}"\|description: .{desc}.\\n' scripts/gen_cace.py && python3 scripts/gen_cace.py . >/dev/null && cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && (time timeout 1200 cace ClassABBiasIn.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_biasin.out 2>&1); tail -30 /tmp/cace_biasin.out
```

</details>

*[Read CACE summary for ClassABBiasIn (in the cloud container; 22 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); cat $R/summary.md | sed 's/  */ /g' | head -40
```

</details>

*[Inspect generated CACE testbench netlist (in the cloud container; 41 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); ls $R/parameters/dc_params/ | head; f=$(ls $R/parameters/mm_params/*/*.spice 2>/dev/null | head -1); [ -z "$f" ] && f=$(find $R -name "*.spice" | head -1); echo $f; grep -v "^\*\*" $f | head -40; find $R/parameters/dc_params -name "*.log" | head -2 | xargs tail -5
```

</details>

*[Rename iref condition, pin conditions, rerun CACE (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('"CACE{iref}"','"CACE{i_ref}"').replace('ideal reference current CACE{{iref}}','ideal reference current CACE{{i_ref}}')
s=s.replace('''  iref:
    description: Reference current
    display: Iref''','''  i_ref:
    description: Reference current
    display: Iref''')
s=s.replace('''    conditions:
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      temp:
        enumerate: [-40, 27, 125]

  mm_params:''','''    conditions:
      i_ref:
        typical: 5e-6
      corner_mos:
        enumerate: [typical, ss, sf, fs, ff]
      temp:
        enumerate: [-40, 27, 125]

  mm_params:''')
s=s.replace('''    conditions:
      vdd:
        enumerate: [3.0, 3.3, 3.6]''','''    conditions:
      i_ref:
        typical: 5e-6
      vdd:
        enumerate: [3.0, 3.3, 3.6]''')
s=s.replace('''      mm:
        typical: 1
"""''','''      mm:
        typical: 1
      vdd:
        typical: 3.3
      i_ref:
        typical: 5e-6
      corner_mos:
        typical: typical
      temp:
        typical: 27
"""''')
open(p,'w').write(s)
EOF
grep -c "i_ref" scripts/gen_cace.py; python3 scripts/gen_cace.py . >/dev/null; cd verification/cace && rm -rf _runs _docs netlist && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && timeout 1200 cace ClassABBiasIn.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_biasin.out 2>&1; R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -17; grep "^Iref\|^Vvdd" $(find $R -name "*.spice" | grep mm_params | head -1)
```

</details>

*[Inspect template source values (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; grep -n "Iref\|Vvdd" templates/ClassABBiasIn_tb_dc.sch; ls -la _runs; grep -n "i_ref" ClassABBiasIn.yaml | head
```

</details>

*[Escape CACE placeholders in source values; rerun (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf && sed -i 's|    sheet.raw(f"C {{devices/{kind}.sym}} {x} {y} 0 0 {{name={name} value=\\"{value}\\"}}")|    sheet.raw(f"C {{devices/{kind}.sym}} {x} {y} 0 0 {{name={name} value=\\"{esc(value)}\\"}}")|' scripts/xsheet.py && grep -n 'esc(value)' scripts/xsheet.py && cd macros/ClassABBias && python3 scripts/gen_cace.py . >/dev/null && grep -n "name=Iref" verification/cace/templates/ClassABBiasIn_tb_dc.sch && cd verification/cace && rm -rf _runs _docs netlist && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && timeout 1200 cace ClassABBiasIn.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_biasin.out 2>&1; R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -17
```

</details>

*[Debug device current readout in CACE netlist (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); f=$(find $R/parameters/dc_params -name "*.spice" | head -1); grep "^Vvdd\|^Iref\|^.temp" $f; sed 's/^echo.*/print e_bp e_bn @m.x1.xbp.m0[id] @m.x1.xbn.m0[id] @m.x1.xbp.m0[gm]\nshow m.x1.xbn.m0 : id ids/' $f > /tmp/t.spice; cd /tmp && ngspice -b t.spice 2>&1 | grep -E "^e_|^@|id |ids" | head
```

</details>

*[Inspect CACE .data outputs (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); for d in $(ls -d $R/parameters/dc_params/run_* | head -3); do cat $d/*.data; grep "^Vvdd\|^.temp\|sm141064.ngspice [tsf]" $d/*.spice | tr '\n' ' '; echo; done; ls $R/parameters/dc_params/run_00
```

</details>

*[Echo fractions for % units; rerun both bias suites (in the cloud container; 38 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias && sed -i 's/let e_{k} = 100\*(abs/let e_{k} = (abs/; s/let s_{k} = 100\*(i_{k}/let s_{k} = (i_{k}/' scripts/gen_cace.py && sed -i 's|"Bias currents are the drain currents of the six diodes inside the DUT: XBP, XBN, XBPC, XBNC, XRP2, XRN2\\n"|"Bias currents are the drain currents of the six diodes inside the DUT: XBP, XBN, XBPC, XBNC, XRP2, XRN2\\n"\n            "(echoed as fractions: CACE shows a unit of % as 100 x the value)\\n"|' scripts/gen_cace.py && grep -n "let e_\|let s_\|fractions" scripts/gen_cace.py && python3 scripts/gen_cace.py . >/dev/null && cd verification/cace && rm -rf _runs _docs netlist && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && for c in ClassABBiasIn ClassABBiasOut; do timeout 1200 cace $c.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_$c.out 2>&1; R=$(ls -d _runs/RUN_* | tail -1); echo "== $c"; sed 's/  */ /g' $R/summary.md | tail -17 | cut -d'|' -f2,5-11; done
```

</details>

*[Write results collector; list runs (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/gf/cloud/collect.sh <<'EOF'
#!/bin/bash
# copy the newest CACE run of <cell> (summary.md, plots, csv) into results/<cell>/ (cloud helper)
cd $1; cell=$2; R=$(ls -d _runs/RUN_* | tail -1); out=results/$cell; rm -rf $out; mkdir -p $out
cp $R/summary.md $out/
find $R -maxdepth 3 \( -name "*.png" -o -name "*.csv" \) -exec cp {} $out/ \;
sed -i "1i <!-- CACE run $(basename $R) in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->" $out/summary.md
ls $out | tr '\n' ' '; echo
EOF
chmod +x /home/claude/work/gf/cloud/collect.sh; cd /home/claude/work/gf/macros/ClassABBias/verification/cace; ls -d _runs/*; for c in ClassABBiasIn ClassABBiasOut; do :; done; ls _runs/*/
```

</details>

*[Collect bias CACE results (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; R1=_runs/RUN_2026-10-08_20-11-55; R2=_runs/RUN_2026-10-08_20-12-58; head -1 $R1/summary.md $R2/summary.md; for p in "$R1 ClassABBiasIn" "$R2 ClassABBiasOut"; do set -- $p; out=results/$2; rm -rf $out; mkdir -p $out; cp $1/summary.md $out/; find $1 -maxdepth 3 \( -name "*.png" -o -name "*.csv" \) -exec cp {} $out/ \; ; sed -i "1i <!-- CACE run $(basename $1) in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->" $out/summary.md; ls $out; done; cp /tmp/cace_ClassABBiasIn.out /tmp/cace_ClassABBiasOut.out /mnt/user-data/outputs/log1/ 2>/dev/null; ls /mnt/user-data/outputs/log1
```

</details>

*[Verify results mapping (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABBias/verification/cace; grep -h "Summary for" results/*/summary.md; find _runs -name simulation_summary.csv | head;
```

</details>

*[Fix collector and re-collect bias results (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/gf/cloud/collect.sh <<'EOF'
#!/bin/bash
# collect.sh <cace dir> <cell> <run dir>: summary.md, plots and per-parameter CSVs into results/<cell>/ (cloud helper)
cd $1; cell=$2; R=$3; out=results/$cell; rm -rf $out; mkdir -p $out
cp $R/summary.md $out/
for p in $R/parameters/*/; do pn=$(basename $p); cp $p/*.png $out/ 2>/dev/null; [ -f $p/simulation_summary.csv ] && cp $p/simulation_summary.csv $out/${pn}.csv; done
sed -i "1i <!-- CACE run $(basename $R) in Claude's cloud container: CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->" $out/summary.md
echo "$cell: $(ls $out | tr '\n' ' ')"
EOF
C=/home/claude/work/gf/macros/ClassABBias/verification/cace; /home/claude/work/gf/cloud/collect.sh $C ClassABBiasIn _runs/RUN_2026-10-08_20-11-55; /home/claude/work/gf/cloud/collect.sh $C ClassABBiasOut _runs/RUN_2026-10-08_20-12-58
```

</details>

*[Read IHP noise deck control section (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
cat /home/claude/ihpab/improvements/sim/tb/tb_mpdda_noise.spice | sed -n '/control/,/endc/p'; grep "B 5" /home/claude/work/gf/macros/ClassABDriver/schematic/xschem/ClassABDriverBiased.sym | wc -l
```

</details>

*[Write driver CACE generator and run the suite (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cat > /home/claude/work/gf/macros/ClassABDriver/scripts/gen_cace.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the CACE datasheet and templates of ClassABDriverBiased (ClassABDriver on the ideal bias fixture
ClassABBiasIdeal), GF180MCU, 2026-10-08. Proof-of-concept subset of the IHP decks tb_mpdda_{dc,loop,step,noise}
and of the d2s_miller_biased CACE draft. After the first run, edit the generated files, not this script.
Stimulus and load are element lines in the NGSPICE block: vinp - vref = +vd/2, vinn - vref = -vd/2 (E sources),
load CACE{rload} to vref || CACE{cload} to vss. Values are echoed in SI units (CACE scales to the unit shown);
quantities in % are echoed as fractions.
Usage: gen_cace.py <ClassABDriver macro dir>"""
import os, sys
MAC = os.path.abspath(sys.argv[1])
sys.path.insert(0, os.path.join(MAC, "..", "..", "scripts"))
from xsheet import cace_template, sym_pins

CELL = "ClassABDriverBiased"
OPTS = ".options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15\n"
OUT = "echo {vals} > CACE{{simpath}}/CACE{{filename}}_CACE{{N}}.data\n"
STIM = ("Ep vinp vref dp 0 0.5\nEn vinn vref dp 0 -0.5\nRL vout vref CACE{rload}\nCL vout 0 CACE{cload}\n")
IQ = ("let iqp = abs(@m.x1.xd.xop.m0[id])\nlet iqn = abs(@m.x1.xd.xon.m0[id])\nlet idd = -i(Vvdd) - i(Vvddo)\n")

def templates(tdir):
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", CELL + ".sym"))
    base = dict(vdd="vdd", vss="0", vddo="vddo", vsso="0", vinp="vinp", vinn="vinn", vref="vref", vout="vout",
                **{p: p for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]})
    src = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Vvddo", "CACE{vdd}", "vddo", "0"), ("Vref", "CACE[CACE{vdd}/2]", "vref", "0")]
    note = ("ClassABDriver (x1.xd) on the ideal bias fixture ClassABBiasIdeal (x1.xb): 5 / 5 / 2 / 2 / 5 / 5 uA into the six diodes.\n"
            "vddo = vdd from its own source, vsso = vss. vref = vdd/2. Stimulus and load: element lines in the NGSPICE block.\n"
            "Iq: drain currents of OP (x1.xd.xop) and ON (x1.xd.xon) at vd = 0; Idd = vdd + vddo.")
    # dc: vfb = vout
    dc = (OPTS + "Vd dp 0 0\n" + STIM + ".control\nsave all\nop\n" + IQ +
          "dc Vd -1 1 0.01\nlet vo = v(vout) - v(vref)\n"
          "meas dc vop find vo at=0.2\nmeas dc von find vo at=-0.2\nmeas dc off find vo at=0\n"
          "let gain = (vop - von)/0.4\n"
          "let inrange = abs(v(dp)) le 0.4001\nlet inl = vecmax(abs(vo - gain*v(dp) - off) * inrange)\n"
          + OUT.format(vals="$&gain $&off $&inl $&iqp $&iqn $&idd") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_dc.sch"), f"Template: DC transfer - {CELL}",
                  note + "\nGain = (vo(+0.2) - vo(-0.2))/0.4 with vo = vout - vref; INL = max deviation from that line for |vd| <= 0.4 V (vo = +-0.2 V).",
                  f"{CELL}.sym", pins, dict(base, vfb="vout"), src, dc)
    loop = (OPTS + "Vd dp 0 0\n" + STIM + "Lb vout fb 1G\nCb fb inj 1\nVinj inj 0 dc 0 ac 1\n.control\nsave all\n"
            "ac dec 50 10 1G\nlet T = -v(vout)/v(fb)\nmeas ac T0 find vdb(T) at=10\nmeas ac fc when vdb(T)=0\n"
            "meas ac pT find vp(T) when vdb(T)=0\nlet pm = 180/pi*pT + 180\n" + OUT.format(vals="$&T0 $&fc $&pm") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_loop.sch"), f"Template: loop gain - {CELL}",
                  note + "\nLoop broken at vfb: DC closed through 1 GH, AC injected through 1 F; T = -v(vout)/v(fb) (vfb only drives gates).",
                  f"{CELL}.sym", pins, dict(base, vfb="fb"), src, loop)
    step = (OPTS + "Vd dp 0 pulse(-0.5 0.5 1u 1n 1n 4u 8u)\n" + STIM + ".control\nsave all\n"
            "tran 2n 5u 0 5n\nmeas tran vlo find v(vout) at=0.99u\nmeas tran vhi find v(vout) at=4.9u\n"
            "meas tran vmax max v(vout) from=1u to=5u\nlet overshoot = (vmax - vhi)/(vhi - vlo)\n"
            "let v10 = vlo + 0.1*(vhi - vlo)\nlet v90 = vlo + 0.9*(vhi - vlo)\n"
            "meas tran t10 when v(vout)=v10 rise=1\nmeas tran t90 when v(vout)=v90 rise=1\nlet slew = 0.8*(vhi - vlo)/(t90 - t10)\n"
            "let outside = abs(v(vout) - vhi) gt 0.01*(vhi - vlo)\nlet t_settle = vecmax(time * outside) - 1u\n"
            + OUT.format(vals="$&overshoot $&slew $&t_settle") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_step.sch"), f"Template: step response - {CELL}",
                  note + "\nvd steps -0.5 -> +0.5 V at 1 us (vout vref - 0.25 -> vref + 0.25 V). Settling: last time outside +-1 % of the step.",
                  f"{CELL}.sym", pins, dict(base, vfb="vout"), src, step)
    noise = (OPTS + "Vd dp 0 0 ac 1\n" + STIM + ".control\nsave all\nnoise v(vout) Vd dec 20 10 10meg\nsetplot noise2\n"
             "let vn_total = onoise_total\n" + OUT.format(vals="$&vn_total") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_noise.sch"), f"Template: output noise - {CELL}",
                  note + "\nOutput noise integrated 10 Hz ... 10 MHz.", f"{CELL}.sym", pins, dict(base, vfb="vout"), src, noise)

def spec(name, disp, desc, unit, mn, typ, mx):
    f = lambda x: "{value: %s}" % x
    return (f"      {name}:\n        display: {disp}\n        description: '{desc}'\n        unit: '{unit}'\n"
            f"        minimum: {f(mn)}\n        typical: {f(typ)}\n        maximum: {f(mx)}\n")

def tool(t, variables, collate=False):
    return (f"    tool:\n      ngspice:\n        template: {CELL}_tb_{t}.sch\n" + ("        collate: iterations\n" if collate else "")
            + f"        format: ascii\n        suffix: .data\n        variables: [{', '.join(variables)}]\n")

def conds(**kw):
    s = "    conditions:\n"
    for k, v in kw.items():
        s += f"      {k}:\n" + (f"        enumerate: [{', '.join(map(str, v))}]\n" if isinstance(v, list) else f"        typical: {v}\n")
    return s

def plot(name, x, y):
    return f"      {name}:\n        type: xyplot\n        xaxis: {x}\n        yaxis: {y}\n        limits: auto\n"

def yaml():
    pins = ""
    for p, d, t in [("vdd", "Front-end and bias supply", "power"), ("vss", "Ground", "ground"), ("vddo", "Output-stage supply (OP, RP1)", "power"),
                    ("vsso", "Output-stage ground (ON, RN1)", "ground"), ("vinp", "Positive input", "signal"), ("vinn", "Negative input", "signal"),
                    ("vref", "Output reference (vout - vref = (vinp - vinn)/2)", "signal"), ("vout", "Output", "signal"),
                    ("vfb", "Feedback input (tied to vout in normal use)", "signal")] + \
                   [(b, "Bias line of the ideal fixture, exposed for perturbation", "signal") for b in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]]:
        pins += f"  {p}:\n    description: {d}\n    type: {t}\n    direction: inout\n" + ("    Vmin: 3.0\n    Vmax: 3.6\n" if p == "vdd" else "")
    std = dict(vdd=3.3, corner_mos="typical", temp=27, rload=1000, cload="100e-12")
    pvt = dict(std, vdd=[3.0, 3.3, 3.6], corner_mos=["typical", "ss", "sf", "fs", "ff"], temp=[-40, 27, 125])
    return f"""# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#--------------------------------------------------------------
# CACE circuit characterization file, proof of concept (2026-10-08)
# ClassABDriver on the ideal bias fixture. Port of the IHP decks tb_mpdda_{{dc,loop,step,noise}} to gf180mcuD.
# Generated by ../../scripts/gen_cace.py; edit this file from now on. Limits: IHP d2s_miller_biased draft
# where it had one, otherwise placeholders.
#--------------------------------------------------------------

name:           {CELL}
description:    "ClassABDriver (matched-pair DDA, folded cascode, class-AB output, Miller compensation) on the ideal bias fixture, GF180MCU 03v3"
PDK:            gf180mcuD

cace_format:    5.2

authorship:
  designer:         Christoph Maier
  creation_date:    October 8, 2026
  license:          Apache-2.0

paths:
  root:             ..
  schematic:        ../schematic/xschem
  netlist:          cace/netlist
  documentation:    cace/_docs
  runs:             cace/_runs

pins:
{pins}
default_conditions:
  vdd:
    description: Supply voltage (vdd = vddo)
    display: VDD
    unit: V
    typical: 3.3
  corner_mos:
    description: Process corner MOSFET (sm141064.ngspice section)
    display: Corner MOSFET
    typical: typical
  corner_res:
    description: Process corner resistors
    display: Corner resistor
    typical: res_typical
  mm:
    description: Local mismatch switch (sw_stat_mismatch)
    display: Mismatch
    typical: 0
  temp:
    description: Ambient temperature
    display: Temperature
    unit: °C
    typical: 27
  rload:
    description: Load resistor to vref
    display: R load
    unit: Ohm
    typical: 1000
  cload:
    description: Load capacitor to vss
    display: C load
    unit: F
    typical: 100e-12

parameters:
  dc_params:
    spec:
{spec("gain", "Gain", "(vo(+0.2 V) - vo(-0.2 V)) / 0.4 V, vo = vout - vref; nominal 0.5", "", 0.495, 0.5, 0.505)}{spec("off", "Output offset", "vout - vref at vd = 0", "mV", -5, 0, 5)}{spec("inl", "Integral nonlinearity", "max deviation from the gain line, vo within +-0.2 V", "mV", "any", "any", 2)}{spec("iqp", "OP quiescent current", "drain current of OP at vd = 0 (target 212 uA)", "uA", 100, 212, 500)}{spec("iqn", "ON quiescent current", "drain current of ON at vd = 0", "uA", 100, 212, 500)}{spec("idd", "Supply current", "vdd + vddo at vd = 0", "uA", "any", "any", 600)}{tool("dc", ["gain", "off", "inl", "iqp", "iqn", "idd"])}    plot:
{plot("iqp_vs_temp", "temp", "iqp")}{plot("off_vs_corner_mos", "corner_mos", "off")}{plot("inl_vs_vdd", "vdd", "inl")}{conds(**pvt)}
  loop_params:
    spec:
{spec("T0", "DC loop gain", "loop gain at 10 Hz", "dB", 40, "any", "any")}{spec("fc", "Loop crossover frequency", "unity loop gain", "MHz", 1, "any", "any")}{spec("pm", "Phase margin", "180 deg + phase of T at fc", "°", 45, 60, "any")}{tool("loop", ["T0", "fc", "pm"])}    plot:
{plot("pm_vs_temp", "temp", "pm")}{plot("T0_vs_corner_mos", "corner_mos", "T0")}{conds(**dict(pvt, vdd=3.3))}
  loop_load_params:
    spec:
{spec("T0", "DC loop gain vs load", "loop gain at 10 Hz", "dB", "any", "any", "any")}{spec("fc", "Crossover vs load", "unity loop gain", "MHz", "any", "any", "any")}{spec("pm", "Phase margin vs load", "180 deg + phase of T at fc", "°", 45, "any", "any")}{tool("loop", ["T0", "fc", "pm"])}    plot:
{plot("pm_vs_cload", "cload", "pm")}{conds(**dict(std, rload=[50, 1000, 1e9], cload=["10e-12", "100e-12", "1e-9"]))}
  step_params:
    spec:
{spec("overshoot", "Overshoot", "step -0.25 -> +0.25 V at the output", "%", "any", 0, 10)}{spec("slew", "Rise rate", "10 - 90 % of the step over its time", "V/us", "any", "any", "any")}{spec("t_settle", "1 % settling time", "after the input step", "ns", "any", "any", 1000)}{tool("step", ["overshoot", "slew", "t_settle"])}{conds(**dict(std, corner_mos=["typical", "ss", "sf", "fs", "ff"], temp=[-40, 27, 125]))}
  noise_params:
    spec:
{spec("vn_total", "Output noise", "integrated 10 Hz ... 10 MHz", "uV", "any", "any", "any")}{tool("noise", ["vn_total"])}{conds(**dict(std, corner_mos=["typical", "ss", "ff"]))}
"""

if __name__ == "__main__":
    tdir = os.path.join(MAC, "verification", "cace", "templates"); os.makedirs(tdir, exist_ok=True)
    templates(tdir)
    open(os.path.join(MAC, "verification", "cace", CELL + ".yaml"), "w").write(yaml())
    print("wrote", CELL)
PYEOF
cd /home/claude/work/gf/macros/ClassABDriver && python3 scripts/gen_cace.py . && python3 -c "import yaml; d=yaml.safe_load(open('verification/cace/ClassABDriverBiased.yaml')); print(list(d['parameters']))" && cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && (time timeout 2400 cace ClassABDriverBiased.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_ClassABDriverBiased.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -20 | cut -d'|' -f2,5-11
```

</details>

*[Read CACE error (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
tail -20 /tmp/cace_ClassABDriverBiased.out
```

</details>

*[Rename offset variable and rerun driver CACE (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver && sed -i 's/meas dc off find vo at=0/meas dc vos find vo at=0/; s/vo - gain\*v(dp) - off)/vo - gain*v(dp) - vos)/; s/\$&gain \$&off \$&inl/$\&gain $\&vos $\&inl/; s/spec("off", "Output offset"/spec("vos", "Output offset"/; s/\["gain", "off", "inl"/["gain", "vos", "inl"/; s/plot("off_vs_corner_mos", "corner_mos", "off")/plot("vos_vs_corner_mos", "corner_mos", "vos")/' scripts/gen_cace.py && grep -c "vos" scripts/gen_cace.py && python3 scripts/gen_cace.py . && cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && (time timeout 2400 cace ClassABDriverBiased.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_ClassABDriverBiased.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -20 | cut -d'|' -f2,5-11
```

</details>

*[Debug failing driver CACE templates (in the cloud container; 69 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); for p in dc_params step_params noise_params; do d=$(ls -d $R/parameters/$p/run_* | head -1); echo "== $p"; ls $d; tail -8 $d/ngspice_stdout.out; tail -5 $d/ngspice_stderr.out; done
```

</details>

*[Run failing step and noise netlists manually (in the cloud container; 43 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); for p in step_params noise_params; do d=$(ls -d $R/parameters/$p/run_* | head -1); cp $d/*.spice /tmp/$p.spice; (cd /tmp && ngspice -b $p.spice 2>&1 | grep -iv "^$\|reference value" | head -30); done
```

</details>

*[See tail of step run output (in the cloud container; 26 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && ngspice -b step_params.spice 2>&1 | grep -v "^x1\|^v\|^ *$\|Reference" | tail -25
```

</details>

*[Find tran abort reason (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && ngspice -b step_params.spice 2>&1 | grep -i -B3 "aborted\|timestep\|singular" | head -20
```

</details>

*[Relax solver options; reference op-plot vectors (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('OPTS = ".options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15\\n"',
 'OPTS = ".options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15\\n"  # sparse solver: ngspice noise does not run with KLU')
s=s.replace('''          "let inrange = abs(v(dp)) le 0.4001\\nlet inl = vecmax(abs(vo - gain*v(dp) - off) * inrange)\\n"
          + OUT.format(vals="$&gain $&vos $&inl $&iqp $&iqn $&idd") + ".endc\\n")''','''          "let inrange = abs(v(dp)) le 0.4001\\nlet inl = vecmax(abs(vo - gain*v(dp) - vos) * inrange)\\n"
          + OUT.format(vals="$&gain $&vos $&inl $&op1.iqp $&op1.iqn $&op1.idd") + ".endc\\n")''')
open(p,'w').write(s)
EOF
grep -n "op1\|OPTS =" scripts/gen_cace.py; grep -n "vecmax(abs(vo" scripts/gen_cace.py
```

</details>

*[Show dc template code lines (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 30,40p scripts/gen_cace.py
```

</details>

*[Test plot-qualified op vectors in dc template (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('''          + OUT.format(vals="$&gain $&vos $&inl $&iqp $&iqn $&idd") + ".endc\\n")''','''          "let iq_p = op1.iqp\\nlet iq_n = op1.iqn\\nlet i_dd = op1.idd\\n"
          + OUT.format(vals="$&gain $&vos $&inl $&iq_p $&iq_n $&i_dd") + ".endc\\n")''')
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . >/dev/null; R=$(ls -d verification/cace/_runs/RUN_* | tail -1); d=$(ls -d $R/parameters/dc_params/run_* | head -1); python3 - $d/ClassABDriverBiased_tb_dc.spice <<'EOF'
import sys,re
s=open(sys.argv[1]).read()
s=s.replace(".options savecurrents klu method=gear reltol=1e-4 abstol=1e-15 gmin=1e-15",".options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15")
s=re.sub(r"echo .*", "let iq_p = op1.iqp\nlet iq_n = op1.iqn\nlet i_dd = op1.idd\necho $&gain $&vos $&inl $&iq_p $&iq_n $&i_dd", s)
open('/tmp/dc_t.spice','w').write(s)
EOF
cd /tmp && ngspice -b dc_t.spice 2>&1 | tail -3
```

</details>

*[Rerun driver CACE suite (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver/verification/cace && rm -rf _runs _docs netlist && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && (time timeout 2400 cace ClassABDriverBiased.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_ClassABDriverBiased.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -18 | cut -d'|' -f2,5-11
```

</details>

*[Find worst INL condition; collect driver results (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); head -1 $R/parameters/dc_params/simulation_summary.csv; sort -t, -k4 -g $R/parameters/dc_params/simulation_summary.csv 2>/dev/null | tail -3; /home/claude/work/gf/cloud/collect.sh $(pwd) ClassABDriverBiased $R; cp /tmp/cace_ClassABDriverBiased.out /mnt/user-data/outputs/log1/
```

</details>

*[Identify worst INL and PM conditions (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/ClassABDriver/verification/cace; sort -t, -k7 -g results/ClassABDriverBiased/dc_params.csv | tail -3; sort -t, -k10 -g results/ClassABDriverBiased/loop_load_params.csv 2>/dev/null| head -3; head -1 results/ClassABDriverBiased/loop_load_params.csv; sort -t, -k7 -g results/ClassABDriverBiased/loop_load_params.csv | head -4
```

</details>

*[Append progress to the running log (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
L=/mnt/user-data/outputs/log1/2026-10-08_opus_classab_port_log.md; cat >> $L <<'EOF'

## 20:40 — chat log across the compaction

The automatic compaction at 19:23 rewrote the transcript; the turns before it are only in the 03:07 export.
`chatlog/export_chatlog.py` now skips the compaction summary (not a user message), marks the cut, and can append
to an earlier export (CHATLOG_TURN_OFFSET, CHATLOG_BODY_ONLY, CHATLOG_COMPACT_USER/TIME). The chat log file keeps
turns 1–7 from the earlier export; turn 8 (19:22) has its user message reconstructed from the compaction summary
and says so.

## 20:55 — PadEnable cells (new macro `macros/PadEnable`)

The IHP power_down switch plan, moved into cells of their own (`scripts/gen_padenable.py`, devices 03v3):

- `EnableInv` en → en_b (2u/0.5u, 1u/0.5u). One per pad; a 1.2 V → 3.3 V level shifter would replace it.
- `DriverEnable` SA a→vddo, SB b→vsso, SABP vabp→vdd, SABN vabn→vss (1u/0.5u), on while en = 0.
  ClassABDriver got the ports `a b` (gates of OP / ON) for this.
- `BiasRefEnable` transmission gate iin→iout, TDN pulls iout (NI's gate line) to vss while disabled.
- `InputEnable` transmission gate pin→pout, second gate parks pout on vpark while disabled (4u/0.5u).

Sheets: rails as wires, sources and bulks wired, gates and drains by stub + label. The first draft had the PMOS
drain stub and the NMOS drain stub meet at one point, which merged iin with iout and pin with pout; the round trip
against `scripts/padenable_reference.spice` caught it (XTGN "iout en iout"). Rows moved apart: MISMATCHES 0 on
all four.

Repo-level `scripts/xsheet.py`: the sheet/symbol/CACE-template helpers shared by the generators.

## 21:00 — pads

- `gf180mcu_IOPadDiff2Single` (was ports only): xbias ClassABBiasIn ← xref BiasRefEnable ← iref; xdrv
  ClassABDriver with vfb = out; xen DriverEnable; xinv EnableInv. Ports `vdd vss vddo vsso inp inn vref out iref en`.
  Bias enters as a current. Block level, pins by stub + label (`scripts/gen_iopad_d2s.py`).
- `gf180mcu_IOPadSingle2Diff`: InputEnable behind the CDM network (in_prot → in_en, parked on vcm), EnableInv;
  new port `en`, last (`scripts/add_input_enable.py`, a one-time edit of the existing sheet and symbol).
- macro xschemrc files append the sibling macros they instantiate (`../../../<Macro>/schematic/xschem`).
- Cloud note: the xschem / Tcl here rejects the UTF-8 BOM at the start of the IOPad and top-level xschemrc files
  (every symbol "IS MISSING", netlist empty). The cloud netlisting runs from a BOM-stripped mirror; the files on
  the computer keep their BOM. (The 2026-10-06 note that 3.4.8 accepts the BOM was wrong for this build.)

## 21:05 — CACE: ClassABBiasIn, ClassABBiasOut (`macros/ClassABBias/verification/cace`)

Three parameters each: bias-current errors over 5 MOS corners × −40/27/125 °C × 3.0/3.3/3.6 V; DC line
sensitivity (vdd = vddo 3.0 → 3.6 V); local mismatch, 100 iterations. All pass the placeholder limits:

| | In | Out |
|---|---|---|
| errors over PVT | −1.7 … +2.9 % | −1.5 … +3.4 % |
| line sensitivity vbn / vabp | 0.8–1.3 / 0.6–1.1 %/V | 0.19–0.23 / 0.8–1.3 %/V |
| mismatch, 100 runs, extremes | −1.7 … +3.6 % | −1.7 … +3.8 % |
| Idd (vdd + vddo, without iref) | 24.0–24.4 µA | 29.0–29.3 µA |

CACE lessons (worth keeping): a condition named like a pin (`iref`) took a value of its own (1 mA) — renamed
`i_ref`; every parameter must state the conditions it does not sweep (vdd defaulted to 3.0 V, the pin's Vmin);
`CACE{...}` in a symbol's `value=` must be brace-escaped or xschem eats it; for a unit of `%` CACE shows
100 × the echoed value, so fractions are echoed; `off` is YAML for false.

## 21:20 — CACE: ClassABDriverBiased (`macros/ClassABDriver/verification/cace`)

DUT = ClassABDriver + ClassABBiasIdeal (the IHP d2s_mpdda_biased fixture). 45 + 15 + 9 + 15 + 3 runs, 6 min:

- DC over PVT: gain 0.49943–0.50007, offset 0.013–0.72 mV, I_Q 205–223 µA, Idd 289–307 µA. INL 0.02–3.5 mV,
  fails the 2 mV placeholder only at ss/3.0 V/−40 °C (input pairs out of headroom at vref ± 0.2 V, as on IHP).
- Loop over corners and temperature: T0 59–97 dB, f_c 1.31–1.47 MHz, PM 68–76°.
- Loop vs load (50 Ω / 1 kΩ / open × 10 p / 100 p / 1 nF): PM 24.9° at 1 nF fails, as on IHP.
- Step ±0.25 V: overshoot ≤ 0.3 %, 2.0–2.8 V/µs, 1 % settling 250–415 ns. Noise 10 Hz–10 MHz 245–251 µV.
- ngspice noise does not run with `option KLU` (the OAB template options); the driver templates use the sparse
  solver. Vectors of an earlier plot are read as `op1.<vec>` after a later analysis.
EOF
echo ok
```

</details>

*[Called mcp__remote-devices__device_list_dir (1 lines of output).]*

*[Name CACE output logs for the notes folder (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/log1 && for f in cace_ClassABBiasIn cace_ClassABBiasOut cace_ClassABDriverBiased; do cp $f.out 2026-10-08_opus_$f.out; done; ls -la
```

</details>

*[Check the two bias CACE logs differ (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/log1 && cmp cace_ClassABBiasIn.out cace_ClassABBiasOut.out && echo SAME; grep -m2 "ClassABBias" cace_ClassABBiasIn.out cace_ClassABBiasOut.out | head; rm cace_*.out; ls; wc -c 2026-10-08_opus_classab_port_log.md
```

</details>

*[Copied 4 files from the cloud container to the computer (1 lines of output).]*

*[Write pad CACE generator and run the suite (in the cloud container; 19 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace/templates && cat > /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/scripts/gen_cace.py <<'PYEOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Writes the CACE datasheet and templates of gf180mcu_IOPadDiff2Single (driver + bias tree + enables), GF180MCU,
2026-10-08, proof of concept: enabled DC transfer, disabled state, enable transient (subset of the IHP power_down
checks, power_down/log.md 20:45). After the first run, edit the generated files, not this script.
The reference current comes from a behavioural source between vdd and iref that loses its compliance near vdd
(Bref: I = CACE{i_ref} * tanh(V(vdd, iref) / 0.1 V)), a stand-in for an external PMOS source; with the pad
disabled the transmission gate is open and Bref runs out of compliance instead of forcing the node.
Usage: gen_cace.py <gf180mcu_IOPadDiff2Single macro dir>"""
import os, sys
MAC = os.path.abspath(sys.argv[1])
sys.path.insert(0, os.path.join(MAC, "..", "..", "scripts"))
from xsheet import cace_template, sym_pins

CELL = "gf180mcu_IOPadDiff2Single"
OPTS = ".options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15\n"
OUT = "echo {vals} > CACE{{simpath}}/CACE{{filename}}_CACE{{N}}.data\n"
STIM = ("Bref vdd iref I=CACE{i_ref}*tanh(max(v(vdd,iref),0)/0.1)\n"
        "Ep inp vref dp 0 0.5\nEn inn vref dp 0 -0.5\nRL out vref CACE{rload}\nCL out 0 CACE{cload}\n")

def templates(tdir):
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", CELL + ".sym"))
    conns = dict(vdd="vdd", vss="0", vddo="vddo", vsso="0", inp="inp", inn="inn", vref="vref", out="out", iref="iref", en="en")
    src = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Vvddo", "CACE{vdd}", "vddo", "0"), ("Vref", "CACE[CACE{vdd}/2]", "vref", "0")]
    note = ("gf180mcu_IOPadDiff2Single (x1): bias tree x1.xbias fed through x1.xref from iref, driver x1.xdrv (vfb = out),\n"
            "enable switches x1.xen, inverter x1.xinv. vddo = vdd from its own source, vsso = vss, vref = vdd/2.\n"
            "Bref (NGSPICE block): reference current CACE{i_ref} into iref from vdd, compliance lost near vdd.\n"
            "Stimulus inp - vref = vd/2, inn - vref = -vd/2; load CACE{rload} to vref || CACE{cload}.")
    en_src = ("Ven en 0 CACE{en_v}\n")
    dc = (OPTS + en_src + "Vd dp 0 0\n" + STIM + ".control\nsave all\nop\n"
          "let iqp = abs(@m.x1.xdrv.xop.m0[id])\nlet idd = -i(Vvdd) - i(Vvddo)\n"
          "dc Vd -0.4 0.4 0.01\nlet vo = v(out) - v(vref)\n"
          "meas dc vop find vo at=0.2\nmeas dc von find vo at=-0.2\nmeas dc vos find vo at=0\nlet gain = (vop - von)/0.4\n"
          "let iq_p = op1.iqp\nlet i_dd = op1.idd\n" + OUT.format(vals="$&gain $&vos $&iq_p $&i_dd") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_on.sch"), f"Template: enabled DC transfer - {CELL}",
                  note + "\nen = CACE{en_v} (vdd). Idd = vdd + vddo, including the 5 uA reference current.", f"{CELL}.sym", pins, conns, src, dc)
    off = (OPTS + en_src + "Vd dp 0 0\n" + STIM + ".control\nsave all\nop\n"
           "let idd_off = -i(Vvdd) - i(Vvddo)\nlet va_off = v(vddo) - v(x1.a)\nlet vb_off = v(x1.b)\n"
           "let vout_off = v(out) - v(vref)\nlet iref_n = v(x1.iref_en)\n"
           + OUT.format(vals="$&idd_off $&va_off $&vb_off $&vout_off $&iref_n") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_off.sch"), f"Template: disabled state - {CELL}",
                  note + "\nen = 0: OP / ON gates a, b held at vddo / vsso; Idd = vdd + vddo (Bref included, out of compliance).",
                  f"{CELL}.sym", pins, conns, src, off)
    ena = (OPTS + "Ven en 0 pwl(0 0 1u 0 1.01u CACE{vdd})\nVd dp 0 0\n" + STIM + ".control\nsave all\n"
           "tran 5n 31u 0 20n\nlet vo = v(out) - v(vref)\n"
           "meas tran glitch_max max vo from=1u to=31u\nmeas tran glitch_min min vo from=1u to=31u\n"
           "let glitch = max(abs(glitch_max), abs(glitch_min))\n"
           "let outside = abs(vo) gt 1e-3\nlet t_on = vecmax(time * outside) - 1u\n"
           "meas tran iq_on find @m.x1.xdrv.xop.m0[id] at=30u\nlet iqp = abs(iq_on)\n"
           + OUT.format(vals="$&glitch $&t_on $&iqp") + ".endc\n")
    cace_template(os.path.join(tdir, f"{CELL}_tb_enable.sch"), f"Template: enable transient - {CELL}",
                  note + "\nen rises at 1 us (10 ns edge), vd = 0. glitch = max |out - vref| after the edge; t_on = time after the edge\n"
                  "until out stays within 1 mV of vref. OP's current is saved for the end value.",
                  f"{CELL}.sym", pins, conns, src, ena.replace(".control\nsave all\n", ".save all @m.x1.xdrv.xop.m0[id]\n.control\n"))

def spec(name, disp, desc, unit, mn, typ, mx):
    f = lambda x: "{value: %s}" % x
    return (f"      {name}:\n        display: {disp}\n        description: '{desc}'\n        unit: '{unit}'\n"
            f"        minimum: {f(mn)}\n        typical: {f(typ)}\n        maximum: {f(mx)}\n")

def tool(t, variables):
    return (f"    tool:\n      ngspice:\n        template: {CELL}_tb_{t}.sch\n        format: ascii\n        suffix: .data\n"
            f"        variables: [{', '.join(variables)}]\n")

def conds(**kw):
    s = "    conditions:\n"
    for k, v in kw.items():
        s += f"      {k}:\n" + (f"        enumerate: [{', '.join(map(str, v))}]\n" if isinstance(v, list) else f"        typical: {v}\n")
    return s

def plot(name, x, y):
    return f"      {name}:\n        type: xyplot\n        xaxis: {x}\n        yaxis: {y}\n        limits: auto\n"

def yaml():
    pins = ""
    for p, d, t in [("vdd", "Analog supply (front end, bias, enables)", "power"), ("vss", "Ground", "ground"),
                    ("vddo", "Output-stage supply (OP, RP1, SA)", "power"), ("vsso", "Output-stage ground (ON, RN1, SB)", "ground"),
                    ("inp", "Positive input", "signal"), ("inn", "Negative input", "signal"), ("vref", "Output reference", "signal"),
                    ("out", "Pad output, out - vref = (inp - inn)/2", "signal"), ("iref", "Reference current input, 5 uA into the pin", "signal"),
                    ("en", "Enable, active high, 0 / vdd", "digital")]:
        pins += f"  {p}:\n    description: {d}\n    type: {t}\n    direction: inout\n" + ("    Vmin: 3.0\n    Vmax: 3.6\n" if p == "vdd" else "")
    std = dict(vdd=3.3, corner_mos="typical", temp=27, rload=1000, cload="100e-12", i_ref="5e-6")
    ct = dict(corner_mos=["typical", "ss", "sf", "fs", "ff"], temp=[-40, 27, 125])
    return f"""# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
#--------------------------------------------------------------
# CACE circuit characterization file, proof of concept (2026-10-08)
# Class-AB output pad: ClassABDriver + ClassABBiasIn + PadEnable cells. Subset of the IHP power_down checks.
# Generated by ../../scripts/gen_cace.py; edit this file from now on. Limits are placeholders.
#--------------------------------------------------------------

name:           {CELL}
description:    "Class-AB differential to single-ended pad driver with bias tree and enable, GF180MCU 03v3"
PDK:            gf180mcuD

cace_format:    5.2

authorship:
  designer:         Christoph Maier
  creation_date:    October 8, 2026
  license:          Apache-2.0

paths:
  root:             ..
  schematic:        ../schematic/xschem
  netlist:          cace/netlist
  documentation:    cace/_docs
  runs:             cace/_runs

pins:
{pins}
default_conditions:
  vdd:
    description: Supply voltage (vdd = vddo)
    display: VDD
    unit: V
    typical: 3.3
  en_v:
    description: Enable level
    display: en
    unit: V
    typical: 3.3
  i_ref:
    description: Reference current into iref
    display: Iref
    unit: A
    typical: 5e-6
  corner_mos:
    description: Process corner MOSFET (sm141064.ngspice section)
    display: Corner MOSFET
    typical: typical
  corner_res:
    description: Process corner resistors
    display: Corner resistor
    typical: res_typical
  mm:
    description: Local mismatch switch (sw_stat_mismatch)
    display: Mismatch
    typical: 0
  temp:
    description: Ambient temperature
    display: Temperature
    unit: °C
    typical: 27
  rload:
    description: Load resistor to vref
    display: R load
    unit: Ohm
    typical: 1000
  cload:
    description: Load capacitor to vss
    display: C load
    unit: F
    typical: 100e-12

parameters:
  on_params:
    spec:
{spec("gain", "Gain - enabled", "(vo(+0.2 V) - vo(-0.2 V)) / 0.4 V, vo = out - vref", "", 0.495, 0.5, 0.505)}{spec("vos", "Output offset - enabled", "out - vref at vd = 0", "mV", -5, 0, 5)}{spec("iq_p", "OP quiescent current - enabled", "drain current of OP, real bias tree (target 212 uA)", "uA", 100, 212, 500)}{spec("i_dd", "Supply current - enabled", "vdd + vddo, 5 uA reference included", "uA", "any", "any", 600)}{tool("on", ["gain", "vos", "iq_p", "i_dd"])}    plot:
{plot("iq_p_vs_temp", "temp", "iq_p")}{conds(**dict(std, en_v=3.3, vdd=[3.0, 3.3, 3.6], **ct))}
  off_params:
    spec:
{spec("idd_off", "Supply current - disabled", "vdd + vddo with en = 0", "nA", "any", "any", 100)}{spec("va_off", "OP gate below vddo - disabled", "vddo - v(a)", "mV", -1, 0, 1)}{spec("vb_off", "ON gate above vsso - disabled", "v(b)", "mV", -1, 0, 1)}{spec("vout_off", "Output - disabled", "out - vref (load to vref)", "mV", "any", "any", "any")}{spec("iref_n", "NI gate line - disabled", "v(iref_en), pulled to vss", "mV", "any", "any", 10)}{tool("off", ["idd_off", "va_off", "vb_off", "vout_off", "iref_n"])}    plot:
{plot("idd_off_vs_temp", "temp", "idd_off")}{conds(**dict(std, en_v=0, **ct))}
  enable_params:
    spec:
{spec("glitch", "Output glitch at enable", "max |out - vref| after en rises, vd = 0", "mV", "any", "any", "any")}{spec("t_on", "Enable time", "en edge until out stays within 1 mV of vref", "us", "any", "any", 20)}{spec("iqp", "OP current after enable", "at 30 us", "uA", 100, 212, 500)}{tool("enable", ["glitch", "t_on", "iqp"])}    plot:
{plot("t_on_vs_temp", "temp", "t_on")}{conds(**dict(std, **ct))}
"""

if __name__ == "__main__":
    tdir = os.path.join(MAC, "verification", "cace", "templates"); os.makedirs(tdir, exist_ok=True)
    templates(tdir)
    open(os.path.join(MAC, "verification", "cace", CELL + ".yaml"), "w").write(yaml())
    print("wrote", CELL)
PYEOF
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single && python3 scripts/gen_cace.py . && grep -n "save all @m" verification/cace/templates/*enable.sch | head -2; cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && (time timeout 2400 cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_d2s.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -14 | cut -d'|' -f2,5-11
```

</details>

*[Show disabled-state results per condition (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); cat $R/parameters/off_params/simulation_summary.csv
```

</details>

*[Separate reference supply; rerun pad suite (in the cloud container; 37 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('STIM = ("Bref vdd iref I=CACE{i_ref}*tanh(max(v(vdd,iref),0)/0.1)\\n"',
 'STIM = ("Vsup vsup 0 CACE{vdd}\\nBref vsup iref I=CACE{i_ref}*tanh(max(v(vsup,iref),0)/0.1)\\nRref vsup iref 100Meg\\n"')
s=s.replace('(Bref: I = CACE{i_ref} * tanh(V(vdd, iref) / 0.1 V)), a stand-in for an external PMOS source; with the pad\ndisabled the transmission gate is open and Bref runs out of compliance instead of forcing the node.',
 '(Bref: I = CACE{i_ref} * tanh(V(vsup, iref) / 0.1 V), with 100 MOhm output resistance Rref), a stand-in for an external\nPMOS source on its own supply vsup = vdd, so that Idd does not include it. With the pad disabled the transmission gate\nis open and the source runs out of compliance instead of forcing the node.')
s=s.replace('"Bref (NGSPICE block): reference current CACE{i_ref} into iref from vdd, compliance lost near vdd.\\n"',
 '"Bref, Rref, Vsup (NGSPICE block): reference current CACE{i_ref} into iref from a separate vsup = vdd, compliance lost near vsup.\\n"')
s=s.replace('"let vout_off = v(out) - v(vref)\\nlet iref_n = v(x1.iref_en)\\n"\n           + OUT.format(vals="$&idd_off $&va_off $&vb_off $&vout_off $&iref_n")',
 '"let vout_off = v(out) - v(vref)\\nlet iref_n = v(x1.iref_en)\\nlet iref_off = -i(Vsup)\\n"\n           + OUT.format(vals="$&idd_off $&va_off $&vb_off $&vout_off $&iref_n $&iref_off")')
s=s.replace('{tool("off", ["idd_off", "va_off", "vb_off", "vout_off", "iref_n"])}',
 '{spec("iref_off", "Reference current - disabled", "what the external source still delivers into iref", "nA", "any", "any", "any")}{tool("off", ["idd_off", "va_off", "vb_off", "vout_off", "iref_n", "iref_off"])}')
s=s.replace('"vdd + vddo, 5 uA reference included"','"vdd + vddo; the 5 uA reference comes from its own supply"')
s=s.replace('"vdd + vddo with en = 0"','"vdd + vddo with en = 0, reference source excluded"')
s=s.replace('\\nen = CACE{en_v} (vdd). Idd = vdd + vddo, including the 5 uA reference current.','\\nen = CACE{en_v} (vdd). Idd = vdd + vddo (the reference current has its own supply vsup).')
s=s.replace('Idd = vdd + vddo (Bref included, out of compliance).','Idd = vdd + vddo; iref_off = current still delivered by the reference source.')
open(p,'w').write(s)
EOF
grep -c "vsup" scripts/gen_cace.py; python3 scripts/gen_cace.py . && cd verification/cace && rm -rf _runs _docs netlist && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && (time timeout 2400 cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_d2s.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -15 | cut -d'|' -f2,5-11; cat $R/parameters/off_params/simulation_summary.csv | cut -d, -f1-4,9
```

</details>

*[Debug disabled-state supply current (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); f=$R/parameters/off_params/run_01/*.spice; cp $f /tmp/off.spice; python3 - <<'EOF'
s=open('/tmp/off.spice').read()
import re
s=re.sub(r"echo .*\n", "print -i(Vvdd) -i(Vvddo) i(Vref) i(Ven) i(Vsup)\nprint v(vbp) v(vbn) v(vbpc) v(vbnc) v(vabp) v(vabn) v(x1.a) v(x1.b) v(x1.en_b) v(en) v(x1.iref_en) v(iref) v(out)\nprint v(x1.xdrv.x) v(x1.xdrv.y) v(x1.xdrv.l1) v(x1.xdrv.l2)\n", s)
open('/tmp/off2.spice','w').write(s)
EOF
cd /tmp && ngspice -b off2.spice 2>&1 | grep "= " | head -30
```

</details>

*[Dump device currents in disabled state (in the cloud container; 121 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && python3 - <<'EOF'
s=open('/tmp/off2.spice').read()
import re
s=re.sub(r"print -i\(Vvdd\).*?\.endc", """let a1 = -i(Vvdd)
let a2 = -i(Vvddo)
print a1 a2
print v(vbp) v(vbn)
print v(x1.vbpc) v(x1.vbnc) v(x1.vabp) v(x1.vabn)
print v(x1.a) v(x1.b) v(x1.en_b) v(en) v(x1.iref_en) v(iref) v(out)
show m : id vgs vds
.endc""", s, flags=re.S)
open('/tmp/off3.spice','w').write(s)
EOF
ngspice -b off3.spice 2>&1 | grep -v "^ *$" | grep -A400 "a1 =" | head -120
```

</details>

*[Find largest junction/gate currents (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && sed 's/^show m : id vgs vds/show m : ibd ibs igidl igisl igs igd igb/' off3.spice > off4.spice && ngspice -b off4.spice 2>&1 | python3 -c "
import sys,re
lines=sys.stdin.read().splitlines()
devs=[];best=[]
for l in lines:
    t=l.split()
    if not t: continue
    if t[0]=='device': devs=t[1:]
    elif t[0] in ('ibd','ibs','igidl','igisl','igs','igd','igb') and devs:
        for d,v in zip(devs,t[1:]):
            try: best.append((abs(float(v)),t[0],d))
            except: pass
best.sort(reverse=True)
for b in best[:12]: print(b)
"
```

</details>

*[Show resistor and B-source currents (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && python3 - <<'EOF'
s=open('/tmp/off3.spice').read()
s=s.replace("show m : id vgs vds","op\nlet all = 0\nprint all > /dev/null\nwrite /tmp/off_op.raw all\nshow r : i\nshow b : i")
open('/tmp/off5.spice','w').write(s)
EOF
ngspice -b off5.spice 2>&1 | grep -A12 "Resistor\|Behav" | head -60; grep -c "" /tmp/off_op.raw 2>/dev/null
```

</details>

*[Test numerical sensitivity of disabled Idd (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp && for o in ".options reltol=1e-4 abstol=1e-12 gmin=1e-15" ".options gmin=1e-12" ".options reltol=1e-6 abstol=1e-15 gmin=1e-15 itl1=500"; do sed "s/^\.options savecurrents reltol=1e-4 abstol=1e-12 gmin=1e-15/$o/" off3.spice | sed 's/^show m : id vgs vds//' > off6.spice; echo "$o: $(ngspice -b off6.spice 2>&1 | grep -E '^a1|^a2' | tr '\n' ' ')"; done
```

</details>

*[Use gmin 1e-12 for the disabled test; rerun pad suite in background (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('''    off = (OPTS + en_src''','''    # gmin = 1e-12 here: with every current root switched off, most nodes float; at gmin = 1e-15 the operating
    # point leaves KCL residues of tens of uA on the supplies (checked 2026-10-08: 17 uA, sign changing with the
    # tolerances), at 1e-12 the supply current is the leakage (tens of pA at 27 C)
    off = (OPTS.replace("gmin=1e-15", "gmin=1e-12") + en_src''')
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . && grep -c "gmin=1e-12" verification/cace/templates/*off.sch && cd verification/cace && rm -rf _runs _docs netlist && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && nohup sh -c "timeout 2400 cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_d2s.out 2>&1" > /dev/null 2>&1 &
echo started
```

</details>

*[Confirm template change and run started (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single; grep -c "gmin=1e-12" verification/cace/templates/*_tb_off.sch verification/cace/templates/*_tb_on.sch; sleep 5; tail -3 /tmp/cace_d2s.out
```

</details>

*[Tie the new en pin high in Single2Diff testbench and template (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff && for f in verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch; do grep -n "gf180mcu_IOPadSingle2Diff.sym\|560 -320\|540 -320" $f; printf 'N 560 -320 520 -320 {lab=vdd}\nC {devices/lab_pin.sym} 520 -320 0 0 {name=l40 sig_type=std_logic lab=vdd}\nT {en tied to vdd (pad enabled); added 2026-10-08} 380 -350 0 0 0.2 0.2 {}\n' >> $f; done; grep -n "l40\|name=l4 \|540 -280" testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch | head
```

</details>

*[Netlist and run updated Single2Diff testbench (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; TOPSUB=0 /home/claude/work/gf/cloud/nl.sh /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch; grep -i "^xdut" /tmp/nl/gf180mcu_IOPadSingle2Diff_tb_dc.spice; cd /tmp/nl && timeout 300 ngspice -b gf180mcu_IOPadSingle2Diff_tb_dc.spice 2>&1 | grep -iE "error|= " | head
```

</details>

*[Write ClassABBias README (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

~~~~sh
mkdir -p /home/claude/work/gf/macros/ClassABBias/testbenches/xschem /home/claude/work/gf/macros/PadEnable/testbenches/xschem; cat > /home/claude/work/gf/macros/ClassABBias/README.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# ClassABBias (GF180MCU)

Bias of the class-AB pad driver (`../ClassABDriver`): six bias lines, generated by diode-connected devices on the
rail of the devices they bias, so that bias crosses from block to block as currents only.

| line | current | diode | biases (in ClassABDriver) |
|---|---|---|---|
| vbp | 5 µA out of | BP 20u/6u nf=2 | DDA unit tails Ta, Tb |
| vbn | 5 µA into | BN 6u/6u | fold sinks SX, SY |
| vbpc | 2 µA out of | BPC 1u/4u | mirror cascodes PCL, PCR |
| vbnc | 2 µA into | BNC 1u/8u | fold cascodes CX, CY |
| vabp | 5 µA out of | RP2 6.66u/0.6u on RP1 12u/0.6u nf=2 | class-AB control ABP, FPL |
| vabn | 5 µA into | RN2 4.4u/1u on RN1 8u/1u nf=2 | class-AB control ABN, FNL |

RP1 and RN1 are the replicas of the output devices OP and ON and sit on the output-stage rails vddo / vsso, like
OP and ON: any voltage between vdd and vddo adds to the translinear loop and moves the quiescent current. In layout,
RP1's source is taken from OP's source rail and RN1's from ON's (Kelvin). RP2's n-well stays on vdd, like ABP's.

**Status: proof of concept (2026-10-08).** Schematics, symbols and CACE suites; no layout. Port of the IHP
sg13cmos5l design notes (`sg13cmos5l_..._sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/`:
`bias.md`, `sim/d2s_bias_ref.spice`, `xschem/d2s_bias_*.sch`), 03v3 devices at 3.3 V.

## Cells

| cell | IHP sheet | ports | content |
|---|---|---|---|
| `ClassABBiasIn` | `d2s_bias_in` | vdd vss vddo vsso iref vbp vbn vbpc vbnc vabp vabn | variant 1: 5 µA **into** iref (external PMOS source) → NMOS input diode NI 6u/6u; NI's gate line drives the sinks out of the PMOS diodes, BP's gate line the sources into the NMOS diodes |
| `ClassABBiasOut` | `d2s_bias_out` | same | variant 2: 5 µA **out of** iref (external NMOS sink) → PMOS input diode PI 20u/6u |
| `ClassABBiasIdeal` | `d2s_bias_lp` | vdd vss vddo vsso + six lines | test fixture: ideal currents into the same six diodes (used by `ClassABDriverBiased`) |

Each sheet is flat at transistor level, as on IHP: reference [R], mirror tree and the six diodes [8]. The two
self-contained IHP variants (Oguey–Aebischer `d2s_bias_oa`, bandgap `d2s_bias_bg`) are not ported yet; both need
a real re-design for GF180 (weak-inversion sizing; the bandgap's PTAT/CTAT balance relied on rhigh's TC, and the
vertical PNPs of GF180 have fixed geometry).

The pad (`../gf180mcu_IOPadDiff2Single`) uses `ClassABBiasIn` behind `PadEnable/BiasRefEnable`.

## Sizing (re-derived for GF180, 2026-10-08)

Started from the IHP geometry; changed where GF180 simulation required it (details: notes worktree,
`logs/main/2026-10-08_opus_classab_port_log.md`):

- vbp diode BP and its copies 5u/6u → 20u/6u nf=2, together with the DDA unit tails: at ss/3.0 V/−40 °C the
  5u/6u tails had V_DS 0.35 V below V_DSsat 0.43 V.
- RP1 13.32u → 12u/0.6u, RN1 8.8u → 8u/1u: quiescent current of the driver 212 µA, as on IHP.
- NBPC 2.4u → 2.5u/6u: narrow-width error of the 2 µA line −3.6 % → +0.7 %.

The source of the port is `../ClassABDriver/scripts/gf180_sizing.spice`; `port_classab_from_ihp.py` and
`check_classab_port.py` there drew the sheets from the IHP drawings and compare xschem's netlists with it
(MISMATCHES 0 on 2026-10-08).

## CACE (`verification/cace/`, results in `verification/cace/results/<cell>/`)

```
cd verification/cace
cace ClassABBiasIn.yaml -s schematic --nofail -j 4 --parallel-parameters 1
```

Three parameters per cell, about 1 min each: bias-current errors over 5 MOS corners × −40/27/125 °C × 3.0/3.3/3.6 V,
DC line sensitivity (vdd = vddo 3.0 → 3.6 V), local mismatch (100 iterations). Limits are placeholders.

| | ClassABBiasIn | ClassABBiasOut |
|---|---|---|
| current errors over PVT | −1.7 … +2.9 % | −1.5 … +3.4 % |
| line sensitivity vbn / vabp | 0.8–1.3 / 0.6–1.1 %/V | 0.19–0.23 / 0.8–1.3 %/V |
| mismatch, 100 runs, extremes | −1.7 … +3.6 % | −1.7 … +3.8 % |
| supply current (without iref) | 24 µA | 29 µA |

Generated by `scripts/gen_cace.py`; edit the yaml and templates from now on. Currents are read as
`@m.x1.<device>.m0[id]` of the diodes inside the DUT; errors are echoed as fractions because CACE shows a unit of
`%` as 100 × the value.

## Open points

- Enable: the switches live in `../PadEnable` (BiasRefEnable cuts iref and pulls NI's gate line low).
  `ClassABBiasOut` would need the mirror image of BiasRefEnable (pull PI's gate line to vdd); not drawn yet.
- Which reference feeds iref, and how many pads share it, is not decided; the bias tree is meant to sit in each pad.
- No layout. RP1 / RN1 need the Kelvin connection to OP's / ON's source rails.
EOF
echo ok
~~~~

</details>

*[Write ClassABDriver and PadEnable READMEs (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

~~~~sh
cat > /home/claude/work/gf/macros/ClassABDriver/README.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# ClassABDriver (GF180MCU)

Class-AB differential → single-ended driver for an analog output pad: matched-pair DDA input (four identical
units), folded cascode, class-AB output OP / ON with a floating class-AB control, Miller compensation with MOS
capacitors. With vfb tied to vout: **vout − vref = (vinp − vinn)/2** for any matched, odd unit law.

**Status: proof of concept (2026-10-08).** Port of the IHP sg13cmos5l design `d2s_mpdda`
(`sg13cmos5l_..._sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/`: `log.md`,
`proposed_improvements.md`, `sim/d2s_mpdda.spice`, `xschem/d2s_mpdda.sch`), 03v3 devices at 3.3 V. No layout.

## Cells

| cell | IHP sheet | ports | content |
|---|---|---|---|
| `ClassABDriver` | `d2s_mpdda` | vdd vss vddo vsso vinp vinn vref vout vfb vbp vbn vbpc vbnc vabp vabn **a b** | the driver; `a`, `b` (gates of OP / ON) are ports for the enable switches (`../PadEnable/DriverEnable`) |
| `ClassABUnitR` | `unit_r2` | x y gp gn vdd vss vbp | DDA unit: split-tail PMOS pair, ppolyf_u_3k between the sources |
| `ClassABDriverBiased` | `d2s_mpdda_biased` | as ClassABDriver without a, b | CACE fixture: ClassABDriver + `../ClassABBias/ClassABBiasIdeal`; bias lines are pins for perturbation |

Blocks ([1]–[7] on the sheet, as on IHP): [1] DDA units A, B, C1, C2; [2] fold sinks SX, SY and cascodes CX, CY;
[3] cascoded PMOS mirror; [4] class-AB control ABP / ABN; [5] its copy FPL / FNL; [6] output devices; [7] Miller
capacitors. The output devices sit on their own rails vddo / vsso.

## Sizing (re-derived for GF180, 2026-10-08)

| | IHP sg13_hv | GF180 03v3 | why |
|---|---|---|---|
| unit tails Ta, Tb | 5u/6u | 20u/6u nf=2 | headroom at ss/3.0 V/−40 °C (V_DS 0.35 V < V_DSsat 0.43 V; INL 6 mV → 0.37 mV) |
| degeneration R | rhigh 0.5u/50.6u | ppolyf_u_3k 1u/50u (≈ 150 kΩ) | GF180 high-R poly; TC −0.17 %/K instead of −0.22 %/K |
| OP | 546.12u/0.6u ng=82 | 91.02u/0.6u nf=14 **m=6** | GF180 model bins end at W = 100 µm per instance (total W, not W/nf) |
| ON | 290.4u/1u ng=66 | 96.8u/1u nf=22 **m=3** | same |
| CMA, CMB | hv PMOS 16u/16u | pfet_03v3 16u/16u (accumulation) | — |
| everything else | | unchanged | GF180 03v3 behaves much like sg13_hv here |

The replicas RP1 / RN1 in the bias were trimmed for I_Q = 212 µA (see `../ClassABBias`).

`scripts/port_classab_from_ihp.py` drew the GF180 sheets from the hand-edited IHP drawings (wires and placement
kept; GF180 FET symbols have the sg13_hv pin geometry), with the sizes from `scripts/gf180_sizing.spice`.
`scripts/check_classab_port.py` compares xschem's netlist of each sheet with that file device by device:

```sh
xschem --rcfile schematic/xschem/xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp schematic/xschem/ClassABDriver.sch
python3 scripts/check_classab_port.py scripts/gf180_sizing.spice /tmp/ClassABDriver.spice d2s_mpdda ClassABDriver a b
```

MISMATCHES 0 for all ported cells on 2026-10-08 (bias cells: reference subckts `d2s_bias_lp`, `d2s_bias_in`,
`d2s_bias_out`). After this port, the sheets are the source of truth.

## Testbenches (`testbenches/xschem/`, ported IHP decks)

| sheet | result (tt, 27 °C, 3.3 V, 1 kΩ ∥ 100 pF) |
|---|---|
| `ClassABDriver_tb_dc` | gain 0.49999, offset 0.017 mV, nonlinearity 1.5 mV over ±1 V, I_Q 212.8 µA, Idd 297 µA |
| `ClassABDriver_tb_loop` | T0 93.1 dB, f_c 1.40 MHz, PM 72.7° (IHP 78.9 dB, 1.37 MHz, 72.4°) |
| `ClassABDriver_tb_step` | ±0.25 V step: no overshoot, 2.4 V/µs |
| `ClassABDriver_tb_thd` | 0.145 % at 10 kHz, 1 V differential (IHP 0.119 %) |
| `ClassABDriver_tb_noise` | 249 µV, 10 Hz … 10 MHz |
| `ClassABDriver_tb_op` | operating point and saturation margins of every device |

The decks' IHP `.lib` lines are replaced by a MODELS block (`$::180MCU_MODELS/sm141064.ngspice typical`,
`res_typical`, `moscap_typical`).

## CACE (`verification/cace/`, results in `verification/cace/results/ClassABDriverBiased/`)

DUT `ClassABDriverBiased`; 87 runs, about 6 min on two cores. Limits: IHP d2s_miller_biased draft where it had
one, otherwise placeholders.

| parameter | conditions | result |
|---|---|---|
| gain | 5 corners × −40/27/125 °C × 3.0/3.3/3.6 V | 0.49943 … 0.50007 |
| offset | same | 0.013 … 0.72 mV |
| INL (vout − vref within ±0.2 V) | same | 0.02 … 3.5 mV; **fails 2 mV at ss/3.0 V/−40 °C** (input-pair headroom, as on IHP) |
| I_Q (OP / ON) | same | 205 … 223 µA |
| loop T0 / f_c / PM | 5 corners × 3 temperatures | 59–97 dB / 1.31–1.47 MHz / 68–76° |
| PM vs load | 50 Ω, 1 kΩ, open × 10 p, 100 p, 1 nF | **24.9° at 1 nF fails**, as on IHP (Miller loop sized for 100 pF) |
| step | 5 corners × 3 temperatures | overshoot ≤ 0.3 %, 2.0–2.8 V/µs, 1 % settling 250–415 ns |
| output noise | typical, ss, ff | 245–251 µV |

```
cd verification/cace
cace ClassABDriverBiased.yaml -s schematic --nofail -j 4 --parallel-parameters 1
```

Generated by `scripts/gen_cace.py`; edit the yaml and templates from now on. Stimulus and load are element lines
in the NGSPICE block. The templates use ngspice's sparse solver: noise analysis does not run with `option KLU`.

## Open points (from the IHP notes, unchanged by the port)

- Supply rejection of the output-stage rails is only the loop gain (Miller capacitors tie a / b to vout).
- FPL carries only ~10 nA (IHP: ~1 nA): the copy of the class-AB control in the mirror input branch.
- Input common-mode headroom at 3.0 V, cold, slow corner.
- Whether OP / ON double as the pad's ESD clamps (IHP case (a)) depends on the GF180 pad frame; not modelled.
EOF
cat > /home/claude/work/gf/macros/PadEnable/README.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# PadEnable (GF180MCU)

Enable circuits of the analog pads, as cells of their own instead of switches spread through the driver and bias
cells (as in the IHP `power_down/` study, 2026-10-06, whose switch plan they implement). `en` is active high,
0 / vdd; every switch is **on while disabled** and off while enabled.

**Status: proof of concept (2026-10-08).** Schematics and symbols; tested inside the pads
(`../gf180mcu_IOPadDiff2Single` CACE `off_params`, `enable_params`). No layout.

| cell | ports | devices (03v3) | function |
|---|---|---|---|
| `EnableInv` | vdd vss en en_b | MP 2u/0.5u, MN 1u/0.5u | en_b for the other cells, one per pad. A 1.2 V → 3.3 V level shifter replaces it when the enable comes from 1.2 V logic |
| `DriverEnable` | vdd vss vddo vsso en en_b a b vabp vabn | SA, SABP (pfet), SB, SABN (nfet), 1u/0.5u | disabled: a (gate of OP) → vddo, b (gate of ON) → vsso, so OP / ON are off with their gates tied to their own rails as in a clamp; vabp → vdd, vabn → vss, otherwise ABP / ABN would conduct from the a pull-up into the b pull-down |
| `BiasRefEnable` | vdd vss en en_b iin iout | TGN, TGP, TDN 1u/0.5u | transmission gate iin → iout (the bias tree's iref) while enabled; disabled: open, and TDN pulls iout (gate line of the NMOS input diode NI) to vss. The external reference is not relied on to switch off |
| `InputEnable` | vdd vss en en_b pin pout vpark | TGN1/TGP1, TGN2/TGP2 4u/0.5u | input switch behind the CDM network: pin → pout while enabled; disabled: pout parked on vpark (the common-mode reference) |

SA and SB sit on the output-stage rails: SA's n-well on vddo, SB in ON's tap ring on vsso.

`scripts/gen_padenable.py` wrote the sheets and symbols (rails as wires, sources and bulks wired to them, gates
and drains by stub and label); `scripts/padenable_reference.spice` is the reference netlist, checked with
`../ClassABDriver/scripts/check_classab_port.py` (MISMATCHES 0). The first draft had a PMOS and an NMOS drain stub
meet at one point, which merged iin with iout; the round trip caught it.

## What the IHP study found that carries over (not re-simulated here unless stated)

- The bias lines without a switch (vbp, vbpc, vbn, vbnc) only carry leakage once the roots are off.
- Unpowered (no supply, en floating or 0): the pull-ups have no gate drive; ESD protection has to come from the
  pad's own network. Not modelled in GF180 yet.
- At enable, a and b are released at once while the bias is still coming up: an output glitch. GF180 pad CACE:
  170–490 mV, settled within 1 mV after 1.3–1.5 µs.
EOF
echo ok; tail -3 /tmp/cace_d2s.out
~~~~

</details>

*[Read current pad READMEs (in the cloud container; 51 lines of output).]*

<details><summary>command</summary>

```sh
cat /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/README.md; cat /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/README.md
```

</details>

*[Read top-level README macro sections and CLAUDE.md (in the cloud container; 96 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; grep -n "macros\|OgueyAebischer\|IOPad" $U/README.md | head -40; echo ----; cat $U/CLAUDE.md | sed -n 1,80p
```

</details>

*[Copy top-level docs into work tree and read sections to edit (in the cloud container; 153 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; W=/home/claude/work/gf; mkdir -p $W/schematic/xschem $W/docs; cp $U/schematic/xschem/xschemrc $W/schematic/xschem/; cp $U/README.md $U/CLAUDE.md $U/HANDOVER_gf180_migration.md $W/; cp $U/docs/IHP_TO_GF180_PORT_MAP.md $U/docs/OPERATING_LIMITS.md $W/docs/; chmod u+w -R $W/schematic $W/docs $W/*.md; sed -n 70,96p $W/README.md; sed -n 145,200p $W/README.md; cat $W/docs/IHP_TO_GF180_PORT_MAP.md | tail -30; tail -40 $W/HANDOVER_gf180_migration.md
```

</details>

Now the top-level edits.

*[Edit top-level xschemrc, README, CLAUDE.md, port map, handover (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf && python3 - <<'EOF'
import re
def edit(p, pairs):
    s = open(p, encoding='utf-8').read()
    for a, b in pairs:
        assert a in s, (p, a[:60])
        s = s.replace(a, b, 1)
    open(p, 'w', encoding='utf-8').write(s)

edit('schematic/xschem/xschemrc', [(
 "source [file dirname [info script]]/../../macros/OgueyAebischerBias/schematic/xschem/xschemrc\n",
 "source [file dirname [info script]]/../../macros/OgueyAebischerBias/schematic/xschem/xschemrc\n"
 "source [file dirname [info script]]/../../macros/ClassABBias/schematic/xschem/xschemrc\n"
 "source [file dirname [info script]]/../../macros/ClassABDriver/schematic/xschem/xschemrc\n"
 "source [file dirname [info script]]/../../macros/PadEnable/schematic/xschem/xschemrc\n")])

edit('README.md', [
 ("│  └─ 📁 gf180mcu_IOPadDiff2Single/  # D2S class-AB driver + analog output pad, same structure\n",
  "│  ├─ 📁 gf180mcu_IOPadDiff2Single/  # D2S class-AB driver + analog output pad, same structure\n"
  "│  ├─ 📁 ClassABDriver/  📁 ClassABBias/  📁 PadEnable/   # building blocks of the pads (2026-10-08)\n"
  "│  └─ 📁 OgueyAebischerBias/         # resistor-free bias reference\n"),
 ("Has `sim-cace` / `sim-cace-all` targets. Not yet part of `build-macros`.\n",
  "Has `sim-cace` / `sim-cace-all` targets. Not yet part of `build-macros`.\n"
  "- **[`macros/ClassABDriver/`](macros/ClassABDriver/README.md)**: the class-AB driver core (matched-pair DDA, folded cascode, class-AB output, Miller compensation) and its CACE fixture `ClassABDriverBiased`; ported from the IHP design notes, re-sized for GF180 (2026-10-08).\n"
  "- **[`macros/ClassABBias/`](macros/ClassABBias/README.md)**: the driver's bias trees `ClassABBiasIn` / `ClassABBiasOut` (reference current into / out of `iref`) and the ideal fixture `ClassABBiasIdeal`, each with its own CACE suite.\n"
  "- **[`macros/PadEnable/`](macros/PadEnable/README.md)**: enable cells of the analog pads (`EnableInv`, `DriverEnable`, `BiasRefEnable`, `InputEnable`).\n"
  "  These three have no Makefile yet (the bridge cannot write Makefiles); run CACE directly in `verification/cace/`.\n"),
 ("| [`macros/OgueyAebischerBias/testbenches/xschem/xschemrc`](macros/OgueyAebischerBias/testbenches/xschem/xschemrc) | bias macro testbenches |\n",
  "| [`macros/OgueyAebischerBias/testbenches/xschem/xschemrc`](macros/OgueyAebischerBias/testbenches/xschem/xschemrc) | bias macro testbenches |\n"
  "| `macros/{ClassABDriver,ClassABBias,PadEnable}/{schematic,testbenches}/xschem/xschemrc` | building blocks of the pads; each also appends the sibling macros it instantiates |\n"),
 ("   └─ source macros/OgueyAebischerBias/schematic/xschem/xschemrc\n",
  "   ├─ source macros/OgueyAebischerBias/schematic/xschem/xschemrc\n"
  "   ├─ source macros/ClassABBias/schematic/xschem/xschemrc\n"
  "   ├─ source macros/ClassABDriver/schematic/xschem/xschemrc\n"
  "   └─ source macros/PadEnable/schematic/xschem/xschemrc\n"),
 ("The macro files do not source each other or the top level, so a macro can be opened and simulated on its own.",
  "The macro files do not source each other or the top level, so a macro can be opened and simulated on its own. A macro that instantiates cells of another macro (the pads, `ClassABDriver`) appends that macro's `schematic/xschem` folder with a relative path instead (`../../../<Macro>/schematic/xschem`)."),
])

edit('CLAUDE.md', [(
 "port-only skeleton of `macros/gf180mcu_IOPadDiff2Single`. **No layout exists**;",
 "port-only skeleton of `macros/gf180mcu_IOPadDiff2Single`.\n"
 "**2026-10-08:** class-AB driver port, proof of concept: `macros/ClassABDriver` (driver core + CACE fixture),\n"
 "`macros/ClassABBias` (bias trees In/Out + ideal fixture), `macros/PadEnable` (enable cells); the output pad\n"
 "`gf180mcu_IOPadDiff2Single` now instantiates them, the input pad got `InputEnable` and an `en` port. CACE suites run\n"
 "in the cloud for all of them (results in each `verification/cace/results/`). Running log:\n"
 "`_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md`. **No layout exists**;")])

edit('docs/IHP_TO_GF180_PORT_MAP.md', [(
 "| KPEX | supported for IHP |",
 "| Class-AB driver | `d2s_mpdda` + `unit_r2` (IHP notes worktree `design_considerations/class_ab_pad_driver/improvements/`) | `macros/ClassABDriver`: `ClassABDriver`, `ClassABUnitR`, fixture `ClassABDriverBiased` | 2026-10-08: hand-drawn IHP sheets ported (wires kept), sizes re-derived: tails 20u/6u, OP/ON split with `m` (bin limit), rhigh → `ppolyf_u_3k`; ports `a b` added for the enable |\n"
 "| Driver bias | `d2s_bias_in`, `_out`, `d2s_bias_lp` (+ `_oa`, `_bg`) | `macros/ClassABBias`: `ClassABBiasIn`, `ClassABBiasOut`, `ClassABBiasIdeal` | 2026-10-08; `_oa` and `_bg` not ported (need a GF180 re-design) |\n"
 "| Enable / power-down | switches inside every `_pd` cell (`power_down/`) | `macros/PadEnable`: `EnableInv`, `DriverEnable`, `BiasRefEnable`, `InputEnable` | 2026-10-08: same switch plan, as cells of their own; `en` 0 / vdd |\n"
 "| Degeneration resistor | `rhigh` (body = attribute) | `ppolyf_u_3k` (v), bulk is a pin (M P B) | TC −0.17 %/K vs −0.22 %/K |\n"
 "| KPEX | supported for IHP |")])
print("edited")
EOF
cat >> HANDOVER_gf180_migration.md <<'EOF'

## 8. 2026-10-08: class-AB driver, its bias and the pad enables (proof of concept)

Requested by Christoph as a smoke test of the schematic and verification flow; the IHP design stays the
reference and is re-migrated later. Running log with every number and decision:
`_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md`.

- New macros: `ClassABDriver` (driver core `ClassABDriver` with ports `a b` for the enable, unit `ClassABUnitR`,
  CACE fixture `ClassABDriverBiased`, six ported IHP testbenches), `ClassABBias` (`ClassABBiasIn`, `ClassABBiasOut`,
  fixture `ClassABBiasIdeal`), `PadEnable` (`EnableInv`, `DriverEnable`, `BiasRefEnable`, `InputEnable`).
- `gf180mcu_IOPadDiff2Single`: block-level sheet (bias tree fed by `iref` through `BiasRefEnable`, driver with
  vfb = out, `DriverEnable`, `EnableInv`); ports `vdd vss vddo vsso inp inn vref out iref en`.
- `gf180mcu_IOPadSingle2Diff`: `InputEnable` behind the CDM network (`in_prot` → `in_en`, parked on `vcm`),
  `EnableInv`, new last port `en`; its testbench and CACE template tie `en` to vdd.
- CACE suites with results: `ClassABBiasIn`, `ClassABBiasOut`, `ClassABDriverBiased`, `gf180mcu_IOPadDiff2Single`;
  `gf180mcu_IOPadSingle2Diff` rerun with the enable. All in a cloud container (same tools as §7); **not yet
  reproduced in IIC-OSIC-TOOLS**.
- Round trip: every ported or generated sheet netlisted by xschem and compared device by device with its reference
  netlist (`ClassABDriver/scripts/check_classab_port.py`), MISMATCHES 0.

Not delivered: Makefiles for the three new macros (the bridge refuses Makefiles); not ported: the self-contained
bias variants `_oa` (Oguey–Aebischer) and `_bg` (bandgap), which need a GF180 re-design; no layout.

Traps found:

- The cloud xschem / Tcl rejects the UTF-8 BOM at the start of the IOPad and top-level `xschemrc` files (every symbol
  "IS MISSING"). §7 said 3.4.8 accepts it; that was wrong for the cloud build. Netlisting there runs from a
  BOM-stripped copy; the files in the repo are unchanged.
- CACE: a condition named like a pin takes a value of its own (`iref` → 1 mA; renamed `i_ref`); state every
  condition a parameter does not sweep, or a pin's `Vmin` is used; brace-escape `CACE{...}` in symbol `value=`;
  a unit of `%` is shown as 100 × the echoed value; `off` in a variable list is YAML for false.
- ngspice: noise analysis refuses `option KLU`; with all current roots switched off (pad disabled), `gmin=1e-15`
  leaves KCL residues of ~17 µA on the supplies, `gmin=1e-12` gives the real leakage.
- GF180 03v3 bins: W ≤ 100 µm per instance counts the total W, not W/nf; large devices need `m`.
EOF
grep -c "ClassAB" README.md CLAUDE.md docs/IHP_TO_GF180_PORT_MAP.md schematic/xschem/xschemrc HANDOVER_gf180_migration.md; tail -3 /tmp/cace_d2s.out
```

</details>

*[Wait for pad CACE run (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 240; tail -2 /tmp/cace_d2s.out; ls /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace/_runs/*/summary.md 2>/dev/null
```

</details>

*[Read pad CACE results and collect them (in the cloud container; 31 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -14 | cut -d'|' -f2,5-11; cut -d, -f1-4,9 $R/parameters/off_params/simulation_summary.csv; /home/claude/work/gf/cloud/collect.sh $(pwd) gf180mcu_IOPadDiff2Single $R; cp /tmp/cace_d2s.out /mnt/user-data/outputs/log1/2026-10-08_opus_cace_IOPadDiff2Single.out
```

</details>

*[Test rshunt to stabilize the disabled operating point (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); for r in run_10 run_01 run_14; do f=$R/parameters/off_params/$r/*.spice; for o in "gmin=1e-12" "gmin=1e-12 rshunt=1e14" "gmin=1e-13 rshunt=1e13"; do sed "s/gmin=1e-12/$o/; s/^echo .*/print idd_off/" $f > /tmp/o.spice; echo "$r $o: $(cd /tmp && ngspice -b o.spice 2>&1 | grep '^idd_off')"; done; done
```

</details>

*[Look for non-MOS current paths in the bad solution (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); f=$R/parameters/off_params/run_10/*.spice; sed "s/^echo .*/print idd_off\nshow d : id\nshow e : i\nshow v : i\nshow i : i/" $f > /tmp/o.spice; cd /tmp && ngspice -b o.spice 2>&1 | grep -v "^ *$" | grep -A40 "^idd_off" | head -60
```

</details>

*[Try transient settling for the disabled supply current (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); for r in run_10 run_01 run_14; do f=$R/parameters/off_params/$r/*.spice; python3 - $f <<'EOF'
import sys,re
s=open(sys.argv[1]).read()
s=re.sub(r"\.control.*?\.endc", """.control
save all
tran 10n 5u
meas tran i1 find i(Vvdd) at=5u
meas tran i2 find i(Vvddo) at=5u
let idd_t = -i1 - i2
print idd_t
.endc""", s, flags=re.S)
open('/tmp/o.spice','w').write(s)
EOF
echo "$r: $(cd /tmp && timeout 300 ngspice -b o.spice 2>&1 | grep '^idd_t')"; done
```

</details>

*[Read disabled state after a transient; rerun pad suite (in the cloud container; 22 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
a=s.index('    # gmin = 1e-12 here'); b=s.index('    cace_template(os.path.join(tdir, f"{CELL}_tb_off.sch")')
s=s[:a]+'''    # With every current root switched off most nodes float, and the DC operating point is not reliable: at
    # gmin = 1e-15 (and in one of 15 runs at 1e-12) ngspice accepted solutions whose supply currents broke KCL by
    # ~17 uA (checked 2026-10-08). A 5 us transient from that point settles to the leakage; the values are read
    # at its end.
    m = lambda n, e: f"meas tran {n} find {e} at=5u\\n"
    off = (OPTS.replace("gmin=1e-15", "gmin=1e-12") + en_src + "Vd dp 0 0\\n" + STIM + ".control\\nsave all\\ntran 10n 5u\\n"
           + m("i1", "i(Vvdd)") + m("i2", "i(Vvddo)") + m("va", "v(vddo,x1.a)") + m("vb", "v(x1.b)")
           + m("vo", "v(out,vref)") + m("vn", "v(x1.iref_en)") + m("ir", "i(Vsup)")
           + "let idd_off = -i1 - i2\\nlet va_off = va\\nlet vb_off = vb\\nlet vout_off = vo\\nlet iref_n = vn\\nlet iref_off = -ir\\n"
           + OUT.format(vals="$&idd_off $&va_off $&vb_off $&vout_off $&iref_n $&iref_off") + ".endc\\n")
'''+s[b:]
s=s.replace("Idd = vdd + vddo; iref_off = current still delivered by the reference source.","Read at the end of a 5 us transient (the DC operating point of the switched-off circuit is not reliable).\\nIdd = vdd + vddo; iref_off = current still delivered by the reference source.")
open(p,'w').write(s)
EOF
python3 scripts/gen_cace.py . && cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && rm -rf _runs _docs netlist && (time timeout 2400 cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_d2s.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -14 | cut -d'|' -f2,5-11; cut -d, -f1-4,9 $R/parameters/off_params/simulation_summary.csv | sort -t, -k4 -g | tail -3
```

</details>

*[Debug missing disabled-state values (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); grep -iE "error|vn |ir |failed" $R/parameters/off_params/run_00/ngspice_std*.out | head; cat $R/parameters/off_params/run_00/*.data
```

</details>

*[Fix differential measures; rerun pad suite (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single && python3 - <<'EOF'
p='scripts/gen_cace.py'; s=open(p).read()
s=s.replace('+ m("va", "v(vddo,x1.a)") + m("vb", "v(x1.b)")\n           + m("vo", "v(out,vref)")',
            '+ m("vo1", "v(vddo)") + m("va1", "v(x1.a)") + m("vb", "v(x1.b)")\n           + m("vout1", "v(out)") + m("vref1", "v(vref)")')
s=s.replace('"let idd_off = -i1 - i2\\nlet va_off = va\\n','"let idd_off = -i1 - i2\\nlet va_off = vo1 - va1\\n')
s=s.replace('let vout_off = vo\\n','let vout_off = vout1 - vref1\\n')
open(p,'w').write(s)
EOF
grep -n "vo1\|vout1" scripts/gen_cace.py | head; python3 scripts/gen_cace.py . && cd verification/cace && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate && rm -rf _runs _docs netlist && (time timeout 2400 cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_d2s.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -14 | cut -d'|' -f2,5-11
```

</details>

*[Collect pad results; rerun Single2Diff CACE in a BOM-free mirror (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf/macros/gf180mcu_IOPadDiff2Single/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); /home/claude/work/gf/cloud/collect.sh $(pwd) gf180mcu_IOPadDiff2Single $R; cp /tmp/cace_d2s.out /mnt/user-data/outputs/log1/2026-10-08_opus_cace_IOPadDiff2Single.out; cd /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/verification/cace && ls; mkdir -p /tmp/s2dorig && cp -r /home/claude/work/gf/orig/gf180mcu_IOPadSingle2Diff/verification/cace/results /tmp/s2dorig/ 2>/dev/null; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:$PATH && source /home/claude/venv/bin/activate; rm -rf /tmp/gfm; cp -a /home/claude/work/gf/macros /tmp/gfm_s2d; find /tmp/gfm_s2d -name xschemrc -exec sed -i '1s/^\xEF\xBB\xBF//' {} +; cd /tmp/gfm_s2d/gf180mcu_IOPadSingle2Diff/verification/cace && ls ../../../ | head; (time timeout 1800 cace gf180mcu_IOPadSingle2Diff.yaml -s schematic --nofail -j 4 --parallel-parameters 1 > /tmp/cace_s2d.out 2>&1); R=$(ls -d _runs/RUN_* | tail -1); sed 's/  */ /g' $R/summary.md | tail -4 | cut -d'|' -f2,5-11
```

</details>

*[Compare Single2Diff input results before and after the enable (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/gfm_s2d/gf180mcu_IOPadSingle2Diff/verification/cace; R=$(ls -d _runs/RUN_* | tail -1); head -2 $R/parameters/*/simulation_summary.csv; python3 - $R/parameters/*/simulation_summary.csv /tmp/s2dorig/results/gf180mcu_IOPadSingle2Diff/input_params_summary.csv <<'EOF'
import csv,sys,collections
def load(p):
    r=list(csv.DictReader(open(p)))
    return r
new=load(sys.argv[1]); 
try: old=load(sys.argv[2])
except Exception as e: old=[]; print(e)
print(new[0].keys(), (old[0].keys() if old else ''))
def agg(rows):
    d=collections.defaultdict(list)
    for x in rows: d[float(x['vin'])].append((float(x['Iin']),float(x['Vprot'])))
    return {k:(min(a for a,b in v),max(a for a,b in v),max(b for a,b in v)) for k,v in sorted(d.items())}
n=agg(new); o=agg(old) if old else {}
for k in n: print(k, 'new Iin %.3g..%.3g Vprot %.3f'%n[k], ' old %.3g..%.3g %.3f'%o[k] if k in o else '')
EOF
```

</details>

*[Store rerun Single2Diff results (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
S=/tmp/gfm_s2d/gf180mcu_IOPadSingle2Diff/verification/cace; R=$(ls -d $S/_runs/RUN_* | tail -1); O=/home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff; mkdir -p $O; cp $R/summary.md $O/summary.md; cp $R/parameters/input_params/*.png $O/; cp $R/parameters/input_params/simulation_summary.csv $O/input_params_summary.csv; sed -i "1i <!-- CACE run $(basename $R) in Claude's cloud container (2026-10-08, after the enable was added): CACE 2.13, ngspice-42, xschem 3.4.8RC ce52727, gf180mcuD from gf180mcu_fd_pr e11a8c9. -->" $O/summary.md; ls $O; cp /tmp/cace_s2d.out /mnt/user-data/outputs/log1/2026-10-08_opus_cace_IOPadSingle2Diff.out
```

</details>

*[Write pad READMEs with CACE results (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

~~~~sh
cd /home/claude/work/gf/macros && cat > gf180mcu_IOPadDiff2Single/README.md <<'EOF'
# gf180mcu_IOPadDiff2Single

Class-AB differential → single-ended driver for the analog output pad, with its bias tree and enable.
IHP counterpart: `sg13cmos5l_IOPadDiff2Single` (ESD clamps `sg13cmos5l_ClampN15N15`/`ClampP15N15` only, no GF180
equivalent; dropped for now) and the driver of the IHP design notes (`d2s_mpdda`).

**Status (2026-10-08): proof of concept.** Block-level schematic, symbol and CACE suite; no layout.

## Schematic

`schematic/xschem/gf180mcu_IOPadDiff2Single.sch` (written by `scripts/gen_iopad_d2s.py`; edit the sheet from now on):

| instance | cell (macro) | connection |
|---|---|---|
| xref | `BiasRefEnable` (`PadEnable`) | iref → iref_en while enabled; iref_en pulled to vss while disabled |
| xbias | `ClassABBiasIn` (`ClassABBias`) | bias tree and the six diodes, fed by iref_en (5 µA into the pin) |
| xdrv | `ClassABDriver` (`ClassABDriver`) | vinp = inp, vinn = inn, vref, vout = vfb = out: out − vref = (inp − inn)/2 |
| xen | `DriverEnable` (`PadEnable`) | disabled: OP / ON gates to vddo / vsso, vabp / vabn to vdd / vss |
| xinv | `EnableInv` (`PadEnable`) | en_b |

Ports: `vdd vss vddo vsso inp inn vref out iref en`. vddo / vsso are the output-stage rails (OP, ON and their
replicas RP1, RN1); tie them to vdd / vss when the output stage shares the supply. Bias enters as a current (iref),
never as a voltage, so each pad has its own bias tree.

Not included yet: the CDM / ESD network at `out` (on IHP, OP and ON double as the pad's clamps, case (a)); a level
shifter if `en` comes from 1.2 V logic.

## CACE (`verification/cace/`, results in `verification/cace/results/gf180mcu_IOPadDiff2Single/`)

Reference current from a behavioural source on its own supply (5 µA, compliance lost near vdd, 100 MΩ output
resistance), load 1 kΩ to vref ∥ 100 pF. Limits are placeholders. 75 runs, about 8 min on two cores.

| parameter | conditions | result |
|---|---|---|
| gain, enabled | 5 corners × −40/27/125 °C × 3.0/3.3/3.6 V | 0.49934 … 0.50007 |
| offset, enabled | same | 0.013 … 0.78 mV |
| I_Q (OP), enabled, real bias tree | same | 203 … 223 µA |
| Idd (vdd + vddo), enabled | same | 289 … 310 µA (reference current not included) |
| Idd, disabled | 5 corners × 3 temperatures | 0.08 … 2.9 nA |
| OP / ON gate vs its rail, disabled | same | ≤ 1 µV |
| reference current still flowing, disabled | same | ≤ 0.08 nA |
| output glitch at enable (vd = 0) | same | 171 … 489 mV |
| enable time (out within 1 mV) | same | 1.27 … 1.52 µs |

```
cd verification/cace
cace gf180mcu_IOPadDiff2Single.yaml -s schematic --nofail -j 4 --parallel-parameters 1
```

`scripts/gen_cace.py` wrote the yaml and templates. The disabled state is read at the end of a 5 µs transient: with
every current root off most nodes float, and ngspice accepted DC operating points whose supply currents broke KCL
by ~17 µA (in one of 15 runs even at `gmin=1e-12`).

The enable glitch comes from releasing a and b at once while the bias tree is still coming up, as on IHP
(power_down study: 69–300 mV). Staggering the release (bias first, then the output gates) would be the fix.
EOF
python3 - <<'EOF'
p='/home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/README.md'
s=open(p,encoding='utf-8').read()
s=s.replace("**Status (2026-10-06): proof of concept, input side only.**","**Status (2026-10-06): proof of concept, input side only. 2026-10-08: enable added (see below).**")
s=s.rstrip("\n")+"""

## Enable (2026-10-08)

`scripts/add_input_enable.py` added, as a one-time edit of the sheet and symbol:

- `InputEnable` (macro `PadEnable`) behind the CDM network: transmission gate `in_prot` → `in_en` while `en` = 1;
  while `en` = 0 it opens and a second gate parks `in_en` on `vcm`. `in_en` is where the single-ended →
  differential buffer will connect (still not designed).
- `EnableInv` for `en_b`; new port **`en`**, last in the port list (`vdd outp vcm in outn vss en`).
- The testbench and the CACE template tie `en` to vdd.

The CACE input deck, rerun with the enable (results above replaced; the 2026-10-06 numbers are in the git history):

| Pad voltage | Current into `in` | `in_prot` (max over corners) |
| --- | --- | --- |
| −0.3 V | −42 nA … −0.08 nA | −0.3 V |
| 0 … 3.6 V | ≤ 5.3 nA | follows the pad |
| 4.0 V | 12 … 72 µA | 4.0 V |
| 5.0 V | 2.3 … 4.8 mA | 4.29 V |
| 5.5 V | 3.8 … 7.5 mA | 4.30 V |

The input transmission gate adds junctions on `in_prot`: its PMOS drain to the n-well on vdd is one more diode to
vdd (more current above vdd + 0.6 V, slightly lower `in_prot`), its NMOS drain one more to vss (−42 nA at −0.3 V,
hot). The conclusion is unchanged: the input is not 5 V tolerant with these diodes and a 3.3 V vdd.
"""
open(p,'w',encoding='utf-8').write(s+"\n")
EOF
echo ok
~~~~

</details>

*[Final netlisting and round-trip checks of all cells (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/The CACE input deck, rerun with the enable (results above replaced; the 2026-10-06 numbers are in the git history):/The CACE input deck, rerun with the enable. The files in `verification\/cace\/results\/` now hold this run; the table above is the 2026-10-06 run without the enable:/' /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/README.md; grep -n "now hold this run" /home/claude/work/gf/macros/gf180mcu_IOPadSingle2Diff/README.md; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; M=/home/claude/work/gf/macros; N=/home/claude/work/gf/cloud/nl.sh; C=$M/ClassABDriver/scripts/check_classab_port.py; S=$M/ClassABDriver/scripts/gf180_sizing.spice; P=$M/PadEnable/scripts/padenable_reference.spice
for c in ClassABBias/schematic/xschem/ClassABBiasIdeal ClassABBias/schematic/xschem/ClassABBiasIn ClassABBias/schematic/xschem/ClassABBiasOut ClassABDriver/schematic/xschem/ClassABUnitR ClassABDriver/schematic/xschem/ClassABDriver ClassABDriver/schematic/xschem/ClassABDriverBiased PadEnable/schematic/xschem/EnableInv PadEnable/schematic/xschem/DriverEnable PadEnable/schematic/xschem/BiasRefEnable PadEnable/schematic/xschem/InputEnable gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff; do $N $M/$c.sch; done 2>&1 | grep -v "^netlisted" ; echo "--- round trip"; for p in "ClassABBiasIdeal d2s_bias_lp $S" "ClassABBiasIn d2s_bias_in $S" "ClassABBiasOut d2s_bias_out $S" "ClassABUnitR unit_r2 $S" "EnableInv EnableInv $P" "DriverEnable DriverEnable $P" "BiasRefEnable BiasRefEnable $P" "InputEnable InputEnable $P"; do set -- $p; echo "$1: $(python3 $C $3 /tmp/nl/$1.spice $2 $1 | tail -1)"; done; echo "ClassABDriver: $(python3 $C $S /tmp/nl/ClassABDriver.spice d2s_mpdda ClassABDriver a b | tail -1)"
```

</details>

*[Check the top-level xschemrc chain finds all new cells (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/handover file §7\./handover file §7–8./' /home/claude/work/gf/CLAUDE.md; rm -rf /tmp/gftop && mkdir -p /tmp/gftop && cp -a /home/claude/work/gf/macros /home/claude/work/gf/schematic /tmp/gftop/ && cp -a /home/claude/work/repo/macros/OgueyAebischerBias /tmp/gftop/macros/ 2>/dev/null; find /tmp/gftop -name xschemrc -exec sed -i '1s/^\xEF\xBB\xBF//' {} +; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/gftop/out /tmp/gftop/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch > /tmp/gftop/log 2>&1; grep -c "MISSING" /tmp/gftop/out/*.spice; grep "^.subckt" /tmp/gftop/out/*.spice; tail -3 /tmp/gftop/log
```

</details>

*[See which cells are missing via top-level rc (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
grep "MISSING" /tmp/gftop/out/*.spice; grep -n "IOPadSingle2Diff/schematic\|source" /tmp/gftop/schematic/xschem/xschemrc | head; ls /tmp/gftop/macros
```

</details>

*[Print library path assembled by the top-level xschemrc (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x --command 'puts "LIB=$XSCHEM_LIBRARY_PATH"' 2>&1 | grep LIB= | tr ':' '\n'; ls /tmp/gftop/macros/ClassABDriver/schematic/xschem/
```

</details>

*[Inspect XSCHEM_LIBRARY_PATH from top-level rc (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && cat > /tmp/p.tcl <<'EOF'
puts stderr "LIB=$XSCHEM_LIBRARY_PATH"
EOF
PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -q -x --script /tmp/p.tcl 2>&1 | grep -o "LIB=.*" | tr ':' '\n' | sed 's|/home/claude/pdk/gf180mcuD/libs.tech/xschem.*|PDK...|' | sort | uniq -c
```

</details>

*[Print library path via script (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && printf 'puts "LIB=$XSCHEM_LIBRARY_PATH"\nexit\n' > /tmp/p.tcl; PWD=$(pwd) timeout 60 /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -x --script /tmp/p.tcl > /tmp/p.out 2>&1; grep -o "LIB=.*" /tmp/p.out | tr ':' '\n'; tail -5 /tmp/p.out
```

</details>

*[Debug library path by appending a print to the rc (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && cp xschemrc xschemrc.bak && echo 'puts stderr "LIB=$XSCHEM_LIBRARY_PATH"' >> xschemrc && PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /tmp/gftop/out /tmp/gftop/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch > /tmp/p.out 2>&1; grep -o "LIB=.*" /tmp/p.out | tr ':' '\n' | grep -v "^/home/claude/pdk"; mv xschemrc.bak xschemrc
```

</details>

*[Show xschem output (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
head -c 1500 /tmp/p.out; echo; wc -l /tmp/p.out
```

</details>

*[Trace sourcing progress in the top-level rc (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && cp xschemrc xschemrc.bak && python3 - <<'EOF'
s=open('xschemrc').read()
out=[]
for l in s.splitlines():
    out.append(l)
    if l.startswith('source [file dirname'):
        out.append('puts "AFTER %s :: [llength [split $XSCHEM_LIBRARY_PATH :]]"' % l.split('/')[-4])
out.insert(0,'puts "RC START"')
open('xschemrc','w').write("\n".join(out)+"\n")
EOF
PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /tmp/gftop/out /tmp/gftop/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch; mv xschemrc.bak xschemrc
```

</details>

*[Trace rc sourcing to a file (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; rm -f /tmp/trace; cd /tmp/gftop/schematic/xschem && cp xschemrc xschemrc.bak && python3 - <<'EOF'
s=open('xschemrc').read()
out=['set _f [open /tmp/trace a]; puts $_f "RC START"; close $_f']
for l in s.splitlines():
    out.append(l)
    if l.startswith('source [file dirname'):
        out.append('set _f [open /tmp/trace a]; puts $_f "AFTER %s :: $XSCHEM_LIBRARY_PATH"; close $_f' % l.split('/')[-4])
open('xschemrc','w').write("\n".join(out)+"\n")
EOF
PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /tmp/gftop/out /tmp/gftop/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch; mv xschemrc.bak xschemrc; sed 's|/home/claude/pdk/gf180mcuD/libs.tech/xschem[^:]*:||g; s|/tmp/gftop/||g' /tmp/trace
```

</details>

*[Check whether PDK xschemrc sets the PDK variable (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "PDK\b\|set PDK\|XSCHEM_LIBRARY_PATH" /home/claude/pdk/gf180mcuD/libs.tech/xschem/xschemrc | head -20
```

</details>

*[Find PDK guard blocks in xschemrc files (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf && grep -rn -A2 "info exists PDK\]" --include=xschemrc . | head -12
```

</details>

*[Ran a command (on the computer; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && grep -rl "info exists PDK\]" --include=xschemrc . | grep -v "/simulations/\|_runs" | sort; md5sum testbenches/xschem/xschemrc macros/OgueyAebischerBias/schematic/xschem/xschemrc
```

</details>

*[Copied 4 files from the computer to the cloud container (1 lines of output).]*

*[Make the PDK guard effective in all project xschemrc files (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; W=/home/claude/work/gf; mkdir -p $W/testbenches/xschem $W/macros/OgueyAebischerBias/{schematic/xschem,testbenches/xschem,verification/cace/templates} $W/macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates; cp $U/testbenches/xschem/xschemrc $W/testbenches/xschem/; for f in schematic/xschem testbenches/xschem verification/cace/templates; do cp $U/macros/OgueyAebischerBias/$f/xschemrc $W/macros/OgueyAebischerBias/$f/; done; chmod -R u+w $W; cd $W && python3 - <<'EOF'
import re, glob
files = [f for f in glob.glob('**/xschemrc', recursive=True) if 'simulations' not in f]
pat = re.compile(r"(if \{!\[info exists PDK\]\} \{\n(\s*)source \$env\(PDK_ROOT\)/\$env\(PDK\)/libs\.tech/xschem/xschemrc\n)(\})")
for f in sorted(files):
    s = open(f, encoding='utf-8').read()
    if 'set PDK $env(PDK)' in s: print('already', f); continue
    n = 0
    def rep(m):
        return m.group(1) + m.group(2) + "# the gf180mcuD PDK xschemrc does not set PDK; without this, every chained project\n" + m.group(2) + "# xschemrc re-sources it, which resets XSCHEM_LIBRARY_PATH (found 2026-10-08)\n" + m.group(2) + "set PDK $env(PDK)\n" + m.group(3)
    s2, n = pat.subn(rep, s)
    print(n, f)
    if n: open(f, 'w', encoding='utf-8').write(s2)
EOF
grep -n -B1 -A4 "info exists PDK\]" schematic/xschem/xschemrc
```

</details>

*[Recheck top-level xschemrc chain after the guard fix (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros; rm -rf /home/claude/work/gf/orig && mkdir -p /home/claude/work/gf/orig && cp -r $U/gf180mcu_IOPadDiff2Single $U/gf180mcu_IOPadSingle2Diff /home/claude/work/gf/orig/; rm -rf /tmp/gftop && mkdir -p /tmp/gftop && cp -a /home/claude/work/gf/macros /home/claude/work/gf/schematic /home/claude/work/gf/testbenches /tmp/gftop/ && cp -an /home/claude/work/repo/macros/OgueyAebischerBias/schematic/xschem/*.s* /tmp/gftop/macros/OgueyAebischerBias/schematic/xschem/; find /tmp/gftop -name xschemrc -exec sed -i '1s/^\xEF\xBB\xBF//' {} +; export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; cd /tmp/gftop/schematic/xschem && rm -rf /tmp/gftop/out; PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/gftop/out /tmp/gftop/macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch >/dev/null 2>&1; echo "missing: $(grep -c MISSING /tmp/gftop/out/*.spice)"; grep "^.subckt" /tmp/gftop/out/*.spice | awk '{print $2}' | tr '\n' ' '; echo; cd /tmp/gftop/testbenches/xschem && rm -rf /tmp/gftop/out2; PWD=$(pwd) /opt/xschem/bin/xschem --rcfile $(pwd)/xschemrc -n -s -q -x -o /tmp/gftop/out2 /tmp/gftop/macros/ClassABDriver/testbenches/xschem/ClassABDriver_tb_loop.sch >/dev/null 2>&1; echo "tb via top testbench rc, missing: $(grep -c MISSING /tmp/gftop/out2/*.spice)"; ls /tmp/gftop/out2
```

</details>

*[Note xschemrc fix in handover; list files to deliver (in the cloud container; 130 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf && python3 - <<'EOF'
p='HANDOVER_gf180_migration.md'; s=open(p,encoding='utf-8').read()
s=s.replace("- GF180 03v3 bins: W ≤ 100 µm per instance counts the total W, not W/nf; large devices need `m`.\n",
"- GF180 03v3 bins: W ≤ 100 µm per instance counts the total W, not W/nf; large devices need `m`.\n"
"- The gf180mcuD PDK `xschemrc` does not set the Tcl variable `PDK` (IHP's does), so the guard\n"
"  `if {![info exists PDK]}` in the project files never fired: every chained `xschemrc` re-sourced the PDK file,\n"
"  which resets `XSCHEM_LIBRARY_PATH`, and a top-level session saw only the last macro's folders. All project\n"
"  `xschemrc` files now `set PDK $env(PDK)` right after sourcing it; checked by netlisting a pad and a driver\n"
"  testbench through the top-level files (all cells found).\n")
open(p,'w',encoding='utf-8').write(s)
EOF
find . -name __pycache__ -prune -exec rm -rf {} +; find macros scripts schematic testbenches docs *.md -type f -not -path "*/_runs/*" -not -path "*/_docs/*" -not -path "*/netlist/*" -not -path "*/simulations/*" | sort > /tmp/deliver_list.txt; wc -l /tmp/deliver_list.txt; cat /tmp/deliver_list.txt
```

</details>

*[Classify deliverables as new or changed (in the cloud container; 43 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; rm -rf /mnt/user-data/outputs/deliver; : > /tmp/new.txt; : > /tmp/changed.txt; while read f; do if [ -f $U/$f ]; then cmp -s $f $U/$f || echo $f >> /tmp/changed.txt; else echo $f >> /tmp/new.txt; fi; done < /tmp/deliver_list.txt; echo "new $(wc -l < /tmp/new.txt), changed $(wc -l < /tmp/changed.txt)"; cat /tmp/changed.txt; grep -v "^macros/Class\|^macros/PadEnable" /tmp/new.txt
```

</details>

*[Called mcp__remote-devices__device_list_dir (1 lines of output).  
Copied 4 files from the computer to the cloud container (1 lines of output).]*

*[List files that will be overwritten on the computer (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
{ cat /tmp/changed.txt; ls macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/* ; } | sort -u > /tmp/overwrite.txt; wc -l < /tmp/overwrite.txt; tr '\n' ' ' < /tmp/overwrite.txt > /tmp/overwrite_line.txt; cat /tmp/overwrite_line.txt | head -c 300
```

</details>

*[Ran a command (on the computer; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && B=$HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-08_before_classab_port && mkdir -p $B && for f in CLAUDE.md HANDOVER_gf180_migration.md README.md docs/IHP_TO_GF180_PORT_MAP.md macros/OgueyAebischerBias/schematic/xschem/xschemrc macros/OgueyAebischerBias/testbenches/xschem/xschemrc macros/OgueyAebischerBias/verification/cace/templates/xschemrc macros/gf180mcu_IOPadDiff2Single/README.md macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sym macros/gf180mcu_IOPadDiff2Single/schematic/xschem/xschemrc macros/gf180mcu_IOPadDiff2Single/testbenches/xschem/xschemrc macros/gf180mcu_IOPadSingle2Diff/README.md macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sym macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/xschemrc macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Iin_vs_vin.png macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Vprot_vs_vin.png macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/input_params_summary.csv macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/summary.md schematic/xschem/xschemrc testbenches/xschem/xschemrc; do mkdir -p $B/$(dirname $f); cp -p $f $B/$f; done; find $B -type f | wc -l; md5sum CLAUDE.md $B/CLAUDE.md | awk '{print $1}' | uniq | wc -l
```

</details>

*[Stage deliverables and build commit batches (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
D=/mnt/user-data/outputs/deliver; rm -rf $D; while read f; do mkdir -p $D/$(dirname $f); cp $f $D/$f; done < <(cat /tmp/new.txt /tmp/changed.txt; ls macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/*); find $D -type f | wc -l; python3 - <<'EOF'
import json, os
mt = {}
# mtimes of existing files on the computer (from staging / listing)
for l in """macros/gf180mcu_IOPadDiff2Single/README.md 1791318883099
macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sch 1791318883508
macros/gf180mcu_IOPadDiff2Single/schematic/xschem/gf180mcu_IOPadDiff2Single.sym 1791318883870
macros/gf180mcu_IOPadDiff2Single/schematic/xschem/xschemrc 1791311743633
macros/gf180mcu_IOPadDiff2Single/testbenches/xschem/xschemrc 1791311743636
macros/gf180mcu_IOPadSingle2Diff/README.md 1791318884261
macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sch 1791318884661
macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/gf180mcu_IOPadSingle2Diff.sym 1791318885088
macros/gf180mcu_IOPadSingle2Diff/schematic/xschem/xschemrc 1791311743627
macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/gf180mcu_IOPadSingle2Diff_tb_dc.sch 1791318885481
macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/xschemrc 1791318885900
macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/gf180mcu_IOPadSingle2Diff_tb_input.sch 1791318888851
macros/gf180mcu_IOPadSingle2Diff/verification/cace/templates/xschemrc 1791318889645
macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Iin_vs_vin.png 1791318886949
macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/input_params_summary.csv 1791318888026
macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/summary.md 1791318888437
macros/gf180mcu_IOPadSingle2Diff/verification/cace/results/gf180mcu_IOPadSingle2Diff/Vprot_vs_vin.png 1791318887576
schematic/xschem/xschemrc 1791318899039
README.md 1791318946188
CLAUDE.md 1791318946186
HANDOVER_gf180_migration.md 1791318975399
docs/IHP_TO_GF180_PORT_MAP.md 1791318932788
testbenches/xschem/xschemrc 1791311760103
macros/OgueyAebischerBias/schematic/xschem/xschemrc 1791318813654
macros/OgueyAebischerBias/testbenches/xschem/xschemrc 1791318816849
macros/OgueyAebischerBias/verification/cace/templates/xschemrc 1791318882748""".splitlines():
    p, m = l.split(); mt[p] = int(m)
D = '/mnt/user-data/outputs/deliver'
files = sorted(os.path.relpath(os.path.join(r, f), D) for r, _, fs in os.walk(D) for f in fs)
items = []
for f in files:
    it = {"stagedPath": f"{D}/{f}", "devicePath": f"~/mnt/gf180_cm_ip__single2diff2single/{f}"}
    if f in mt: it["expectedMtimeMs"] = mt[f]
    items.append(it)
assert all(f in files for f in mt), [f for f in mt if f not in files]
for i in range(0, len(items), 45):
    json.dump(items[i:i+45], open(f'/tmp/batch{i//45}.json', 'w'))
print(len(items), [len(items[i:i+45]) for i in range(0, len(items), 45)], sum(1 for x in items if 'expectedMtimeMs' in x))
EOF
```

</details>

*[Print first commit batch (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cat /tmp/batch0.json
```

</details>

*[Copied 45 files from the cloud container to the computer (1 lines of output).]*

*[Print second batch compactly (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
import json; b=json.load(open('/tmp/batch1.json')); print(json.dumps(b))" | sed 's|/mnt/user-data/outputs/deliver/|@S@|g; s|~/mnt/gf180_cm_ip__single2diff2single/|@D@|g' | head -c 100000
```

</details>

*[Copied 45 files from the cloud container to the computer (1 lines of output).]*

*[Print third batch (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
import json; b=json.load(open('/tmp/batch2.json')); print(json.dumps(b))"
```

</details>

*[Copied 33 files from the cloud container to the computer (1 lines of output).]*

*[Compute checksums of delivered files (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/deliver && find . -type f | sort | xargs md5sum > /tmp/deliver.md5; wc -l < /tmp/deliver.md5; cp /tmp/deliver.md5 /mnt/user-data/outputs/deliver.md5
```

</details>

*[Size of compressed checksum list (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
awk '{print $1"  "$2}' /tmp/deliver.md5 | gzip -9 | base64 -w0 | wc -c
```

</details>

*[Ran a command (on the computer; 125 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && md5sum CLAUDE.md HANDOVER_gf180_migration.md README.md docs/IHP_TO_GF180_PORT_MAP.md schematic/xschem/xschemrc testbenches/xschem/xschemrc scripts/xsheet.py $(find macros/ClassABBias macros/ClassABDriver macros/PadEnable -type f -not -path "*/simulations/*" | sort) macros/OgueyAebischerBias/schematic/xschem/xschemrc macros/OgueyAebischerBias/testbenches/xschem/xschemrc macros/OgueyAebischerBias/verification/cace/templates/xschemrc $(find macros/gf180mcu_IOPadDiff2Single macros/gf180mcu_IOPadSingle2Diff -type f \( -name "*.sch" -o -name "*.sym" -o -name xschemrc -o -name "*.md" -o -name "*.yaml" -o -name "*.csv" -o -name "*.png" -o -name "gen_*.py" -o -name "add_*.py" \) -not -path "*/simulations/*" | sort) | sed 's|  |  ./|'
```

</details>

*[Copied 1 files from the cloud container to the computer (1 lines of output).]*

*[Ran a command (on the computer; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && md5sum -c $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_delivery.md5 2>&1 | grep -v ": OK$"; echo "checked: $(wc -l < $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_delivery.md5)"; python3 -c "
import sys
try:
    from PIL import Image; print('PIL ok')
except Exception as e: print('no PIL', e)"
```

</details>

*[Pixel hashes of delivered PNGs (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/deliver && python3 -c "
import glob,hashlib
from PIL import Image
for f in sorted(glob.glob('**/*.png', recursive=True)):
    im=Image.open(f).convert('RGBA'); print(hashlib.md5(im.tobytes()).hexdigest()[:12], im.size, f.split('/')[-1])
" | md5sum;
```

</details>

*[Ran a command (on the computer; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && python3 -c "
import glob,hashlib
from PIL import Image
fs=sorted(f for f in glob.glob('macros/**/*.png', recursive=True) if any(k in f for k in ['ClassABBias/verification','ClassABDriver/verification','IOPadDiff2Single/verification','IOPadSingle2Diff/verification']))
for f in fs:
    im=Image.open(f).convert('RGBA'); print(hashlib.md5(im.tobytes()).hexdigest()[:12], im.size, f.split('/')[-1])
" | tee /dev/stderr | md5sum
```

</details>

*[Called mcp__claude_ai__current_time (1 lines of output).]*

*[List tool-call times to correct the log timestamps (in the cloud container; 174 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
import json, datetime
from zoneinfo import ZoneInfo
recs=[json.loads(l) for l in open('/root/.claude/projects/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb.jsonl')]
for r in recs:
    if r.get('type')!='assistant': continue
    for b in r['message'].get('content',[]):
        if isinstance(b,dict) and b.get('type')=='tool_use' and b['name'] in ('Bash',):
            d=b['input'].get('description','')
            t=datetime.datetime.fromisoformat(r['timestamp'].replace('Z','+00:00')).astimezone(ZoneInfo('Europe/Berlin')).strftime('%H:%M')
            print(t, d[:80])
EOF
```

</details>

*[Correct log times and add final entries (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
L=/mnt/user-data/outputs/log1/2026-10-08_opus_classab_port_log.md; python3 - $L <<'EOF'
import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
for a,b in [("## 19:55 — plan","## 19:50 — plan"),
            ("## 20:05 — GF180 sizing, driver on the ideal fixture","## 19:53 — GF180 sizing, driver on the ideal fixture"),
            ("## 20:20 — bias variants in / out","## 19:54 — bias variants in / out"),
            ("## 20:35 — xschem port of the hand-drawn IHP sheets","## 19:57 — xschem port of the hand-drawn IHP sheets"),
            ("## 20:40 — chat log across the compaction","## 20:00 — chat log across the compaction"),
            ("## 20:55 — PadEnable cells","## 20:03 — PadEnable cells"),
            ("## 21:00 — pads","## 20:05 — pads"),
            ("## 21:05 — CACE: ClassABBiasIn","## 20:14 — CACE: ClassABBiasIn"),
            ("## 21:20 — CACE: ClassABDriverBiased","## 20:26 — CACE: ClassABDriverBiased")]:
    assert a in s, a; s=s.replace(a,b)
s=s.replace("Written to preempt context compaction;","Written to preempt context compaction. Times corrected at 21:17 from the transcript (the first\nversions of the entries 19:53–20:26 carried later, wrong times);")
s+='''
## 20:52 — CACE: gf180mcu_IOPadDiff2Single (`macros/gf180mcu_IOPadDiff2Single/verification/cace`)

DUT = the pad (bias tree + driver + enables). Reference current from a behavioural source on its own supply vsup
(5 µA, tanh compliance near vsup, 100 MΩ), so that Idd excludes it. Three parameters, 75 runs, 8 min:

- enabled, PVT (45): gain 0.49934–0.50007, offset 0.013–0.78 mV, I_Q 203–223 µA, Idd 289–310 µA.
- disabled (15): Idd 0.08–2.9 nA; OP / ON gates within 1 µV of their rails; reference current ≤ 0.08 nA.
- enable transient (15): output glitch 171–489 mV, out within 1 mV after 1.27–1.52 µs, I_Q back to 207–219 µA.

The disabled state first gave Idd of ±17 µA in some runs. The device currents were all fA–pA and the source currents
did not satisfy KCL: with every current root off most nodes float, and ngspice accepted DC operating points with large
residues (at gmin = 1e-15; at 1e-12 still in 1 of 15 runs; rshunt did not help). A 5 µs transient from that point
settles to the leakage (fs/27 °C: 17 µA → 0.24 nA). The template reads the disabled state at the end of the transient.

## 21:09 — CACE: gf180mcu_IOPadSingle2Diff rerun with the enable

en tied to vdd in the testbench and the template. The transmission gate adds junctions on in_prot: −0.3 V up to −42 nA
(hot), 0…3.6 V ≤ 5.3 nA, 5.0 V 2.3–4.8 mA at in_prot 4.29 V, 5.5 V 3.8–7.5 mA (before: 2.0–3.9 mA / 4.34 V and
3.4–6.4 mA / 4.38 V). Not 5 V tolerant, as before. Results in the repo replaced; the old ones are in the backup below.

## 21:12 — xschemrc chain of the whole project

Netlisting the output pad through the top-level `schematic/xschem/xschemrc` lost ClassABBiasIn and ClassABDriver.
Cause: the gf180mcuD PDK xschemrc does not set the Tcl variable `PDK` (IHP's does), so the guard
`if {![info exists PDK]}` never fired and every chained project xschemrc re-sourced the PDK file, which resets
`XSCHEM_LIBRARY_PATH`. Every project xschemrc now does `set PDK $env(PDK)` after sourcing it (24 files incl. the
OgueyAebischerBias and IOPad ones). After the fix the pad and a driver testbench netlist through the top-level files
with every cell found.

## 21:17 — delivery

- Backup of the 26 files that were overwritten (as found on the computer before the delivery):
  `sudelbuecher/backups/2026-10-08_before_classab_port/` (copied on the computer, checksums identical).
- 123 files written to the main repo with device_commit_files, mtime guards on the 26 existing ones; none rejected.
- `logs/main/2026-10-08_opus_classab_delivery.md5`: `md5sum -c` on the computer: 106 OK, the 17 PNGs differ
  (provenance stamp in transit); their decoded pixels are identical (hash of all 17 decoded images matches).
- Not delivered: Makefiles for the three new macros (the bridge refuses Makefiles). The bias variants `_oa` and `_bg`
  are not ported (need a GF180 re-design).
- No git commands were run.
'''
open(p,'w',encoding='utf-8').write(s)
EOF
grep -n "^## " $L; cp /tmp/cace_s2d.out /mnt/user-data/outputs/log1/2026-10-08_opus_cace_IOPadSingle2Diff.out 2>/dev/null; ls /mnt/user-data/outputs/log1
```

</details>

*[Fix count; rebuild chat log (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
L=/mnt/user-data/outputs/log1/2026-10-08_opus_classab_port_log.md; sed -i 's/(24 files incl. the/(19 files incl. the/' $L; grep -n "19 files" $L; /tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/rebuild.sh && grep -c "^## Turn" /mnt/user-data/outputs/chat1/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md
```

</details>

*[Ran a command (on the computer; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && stat -c '%n %Y %s' logs/main/2026-10-08_opus_classab_port_log.md chatlog/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md; python3 -c "
import os
for f in ['logs/main/2026-10-08_opus_classab_port_log.md','chatlog/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md']: print(f, int(os.stat(f).st_mtime*1000))"
```

</details>

*[Copied 4 files from the cloud container to the computer (1 lines of output).  
Called TaskList (11 lines of output).  
Set task 7 to completed.  
Set task 8 to completed.  
Set task 9 to completed.  
Set task 10 to completed.  
Set task 11 to completed.]*

The macro hierarchy is in the GF180 repo. Every schematic was netlisted by xschem and matched its reference netlist device by device, and every macro has a CACE suite that ran. This was all in my cloud container; none of it has been rerun in your IIC-OSIC-TOOLS container yet.

**New macros**
- **`ClassABDriver`**: the driver core, ported from your hand-drawn `d2s_mpdda` sheet (wires and placement kept). It has new ports `a b` (the gates of the output transistors) for the enable. Also here: the six IHP testbenches, and a CACE fixture that runs the driver on ideal bias currents.
- **`ClassABBias`**: the two bias variants that take a reference current (into or out of `iref`), plus the ideal-current fixture. Each variant has its own CACE suite.
- **`PadEnable`**: the IHP power-down switches, now as cells of their own: an enable inverter, the driver switches, the reference-current switch and an input switch.

**Pads**
- **`gf180mcu_IOPadDiff2Single`**: now bias tree + driver + enable cells. Ports are `vdd vss vddo vsso inp inn vref out iref en`. Bias enters as a current, so the answer to my earlier question became one bias tree per pad.
- **`gf180mcu_IOPadSingle2Diff`**: got the input switch behind the CDM network and a new last port `en`. Its CACE input sweep was rerun.

**Re-sizing for GF180**
- GF180 03v3 devices behave much like IHP's sg13_hv here; the unchanged sizes gave 192 µA quiescent current instead of 212 µA. Narrower replicas in the bias restored 212 µA.
- The input-stage tails had to be four times wider: at ss / 3.0 V / −40 °C they ran out of headroom.
- The output transistors are split with `m`, because GF180 allows at most 100 µm total width per transistor.
- The degeneration resistor is now `ppolyf_u_3k`.

**Results**

| | Result |
|---|---|
| Loop, typical | 93 dB, 1.40 MHz, 72.7° phase margin (IHP: 79 dB, 1.37 MHz, 72.4°) |
| Driver over 45 PVT points | gain 0.4994–0.5001, offset ≤ 0.78 mV, quiescent current 205–223 µA |
| Bias currents over PVT and mismatch | within −1.7…+3.8 % |
| Pad disabled | 0.08–2.9 nA supply current, output gates at their rails |
| Pad at enable | 171–489 mV output glitch, settled within 1.5 µs |

**Expected failures (same as IHP)**
- Nonlinearity of 3.5 mV at ss / 3.0 V / −40 °C.
- Phase margin 25° with a 1 nF load.

**Problems found on the way**
- **Library-path bug (project-wide):** the PDK guard in our `xschemrc` files never worked with gf180mcuD. Every chained file reset the library path, so a top-level session lost macro cells. I fixed it in all 19 project `xschemrc` files (one line each), including the OgueyAebischerBias and pad ones.
- **Disabled-pad simulation:** ngspice's operating point for the disabled pad was unreliable (supply currents off by ~17 µA). The test now reads its values at the end of a short transient.

**Not done**
- The Oguey–Aebischer and bandgap bias variants. Both need a real GF180 re-design, not a port.
- Makefiles for the three new macros; the bridge refuses to write Makefiles.
- No layout.

**Where things are**
- The 26 files I overwrote are backed up in `sudelbuecher/backups/2026-10-08_before_classab_port/`.
- The running log, with every number and decision, is `sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md`; the CACE outputs are next to it.
- The chat log is updated through 21:17. The automatic context compaction at 19:23 cut the transcript, so your 19:22 message is reconstructed from the compaction summary, and the log says so.
- All 123 delivered files were checked by checksum on your computer. The 17 PNG plots differ in bytes from my copies but have identical pixels.
- No git commands were run.

A good first step on your side: run `cace` in the four new `verification/cace` folders in the IIC-OSIC-TOOLS container, to confirm the numbers there.

## Turn 13 — 2026-10-08 21:42

**User:**

Several Makefiles need to be modified and created from scratch. If you're not allowed to write them, drop me a zip file into the _sudelbuecher with instructions where to put them.

**Assistant:**

*[Copied 4 files from the computer to the cloud container (1 lines of output).]*

*[Compare macro Makefiles and list targets (in the cloud container; 79 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; diff $U/macros/gf180mcu_IOPadDiff2Single/Makefile $U/macros/OgueyAebischerBias/Makefile; diff $U/macros/gf180mcu_IOPadDiff2Single/Makefile $U/macros/gf180mcu_IOPadSingle2Diff/Makefile && echo PADS-IDENTICAL-EXCEPT-TOP?; grep -n "^[a-zA-Z_-]*:" $U/macros/gf180mcu_IOPadDiff2Single/Makefile | head -60
```

</details>

*[Read macro Makefile sim/clean recipes and top-level macro targets (in the cloud container; 121 lines of output).]*

<details><summary>command</summary>

```sh
U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; sed -n 60,130p $U/macros/gf180mcu_IOPadDiff2Single/Makefile; sed -n 380,410p $U/macros/gf180mcu_IOPadDiff2Single/Makefile; grep -n "macro\|MACRO" $U/Makefile | head -40
```

</details>

*[Read .gitignore and top-level macro targets (in the cloud container; 78 lines of output).]*

<details><summary>command</summary>

```sh
cat /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/.gitignore; sed -n 120,150p /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/Makefile; sed -n 425,450p /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/Makefile
```

</details>

*[Generate new and modified Makefiles and show diffs (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/mk && cd /home/claude/work/mk && U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single && python3 - <<'PYEOF'
import os, re
U='/mnt/user-data/uploads/gf180_cm_ip__single2diff2single'
pad=open(f'{U}/macros/gf180mcu_IOPadDiff2Single/Makefile').read()
oab=open(f'{U}/macros/OgueyAebischerBias/Makefile').read()
top=open(f'{U}/Makefile').read()
HDR_OLD='# SPDX-FileCopyrightText: 2026 Tim Edwards and Simon Dorrer\n'
HDR_NEW='# SPDX-FileCopyrightText: 2026 Tim Edwards, Simon Dorrer and Christoph Maier\n'
SIMALL_OLD='''sim-all: ## Simulate the macro
	$(MAKE) sim-xschem TB=$(TOP)_tb_tran
.PHONY: sim-all
'''
CLEAN_OLD='''	rm -rf $(SCRIPTS_DIR)/__pycache__
.PHONY: clean
'''
CLEAN_NEW='''	rm -rf $(SCRIPTS_DIR)/__pycache__
	rm -rf $(CACE_DIR)/_runs $(CACE_DIR)/_docs $(CACE_DIR)/netlist
	rm -rf $(CACE_DIR)/templates/simulations
.PHONY: clean
'''
def cace_block(cells, default):
    return f'''
# CACE (verification/cace/<datasheet>.yaml; results worth keeping go to verification/cace/results/)
CACE_DIR := verification/cace
# Datasheet(s) of this macro; sim-cace runs CACE_TOP, sim-cace-all runs all of them
CACE_CELLS := {cells}
CACE_TOP ?= {default}
# Parameter groups to run (default: all). Override with: make sim-cace CACE_PARAMS="dc_params loop_params"
CACE_PARAMS ?=
CACE_JOBS ?= 4
# --nofail: exit 0 and write the documentation (_docs) even when parameters fail; CACE_OPTS= to stop on failures
CACE_OPTS ?= --nofail

sim-cace: ## Run the CACE suite of CACE_TOP (usage: make sim-cace [CACE_TOP=<datasheet>] [CACE_PARAMS="<groups>"])
	cd $(CACE_DIR) && cace $(CACE_TOP).yaml -s schematic $(if $(CACE_PARAMS),-p $(CACE_PARAMS),) -j $(CACE_JOBS) --parallel-parameters 1 $(CACE_OPTS)
.PHONY: sim-cace

sim-cace-all: ## Run the CACE suites of all datasheets of this macro (CACE_CELLS)
	for c in $(CACE_CELLS); do $(MAKE) sim-cace CACE_TOP=$$c || exit 1; done
.PHONY: sim-cace-all
'''
def mk(top, simall, cace, extra_top=''):
    s = pad.replace(HDR_OLD, HDR_NEW).replace('TOP = gf180mcu_IOPadDiff2Single\n', f'{extra_top}TOP = {top}\n')
    assert SIMALL_OLD in s and CLEAN_OLD in s
    s = s.replace(SIMALL_OLD, simall + cace)
    s = s.replace(CLEAN_OLD, CLEAN_NEW if cace else CLEAN_OLD)
    s = s.replace('clean: ## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation outputs)',
                  'clean: ## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation and CACE outputs)' if cace else
                  'clean: ## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation outputs)')
    return s

out = {}
out['macros/ClassABBias/Makefile'] = mk('ClassABBiasIn',
 '''sim-all: ## Simulate the macro (the CACE suites of both bias variants; there are no separate testbenches)
	$(MAKE) sim-cace-all
.PHONY: sim-all
''', cace_block('ClassABBiasIn ClassABBiasOut', '$(TOP)'),
 '# Cells: ClassABBiasIn (reference current into iref), ClassABBiasOut (out of iref), ClassABBiasIdeal (test fixture).\n# Override with: make <target> TOP=<cell>\n').replace('TOP = ClassABBiasIn\n', 'TOP ?= ClassABBiasIn\n')
out['macros/ClassABDriver/Makefile'] = mk('ClassABDriver',
 '''# Ported IHP testbenches (testbenches/xschem/ClassABDriver_tb_<name>.sch)
DRIVER_TBS := dc loop step thd noise op

sim-all: ## Simulate the macro (all six testbenches, then the CACE suite)
	for t in $(DRIVER_TBS); do $(MAKE) sim-xschem TB=$(TOP)_tb_$$t || exit 1; done
	$(MAKE) sim-cace
.PHONY: sim-all
''', cace_block('ClassABDriverBiased', 'ClassABDriverBiased'),
 '# CACE DUT: ClassABDriverBiased (ClassABDriver on the ideal bias fixture ClassABBiasIdeal from ../ClassABBias)\n')
out['macros/PadEnable/Makefile'] = mk('DriverEnable',
 '''sim-all: ## Simulate the macro (no stand-alone testbenches: the cells are tested inside the pads)
	@echo 'PadEnable has no testbenches of its own; run: make -C ../gf180mcu_IOPadDiff2Single sim-cace'
.PHONY: sim-all
''', '',
 '# Cells: EnableInv, DriverEnable, BiasRefEnable, InputEnable. Override with: make <target> TOP=<cell>\n').replace('TOP = DriverEnable\n','TOP ?= DriverEnable\n')
out['macros/gf180mcu_IOPadDiff2Single/Makefile'] = mk('gf180mcu_IOPadDiff2Single',
 '''sim-all: ## Simulate the macro (CACE suite: enabled DC, disabled state, enable transient)
	$(MAKE) sim-cace
.PHONY: sim-all
''', cace_block('gf180mcu_IOPadDiff2Single', '$(TOP)'))
s2d = mk('gf180mcu_IOPadDiff2Single',
 '''sim-all: ## Simulate the macro (pad-in-the-loop DC testbench, then the CACE input-range suite)
	$(MAKE) sim-xschem TB=$(TOP)_tb_dc
	$(MAKE) sim-cace
.PHONY: sim-all
''', cace_block('gf180mcu_IOPadSingle2Diff', '$(TOP)')).replace('TOP = gf180mcu_IOPadDiff2Single\n', 'TOP = gf180mcu_IOPadSingle2Diff\n')
out['macros/gf180mcu_IOPadSingle2Diff/Makefile'] = s2d
# OgueyAebischerBias: only the --nofail option
o = oab.replace('CACE_JOBS ?= 4\n', 'CACE_JOBS ?= 4\n# --nofail: exit 0 and write the documentation (_docs) even when parameters fail; CACE_OPTS= to stop on failures\nCACE_OPTS ?= --nofail\n')
o = o.replace('-j $(CACE_JOBS) --parallel-parameters 1\n', '-j $(CACE_JOBS) --parallel-parameters 1 $(CACE_OPTS)\n')
assert o != oab and o.count('$(CACE_OPTS)') == 1
out['macros/OgueyAebischerBias/Makefile'] = o
# top level: new macros in clean-macros, and a CACE target over all macros
t = top
t = t.replace('''#	ToDo: further macros
.PHONY: build-macros
''', '''#	ToDo: further macros (ClassABBias, ClassABDriver, PadEnable, OgueyAebischerBias have no layout yet; see sim-cace-macros)
.PHONY: build-macros

sim-cace-macros: ## Run the CACE suites of all macros that have one
	$(MAKE) -C $(MACROS_DIR)/OgueyAebischerBias sim-cace-all
	$(MAKE) -C $(MACROS_DIR)/ClassABBias sim-cace-all
	$(MAKE) -C $(MACROS_DIR)/ClassABDriver sim-cace-all
	$(MAKE) -C $(MACROS_DIR)/gf180mcu_IOPadDiff2Single sim-cace
	$(MAKE) -C $(MACROS_DIR)/gf180mcu_IOPadSingle2Diff sim-cace
.PHONY: sim-cace-macros
''')
t = t.replace('''clean-macros: ## Delete all generated files and folders of all macros
	$(MAKE) clean-single2diff
	$(MAKE) clean-diff2single
#	ToDo: further macros
''', '''clean-macros: ## Delete all generated files and folders of all macros
	$(MAKE) clean-single2diff
	$(MAKE) clean-diff2single
	@$(MAKE) -C $(MACROS_DIR)/OgueyAebischerBias clean
	@$(MAKE) -C $(MACROS_DIR)/ClassABBias clean
	@$(MAKE) -C $(MACROS_DIR)/ClassABDriver clean
	@$(MAKE) -C $(MACROS_DIR)/PadEnable clean
''')
assert t.count('sim-cace-macros') == 2 and 'ClassABBias clean' in t
out['Makefile'] = t
for p, s in out.items():
    os.makedirs(os.path.join('tree', os.path.dirname(p)) or 'tree', exist_ok=True)
    open(os.path.join('tree', p), 'w').write(s)
    print(p, len(s))
PYEOF
for f in $(cd tree && find . -name Makefile); do echo "== $f"; orig=$U/${f#./}; [ -f $orig ] && diff $orig tree/$f | head -60 || echo NEW; done 2>&1 | head -150
```

</details>

*[Inspect exact whitespace of top-level ToDo lines (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "ToDo\|clean-macros" -A3 /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/Makefile | cat -A | head -30
```

</details>

*[No-op (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
fc -ln 0 >/dev/null 2>&1; history | tail -1 >/dev/null; echo skip
```

</details>

*[Generate Makefiles and diff against originals (in the cloud container; 119 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/mk && cd /home/claude/work/mk && cat > gen_makefiles.py <<'PYEOF'
import os
U='/mnt/user-data/uploads/gf180_cm_ip__single2diff2single'
pad=open(f'{U}/macros/gf180mcu_IOPadDiff2Single/Makefile').read()
oab=open(f'{U}/macros/OgueyAebischerBias/Makefile').read()
top=open(f'{U}/Makefile').read()
T='\t'
HDR_OLD='# SPDX-FileCopyrightText: 2026 Tim Edwards and Simon Dorrer\n'
HDR_NEW='# SPDX-FileCopyrightText: 2026 Tim Edwards, Simon Dorrer and Christoph Maier\n'
SIMALL_OLD=f'sim-all: ## Simulate the macro\n{T}$(MAKE) sim-xschem TB=$(TOP)_tb_tran\n.PHONY: sim-all\n'
CLEAN_OLD=f'{T}rm -rf $(SCRIPTS_DIR)/__pycache__\n.PHONY: clean\n'
CLEAN_NEW=(f'{T}rm -rf $(SCRIPTS_DIR)/__pycache__\n{T}rm -rf $(CACE_DIR)/_runs $(CACE_DIR)/_docs $(CACE_DIR)/netlist\n'
           f'{T}rm -rf $(CACE_DIR)/templates/simulations\n.PHONY: clean\n')
def cace_block(cells, default):
    return f'''
# CACE (verification/cace/<datasheet>.yaml; results worth keeping go to verification/cace/results/)
CACE_DIR := verification/cace
# Datasheet(s) of this macro; sim-cace runs CACE_TOP, sim-cace-all runs all of them
CACE_CELLS := {cells}
CACE_TOP ?= {default}
# Parameter groups to run (default: all). Override with: make sim-cace CACE_PARAMS="dc_params loop_params"
CACE_PARAMS ?=
CACE_JOBS ?= 4
# --nofail: exit 0 and write the documentation (_docs) even when parameters fail; CACE_OPTS= to stop on failures
CACE_OPTS ?= --nofail

sim-cace: ## Run the CACE suite of CACE_TOP (usage: make sim-cace [CACE_TOP=<datasheet>] [CACE_PARAMS="<groups>"])
{T}cd $(CACE_DIR) && cace $(CACE_TOP).yaml -s schematic $(if $(CACE_PARAMS),-p $(CACE_PARAMS),) -j $(CACE_JOBS) --parallel-parameters 1 $(CACE_OPTS)
.PHONY: sim-cace

sim-cace-all: ## Run the CACE suites of all datasheets of this macro (CACE_CELLS)
{T}for c in $(CACE_CELLS); do $(MAKE) sim-cace CACE_TOP=$$c || exit 1; done
.PHONY: sim-cace-all
'''
def mk(top, simall, cace, extra_top=''):
    s = pad.replace(HDR_OLD, HDR_NEW).replace('TOP = gf180mcu_IOPadDiff2Single\n', f'{extra_top}TOP = {top}\n')
    assert SIMALL_OLD in s and CLEAN_OLD in s
    s = s.replace(SIMALL_OLD, simall + cace)
    if cace:
        s = s.replace(CLEAN_OLD, CLEAN_NEW).replace(
            'clean: ## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation outputs)',
            'clean: ## Delete all generated files and folders (final, netlists, render, DRC/LVS reports, simulation and CACE outputs)')
    return s
out = {}
out['macros/ClassABBias/Makefile'] = mk('ClassABBiasIn',
 f'sim-all: ## Simulate the macro (the CACE suites of both bias variants; there are no separate testbenches)\n{T}$(MAKE) sim-cace-all\n.PHONY: sim-all\n',
 cace_block('ClassABBiasIn ClassABBiasOut', '$(TOP)'),
 '# Cells: ClassABBiasIn (reference current into iref), ClassABBiasOut (out of iref), ClassABBiasIdeal (test fixture).\n# Override with: make <target> TOP=<cell>\n').replace('TOP = ClassABBiasIn\n', 'TOP ?= ClassABBiasIn\n')
out['macros/ClassABDriver/Makefile'] = mk('ClassABDriver',
 f'# Ported IHP testbenches (testbenches/xschem/ClassABDriver_tb_<name>.sch)\nDRIVER_TBS := dc loop step thd noise op\n\n'
 f'sim-all: ## Simulate the macro (all six testbenches, then the CACE suite)\n{T}for t in $(DRIVER_TBS); do $(MAKE) sim-xschem TB=$(TOP)_tb_$$t || exit 1; done\n{T}$(MAKE) sim-cace\n.PHONY: sim-all\n',
 cace_block('ClassABDriverBiased', 'ClassABDriverBiased'),
 '# CACE DUT: ClassABDriverBiased (ClassABDriver on the ideal bias fixture ClassABBiasIdeal from ../ClassABBias)\n')
out['macros/PadEnable/Makefile'] = mk('DriverEnable',
 f"sim-all: ## Simulate the macro (no stand-alone testbenches: the cells are tested inside the pads)\n{T}@echo 'PadEnable has no testbenches of its own; run: make -C ../gf180mcu_IOPadDiff2Single sim-cace'\n.PHONY: sim-all\n",
 '', '# Cells: EnableInv, DriverEnable, BiasRefEnable, InputEnable. Override with: make <target> TOP=<cell>\n').replace('TOP = DriverEnable\n', 'TOP ?= DriverEnable\n')
out['macros/gf180mcu_IOPadDiff2Single/Makefile'] = mk('gf180mcu_IOPadDiff2Single',
 f'sim-all: ## Simulate the macro (CACE suite: enabled DC, disabled state, enable transient)\n{T}$(MAKE) sim-cace\n.PHONY: sim-all\n',
 cace_block('gf180mcu_IOPadDiff2Single', '$(TOP)'))
out['macros/gf180mcu_IOPadSingle2Diff/Makefile'] = mk('gf180mcu_IOPadSingle2Diff',
 f'sim-all: ## Simulate the macro (pad-in-the-loop DC testbench, then the CACE input-range suite)\n{T}$(MAKE) sim-xschem TB=$(TOP)_tb_dc\n{T}$(MAKE) sim-cace\n.PHONY: sim-all\n',
 cace_block('gf180mcu_IOPadSingle2Diff', '$(TOP)'))
o = oab.replace('CACE_JOBS ?= 4\n', 'CACE_JOBS ?= 4\n# --nofail: exit 0 and write the documentation (_docs) even when parameters fail; CACE_OPTS= to stop on failures\nCACE_OPTS ?= --nofail\n')
o = o.replace('-j $(CACE_JOBS) --parallel-parameters 1\n', '-j $(CACE_JOBS) --parallel-parameters 1 $(CACE_OPTS)\n')
assert o.count('$(CACE_OPTS)') == 1
out['macros/OgueyAebischerBias/Makefile'] = o
t = top
a = f'#{T}ToDo: further macros\n.PHONY: build-macros\n'
assert a in t
t = t.replace(a, f'''#{T}ToDo: further macros (OgueyAebischerBias, ClassABBias, ClassABDriver, PadEnable have no layout yet; see sim-cace-macros)
.PHONY: build-macros

sim-cace-macros: ## Run the CACE suites of all macros that have one
{T}$(MAKE) -C $(MACROS_DIR)/OgueyAebischerBias sim-cace-all
{T}$(MAKE) -C $(MACROS_DIR)/ClassABBias sim-cace-all
{T}$(MAKE) -C $(MACROS_DIR)/ClassABDriver sim-cace-all
{T}$(MAKE) -C $(MACROS_DIR)/gf180mcu_IOPadDiff2Single sim-cace
{T}$(MAKE) -C $(MACROS_DIR)/gf180mcu_IOPadSingle2Diff sim-cace
.PHONY: sim-cace-macros
''')
b = f'{T}$(MAKE) clean-diff2single\n#{T}ToDo: further macros\n.PHONY: clean-macros\n'
assert b in t
t = t.replace(b, f'''{T}$(MAKE) clean-diff2single
{T}@$(MAKE) -C $(MACROS_DIR)/OgueyAebischerBias clean
{T}@$(MAKE) -C $(MACROS_DIR)/ClassABBias clean
{T}@$(MAKE) -C $(MACROS_DIR)/ClassABDriver clean
{T}@$(MAKE) -C $(MACROS_DIR)/PadEnable clean
.PHONY: clean-macros
''')
out['Makefile'] = t
for p, s in out.items():
    d = os.path.join('tree', os.path.dirname(p)); os.makedirs(d, exist_ok=True)
    open(os.path.join('tree', p), 'w').write(s)
    print(p, len(s))
PYEOF
rm -rf tree; python3 gen_makefiles.py && U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single; for f in $(cd tree && find . -name Makefile | sort); do echo "== $f"; o=$U/${f#./}; if [ -f "$o" ]; then diff "$o" tree/$f; else echo NEW; fi; done 2>&1 | head -170
```

</details>

*[Test generated Makefiles with help and dry runs (in the cloud container; 72 lines of output).]*

<details><summary>command</summary>

```sh
rm -rf /tmp/mktest && mkdir -p /tmp/mktest && cp -a /home/claude/work/gf/macros /home/claude/work/gf/schematic /home/claude/work/gf/testbenches /home/claude/work/gf/scripts /tmp/mktest/ && cp -a /home/claude/work/repo/macros/OgueyAebischerBias/* /tmp/mktest/macros/OgueyAebischerBias/ 2>/dev/null; cp -a tree/. /tmp/mktest/; find /tmp/mktest -name xschemrc -exec sed -i '1s/^\xEF\xBB\xBF//' {} +; find /tmp/mktest -name "_runs" -prune -exec rm -rf {} +; cd /tmp/mktest && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:/home/claude/venv/bin:$PATH; for m in ClassABBias ClassABDriver PadEnable gf180mcu_IOPadDiff2Single gf180mcu_IOPadSingle2Diff OgueyAebischerBias; do echo "== $m"; make -C macros/$m help | grep -E "sim-|clean"; make -n -C macros/$m sim-all | grep -v "^make" | head -4; done; make help | grep -E "cace|clean-macros"
```

</details>

*[Run Makefile targets for real in a test copy (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/mktest && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:/home/claude/venv/bin:$PATH; (for t in dc loop step thd noise op; do make -C macros/ClassABDriver sim-xschem TB=ClassABDriver_tb_$t > /tmp/mk_$t.out 2>&1; echo "tb_$t exit $? $(grep -E '^(gain|t0|os|pm|onoise_total|vlo) ' /tmp/mk_$t.out | head -2 | tr '\n' ' ') $(grep -c THD /tmp/mk_$t.out)"; done); make -C macros/gf180mcu_IOPadSingle2Diff sim-xschem TB=gf180mcu_IOPadSingle2Diff_tb_dc > /tmp/mk_s2d.out 2>&1; echo "s2d exit $? $(grep -E '^(iin_5v0|vprot_5v0)' /tmp/mk_s2d.out | tr '\n' ' ')"; make -C macros/ClassABBias sim-cace CACE_PARAMS=line_params > /tmp/mk_cace.out 2>&1; echo "cace exit $?"; grep -E "Line sens" /tmp/mk_cace.out | head -4; make -C macros/ClassABBias clean >/dev/null && ls macros/ClassABBias/verification/cace
```

</details>

*[Inspect Single2Diff testbench failure (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
tail -15 /tmp/mk_s2d.out; grep -i "line\|Pass\|Fail" /tmp/mk_cace.out | tail -5
```

</details>

*[Check why xschem returns 10 for the input-pad testbench (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
ls -la /tmp/mktest/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem/simulations/; cd /tmp/mktest/macros/gf180mcu_IOPadSingle2Diff/testbenches/xschem && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; /opt/xschem/bin/xschem -r -x -q --rcfile xschemrc -n -o /tmp/s2dnl gf180mcu_IOPadSingle2Diff_tb_dc.sch 2>&1 | tail -5; echo "exit $?"; grep -i "warn\|error\|not found\|missing" /tmp/s2dnl/*.spice | head
```

</details>

*[Make the input-pad sim-all tolerate the undriven-pin status; test (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/mk && python3 - <<'EOF'
p='gen_makefiles.py'; s=open(p).read()
old="""f'sim-all: ## Simulate the macro (pad-in-the-loop DC testbench, then the CACE input-range suite)\\n{T}$(MAKE) sim-xschem TB=$(TOP)_tb_dc\\n{T}$(MAKE) sim-cace\\n.PHONY: sim-all\\n',"""
assert old in s
new="""('# xschem exits with status 10 on "undriven node: outp" (the single-ended -> differential buffer is not designed yet,\\n'
  '# outp/outn have no driver) although the netlist is complete; sim-all then runs ngspice on that netlist itself.\\n'
  f'sim-all: ## Simulate the macro (pad-in-the-loop DC testbench, then the CACE input-range suite)\\n'
  f'{T}rm -f $(XSCHEM_TB_DIR)/simulations/$(TOP)_tb_dc.spice\\n'
  f'{T}$(MAKE) sim-xschem TB=$(TOP)_tb_dc || (test -s $(XSCHEM_TB_DIR)/simulations/$(TOP)_tb_dc.spice && cd $(XSCHEM_TB_DIR)/simulations && ngspice -b $(TOP)_tb_dc.spice)\\n'
  f'{T}$(MAKE) sim-cace\\n.PHONY: sim-all\\n'),"""
s=s.replace(old,new); open(p,'w').write(s)
EOF
rm -rf tree && python3 gen_makefiles.py >/dev/null && cp tree/macros/gf180mcu_IOPadSingle2Diff/Makefile /tmp/mktest/macros/gf180mcu_IOPadSingle2Diff/Makefile && cd /tmp/mktest && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:/home/claude/venv/bin:$PATH && make -C macros/gf180mcu_IOPadSingle2Diff sim-all > /tmp/mk_s2d.out 2>&1; echo "exit $?"; grep -E "^(iin|vprot)_5v0|Completed|undriven" /tmp/mk_s2d.out | head
```

</details>

*[Dry-run top-level CACE target and run clean-macros (in the cloud container; 17 lines of output).]*

<details><summary>command</summary>

```sh
cd /tmp/mktest && export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD PATH=/opt/xschem/bin:/home/claude/venv/bin:$PATH && make -n sim-cace-macros | grep -E "^make|cace " | head -12; make clean-macros > /tmp/mk_clean.out 2>&1; echo "clean-macros exit $?"; tail -3 /tmp/mk_clean.out
```

</details>

*[Assemble Makefile package with checksums and diff (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
P=/home/claude/work/mk/pkg; rm -rf $P && mkdir -p $P/2026-10-08_opus_makefiles/repo && cd /home/claude/work/mk && cp -a tree/. $P/2026-10-08_opus_makefiles/repo/ && U=/mnt/user-data/uploads/gf180_cm_ip__single2diff2single && cd $P/2026-10-08_opus_makefiles && { for f in Makefile macros/OgueyAebischerBias/Makefile macros/gf180mcu_IOPadDiff2Single/Makefile macros/gf180mcu_IOPadSingle2Diff/Makefile; do md5sum < $U/$f | sed "s|-|$f|"; done; } > expected_originals.md5 && (cd repo && find . -name Makefile | sort | sed 's|^\./||' | xargs md5sum) > new.md5 && { for f in Makefile macros/OgueyAebischerBias/Makefile macros/gf180mcu_IOPadDiff2Single/Makefile macros/gf180mcu_IOPadSingle2Diff/Makefile; do diff -u --label a/$f --label b/$f $U/$f repo/$f; done; } > changes_to_existing_makefiles.diff; cat expected_originals.md5 new.md5; wc -l changes_to_existing_makefiles.diff
```

</details>

*[Write install script and README, zip, test the installer (in the cloud container; 45 lines of output).]*

<details><summary>command</summary>

~~~~sh
cat > install.sh <<'EOF'
#!/bin/sh
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
# Installs the Makefiles of this package into the design repository.
#   sh install.sh [<repo>]        default <repo>: ~/EDA/gf180_cm_ip__single2diff2single
# An existing Makefile is replaced only if it is still the version this package was made from
# (expected_originals.md5); otherwise it is left alone and reported. FORCE=1 replaces it anyway.
# Every replaced Makefile is kept next to it as Makefile.orig-2026-10-08 (delete those once you are happy).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
REPO=${1:-$HOME/EDA/gf180_cm_ip__single2diff2single}
[ -f "$REPO/submission.yaml" ] || { echo "not the design repository: $REPO"; exit 1; }
status=0
cd "$HERE/repo"
for f in $(find . -name Makefile | sed 's|^\./||' | sort); do
  dst="$REPO/$f"
  if [ -f "$dst" ]; then
    want=$(grep "  $f\$" "$HERE/expected_originals.md5" | cut -d' ' -f1)
    have=$(md5sum < "$dst" | cut -d' ' -f1)
    if [ "$have" = "$(grep "  $f\$" "$HERE/new.md5" | cut -d' ' -f1)" ]; then echo "already installed: $f"; continue; fi
    if [ "$have" != "$want" ] && [ "${FORCE:-0}" != 1 ]; then
      echo "SKIPPED (changed since 2026-10-08, see changes_to_existing_makefiles.diff): $f"; status=2; continue
    fi
    cp -p "$dst" "$dst.orig-2026-10-08"
    echo "replaced: $f (old one kept as $f.orig-2026-10-08)"
  else
    mkdir -p "$(dirname "$dst")"
    echo "new:      $f"
  fi
  cp "$f" "$dst"
done
cd "$REPO" && md5sum -c "$HERE/new.md5" 2>&1 | sed 's/^/check: /'
exit $status
EOF
cat > README.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Makefiles for the class-AB port (2026-10-08)

The bridge refuses to write Makefiles, so they come as this package. `repo/` mirrors the design repository
`~/EDA/gf180_cm_ip__single2diff2single`; each file goes to the same path there.

| file | status | change |
|---|---|---|
| `macros/ClassABBias/Makefile` | new | from the IOPad template; `TOP ?= ClassABBiasIn`; `sim-cace`, `sim-cace-all` (In and Out); `sim-all` = `sim-cace-all` (no separate testbenches) |
| `macros/ClassABDriver/Makefile` | new | `TOP = ClassABDriver`; `sim-all` runs the six testbenches `ClassABDriver_tb_{dc,loop,step,thd,noise,op}`, then `sim-cace` (DUT `ClassABDriverBiased`) |
| `macros/PadEnable/Makefile` | new | `TOP ?= DriverEnable`; `sim-all` only prints that the cells are tested in the output pad |
| `macros/gf180mcu_IOPadDiff2Single/Makefile` | changed | `sim-all` = `sim-cace` (it pointed at a `_tb_tran` testbench that does not exist); CACE targets; CACE outputs in `clean` |
| `macros/gf180mcu_IOPadSingle2Diff/Makefile` | changed | `sim-all` runs `_tb_dc` (was the non-existent `_tb_tran`) and `sim-cace`; tolerates xschem's exit status 10 for the undriven `outp`/`outn` when the netlist is complete; CACE targets and clean |
| `macros/OgueyAebischerBias/Makefile` | changed | `CACE_OPTS ?= --nofail` added to `sim-cace` (report even when parameters fail; `make sim-cace CACE_OPTS=` restores stop-on-fail) |
| `Makefile` (top level) | changed | new `sim-cace-macros` (all CACE suites); `clean-macros` also cleans OgueyAebischerBias, ClassABBias, ClassABDriver, PadEnable; `build-macros` unchanged (the new macros have no layout) |

All macro Makefiles keep the template's layout targets (DRC, LVS, PEX, LEF, …) unchanged; for the new macros they
have nothing to work on until there is a layout. The CACE targets are the same in every macro:

```
make sim-cace [CACE_TOP=<datasheet>] [CACE_PARAMS="<groups>"] [CACE_JOBS=4] [CACE_OPTS=--nofail]
make sim-cace-all
```

`changes_to_existing_makefiles.diff` shows every change to the four existing files.

## Install

```sh
unzip 2026-10-08_opus_makefiles.zip -d /tmp
sh /tmp/2026-10-08_opus_makefiles/install.sh ~/EDA/gf180_cm_ip__single2diff2single
```

`install.sh` replaces an existing Makefile only if it is unchanged since this package was made (checksums in
`expected_originals.md5`), keeps the old one as `Makefile.orig-2026-10-08`, and checks the installed files against
`new.md5`. A file you edited in the meantime is skipped and reported; merge it by hand from the diff, or run with
`FORCE=1`. Or copy by hand: `cp -r /tmp/2026-10-08_opus_makefiles/repo/. ~/EDA/gf180_cm_ip__single2diff2single/`.

## Tested (cloud container, copy of the repository)

- `make help` in every macro and at the top; `make -n sim-all` / `sim-cace-macros`.
- `ClassABDriver`: the six testbenches through `sim-xschem` (loop 93.1 dB, gain 0.49999, THD and noise as in the README).
- `gf180mcu_IOPadSingle2Diff`: `sim-all` (testbench, then CACE with `--nofail`; exit 0, input_params fails as expected).
- `ClassABBias`: `sim-cace CACE_PARAMS=line_params`; `make clean-macros` at the top.
EOF
chmod +x install.sh; cd .. && rm -f 2026-10-08_opus_makefiles.zip && zip -qr 2026-10-08_opus_makefiles.zip 2026-10-08_opus_makefiles && unzip -l 2026-10-08_opus_makefiles.zip; rm -rf /tmp/insttest && mkdir -p /tmp/insttest && cp -a /tmp/mktest /tmp/insttest/repo && for f in Makefile macros/OgueyAebischerBias/Makefile macros/gf180mcu_IOPadDiff2Single/Makefile macros/gf180mcu_IOPadSingle2Diff/Makefile; do cp /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/$f /tmp/insttest/repo/$f; done; rm -f /tmp/insttest/repo/macros/Class*/Makefile /tmp/insttest/repo/macros/PadEnable/Makefile; touch /tmp/insttest/repo/submission.yaml; cd /tmp && unzip -qo /home/claude/work/mk/pkg/2026-10-08_opus_makefiles.zip -d /tmp/insttest && sh /tmp/insttest/2026-10-08_opus_makefiles/install.sh /tmp/insttest/repo; echo "exit $?"; sh /tmp/insttest/2026-10-08_opus_makefiles/install.sh /tmp/insttest/repo | head -3
~~~~

</details>

*[Point README and handover at the Makefile package (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /mnt/user-data/outputs/mk && cp /home/claude/work/mk/pkg/2026-10-08_opus_makefiles.zip /mnt/user-data/outputs/mk/ && cd /home/claude/work/gf && python3 - <<'EOF'
def edit(p, a, b):
    s=open(p,encoding='utf-8').read(); assert a in s, (p,a[:50]); open(p,'w',encoding='utf-8').write(s.replace(a,b,1))
edit('README.md', "  These three have no Makefile yet (the bridge cannot write Makefiles); run CACE directly in `verification/cace/`.\n",
 "  Their Makefiles (and the changes to the existing ones: `sim-cace`, `sim-cace-all`, `make sim-cace-macros` at the top) come as a package, because the bridge cannot write Makefiles: `_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip`, installed with its `install.sh`.\n")
edit('HANDOVER_gf180_migration.md', "Not delivered: Makefiles for the three new macros (the bridge refuses Makefiles);",
 "Makefiles (three new, four changed) come as `_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip`\n(the bridge refuses Makefiles); its `install.sh` copies them and keeps the old ones as `Makefile.orig-2026-10-08`.\n")
print('ok')
EOF
grep -n "deliveries" README.md HANDOVER_gf180_migration.md | cut -c1-120; grep -n -A2 "deliveries" HANDOVER_gf180_migration.md | head
```

</details>

*[Fix sentence start; stage edited docs (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
sed -i '174s/^ not ported: the self-contained/Not ported: the self-contained/' HANDOVER_gf180_migration.md && sed -n 170,176p HANDOVER_gf180_migration.md && mkdir -p /mnt/user-data/outputs/mk/repo && cp README.md HANDOVER_gf180_migration.md /mnt/user-data/outputs/mk/repo/
```

</details>

*[Ran a command (on the computer; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && python3 -c "
import os
for f in ['README.md','HANDOVER_gf180_migration.md']: print(f, int(os.stat(f).st_mtime*1000))"; md5sum README.md HANDOVER_gf180_migration.md
```

</details>

*[Copied 3 files from the cloud container to the computer (1 lines of output).]*

*[Ran a command (on the computer; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries && md5sum 2026-10-08_opus_makefiles.zip && unzip -tq 2026-10-08_opus_makefiles.zip; cd $HOME/mnt/gf180_cm_ip__single2diff2single && md5sum README.md HANDOVER_gf180_migration.md Makefile macros/OgueyAebischerBias/Makefile macros/gf180mcu_IOPadDiff2Single/Makefile macros/gf180mcu_IOPadSingle2Diff/Makefile
```

</details>

*[Compare checksums with the computer (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
md5sum /mnt/user-data/outputs/mk/2026-10-08_opus_makefiles.zip /mnt/user-data/outputs/mk/repo/*.md
```

</details>

*[Log the Makefile package; rebuild chat log (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
L=/mnt/user-data/outputs/log1/2026-10-08_opus_classab_port_log.md; cat >> $L <<'EOF'

## 21:46 — Makefiles as a package (Christoph, 21:42: "drop me a zip file into the _sudelbuecher")

`sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip` (md5 558bde3f…): `repo/` mirrors the design repository,
`README.md` lists every file and change, `install.sh` installs, `changes_to_existing_makefiles.diff` shows the
changes to the four existing files.

- New: `macros/ClassABBias/Makefile` (sim-cace, sim-cace-all for In/Out; sim-all = sim-cace-all),
  `macros/ClassABDriver/Makefile` (sim-all = six testbenches + sim-cace on ClassABDriverBiased),
  `macros/PadEnable/Makefile` (sim-all only points to the pad's CACE).
- Changed: both IOPad Makefiles (their sim-all called a non-existent `<TOP>_tb_tran`; now CACE, and for Single2Diff
  the `_tb_dc` testbench, tolerating xschem's exit status 10 for the undriven outp/outn); OgueyAebischerBias
  (`CACE_OPTS ?= --nofail`); top level (`sim-cace-macros`, `clean-macros` covers all macros).
- `install.sh` replaces an existing Makefile only if its checksum is still the 2026-10-08 one (all four were, checked on
  the computer at 21:47), keeps it as `Makefile.orig-2026-10-08`, and checks the result.
- Tested in a copy of the repository in the cloud: help and dry runs everywhere; the six driver testbenches through
  sim-xschem; Single2Diff sim-all (exit 0); a ClassABBias CACE parameter; clean-macros; install.sh on the original
  files (all replaced, all checks OK) and a second run (all "already installed").
- `README.md` and `HANDOVER_gf180_migration.md` now point to the package (so their checksums in
  `2026-10-08_opus_classab_delivery.md5` are superseded: a5e740cb… and edd6d62f…).
EOF
/tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/rebuild.sh
```

</details>

*[Ran a command (on the computer; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && python3 -c "
import os
for f in ['logs/main/2026-10-08_opus_classab_port_log.md','chatlog/2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md']: print(f, int(os.stat(f).st_mtime*1000))"
```

</details>

*[Copied 2 files from the cloud container to the computer (1 lines of output).]*

I couldn't write the Makefiles into the repo, so they're in a zip with an install script. It's at `_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip`; the copy on your computer matches mine by checksum.

To install:

```sh
unzip ~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip -d /tmp
sh /tmp/2026-10-08_opus_makefiles/install.sh ~/EDA/gf180_cm_ip__single2diff2single
```

- **Safety:** `install.sh` only overwrites a Makefile you haven't edited since today; an edited one is skipped and listed. Your four current Makefiles are unedited, so all will be replaced. Each replaced file is kept next to it as `Makefile.orig-2026-10-08`. Delete those once you're happy, since git would otherwise show them as new files.
- **Copy by hand instead:** `cp -r /tmp/2026-10-08_opus_makefiles/repo/. ~/EDA/gf180_cm_ip__single2diff2single/` (this keeps no backups).

What's in it:
- **New Makefiles in `ClassABBias`, `ClassABDriver` and `PadEnable`.** They're built from the pad Makefile template.
  - `ClassABBias`: `sim-all` runs the CACE suites of both bias variants.
  - `ClassABDriver`: `sim-all` runs the six testbenches, then the CACE suite.
  - `PadEnable`: `sim-all` only says the cells are tested inside the output pad.
- **Both pad Makefiles were broken:** their `sim-all` called a `_tb_tran` testbench that doesn't exist. Now:
  - `gf180mcu_IOPadDiff2Single`: `sim-all` runs its CACE suite.
  - `gf180mcu_IOPadSingle2Diff`: `sim-all` runs the `_tb_dc` testbench, then CACE. Xschem stops there with exit status 10 because `outp`/`outn` have no driver yet (the buffer isn't designed), even though the netlist is complete. `sim-all` runs ngspice on that netlist anyway.
- **CACE targets in every macro:** `make sim-cace` and `make sim-cace-all`, reporting even when a parameter fails. `make sim-cace CACE_OPTS=` stops at the first failure instead. `OgueyAebischerBias` gets the same option.
- **Top-level Makefile:** a new `make sim-cace-macros` runs every CACE suite, and `clean-macros` now covers all macros. I left `build-macros` alone: the new macros have no layout, so its DRC/LVS steps would fail on them.

In a copy of the repo in my cloud container, the six driver testbenches, the input-pad `sim-all`, one bias CACE parameter, `clean-macros` and the installer all ran without errors. The installer was tested on unchanged originals and on a second run, not on a file you've edited. Nothing has been run in your container yet.

I also pointed the top-level README and the handover file at the zip, and added an entry to the running log; the chat log is updated through 21:46.

## Turn 14 — 2026-10-08 22:09

**User:**

Concerning
Not done

* The Oguey–Aebischer and bandgap bias variants. Both need a real GF180 re-design, not a port.

Is this a task better left to Fable or to Opus with extra effort?

**Assistant:**

I'd split it: the Oguey–Aebischer core is fine for Opus, and I'd give the bandgap to Fable if you have it. I can't benchmark the two against each other on this kind of work, so this is a judgment about where each task is hard, not a measured comparison.

**Oguey–Aebischer core: Opus, normal or high effort.** It's the same procedure I already ran for `OgueyAebischerBias`:
- read the device data off the GF180 models;
- set M10/M11 into weak inversion;
- size the composite pair for the target current;
- check mismatch by Monte Carlo;
- rework the start-up.

The open points are known in advance: `MS1` at L = 100 µm exceeds GF180's 50 µm limit, and the T^1.3 temperature drift is inherent to the topology. Errors in that kind of work are caught by the simulations, not by more reasoning.

**Bandgap: Fable, or Opus at the highest effort if not.** This is a real design problem with coupled choices:
- **Resistor temperature coefficient.** The IHP version leaned on rhigh's −0.22 %/K, which almost cancels V_BE by itself. GF180's `ppolyf_u_1k` is −0.094 %/K and `ppolyf_u_3k` −0.167 %/K, so the PTAT/CTAT balance has to be rebuilt. One option worth trying is mixing in a positive-TC resistor such as `ppolyf_s`.
- **PNPs.** GF180's vertical PNPs come in fixed geometries (5×5 or 10×10 µm), so the area ratio can only be set with `m`. That changes the ln(N) term and the layout.
- **False operating point and start-up.** The R1A/R1B asymmetry that stopped the core from resting with both PNPs off has to be re-derived, and start-up re-checked at all corners.
- **Headroom.** The stacked cascodes at 3.0 V, slow corner, −40 °C.

That's the kind of multi-variable trade-off where a stronger model is more likely to find a good topology on the first pass. The simulation loop catches mistakes either way, but not a weak design choice.

**What matters more than the model choice is the brief.** Either model will do better with:
- your targets: current, allowed drift over temperature, allowed spread over corners, area budget, supply range;
- whether 06v0 devices or a 5 V supply are on the table;
- which of the two variants you actually need. If the reference current comes from elsewhere on the chip, maybe only one.

Today's pitfalls (CACE quirks, the disabled-state convergence problem, the xschemrc library-path bug) are written up in the running log, so the next session won't repeat them.

I can write a kickoff file for that session into `_sudelbuecher`, covering scope, the facts the redesign starts from, and the verification setup to reuse.

## Turn 15 — 2026-10-08 22:36

**User:**

ok set up a hand-off for a side (or main) quest to redesign the reference circuits. I might have some more questions in addition. Tell me how to set up the cowork session. Give me an estimate how much of my (as of 2 days ago, Max) token budget I'm going to burn, in particular if I tell Fable to get at the task.

**Assistant:**

*[Loaded skill "product-self-knowledge".  
Searched the web for "site:support.claude.com Max plan usage limits Fable".  
Searched the web for "site:support.claude.com Claude desktop app cloud session link computer folders model selection effort" (6 lines of output).  
Fetched https://support.claude.com/en/articles/15424964-claude-fable-models-on-your-plan.  
Fetched https://support.claude.com/en/articles/15811196-what-to-expect-with-claude-cowork-in-the-cloud (9 lines of output).]*

*[Measure this session's token usage by phase (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
import json, datetime
from zoneinfo import ZoneInfo
TZ=ZoneInfo('Europe/Berlin')
def load(p):
    out={}
    for l in open(p):
        r=json.loads(l)
        if r.get('type')!='assistant': continue
        m=r.get('message',{}); u=m.get('usage'); mid=m.get('id')
        if not u or not mid: continue
        t=datetime.datetime.fromisoformat(r['timestamp'].replace('Z','+00:00')).astimezone(TZ)
        out[mid]=(t,u,m.get('model'))
    return out
a=load('/tmp/claude-0/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb/scratchpad/chatlog/session.jsonl')
b=load('/root/.claude/projects/-home-claude/ae2f9665-832e-520c-96fd-494fa4898beb.jsonl')
a.update(b)
def agg(f):
    s=dict(n=0,inp=0,cw=0,cr=0,out=0)
    for t,u,mo in a.values():
        if f(t):
            s['n']+=1; s['inp']+=u.get('input_tokens',0); s['cw']+=u.get('cache_creation_input_tokens',0); s['cr']+=u.get('cache_read_input_tokens',0); s['out']+=u.get('output_tokens',0)
    return s
d=lambda s: datetime.datetime.fromisoformat(s).replace(tzinfo=TZ)
print('models', {mo for _,_,mo in a.values()})
for name,f in [('whole session 10-06 21:30 .. now',lambda t:True),
               ('bias port + IOPad (10-06/07)',lambda t:t<d('2026-10-08T03:10')),
               ('class-AB port 10-08 19:22-21:20',lambda t:d('2026-10-08T19:20')<=t<d('2026-10-08T21:20')),
               ('Makefiles 21:42-21:50',lambda t:d('2026-10-08T21:40')<=t<d('2026-10-08T21:55'))]:
    s=agg(f); print(name, s, 'total M', round((s['inp']+s['cw']+s['cr']+s['out'])/1e6,1))
EOF
```

</details>

*[Collect GF180 resistor TCs and PNP facts for the kickoff (in the cloud container; 24 lines of output).]*

<details><summary>command</summary>

```sh
P=/home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice; for r in nplus_u pplus_u npolyf_u ppolyf_s ppolyf_u; do echo "$r: $(sed -n "/^\.subckt $r /,/^\.ends/p" $P | grep -m2 -o "r_tc1=[-0-9.e]*\|rsh_$r[ =]*[^ ]*" | tr '\n' ' ')"; done; grep -n "^\.param rsh_\(nplus_u\|pplus_u\|ppolyf_s\|ppolyf_u\|npolyf_u\)=" $P | head; grep -n "^\.lib bjt_statistical" -A3 $P | head; grep -n "subckt pnp_05p00x05p00" -A3 $P | head -5; grep -c "mc_.*pnp\|pnp.*mc_" $P
```

</details>

*[Package the sizing harness for the next session and test it (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
K=/mnt/user-data/outputs/kick/2026-10-08_reference_redesign; rm -rf $K; mkdir -p $K/tools; cd /home/claude/work/classab/sim && cp bias_ref_gf.spice run_bias_gf.py run_gf.py units_gf.spice bias_lp_gf.spice mpdda_gf.spice $K/tools/ && cd $K/tools && sed -i 's|^PDK = "/home/claude/pdk/gf180mcuD/libs.tech/ngspice"|PDK = os.path.join(os.environ.get("PDK_ROOT", "/foss/pdks"), os.environ.get("PDK", "gf180mcuD"), "libs.tech", "ngspice")|' run_gf.py run_bias_gf.py && grep -n "^PDK\|^import" run_gf.py run_bias_gf.py && python3 - <<'EOF'
for f in ['run_gf.py','run_bias_gf.py']:
    s=open(f).read()
    hdr='#!/usr/bin/env python3\n# SPDX-FileCopyrightText: 2026 Christoph Maier\n# SPDX-License-Identifier: Apache-2.0\n'
    if not s.startswith('#!'): s=hdr+s
    else: s=s.replace('#!/usr/bin/env python3\n',hdr,1)
    open(f,'w').write(s)
EOF
export PDK_ROOT=/home/claude/pdk PDK=gf180mcuD; python3 run_bias_gf.py in | head -3; python3 run_gf.py tt
```

</details>

*[Write the kickoff file and tools README (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

~~~~sh
K=/mnt/user-data/outputs/kick/2026-10-08_reference_redesign; cat > $K/tools/README.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Sizing harness of the 2026-10-08 class-AB port (copied as a starting point)

Plain ngspice decks and two Python drivers, used to size the GF180 class-AB driver and bias before drawing
schematics. Needs `PDK_ROOT` (and `PDK`, default `gf180mcuD`) and ngspice on the path.

| file | content |
|---|---|
| `bias_ref_gf.spice` | `d2s_bias_diodes`, `d2s_bias_in`, `d2s_bias_out` with the GF180 sizes (= the `ClassABBias` sheets) |
| `units_gf.spice`, `mpdda_gf.spice`, `bias_lp_gf.spice` | DDA unit, driver, ideal bias fixture (= the `ClassABDriver` sheets) |
| `run_bias_gf.py` | the six bias currents (0 V sources in the diode drains) over MOS/res corners, temperature, supply. Variant keys `in out oa bg`: `oa`/`bg` expect subckts `d2s_bias_oa` / `d2s_bias_bg` with an `Xt` instance of `d2s_bias_in` (IHP structure); add their netlist file to `FILES` |
| `run_gf.py` | driver on the ideal fixture: op, loop gain, DC transfer; `tt`, `corners`, `loads` |

```
python3 run_bias_gf.py in out          # current errors, % of 5/5/2/2/5/5 uA
python3 run_gf.py corners
```
EOF
cat > $K/kickoff_reference_redesign.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Kickoff: GF180 redesign of the self-contained bias references of the class-AB driver

Written 2026-10-08 22:40 by the session that ported the class-AB driver (Claude, configured model `claude-opus-5-5`),
for a new session. Christoph decides scope and targets; confirm the open questions (§3) with him first.

## 1. Task

The class-AB pad driver of `gf180_cm_ip__single2diff2single` takes its six bias currents from the bias tree
`ClassABBiasIn`, fed by a 5 µA reference current into `iref`. On IHP there were two self-contained references
that make that current on chip; on GF180 they do not exist yet. **Re-design them for GF180MCU (gf180mcuD) — do not
transliterate the IHP sizes:**

1. `ClassABBiasOA`: resistor-free Oguey–Aebischer core (IHP `oa_core`), output 5 µA into the `ClassABBiasIn` tree.
2. `ClassABBiasBG`: current-mode (Banba) bandgap core with vertical PNPs (IHP `bg_core`), same output.

Each as cells in `macros/ClassABBias/` (schematic, symbol, CACE suite like `ClassABBiasIn`), with start-up, and with
a disable (see §3.5). The IHP design stays the reference and is not changed.

## 2. Where things are

| what | where |
|---|---|
| design repo (write) | `~/EDA/gf180_cm_ip__single2diff2single` — macros `ClassABBias`, `ClassABDriver`, `PadEnable`, the two pads, `OgueyAebischerBias` |
| notes worktree (write) | `~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/` — `logs/main/`, `chatlog/`, `backups/`, `deliveries/`, this folder |
| IHP notes (read only) | `~/EDA/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/` |

Read first:

- IHP `improvements/bias.md` (design, results, open points of all four variants), `improvements/sim/d2s_bias_ref.spice`
  (`oa_core`, `bg_core`, the source netlists), `improvements/sim/run_bias.py` and `results_bias.txt` (the IHP checks and
  numbers; do not rerun IHP), `improvements/xschem/d2s_bias_oa.sch`, `d2s_bias_bg.sch` (Christoph's hand-edited
  drawings, layout conventions in `improvements/xschem/README.md`).
- IHP `power_down/log.md`, entry 17:10 and 20:45: the switch plan for the cores (MS1 gated, vpg pulled to vdd, ks to vss).
- GF180 repo: `macros/ClassABBias/README.md`, `macros/ClassABDriver/README.md`, `macros/PadEnable/README.md`,
  `HANDOVER_gf180_migration.md` §7–8, `macros/OgueyAebischerBias/README.md` (the earlier GF180 resistor-free reference at
  100 nA: sizing method, I_spec / A_VT table, PSRR problem).
- Running log of the port: `sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md` (every number and pitfall).
- `tools/` next to this file: the plain-ngspice sizing harness of the port (README there).

## 3. Open questions for Christoph (ask at the start; defaults in brackets)

1. Which of the two (or both)? The pads take iref from outside; maybe one chip-level reference feeds all pads.
   [both, OA first]
2. Targets: output current [5 µA into the tree], allowed drift −40…125 °C [bandgap: ±3 %; OA: whatever the topology
   gives, report it], process spread [report], mismatch σ [≤ 2 % bandgap, ≤ 5 % OA], line sensitivity [≤ 1 %/V],
   start-up from 0 V with 1 µs and 1 ms ramps at all corners [required], area budget [report].
3. Device family and supply: 03v3 at 3.0–3.6 V [default], or 06v0 / 5 V (`docs/OPERATING_LIMITS.md`).
4. Relation to `macros/OgueyAebischerBias` (100 nA, PSRR 31 dB, cascoding not done): merge, replace or leave alone?
   [leave alone]
5. Disable: the cores have internal nodes that need switches (MS1's gate, vpg, ks). Ports `en`, `en_b` on the core cells
   with the switches inside, or a `PadEnable`-style sub-cell? [a sub-cell `RefCoreEnable` in `macros/PadEnable`,
   instantiated in the core cell, so the enable stays its own sub-macro]

## 4. GF180 facts the redesign starts from (checked 2026-10-06/08 in gf180mcuD from gf180mcu_fd_pr e11a8c9)

- MOS 03v3 bins: L 0.28–50 µm, **W ≤ 100 µm per instance counting the total W, not W/nf** (W = 400 µm with nf = 40 fails
  "could not find a valid modelname"). IHP `oa_core` MS1 is 0.5/100 µm → needs a different solution (L ≤ 50 µm).
- Mismatch: `.param sw_stat_mismatch=1`; `fets_mm` draws one sample per instance with σ from that instance's own W·L and
  **ignores `m`**: draw matched multi-unit devices as one instance with nf = units. A_VT ≈ 7.1 (n) / 6.7 (p) mV·µm;
  I_spec per square at IC = 1 ≈ 360 nA (n, slope 1.41) / 97 nA (p, 1.46) (`OgueyAebischerBias/README.md`).
- Corners: `sm141064.ngspice` sections `typical ss ff sf fs`, `res_typical res_ss res_ff`, `bjt_typical bjt_ss bjt_ff`,
  `moscap_*`, `mimcap_*`, `bjt_statistical`, `res_statistical`. (06v0 devices use `_t` in every MOS corner in this file.)
- Resistors (first-order body TC `r_tc1` from the model cards; the terminal resistances have their own TC, so simulate the
  effective TC): `ppolyf_u_1k` 1 kΩ/sq −0.094 %/K; `ppolyf_u_2k`; `ppolyf_u_3k` −0.167 %/K; `ppolyf_u` 350 Ω/sq
  −0.009 %/K; `npolyf_u` 310 Ω/sq −0.14 %/K; `ppolyf_s` 7.3 Ω/sq +0.32 %/K; `nplus_u` 60 Ω/sq +0.136 %/K; `pplus_u`
  185 Ω/sq +0.138 %/K. Symbols: pins M P B (bulk is a pin). IHP rhigh was −0.22 %/K and nearly cancelled V_BE by itself;
  that balance has to be rebuilt (a series mix of negative- and positive-TC resistors is one option).
- PNPs: `pnp_05p00x05p00`, `pnp_10p00x10p00` (and the 0.42 µm strips), pins C B E, **geometry fixed, ratios only via m**;
  they have mismatch parameters (`mis_is_*`, `mis_bf_*`, agauss); check whether `sw_stat_mismatch` turns them on.
- MIM option 2 fF/µm² (`cap_mim_2f0fF`); MOS caps `cap_pmos_03v3` etc. (moscap sections).

## 5. Verification flow (reuse; it works)

1. Size in plain ngspice first (`tools/`), then draw: start from the IHP sheets `d2s_bias_oa.sch` / `d2s_bias_bg.sch`
   with `macros/ClassABDriver/scripts/port_classab_from_ihp.py` (symbol/property substitution keeps Christoph's
   drawing; extend its tables for the new devices, PNPs and resistors whose pins differ) or with `scripts/xsheet.py`.
2. Round trip: `macros/ClassABDriver/scripts/check_classab_port.py <reference.spice> <xschem netlist> <subckt> <cell>`,
   MISMATCHES 0, and sanity-check it once with a deliberate error.
3. CACE: copy `macros/ClassABBias/scripts/gen_cace.py` (currents of the six diodes, line sensitivity, mismatch) and add
   start-up (supply ramps, `t_startup` measured as in `OgueyAebischerBias`: last time outside ±10 % of the final value)
   and temperature sweeps. `make sim-cace` once the Makefile package (`deliveries/2026-10-08_opus_makefiles.zip`) is
   installed; add the new datasheets to `CACE_CELLS` in `macros/ClassABBias/Makefile`.
4. Then the driver with the real reference: an `iref`-free pad variant, or a CACE fixture `ClassABBiasOA` → driver.

Pitfalls already paid for (details in the running log):

- CACE 2.13: a condition named like a pin takes its own value (use `i_ref`, not `iref`); state every condition a
  parameter does not sweep (else a pin's Vmin is used); brace-escape `CACE{…}` inside symbol `value=` strings; unit `%`
  shows 100 × the echoed value (echo fractions); `off` in a YAML list is false; templates are netlisted with the PDK
  xschemrc + templates folder only, the DUT with its own folder's xschemrc.
- ngspice: noise refuses `option KLU`; read earlier plots as `op1.<vec>` after a later analysis; with all current roots
  off (disabled state) the DC operating point is unreliable — read leakage at the end of a short transient.
- Transients: `abstol=1e-13` and an explicit tmax, or cold corners take minutes.
- xschem: in a cloud container the UTF-8 BOM at the start of some project `xschemrc` files breaks loading (netlist from a
  BOM-stripped copy there; leave the files alone); xschem exits 10 on undriven output pins while writing a complete netlist.
- Self-biased references can have a zero-current or a false operating point: check start-up from 0 V without `.nodeset`,
  and the IHP bandgap's R1A/R1B asymmetry trick.

## 6. Rules (Christoph's standing orders)

- **No git commands** without asking first (even `status`/`log` can leave an `index.lock` on the bridge). Never
  `git switch sudel_buecher` in the main directory.
- Write to the computer only with `device_commit_files` from a staged folder under `/mnt/user-data/outputs/`, with
  `expectedMtimeMs` guards on existing files; verify checksums afterwards (PNG/SVG get a provenance stamp: compare
  decoded pixels). Before overwriting anything, copy the old version into `sudelbuecher/backups/<date>_<topic>/` on the
  computer. Never overwrite Christoph's hand edits.
- Makefiles cannot be written by the bridge: deliver them as a zip in `sudelbuecher/deliveries/` with an installer.
- No Microsoft formats; never suggest a spreadsheet. Index external sources, don't copy them.
- Memory: never add inferences about Christoph's habits or views to persistent memory without asking.
- Keep a running log `sudelbuecher/logs/main/<date>_<model>_reference_redesign_log.md`, updated after each milestone
  (context compaction happens); export the chat log with `sudelbuecher/chatlog/export_chatlog.py` (it handles compaction).
- Results go to the macro READMEs and `verification/cace/results/<cell>/`; update `HANDOVER_gf180_migration.md`.

## 7. Suggested order and checkpoints

1. Confirm §3 with Christoph. 2. OA core: size (tools), start-up, PVT, mismatch → sheet → round trip → CACE → log.
3. Checkpoint with Christoph (numbers, area, usage so far). 4. Bandgap: TC balance with GF180 resistors, PNP ratio via
m, false operating point, start-up, headroom at ss/3.0 V/−40 °C → sheet → round trip → CACE → log. 5. Driver with each
reference over PVT (I_Q, loop, offset), compare with the ideal fixture as on IHP (`bias.md`, "Results, driver").
EOF
ls -R $K
~~~~

</details>

*[Copied 8 files from the cloud container to the computer (1 lines of output).]*

*[Ran a command (on the computer).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign && find . -type f | sort | xargs md5sum
```

</details>

*[Checksums of staged kickoff files (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /mnt/user-data/outputs/kick/2026-10-08_reference_redesign && find . -type f | sort | xargs md5sum
```

</details>

*[Ran a command (on the computer; 23 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && ls cloud_environment.md && grep -n "gf180\|^#" cloud_environment.md | head -30; wc -l cloud_environment.md
```

</details>

*[Add cloud setup section to the kickoff (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
K=/mnt/user-data/outputs/kick/2026-10-08_reference_redesign/kickoff_reference_redesign.md; python3 - $K <<'EOF'
import sys
p=sys.argv[1]; s=open(p).read()
a="## 5. Verification flow (reuse; it works)\n"
b="""## 5. Cloud tools (the new session's container starts empty)

Follow `sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/cloud_environment.md` (IHP notes): it builds
xschem 3.4.8RC and ngspice-47 as in Christoph's IIC-OSIC-TOOLS image and installs gf180mcuD from the image's open_pdks
build (`1689ac3`, ciel release asset). The IHP PDK and OpenVAF are not needed for this task. Add CACE in a venv
(`pip install cace`, 2.13 was used) and `PDK_ROOT`/`PDK=gf180mcuD`.
The 2026-10-08 numbers came from a different setup (ngspice-42, gf180mcuD assembled from gf180mcu_fd_pr `e11a8c9`):
rerun `ClassABBiasIn` and `ClassABDriverBiased` CACE once first and note any differences in the log before designing.

## 6. Verification flow (reuse; it works)
"""
assert a in s; s=s.replace(a,b)
s=s.replace("## 6. Rules (Christoph's standing orders)","## 7. Rules (Christoph's standing orders)").replace("## 7. Suggested order and checkpoints","## 8. Suggested order and checkpoints")
open(p,'w').write(s)
EOF
grep -n "^## " $K; md5sum $K
```

</details>

*[Ran a command (on the computer; 1 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
import os; print(int(os.stat(os.path.expanduser('~/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/kickoff_reference_redesign.md')).st_mtime*1000))"
```

</details>

*[Copied 1 files from the cloud container to the computer (1 lines of output).]*
