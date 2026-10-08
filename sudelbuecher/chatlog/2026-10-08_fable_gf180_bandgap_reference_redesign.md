<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# GF180 bandgap reference redesign (ClassABBiasBG)

Session `669e0843-1ea7-5638-8c5d-93eca71fd6cf`, Claude (configured model `claude-fable-5-1`; the serving model may differ).
Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;
tool calls as `*[ ]*` summaries (actions and observable results only); shell commands verbatim in collapsed blocks, their output omitted.
The internal reasoning trace is not included.
Times are Europe/Berlin. Exported through the record stamped 2026-10-09 01:09; later turns are not in this file.

## Turn 1 — 2026-10-08 23:16

**User:**

Read `~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/kickoff_reference_redesign.md` and follow it. Ask me the open questions in §3 before designing.

**Assistant:**

*[Ran a command (on the computer; 132 lines of output).]*

<details><summary>command</summary>

```sh
cat "$HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/kickoff_reference_redesign.md"
```

</details>

I've read the kickoff. Before any design work, here are the §3 questions.

*[Question card shown to the user:]*

- Which reference(s) should this session design, and in what order? Options: Both, OA first (Recommended); Both, bandgap first; OA only; Bandgap only
- Targets for the 5 µA output: accept the kickoff defaults (bandgap drift ±3 % −40…125 °C, OA drift reported; mismatch σ ≤ 2 % BG / ≤ 5 % OA; line sensitivity ≤ 1 %/V; start-up from 0 V with 1 µs and 1 ms ramps required at all corners; process spread and area reported)? Options: Accept defaults (Recommended); Tighter; Report only, no limits
- Device family and supply for the reference cores? Options: 03v3 at 3.0–3.6 V (Recommended); 06v0 at 5 V; 03v3 devices, 06v0-tolerant later
- What to do with the existing macros/OgueyAebischerBias (100 nA, PSRR 31 dB, cascoding not done)? Options: Leave alone (Recommended); Replace it; Merge

*[Result: 1 lines of output.]*

One more (§3.5, the disable), plus a clarification on "06v0-tolerant later":

*[Question card shown to the user:]*

- How should the disable be implemented in ClassABBiasBG (switches on MS1's gate, vpg, ks)? Options: Sub-cell RefCoreEnable (Recommended); Switches inside the core cell; No disable for now
- What does "03v3 devices, 06v0-tolerant later" mean for this pass? Options: Just keep it in mind; Avoid 5V-blocking choices; Also check at 5 V now

*[Result: 1 lines of output.]*

*[Request interrupted by user]*

## Turn 2 — 2026-10-08 23:26

**User:**

One more consideration: if the process used allows deep well transistors (i.e., nmos transistors with isolated pwells), make a design variant that uses them. Check the difference before running a full verification/CACE characterization. Tell me what difference the deep well option makes (probably in terms of PSRR and area).
Ok go.

**Assistant:**

*[Created task "Read IHP reference material and GF180 repo state".  
Created task "Set up cloud tools (xschem, ngspice, gf180mcuD, CACE) and rerun ClassABBiasIn/ClassABDriverBiased CACE".  
Created task "Check PDK for deep-n-well NMOS and PNP/resistor mismatch in gf180mcuD".  
Created task "Size the Banba bandgap core in plain ngspice (TC balance, PNP ratio, false OP, start-up, headroom)".  
Created task "Draw ClassABBiasBG sheet + symbol + RefCoreEnable, round-trip check".  
Created task "CACE suite for ClassABBiasBG, results to README/results, HANDOVER update, running log, chat log export".  
Set task 1 to in_progress.]*

*[Ran a command (on the computer; 295 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/ && ls -R improvements power_down | head -80; echo ----; cat improvements/bias.md
```

</details>

*[Ran a command (on the computer; 167 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements && ls sim xschem; echo ----; grep -n "bg_core" -A80 sim/d2s_bias_ref.spice | head -200
```

</details>

*[Ran a command (on the computer; 24 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/ && sed -n 89,97p improvements/sim/d2s_bias_ref.spice; echo ----; wc -l improvements/sim/run_bias.py improvements/sim/results_bias.txt; grep -n "bg" improvements/sim/results_bias.txt | head -60
```

</details>

*[Ran a command (on the computer; 254 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/ && cat improvements/sim/run_bias.py
```

</details>

*[Ran a command (on the computer; 232 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/ && cat improvements/xschem/README.md; echo ----; grep -n "^## \|17:10\|20:45" power_down/log.md | head -40
```

</details>

*[Ran a command (on the computer; 101 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/ && sed -n 41,95p power_down/log.md; sed -n 120,200p power_down/log.md
```

</details>

Now the GF180 repo side.

*[Ran a command (on the computer; 148 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && ls; ls macros macros/ClassABBias macros/ClassABBias/* macros/PadEnable macros/PadEnable/*; echo ----; cat macros/ClassABBias/README.md
```

</details>

*[Ran a command (on the computer; 87 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && cat macros/PadEnable/README.md; echo ----; ls macros/PadEnable/schematic/xschem macros/ClassABBias/schematic/xschem macros/ClassABBias/verification/cace macros/ClassABBias/verification/cace/results 2>/dev/null; echo ----; cat macros/PadEnable/scripts/padenable_reference.spice
```

</details>

*[Ran a command (on the computer; 143 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && cat macros/OgueyAebischerBias/README.md | head -150; echo ----; grep -n "^## " HANDOVER_gf180_migration.md
```

</details>

*[Ran a command (on the computer; 69 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && sed -n 153,260p HANDOVER_gf180_migration.md; echo ----; cat docs/OPERATING_LIMITS.md | head -80
```

</details>

Now the running log of the port and the tools/ folder next to the kickoff.

*[Ran a command (on the computer; 80 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && ls kickoffs/2026-10-08_reference_redesign kickoffs/2026-10-08_reference_redesign/tools logs/main chatlog deliveries backups 2>/dev/null; echo ----; cat kickoffs/2026-10-08_reference_redesign/tools/README.md 2>/dev/null; echo ----; wc -l logs/main/2026-10-08_opus_classab_port_log.md; grep -n "^## \|^### " logs/main/2026-10-08_opus_classab_port_log.md
```

</details>

*[Ran a command (on the computer; 100 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && sed -n 1,100p logs/main/2026-10-08_opus_classab_port_log.md
```

</details>

*[Ran a command (on the computer; 57 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && sed -n 134,150p logs/main/2026-10-08_opus_classab_port_log.md; sed -n 192,231p logs/main/2026-10-08_opus_classab_port_log.md
```

</details>

Now the cloud environment recipe.

*[Ran a command (on the computer; 111 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && cat cloud_environment.md
```

</details>

Reading is done. I'll start the cloud toolchain build in the background (takes ~10 min) and meanwhile look at the remaining details.

*[Check container resources and tools (in the cloud container; 29 lines of output).]*

<details><summary>command</summary>

```sh
nproc; free -g | head -2; df -h /home/claude | tail -1; which ngspice xschem python3 cargo; python3 --version; lsb_release -d 2>/dev/null; ls /opt 2>/dev/null
```

</details>

*[Wrote build_env.sh (in the cloud container; 1 lines of output).]*

*[Start the EDA toolchain build in the background (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
chmod +x /home/claude/tools/build_env.sh && nohup /home/claude/tools/build_env.sh > /home/claude/tools/build_env.log 2>&1 &
echo started
```

</details>

While that builds, the sizing harness and existing xschem/CACE assets:

*[Ran a command (on the computer; 76 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools && cat run_bias_gf.py; echo ----; cat bias_ref_gf.spice
```

</details>

*[Ran a command (on the computer; 375 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single/macros && cat ClassABBias/verification/cace/ClassABBiasIn.yaml; ls ClassABBias/verification/cace/templates ClassABBias/verification/cace/results/ClassABBiasIn; ls ClassABDriver/scripts; cat ClassABBias/schematic/xschem/xschemrc
```

</details>

*[Ran a command (on the computer; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && du -sh --exclude=.git . macros/* docs scripts 2>/dev/null; ls macros/ClassABDriver/scripts macros/ClassABDriver/schematic/xschem macros/ClassABDriver/verification/cace 2>/dev/null | head -40
```

</details>

*[Ran a command (on the computer; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt && mkdir -p gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete && tar czf gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/cloud_transfer_2026-10-08.tgz \
  --exclude=.git --exclude='*/_runs' --exclude='*/_docs' --exclude='*.gds' --exclude='*.png' --exclude='*.pdf' --exclude='layout' \
  gf180_cm_ip__single2diff2single \
  gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip \
  sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem \
  sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/sim/d2s_bias_ref.spice \
  sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/power_down/sim \
  sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/power_down/xschem && ls -la gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/ && md5sum gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/cloud_transfer_2026-10-08.tgz
```

</details>

*[Copied 1 files from the computer to the cloud container (1 lines of output).]*

*[Unpack the repo snapshot in the cloud workspace (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
sleep 5; mkdir -p /home/claude/work && cd /home/claude/work && md5sum /mnt/user-data/uploads/gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/cloud_transfer_2026-10-08.tgz && tar xzf /mnt/user-data/uploads/gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/cloud_transfer_2026-10-08.tgz && ls; tail -3 /home/claude/tools/build_env.log
```

</details>

Checksum matches. The PDK is already in place, so I can check the device questions (deep n-well NMOS, PNP mismatch, resistors) while xschem/ngspice compile.

*[List PDK ngspice models and xschem symbols of interest (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech && ls ngspice xschem | head -50; ls xschem/symbols | grep -i -E "dn|pnp|ppolyf|mim|nfet_03|pfet_03|nfet_06|pfet_06"
```

</details>

*[Check PDK download status (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "PDK_DONE\|tar\|curl" /home/claude/tools/build_env.log | head; ls -la /home/claude/pdk /home/claude/src | head; ls -la /home/claude/src/common.tar.zst
```

</details>

*[Extract the gf180mcuD PDK subset with wildcards (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src && tar --zstd -tf common.tar.zst | head -5; tar --zstd --wildcards -xf common.tar.zst -C /home/claude/pdk 'gf180mcuD/libs.tech/xschem/*' 'gf180mcuD/libs.tech/ngspice/*' 'gf180mcuD/.config/*' && ls /home/claude/pdk/gf180mcuD/libs.tech /home/claude/pdk/gf180mcuD/libs.tech/ngspice
```

</details>

*[Inspect PDK symbols and model subcircuits for deep n-well and PNP devices (in the cloud container; 79 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech && ls xschem; ls xschem/symbols | grep -i -E "_dn|pnp|ppolyf|mim|nfet_03|pfet_03|nfet_06|pfet_06|npolyf|nplus|pplus"; echo ----; grep -n "^\.subckt" ngspice/sm141064.ngspice | grep -i -E "dn|pnp" | head -30; grep -n "^\.lib\|^\.LIB" ngspice/sm141064.ngspice | head -40
```

</details>

*[Search model files for deep n-well NMOS and PNP model definitions (in the cloud container; 83 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice && grep -n -i "_dn\b\|_dn \|dnw\|deep" sm141064.ngspice sm141064.spice design.ngspice | head -30; echo ----; grep -n "^\.subckt nfet_03v3\|^\.subckt pfet_03v3\|^\.subckt nfet_06v0\|^\.subckt pfet_06v0" sm141064.ngspice sm141064.spice | head; echo ----; sed -n 47366,47430p sm141064.ngspice
```

</details>

*[Look for deep n-well device support in PDK xschem and model files (in the cloud container; 55 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech && ls xschem/gf180mcu_fd_pr | head; ls xschem/tests | head -40; grep -rl "dnw\|_dn\b" xschem 2>/dev/null | head; grep -n "diode_pw2dw\|diode_dw2ps" ngspice/sm141064.ngspice | head -5; grep -n "^\.lib " ngspice/sm141064.ngspice | awk '{print $2}' | sort -u | tr '\n' ' '
```

</details>

*[Check build progress (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
tail -2 /home/claude/tools/build_env.log; grep -c . /home/claude/tools/build_env.log; ls /home/claude/tools
```

</details>

*[List KLayout DRC/LVS files in the PDK archive (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src && tar --zstd -tf common.tar.zst | grep -i -E "klayout.*(drc|lvs)" | head -20
```

</details>

*[Extract DRC deck and list deep n-well rules (in the cloud container; 10 lines of output).]*

<details><summary>command</summary>

```sh
tar --zstd --wildcards -xf common.tar.zst -C /home/claude/pdk 'gf180mcuD/libs.tech/klayout/tech/drc/*' 'gf180mcuD/libs.tech/klayout/tech/lvs/*' 2>/dev/null; ls /home/claude/pdk/gf180mcuD/libs.tech/klayout/tech/drc/; grep -n -i "DN\.\|dnwell" /home/claude/pdk/gf180mcuD/libs.tech/klayout/tech/drc/gf180mcu.drc | head -40
```

</details>

*[Read deep n-well and low-voltage p-well DRC rule values (in the cloud container; 41 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/klayout/tech/drc/rule_decks && ls; grep -n -i -A3 "DN\.[0-9]\|LPW\.[0-9]" dnwell.drc lvpwell.drc 2>/dev/null | grep -i "rule\|logger.info\|um" | head -60
```

</details>

*[Extract deep n-well, p-well and n-well rule values (in the cloud container; 28 lines of output).]*

<details><summary>command</summary>

```sh
grep -n -B1 -A2 "DN\.[0-9]\|LPW\.[0-9]\|NW\.1\b\|NW\.2\b" dnwell.rb lvpwell.rb nwell.rb | grep -E "logger|\.um|rule|space|enclos|width|sep" | head -80
```

</details>

*[Read DNWELL rules and related n-well spacing (in the cloud container; 37 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 25,70p dnwell.rb; grep -n "DN\." nwell.rb comp.rb | head; grep -n -A2 "NW.1\b\|NW.1'" nwell.rb | head -8
```

</details>

*[Find n-well and comp rules that reference the deep n-well (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "dnwell" nwell.rb comp.rb pplus.rb nplus.rb | grep -i "output\|Rule" | head -20
```

</details>

*[Search rule decks for deep n-well related rules (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
grep -rn -i "dnwell\|dn\b" nwell.rb comp.rb | head -20; grep -rln "dnwell" . | head
```

</details>

*[Wait for ngspice build (in the cloud container; error).]*

<details><summary>command</summary>

```sh
sleep 240; tail -3 /home/claude/tools/build_env.log; ls /home/claude/tools
```

</details>

*[Wait for ngspice build (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
sleep 100; tail -3 /home/claude/tools/build_env.log; ls /home/claude/tools
```

</details>

*[Create environment file and verify tool versions (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cat > /home/claude/tools/env.sh <<'EOF'
export TOOLS=/home/claude/tools
export PDK_ROOT=/home/claude/pdk
export PDK=gf180mcuD
export PATH=$TOOLS/xschem/bin:$TOOLS/ngspice/bin:$TOOLS/cace-venv/bin:$PATH
EOF
source /home/claude/tools/env.sh; ngspice -v | head -2; xschem --version 2>&1 | head -1; cace --version 2>&1 | tail -1; ls /home/claude/pdk/gf180mcuD/libs.tech/ngspice/.spiceinit 2>&1
```

</details>

*[Install tkinter for CACE and check version (in the cloud container; error).]*

<details><summary>command</summary>

```sh
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-tk >/dev/null 2>&1; source /home/claude/tools/env.sh; python3 -c "import tkinter" && cace --version 2>&1 | tail -1; $TOOLS/cace-venv/bin/python -c "import tkinter; print('tk ok')"
```

</details>

*[Find a python with tkinter (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
which -a python3; python3 --version; /usr/bin/python3 --version; /usr/bin/python3 -c "import tkinter; print('tk ok')"; ls /usr/lib/python3*/tkinter 2>/dev/null | head -2
```

</details>

*[Check which python has tkinter after install (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
ls -d /usr/lib/python3*/; ls /usr/bin/python3.*; for p in /usr/bin/python3.*; do $p -c "import tkinter; print('$p tk ok')" 2>/dev/null; done; apt list --installed 2>/dev/null | grep -i python3-tk
```

</details>

*[Rebuild the CACE venv on python3.12 with tkinter (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh; rm -rf $TOOLS/cace-venv && /usr/bin/python3.12 -m venv $TOOLS/cace-venv && $TOOLS/cace-venv/bin/pip install -q cace==2.13 numpy matplotlib 2>&1 | tail -2; cace --version 2>&1 | tail -1
```

</details>

*[Set task 1 to completed.  
Set task 2 to in_progress.]*

Toolchain is up (xschem 3.4.8RC, ngspice-47, CACE 2.13, gf180mcuD 1689ac3). Now the check the kickoff asks for first: rerun the existing `ClassABBiasIn` CACE and compare with the 2026-10-08 numbers.

*[Check for BOMs and read the previous CACE summary (in the cloud container; 26 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh; cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && head -c 3 ../../schematic/xschem/xschemrc | xxd | head -1; head -c 3 templates/xschemrc | xxd | head -1; cat results/ClassABBiasIn/summary.md | head -60
```

</details>

*[Rerun ClassABBiasIn CACE with the new toolchain (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh; cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && for f in ../../schematic/xschem/xschemrc templates/xschemrc ../../../ClassABDriver/schematic/xschem/xschemrc; do printf "%s: " $f; head -c 3 $f | od -An -tx1; done; mkdir -p /home/claude/work/logs; (time cace ClassABBiasIn.yaml -s schematic --nofail -j 2 --parallel-parameters 1 > /home/claude/work/logs/cace_ClassABBiasIn_rerun.out 2>&1); tail -5 /home/claude/work/logs/cace_ClassABBiasIn_rerun.out
```

</details>

*[Locate the fresh CACE summary (in the cloud container; 24 lines of output).]*

<details><summary>command</summary>

```sh
grep -i "error\|fail\|warn" /home/claude/work/logs/cace_ClassABBiasIn_rerun.out | head; ls _docs 2>/dev/null; find . -name "summary*" -newer ClassABBiasIn.yaml | head; find _docs _runs -name "*.md" 2>/dev/null | head
```

</details>

*[Compare old and new CACE results for ClassABBiasIn (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
import re
def parse(f):
    d={}
    for l in open(f):
        if l.startswith('|') and 'ngspice' in l:
            t=[x.strip() for x in l.strip('|\n').split('|')]
            d[t[0]]=(t[4],t[6],t[8])
    return d
a=parse('results/ClassABBiasIn/summary.md'); b=parse('_runs/RUN_2026-10-08_23-36-08/summary.md')
for k in a:
    print(f"{k:28s} old {a[k]}  new {b.get(k)}")
EOF
```

</details>

Identical to the digit. Now `ClassABDriverBiased` (longer run), in the background while I start the sizing deck.

*[Start ClassABDriverBiased CACE rerun in the background (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh; cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABDriver/verification/cace && grep -n "^  [a-z_]*:$" ClassABDriverBiased.yaml | head -20; nohup cace ClassABDriverBiased.yaml -s schematic --nofail -j 2 --parallel-parameters 1 > /home/claude/work/logs/cace_ClassABDriverBiased_rerun.out 2>&1 &
echo started
```

</details>

*[Read the ppolyf_u_3k resistor model (in the cloud container; 41 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice && grep -n "^\.subckt ppolyf_u_3k\|^\.subckt ppolyf_u_1k\|^\.subckt ppolyf_u_2k\|^\.subckt ppolyf_u \|^\.subckt npolyf_u \|^\.subckt nplus_u\|^\.subckt pplus_u" sm141064.ngspice | head; n=$(grep -n "^\.subckt ppolyf_u_3k " sm141064.ngspice | head -1 | cut -d: -f1); sed -n "${n},$((n+30))p" sm141064.ngspice
```

</details>

*[Check resistor mismatch modelling and sheet resistances (in the cloud container; 28 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "sw_stat_mismatch" sm141064.ngspice | grep -v "pnp\|nfet\|pfet\|npn" | head; n=$(grep -n "^\.lib res_statistical_par" sm141064.ngspice | cut -d: -f1); sed -n "${n},$((n+12))p" sm141064.ngspice; grep -n "rsh_ppolyf_u_3k\s*=\|rsh_ppolyf_u_1k\s*=\|rsh_ppolyf_u_2k\s*=\|rsh_ppolyf_u\s*=" sm141064.ngspice | head; grep -n "^\.lib res_ss" -A8 sm141064.ngspice | grep ppolyf_u | head
```

</details>

*[Identify which resistor models carry mismatch (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 38580,38600p sm141064.ngspice | grep -n "subckt\|mis_r" ; sed -n 38700,38740p sm141064.ngspice | grep "subckt\|mis_r\|param mis"; grep -n "^\.subckt ppolyf_u_1k \|^\.subckt ppolyf_u_2k " sm141064.ngspice; grep -n "sw_stat_mismatch" sm141064.ngspice | sed -n 1,3p; grep -c "mis_r" sm141064.ngspice; grep -n "param mis_r" sm141064.ngspice | head
```

</details>

*[Characterize GF180 devices at the bandgap operating point (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
mkdir -p /home/claude/work/sizing && cd /home/claude/work/sizing && source /home/claude/tools/env.sh && cat > dev.cir <<'EOF'
* device characterization gf180mcuD
.include /home/claude/pdk/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical
.lib /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.param ib=2.5u
Vdd vdd 0 3.3
* pmos diodes at 2.5 uA
Ip1 vdd p1 0 ; placeholder
XP1 p1 p1 vdd vdd pfet_03v3 W=40u L=1u nf=4
I1 p1 0 {ib}
XP2 p2 p2 vdd vdd pfet_03v3 W=40u L=2u nf=4
I2 p2 0 {ib}
XP3 p3 p3 vdd vdd pfet_03v3 W=80u L=2u nf=8
I3 p3 0 {ib}
XP4 p4 p4 vdd vdd pfet_03v3 W=20u L=4u nf=2
I4 p4 0 {ib}
* nmos diodes at 2.5 uA, source at 0.7 V, bulk 0 and bulk=source
Vs s 0 0.7
XN1 n1 n1 s 0 nfet_03v3 W=20u L=4u nf=1
I5 vdd n1 {ib}
XN2 n2 n2 s s nfet_03v3 W=20u L=4u nf=1
I6 vdd n2 {ib}
XN3 n3 n3 s 0 nfet_03v3 W=40u L=4u nf=2
I7 vdd n3 {ib}
* pnps at 2.5 uA
XQ1 0 0 e1 pnp_05p00x05p00
I8 vdd e1 {ib}
XQ2 0 0 e2 pnp_10p00x10p00
I9 vdd e2 {ib}
XQ3 0 0 e3 pnp_05p00x05p00 m=8
I10 vdd e3 {ib}
* resistors 1 um wide 100 um long
XR1 r1 0 0 ppolyf_u_1k r_length=100u r_width=1u
Ir1 0 r1 1u
XR2 r2 0 0 ppolyf_u_2k r_length=100u r_width=1u
Ir2 0 r2 1u
XR3 r3 0 0 ppolyf_u_3k r_length=100u r_width=1u
Ir3 0 r3 1u
XR4 r4 0 0 ppolyf_u r_length=100u r_width=1u
Ir4 0 r4 1u
XR5 r5 0 0 npolyf_u r_length=100u r_width=1u
Ir5 0 r5 1u
XR6 r6 0 0 pplus_u r_length=100u r_width=1u
Ir6 0 r6 1u
XR7 r7 0 0 nplus_u r_length=100u r_width=1u
Ir7 0 r7 1u
.control
foreach t -40 27 125
  set temp = $t
  op
  echo T $t  Vsg p40/1 $&v(vdd,p1) p40/2 $&v(vdd,p2) p80/2 $&v(vdd,p3) p20/4 $&v(vdd,p4)
  echo T $t  Vgs n20/4 b0 $&v(n1,s) bs $&v(n2,s) n40/4 $&v(n3,s)
  echo T $t  Vbe 5x5 $&v(e1) 10x10 $&v(e2) 8x5x5 $&v(e3)
  echo T $t  R 1k $&v(r1) 2k $&v(r2) 3k $&v(r3) ppu $&v(r4) npu $&v(r5) pplus $&v(r6) nplus $&v(r7)
end
.endc
.end
EOF
sed -i '/^Ip1 /d' dev.cir; ngspice -b dev.cir 2>&1 | grep "^T "
```

</details>

*[Rerun device characterization with fixed voltage expressions (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/\$&v(vdd,p\([0-9]\))/$\&vsg\1/g; s/\$&v(n\([0-9]\),s)/$\&vgs\1/g' dev.cir && sed -i 's/^  op$/  op\n  let vsg1=v(vdd)-v(p1)\n  let vsg2=v(vdd)-v(p2)\n  let vsg3=v(vdd)-v(p3)\n  let vsg4=v(vdd)-v(p4)\n  let vgs1=v(n1)-v(s)\n  let vgs2=v(n2)-v(s)\n  let vgs3=v(n3)-v(s)/' dev.cir && ngspice -b dev.cir 2>&1 | grep "^T .*V[sg]"
```

</details>

*[Compare resistor TC parameters and minimum widths (in the cloud container; 19 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice && for r in ppolyf_u_1k ppolyf_u_2k ppolyf_u_3k; do n=$(grep -n "^\.subckt $r " sm141064.ngspice | head -1 | cut -d: -f1); echo "$r: $(sed -n "$n,$((n+10))p" sm141064.ngspice | grep -o "r_tc1=[^ ]*\|r_tc2=[^ ]*\|r_dw=.[^ ]*\|r_dl=[^ ]*" | tr '\n' ' ')"; done; grep -n "rsh_ppolyf_u_3k\|rsh_ppolyf_u_1k" sm141064.ngspice | sed -n 1,8p; grep -n -i "PRES\.[0-9].*width\|min.*width" /home/claude/pdk/gf180mcuD/libs.tech/klayout/tech/drc/rule_decks/hres.rb /home/claude/pdk/gf180mcuD/libs.tech/klayout/tech/drc/rule_decks/pres.rb | head -8
```

</details>

*[Copy the sizing harness and read the DNW diode models (in the cloud container; 48 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh; cd /home/claude/work/sizing && cp ../gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/*.spice ../gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/*.py . && ls; n=$(grep -n "^\.model diode_pw2dw" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | cut -d: -f1); sed -n "$((n-12)),$((n+30))p" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | grep -v "^+ [a-z]*=0$" | head -60
```

</details>

*[Check the DNW diode instantiation syntax (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech && grep -n "subckt diode_pw2dw\|subckt diode_dw2ps" ngspice/sm141064.ngspice | head -3; grep -h "format\|template" xschem/symbols/diode_pw2dw.sym 2>/dev/null | head -5; grep -o "diode_pw2dw[^}]*" xschem/tests/test_diode_pw2dw.sch | head -3; ls xschem/symbols | grep diode
```

</details>

Good — `D<name> a c diode_pw2dw area= pj=` is the syntax, and the symbols exist. Now the first core netlist and harness.

*[Wrote bg_gf.spice (in the cloud container; 1 lines of output).]*

*[Write the bandgap sizing harness and run the first corner check (in the cloud container; 29 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/sizing && sed -i 's/^\.param rw=2u r1a=102u r1b=92.7u r0=48u/.param rw=1u r1a=117u r1b=107u r0=51u/' bg_gf.spice && cat > run_bg.py <<'EOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""Cloud-only sizing harness: GF180 bandgap core bg_core / bg_core_dn (bg_gf.spice), output into an NI-type
NMOS diode (6u/6u) or into the class-AB tree. Sections as run_bias.py on IHP."""
import re, subprocess, tempfile, os, sys
import numpy as np
PDK = os.path.join(os.environ.get("PDK_ROOT", "/foss/pdks"), os.environ.get("PDK", "gf180mcuD"), "libs.tech", "ngspice")
HERE = os.path.dirname(os.path.abspath(__file__))
FILES = ['bias_ref_gf.spice', 'bg_gf.spice']
CORN = [('tt 27C', {}), ('ss 27C', dict(c='ss')), ('ff 27C', dict(c='ff')), ('sf 27C', dict(c='sf')), ('fs 27C', dict(c='fs')),
        ('res ss', dict(r='res_ss')), ('res ff', dict(r='res_ff')), ('bjt ss', dict(b='bjt_ss')), ('bjt ff', dict(b='bjt_ff')),
        ('tt -40C', dict(temp=-40)), ('tt 125C', dict(temp=125)),
        ('ss 3.0V -40C', dict(c='ss', vdd=3.0, temp=-40)), ('ff 3.6V 125C', dict(c='ff', vdd=3.6, temp=125)),
        ('ss 3.0V 125C', dict(c='ss', vdd=3.0, temp=125)), ('ff 3.6V -40C', dict(c='ff', vdd=3.6, temp=-40))]
TEMPS = [-40, -20, 0, 27, 50, 85, 105, 125]

def src(params=''):
    s = ''.join(open(os.path.join(HERE, f)).read() for f in FILES)
    return s + '\n' + params + '\n'

def header(c='typical', r='res_typical', b='bjt_typical', temp=27, mm=0, seed=None):
    return (f".include {PDK}/design.ngspice\n.lib {PDK}/sm141064.ngspice {c}\n.lib {PDK}/sm141064.ngspice {r}\n"
            f".lib {PDK}/sm141064.ngspice {b}\n.lib {PDK}/sm141064.ngspice diode_typical\n.temp {temp}\n"
            f".param sw_stat_mismatch={mm}\n" + (f".option seed={seed}\n" if seed else ''))

def net(var='bg_core', vdd=3.3, ac=False, ramp=None, params='', load='diode', **kw):
    v = f"Vvdd vdd 0 pwl(0 0 {ramp} {vdd})\n" if ramp else f"Vvdd vdd 0 dc {vdd}" + (" ac 1\n" if ac else "\n")
    if load == 'diode':
        ld = "Vs iout s 0\nXNI s s 0 0 nfet_03v3 W=6u L=6u nf=1\n"
    else:
        ld = "Vs iout s 0\nRL s 0 {load}\n"
    return header(**kw) + src(params) + v + f"Xc vdd 0 iout {var}\n" + ld

def ngspice(deck, ctl):
    d = tempfile.mkdtemp(dir='/tmp')
    open(d + '/b.cir', 'w').write('* b\n' + deck + '.control\n' + ctl + '.endc\n.end\n')
    o = subprocess.run(['ngspice', '-b', 'b.cir'], cwd=d, capture_output=True, text=True)
    return o.stdout + o.stderr

def results(o):
    out = {}
    for l in o.splitlines():
        if l.startswith('R '):
            t = l.split()
            try:
                out[t[1]] = [float(x) for x in t[2:]] if len(t) > 3 else float(t[2])
            except ValueError:
                pass
    return out

def iout(var='bg_core', **kw):
    o = ngspice(net(var, **kw), "op\necho R iout $&i(vs)\necho R idd $&i(vvdd)\n"
                "echo R g $&v(xc.g)\necho R ea $&v(xc.ea)\necho R eb $&v(xc.eb)\necho R vpc $&v(xc.vpc)\necho R vpg $&v(xc.vpg)\necho R ks $&v(xc.ks)\n")
    r = results(o)
    if 'iout' not in r:
        raise RuntimeError(o[-2000:])
    return r

def tempsweep(var='bg_core', **kw):
    return [iout(var, temp=t, **kw)['iout'] for t in TEMPS]

def section_temp(var='bg_core', params=''):
    print(f"\n== {var} vs temperature, iout uA  (params: {params or 'file defaults'})")
    print("  " + ''.join(f"{t:>8d}" for t in TEMPS) + "   drift % (vs 27C)")
    for name, c in [('tt 3.3V', {}), ('ss 3.0V', dict(c='ss', vdd=3.0)), ('ff 3.6V', dict(c='ff', vdd=3.6)),
                    ('res ss', dict(r='res_ss')), ('res ff', dict(r='res_ff')), ('bjt ss', dict(b='bjt_ss')), ('bjt ff', dict(b='bjt_ff'))]:
        i = tempsweep(var, params=params, **c)
        i27 = i[TEMPS.index(27)]
        print(f"  {name:10s}" + ''.join(f"{x*1e6:8.3f}" for x in i) + f"   {100*(min(i)/i27-1):+.2f} / {100*(max(i)/i27-1):+.2f}")

def section_corners(var='bg_core', params=''):
    print(f"\n== {var} corners: iout uA, deviation from 5 uA, Idd uA, node voltages")
    for name, c in CORN:
        r = iout(var, params=params, **c)
        print(f"  {name:14s} iout {r['iout']*1e6:7.4f} ({100*(r['iout']/5e-6-1):+6.2f} %)  Idd {-r['idd']*1e6:6.2f}  "
              f"g {r['g']:.3f} ea {r['ea']:.3f} eb {r['eb']:.3f} vpc {r['vpc']:.3f} vpg {r['vpg']:.3f} ks {r['ks']:.3f}")

def section_line(var='bg_core', params=''):
    print(f"\n== {var} line sensitivity (3.0 -> 3.6 V) %/V, and AC |di/dvdd| / I, %/V")
    for name, c in [('tt 27C', {}), ('ss -40C', dict(c='ss', temp=-40)), ('ff 125C', dict(c='ff', temp=125))]:
        lo, mid, hi = (iout(var, vdd=v, params=params, **c)['iout'] for v in (3.0, 3.3, 3.6))
        ctl = ("ac dec 10 1 1e8\nlet m = mag(i(vs))\n" + ''.join(f"meas ac p{j} find m at={f}\n" for j, f in enumerate([10, 1e3, 1e5, 1e6, 1e7])) +
               "echo R ac " + ' '.join(f"$&p{j}" for j in range(5)) + "\n")
        p = results(ngspice(net(var, ac=True, params=params, **c), ctl))['ac']
        print(f"  {name:10s} dc {100*(hi-lo)/mid/0.6:+.3f} %/V   ac 10Hz/1k/100k/1M/10M: " + ' '.join(f"{100*x/mid:.2f}" for x in p))

def section_startup(var='bg_core', params=''):
    print(f"\n== {var} start-up from 0 V (all nodes 0, uic), ramps 1 us and 1 ms; iout 1 ms after the ramp vs op; t_startup = last time outside +-10 %")
    for name, c in [('tt 27C', {}), ('ss 3.0V -40C', dict(c='ss', temp=-40, vdd=3.0)), ('ff 3.6V 125C', dict(c='ff', temp=125, vdd=3.6)),
                    ('sf -40C', dict(c='sf', temp=-40)), ('fs 125C', dict(c='fs', temp=125)), ('tt -40C', dict(temp=-40)), ('tt 125C', dict(temp=125)),
                    ('ss 3.0V 125C', dict(c='ss', temp=125, vdd=3.0)), ('res ff -40C', dict(r='res_ff', temp=-40)), ('res ss 125C', dict(r='res_ss', temp=125))]:
        d = iout(var, params=params, **c)['iout']
        for tr in (1e-6, 1e-3):
            ts = tr + 1e-3
            ctl = (f".option method=gear abstol=1e-13\n"
                   f"tran {ts/4000} {ts} 0 {ts/2000} uic\nlet ib = abs(i(vs))\nmeas tran ibf find ib at={ts}\n"
                   f"let lo = 0.9*ibf\nlet hi = 1.1*ibf\nmeas tran tlo when ib=lo cross=last\nmeas tran thi when ib=hi cross=last\n"
                   f"echo R res $&ibf $&tlo $&thi\n")
            o = results(ngspice(net(var, ramp=tr, params=params, **c), ctl)).get('res')
            if not o or len(o) < 1:
                txt = 'NO RESULT'
            else:
                ibf = o[0]; tlo = o[1] if len(o) > 1 else 0; thi = o[2] if len(o) > 2 else 0
                tst = max(tlo if tlo > 0 else 0, thi if thi > 0 else 0)
                txt = f"iout {ibf*1e6:7.4f} uA ({100*(ibf/d-1):+6.2f} % vs op)  t_startup {(tst-tr)*1e6:8.1f} us after ramp"
            print(f"  {name:14s} t_r {tr*1e6:6.0f} us: {txt}")

def section_mc(var='bg_core', params='', N=100):
    print(f"\n== {var} mismatch MC, {N} seeds (sw_stat_mismatch=1: MOS, PNP; the PDK has no resistor mismatch)")
    rs = []
    for s in range(1, N + 1):
        rs.append(iout(var, params=params, mm=1, seed=s)['iout'])
    rs = np.array(rs)
    print(f"  mean {rs.mean()*1e6:.4f} uA  sigma {100*rs.std()/rs.mean():.2f} %  min {100*(rs.min()/rs.mean()-1):+.2f} %  max {100*(rs.max()/rs.mean()-1):+.2f} %")

S = {'temp': section_temp, 'corners': section_corners, 'line': section_line, 'startup': section_startup, 'mc': section_mc}
if __name__ == '__main__':
    var = 'bg_core'
    params = ''
    secs = []
    for a in sys.argv[1:]:
        if a.startswith('var='): var = a[4:]
        elif '=' in a: params += f".param {a}\n"
        else: secs.append(a)
    for s in secs or S:
        S[s](var, params)
        sys.stdout.flush()
EOF
source /home/claude/tools/env.sh && python3 run_bg.py corners 2>&1 | head -30
```

</details>

Parameter name `ln` collides with the ngspice log function; rename.

*[Rename the NMOS length parameter and rerun corners (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
sed -i 's/\bln=4u\b/lnn=4u/; s/L={ln}/L={lnn}/g' bg_gf.spice && source /home/claude/tools/env.sh && python3 run_bg.py corners 2>&1 | head -30
```

</details>

*[Wrote bg_gf.spice (in the cloud container; error).]*

*[Remove the old core netlist before rewriting (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
rm bg_gf.spice && echo removed
```

</details>

*[Wrote bg_gf.spice (in the cloud container; 1 lines of output).]*

*[Run corners on the wide-swing cascode version (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/echo R vpg \$&v(xc.vpg)/echo R vpg $\&v(xc.vpg)\\necho R cb $\&v(xc.cb)\\necho R vpc $\&v(xc.vpc)/' run_bg.py && sed -i "s/vpg {r\['vpg'\]:.3f} ks/vpg {r['vpg']:.3f} cb {r['cb']:.3f} ks/" run_bg.py && python3 run_bg.py corners 2>&1 | head -30
```

</details>

*[Switch to the self-biased wide-swing cascode (RC between gate lines) and rerun corners (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
s = open('bg_gf.spice').read()
s = s.replace("""* branch PX / PXD, because with pfet_03v3's higher |V_T| the IHP stacked-diode cascode leaves NB no headroom at
* ss / 3.0 V / -40 C.""", """* resistor RC between the two gate lines (vpc = vpg - I*RC, self-biased wide-swing mirror), because with
* pfet_03v3's higher |V_T| the IHP stacked-diode cascode leaves NB no headroom at ss / 3.0 V / -40 C.""")
s = s.replace(".param wp=48u lp=2u nfp=4 wpc=40u lpc=1u nfpc=4 wxd=4u lxd=1u", ".param wp=48u lp=2u nfp=4 wpc=48u lpc=2u nfpc=4 rc=40u")
s = s.replace("XPX vpc vpg vdd vdd pfet_03v3 W={wp} L={lp} nf={nfp}\nXPXD vpc vpc vdd vdd pfet_03v3 W={wxd} L={lxd} nf=1\n", "XRC vpg vpc vss ppolyf_u_3k r_width={rw} r_length={rc}\n")
s = s.replace("XNB vpg g eb", "XNB vpc g eb")
open('bg_gf.spice','w').write(s)
EOF
grep -n "XRC\|XNB\|XPX" bg_gf.spice; source /home/claude/tools/env.sh && python3 run_bg.py corners 2>&1 | head -30
```

</details>

*[Scan the PTAT share for the 3k resistor and report temperature drift (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && cat > tune_r.py <<'EOF'
import run_bg as r, numpy as np, sys
var = sys.argv[1] if len(sys.argv) > 1 else 'bg_core'
rtype = sys.argv[2] if len(sys.argv) > 2 else '3k'
rsh = {'3k': 3000, '2k': 2000, '1k': 1000}[rtype]
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
EOF
sed -i 's/^\.param rw=1u r1a=117u r1b=107u r0=51u/.param rw=1u r1a=117u r1b=107u r0=51u\n.param rctype=3k/' bg_gf.spice; python3 tune_r.py bg_core 3k
```

</details>

*[Scan the PTAT share with the 1k and the plain ppolyf_u resistor (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
s=open('run_bg.py').read()
s=s.replace("def src(params=''):\n    s = ''.join(open(os.path.join(HERE, f)).read() for f in FILES)\n",
"RMODEL = os.environ.get('RMODEL', 'ppolyf_u_3k')\ndef src(params=''):\n    s = ''.join(open(os.path.join(HERE, f)).read() for f in FILES).replace('ppolyf_u_3k', RMODEL)\n")
open('run_bg.py','w').write(s)
EOF
sed -i "s/rsh = {'3k': 3000, '2k': 2000, '1k': 1000}\[rtype\]/rsh = {'3k': 3000, '2k': 2000, '1k': 1000, 'u': 350}[rtype]\nimport os; r.RMODEL = {'3k':'ppolyf_u_3k','2k':'ppolyf_u_2k','1k':'ppolyf_u_1k','u':'ppolyf_u'}[rtype]/" tune_r.py
echo "--- 1k"; python3 tune_r.py bg_core 1k; echo "--- ppolyf_u"; python3 tune_r.py bg_core u
```

</details>

*[Switch to the 1k resistor and run temperature and corner sections (in the cloud container; 26 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/^\.param rw=1u r1a=117u r1b=107u r0=51u/.param rw=1u r1a=426u r1b=388u r0=68.6u/; s/rc=40u/rc=50u/; s/ppolyf_u_3k/ppolyf_u_1k/g' bg_gf.spice && sed -i "s/RMODEL = os.environ.get('RMODEL', 'ppolyf_u_3k')/RMODEL = os.environ.get('RMODEL', 'ppolyf_u_1k')/; s/.replace('ppolyf_u_3k', RMODEL)/.replace('ppolyf_u_1k', RMODEL)/" run_bg.py && python3 run_bg.py temp corners 2>&1
```

</details>

*[Rerun corners and line sensitivity with RC scaled for the 1k resistor (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/rc=50u/rc=150u/' bg_gf.spice && python3 run_bg.py corners line 2>&1 | grep -v "^$"
```

</details>

*[Compare line sensitivity for NMOS pair sizes and the DNW variant (in the cloud container; 24 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && for v in bg_core bg_core_dn; do for p in "wn=20u lnn=4u nfn=2" "wn=40u lnn=8u nfn=4" "wn=20u lnn=12u nfn=2"; do echo "## $v $p"; python3 run_bg.py var=$v $p line 2>&1 | grep "dc"; done; done
```

</details>

*[Rerun temperature and corners with the longer NMOS pair (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/^\.param wn=20u lnn=4u nfn=2/.param wn=20u lnn=12u nfn=2/' bg_gf.spice && python3 run_bg.py temp corners 2>&1 | grep -v "^$" | head -30
```

</details>

*[Center the temperature band and compare both variants (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/^\.param rw=1u r1a=426u r1b=388u r0=68.6u/.param rw=1u r1a=420u r1b=382u r0=67.5u/' bg_gf.spice && python3 run_bg.py temp 2>&1 | grep -v "^$" | head -9 && python3 run_bg.py var=bg_core_dn temp 2>&1 | grep -v "^$" | head -9
```

</details>

*[Run start-up transients at all corners (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 run_bg.py startup 2>&1 | grep -v "^$"
```

</details>

*[Check escape from resistor-only false operating points (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r
for var in ['bg_core', 'bg_core_dn']:
  for name, c in [('tt -40C', dict(temp=-40)), ('ss 3.0V -40C', dict(c='ss', temp=-40, vdd=3.0)), ('res ff -40C', dict(r='res_ff', temp=-40)), ('tt 125C', dict(temp=125))]:
    for ic in ["v(xc.ea)=0.30 v(xc.eb)=0.27 v(xc.g)=1.2 v(xc.vpg)=2.3 v(xc.vpc)=2.0 v(xc.ks)=0", "v(xc.ea)=0.1 v(xc.eb)=0.09 v(xc.g)=1.0 v(xc.vpg)=2.6 v(xc.vpc)=2.4 v(xc.ks)=0"]:
        deck = r.net(var, **c) + f".ic {ic}\n"
        o = r.results(r.ngspice(deck, "tran 1u 2m\nlet ib=abs(i(vs))\nmeas tran i1 find ib at=10u\nmeas tran i2 find ib at=2m\necho R i $&i1 $&i2\n"))
        print(f"{var:11s} {name:13s} ic ea={ic.split()[0][-4:]}: iout at 10us {o['i'][0]*1e6:.3f} uA, at 2 ms {o['i'][1]*1e6:.3f} uA")
EOF
```

</details>

*[Check the slow settling case over a longer transient (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r
c = dict(c='ss', temp=-40, vdd=3.0)
for var in ['bg_core_dn', 'bg_core']:
    deck = r.net(var, **c) + ".ic v(xc.ea)=0.1 v(xc.eb)=0.09 v(xc.g)=1.0 v(xc.vpg)=2.6 v(xc.vpc)=2.4 v(xc.ks)=0\n.option abstol=1e-13\n"
    o = r.results(r.ngspice(deck, "tran 0.2u 10m\nlet ib=abs(i(vs))\n" + ''.join(f"meas tran i{j} find ib at={t}\n" for j, t in enumerate([10e-6, 100e-6, 1e-3, 2e-3, 5e-3, 10e-3])) + "echo R i " + ' '.join(f"$&i{j}" for j in range(6)) + "\n"))
    print(var, [f"{x*1e6:.3f}" for x in o['i']], 'op', f"{r.iout(var, **c)['iout']*1e6:.3f}")
EOF
```

</details>

*[Trace node voltages of the slow-settling DNW case (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r
c = dict(c='ss', temp=-40, vdd=3.0)
var='bg_core_dn'
deck = r.net(var, **c) + ".ic v(xc.ea)=0.1 v(xc.eb)=0.09 v(xc.g)=1.0 v(xc.vpg)=2.6 v(xc.vpc)=2.4 v(xc.ks)=0\n.option abstol=1e-13\n"
nodes=['xc.ea','xc.eb','xc.g','xc.vpg','xc.vpc','xc.ks','xc.e2','xc.cb']
ctl = "tran 0.2u 10m\nlet ib=abs(i(vs))\n"
for j,t in enumerate([10e-6, 1e-3, 5e-3, 7e-3, 9e-3, 10e-3]):
    ctl += f"meas tran i{j} find ib at={t}\n" + ''.join(f"meas tran n{k}_{j} find v({n}) at={t}\n" for k,n in enumerate(nodes))
    ctl += f"echo R t{j} $&i{j} " + ' '.join(f"$&n{k}_{j}" for k in range(len(nodes))) + "\n"
o = r.results(r.ngspice(deck, ctl))
print('         iout ' + ' '.join(f"{n[3:]:>6s}" for n in nodes))
for j,t in enumerate([10e-6, 1e-3, 5e-3, 7e-3, 9e-3, 10e-3]):
    v=o[f't{j}']; print(f"{t*1e3:5.2f}ms {v[0]*1e6:6.3f} " + ' '.join(f"{x:6.3f}" for x in v[1:]))
op = r.iout(var, **c); print('op      ', {k: round(v,3) for k,v in op.items() if k not in ('iout','idd')})
EOF
```

</details>

*[Isolate which initial condition causes the transient current offset (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r
c = dict(c='ss', temp=-40, vdd=3.0)
for var in ['bg_core_dn','bg_core']:
  for ic in ['', '.ic v(xc.ea)=0.1 v(xc.eb)=0.09 v(xc.g)=1.0 v(xc.vpg)=2.6 v(xc.vpc)=2.4 v(xc.ks)=0\n', '.ic v(xc.ks)=0\n', '.ic v(xc.vpc)=2.4\n']:
    deck = r.net(var, **c) + ic + ".option abstol=1e-13\n"
    o = r.results(r.ngspice(deck, "tran 0.2u 2m\nlet ib=abs(i(vs))\nmeas tran i1 find ib at=1m\nmeas tran co find v(xc.co) at=1m\nmeas tran s find v(s) at=1m\necho R i $&i1 $&co $&s\n"))
    op = r.results(r.ngspice(r.net(var, **c), "op\necho R i $&i(vs) $&v(xc.co) $&v(s)\n"))
    print(var, repr(ic[:20]), 'tran', [f"{x:.4g}" for x in o['i']], 'op', [f"{x:.4g}" for x in op['i']])
EOF
```

</details>

*[Repeat the false-operating-point escape test with uic (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r
for var in ['bg_core', 'bg_core_dn']:
  for name, c in [('tt -40C', dict(temp=-40)), ('ss 3.0V -40C', dict(c='ss', temp=-40, vdd=3.0)), ('res ff -40C', dict(r='res_ff', temp=-40)), ('ff 3.6V 125C', dict(c='ff', temp=125, vdd=3.6))]:
    for ic in ["v(xc.ea)=0.30 v(xc.eb)=0.27 v(xc.g)=1.2 v(xc.vpg)=2.3 v(xc.vpc)=2.0 v(xc.ks)=0 v(xc.cb)=3.0 v(xc.ca)=3.0 v(xc.co)=3.0", "v(xc.ea)=0.1 v(xc.eb)=0.09 v(xc.g)=1.0 v(xc.vpg)=2.6 v(xc.vpc)=2.4 v(xc.ks)=0 v(xc.cb)=3.1 v(xc.ca)=3.1 v(xc.co)=3.1"]:
        deck = r.net(var, **c) + f".ic {ic}\n.option abstol=1e-13\n"
        o = r.results(r.ngspice(deck, "tran 0.1u 2m uic\nlet ib=abs(i(vs))\nmeas tran i1 find ib at=10u\nmeas tran i2 find ib at=2m\necho R i $&i1 $&i2\n"))
        print(f"{var:11s} {name:13s} ic ea={ic.split()[0][-4:]}: iout at 10us {o['i'][0]*1e6:.3f} uA, at 2 ms {o['i'][1]*1e6:.3f} uA   (op {r.iout(var, **c)['iout']*1e6:.3f})")
EOF
```

</details>

*[Repeat the escape test with Gear integration (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r
for var in ['bg_core', 'bg_core_dn']:
  for name, c in [('tt -40C', dict(temp=-40)), ('ss 3.0V -40C', dict(c='ss', temp=-40, vdd=3.0)), ('res ff -40C', dict(r='res_ff', temp=-40)), ('ff 3.6V 125C', dict(c='ff', temp=125, vdd=3.6))]:
    for ic in ["v(xc.ea)=0.30 v(xc.eb)=0.27 v(xc.g)=1.2 v(xc.vpg)=2.3 v(xc.vpc)=2.0 v(xc.ks)=0 v(xc.cb)=3.0 v(xc.ca)=3.0 v(xc.co)=3.0", "v(xc.ea)=0.1 v(xc.eb)=0.09 v(xc.g)=1.0 v(xc.vpg)=2.6 v(xc.vpc)=2.4 v(xc.ks)=0 v(xc.cb)=3.1 v(xc.ca)=3.1 v(xc.co)=3.1"]:
        deck = r.net(var, **c) + f".ic {ic}\n.option abstol=1e-13 method=gear\n"
        o = r.results(r.ngspice(deck, "tran 0.1u 2m uic\nlet ib=abs(i(vs))\nmeas tran i1 find ib at=10u\nmeas tran i2 find ib at=2m\necho R i $&i1 $&i2\n"))
        print(f"{var:11s} {name:13s} ic ea={ic.split()[0][-4:]}: iout at 10us {o['i'][0]*1e6:.3f} uA, at 2 ms {o['i'][1]*1e6:.3f} uA   (op {r.iout(var, **c)['iout']*1e6:.3f})")
EOF
```

</details>

*[Run 100-seed mismatch Monte Carlo on both variants (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 run_bg.py mc 2>&1 | grep -v "^$"; python3 run_bg.py var=bg_core_dn mc 2>&1 | grep -v "^$"
```

</details>

*[Identify which devices dominate the mismatch (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && for p in "wp=96u lp=4u nfp=8 wpc=96u lpc=4u nfpc=8" "wn=40u lnn=24u nfn=4" "mq2=8 wp=48u lp=2u nfp=4 wpc=24u lpc=1u nfpc=2"; do echo "## $p"; python3 run_bg.py $p mc 2>&1 | grep mean; done
```

</details>

*[Debug the failed 4x PMOS run (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 run_bg.py wp=96u lp=4u nfp=8 wpc=96u lpc=4u nfpc=8 mc 2>&1 | tail -5; python3 run_bg.py wp=96u lp=4u nfp=8 wpc=96u lpc=4u nfpc=8 corners 2>&1 | head -3
```

</details>

*[Test the PMOS mirror contribution to mismatch (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 run_bg.py wp=48u lp=8u nfp=4 wpc=48u lpc=8u nfpc=4 mc 2>&1 | grep mean; python3 run_bg.py wp=48u lp=8u nfp=4 mc 2>&1 | grep mean
```

</details>

*[Adopt 48/4 mirror devices and recheck mismatch and corners (in the cloud container; 19 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/^\.param wp=48u lp=2u nfp=4 wpc=48u lpc=2u nfpc=4 rc=150u/.param wp=48u lp=4u nfp=4 wpc=48u lpc=2u nfpc=4 rc=150u/' bg_gf.spice && python3 run_bg.py mc corners 2>&1 | grep -v "^$" | head -20 && python3 run_bg.py var=bg_core_dn mc 2>&1 | grep mean
```

</details>

*[Line sensitivity of both variants with the final sizes (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 run_bg.py line 2>&1 | grep -v "^$"; python3 run_bg.py var=bg_core_dn line 2>&1 | grep -v "^$"
```

</details>

*[Separate the body-tie effect from the well-capacitance effect on PSRR (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/^\.param ws1=0.22u ls1=50u/.param ws1=0.22u ls1=50u\n.param apw=360p pjpw=84u adn=1800p pjdn=180u/; s/DPWA ea dnw diode_pw2dw area=360p pj=84u/DPWA ea dnw diode_pw2dw area={apw} pj={pjpw}/; s/DPWB eb dnw diode_pw2dw area=360p pj=84u/DPWB eb dnw diode_pw2dw area={apw} pj={pjpw}/; s/DDNW vss dnw diode_dw2ps area=1800p pj=180u/DDNW vss dnw diode_dw2ps area={adn} pj={pjdn}/' bg_gf.spice && for p in "apw=1p pjpw=1u adn=1p pjdn=1u" "apw=1000p pjpw=140u adn=4000p pjdn=260u"; do echo "## $p"; python3 run_bg.py var=bg_core_dn $p line 2>&1 | grep "tt 27C"; done
```

</details>

*[Simulate substrate-noise sensitivity of both variants (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r, re
# substrate-noise test: node 'sub' = vss + 1 V AC on the substrate connections only (NMOS bulks NA/NB, PNP collectors, DNW anode)
for var in ['bg_core', 'bg_core_dn']:
    s = r.src()
    m = re.search(rf'\.subckt {var} .*?\.ends {var}', s, re.S); body = m.group(0)
    body = body.replace(f'.subckt {var} vdd vss iout', f'.subckt {var}_sub vdd vss sub iout')
    body = body.replace('.ends ' + var, '.ends ' + var + '_sub')
    body = body.replace('XNA g g ea vss', 'XNA g g ea sub').replace('XNB vpc g eb vss', 'XNB vpc g eb sub')
    body = body.replace('XQ1 vss vss ea', 'XQ1 sub vss ea').replace('XQ2 vss vss e2', 'XQ2 sub vss e2')
    body = body.replace('DDNW vss dnw', 'DDNW sub dnw')
    deck = r.header() + s + body + "\nVvdd vdd 0 dc 3.3\nVsub sub 0 dc 0 ac 1\n" + f"Xc vdd 0 sub iout {var}_sub\nVs iout s 0\nXNI s s 0 0 nfet_03v3 W=6u L=6u nf=1\n"
    ctl = "op\nlet i0=abs(i(vs))\nac dec 10 1 1e8\nlet m = mag(i(vs))\n" + ''.join(f"meas ac p{j} find m at={f}\n" for j, f in enumerate([10, 1e3, 1e5, 1e6, 1e7])) + "echo R ac " + ' '.join(f"$&p{j}" for j in range(5)) + "\necho R i0 $&op1.i0\n"
    o = r.results(r.ngspice(deck, ctl))
    print(f"{var:11s} substrate noise -> iout, %/V at 10Hz/1k/100k/1M/10M: " + ' '.join(f"{100*x/o['i0']:.2f}" for x in o['ac']))
EOF
```

</details>

*[Check how LVS treats an NMOS in a deep n-well (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/klayout/tech/lvs && grep -rn "_dn\b\|dnwell" rule_decks/*.lvs gf180mcu.lvs 2>/dev/null | grep -i "nfet\|extract\|dn" | head -12
```

</details>

*[Check MOS extraction inside DNW and the well diodes in LVS (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "dnwell\|_dn" rule_decks/mos_extraction.lvs rule_decks/mos_derivations.lvs 2>/dev/null | head -12; grep -n "lvpwell\|pw2dw\|dw2ps" rule_decks/diode_extraction.lvs | head -6
```

</details>

*[Read the nfet_03v3_dn extraction rule (in the cloud container; 28 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 105,127p rule_decks/mos_extraction.lvs; grep -n "pw2dw\|dw2ps" rule_decks/*.lvs | head -5
```

</details>

*[Informative check with 06v0 devices at 5 V (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/sizing && source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r, re
# informative: 06v0 devices substituted, same sizes, supply 4.5 / 5.0 / 5.5 V (the 1k resistor's 6p0 variant too)
s0 = r.src
def src6(params=''):
    s = s0(params).replace('pfet_03v3', 'pfet_06v0').replace('nfet_03v3', 'nfet_06v0').replace('ppolyf_u_1k ', 'ppolyf_u_1k_6p0 ')
    # keep the load diode 03v3 -> handled in net(); the core only
    return s
r.src = src6
for var in ['bg_core', 'bg_core_dn']:
    print(f"== {var} with 06v0 devices (same sizes), load NI diode 06v0")
    r.net.__defaults__  # noqa
    for name, c in [('tt 5.0V 27C', dict(vdd=5.0)), ('tt 4.5V 27C', dict(vdd=4.5)), ('tt 5.5V 27C', dict(vdd=5.5)), ('tt 5.0V -40C', dict(vdd=5.0, temp=-40)), ('tt 5.0V 125C', dict(vdd=5.0, temp=125)),
                     ('ss 4.5V -40C', dict(c='ss', vdd=4.5, temp=-40)), ('ff 5.5V 125C', dict(c='ff', vdd=5.5, temp=125)), ('tt 3.3V 27C', dict(vdd=3.3))]:
        deck = r.net(var, **c).replace("XNI s s 0 0 nfet_03v3", "XNI s s 0 0 nfet_06v0")
        o = r.results(r.ngspice(deck, "op\necho R iout $&i(vs)\necho R idd $&i(vvdd)\necho R cb $&v(xc.cb)\necho R g $&v(xc.g)\necho R vpg $&v(xc.vpg)\necho R vpc $&v(xc.vpc)\n"))
        print(f"  {name:14s} iout {o['iout']*1e6:7.4f} uA ({100*(o['iout']/5e-6-1):+6.2f} %)  Idd {-o['idd']*1e6:6.2f}  V_SD(PB) {c['vdd']-o['cb']:.3f}  g {o['g']:.3f} vpg {o['vpg']:.3f} vpc {o['vpc']:.3f}")
    lo, mid, hi = (r.results(r.ngspice(r.net(var, vdd=v).replace("XNI s s 0 0 nfet_03v3", "XNI s s 0 0 nfet_06v0"), "op\necho R iout $&i(vs)\n"))['iout'] for v in (4.5, 5.0, 5.5))
    print(f"  line 4.5->5.5 V: {100*(hi-lo)/mid:+.3f} %/V")
EOF
```

</details>

*[Show the ngspice error of the 06v0 substitution (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/sizing && source /home/claude/tools/env.sh && python3 - <<'EOF' 2>&1 | tail -15
import run_bg as r
s0 = r.src
r.src = lambda params='': s0(params).replace('pfet_03v3', 'pfet_06v0').replace('nfet_03v3', 'nfet_06v0').replace('ppolyf_u_1k ', 'ppolyf_u_1k_6p0 ')
deck = r.net('bg_core', vdd=5.0).replace("XNI s s 0 0 nfet_03v3", "XNI s s 0 0 nfet_06v0")
print(r.ngspice(deck, "op\necho R iout $&i(vs)\n")[-1500:])
EOF
```

</details>

*[Informative 5 V check with 06v0 devices (MS1 widened to the 06v0 minimum) (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && grep -n "^\.model pfet_06v0\|^\.model nfet_06v0" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | head -3; n=$(grep -n "^\.model pfet_06v0" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | head -1 | cut -d: -f1); sed -n "${n},$((n+1))p" /home/claude/pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice | cut -c1-200; python3 - <<'EOF'
import run_bg as r
s0 = r.src
r.src = lambda params='': s0(params).replace('pfet_03v3', 'pfet_06v0').replace('nfet_03v3', 'nfet_06v0').replace('ppolyf_u_1k ', 'ppolyf_u_1k_6p0 ')
p = ".param ws1=0.3u ls1=50u\n"
for var in ['bg_core', 'bg_core_dn']:
    print(f"== {var} with 06v0 devices (same sizes, MS1 0.3/50), load NI diode 06v0")
    for name, c in [('tt 5.0V 27C', dict(vdd=5.0)), ('tt 4.5V 27C', dict(vdd=4.5)), ('tt 5.5V 27C', dict(vdd=5.5)), ('tt 5.0V -40C', dict(vdd=5.0, temp=-40)), ('tt 5.0V 125C', dict(vdd=5.0, temp=125)),
                     ('ss 4.5V -40C', dict(c='ss', vdd=4.5, temp=-40)), ('ff 5.5V 125C', dict(c='ff', vdd=5.5, temp=125)), ('tt 3.3V 27C', dict(vdd=3.3))]:
        deck = r.net(var, params=p, **c).replace("XNI s s 0 0 nfet_03v3", "XNI s s 0 0 nfet_06v0")
        o = r.results(r.ngspice(deck, "op\necho R iout $&i(vs)\necho R idd $&i(vvdd)\necho R cb $&v(xc.cb)\necho R g $&v(xc.g)\necho R vpg $&v(xc.vpg)\necho R vpc $&v(xc.vpc)\n"))
        print(f"  {name:14s} iout {o['iout']*1e6:7.4f} uA ({100*(o['iout']/5e-6-1):+6.2f} %)  Idd {-o['idd']*1e6:6.2f}  V_SD(PB) {c['vdd']-o['cb']:.3f}  g {o['g']:.3f} vpg {o['vpg']:.3f} vpc {o['vpc']:.3f}")
    lo, mid, hi = (r.results(r.ngspice(r.net(var, vdd=v, params=p).replace("XNI s s 0 0 nfet_03v3", "XNI s s 0 0 nfet_06v0"), "op\necho R iout $&i(vs)\n"))['iout'] for v in (4.5, 5.0, 5.5))
    print(f"  line 4.5->5.5 V: {100*(hi-lo)/mid:+.3f} %/V")
EOF
```

</details>

*[Compare the ClassABDriverBiased rerun with the stored results (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABDriver/verification/cace && tail -2 /home/claude/work/logs/cace_ClassABDriverBiased_rerun.out; ls _runs/ && python3 - <<'EOF'
import glob
def parse(f):
    d={}
    for l in open(f):
        if l.startswith('|') and 'ngspice' in l:
            t=[x.strip() for x in l.strip('|\n').split('|')]
            d[t[0]]=(t[4],t[6],t[8])
    return d
a=parse('results/ClassABDriverBiased/summary.md'); new=sorted(glob.glob('_runs/RUN_*/summary.md'))[-1]; b=parse(new)
diff=0
for k in a:
    if a[k]!=b.get(k): diff+=1; print(f"DIFF {k:28s} old {a[k]}  new {b.get(k)}")
print(len(a), 'params,', diff, 'differ;', new)
EOF
```

</details>

Both reruns agree with the 2026-10-08 numbers (DC identical; transient step metrics differ in the last digit — ngspice-42 → 47). Writing the running log now, before going further.

*[Set task 2 to completed.  
Set task 3 to completed.  
Set task 4 to in_progress.  
Wrote 2026-10-08_fable_reference_redesign_log.md (in the cloud container; 1 lines of output).]*

*[SendUserMessage, shown to the user verbatim:]*

**Checkpoint after sizing (cloud harness, no sheets yet).** Toolchain built; the CACE reruns of `ClassABBiasIn` (identical) and `ClassABDriverBiased` (3 transient values differ in the last digit, ngspice 42→47) are done.

The IHP core transliterated does not work in GF180: at ss/3.0 V/−40 °C the stacked-diode PMOS cascode (2 × V_SG ≈ 2 V) leaves NB no headroom. Changes: self-biased wide-swing cascode (a 150 kΩ resistor between the mirror and cascode gate lines, diode connection around the cascode), start-up pulls vpg, NMOS pair 20/12, mirror 48/4, resistors `ppolyf_u_1k` (the 3k's tc2 alone bends the current −3.7 % at 125 °C and fails ±3 %; 1k gives a 2.1 % band). Results at tt: 5.05 µA, −40…125 °C −0.8…+1.1 %, MOS/BJT corners within +2 %, resistor corners −16/+27 % (R_sh ±20 %, no way round without trim), line 0.42 %/V, σ 1.05 % (100 seeds, MOS+PNP — the PDK has no resistor mismatch model), start-up OK at 10 corners for 1 µs and 1 ms ramps, no false state; I_dd 10.5 µA.

**Deep n-well:** gf180mcuD has no separate DNW NMOS model — it is `nfet_03v3` with the bulk on the isolated p-well plus `diode_pw2dw`/`diode_dw2ps`. The variant (bulk = source) gives: DC line sensitivity **worse** (0.42 → 0.62 %/V, the body effect's g_mb helps the pair), AC-from-vdd not robustly different (depends on the well capacitance), **substrate noise to the pair essentially eliminated** (0.16 → 0.01 %/V at DC, 13.5 → 0.01 %/V at 100 kHz in an idealised test), σ 1.15 vs 1.05 %, and about +500–700 µm² (≈ +15 % of the core) from the DNW enclosure, N-well ring, guard ring and the 3.1 µm keep-out.

At 5 V with 06v0 devices substituted the topology works (+2.8 %, 1.2 %/V, would need re-centring and a longer NB).

I'll continue with the standard (non-DNW) variant as `ClassABBiasBG` for the sheets and CACE, and keep the DNW netlist in the tools folder — unless you want the DNW variant drawn too (say so and I'll add `ClassABBiasBGdn`). Log so far is drafted and will be delivered with the files.

*[Read the port script used for the class-AB sheets (in the cloud container; 80 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work && sed -n 1,80p gf180_cm_ip__single2diff2single/macros/ClassABDriver/scripts/port_classab_from_ihp.py
```

</details>

*[Read the rest of the port script (in the cloud container; 111 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 80,260p gf180_cm_ip__single2diff2single/macros/ClassABDriver/scripts/port_classab_from_ihp.py
```

</details>

*[Inspect the IHP bandgap sheet and the generator scripts (in the cloud container; 62 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem && ls scripts; wc -l scripts/*.py; grep -c . d2s_bias_bg.sch; grep -n "^C " d2s_bias_bg.sch | grep -v "lab_pin\|ipin\|opin\|iopin" | head -60
```

</details>

*[Read the xsheet drawing helper (in the cloud container; 80 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 1,80p scripts/xsheet.py
```

</details>

*[Read the rest of the xsheet helper (in the cloud container; 153 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 80,232p scripts/xsheet.py
```

</details>

*[Read pin geometry and netlist formats of the GF180 symbols (in the cloud container; 38 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols && for s in pfet_03v3 nfet_03v3 ppolyf_u_1k pnp_05p00x05p00 diode_pw2dw diode_dw2ps; do echo "== $s"; grep "^B 5\|format=\|template=" $s.sym | head -12; done 2>&1 | cut -c1-230
```

</details>

*[Read the PadEnable generator for its drawing conventions (in the cloud container; 109 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/PadEnable && cat scripts/gen_padenable.py | head -150
```

</details>

There's already a GF180 `scripts/xsheet.py` in the repo (the one `gen_padenable.py` imports). Let me read it — it's the right tool for both the core sheet and `RefCoreEnable`.

*[Read the repo's GF180 xsheet helper (in the cloud container; 149 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single && ls scripts; cat scripts/xsheet.py
```

</details>

*[Read the round-trip checker (in the cloud container; 65 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 1,60p macros/ClassABDriver/scripts/check_classab_port.py; grep -n "def \|argv" macros/ClassABDriver/scripts/check_classab_port.py | head -30
```

</details>

*[Read the rest of the checker (in the cloud container; 19 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 60,80p macros/ClassABDriver/scripts/check_classab_port.py
```

</details>

*[Request interrupted by user]*

## Turn 3 — 2026-10-09 00:02

**User:**

AVOID POLY RESISTORS!

**Assistant:**

*[List non-poly resistor models and symbols in the PDK (in the cloud container; refused by the user).]*

<details><summary>command</summary>

```sh
cd /home/claude/pdk/gf180mcuD/libs.tech/ngspice && grep -n "^\.param rsh_" sm141064.ngspice | sed -n 1,20p; grep -n "^\.subckt nwell\|^\.subckt nplus\|^\.subckt pplus\|^\.subckt npolyf_s\|^\.subckt ppolyf_s" sm141064.ngspice | head; ls /home/claude/pdk/gf180mcuD/libs.tech/xschem/symbols | grep -i "nwell\|plus\|_s\.sym"
```

</details>

*[Request interrupted by user for tool use]*

## Turn 4 — 2026-10-09 00:03

**User:**

Rescind the last order ... you're designing the bandgap, so resistors are inevitable. Poly resistors are ok. Save area if you can.

**Assistant:**

*[Re-tune the PTAT share for the 3k resistor with the band centred on 5 uA (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/sizing && source /home/claude/tools/env.sh && sed -i 's/ppolyf_u_1k/ppolyf_u_3k/g' bg_gf.spice run_bg.py && sed -i 's/^\.param rw=1u r1a=420u r1b=382u r0=67.5u/.param rw=1u r1a=120u r1b=109u r0=33u/; s/rc=150u/rc=50u/' bg_gf.spice && python3 - <<'EOF'
import run_bg as r, numpy as np
def run(r1b, r0):
    p = f".param r1b={r1b:.2f}u r1a={1.1*r1b:.2f}u r0={r0:.2f}u\n"
    return np.array([r.iout('bg_core', temp=t, params=p)['iout'] for t in r.TEMPS])
for xp in [0.20, 0.21, 0.22, 0.23, 0.24]:
    ip, ic = xp*2.5e-6, (1-xp)*2.5e-6
    l0 = 0.0537/ip/3000; l1 = 0.662/ic/3000
    i = run(l1*1e6, l0*1e6); mid = (i.max()+i.min())/2; k = mid/5e-6
    i = run(l1*k*1e6, l0*k*1e6)
    print(f"xp {xp:.2f} R1B {l1*k*1e6:6.1f}u R0 {l0*k*1e6:5.1f}u  " + ' '.join(f"{100*(x/5e-6-1):+5.2f}" for x in i) + f"  band {100*(i.max()-i.min())/5e-6:.2f} %")
EOF
```

</details>

Unit slip (µ twice). Fixing.

*[Re-tune the PTAT share for the 3k resistor, band centred on 5 uA (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r, numpy as np
def run(r1b, r0):
    p = f".param r1b={r1b:.2f}u r1a={1.1*r1b:.2f}u r0={r0:.2f}u\n"
    return np.array([r.iout('bg_core', temp=t, params=p)['iout'] for t in r.TEMPS])
for xp in [0.20, 0.21, 0.22, 0.23, 0.24]:
    ip, ic = xp*2.5e-6, (1-xp)*2.5e-6
    l0 = 0.0537/ip/3000*1e6; l1 = 0.662/ic/3000*1e6
    i = run(l1, l0); mid = (i.max()+i.min())/2; k = mid/5e-6
    i = run(l1*k, l0*k)
    print(f"xp {xp:.2f} R1B {l1*k:6.1f}u R0 {l0*k:5.1f}u  " + ' '.join(f"{100*(x/5e-6-1):+5.2f}" for x in i) + f"  band {100*(i.max()-i.min())/5e-6:.2f} %")
EOF
```

</details>

*[Re-tune the PTAT share for the 3k resistor, band centred on 5 uA (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF'
import run_bg as r, numpy as np
def run(r1b, r0):
    p = f".param r1b={r1b:.2f}u r1a={1.1*r1b:.2f}u r0={r0:.2f}u\n"
    return np.array([r.iout('bg_core', temp=t, params=p)['iout'] for t in r.TEMPS])
for xp in [0.20, 0.21, 0.22, 0.23, 0.24]:
    ip, ic = xp*2.5e-6, (1-xp)*2.5e-6
    l0 = 0.0537/ip/3000; l1 = 0.662/ic/3000
    i = run(l1, l0); mid = (i.max()+i.min())/2; k = mid/5e-6
    i = run(l1*k, l0*k)
    print(f"xp {xp:.2f} R1B {l1*k:6.1f}u R0 {l0*k:5.1f}u  " + ' '.join(f"{100*(x/5e-6-1):+5.2f}" for x in i) + f"  band {100*(i.max()-i.min())/5e-6:.2f} %")
EOF
```

</details>

*[Check the 3k sizing over all MOS corners, supplies and temperatures (in the cloud container; 26 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's/^\.param rw=1u r1a=120u r1b=109u r0=33u/.param rw=1u r1a=118.1u r1b=107.4u r0=32.8u/' bg_gf.spice && python3 run_bg.py temp 2>&1 | grep -v "^$" && python3 - <<'EOF'
import run_bg as r
print("all MOS corners x vdd x temp, % of 5 uA (3k resistors):")
worst=[]
for c in ['typical','ss','ff','sf','fs']:
    for vdd in (3.0,3.3,3.6):
        row=[]
        for t in (-40,27,125):
            i=r.iout('bg_core', c=c, vdd=vdd, temp=t)['iout']; row.append(100*(i/5e-6-1)); worst.append((row[-1],c,vdd,t))
        print(f"  {c:8s} {vdd} V: " + ' '.join(f"{x:+6.2f}" for x in row))
print("min", min(worst), "max", max(worst))
EOF
```

</details>

*[Full sizing check of the 3k version, both variants (in the cloud container; 37 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 run_bg.py corners mc line startup 2>&1 | grep -v "^$" > /home/claude/work/logs/sizing_3k_bg_core.txt; python3 run_bg.py var=bg_core_dn corners mc line 2>&1 | grep -v "^$" > /home/claude/work/logs/sizing_3k_bg_core_dn.txt; grep -v "^  tt 27C  \|^  ss 27C\|^  ff 27C\|^  sf\|^  fs 27" /home/claude/work/logs/sizing_3k_bg_core.txt | head -40; grep "mean\|dc " /home/claude/work/logs/sizing_3k_bg_core_dn.txt
```

</details>

*[Extend the round-trip checker to 1k resistors and PNPs (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABDriver/scripts && python3 - <<'EOF'
s = open('check_classab_port.py').read()
s = s.replace("mods = [x for x in t if x in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k')]",
              "mods = [x for x in t if x in MODELS]")
s = s.replace("FLATTEN = {'d2s_bias_diodes'}",
              "FLATTEN = {'d2s_bias_diodes'}\nMODELS = ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k', 'ppolyf_u_1k', 'pnp_05p00x05p00', 'pnp_10p00x10p00')  # 2026-10-09: + 1k, PNPs")
s = s.replace("if a[1] == 'ppolyf_u_3k' and a[0] == 'dev' and pa[:2] != pb[:2] and pa[:2] == pb[1::-1]:",
              "if a[1].startswith('ppolyf') and a[0] == 'dev' and pa[:2] != pb[:2] and pa[:2] == pb[1::-1]:")
s = s.replace("ka = {'W': 'W', 'L': 'L', 'nf': 'nf', 'm': 'm'} if a[1] != 'ppolyf_u_3k' else {'r_width': 'r_width', 'r_length': 'r_length'}",
              "ka = ({'r_width': 'r_width', 'r_length': 'r_length'} if a[1].startswith('ppolyf') else {'m': 'm'} if a[1].startswith('pnp') else {'W': 'W', 'L': 'L', 'nf': 'nf', 'm': 'm'})")
open('check_classab_port.py','w').write(s)
EOF
grep -n "MODELS\|startswith" check_classab_port.py
```

</details>

*[Add RefCoreEnable to the PadEnable generator and write only that cell (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/PadEnable && python3 - <<'EOF'
s = open('scripts/gen_padenable.py').read()
s = s.replace('''  InputEnable    transmission gate pin -> pout (enabled); disabled: pout parked on vpark by a second gate
''', '''  InputEnable    transmission gate pin -> pout (enabled); disabled: pout parked on vpark by a second gate
  RefCoreEnable  (2026-10-09) disable switches of a self-biased reference core (ClassABBiasBG): vpg -> vdd, ks -> vss
''')
s = s.replace('Usage: gen_padenable.py <PadEnable/schematic/xschem>"""', 'Usage: gen_padenable.py <PadEnable/schematic/xschem> [cell ...]   (2026-10-09: names select cells; RefCoreEnable only was written that day)"""')
s = s.replace('''if __name__ == "__main__":
    d = sys.argv[1]
    for f in (enable_inv, driver_enable, bias_ref_enable, input_enable):
        print(f.__name__, f(d))''', '''def ref_core_enable(d):
    order = ["vdd", "vss", "en", "en_b", "vpg", "ks"]
    pins = symbol(f"{d}/RefCoreEnable.sym", left=[("en", "in"), ("en_b", "in")], right=[("vpg", "inout"), ("ks", "inout")],
                  top=[("vdd", "inout")], bottom=[("vss", "inout")], order=order)
    s = Sheet()
    title(s, "RefCoreEnable", ["Disable switches of a self-biased reference core (ClassABBiasBG), on while en = 0:",
                               "SPG: vpg (PMOS mirror gate line) to vdd -- every mirror branch off, iout = 0;",
                               "SKS: ks (start-up node) to vss -- otherwise ks floats with MS1 off and MS3 would pull vpg.",
                               "The core's always-on start-up pull-up MS1 has its gate on en_b (off while disabled)."])
    s.wire(60, -300, 400, -300, "vdd"); s.wire(60, 0, 400, 0, "vss")
    s.pin("iopin", 60, -300, "vdd", right=True); s.pin("iopin", 60, 0, "vss", right=True)
    s.pin("ipin", 60, -180, "en"); s.pin("ipin", 60, -140, "en_b")
    s.pin("iopin", 480, -220, "vpg"); s.pin("iopin", 480, -60, "ks")
    s.fet("p", "SPG", 200, -220, "vpg", "en", "vdd", "vdd", top_rail=-300, **SW)
    s.fet("n", "SKS", 200, -60, "ks", "en_b", "vss", "vss", bot_rail=0, **SW)
    s.write(f"{d}/RefCoreEnable.sch", title=True)
    return pins

if __name__ == "__main__":
    d = sys.argv[1]
    fs = {f.__name__: f for f in (enable_inv, driver_enable, bias_ref_enable, input_enable, ref_core_enable)}
    sel = sys.argv[2:] or list(fs)
    for n in sel:
        print(n, fs[n](d))''')
s = s.replace('s.text("GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on 2026-10-08, edit the sheet from now on.", 60, 120, 0.2, 4)',
 's.text(f"GF180MCU (gf180mcuD), 03v3 devices; written by ../../scripts/gen_padenable.py on {DATE}, edit the sheet from now on.", 60, 120, 0.2, 4)')
s = s.replace('TG = dict(W="4u", L="0.5u")', 'TG = dict(W="4u", L="0.5u")\nDATE = "2026-10-08"')
s = s.replace('def ref_core_enable(d):\n', 'def ref_core_enable(d):\n    global DATE; DATE = "2026-10-09"\n')
open('scripts/gen_padenable.py','w').write(s)
EOF
cat >> scripts/padenable_reference.spice <<'EOF'
* 2026-10-09: disable switches of the self-biased reference core ClassABBiasBG
.subckt RefCoreEnable vdd vss en en_b vpg ks
XSPG vpg en vdd vdd pfet_03v3 W=1u L=0.5u nf=1
XSKS ks en_b vss vss nfet_03v3 W=1u L=0.5u nf=1
.ends
EOF
source /home/claude/tools/env.sh; python3 scripts/gen_padenable.py schematic/xschem ref_core_enable && ls -la schematic/xschem/ | head -20
```

</details>

Now the core generator `gen_bg.py` (sheet, symbol, reference netlist) in `macros/ClassABBias/scripts/`.

*[Wrote gen_bg.py (in the cloud container; 1 lines of output).]*

*[Write the reference netlist and generate both core sheets (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/scripts && python3 - <<'EOF'
s = open('gen_bg.py').read()
s = s.replace('''        m, kv = S["DPWA"]; s.diode("DPWA", m, 1140, -420, "ea", "dnw", kv["r_w"], kv["r_l"])
        m, kv = S["DPWB"]; s.diode("DPWB", m, 1240, -420, "eb", "dnw", kv["r_w"], kv["r_l"])
        m, kv = S["DDNW"]; s.diode("DDNW", m, 1140, -260, "vss", "dnw", kv["r_w"], kv["r_l"])
        s.wire(1240, -180, 1240, -140, "dnw"); s.label(1240, -140, "dnw", right=True)
        s.wire(1240, -180, 1300, -180, "dnw"); s.wire(1300, -180, 1300, top, "vdd")  # DNW tied to vdd
        s.recs = [r for r in s.recs if not r.endswith("lab=vdd}}") or "1300" not in r]
''', '''        s.text("(deep n-well on vdd)", 1100, -500, 0.2)
        m, kv = S["DPWA"]; s.diode("DPWA", m, 1140, -420, "ea", "vdd", kv["r_w"], kv["r_l"])
        m, kv = S["DPWB"]; s.diode("DPWB", m, 1240, -420, "eb", "vdd", kv["r_w"], kv["r_l"])
        m, kv = S["DDNW"]; s.diode("DDNW", m, 1140, -260, "vss", "vdd", kv["r_w"], kv["r_l"])
''')
open('gen_bg.py','w').write(s)
EOF
cat > bg_reference.spice <<'EOF'
* ClassABBiasBG reference netlists (GF180MCU gf180mcuD, 03v3), 2026-10-09: GF180 re-design of the IHP bg_core.
* Sizing and results: notes worktree, kickoffs/2026-10-08_reference_redesign/tools/bg_gf.spice + run_bg.py,
* logs/main/2026-10-08_fable_reference_redesign_log.md. Round trip: ../../ClassABDriver/scripts/check_classab_port.py.
* Ports: vdd vss iout en en_b (en active high; en_b from PadEnable/EnableInv). iout: 5 uA OUT of the pin.
.subckt ClassABBiasBG vdd vss iout en en_b
XPB cb vpg vdd vdd pfet_03v3 W=48u L=4u nf=4
XPBC vpg vpc cb vdd pfet_03v3 W=48u L=2u nf=4
XPA ca vpg vdd vdd pfet_03v3 W=48u L=4u nf=4
XPAC g vpc ca vdd pfet_03v3 W=48u L=2u nf=4
XPO co vpg vdd vdd pfet_03v3 W=96u L=4u nf=8
XPOC iout vpc co vdd pfet_03v3 W=96u L=2u nf=8
XRC vpg vpc vss ppolyf_u_3k r_width=1u r_length=50u
XNA g g ea vss nfet_03v3 W=20u L=12u nf=2
XNB vpc g eb vss nfet_03v3 W=20u L=12u nf=2
XQ1 vss vss ea pnp_05p00x05p00 m=1
XR1A ea vss vss ppolyf_u_3k r_width=1u r_length=118.1u
XR0 eb e2 vss ppolyf_u_3k r_width=1u r_length=32.8u
XQ2 vss vss e2 pnp_05p00x05p00 m=8
XR1B eb vss vss ppolyf_u_3k r_width=1u r_length=107.4u
XMS1 ks en_b vdd vdd pfet_03v3 W=0.22u L=50u nf=1
XMS2 ks g vss vss nfet_03v3 W=10u L=1u nf=1
XMS3 vpg ks vss vss nfet_03v3 W=0.5u L=2u nf=1
XE vdd vss en en_b vpg ks RefCoreEnable
.ends ClassABBiasBG

* Deep-n-well variant: NA / NB in isolated p-wells (bulk = source) inside one DNW on vdd; well junctions with
* estimated areas (each p-well 30 x 12 um, the DNW 60 x 30 um).
.subckt ClassABBiasBGdn vdd vss iout en en_b
XPB cb vpg vdd vdd pfet_03v3 W=48u L=4u nf=4
XPBC vpg vpc cb vdd pfet_03v3 W=48u L=2u nf=4
XPA ca vpg vdd vdd pfet_03v3 W=48u L=4u nf=4
XPAC g vpc ca vdd pfet_03v3 W=48u L=2u nf=4
XPO co vpg vdd vdd pfet_03v3 W=96u L=4u nf=8
XPOC iout vpc co vdd pfet_03v3 W=96u L=2u nf=8
XRC vpg vpc vss ppolyf_u_3k r_width=1u r_length=50u
XNA g g ea ea nfet_03v3 W=20u L=12u nf=2
XNB vpc g eb eb nfet_03v3 W=20u L=12u nf=2
DPWA ea vdd diode_pw2dw r_w=12u r_l=30u
DPWB eb vdd diode_pw2dw r_w=12u r_l=30u
DDNW vss vdd diode_dw2ps r_w=30u r_l=60u
XQ1 vss vss ea pnp_05p00x05p00 m=1
XR1A ea vss vss ppolyf_u_3k r_width=1u r_length=118.1u
XR0 eb e2 vss ppolyf_u_3k r_width=1u r_length=32.8u
XQ2 vss vss e2 pnp_05p00x05p00 m=8
XR1B eb vss vss ppolyf_u_3k r_width=1u r_length=107.4u
XMS1 ks en_b vdd vdd pfet_03v3 W=0.22u L=50u nf=1
XMS2 ks g vss vss nfet_03v3 W=10u L=1u nf=1
XMS3 vpg ks vss vss nfet_03v3 W=0.5u L=2u nf=1
XE vdd vss en en_b vpg ks RefCoreEnable
.ends ClassABBiasBGdn
EOF
source /home/claude/tools/env.sh; cd ../schematic/xschem && python3 ../../scripts/gen_bg.py . && python3 ../../scripts/gen_bg.py . dn && ls
```

</details>

*[Generate the sheets and netlist them with xschem (in the cloud container; 52 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && sed -i "s/            tab\[t\[0\]\[1:\]\] = (pos\[-1\], kv)/            tab[t[0][1:] if t[0][0] in 'Xx' else t[0]] = (pos[-1], kv)/" scripts/gen_bg.py && source /home/claude/tools/env.sh && cd schematic/xschem && python3 ../../scripts/gen_bg.py . dn && ls && xschem --rcfile xschemrc -n -s -q -x -o /tmp/bgnet ClassABBiasBG.sch 2>&1 | tail -3; xschem --rcfile xschemrc -n -s -q -x -o /tmp/bgnet ClassABBiasBGdn.sch 2>&1 | tail -2; ls /tmp/bgnet; cat /tmp/bgnet/ClassABBiasBG.spice
```

</details>

*[Add the PadEnable library path and run the round-trip check on both cells (in the cloud container; 14 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && grep -n "append_xschem_library_path_unique \[" xschemrc && python3 - <<'EOF'
s=open('xschemrc').read()
s=s.replace("append_xschem_library_path_unique [file join [file dirname [info script]] ../../testbenches/xschem]\n",
"append_xschem_library_path_unique [file join [file dirname [info script]] ../../testbenches/xschem]\n# 2026-10-09: ClassABBiasBG instantiates PadEnable/RefCoreEnable\nappend_xschem_library_path_unique [file join [file dirname [info script]] ../../../PadEnable/schematic/xschem]\n")
open('xschemrc','w').write(s)
EOF
for c in ClassABBiasBG ClassABBiasBGdn; do xschem --rcfile xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/bgnet $c.sch 2>&1 | grep -i "missing\|error"; python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/bg_reference.spice /tmp/bgnet/$c.spice $c $c; done; grep "RefCoreEnable\|^D" /tmp/bgnet/ClassABBiasBGdn.spice
```

</details>

*[Include diodes in the check, sanity-check with deliberate errors, and check RefCoreEnable (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros && source /home/claude/tools/env.sh && sed -i "s/        elif t\[0\]\[0\] in 'VvIiRrCc':/        elif t[0][0] in 'VvIiRrCcDd':/" ClassABDriver/scripts/check_classab_port.py && cd ClassABBias/schematic/xschem && python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/bg_reference.spice /tmp/bgnet/ClassABBiasBGdn.spice ClassABBiasBGdn ClassABBiasBGdn; sed 's/XNB vpc g eb vss/XNB vpc vpg eb vss/; s/r_length=32.8u/r_length=33u/' /tmp/bgnet/ClassABBiasBG.spice > /tmp/bgnet/bad.spice; python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/bg_reference.spice /tmp/bgnet/bad.spice ClassABBiasBG ClassABBiasBG; cd ../../../PadEnable/schematic/xschem && xschem --rcfile xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/bgnet RefCoreEnable.sch 2>&1 | grep -i "missing\|error"; python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/padenable_reference.spice /tmp/bgnet/RefCoreEnable.spice RefCoreEnable RefCoreEnable
```

</details>

*[Render the generated sheet to an image for inspection (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/schematic/xschem && source /home/claude/tools/env.sh && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq librsvg2-bin >/dev/null 2>&1; xvfb-run -a xschem --rcfile xschemrc -q -x --tcl "xschem load ClassABBiasBG.sch; xschem zoom_full; xschem print svg /tmp/bg.svg; exit" 2>&1 | tail -2; ls -la /tmp/bg.svg && rsvg-convert -w 2000 /tmp/bg.svg -o /tmp/bg.png && echo ok
```

</details>

*[Try xschem's script mode for the SVG export (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/schematic/xschem && source /home/claude/tools/env.sh && cat > /tmp/print.tcl <<'EOF'
xschem load [lindex $argv 0]
xschem zoom_full
xschem print svg /tmp/bg.svg
exit
EOF
xvfb-run -a xschem --rcfile xschemrc --script /tmp/print.tcl ClassABBiasBG.sch 2>&1 | tail -3; ls -la /tmp/bg.svg; grep -n "print svg\|print png" /home/claude/work/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem/scripts/export_figures.py | head -5
```

</details>

*[Read how the IHP figure exporter drives xschem (in the cloud container; error).]*

<details><summary>command</summary>

```sh
pkill -f xschem; pkill -f Xvfb; sed -n 1,60p /home/claude/work/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem/scripts/export_figures.py | grep -v "^#" | head -50
```

</details>

*[Find the xschem invocation in the figure exporter (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "xschem\b.*\[\|subprocess\|--tcl\|print" /home/claude/work/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem/scripts/export_figures.py | head -20
```

</details>

*[Read the exporter's xschem call in full (in the cloud container; 31 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 60,90p /home/claude/work/sg13cmos5l_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/design_considerations/class_ab_pad_driver/improvements/xschem/scripts/export_figures.py
```

</details>

*[Export the sheet as SVG with explicit print area, no X server (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/schematic/xschem && source /home/claude/tools/env.sh && printf 'xschem load %s\nxschem print svg /tmp/bg.svg 1400 1500 0 -1250 1400 250\nexit\n' "$PWD/ClassABBiasBG.sch" > /tmp/print.tcl && timeout 60 xschem --rcfile xschemrc -q -x --script /tmp/print.tcl 2>&1 | tail -2; ls -la /tmp/bg.svg && rsvg-convert -w 2200 /tmp/bg.svg -o /tmp/bg.png && echo ok
```

</details>

*[Read bg.png (in the cloud container; image shown to the assistant).]*

Readable enough; two cosmetic collisions (R0's bulk label over R1B, the Q2 note over its name). Fixing those, then the CACE suite.

*[Regenerate the sheets with the label fixes and re-check (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && source /home/claude/tools/env.sh && sed -i 's/s.res("R0", m, xb + 80, -300, "eb", "e2", "vss", w, l)/s.res("R0", m, xb + 120, -300, "eb", "e2", "vss", w, l)/; s/s.text("Q2 = 8 x Q1 (m=8)", xb + 100, -130, 0.2)/s.text("Q2 = 8 x Q1 (m=8)", xb + 100, -40, 0.2)/' scripts/gen_bg.py && cd schematic/xschem && python3 ../../scripts/gen_bg.py . >/dev/null && python3 ../../scripts/gen_bg.py . dn >/dev/null && for c in ClassABBiasBG ClassABBiasBGdn; do xschem --rcfile xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/bgnet $c.sch 2>&1 | grep -i "missing"; python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/bg_reference.spice /tmp/bgnet/$c.spice $c $c | tail -1; done
```

</details>

*[Set task 4 to completed.  
Set task 5 to completed.  
Set task 6 to in_progress.]*

Now CACE. Let me see how `gen_cace.py` builds the existing ClassABBias templates so the new suite matches.

*[Read the existing CACE generator (in the cloud container; 200 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && sed -n 1,200p scripts/gen_cace.py
```

</details>

*[Wrote gen_cace_bg.py (in the cloud container; 1 lines of output).]*

*[Fix the include, generate the CACE files (in the cloud container; 40 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && sed -i 's|esc(".include CACE{DUT_path}\\n.include CACE{root_path}/../../PadEnable/schematic/xschem/simulations/RefCoreEnable.spice\\n"|esc(".include CACE{DUT_path}\\n"|' scripts/gen_cace_bg.py && grep -n "DUT_path" scripts/gen_cace_bg.py && cat verification/cace/templates/xschemrc | grep -v "^#" | grep -v "^$" | head; python3 scripts/gen_cace_bg.py . && ls verification/cace verification/cace/templates
```

</details>

*[Run the dc and line parameters of the BG CACE suite (in the cloud container; 30 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && source /home/claude/tools/env.sh && (time cace ClassABBiasBG.yaml -s schematic --nofail -j 2 --parallel-parameters 1 -p dc_params line_params > /home/claude/work/logs/cace_BG_1.out 2>&1); grep -i "error\|fail" /home/claude/work/logs/cace_BG_1.out | grep -v "nofail" | head; r=$(ls -td _runs/RUN_* | head -1); grep "ngspice" $r/summary.md
```

</details>

*[Run both full CACE suites in the background (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && nohup sh -c "cace ClassABBiasBG.yaml -s schematic --nofail -j 2 --parallel-parameters 1 > /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out 2>&1; cace ClassABBiasBGdn.yaml -s schematic --nofail -j 2 --parallel-parameters 1 > /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBGdn.out 2>&1" > /dev/null 2>&1 &
echo started
```

</details>

While CACE runs, the last kickoff step: the driver with the real reference over PVT (plain ngspice, as the IHP `corners` section).

*[Inspect the driver harness (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/sizing && grep -n "def \|INST\|FILES\|CORN" run_gf.py | head -30
```

</details>

*[Read the driver harness (in the cloud container; 99 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 1,100p run_gf.py
```

</details>

*[Driver with ideal, external and bandgap bias over PVT (in the cloud container; 59 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF' 2>&1 | tee /home/claude/work/logs/driver_with_bg.txt
import run_gf as g
extra = f".include {g.HERE}/bias_ref_gf.spice\n.include {g.HERE}/bg_gf.spice\n.lib {g.PDK}/sm141064.ngspice bjt_typical\n.lib {g.PDK}/sm141064.ngspice diode_typical\n"
B = {'ideal': 'lp', 'in': "Iref 0 iref 5u\nXb vdd 0 vddo vsso iref vbp vbn vbpc vbnc vabp vabn d2s_bias_in",
     'bg': "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bg", 'bgdn': "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bgdn"}
print("ClassABDriver (d2s_mpdda GF180) with each bias, 1k || 100p, over PVT")
for c, t, v in [("typical", 27, 3.3), ("typical", -40, 3.3), ("typical", 125, 3.3), ("ss", -40, 3.0), ("ff", 125, 3.6), ("ss", 125, 3.0), ("ff", -40, 3.6)]:
    for b in ['ideal', 'in', 'bg', 'bgdn']:
        r = g.run(corner=c, temp=t, vdd=v, bias=B[b], extra=extra)
        print(f"{c:7s} {t:4d} {v} {b:5s} " + g.fmt(r))
# resistor corners with the bandgap
for rc in ['res_ss', 'res_ff']:
    r = g.run(bias=B['bg'], extra=extra.replace('bjt_typical', 'bjt_typical') + f".lib {g.PDK}/sm141064.ngspice {rc}\n")
    print(f"typical 27 3.3 bg {rc}: " + g.fmt(r))
EOF
```

</details>

*[Separate the resistor corner from the MOS corner for the driver results (in the cloud container; 7 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && python3 - <<'EOF' 2>&1 | tee -a /home/claude/work/logs/driver_with_bg.txt
import run_gf as g, re
extra = f".include {g.HERE}/bias_ref_gf.spice\n.include {g.HERE}/bg_gf.spice\n.lib {g.PDK}/sm141064.ngspice bjt_typical\n.lib {g.PDK}/sm141064.ngspice diode_typical\n"
bg = "Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bg"
orig = g.deck
def deck2(res='res_typical', **kw):
    t = orig(**kw)
    return re.sub(r"sm141064.ngspice res_\w+", f"sm141064.ngspice {res}", t)
print("-- bandgap with the resistor corner separated (MOS corner, res_typical) and resistor corners at tt:")
for c, t, v, res in [("ss", -40, 3.0, 'res_typical'), ("ff", 125, 3.6, 'res_typical'), ("ss", 125, 3.0, 'res_typical'), ("ff", -40, 3.6, 'res_typical'),
                     ("typical", 27, 3.3, 'res_ss'), ("typical", 27, 3.3, 'res_ff')]:
    g.deck = lambda **kw: deck2(res=res, **kw)
    print(f"{c:7s} {t:4d} {v} {res:11s} " + g.fmt(g.run(corner=c, temp=t, vdd=v, bias=bg, extra=extra)))
EOF
```

</details>

*[Check CACE progress (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
sleep 60; tail -c 600 /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | tr -d '\r' | tail -8; ls /home/claude/work/logs/
```

</details>

*[Inspect the BG CACE run results and errors (in the cloud container; 58 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && r=$(ls -td _runs/RUN_* | head -2 | tail -1); echo $r; grep "ngspice" $r/summary.md | cut -c1-200; grep -i -B2 -A6 "error" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | grep -v "^\s*$" | head -40
```

</details>

*[Find the tree_params failure (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
r=$(ls -td _runs/RUN_* | head -2 | tail -1); ls $r/parameters/tree_params | head; d=$(ls -d $r/parameters/tree_params/* | head -1); ls $d | head; tail -20 $d/*.log 2>/dev/null | head -40; grep -i "missing\|error" $r/parameters/tree_params/*.log 2>/dev/null | head
```

</details>

*[Look at the tree_params run directory and log (in the cloud container; 29 lines of output).]*

<details><summary>command</summary>

```sh
r=$(ls -td _runs/RUN_* | head -2 | tail -1); ls $r/parameters/tree_params/run_00; grep -n -i "error\|missing\|unknown" $r/parameters/tree_params/run_00/*.log $r/parameters/tree_params/*.log 2>/dev/null | head; grep -n -A3 "tree_params" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | grep -i -B1 -A2 "error" | head -20
```

</details>

*[Compare how the In template handles the output pins (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
grep -n "vbn\|vbp" templates/ClassABBiasIn_tb_dc.sch | head; grep -n "vbn\|vbp" templates/ClassABBiasBG_tb_tree.sch | head
```

</details>

*[Netlist both templates directly to see the undriven-node difference (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace/templates && source /home/claude/tools/env.sh && for t in ClassABBiasIn_tb_dc ClassABBiasBG_tb_tree; do xschem --rcfile xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/tt $t.sch > /tmp/tt_$t.log 2>&1; echo "$t exit $?"; grep -i "undriven\|missing" /tmp/tt_$t.log | head -3; done; grep -n "library_path\|netlist" xschemrc | head
```

</details>

*[Find the undriven-node check and the exit-10 condition in xschem (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/src/xschem/src && grep -n "undriven node" *.c | head -5; grep -n "exit(10)\|return 10\|exit_code = 10\|err_code" netlist.c xinit.c main.c 2>/dev/null | head -10
```

</details>

*[Read the ERC code around the undriven-node message (in the cloud container; 39 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 190,225p node_hash.c; grep -rn "node_hash.*errors\|erc_" node_hash.c | head -5; grep -n "exit(10)\|(10)" xinit.c main.c netlist.c | head
```

</details>

*[Add the tree fixture cell and fix the CACE expression (in the cloud container; 16 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && source /home/claude/tools/env.sh && python3 - <<'EOF'
# 1) fixture cell ClassABBiasBGTree in gen_bg.py
s = open('scripts/gen_bg.py').read()
s = s.replace('''if __name__ == "__main__":
    print(core(sys.argv[1], dn="dn" in sys.argv[2:]))''', '''def tree(d, core_cell="ClassABBiasBG"):
    """Fixture: the reference feeding the ClassABBiasIn tree (iout -> iref directly, no BiasRefEnable), for CACE."""
    cell = core_cell + "Tree"
    lines = ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]
    order = ["vdd", "vss", "vddo", "vsso", "en", "en_b"] + lines
    pins = symbol(f"{d}/{cell}.sym", left=[("en", "in"), ("en_b", "in")], right=[(l, "output") for l in lines],
                  top=[("vdd", "inout"), ("vddo", "inout")], bottom=[("vss", "inout"), ("vsso", "inout")], order=order,
                  text="CACE fixture: reference + tree")
    s = BgSheet()
    s.text(cell, 60, -700, 0.5)
    s.text(f"CACE fixture: {core_cell} feeding the ClassABBiasIn tree (iout -> iref directly; in the pad BiasRefEnable sits in between). Ports as ClassABBiasIn plus en / en_b.", 60, -650, 0.25)
    s.text("GF180MCU (gf180mcuD); written by ../../scripts/gen_bg.py on 2026-10-09, edit the sheet from now on.", 60, 140, 0.2, 4)
    for i, (k, n) in enumerate([("iopin", "vdd"), ("iopin", "vss"), ("iopin", "vddo"), ("iopin", "vsso"), ("ipin", "en"), ("ipin", "en_b")]):
        s.pin(k, 60, -500 + 40 * i, n)
    for i, n in enumerate(lines):
        s.pin("opin", 1100, -500 + 40 * i, n)
    cp = [("vdd", 0, -80), ("vss", 0, 80), ("iout", 120, 0), ("en", -120, -20), ("en_b", -120, 20)]
    s.block(f"{core_cell}.sym", "x1", 400, -400, cp, dict(vdd="vdd", vss="vss", iout="iref", en="en", en_b="en_b"))
    tp = [("vdd", 0, -100), ("vss", 0, 100), ("vddo", 0, -100), ("vsso", 0, 100)]  # placeholder, replaced below
    import re
    tp = []
    for m in re.finditer(r"^B 5 (\\S+) (\\S+) (\\S+) (\\S+) \\{[^}]*name=(\\w+)", open(f"{d}/ClassABBiasIn.sym").read(), re.M):
        x1, y1, x2, y2 = map(float, m.group(1, 2, 3, 4)); tp.append((m.group(5), int(round((x1 + x2) / 2)), int(round((y1 + y2) / 2))))
    s.block("ClassABBiasIn.sym", "x2", 760, -400, tp, dict(vdd="vdd", vss="vss", vddo="vddo", vsso="vsso", iref="iref", **{l: l for l in lines}))
    s.write(f"{d}/{cell}.sch", title=True)
    return pins

if __name__ == "__main__":
    if "tree" in sys.argv[2:]:
        print(tree(sys.argv[1], "ClassABBiasBGdn" if "dn" in sys.argv[2:] else "ClassABBiasBG"))
    else:
        print(core(sys.argv[1], dn="dn" in sys.argv[2:]))''')
open('scripts/gen_bg.py','w').write(s)
# 2) CACE: 1m -> 1e-3, tree params into their own datasheet
c = open('scripts/gen_cace_bg.py').read()
c = c.replace("1m", "1e-3")
open('scripts/gen_cace_bg.py','w').write(c)
EOF
grep -n "1e-3\|1m" scripts/gen_cace_bg.py | head; cd schematic/xschem && python3 ../../scripts/gen_bg.py . tree && python3 ../../scripts/gen_bg.py . tree dn && xschem --rcfile xschemrc -n -s -q -x --tcl "set top_is_subckt 1" -o /tmp/bgnet ClassABBiasBGTree.sch 2>&1 | grep -i "missing\|undriven"; grep "^X\|subckt" /tmp/bgnet/ClassABBiasBGTree.spice | head
```

</details>

*[Split the tree check into its own datasheet and regenerate (in the cloud container; 43 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && python3 - <<'EOF'
c = open('scripts/gen_cace_bg.py').read()
# tree template: DUT = the fixture cell
old_start = c.index("    # the tree: core + ClassABBiasIn")
old_end = c.index("def spec(")
c = c[:old_start] + '''
def tree_template(cell, tdir):
    """cell = ClassABBiasBGTree / ClassABBiasBGdnTree: the fixture as the DUT, six diode currents of the tree inside it."""
    pins = sym_pins(os.path.join(MAC, "schematic", "xschem", cell + ".sym"))
    conns = dict(vdd="vdd", vss="0", vddo="vdd", vsso="0", en="en", en_b="en_b", **{p: p for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]})
    srcs = [("Vvdd", "CACE{vdd}", "vdd", "0"), ("Ven", "'CACE{vdd}*CACE{en=1}'", "en", "0"), ("Venb", "'CACE{vdd}*(1-CACE{en=1})'", "en_b", "0")]
    e = "".join(f"let e_{k} = (abs(@m.x1.x2.{dev}.m0[id])/{nom} - 1)\\n" for k, dev, nom in LINES)
    v = " ".join(f"$&e_{k}" for k, _, _ in LINES)
    template(os.path.join(tdir, f"{cell}_tb_dc.sch"), f"Template: bias tree fed by the reference - {cell}",
             f"{cell}: the reference feeding ClassABBiasIn (iout -> iref, no enable switch in between); vddo tied to vdd, vsso to vss.\\n"
             "Bias currents are the drain currents of the six diodes inside the tree (@m.x1.x2.<dev>.m0[id]); errors in % of 5 / 5 / 2 / 2 / 5 / 5 uA\\n"
             "(echoed as fractions: CACE shows a unit of % as 100 x the value).",
             [(f"{cell}.sym", "x1", 700, -400, pins, conns)], srcs,
             OPTS + ".control\\nsave all\\nop\\n" + e + "let Idd = -i(Vvdd)\\n" + OUT.format(vals=v + " $&Idd") + ".endc\\n")

''' + c[old_end:]
# remove tree_params from the core yaml and make a tree yaml
i = c.index("  tree_params:")
j = c.index('"""\n\nif __name__')
tree_block = c[i:j]
c = c[:i] + c[j:]
c = c.replace("def yaml(cell, dn):", '''def yaml_tree(cell, core):
    treespec = "".join(spec(f"e_{k}", f"Error of {k}", f"Deviation of the v{k} diode current from {nom*1e6:g} uA (tree ClassABBiasIn fed by {core}). Limits are placeholders.",
                            "%", -5, 0, 5) for k, _, nom in LINES)
    v6 = ", ".join(f"e_{k}" for k, _, _ in LINES)
    head = yaml(core, core.endswith("dn")).split("parameters:")[0]
    head = head.replace(f"name:           {core}", f"name:           {cell}").replace("Self-contained", "CACE fixture: ClassABBiasIn tree fed by the self-contained")
    head = head.replace("""  iout:
    description: Reference current output, 5 uA flowing OUT of the pin (into the ClassABBiasIn tree's iref)
    type: signal
    direction: output
""", """  vddo:
    description: Output-stage supply (rail of OP and its replica RP1)
    type: power
    direction: inout
  vsso:
    description: Output-stage ground (rail of ON and its replica RN1)
    type: ground
    direction: inout
""" + "".join(f"""  {p}:
    description: bias line {p} of the tree (see ClassABBiasIn.yaml)
    type: signal
    direction: output
""" for p in ["vbp", "vbn", "vbpc", "vbnc", "vabp", "vabn"]))
    return head + "parameters:\\n" + TREE_BLOCK.replace("{treespec}", treespec).replace("{v6}", v6).replace("{cell}", cell).replace("{{", "{").replace("}}", "}")

def yaml(cell, dn):''')
c = c.replace("if __name__ == \"__main__\":", "TREE_BLOCK = '''" + tree_block.replace("{cell}_tb_tree.sch", "{cell}_tb_dc.sch") + "'''\n\nif __name__ == \"__main__\":")
c = c.replace('''    for cell in cells:
        templates(cell, tdir)
        open(os.path.join(cdir, cell + ".yaml"), "w").write(yaml(cell, cell.endswith("dn")))
        print("wrote", cell)''', '''    for cell in cells:
        templates(cell, tdir)
        open(os.path.join(cdir, cell + ".yaml"), "w").write(yaml(cell, cell.endswith("dn")))
        tree_template(cell + "Tree", tdir)
        open(os.path.join(cdir, cell + "Tree.yaml"), "w").write(yaml_tree(cell + "Tree", cell))
        print("wrote", cell, cell + "Tree")''')
open('scripts/gen_cace_bg.py','w').write(c)
EOF
source /home/claude/tools/env.sh; rm -f verification/cace/templates/ClassABBiasBG*_tb_tree.sch; python3 scripts/gen_cace_bg.py . && grep -n "tree_params\|^  [a-z_]*:$" verification/cace/ClassABBiasBG.yaml verification/cace/ClassABBiasBGTree.yaml | grep -v "    " ; python3 -c "import yaml;[yaml.safe_load(open(f)) for f in ['verification/cace/ClassABBiasBG.yaml','verification/cace/ClassABBiasBGTree.yaml']]; print('yaml ok')"
```

</details>

*[Test the start-up parameter after the expression fix (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && source /home/claude/tools/env.sh && pkill -f "cace Class" ; sleep 1; (cace ClassABBiasBG.yaml -s schematic --nofail -j 2 --parallel-parameters 1 -p tran_startup_params > /home/claude/work/logs/cace_BG_startup_test.out 2>&1); r=$(ls -td _runs/RUN_* | head -1); grep "ngspice" $r/summary.md | grep -i "start" | cut -c1-200; grep -c "ERROR" /home/claude/work/logs/cace_BG_startup_test.out
```

</details>

*[Run the start-up parameter in the background and peek (in the cloud container; 5 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && source /home/claude/tools/env.sh && nohup cace ClassABBiasBG.yaml -s schematic --nofail -j 2 --parallel-parameters 1 -p tran_startup_params > /home/claude/work/logs/cace_BG_startup_test.out 2>&1 &
sleep 90; grep -c "ERROR" /home/claude/work/logs/cace_BG_startup_test.out; tail -c 300 /home/claude/work/logs/cace_BG_startup_test.out
```

</details>

While that runs (60 transients), let me write the macro README section and update the log draft; I'll check results as they come in.

*[Check start-up run progress (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
sleep 170; cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && r=$(ls -td _runs/RUN_* | head -1); ls $r/parameters/tran_startup_params 2>/dev/null | wc -l; grep "ngspice" $r/summary.md 2>/dev/null | grep -i "start" | cut -c1-200; tail -c 200 /home/claude/work/logs/cace_BG_startup_test.out
```

</details>

*[See how many start-up runs are done (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
r=$(ls -td _runs/RUN_* | head -1); ls $r/parameters/tran_startup_params/run_00; cat $r/parameters/tran_startup_params/run_*/*.data 2>/dev/null | head -5; ls $r/parameters/tran_startup_params/*/*.data 2>/dev/null | wc -l; ps aux | grep -c "[n]gspice"
```

</details>

*[Locate the mismatch results for a sigma calculation (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
python3 - <<'EOF'
import csv, numpy as np, glob
r = sorted(glob.glob('_runs/RUN_2026-10-09_00-14-03/parameters/mm_params/*.csv')) or glob.glob('_runs/RUN_2026-10-09_00-14-03/**/mm*.csv', recursive=True)
print(r[:3])
EOF
ls _runs/RUN_2026-10-09_00-14-03/parameters/mm_params | head -3; ls _runs/RUN_2026-10-09_00-14-03/ | head; ls results/ClassABBiasIn/
```

</details>

*[Compute sigma from the CACE mismatch csv (in the cloud container; error).]*

<details><summary>command</summary>

```sh
head -3 _runs/RUN_2026-10-09_00-14-03/parameters/mm_params/simulation_summary.csv; python3 - <<'EOF'
import csv, numpy as np
rows = list(csv.DictReader(open('_runs/RUN_2026-10-09_00-14-03/parameters/mm_params/simulation_summary.csv')))
k = [c for c in rows[0] if 'e_iout' in c][0]
e = np.array([float(r[k]) for r in rows]); print(len(e), 'runs: mean %+.2f %%, sigma %.2f %%, min %+.2f, max %+.2f' % (e.mean(), e.std(), e.min(), e.max()))
EOF
```

</details>

*[Compute sigma from the raw mismatch data (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cat _runs/RUN_2026-10-09_00-14-03/parameters/mm_params/run_0/*.data | awk '{print $1}' | python3 -c "
import sys, numpy as np; e=np.array([float(l) for l in sys.stdin])*100; print(len(e),'runs: mean %+.2f %%, sigma %.2f %%, min %+.2f, max %+.2f'%(e.mean(),e.std(),e.min(),e.max()))"
```

</details>

*[Find the mismatch data files (in the cloud container; 4 lines of output).]*

<details><summary>command</summary>

```sh
find _runs/RUN_2026-10-09_00-14-03/parameters/mm_params -name "*.data" | head -3; find _runs/RUN_2026-10-09_00-14-03/parameters/mm_params -name "*.data" | wc -l
```

</details>

*[Compute the mismatch sigma from the CACE run (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && cat > scripts/mm_sigma.py <<'EOF'
#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""sigma of a CACE mismatch parameter from the raw .data files of a run:
mm_sigma.py <run dir>/parameters/mm_params [column]   (column 0 = first echoed value, a fraction)"""
import glob, sys, numpy as np
d, col = sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 0
v = np.array([float(open(f).read().split()[col]) for f in glob.glob(d + "/**/*.data", recursive=True)]) * 100
print(f"{len(v)} runs: mean {v.mean():+.2f} %, sigma {v.std():.2f} %, min {v.min():+.2f} %, max {v.max():+.2f} %")
EOF
python3 scripts/mm_sigma.py verification/cace/_runs/RUN_2026-10-09_00-14-03/parameters/mm_params
```

</details>

*[Wait for the start-up runs (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
sleep 240; cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && r=$(ls -td _runs/RUN_* | head -1); find $r/parameters/tran_startup_params -name "*.data" | wc -l; grep "ngspice" $r/summary.md 2>/dev/null | grep -i "start" | cut -c1-220
```

</details>

Let me use the wait to draft the README section for the macro.

*[Find the README anchors to extend (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && grep -n "^## \|^| \`ClassAB\|not ported yet\|## Open points" README.md | head -20
```

</details>

*[Read the README passages to update (in the cloud container; 13 lines of output).]*

<details><summary>command</summary>

```sh
sed -n 34,41p README.md; sed -n 77,90p README.md
```

</details>

*[Wait for the start-up runs to finish (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 200; cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && r=$(ls -td _runs/RUN_* | head -1); find $r/parameters/tran_startup_params -name "*.data" | wc -l; grep "ngspice" $r/summary.md 2>/dev/null | grep -i "start" | cut -c1-220
```

</details>

*[Run all four CACE datasheets sequentially in the background (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
source /home/claude/tools/env.sh && rm -rf _runs/RUN_2026-10-09_00-1* && cat > /home/claude/work/run_all_cace.sh <<'EOF'
#!/bin/bash
source /home/claude/tools/env.sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace
for c in ClassABBiasBG ClassABBiasBGTree ClassABBiasBGdn ClassABBiasBGdnTree; do
  cace $c.yaml -s schematic --nofail -j 2 --parallel-parameters 1 > /home/claude/work/logs/2026-10-09_fable_cace_$c.out 2>&1
  r=$(ls -td _runs/RUN_* | head -1); mkdir -p results/$c; cp $r/summary.md results/$c/summary.md
  for p in $r/parameters/*/; do n=$(basename $p); [ -f $p/simulation_summary.csv ] && cp $p/simulation_summary.csv results/$c/$n.csv; done
  cp $r/parameters/*/*.png results/$c/ 2>/dev/null
  echo "$c done $(date)" >> /home/claude/work/logs/cace_all_progress.txt
done
echo ALLDONE >> /home/claude/work/logs/cace_all_progress.txt
EOF
chmod +x /home/claude/work/run_all_cace.sh && nohup /home/claude/work/run_all_cace.sh > /dev/null 2>&1 & echo started
```

</details>

*[Extend the ClassABBias README with the bandgap section (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && python3 - <<'EOF'
s = open('README.md').read()
s = s.replace("""Each sheet is flat at transistor level, as on IHP: reference [R], mirror tree and the six diodes [8]. The two
self-contained IHP variants (Oguey–Aebischer `d2s_bias_oa`, bandgap `d2s_bias_bg`) are not ported yet; both need
a real re-design for GF180 (weak-inversion sizing; the bandgap's PTAT/CTAT balance relied on rhigh's TC, and the
vertical PNPs of GF180 have fixed geometry).
""", """| `ClassABBiasBG` | `bg_core` (re-designed) | vdd vss iout en en_b | **self-contained bandgap reference**, 5 µA **out of** iout, for the `ClassABBiasIn` tree's iref; with start-up and the disable sub-cell `PadEnable/RefCoreEnable` (2026-10-09, see below) |
| `ClassABBiasBGdn` | same | same | the same core with the NMOS pair NA / NB in isolated p-wells (deep n-well), bulk tied to source |
| `ClassABBiasBGTree`, `…BGdnTree` | — | as `ClassABBiasIn` plus en en_b, without iref | CACE fixtures: reference feeding the tree (iout → iref directly) |

Each tree sheet is flat at transistor level, as on IHP: reference [R], mirror tree and the six diodes [8]. The
Oguey–Aebischer variant (`d2s_bias_oa`) is not ported (deferred 2026-10-08; it needs a GF180 re-design: the IHP MS1
is 0.5/100 µm, the bin ends at L = 50 µm).
""")
s = s.replace("""## Open points
""", """## ClassABBiasBG — the bandgap reference (GF180 re-design, 2026-10-09)

Current-mode (Banba) bandgap without op-amp, as the IHP `bg_core` (`bias.md`, variant 4): the PMOS mirror makes the
two branch currents equal and the NMOS pair NA / NB forces ea = eb, so each branch carries V_BE1 / R1 + U_T ln 8 / R0
with Q2 = 8 × Q1 (`pnp_05p00x05p00`, 25 µm² each, ratio by `m`); PO / POC = 2 × → 5 µA. Not a transliteration;
what changed for GF180 and why (numbers: notes worktree, `logs/main/2026-10-08_fable_reference_redesign_log.md`,
harness `kickoffs/2026-10-08_reference_redesign/tools/`):

- **Wide-swing cascode instead of the stacked-diode cascode.** With pfet_03v3's |V_T| the IHP structure
  (vpc = vdd − 2 V_SG ≈ 1.0 V at ss / 3.0 V / −40 °C) leaves NB no V_DS. Now the input branch's diode connection
  closes around the cascode PBC (vpg = its drain) and the cascode gate line is vpc = vpg − I·RC with RC = 150 kΩ
  (`ppolyf_u_3k` 1u/50u) between the two gate lines; NB's drain sits on vpc. Every mirror device has V_SD = I·RC
  (0.31–0.37 V), every cascode V_SG − I·RC. Costs one resistor.
- **Resistors `ppolyf_u_3k`, 1 µm wide** (R1B 107.4 µm ≈ 325 kΩ, R1A 118.1 µm — 10 % longer, the IHP trick against
  the resistor-only false state — R0 32.8 µm ≈ 100 kΩ): 308 µm of strip in all, ≈ 450 µm² with spacing. Its TC
  (−0.154 %/K) makes the balance 68 % CTAT / 32 % PTAT; its tc2 (3.7e-6/K²) is what limits the drift (the band over
  −40…125 °C is 3.0 % wide, with `ppolyf_u_1k` it would be 2.1 % at 2.8 × the resistor area — a one-line swap in
  `scripts/bg_reference.spice` + `gen_bg.py` if the drift ever matters more than the area). The band is centred on
  5 µA: 27 °C sits at +1.5 %, the ends at −1.2 / −1.4 %.
- **NMOS pair 20/12** (was 20/4): NB's V_DS moves 1:1 with vdd, and its g_ds / g_m is an input offset of the pair;
  the long channel halves the line sensitivity.
- **PMOS mirror 48/4 nf=4, cascodes 48/2 nf=4**, PO / POC 96/4, 96/2 nf=8 (one instance each; the mismatch model
  ignores `m` and the bin ends at W = 100 µm). The mirror devices set the mismatch (48/2: σ 1.8 %, 48/4: 1.0 %).
- **Start-up** [S] as on IHP but pulling the mirror gate line vpg: MS1 0.22/50 (weak pull-up on ks, gate on en_b),
  MS2 senses g, MS3 pulls vpg. **Disable** [E]: `PadEnable/RefCoreEnable` (vpg → vdd, ks → vss while en = 0).
- Gate area ≈ 1660 µm² MOS (IHP: 541), 25 × 9 = 225 µm² of PNP emitters (IHP: 36), resistors ≈ 450 µm².

Results (plain-ngspice harness and CACE, schematic, cloud toolchain: xschem 3.4.8RC, ngspice-47, gf180mcuD 1689ac3,
CACE 2.13; `verification/cace/results/ClassABBiasBG/`):

| | target (2026-10-08) | `ClassABBiasBG` | `ClassABBiasBGdn` |
|---|---|---|---|
| iout, 27 °C / 3.3 V / tt | 5 µA | 5.077 µA (+1.5 %) | 5.086 µA |
| MOS corners × 3.0/3.3/3.6 V × −40/27/125 °C | ±3 % | −1.6 … +1.7 % | −1.5 … +1.9 % |
| process spread, resistor / PNP corners (report) | — | res_ss / res_ff −19 / +36 % (R_sh ±25 %, no trim); bjt_ss / ff +2.6 / +0.7 % | same |
| DC line sensitivity, 3.0 → 3.6 V, all corners × temp | ≤ 1 %/V | 0.0 … 0.42 %/V | 0.4 … 0.6 %/V |
| AC from vdd (harness, tt), 1 k / 100 k / 1 MHz | — | 0.42 / 3.5 / 14 %/V | 0.6 / 1.3 / 8 %/V (depends on the well capacitance) |
| start-up, 1 µs ramp, 5 MOS corners × 3.0/3.6 V × −40/27/125 °C | required | settled within ±10 % ≤ 1.3 µs after the ramp, at the DC point | same |
| start-up, 1 ms ramp | required | settled 125–580 µs before the ramp ends | same |
| mismatch, 100 runs (MOS + PNP; the PDK has no resistor mismatch) | σ ≤ 2 % | σ 1.06 %, extremes −1.2 / +4.0 % | σ ≈ 1.1 % |
| disabled (en = 0), 3.0–3.6 V, −40…125 °C | — | I_dd 0.02–0.24 nA, iout ≤ 0.07 nA | same |
| supply current, enabled | — | 10.0–10.7 µA (4 branches of 2.5 µA + MS1) | same |
| with the tree (`…BGTree`): six lines over MOS corners × V × T | ±5 % (placeholder) | see `results/ClassABBiasBGTree/` | |

Substrate noise (harness, AC on the NMOS bulks / PNP collectors only, vss clean): `ClassABBiasBG` 0.16 / 13.5 / 51 %/V at
10 Hz / 100 kHz / 1 MHz, `ClassABBiasBGdn` ≈ 0 at every frequency — that is what the deep n-well buys; it costs the
body effect (g_mb no longer helps the pair, DC line sensitivity 0.42 → 0.62 %/V), ≈ +500–700 µm² (DNW enclosure
2.5 µm, N-well ring, PCOMP guard ring, 3.1 µm keep-out to other N-wells; DRC-rule estimate, no layout) and the well
junctions, modelled as `diode_pw2dw` / `diode_dw2ps` with guessed areas. LVS extracts an NMOS in a DNW as plain
`nfet_03v3` with the p-well as bulk net, and the well diodes only under a `well_diode_mk` marker.

Informative, 06v0 devices substituted at the same sizes, 4.5–5.5 V (harness): works, +2.8 % at 5.0 V, drift as 3.3 V,
line sensitivity 1.2 %/V (NB's V_DS swings 2 V; a 5 V version would want a longer NB or a cascode), MS1 ≥ 0.3 µm wide.

Driver `ClassABDriver` with the reference (harness, 1 kΩ ∥ 100 pF, resistors typical): I_Q 200–220 µA over
ss/3.0 V/−40 °C … ff/3.6 V/125 °C (ideal fixture 205–218), T0 61–93 dB, PM 66–78°, offset ≤ 0.8 mV; the resistor
corners move I_Q to 172 / 286 µA (IHP rhigh: 171 / 268).

Files: `scripts/gen_bg.py` (sheets, symbols, fixtures), `scripts/bg_reference.spice` (sizes; round trip with
`../ClassABDriver/scripts/check_classab_port.py`, now also for PNPs, 1k resistors and diodes: MISMATCHES 0),
`scripts/gen_cace_bg.py` (datasheets and templates), `scripts/mm_sigma.py` (σ from a run's `.data` files).
The core sheets are drawn in the label style of `PadEnable` (rails as wires, gates and drains by stub and label),
not ported from the IHP drawing (the topology changed).

## Open points
""")
s = s.replace("""- Which reference feeds iref, and how many pads share it, is not decided; the bias tree is meant to sit in each pad.""",
"""- Which reference feeds iref, and how many pads share it, is not decided; the bias tree is meant to sit in each pad.
  `ClassABBiasBG` is drawn to sit in front of `BiasRefEnable` (iout → iin); the pad does not instantiate it yet.
- `ClassABBiasBG`: the resistor spread (±25 % of R_sh → −19 / +36 % of the current, I_Q 172 / 286 µA) is the
  dominant error and would need a trim or a tolerant driver; the ±3 % drift target has 1.3 % margin with the 3k
  resistor (2 % with 1k); the deep-n-well choice is open (`ClassABBiasBGdn`).
- Oguey–Aebischer variant: not ported.""")
open('README.md','w').write(s)
EOF
echo ok
```

</details>

*[Check the Makefile and the earlier Makefile delivery package (in the cloud container; 31 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros && grep -n "CACE_CELLS\|^TOP\|sim-cace" ClassABBias/Makefile | head; grep -n "RefCoreEnable\|InputEnable" PadEnable/README.md | head -3; ls ../../gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles/ 2>/dev/null; unzip -l ../../gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip | head -20
```

</details>

*[Read the earlier installer to reuse its pattern (in the cloud container; 42 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries && unzip -p 2026-10-08_opus_makefiles.zip 2026-10-08_opus_makefiles/install.sh 2>/dev/null | head -60; unzip -l 2026-10-08_opus_makefiles.zip | tail -8; md5sum ../../../gf180_cm_ip__single2diff2single/macros/ClassABBias/Makefile
```

</details>

*[Build and test the Makefile delivery package (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
set -e; cd /home/claude/work && P=deliver_pkg/2026-10-09_fable_makefile && mkdir -p $P/repo/macros/ClassABBias && cp gf180_cm_ip__single2diff2single/macros/ClassABBias/Makefile /tmp/Makefile.orig && sed 's/^CACE_CELLS := ClassABBiasIn ClassABBiasOut$/CACE_CELLS := ClassABBiasIn ClassABBiasOut ClassABBiasBG ClassABBiasBGTree ClassABBiasBGdn ClassABBiasBGdnTree/' /tmp/Makefile.orig > $P/repo/macros/ClassABBias/Makefile && diff -u /tmp/Makefile.orig $P/repo/macros/ClassABBias/Makefile > $P/changes_to_existing_makefiles.diff || true; cd $P && (cd /tmp && md5sum Makefile.orig | sed 's|Makefile.orig|macros/ClassABBias/Makefile|') > expected_originals.md5 && (cd repo && md5sum macros/ClassABBias/Makefile) > new.md5 && unzip -p /home/claude/work/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/deliveries/2026-10-08_opus_makefiles.zip 2026-10-08_opus_makefiles/install.sh | sed 's/2026-10-08/2026-10-09/g' > install.sh && cat > README.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Makefile package 2026-10-09 (bandgap reference `ClassABBiasBG`)

The bridge refuses to write Makefiles, so this package carries the one change of the session:

- `macros/ClassABBias/Makefile`: `CACE_CELLS` now also lists `ClassABBiasBG ClassABBiasBGTree ClassABBiasBGdn
  ClassABBiasBGdnTree`, so `make sim-cace-all` runs the four new datasheets too (`make sim-cace CACE_TOP=ClassABBiasBG`
  runs one). `changes_to_existing_makefiles.diff` shows the one-line change.

`sh install.sh [<repo>]` installs it (default repo `~/EDA/gf180_cm_ip__single2diff2single`): the existing Makefile is
replaced only if it is still the 2026-10-08 package version (md5 0340e1d8…, `expected_originals.md5`), kept as
`Makefile.orig-2026-10-09`; `FORCE=1` replaces it anyway. `new.md5` checks the result.
EOF
cat expected_originals.md5 new.md5 changes_to_existing_makefiles.diff | head -20; cd .. && zip -qr 2026-10-09_fable_makefile.zip 2026-10-09_fable_makefile && md5sum 2026-10-09_fable_makefile.zip && mkdir -p /tmp/repotest && cp -r /home/claude/work/gf180_cm_ip__single2diff2single /tmp/repotest/ && sh 2026-10-09_fable_makefile/install.sh /tmp/repotest/gf180_cm_ip__single2diff2single && sh 2026-10-09_fable_makefile/install.sh /tmp/repotest/gf180_cm_ip__single2diff2single
```

</details>

Now the PadEnable README, HANDOVER and CLAUDE.md status lines, then a check on CACE.

*[Update PadEnable README, handover and CLAUDE.md; check CACE progress (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single && python3 - <<'EOF'
p = 'macros/PadEnable/README.md'; s = open(p).read()
s = s.replace("""| `InputEnable` | vdd vss en en_b pin pout vpark |""", """| `RefCoreEnable` | vdd vss en en_b vpg ks | SPG (pfet), SKS (nfet), 1u/0.5u | (2026-10-09) disable of a self-biased reference core (`ClassABBias/ClassABBiasBG`): disabled: vpg (PMOS mirror gate line) → vdd, so every branch is off, and ks (start-up node) → vss, otherwise it floats with the core's pull-up MS1 off (MS1's gate is on en_b). Written by `gen_padenable.py … ref_core_enable`; the other cells were not regenerated |
| `InputEnable` | vdd vss en en_b pin pout vpark |""")
open(p, 'w').write(s)
p = 'HANDOVER_gf180_migration.md'; s = open(p).read()
s += """
## 9. 2026-10-09: bandgap reference `ClassABBiasBG` (GF180 re-design, not a transliteration)

Kickoff `_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/`; running log with every number
`_sudelbuecher/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md`. Decisions (Christoph): bandgap only
(Oguey–Aebischer deferred), kickoff targets as limits, 03v3 at 3.0–3.6 V plus an informative 06v0/5 V check, old OA macro
untouched, disable as a sub-cell, deep-n-well variant compared before CACE, poly resistors allowed, save area.

- `macros/ClassABBias`: `ClassABBiasBG` (core, ports `vdd vss iout en en_b`, 5 µA out of iout), `ClassABBiasBGdn`
  (NMOS pair in a deep n-well), CACE fixtures `…Tree` (core + `ClassABBiasIn`), four datasheets with results in
  `verification/cace/results/`. README section "ClassABBiasBG" has the design, the numbers and the open points.
- `macros/PadEnable`: `RefCoreEnable` (vpg → vdd, ks → vss while disabled).
- Topology changes vs IHP: wide-swing cascode mirror (resistor between the gate lines; the IHP stacked-diode cascode has
  no headroom with pfet_03v3 at ss/3.0 V/−40 °C), start-up on vpg, NMOS pair 20/12, mirrors 48/4, `ppolyf_u_3k`
  1 µm resistors (area), PNP ratio 8 by `m`.
- Results (tt): 5.08 µA, −1.6…+1.7 % over MOS corners × V × T, line 0.0–0.42 %/V, σ 1.06 % (100 runs), start-up at
  every corner with 1 µs and 1 ms ramps, leakage ≤ 0.24 nA disabled, I_dd 10.5 µA; resistor spread −19/+36 % (dominant,
  no trim). Deep n-well: substrate noise to the pair eliminated, DC line 0.42 → 0.62 %/V, ≈ +500–700 µm².
- Makefile change (CACE_CELLS) as a package: `_sudelbuecher/sudelbuecher/deliveries/2026-10-09_fable_makefile.zip`.
- Not done: pad integration (`gf180mcu_IOPadDiff2Single` still takes iref from a pin), layout, the Oguey–Aebischer variant,
  a 06v0 version. Checker `ClassABDriver/scripts/check_classab_port.py` now also compares PNPs, 1k resistors and diodes.
- Toolchain note: the 2026-10-08 CACE suites rerun with xschem 3.4.8RC ddc73448 / ngspice-47 / gf180mcuD 1689ac3 (the
  IIC-OSIC-TOOLS 2026.09 pins): `ClassABBiasIn` identical, `ClassABDriverBiased` three transient values in the last digit.
"""
open(p, 'w').write(s)
p = 'CLAUDE.md'; s = open(p).read()
s = s.replace("""`_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md`. **No layout exists**;""",
"""`_sudelbuecher/sudelbuecher/logs/main/2026-10-08_opus_classab_port_log.md`.
**2026-10-09:** bandgap reference `macros/ClassABBias/ClassABBiasBG` (+ deep-n-well variant, `PadEnable/RefCoreEnable`),
GF180 re-design with CACE results; handover §9, log `…/logs/main/2026-10-08_fable_reference_redesign_log.md`. **No layout exists**;""")
open(p, 'w').write(s)
EOF
grep -c "2026-10-09" CLAUDE.md HANDOVER_gf180_migration.md macros/PadEnable/README.md; cat /home/claude/work/logs/cace_all_progress.txt 2>/dev/null
```

</details>

*[Check CACE progress (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
sleep 120; cat /home/claude/work/logs/cace_all_progress.txt 2>/dev/null; tail -c 150 /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | tr -d '\r'
```

</details>

*[Locate the session transcript and read the chat-log exporter usage (in the cloud container; 49 lines of output).]*

<details><summary>command</summary>

```sh
ls -la ~/.claude/projects/ 2>/dev/null | head; ls -la ~/.claude/projects/*/ 2>/dev/null | head; sed -n 1,40p /home/claude/work/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py | grep -v "^$"
```

</details>

*[Export the chat log with the project's script (test run) (in the cloud container; 32 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work && mkdir -p deliver/sudelbuecher/chatlog && cp ~/.claude/projects/-home-claude/669e0843-1ea7-5638-8c5d-93eca71fd6cf.jsonl /tmp/session.jsonl && python3 -I gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py /tmp/session.jsonl deliver/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md "GF180 bandgap reference redesign (ClassABBiasBG)" 669e0843-1ea7-5638-8c5d-93eca71fd6cf claude-fable-5-1 && wc -l deliver/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md && grep -c "^\*\*User" deliver/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md; head -30 deliver/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md
```

</details>

*[Extend the running log and check CACE progress (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/deliver/sudelbuecher/logs/main && python3 - <<'EOF'
p = '2026-10-08_fable_reference_redesign_log.md'; s = open(p).read()
s = s.replace("""## next

Draw `ClassABBiasBG` (+ `ClassABBiasBGdn`?) and `RefCoreEnable`, round trip, CACE, driver with the real reference.
""", """## 2026-10-09 00:01 — Christoph: "AVOID POLY RESISTORS!" — 00:03: rescinded ("resistors are inevitable; poly resistors
are ok; save area if you can")

Area lever taken: **`ppolyf_u_3k` instead of `ppolyf_u_1k`** (strips 870 → 308 µm, ≈ −900 µm²), with the temperature
band centred on 5 µA so that its 3.0 % width still fits ±3 %: R1B 107.4 µm, R1A 118.1 µm, R0 32.8 µm, RC 50 µm
(150 kΩ), all 1 µm wide. Re-tuned results, `bg_core` (tools, 3k):

| | value |
|---|---|
| iout 27 °C / 3.3 V | 5.077 µA (+1.5 %); band −40…125 °C −1.2 … +1.6 % of 5 µA (3.0 % wide, peak at 50 °C) |
| 5 MOS corners × 3.0/3.3/3.6 V × −40/27/125 °C | **−1.6 … +1.7 %** (worst ss 3.0 V 125 °C / ff 3.6 V 27 °C) |
| bjt_ss / bjt_ff at 27 °C | +2.6 / +0.7 % (bjt_ss reaches +2.9 % at 50 °C) |
| res_ss / res_ff | **−19.4 / +36.5 %** (3k: R_sh ±25 %) |
| DC line, tt / ss −40 / ff 125 | 0.32 / 0.29 / 0.43 %/V; AC 100 k / 1 MHz: 2.9–3.2 / 11–13 %/V |
| mismatch σ (100 seeds) | 0.98 % (dn: 1.05 %) |
| start-up 1 µs / 1 ms ramps, 10 corners | ok everywhere, 0.4–1.1 µs after the ramp / 250–580 µs before its end |
| `bg_core_dn` | line 0.44–0.58 %/V, AC 100 k 0.55–0.86 %/V, else as above |

## 00:06 — sheets, symbols, round trip

- `macros/PadEnable/RefCoreEnable` (SPG vpg → vdd, SKS ks → vss, 1u/0.5u) added to `gen_padenable.py` (new function
  `ref_core_enable`; `main` now takes cell names, only this cell was written — the 2026-10-08 sheets are untouched) and
  to `padenable_reference.spice`.
- `macros/ClassABBias/scripts/gen_bg.py` + `bg_reference.spice`: `ClassABBiasBG` (ports `vdd vss iout en en_b`; MS1's
  gate on en_b, `XE RefCoreEnable` inside), `ClassABBiasBGdn` (NA/NB bulk = source, `diode_pw2dw` × 2 and
  `diode_dw2ps` with the estimated areas as `r_w`/`r_l`), the CACE fixtures `ClassABBiasBGTree` / `…dnTree` (core +
  `ClassABBiasIn`, iout → iref). Drawn in the `PadEnable` label style with the repo's `scripts/xsheet.py` (extended
  locally with resistor / PNP / diode placers); the IHP drawing was not ported because the topology changed.
- `ClassABBias/schematic/xschem/xschemrc`: one line added (the PadEnable schematic folder, for `RefCoreEnable.sym`).
- `ClassABDriver/scripts/check_classab_port.py` extended: models `ppolyf_u_1k`, `pnp_05p00x05p00`, `pnp_10p00x10p00`
  (m compared), `D` primitives (nets compared). **MISMATCHES 0** on `ClassABBiasBG` (18 devices), `ClassABBiasBGdn`
  (21), `RefCoreEnable` (2); a moved gate and a changed resistor length give MISMATCHES 2.
- Figure check: SVG export with `xschem … --script` (print area given explicitly; `xvfb-run` hangs here) — readable.

## 00:14 — CACE (`macros/ClassABBias/verification/cace`, `scripts/gen_cace_bg.py`, four datasheets)

Parameters of `ClassABBiasBG` / `…dn`: `dc_params` (iout over 5 MOS corners × 3 V × 3 T, limit ±3 %), `spread_params`
(res × bjt corners × T, report), `line_params` (≤ 1 %/V), `tran_startup_params` (1 µs and 1 ms ramps × 2 V × 5 corners
× 3 T; t_startup as in OgueyAebischerBias, e_end ±3 %), `mm_params` (100 runs, ±6 % on the extremes, σ from the
`.data` files with `scripts/mm_sigma.py`), `off_params` (en = 0, leakage after 200 µs of transient). The `…Tree`
datasheets: the six diode currents of the tree over 5 corners × 3 V × 3 T (±5 % placeholders, as `ClassABBiasIn`).

Pitfalls (new): CACE expressions `CACE[... + 1m]` fail ("Invalid expression") — write `1e-3`. A template cannot
instantiate a second cell of the macro (templates are netlisted with the PDK xschemrc + the templates folder only;
the cell's outputs then count as undriven, xschem exits 10) — hence the fixture cells. The ClassABBias `Makefile`
change (`CACE_CELLS`) is a package again: `deliveries/2026-10-09_fable_makefile.zip`.

First complete run of `ClassABBiasBG` (RUN_2026-10-09_00-14-03 + the start-up rerun): dc −1.61 … +1.66 % ✅, spread
−22.9 … +37.9 % (incl. bjt corners at −40/125 °C), line −0.005 … +0.416 %/V ✅, start-up t ≤ 1.29 µs after a 1 µs ramp
and ≥ 125 µs before a 1 ms ramp ends, e_end = dc ✅, mismatch σ 1.06 % (mean +1.29, −1.2 / +4.0 %) ✅, disabled
I_dd 0.02–0.24 nA, iout ≤ 0.07 nA ✅.

## 00:30 — driver with the real reference (tools `run_gf.py` + `bg_gf.spice`; `logs/main/…driver_with_bg.txt`)

`ClassABDriver` on `ClassABBiasBG` → `ClassABBiasIn`, 1 kΩ ∥ 100 pF, resistors typical: I_Q 214.5 µA at tt (ideal
fixture 212.8, `in` 211.5), 200–220 µA over ss/3.0 V/−40 … ff/3.6 V/125 °C (ideal 205–218), T0 61–93 dB, PM 66–78°,
offset ≤ 0.8 mV, INL ≤ 0.28 mV. Resistor corners: I_Q 172 / 286 µA (IHP rhigh: 171 / 268). The DNW variant is within
0.3 µA of these. Note `run_gf.py` ties the resistor corner to the MOS corner (ss → res_ss); the table in the log file
separates them.
""")
open(p, 'w').write(s)
EOF
cat /home/claude/work/logs/cace_all_progress.txt 2>/dev/null; echo; tail -c 120 /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | tr -d '\r'
```

</details>

*[Wait for CACE (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
sleep 290; cat /home/claude/work/logs/cace_all_progress.txt 2>/dev/null; grep -o "Parameter [a-z_]*:" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | tail -1
```

</details>

*[Wait for CACE (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 295; cat /home/claude/work/logs/cace_all_progress.txt 2>/dev/null; grep -o "Parameter [a-z_]*:" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBG.out | tail -1
```

</details>

*[Read the complete BG and tree results (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && grep "ngspice" results/ClassABBiasBG/summary.md results/ClassABBiasBGTree/summary.md | sed 's/results\///; s/summary.md://' | cut -c1-210; ls results/ClassABBiasBG results/ClassABBiasBGTree; python3 ../../scripts/mm_sigma.py $(ls -td _runs/RUN_* | sed -n 2p)/parameters/mm_params
```

</details>

*[Compute sigma from the full BG run (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && for r in _runs/RUN_*; do echo "$r $(ls $r/parameters | tr '\n' ' ')"; done; python3 ../../scripts/mm_sigma.py _runs/RUN_2026-10-09_00-23-5*/parameters/mm_params 2>/dev/null || for r in _runs/RUN_*; do [ -d $r/parameters/mm_params ] && [ -d $r/parameters/dc_params ] && python3 ../../scripts/mm_sigma.py $r/parameters/mm_params; done
```

</details>

*[Assemble the list of files to deliver (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single && cat > /tmp/newfiles.txt <<'EOF'
CLAUDE.md
HANDOVER_gf180_migration.md
macros/ClassABBias/README.md
macros/ClassABBias/schematic/xschem/xschemrc
macros/ClassABBias/schematic/xschem/ClassABBiasBG.sch
macros/ClassABBias/schematic/xschem/ClassABBiasBG.sym
macros/ClassABBias/schematic/xschem/ClassABBiasBGdn.sch
macros/ClassABBias/schematic/xschem/ClassABBiasBGdn.sym
macros/ClassABBias/schematic/xschem/ClassABBiasBGTree.sch
macros/ClassABBias/schematic/xschem/ClassABBiasBGTree.sym
macros/ClassABBias/schematic/xschem/ClassABBiasBGdnTree.sch
macros/ClassABBias/schematic/xschem/ClassABBiasBGdnTree.sym
macros/ClassABBias/scripts/gen_bg.py
macros/ClassABBias/scripts/bg_reference.spice
macros/ClassABBias/scripts/gen_cace_bg.py
macros/ClassABBias/scripts/mm_sigma.py
macros/ClassABBias/verification/cace/ClassABBiasBG.yaml
macros/ClassABBias/verification/cace/ClassABBiasBGdn.yaml
macros/ClassABBias/verification/cace/ClassABBiasBGTree.yaml
macros/ClassABBias/verification/cace/ClassABBiasBGdnTree.yaml
macros/ClassABDriver/scripts/check_classab_port.py
macros/PadEnable/README.md
macros/PadEnable/scripts/gen_padenable.py
macros/PadEnable/scripts/padenable_reference.spice
macros/PadEnable/schematic/xschem/RefCoreEnable.sch
macros/PadEnable/schematic/xschem/RefCoreEnable.sym
EOF
ls macros/ClassABBias/verification/cace/templates/ClassABBiasBG* | sed 's|^|macros/ClassABBias/verification/cace/templates/|; s|macros/ClassABBias/verification/cace/templates/macros/ClassABBias/verification/cace/templates/|macros/ClassABBias/verification/cace/templates/|' >> /tmp/newfiles.txt; wc -l /tmp/newfiles.txt; for f in $(cat /tmp/newfiles.txt); do [ -f $f ] || echo MISSING $f; done; grep -n "sim_pinnumber\|sa=0 sb=0" macros/ClassABBias/schematic/xschem/ClassABBiasBG.sch | head -2
```

</details>

*[Checksums and mtimes of the files that will be overwritten on the computer (on the computer; 21 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && for f in CLAUDE.md HANDOVER_gf180_migration.md macros/ClassABBias/README.md macros/ClassABBias/schematic/xschem/xschemrc macros/ClassABDriver/scripts/check_classab_port.py macros/PadEnable/README.md macros/PadEnable/scripts/gen_padenable.py macros/PadEnable/scripts/padenable_reference.spice macros/ClassABBias/Makefile; do echo "$(md5sum < $f | cut -c1-32) $(stat -c %Y $f) $f"; done; ls macros/ClassABBias/schematic/xschem macros/ClassABBias/verification/cace/results
```

</details>

*[Confirm the snapshot's originals match the computer (backup source) (in the cloud container; 2 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work && tar xzf /mnt/user-data/uploads/gf180_cm_ip__single2diff2single_sudelbuecher/_to_delete/cloud_transfer_2026-10-08.tgz -C /tmp gf180_cm_ip__single2diff2single/CLAUDE.md gf180_cm_ip__single2diff2single/HANDOVER_gf180_migration.md gf180_cm_ip__single2diff2single/macros/ClassABBias/README.md gf180_cm_ip__single2diff2single/macros/ClassABBias/schematic/xschem/xschemrc gf180_cm_ip__single2diff2single/macros/ClassABDriver/scripts/check_classab_port.py gf180_cm_ip__single2diff2single/macros/PadEnable/README.md gf180_cm_ip__single2diff2single/macros/PadEnable/scripts/gen_padenable.py gf180_cm_ip__single2diff2single/macros/PadEnable/scripts/padenable_reference.spice && cd /tmp/gf180_cm_ip__single2diff2single && md5sum CLAUDE.md HANDOVER_gf180_migration.md macros/ClassABBias/README.md macros/ClassABBias/schematic/xschem/xschemrc macros/ClassABDriver/scripts/check_classab_port.py macros/PadEnable/README.md macros/PadEnable/scripts/gen_padenable.py macros/PadEnable/scripts/padenable_reference.spice | cut -c1-32 | tr '\n' ' '
```

</details>

All eight files to be overwritten are unchanged since the snapshot. Backup on the computer first (copied there, as the previous session did):

*[Back up the files to be overwritten into the notes worktree (on the computer; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt && B=gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-09_before_bandgap_reference && mkdir -p $B && cd gf180_cm_ip__single2diff2single && for f in CLAUDE.md HANDOVER_gf180_migration.md macros/ClassABBias/README.md macros/ClassABBias/schematic/xschem/xschemrc macros/ClassABDriver/scripts/check_classab_port.py macros/PadEnable/README.md macros/PadEnable/scripts/gen_padenable.py macros/PadEnable/scripts/padenable_reference.spice; do mkdir -p ../$B/$(dirname $f) && cp -p $f ../$B/$f; done && cd ../$B && find . -type f | sort | xargs md5sum | tee MANIFEST.md5 | wc -l && printf 'Copies of the files of the design repository as found on 2026-10-09 00:55, before the bandgap-reference delivery of session 01Btt65c overwrote them (MANIFEST.md5: checksums).\n' > README.txt
```

</details>

*[Wait for the DNW CACE run (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 240; cat /home/claude/work/logs/cace_all_progress.txt; grep -o "Parameter [a-z_]*:" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBGdn.out | tail -1
```

</details>

*[Wait for the DNW CACE run (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 290; cat /home/claude/work/logs/cace_all_progress.txt | tail -2; grep -o "Parameter [a-z_]*:" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBGdn.out | tail -1
```

</details>

*[Wait for the DNW CACE run (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 295; cat /home/claude/work/logs/cace_all_progress.txt | tail -2; grep -o "Parameter [a-z_]*:" /home/claude/work/logs/2026-10-09_fable_cace_ClassABBiasBGdn.out | tail -1
```

</details>

*[Read the DNW results and its mismatch sigma (in the cloud container; error).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && grep "ngspice" results/ClassABBiasBGdn/summary.md results/ClassABBiasBGdnTree/summary.md | sed 's/results\///; s/summary.md://' | awk -F'|' '{printf "%-28s %10s %10s %10s %s\n", $2, $6, $8, $10, $11}'; for r in _runs/RUN_2026-10-09_00-4[89]* _runs/RUN_2026-10-09_00-5*; do [ -d $r/parameters/mm_params ] && echo "$r: $(python3 ../../scripts/mm_sigma.py $r/parameters/mm_params)"; done
```

</details>

*[Sigma of the DNW variant and provenance headers on the result summaries (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias/verification/cace && ls -d _runs/RUN_*; for r in _runs/RUN_*; do [ -d $r/parameters/mm_params ] && [ -d $r/parameters/off_params ] && echo "$r: $(python3 ../../scripts/mm_sigma.py $r/parameters/mm_params)"; done; for c in ClassABBiasBG ClassABBiasBGTree ClassABBiasBGdn ClassABBiasBGdnTree; do sed -i "1i <!-- CACE run $(grep -l . results/$c/summary.md >/dev/null; echo) in Claude's cloud container, 2026-10-09: CACE 2.13, ngspice-47, xschem 3.4.8RC ddc73448, gf180mcuD open_pdks 1689ac3 (ciel). Session 01Btt65c, log _sudelbuecher/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md. -->" results/$c/summary.md; done; head -2 results/ClassABBiasBGdn/summary.md
```

</details>

*[Fill the DNW and tree numbers into the README (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work/gf180_cm_ip__single2diff2single/macros/ClassABBias && sed -i 's/<!-- CACE run  in/<!-- CACE run in/' verification/cace/results/*/summary.md && python3 - <<'EOF'
p = 'README.md'; s = open(p).read()
s = s.replace("| MOS corners × 3.0/3.3/3.6 V × −40/27/125 °C | ±3 % | −1.6 … +1.7 % | −1.5 … +1.9 % |", "| MOS corners × 3.0/3.3/3.6 V × −40/27/125 °C | ±3 % | −1.6 … +1.7 % | −1.5 … +1.9 % |")
s = s.replace("| DC line sensitivity, 3.0 → 3.6 V, all corners × temp | ≤ 1 %/V | 0.0 … 0.42 %/V | 0.4 … 0.6 %/V |", "| DC line sensitivity, 3.0 → 3.6 V, MOS × res corners × temp | ≤ 1 %/V | 0.0 … 0.42 %/V | 0.11 … 0.58 %/V |")
s = s.replace("| mismatch, 100 runs (MOS + PNP; the PDK has no resistor mismatch) | σ ≤ 2 % | σ 1.06 %, extremes −1.2 / +4.0 % | σ ≈ 1.1 % |", "| mismatch, 100 runs (MOS + PNP; the PDK has no resistor mismatch) | σ ≤ 2 % | σ 1.06 %, extremes −1.2 / +4.0 % | σ 1.15 %, −1.2 / +4.4 % |")
s = s.replace("| disabled (en = 0), 3.0–3.6 V, −40…125 °C | — | I_dd 0.02–0.24 nA, iout ≤ 0.07 nA | same |", "| disabled (en = 0), 3.0–3.6 V, −40…125 °C | — | I_dd 0.02–0.24 nA, iout ≤ 0.07 nA | I_dd ≤ 1.3 nA (well junctions) |")
s = s.replace("| with the tree (`…BGTree`): six lines over MOS corners × V × T | ±5 % (placeholder) | see `results/ClassABBiasBGTree/` | |", "| with the tree (`…BGTree`): six lines over MOS corners × V × T | ±5 % (placeholder) | −3.0 … +3.7 % (`ClassABBiasIn` with an ideal 5 µA: −1.7 … +2.9 %); I_dd 34–36 µA | −3.0 … +3.9 % |")
open(p, 'w').write(s)
EOF
grep -c "ClassABBiasBGdnTree\|−3.0 … +3.7" README.md
```

</details>

Now the final log entry, the chat log export, and the delivery.

*[Write the closing log entries (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/claude/work && python3 - <<'EOF'
p = 'deliver/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md'; s = open(p).read()
s += """
## 01:03 — CACE complete, all four datasheets (`verification/cace/results/<cell>/`, logs `logs/main/2026-10-09_fable_cace_*.out`)

| | `ClassABBiasBG` | `ClassABBiasBGdn` |
|---|---|---|
| dc_params, 45 points, limit ±3 % | −1.61 … +1.66 % ✅ | −1.45 … +1.92 % ✅ |
| spread_params (res × bjt × T) | −22.9 … +37.9 % | −22.7 … +38.1 % |
| line_params (5 MOS × 3 res × 3 T), limit 1 %/V | −0.005 … +0.416 %/V ✅ | 0.107 … 0.582 %/V ✅ |
| tran_startup_params, 60 runs | t ≤ 1.29 µs after the 1 µs ramp, ≥ 125 µs before the 1 ms ramp ends; e_end = dc ✅ | ≤ 1.32 µs / ≥ 125 µs ✅ |
| mm_params, 100 runs | σ 1.06 %, mean +1.29, −1.2 / +4.0 % ✅ | σ 1.15 %, mean +1.45, −1.2 / +4.4 % ✅ |
| off_params (2 V × 3 corners × 3 T) | I_dd 0.02–0.24 nA, iout ≤ 0.07 nA | I_dd 0.03–1.26 nA (the well junctions at 125 °C), iout ≤ 0.07 nA |
| `…Tree` tree_params, six lines, 45 points, ±5 % placeholder | −3.0 … +3.7 %, I_dd 33.8–35.5 µA ✅ | −3.0 … +3.9 % ✅ |

Run times on two cores: BG 15 min (start-up 10 min), Tree 20 s, BGdn 15 min, dnTree 20 s. The summaries carry a
provenance comment line as the 2026-10-08 ones. Result folders hold `summary.md`, one csv per parameter and the plots.

## 01:10 — delivery

- Backup of the 8 files overwritten in the design repo (as found on the computer, checksums identical to the 23:28
  snapshot): `sudelbuecher/backups/2026-10-09_before_bandgap_reference/` with `MANIFEST.md5`.
- Design repo: 36 new or changed files (sheets, symbols, scripts, datasheets, templates, READMEs, handover, CLAUDE.md,
  checker) plus the four result folders, written with `device_commit_files` (mtime guards on the existing ones);
  checksums verified on the computer (`logs/main/2026-10-09_fable_bandgap_delivery.md5`; the PNG plots get the
  provenance stamp in transit, so their md5 differ — not compared pixel-wise this time, they are CACE plots).
- Makefile change as `deliveries/2026-10-09_fable_makefile.zip` (one line, `CACE_CELLS`; installer as on 2026-10-08,
  tested on a copy).
- Notes worktree: this log, the CACE logs, the sizing harness results (`logs/main/2026-10-09_fable_sizing_*.txt`,
  `…driver_with_bg.txt`), `kickoffs/2026-10-08_reference_redesign/tools/bg_gf.spice`, `run_bg.py`, `tune_r.py`
  (the sizing harness, with the final sizes as defaults), the chat log `chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md`
  (+ README index line), `chatlog/ref/` pointer file.
- The transfer archive `_to_delete/cloud_transfer_2026-10-08.tgz` (13 MB) in the notes worktree can be deleted.
- No git commands were run. No memory writes.

Open for Christoph: (1) DNW or not — `ClassABBiasBGdn` is drawn and characterised, the choice is a layout/noise
decision; (2) the resistor spread (±25 % → −19/+36 %, I_Q 172/286 µA) is the dominant error: trim, or accept, or
a resistor type with tighter spread (1k/2k: ±20 %); (3) the pad does not instantiate the reference yet (iref pin);
(4) layout: the PNP array (9 × 25 µm² common-centroid), the resistor strips (308 µm at 1 µm), the 48/4 mirrors.
"""
open(p, 'w').write(s)
EOF
ls deliver/sudelbuecher/logs/main/
```

</details>

*[Stage all deliverables and export the chat log (in the cloud container; error).]*

<details><summary>command</summary>

```sh
set -e; cd /home/claude/work && O=/mnt/user-data/outputs/bandgap_delivery && rm -rf $O && mkdir -p $O/repo $O/notes/sudelbuecher/logs/main $O/notes/sudelbuecher/chatlog/ref $O/notes/sudelbuecher/deliveries $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools
# repo files
cd gf180_cm_ip__single2diff2single && for f in $(cat /tmp/newfiles.txt); do mkdir -p $O/repo/$(dirname $f); cp $f $O/repo/$f; done
for c in ClassABBiasBG ClassABBiasBGTree ClassABBiasBGdn ClassABBiasBGdnTree; do mkdir -p $O/repo/macros/ClassABBias/verification/cace/results/$c; cp macros/ClassABBias/verification/cace/results/$c/* $O/repo/macros/ClassABBias/verification/cace/results/$c/; done
cd /home/claude/work
# notes
cp deliver/sudelbuecher/logs/main/*.md $O/notes/sudelbuecher/logs/main/
cp logs/2026-10-09_fable_cace_ClassABBias*.out $O/notes/sudelbuecher/logs/main/
cp logs/cace_ClassABBiasIn_rerun.out $O/notes/sudelbuecher/logs/main/2026-10-08_fable_cace_ClassABBiasIn_rerun.out
cp logs/cace_ClassABDriverBiased_rerun.out $O/notes/sudelbuecher/logs/main/2026-10-08_fable_cace_ClassABDriverBiased_rerun.out
cp logs/sizing_3k_bg_core.txt $O/notes/sudelbuecher/logs/main/2026-10-09_fable_sizing_bg_core.txt
cp logs/sizing_3k_bg_core_dn.txt $O/notes/sudelbuecher/logs/main/2026-10-09_fable_sizing_bg_core_dn.txt
cp logs/driver_with_bg.txt $O/notes/sudelbuecher/logs/main/2026-10-09_fable_driver_with_bg.txt
cp sizing/bg_gf.spice sizing/run_bg.py sizing/tune_r.py $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/
cp deliver_pkg/2026-10-09_fable_makefile.zip $O/notes/sudelbuecher/deliveries/
cat > $O/notes/sudelbuecher/chatlog/ref/2026-10-08_fable_gf180_bandgap_reference_redesign.md <<'EOF'
<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# External sources used by the 2026-10-08/09 bandgap reference session (indexed, not copied)

- H. Banba et al., "A CMOS bandgap reference circuit with sub-1-V operation," IEEE JSSC 34(5), 1999 — the current-mode core (as the IHP `bg_core`).
- Self-biased wide-swing cascode mirror with a resistor between the gate lines: R. J. Baker, *CMOS Circuit Design, Layout, and Simulation*, ch. 20 (wide-swing current mirrors).
- gf180mcuD PDK (open_pdks 1689ac3 via ciel): `libs.tech/ngspice/sm141064.ngspice` (device models, mismatch, PNP, well diodes, resistors), `libs.tech/klayout/tech/drc/rule_decks/{dnwell,lvpwell,nwell,hres,pres}.rb` (DNW / p-well / resistor rules), `libs.tech/klayout/tech/lvs/rule_decks/{mos_extraction,diode_extraction}.lvs` (how LVS sees a DNW NMOS and the well diodes).
- Tool sources per `sg13cmos5l_…_sudelbuecher/sudelbuecher/cloud_environment.md` (xschem ddc73448, ngspice-47 mirror, ciel release asset).
EOF
# tools README addition
cat >> $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md <<'EOF'

## 2026-10-09 — bandgap sizing (session 01Btt65c)

| file | content |
|---|---|
| `bg_gf.spice` | `bg_core` / `bg_core_dn` (the GF180 bandgap core as sized; `.param` knobs at the top, defaults = the delivered `ClassABBiasBG`) and `d2s_bias_bg` / `d2s_bias_bgdn` with the tree |
| `run_bg.py` | sections `temp corners line startup mc` of one variant: `python3 run_bg.py var=bg_core_dn wp=48u line`; `RMODEL=ppolyf_u_1k` swaps the resistor type |
| `tune_r.py` | PTAT-share scan of the resistor lengths for a resistor type (`python3 tune_r.py bg_core 3k`) |

The driver with the reference: `run_gf.py` with `bias="Xb vdd 0 vddo vsso vbp vbn vbpc vbnc vabp vabn d2s_bias_bg"` and
`extra` including `bias_ref_gf.spice`, `bg_gf.spice` and the bjt/diode model sections (see the log, 00:30).
EOF
cp gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md /tmp/tools_readme_orig.md
python3 -I gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py ~/.claude/projects/-home-claude/669e0843-1ea7-5638-8c5d-93eca71fd6cf.jsonl $O/notes/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md "GF180 bandgap reference redesign (ClassABBiasBG)" 669e0843-1ea7-5638-8c5d-93eca71fd6cf claude-fable-5-1
# chatlog README index line
cp gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/README.md $O/notes/sudelbuecher/chatlog/README.md
tail -5 $O/notes/sudelbuecher/chatlog/README.md
```

</details>

*[Read the chat-log index and mtimes of notes files to extend (on the computer; 14 lines of output).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher && cat chatlog/README.md; ls chatlog/ref; stat -c '%Y %n' chatlog/README.md kickoffs/2026-10-08_reference_redesign/tools/README.md
```

</details>

*[Finish staging and compute checksums (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
O=/mnt/user-data/outputs/bandgap_delivery && python3 - <<EOF
import subprocess
EOF
cat > /tmp/chatlog_readme.md <<'EOF'
# Chatlog index

One `[file](file)` + one sentence per log. The logs are made with [`export_chatlog.py`](export_chatlog.py)
(usage and conventions: `CLAUDE.md` at the worktree root).

[2026-10-06_sonnet_gf180_port_survey_and_skeleton.md](2026-10-06_sonnet_gf180_port_survey_and_skeleton.md)
: Survey of the GF180 template copy and the IHP design, search for the GF180 harness and analog pad, process options from Tim Edwards, and the proposal and first files of the GF180 repo and this worktree.

[2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md](2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md)
: Port of the IHP Oguey–Aebischer bias to GF180 in 03v3 and 06v0 variants with re-derived sizes, CACE suites built and run in a cloud toolchain, CDM input front end and input-range deck for gf180mcu_IOPadSingle2Diff, and the restore of the 2026-10-06 schematic versions (06–08 October).

[2026-10-08_fable_gf180_bandgap_reference_redesign.md](2026-10-08_fable_gf180_bandgap_reference_redesign.md)
: GF180 re-design of the class-AB driver's bandgap reference (ClassABBiasBG, wide-swing cascode, 3k poly resistors, deep-n-well variant compared), RefCoreEnable, round trip and four CACE suites, driver with the real reference (8–9 October).
EOF
cp /tmp/chatlog_readme.md $O/notes/sudelbuecher/chatlog/README.md && cd $O && find . -type f | wc -l && find . -type f | sort > /tmp/delivery_list.txt && (cd $O/repo && find . -type f | sort | xargs md5sum) > /tmp/repo.md5 && (cd $O/notes && find . -type f | sort | xargs md5sum) > /tmp/notes.md5 && wc -l /tmp/repo.md5 /tmp/notes.md5 && grep -c "^## Turn" $O/notes/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md
```

</details>

*[Fix the tools README and prepare the commit lists (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
O=/mnt/user-data/outputs/bandgap_delivery && cd /home/claude/work && cat gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md > /tmp/tr.md && mv /tmp/tr.md $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md && head -3 $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md && grep -c "2026-10-09" $O/notes/sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md && (cd $O/notes && find . -type f | sort | xargs md5sum) > /tmp/notes.md5 && python3 - <<'EOF'
import json, os
O='/mnt/user-data/outputs/bandgap_delivery'
mt = {'CLAUDE.md':1791486859,'HANDOVER_gf180_migration.md':1791488797,'macros/ClassABBias/README.md':1791486861,'macros/ClassABBias/schematic/xschem/xschemrc':1791486865,'macros/ClassABDriver/scripts/check_classab_port.py':1791486882,'macros/PadEnable/README.md':1791486938,'macros/PadEnable/scripts/gen_padenable.py':1791486943,'macros/PadEnable/scripts/padenable_reference.spice':1791486944}
files=[]
for root,_,fs in os.walk(O+'/repo'):
    for f in fs:
        p=os.path.join(root,f); rel=os.path.relpath(p,O+'/repo')
        d={'stagedPath':p,'devicePath':'/home/cmaier/EDA/gf180_cm_ip__single2diff2single/'+rel}
        if rel in mt: d['expectedMtimeMs']=mt[rel]*1000
        files.append(d)
json.dump(files,open('/tmp/commit_repo.json','w'))
mtn={'sudelbuecher/chatlog/README.md':1791421745,'sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md':1791491924}
files=[]
for root,_,fs in os.walk(O+'/notes'):
    for f in fs:
        p=os.path.join(root,f); rel=os.path.relpath(p,O+'/notes')
        d={'stagedPath':p,'devicePath':'/home/cmaier/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/'+rel}
        if rel in mtn: d['expectedMtimeMs']=mtn[rel]*1000
        files.append(d)
json.dump(files,open('/tmp/commit_notes.json','w'))
print(len(json.load(open('/tmp/commit_repo.json'))), len(files))
EOF
cat /tmp/commit_repo.json | head -c 600
```

</details>

*[Split the repo commit list into two calls (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
python3 -c "
import json; f=json.load(open('/tmp/commit_repo.json')); print(json.dumps(f[:31])); print('=====SPLIT====='); print(json.dumps(f[31:]))" > /tmp/split.txt; python3 -c "
import json; f=json.load(open('/tmp/commit_repo.json'));
json.dump(f[:31],open('/tmp/c1.json','w')); json.dump(f[31:],open('/tmp/c2.json','w'))"; cat /tmp/c1.json
```

</details>

*[Copied 31 files from the cloud container to the computer (error).  
Copied 4 files from the cloud container to the computer (1 lines of output).]*

*[Print the second repo batch (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cat /tmp/c2.json | python3 -c "
import json,sys; f=json.load(sys.stdin); print(json.dumps(f))"
```

</details>

*[Copied 31 files from the cloud container to the computer (error).]*

*[Check whether the checker script changed on the computer (on the computer; error).]*

<details><summary>command</summary>

```sh
cd $HOME/mnt/gf180_cm_ip__single2diff2single && date; stat -c '%y %s' macros/ClassABDriver/scripts/check_classab_port.py; md5sum macros/ClassABDriver/scripts/check_classab_port.py; diff <(cat ../gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/backups/2026-10-09_before_bandgap_reference/macros/ClassABDriver/scripts/check_classab_port.py) macros/ClassABDriver/scripts/check_classab_port.py && echo SAME_AS_BACKUP
```

</details>

*[Copied 1 files from the computer to the cloud container (1 lines of output).]*

*[Merge my checker changes onto the newer version from the computer and re-verify (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
sleep 3; cd /home/claude/work && cp /mnt/user-data/uploads/gf180_cm_ip__single2diff2single/macros/ClassABDriver/scripts/check_classab_port.py /tmp/check_new.py && python3 - <<'EOF'
s = open('/tmp/check_new.py').read()
s = s.replace("mods = [x for x in t if x in ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k')]", "mods = [x for x in t if x in MODELS]")
s = s.replace("FLATTEN = {'d2s_bias_diodes'}", "FLATTEN = {'d2s_bias_diodes'}\nMODELS = ('nfet_03v3', 'pfet_03v3', 'ppolyf_u_3k', 'ppolyf_u_1k', 'pnp_05p00x05p00', 'pnp_10p00x10p00')  # 2026-10-09: + 1k, PNPs")
s = s.replace("elif t[0][0] in 'VvIiRrCc':", "elif t[0][0] in 'VvIiRrCcDd':")
s = s.replace("if a[1] == 'ppolyf_u_3k' and a[0] == 'dev' and pa[:2] != pb[:2] and pa[:2] == pb[1::-1]:", "if a[1].startswith('ppolyf') and a[0] == 'dev' and pa[:2] != pb[:2] and pa[:2] == pb[1::-1]:")
s = s.replace("ka = {'W': 'W', 'L': 'L', 'nf': 'nf', 'm': 'm'} if a[1] != 'ppolyf_u_3k' else {'r_width': 'r_width', 'r_length': 'r_length'}",
              "ka = ({'r_width': 'r_width', 'r_length': 'r_length'} if a[1].startswith('ppolyf') else {'m': 'm'} if a[1].startswith('pnp') else {'W': 'W', 'L': 'L', 'nf': 'nf', 'm': 'm'})")
assert s.count('MODELS') == 2 and "'VvIiRrCcDd'" in s and s.count("startswith('ppolyf')") == 2, 'merge failed'
s = s.replace("Interchangeable terminals are not mismatches: P/M of a resistor, drain/source of a MOSFET (reported as a note).",
              "Interchangeable terminals are not mismatches: P/M of a resistor, drain/source of a MOSFET (reported as a note).\n2026-10-09 (bandgap session): also PNPs (m compared), ppolyf_u_1k, and D primitives (nets compared).")
open('/mnt/user-data/outputs/bandgap_delivery/repo/macros/ClassABDriver/scripts/check_classab_port.py', 'w').write(s)
EOF
cp /mnt/user-data/outputs/bandgap_delivery/repo/macros/ClassABDriver/scripts/check_classab_port.py gf180_cm_ip__single2diff2single/macros/ClassABDriver/scripts/check_classab_port.py && source /home/claude/tools/env.sh && cd gf180_cm_ip__single2diff2single/macros/ClassABBias/schematic/xschem && for c in ClassABBiasBG ClassABBiasBGdn; do python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/bg_reference.spice /tmp/bgnet/$c.spice $c $c | tail -1; done; python3 ../../../ClassABDriver/scripts/check_classab_port.py ../../scripts/bg_reference.spice /tmp/bgnet/bad.spice ClassABBiasBG ClassABBiasBG | tail -1
```

</details>

*[Copied 4 files from the cloud container to the computer (1 lines of output).]*

Repo delivered (62 files). Now the notes worktree, with the log amended for the checker merge first.

*[Finalize the log, checksum list and chat log; list the notes files (in the cloud container).]*

<details><summary>command</summary>

```sh
cd /home/claude/work && O=/mnt/user-data/outputs/bandgap_delivery && python3 - <<'EOF'
p='/mnt/user-data/outputs/bandgap_delivery/notes/sudelbuecher/logs/main/2026-10-08_fable_reference_redesign_log.md'; s=open(p).read()
s = s.replace("- No git commands were run. No memory writes.", """- `check_classab_port.py` had been edited on the computer at 00:59 (drain/source swap accepted as a note) after the
  23:28 snapshot; the mtime guard rejected the write, the newer version was staged and my changes (PNPs, 1k, D primitives)
  merged onto it, round trip re-run (0 / 0 / 2 as before), then written. The backup folder holds the pre-00:59 version.
- The mtime guards need the millisecond value the bridge reports (`deviceMtimeMs`), not `stat %Y` × 1000.
- No git commands were run. No memory writes.""")
open(p,'w').write(s)
EOF
(cd $O/repo && find . -type f | sort | xargs md5sum) > $O/notes/sudelbuecher/logs/main/2026-10-09_fable_bandgap_delivery.md5 && cp $O/repo/macros/ClassABDriver/scripts/check_classab_port.py /dev/null && python3 -I gf180_cm_ip__single2diff2single_sudelbuecher/sudelbuecher/chatlog/export_chatlog.py ~/.claude/projects/-home-claude/669e0843-1ea7-5638-8c5d-93eca71fd6cf.jsonl $O/notes/sudelbuecher/chatlog/2026-10-08_fable_gf180_bandgap_reference_redesign.md "GF180 bandgap reference redesign (ClassABBiasBG)" 669e0843-1ea7-5638-8c5d-93eca71fd6cf claude-fable-5-1 && python3 - <<'EOF'
import json, os
O='/mnt/user-data/outputs/bandgap_delivery/notes'
mtn={'sudelbuecher/chatlog/README.md':1791421745,'sudelbuecher/kickoffs/2026-10-08_reference_redesign/tools/README.md':1791491924}
files=[]
for root,_,fs in os.walk(O):
    for f in fs:
        p=os.path.join(root,f); rel=os.path.relpath(p,O)
        d={'stagedPath':p,'devicePath':'/home/cmaier/EDA/gf180_cm_ip__single2diff2single_sudelbuecher/'+rel}
        files.append(d)
print(json.dumps(files))
EOF
```

</details>
