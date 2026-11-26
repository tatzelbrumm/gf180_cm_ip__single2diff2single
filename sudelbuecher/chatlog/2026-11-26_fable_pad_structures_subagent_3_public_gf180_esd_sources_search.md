<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Subagent 3 of the session "session_01XU3KH8TTLjkQNhWPaFJmRL": Public GF180 ESD sources search (agent type general-purpose). The message shown as "User" is the brief written by the main session's assistant, not a message from Christoph; the subagent's final report went back through a hand-back call and is filed verbatim in sudelbuecher/logs/

Session `session_01XU3KH8TTLjkQNhWPaFJmRL, subagent 3`, Claude (configured model `claude-fable-5-2`; the serving model may differ).
Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;
tool calls as `*[ ]*` summaries (actions and observable results only); shell commands verbatim in collapsed blocks, their output omitted.
The internal reasoning trace is not included.
Times are Europe/Berlin. Exported through the record stamped 2026-11-26 16:14; later turns are not in this file.

## Turn 1 — 15:46

**User:**

Research task (web search and reading only; do not modify any repository, do not push anything, do not include any personal names, e-mail addresses or project names of the requester in search queries or requests).

Background. An open-source analog chip is being designed in GlobalFoundries GF180MCU (0.18 um, 3.3 V and 5 V/6 V devices, open PDK `gf180mcu`, variant D) for a multi-project shuttle. Its pads are the cells of the open I/O libraries `gf180mcu_fd_io` (foundry, 5 V) and `gf180mcu_ocd_io` (a dual-voltage derivative by Tim Edwards / Open Circuit Design); the analog pad is `asig_5p0`, which contains only two groups of ESD diodes (4 fingers of 3 um x 50 um each, P+/n-well to DVDD and N+/p-substrate from DVSS) and no other protection. What is already known and does NOT need to be searched again:
- The GF180MCU design manual chapter 14 (gf180mcu-pdk.readthedocs.io, physical_verification/design_manual/drm_14_4 ... drm_14_5_8): TLP data for test structures (5V/6V N+/PWELL diode ~30 mA/um It2, ~6.7 V; P+/NWELL ~31 mA/um, ~6.9 V; GGNMOS Vt1 ~10.7 V, Vsp ~6.2 V, It2 ~7 mA/um; GGPMOS Vt1 ~9.7 V, It2 ~5.3 mA/um) and layout guidelines (HVNESD/HVPESD rules, diode junction width >= 0.9 um, recommended max finger length 25 um), I/O latch-up rules IO.1-IO.4.
- The I/O library datasheet: targets HBM 2000 V, MM 200 V, CDM 500 V, latch-up +/-100 mA; the statement that the analog pads contain only HBM diodes and the user must add a CDM network (resistor > 50 ohm, diode perimeter > 25 um).
- The page evampire.readthedocs.io/en/latest/esd/io-cells.html (an unreviewed write-up).

Goal. Find OTHER publicly available information (not trade secrets, not paywalled-leak material; published papers, public datasheets, application notes, open-source project documentation, public issue trackers, conference slides, public standards summaries) that helps answer these questions. For each item give: the URL, the title/author/date, a short verbatim quote (under 25 words) or exact numbers with units, and whether it is (a) measured silicon data, (b) a foundry/vendor target or spec, (c) simulation, or (d) general guidance. Say plainly when you searched and found nothing.

Questions, in priority order:
1. Any MEASURED ESD results (HBM, CDM, MM, TLP, latch-up) for chips made in GF180MCU with the open I/O cells: e.g. Efabless/chipIgnite/Caravel GF180 (caravel-gf180mcu), GFMPW-0/GFMPW-1 shuttle projects, wafer.space runs, Tiny Tapeout GF180 runs, university test chips, Open Circuit Design / Tim Edwards notes, FOSSi / Chipalooza material. Also search GitHub issues/discussions of google/gf180mcu-pdk, google/globalfoundries-pdk-libs-gf180mcu_fd_io, RTimothyEdwards/gf180mcu_ocd_io, efabless/caravel-gf180mcu, wafer-space/gf180mcu for "ESD", "HBM", "CDM", "snapback", "latch-up", "asig_5p0".
2. Any public GlobalFoundries (or former Chartered Semiconductor) 0.18 um "Green"/MCU/BCDLite-family documentation or papers with ESD device characterization: TLP of diodes, GGNMOS, RC clamps, 5 V/6 V devices; ESD design-kit descriptions; ESD implant option. Note that GF180MCU descends from Chartered's 0.18 um process; papers from Chartered/GF/A*STAR/NTU/IME authors on 0.18 um 5 V/6 V ESD are relevant if they clearly concern this process family (say how sure that link is).
3. Public, citable rules of thumb for sizing what a user must add behind a diode-only analog pad: secondary (CDM) protection resistor and diode sizing, HBM/CDM peak currents and time scales (ANSI/ESDA/JEDEC JS-001, JS-002 summaries; ESDA or Industry Council on ESD Target Levels white papers on recommended HBM/CDM target levels, e.g. 1 kV HBM / 250 V CDM), diode current capability per um perimeter in 0.18 um CMOS from published TLP papers, metal line current limits for ESD pulses (e.g. published mA/um for 100 ns pulses in Al or Cu), gate-oxide breakdown under short pulses (TDDB/TLP of ~12-15 nm oxide for 5 V/6 V devices and ~6.5-7 nm oxide for 3.3 V devices).
4. Other open PDKs' documentation of the same things, as method comparison only: SkyWater sky130 I/O (sky130_fd_io) ESD documentation, IHP SG13G2 open PDK I/O cells (sg13g2_io) ESD documentation or measured results.
5. Anything public that says the gf180mcu_fd_io or gf180mcu_ocd_io pads were or were not silicon-tested for ESD, or known ESD/latch-up failures on GF180 open-shuttle chips.

Method notes: use web search with several differently worded queries per question; open the most promising results and read them rather than trusting snippets; prefer primary sources. Do not report a number unless you saw it on the page. Keep quotes short. Separate clearly what a source states from your own inference. End with (i) a table of the most useful findings (source, kind a-d, key numbers, relevance to a 3 um x 50 um x 4 diode pad and to user-added secondary protection), (ii) a list of what you looked for and did not find, (iii) the list of search queries you ran.

**Assistant:**

*[Called ToolSearch (0 lines of output).  
Searched the web for "GF180MCU ESD measured HBM results caravel gf180mcu_fd_io silicon test".  
Searched the web for "gf180mcu_fd_io ESD "HBM" OR "CDM" OR "snapback" github issue".  
Searched the web for "gf180mcu_ocd_io asig_5p0 ESD diodes analog pad Tim Edwards" (14 lines of output).]*

*[Search public GitHub issue trackers for ESD keywords (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for q in "ESD" "HBM" "CDM" "snapback" "latch-up" "latchup" "asig_5p0"; do for r in google/gf180mcu-pdk google/globalfoundries-pdk-libs-gf180mcu_fd_io RTimothyEdwards/gf180mcu_ocd_io efabless/caravel-gf180mcu wafer-space/gf180mcu efabless/globalfoundries-pdk-libs-gf180mcu_fd_io; do echo "=== $r :: $q"; gh search issues "$q" --repo "$r" --include-prs --limit 30 --json number,title,url,state,createdAt --jq '.[] | "\(.number)\t\(.state)\t\(.createdAt[0:10])\t\(.title)\t\(.url)"' 2>&1 | head -30; done; done
```

</details>

*[Search gf180mcu-pdk issues for ESD via REST API (in the cloud container; 1 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && gh api "search/issues?q=ESD+repo:google/gf180mcu-pdk&per_page=50" --jq '.total_count, (.items[] | "\(.number)\t\(.state)\t\(.created_at[0:10])\t\(.title)\t\(.html_url)")' 2>&1 | head -60
```

</details>

*[Search several public GitHub repos' issues and PRs for ESD keywords (in the cloud container; 42 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for r in google/gf180mcu-pdk google/globalfoundries-pdk-libs-gf180mcu_fd_io RTimothyEdwards/gf180mcu_ocd_io efabless/caravel-gf180mcu wafer-space/gf180mcu efabless/globalfoundries-pdk-libs-gf180mcu_fd_io RTimothyEdwards/open_pdks efabless/caravel_user_project_analog; do for q in ESD HBM CDM snapback latch-up latchup asig_5p0; do for t in issue pull-request; do out=$(gh api "search/issues?q=${q}+repo:${r}+is:${t}&per_page=50" --jq '(.items[] | "\(.number)\t\(.state)\t\(.created_at[0:10])\t\(.title)\t\(.html_url)")' 2>&1); if [ -n "$out" ]; then echo "=== $r :: $q :: $t"; echo "$out" | head -25; fi; sleep 2.2; done; done; done
```

</details>

*[List issues of the I/O library and shuttle repositories (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for r in RTimothyEdwards/gf180mcu_ocd_io wafer-space/gf180mcu wafer-space/gf180mcu-project-template RTimothyEdwards/open_pdks efabless/caravel-gf180mcu google/globalfoundries-pdk-libs-gf180mcu_fd_io; do echo "=== $r"; gh api "repos/$r/issues?state=all&per_page=100" --jq '.[] | "\(.number)\t\(.state)\t\(.created_at[0:10])\t\(.title)"' 2>&1 | head -80; done
```

</details>

*[Search all public GitHub issues for GF180 ESD topics (in the cloud container; 20 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for q in "gf180mcu+ESD+HBM" "gf180+ESD+pad+is:issue" "gf180mcu+asig_5p0" "gf180mcu+latch-up" "gf180mcu+CDM+ESD" "gf180+ESD+clamp" "gf180mcu_ocd_io" "gf180mcu+snapback" "gf180+ESD+org:wafer-space" "ESD+org:wafer-space" "ESD+org:TinyTapeout+gf180" "gf180+ESD+tested+silicon"; do for t in issue pull-request; do case "$q" in *is:issue*) [ $t = pull-request ] && continue; qq="$q";; *) qq="${q}+is:${t}";; esac; out=$(gh api "search/issues?q=${qq}&per_page=40" --jq '(.items[] | "\(.created_at[0:10])\t\(.state)\t\(.title)\t\(.html_url)")' 2>&1); echo "=== $qq"; echo "$out" | head -40; sleep 2.5; done; done
```

</details>

*[Read bwbau5rxm.txt (in the cloud container; 286 lines of output).  
Fetched https://github.com/2AMLogic/gf180-tmds-tx/issues/145 (33 lines of output).  
Searched the web for "Chartered Semiconductor 0.18um ESD characterization TLP GGNMOS 5V 6V devices paper".  
Searched the web for "Tim Edwards gf180mcu I/O pads ESD "not been tested" OR "silicon proven" OR "untested" gf180mcu_fd_io".  
Searched the web for "Industry Council on ESD Target Levels white paper 1 recommended HBM 1 kV CDM 250 V peak current".  
Searched the web for "sky130_fd_io ESD documentation HBM CDM tested silicon skywater I/O pads ESD rating" (17 lines of output).  
Searched the web for ""GF180" OR "gf180mcu" open-source chip "ESD" "HBM" measured test results passed 2 kV test chip paper".  
Searched the web for "gf180mcu_ocd_io README dual-voltage I/O library Open Circuit Design ESD".  
Searched the web for "GFMPW-0 caravel gf180 silicon bring-up results I/O pads issue latch-up ESD failure".  
Searched the web for "Tiny Tapeout GF180 ESD protection pads "ESD" gf180mcu wafer.space run silicon results" (15 lines of output).  
Fetched https://github.com/RTimothyEdwards/gf180mcu_ocd_io.  
Fetched https://tinytapeout.com/news/wafer-space-gf180/ (error).  
Fetched https://github.com/efabless/caravel-gf180mcu/issues/59.  
Fetched https://github.com/fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_pv/issues/33 (12 lines of output).]*

*[Fetch the dual-voltage I/O library README from GitHub raw (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for u in https://raw.githubusercontent.com/RTimothyEdwards/gf180mcu_ocd_io/main/README.md https://raw.githubusercontent.com/RTimothyEdwards/gf180mcu_ocd_io/main/README https://raw.githubusercontent.com/RTimothyEdwards/gf180mcu_ocd_io/master/README.md; do echo "== $u"; curl -sS -m 30 -w "\nHTTP %{http_code}\n" "$u" | head -150; done
```

</details>

*[Shallow-clone the public I/O library into the scratchpad to read its docs and history (in the cloud container; 54 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad; mkdir -p $S/dl && cd $S/dl && for r in RTimothyEdwards/gf180mcu_ocd_io; do n=$(basename $r); [ -d $n ] || git clone --depth 50 -q https://github.com/$r.git $n 2>&1 | tail -3; done; ls $S/dl/gf180mcu_ocd_io 2>&1 | head; cd $S/dl/gf180mcu_ocd_io 2>/dev/null && git log --format='%h %ad %s' --date=short | head -50
```

</details>

*[Read README, TODO and find ESD-related docs in the cloned I/O library (in the cloud container; 81 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/gf180mcu_ocd_io; cd $S; echo "--- README.rst"; cat README.rst | head -120; echo "--- TODO"; cat TODO | head -80; ls docs | head -40; grep -rIil -E "esd|hbm|cdm|latch" --include=*.rst --include=*.md --include=*.txt --include=*.csv . | head -40
```

</details>

*[Read ESD, analog and power docs of the cloned I/O library (in the cloud container; 120 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/gf180mcu_ocd_io; cd $S; cat docs/esd.rst; echo ----; cat docs/analog.rst; echo ----; cat docs/power.rst | head -60; echo; cat docs/specs/16_ESD_Protection.csv docs/specs/17_Latchup_Immunity.csv; ls cells | head -40; ls cells/asig_5p0 cells/in_c 2>/dev/null
```

</details>

*[Inspect analog pad netlist and input-pad secondary protection devices (in the cloud container; 39 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/gf180mcu_ocd_io; cd $S; echo "--- asig"; cat cells/asig_5p0/gf180mcu_ocd_io__asig_5p0.cdl | grep -v '^\*' | head -40; echo "--- in_c resistors/diodes"; grep -n -i -E "ppolyf|npolyf|nwell |res|diode|^\.subckt" cells/in_c/gf180mcu_ocd_io__in_c.cdl | head -60
```

</details>

*[Inspect which devices connect to the pad node in the digital pad netlists (in the cloud container; 60 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/gf180mcu_ocd_io; cd $S; grep -n -w "PAD" cells/in_c/gf180mcu_ocd_io__in_c.cdl | cut -c1-200 | head -40; echo; grep -c -w PAD cells/in_c/gf180mcu_ocd_io__in_c.cdl; echo "--- bi_t resistors on PAD"; grep -n -E "^R.* PAD |^R[0-9]+ PAD|ppolyf|nplus_u|pplus_u" cells/bi_t/gf180mcu_ocd_io__bi_t.cdl | cut -c1-160 | head -30; echo '--- bi_a'; grep -n -i -E "ASIG|A " cells/bi_a/gf180mcu_ocd_io__bi_a.cdl | cut -c1-160| head -12; echo "--- n15 gate connections in in_c"; grep -n -w n15 cells/in_c/gf180mcu_ocd_io__in_c.cdl | cut -c1-170 | head
```

</details>

*[Searched the web for "Chartered Semiconductor Manufacturing ESD "0.18" "5V" GGNMOS "It2" TLP paper authors Chartered Singapore drain-extended OR "6V" ESD protection".  
Searched the web for "GlobalFoundries 180nm BCDLite OR "180MCU" OR "0.18um green" ESD protection characterization TLP paper IRPS EOS/ESD symposium Singapore" (14 lines of output).  
Searched the web for "Manna Lo "Chartered Semiconductor" ESD "0.18" salicide block NMOS TLP second breakdown paper".  
Searched the web for ""5-V tolerant fail-safe ESD solutions for 0.18" logic CMOS process abstract Chartered".  
Searched the web for "gf180mcu history "Chartered" 0.18um process origin "green" comp018green GlobalFoundries 180MCU descends" (16 lines of output).  
Fetched https://foss-eda-tools.googlesource.com/gf180mcu-pdk/+/e5487e6e031a71444fa4ac07764f33c43201d714/docs/physical_verification/design_manual/tables_clear/02_Process_Identification7.csv (error).  
Searched the web for "GlobalFoundries Singapore authors ESD "0.18" "5V" OR "6V" NMOS diode TLP "It2" "mA/µm" IPFA OR "EOS/ESD" OR "Microelectronics Reliability"" (15 lines of output).  
Fetched https://www.esda.org/assets/IndustryCouncilOnESDTargetLevels_WP1.pdf (error).  
Fetched https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_io/docs/user_guide.html (error).]*

*[Check which web hosts are reachable from this session (in the cloud container; 15 lines of output).]*

<details><summary>command</summary>

```sh
for h in https://gf180mcu-pdk.readthedocs.io/en/latest/ https://www.esda.org/ https://ir.lib.nycu.edu.tw/ https://www.crowdsupply.com/ https://skywater-pdk.readthedocs.io/ https://gitlab.com/ https://arxiv.org/ https://en.wikipedia.org/ https://web.archive.org/ https://api.github.com/ https://raw.githubusercontent.com/google/gf180mcu-pdk/main/README.rst https://codeberg.org/ https://www.jedec.org/ https://ieeexplore.ieee.org/ https://github.com/IHP-GmbH/IHP-Open-PDK; do printf "%s -> " "$h"; curl -sS -o /dev/null -m 15 -w "%{http_code}\n" "$h" 2>&1 | tail -1; done
```

</details>

*[Called mcp__claude-code-remote__get_environment (1 lines of output).]*

*[Blobless shallow clones of public PDK and shuttle repositories for reading docs (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S; for r in google/skywater-pdk-libs-sky130_fd_io IHP-GmbH/IHP-Open-PDK efabless/caravel-gf180mcu wafer-space/gf180mcu-project-template google/skywater-pdk google/gf180mcu-pdk; do n=$(echo $r | tr / _); if [ ! -d $n ]; then timeout 120 git clone -q --depth 1 --filter=blob:none --no-checkout https://github.com/$r.git $n 2>&1 | tail -2; fi; echo "$r: $(cd $n 2>/dev/null && git ls-tree -r --name-only HEAD | wc -l) files"; done
```

</details>

*[List documentation files in the cloned repositories (in the cloud container; 146 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S; for n in google_skywater-pdk-libs-sky130_fd_io IHP-GmbH_IHP-Open-PDK efabless_caravel-gf180mcu wafer-space_gf180mcu-project-template google_skywater-pdk; do echo "=== $n"; (cd $n && git ls-tree -r --name-only HEAD | grep -i -E "\.(rst|md|txt|pdf)$|esd|README" | grep -v -E "^(ihp-sg13g2/libs.ref/sg13g2_stdcell|.*/doc/.*\.html)" | head -60); done
```

</details>

*[Extract ESD-related lines from the sky130 I/O user guide (in the cloud container; 82 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_skywater-pdk-libs-sky130_fd_io && git show HEAD:docs/user_guide.rst > $S/sky130_io_user_guide.rst; wc -l $S/sky130_io_user_guide.rst; grep -n -i -E "esd|hbm|cdm|latch|ohm|Ω|resist" $S/sky130_io_user_guide.rst | cut -c1-260 | head -120
```

</details>

*[Read the ESD design sections of the sky130 I/O user guide (in the cloud container; 155 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; sed -n '160,182p;458,468p;1248,1330p;1468,1476p' $S/sky130_io_user_guide.rst | cut -c1-400; cd $S/google_skywater-pdk && git ls-tree -r --name-only HEAD | grep -i -E "esd|latch|rules/" | head -30
```

</details>

*[Look for ESD-related rule and device documentation in the sky130 PDK docs (in the cloud container; 131 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_skywater-pdk && git ls-tree -r --name-only HEAD | grep -i -E "esd|hv|periphery|wlcsp|reliab|current" | head -30; git show HEAD:docs/rules/device-details/esd_nfet/index.rst | head -40; echo ----; git show HEAD:docs/rules/device-details/esd_nfet/esd_nfet-table0.rst | head -60
```

</details>

*[Search sky130 rule documents for ESD, latch-up and current-density statements (in the cloud container; 25 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_skywater-pdk && for f in docs/rules/periphery-rules.rst docs/rules/assumptions/07-other.csv docs/rules/assumptions/08-hv.csv docs/rules/assumptions/04-physical.csv docs/rules/assumptions/01-general.csv docs/known_issues.rst; do echo "== $f"; git show HEAD:$f | grep -n -i -E "esd|latch|electromig|mA/|current dens|HBM|CDM" | cut -c1-300 | head -20; done; git ls-tree -r --name-only HEAD | grep -i -E "current|em|resist" | head
```

</details>

*[List SG13G2 I/O and ESD documentation files (in the cloud container; 50 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/IHP-GmbH_IHP-Open-PDK && git ls-tree -r --name-only HEAD | grep -E "^ihp-sg13g2/" | grep -i -E "sg13g2_io/(doc|README)|libs.doc|esd" | grep -v testing | head -50
```

</details>

*[Find SG13G2 I/O library docs and ESD device files (in the cloud container; 40 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/IHP-GmbH_IHP-Open-PDK && git ls-tree -r --name-only HEAD | grep -E "^ihp-sg13g2/" | grep -v -E "libs.doc/meas|testing|stdcell|\.(gds|png|svg|sch|sym|lef|lib|v)$" | grep -i -E "sg13g2_io|esd|diode|nmoscl|README" | head -40
```

</details>

*[Read the SG13G2 I/O library README and ESD model header (in the cloud container; 104 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/IHP-GmbH_IHP-Open-PDK && git show HEAD:ihp-sg13g2/libs.ref/sg13g2_io/doc/README.md | head -150; echo ====; git show HEAD:ihp-sg13g2/libs.tech/ngspice/models/sg13g2_esd.lib 2>/dev/null | head -60
```

</details>

*[Search IHP, sky130 and related public issue trackers for ESD topics (in the cloud container; 64 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for r in IHP-GmbH/IHP-Open-PDK google/skywater-pdk efabless/caravel TinyTapeout/tinytapeout-ihp-26a fossi-foundation/open-pdks fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_io RTimothyEdwards/gf180mcu_ocd_chipalooza; do for q in ESD HBM CDM TLP latch-up "ESD+measured"; do for t in issue; do out=$(gh api "search/issues?q=${q}+repo:${r}+is:${t}&per_page=30" --jq '(.items[] | "\(.number)\t\(.state)\t\(.created_at[0:10])\t\(.title)\t\(.html_url)")' 2>&1); if [ -n "$out" ]; then echo "=== $r :: $q :: $t"; echo "$out" | cut -c1-220 | head -30; fi; sleep 2.2; done; done; done
```

</details>

*[Fetched https://github.com/IHP-GmbH/IHP-Open-PDK/issues/12.  
Fetched https://github.com/IHP-GmbH/IHP-Open-PDK/issues/1247.  
Fetched https://github.com/IHP-GmbH/IHP-Open-PDK/issues/401.  
Fetched https://github.com/IHP-GmbH/IHP-Open-PDK/issues/1218 (15 lines of output).]*

*[Search Caravel GF180 and wafer.space template READMEs for ESD or silicon statements (in the cloud container; 18 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/efabless_caravel-gf180mcu && git show HEAD:README.md | grep -n -i -E "esd|silicon|tested|latch|pad|bring" | cut -c1-300 | head -30; cd $S/wafer-space_gf180mcu-project-template && git show HEAD:README.md | grep -n -i -E "esd|silicon|tested|latch|pad|analog|warn" | cut -c1-300 | head -40
```

</details>

*[Read the library status table in the wafer.space template README (in the cloud container; 62 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/wafer-space_gf180mcu-project-template && git log -1 --format='%h %ad' --date=short && git show HEAD:README.md | sed -n '1,20p;96,137p' | cut -c1-330
```

</details>

*[Search GitHub repositories for wafer.space docs and GF180 ESD test projects (in the cloud container; 26 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && gh api "search/repositories?q=org:wafer-space&per_page=50" --jq '.items[] | "\(.full_name)\t\(.pushed_at[0:10])\t\(.description)"' 2>&1 | head -40; echo; gh api "search/repositories?q=gf180mcu+esd&per_page=30" --jq '.items[] | "\(.full_name)\t\(.pushed_at[0:10])\t\(.description)"' 2>&1 | cut -c1-220 | head -30; echo; gh api "search/repositories?q=gf180+esd+test&per_page=30" --jq '.items[] | "\(.full_name)\t\(.pushed_at[0:10])\t\(.description)"' 2>&1 | cut -c1-220 | head -30
```

</details>

*[Search code in wafer.space and related organizations for ESD mentions (in the cloud container; 86 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for q in "ESD+org:wafer-space" "HBM+org:wafer-space" "latch-up+org:wafer-space" "latchup+org:wafer-space" "electrostatic+org:wafer-space" "asig_5p0+org:wafer-space" "ESD+repo:RTimothyEdwards/gf180mcu_ocd_chipalooza" "ESD+repo:TinyTapeout/tinytapeout-gf-0p2" "ESD+org:TinyTapeout+gf180"; do echo "=== $q"; gh api "search/code?q=${q}&per_page=40" --jq '.total_count, (.items[] | "\(.repository.full_name)\t\(.path)")' 2>&1 | cut -c1-200 | head -30; sleep 7; done
```

</details>

*[Read wafer.space site pages mentioning latch-up/ESD and find the Tiny Tapeout I/O fix library (in the cloud container; 44 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for u in https://raw.githubusercontent.com/wafer-space/wafer-space.github.io/HEAD/redirects/latchup25.md https://raw.githubusercontent.com/wafer-space/wafer-space.github.io/HEAD/_design_help/professional/slicesemi.md; do echo "== $u"; curl -sS -m 30 "$u" | head -60 | cut -c1-600; done; echo; gh api "search/code?q=gf180mcu_ht_io_fix&per_page=30" --jq '.total_count, (.items[] | "\(.repository.full_name)\t\(.path)")' 2>&1 | grep -v -E "\.(mag|gds|lef|lib)$" | head -30
```

</details>

*[Scan Tiny Tapeout and wafer.space run READMEs for ESD, failure or handling notes (in the cloud container; 12 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && curl -sS -m 30 https://raw.githubusercontent.com/TinyTapeout/tinytapeout-gf-0p1/HEAD/README.md | grep -n -i -E "io_fix|esd|pad|analog" | cut -c1-300 | head -20; for r in wafer-space/ws-run1 wafer-space/ws-run1-cob wafer-space/wafer.space-bench wafer-space/google-gf180mcu-mpw0 wafer-space/tinytapeouts wafer-space/chip-on-board-wire-bonded-pcbs; do echo "== $r"; curl -sS -m 30 https://raw.githubusercontent.com/$r/HEAD/README.md | grep -n -i -E "esd|electrostatic|latch|damage|fail|dead|yield|silicon-verified|handling" | cut -c1-300 | head -12; done
```

</details>

*[Read the Tiny Tapeout GF 0p1 pad test project description (in the cloud container; 42 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && gh api "search/code?q=repo:TinyTapeout/tinytapeout-gf-0p1+path:src/projects/tt_um_pad_test&per_page=30" --jq '.total_count, (.items[] | .path)' 2>&1 | head -20; curl -sS -m 30 https://raw.githubusercontent.com/TinyTapeout/tinytapeout-gf-0p1/HEAD/main/src/projects/tt_um_pad_test/docs/info.md | head -60 | cut -c1-500; curl -sS -m 30 https://raw.githubusercontent.com/TinyTapeout/tinytapeout-gf-0p1/HEAD/README.md | head -40 | cut -c1-300
```

</details>

*[Searched the web for "ANSI/ESDA/JEDEC JS-001 HBM waveform 100 pF 1.5 kΩ peak current per kV 0.67 A rise time 2-10 ns decay 150 ns table".  
Searched the web for "ANSI/ESDA/JEDEC JS-002 CDM waveform peak current 500 V small large verification module amps rise time full width half maximum table".  
Searched the web for "Industry Council ESD Target Levels White Paper 2 CDM "250 V" peak current package size amps recommended target JEP157".  
Searched the web for "Banerjee Amerasekera interconnect heating failure under ESD conditions critical current density AlCu 100 ns pulse MA/cm2 metal width mA/um design rule" (19 lines of output).  
Fetched https://en.wikipedia.org/wiki/Human-body_model.  
Fetched https://en.wikipedia.org/wiki/Charged-device_model.  
Searched the web for ""A Look at the New ANSI/ESDA/JEDEC JS-002 CDM Test Standard" peak current TC 500 small module large module "A" rise time table values" (17 lines of output).  
Searched the web for "Indrajit Manna Keng Foo Lo Pee Ya Tan Chartered Semiconductor ESD paper 0.18 µm 3.3V 5V NMOS diode TLP results".  
Searched the web for "gate oxide breakdown voltage TLP 100 ns pulse versus oxide thickness 7 nm 12 nm 14 nm ESD design window "BVox" CDM time domain measured" (16 lines of output).  
Searched the web for "Ille "Reliability aspects of gate oxide under ESD pulse stress" breakdown voltage 100 ns thick oxide nm "V" power law results summary thick gate oxide 5 nm 7 nm".  
Searched the web for "ESD metal interconnect design rule "mA/µm" 100 ns TLP aluminum copper line failure current per micron width HBM rule of thumb metal width per kV" (16 lines of output).  
Searched the web for "Chipalooza analog pad ESD "gf180mcu" OR "GF180" Tim Edwards "CDM" OR "secondary ESD" OR "ESD diodes" analog signal pad guidance".  
Searched the web for "STI diode ESD TLP failure current "mA/µm" 0.18 µm CMOS P+/N-well N+/P-well diode It2 per perimeter measured" (15 lines of output).]*

*[Read the shuttle harness README for analog pad and ESD statements (in the cloud container; 3 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for b in main master; do curl -sS -m 30 -o /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/harness_README_$b.md -w "%{http_code}\n" https://raw.githubusercontent.com/RTimothyEdwards/gf180mcu_ocd_chipalooza/$b/README.md; done; F=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/harness_README_main.md; wc -l $F; grep -n -i -E "esd|analog pad|asig|protect|non-ESD|latch|CDM|HBM|5V|resist" $F | cut -c1-400 | head -40
```

</details>

*[Fetched https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza (23 lines of output).  
Searched the web for "CDM ESD secondary protection input gate series resistor value local clamp near receiver design guideline "secondary" diode size ohms paper application note Texas Instruments OR Duvvury OR Ker".  
Searched the web for "Ker 0.18 µm CMOS 3.3 V thick gate oxide breakdown voltage TLP 100 ns "gate-oxide breakdown" measured V input stage ESD design window 1.8V/3.3V" (13 lines of output).]*

*[Look up gate-oxide thickness parameters in the installed PDK models (in the cloud container; 38 lines of output).]*

<details><summary>command</summary>

```sh
ls /foss/pdks/gf180mcuD/libs.tech/ngspice/ 2>/dev/null | head; cd /foss/pdks/gf180mcuD/libs.tech/ngspice 2>/dev/null && grep -n -i -E "^\+? *tox *=|toxe *=|tox_[a-z0-9_]* *=" sm141064.ngspice design.ngspice 2>/dev/null | head -30
```

</details>

*[Tabulate oxide thickness per device model in the PDK (in the cloud container; 17 lines of output).]*

<details><summary>command</summary>

```sh
cd /foss/pdks/gf180mcuD/libs.tech/ngspice && awk '/^\.model|^\.subckt/{m=$2} /toxe *=/{print m, $0}' sm141064.ngspice | sed 's/\.[0-9]* / /' | awk '{print $1, $NF}' | sort | uniq -c | head -30
```

</details>

*[Searched the web for "gate oxide ESD breakdown field "MV/cm" 100 ns pulse thick oxide 10 nm 15 nm 20 nm HBM time scale versus DC breakdown Amerasekera Duvvury "ESD in Silicon Integrated Circuits"" (16 lines of output).]*

*[Extract the IHP process spec and layout rules PDFs from the clone and check for PDF text tools (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; mkdir -p $S/ihp_pdf && cd $S/IHP-GmbH_IHP-Open-PDK && git show HEAD:ihp-sg13g2/libs.doc/doc/SG13G2_os_process_spec.pdf > $S/ihp_pdf/process_spec.pdf && git show HEAD:ihp-sg13g2/libs.doc/doc/SG13G2_os_layout_rules.pdf > $S/ihp_pdf/layout_rules.pdf; ls -la $S/ihp_pdf; which pdftotext mutool qpdf 2>&1 | head; python3 -I -c "import pypdf; print('pypdf', pypdf.__version__)" 2>&1; python3 -I -c "import fitz; print('fitz')" 2>&1 | tail -1
```

</details>

*[Search the IHP process spec and layout rules for ESD, latch-up and current-density content (in the cloud container; 46 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/ihp_pdf; cd $S && pdftotext -layout process_spec.pdf ps.txt && pdftotext -layout layout_rules.pdf lr.txt; grep -n -i -E "esd|hbm|tlp|latch|2kv|4kv|nmoscl|current dens|mA/" ps.txt | cut -c1-220 | head -60; echo ======; grep -n -i -E "esd|hbm|latch-?up|2kv|nmoscl|mA/µm|mA/um|current density" lr.txt | cut -c1-220 | head -60
```

</details>

*[Read the IHP ESD device section and the current-density footnote (in the cloud container; 53 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/ihp_pdf; cd $S && sed -n '2322,2345p' lr.txt | cut -c1-240; sed -n '1190,1202p' ps.txt | cut -c1-260; head -40 ps.txt | grep -i -E "rev|date|20[0-9][0-9]" | head; head -60 lr.txt | grep -i -E "rev|date|20[0-9][0-9]" | head -5
```

</details>

*[Search GF180 PDK documentation for current-density, electromigration and oxide data (in the cloud container; 72 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_gf180mcu-pdk && git log -1 --format='%h %ad' --date=short; git ls-tree -r --name-only HEAD | grep -E "\.(rst|csv)$" > $S/gf_docs.lst; wc -l $S/gf_docs.lst; git grep -n -i -I -E "current density|mA/um|mA/µm|electromigration|Jmax|breakdown voltage|gate oxide|BVox|Tox" HEAD -- 'docs/*.rst' 'docs/*.csv' 2>/dev/null | cut -c1-260 | head -70
```

</details>

*[Read GF180 oxide breakdown spec, voltage limits and electromigration tables (in the cloud container; 155 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_gf180mcu-pdk && for f in docs/analog/spice/elec_specs/tables_clear/5_General_Specification4.csv docs/analog/spice/elec_specs/tables_clear/5_General_Specification5.csv docs/analog/spice/elec_specs/tables_clear/5_General_Specification3.csv docs/physical_verification/design_manual/tables_clear/54_Electro-migration1_150.csv; do echo "== $f"; git show HEAD:$f | cut -c1-200 | head -30; done; echo "== drm_14_1"; git show HEAD:docs/physical_verification/design_manual/drm_14_1.rst | sed -n '1,80p' | cut -c1-700; echo "== drm_14_2"; git show HEAD:docs/physical_verification/design_manual/drm_14_2.rst | cut -c1-500 | head -70; git ls-tree -r --name-only HEAD | grep -i -E "Electro-migration|14_1|Voltage" | head -20
```

</details>

*[Read via/contact current limits and look for process lineage hints in the GF180 docs (in the cloud container; 47 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_gf180mcu-pdk && git show HEAD:docs/physical_verification/design_manual/tables_clear/54_Electro-migration2_151.csv | head -20; git grep -n -i -I -E "Fab ?3E|Chartered|CSM|Fab ?[0-9]" HEAD -- 'docs/*' | cut -c1-300 | head -12; git grep -n -i -I -E "0\.22/0\.18|R-QR|YI-141|DM-0001" HEAD -- 'docs/*.rst' | cut -c1-260 | head -12
```

</details>

*[Fetched https://en.wikipedia.org/wiki/GlobalFoundries (30 lines of output).  
Fetched https://en.wikipedia.org/wiki/Chartered_Semiconductor_Manufacturing.  
Searched the web for "Chartered Semiconductor acquires Hitachi Semiconductor Singapore Tampines fab 2008 renamed Fab 3E 0.18 micron" (13 lines of output).]*

*[Read heads of wafer.space run READMEs (in the cloud container; 136 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && for r in wafer-space/google-gf180mcu-mpw0 wafer-space/ws-run1 wafer-space/ws-run1-cob wafer-space/tinytapeouts; do echo "=== $r"; curl -sS -m 30 https://raw.githubusercontent.com/$r/HEAD/README.md | head -45 | cut -c1-400; done
```

</details>

*[Inspect the wafer.space chip-on-board test results repository for pad or diode tests (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && gh api "search/code?q=repo:wafer-space/ws-run1-cob+diode&per_page=10" --jq '.total_count, (.items[] | .path)' 2>&1 | head; sleep 7; gh api "search/code?q=repo:wafer-space/ws-run1-cob+ESD&per_page=10" --jq '.total_count, (.items[] | .path)' 2>&1 | head; curl -sS -m 30 https://raw.githubusercontent.com/wafer-space/ws-run1-cob/HEAD/README.md | sed -n '20,80p' | cut -c1-400; curl -sS -m 30 https://raw.githubusercontent.com/wafer-space/ws-run1-cob/HEAD/data/2026-06-13.jsonl | head -c 1500
```

</details>

*[Find how the chip-on-board pad test is defined (in the cloud container; 42 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && curl -sS -m 30 https://raw.githubusercontent.com/wafer-space/ws-run1-cob/HEAD/README.md | wc -l; curl -sS -m 30 https://raw.githubusercontent.com/wafer-space/ws-run1-cob/HEAD/scripts/gen_reports.py | grep -n -i -E "diode|sense|esd|short|open|current|mA|uA|volt|threshold|protection" | cut -c1-220 | head -40; curl -sS -m 30 "https://api.github.com/repos/wafer-space/ws-run1-cob/contents/" 2>&1 | head -5
```

</details>

*[Fetched https://github.com/wafer-space/ws-run1-cob/tree/main/docs (3 lines of output).]*

*[Clone the chip-on-board results repository and search for the test method description (in the cloud container; 46 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp && S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S && [ -d cob ] || timeout 120 git clone -q --depth 1 --filter=blob:none --no-checkout https://github.com/wafer-space/ws-run1-cob.git cob 2>&1 | tail -2; cd cob && git log -1 --format='%h %ad' --date=short && git ls-tree -r --name-only HEAD | grep -v -E "results/.*\.html$" | head -40; git grep -n -i -I -E "diode|senseV|sense voltage|ESD|forward" HEAD -- '*.md' '*.py' '*.txt' | cut -c1-260 | head -30
```

</details>

*[Searched the web for ""GF180MCU" OR "gf180mcu" "TLP" OR "HBM" measurement silicon ESD test structures open-source PDK university paper 2024 2025 2026 "ESD" characterization tapeout".  
Searched the web for "efabless caravel sky130 ESD HBM test results pads "ESD" measured OR tested OR "not tested" open-source-silicon.dev slack Tim Edwards analog pads ESD" (15 lines of output).  
Searched the web for "wiki.f-si.org Tim Edwards "Chipalooza" OR "Panamax" OR "Frigate" talk ESD analog pads "ESD" slides abstract".  
Searched the web for "gf180mcu analog pad "asig_5p0" "ESD" wafer.space OR "open-source-silicon.dev" discussion secondary protection resistor CDM diode analog input" (16 lines of output).]*

*[Verify the analog pad current rating in the library spec tables (in the cloud container; 8 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl/gf180mcu_ocd_io; cd $S; grep -rn -i "asig\|analog" docs/specs/*.csv | cut -c1-260 | head -12; grep -rn -i -E "10 ?mA|current carrying" docs | cut -c1-240 | head
```

</details>

*[Searched the web for "JS-002 CDM waveform characteristics table "TC 500" small verification module peak current "A" 6 GHz oscilloscope values 250 500 750 1000 large module".  
Searched the web for "HBM ESD 2 kV peak current 1.33 A time constant 150 ns rise time 10 ns explanation application note "1.33 A"" (15 lines of output).  
Searched the web for "0.18 µm 5 V device gate oxide breakdown voltage ESD design window "5 V" thick oxide "breakdown" TLP "V" 120 Å OR "12 nm" OR "13.5 nm" SCR ESD protection paper 0.18 BCD 5V I/O" (15 lines of output).  
Fetched https://github.com/2AMLogic/gf180-io-ring/issues/38.  
Fetched https://github.com/mithro/evampire/pull/15 (21 lines of output).]*

*[Search GF180 docs for the ESD implant option and ESD layer rules (in the cloud container; 40 lines of output).]*

<details><summary>command</summary>

```sh
S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/dl; cd $S/google_gf180mcu-pdk && git grep -n -i -I -E "ESD implant|ESD_MK|,ESD,|ESD layer|ESD.*3\.3V SAB|ESD-[0-9]|ESD\.[0-9]" HEAD -- 'docs/*.rst' 'docs/*.csv' 2>/dev/null | grep -v "Auto packing" | cut -c1-300 | head -40
```

</details>

*[Check whether the I/O library layouts draw the ESD implant layer (in the cloud container; 6 lines of output).]*

<details><summary>command</summary>

```sh
ls /foss/pdks/gf180mcuD/libs.ref/gf180mcu_ocd_io/gds/ 2>/dev/null | head -20; python3 -I - <<'EOF'
import klayout.db as db, glob, os
for lib in ("gf180mcu_ocd_io","gf180mcu_fd_io"):
    files = sorted(glob.glob(f"/foss/pdks/gf180mcuD/libs.ref/{lib}/gds/*.gds*"))
    print(lib, len(files), [os.path.basename(f) for f in files][:6])
    for f in files[:3]:
        ly = db.Layout(); ly.read(f)
        want = {(24,0):"ESD implant",(24,5):"ESD_MK",(137,5):"Latchup_MK?",(49,0):"SAB"}
        found = {}
        for li in ly.layer_indexes():
            info = ly.get_info(li)
            key=(info.layer,info.datatype)
            if key in want:
                n=0
                for c in ly.each_cell():
                    n += c.shapes(li).size()
                found[want[key]+str(key)] = n
        print("  ", os.path.basename(f), "cells:", ly.cells(), found)
EOF
```

</details>

*[Fetched https://github.com/RTimothyEdwards/gf180mcu_ocd_io/issues?q=is%3Aissue.  
Fetched https://github.com/wafer-space/gf180mcu-project-template/issues/76 (13 lines of output).]*

*[Confirm the foundry library netlist values for the analog pad and input-pad secondary network (in the cloud container; 21 lines of output).]*

<details><summary>command</summary>

```sh
cd /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io 2>/dev/null && ls; f=$(ls cdl/*.cdl | head -1); echo $f; awk '/^\.SUBCKT gf180mcu_fd_io__asig_5p0/,/^\.ENDS/' $f | head -12; awk '/^\.SUBCKT gf180mcu_fd_io__in_c /,/^\.ENDS/' $f | grep -E "^R[0-9]+ PAD|diode_nd2ps_06v0 m=2|diode_pd2nw_06v0 m=2" | cut -c1-140
```

</details>

*[Called SubagentHandback (1 lines of output).]*
