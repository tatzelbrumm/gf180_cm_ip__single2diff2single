<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Subagent 1 of the session "session_01XU3KH8TTLjkQNhWPaFJmRL": IHP parametric cells survey (agent type general-purpose). The message shown as "User" is the brief written by the main session's assistant, not a message from Christoph; the subagent's final report went back through a hand-back call and is filed verbatim in sudelbuecher/logs/

Session `session_01XU3KH8TTLjkQNhWPaFJmRL, subagent 1`, Claude (configured model `claude-fable-5-2`; the serving model may differ).
Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;
tool calls as `*[ ]*` summaries (actions and observable results only); shell commands verbatim in collapsed blocks, their output omitted.
The internal reasoning trace is not included.
Times are Europe/Berlin. Exported through the record stamped 2026-11-26 15:07; later turns are not in this file.

## Turn 1 — 15:01

**User:**

Read-only research task. Do not modify, commit or push anything anywhere.

A git clone of the public repository `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single` (an IHP sg13cmos5l analog chip design: single-ended -> differential -> single-ended converter between pads) is at `/home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single` (shallow, all branches fetched as `origin/*`; only `main` is checked out). To look at other branches use `git -C <path> show origin/<branch>:<file>`, `git -C <path> ls-tree -r --name-only origin/<branch>`, or `git worktree add /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_<branch> origin/<branch>` (worktrees only under that scratchpad directory).

Goal: find out how this repository builds its ESD protection and output-pad layout as PARAMETRIC cells, so that the method (not the IHP numbers) can later be carried over to a GlobalFoundries GF180MCU port. Branches that look relevant by name: `main`, `claude/c2-pad-layout`, `claude/c3-s2d-pad-layout`, `pcells`; check others if they look relevant (`claude/c5-tree-layout`, `toplevel`). Look especially for: `scripts/pcells/` (Clamp_* cells, e.g. ClampN / ClampP), any KLayout PyCell / pya / gdsfactory / Magic Tcl generator code, macro directories such as `macros/sg13cmos5l_IOPadSingle2Diff`, `macros/sg13cmos5l_IOPadDiff2Single`, their `layout/` folders, Makefiles targets that build or check the cells, and notes/handover docs that describe the pcell method.

Report, concisely and factually (this report will be quoted in a design document, so every statement needs a source):
1. Which branch(es) hold the parametric layout code, and the list of generator files (path, line count, one line on what each makes).
2. Language and tool (e.g. KLayout PCellDeclarationHelper in Python, IHP PyCell wrappers, plain pya scripts, ...), how the cells are registered/instantiated/exported to GDS, and which PDK library functions they depend on.
3. For each parametric ESD/clamp/pad/driver cell: the full parameter list (name, type, default, unit, meaning) with file path and line numbers; which dimensions are hard-coded constants (path:line) and where the design-rule values come from (hard-coded numbers, PDK tech file lookup, ...).
4. Which checks are run on the generated cells (DRC, LVS, XOR against a reference, connectivity, boundary checks, unit tests), with the script/Makefile target paths and lines, and any recorded results.
5. How the cell sits relative to the IHP pad (`sg13cmos5l_IOPadAnalog` or similar): anchors such as pad pitch, terminal positions, metal layers, supply rails, guard rings — whatever the code or docs record.
6. Anything the docs/notes say about limits of the approach (what was not parametrized, what failed, open issues).

For every fact give `branch:path:line` (or line range). Quote short code excerpts (parameter declarations) verbatim. Clearly separate what you read in a file from what you infer. If something does not exist (e.g. no parametric ESD cell at all on a branch), say so plainly rather than guessing. Do not run any EDA tools; reading files is enough.

**Assistant:**

*[List branches and top-level files of the IHP clone (in the cloud container; 52 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && git --no-optional-locks branch -a && git --no-optional-locks log --oneline -3 && ls
```

</details>

*[List generator-like files per relevant branch (in the cloud container; 440 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && for b in main pcells claude/c2-pad-layout claude/c3-s2d-pad-layout claude/c5-tree-layout toplevel claude_salvage i_claude generated_deleted; do echo "=== $b"; git --no-optional-locks log -1 --format='%h %ad %s' --date=short origin/$b; git --no-optional-locks ls-tree -r --name-only origin/$b | grep -iE 'pcell|clamp|pycell|\.py$|\.tcl$|\.lym$|\.rb$' | head -80; done
```

</details>

*[Compare pcell scripts between branches (in the cloud container; 72 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad; mkdir -p $S; for p in "pcells claude/c2-pad-layout" "claude/c2-pad-layout claude/c3-s2d-pad-layout" "claude/c3-s2d-pad-layout claude/c5-tree-layout" "claude/c5-tree-layout toplevel" "claude_salvage pcells"; do set -- $p; echo "=== $1 .. $2"; git --no-optional-locks diff --stat origin/$1 origin/$2 -- scripts/pcells scripts/pymacros scripts/extract_pad.py | tail -25; done; git --no-optional-locks ls-tree -r --name-only origin/toplevel | grep -E '^scripts/'
```

</details>

*[Create scratch worktrees and count generator file lines (in the cloud container; 216 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad; git worktree add --detach $S/D_c3 origin/claude/c3-s2d-pad-layout 2>&1 | tail -1; git worktree add --detach $S/D_pcells origin/pcells 2>&1 | tail -1; cd $S/D_c3 && wc -l scripts/pcells/*.py scripts/pcells/test_m1/*.py scripts/pcells/README.md scripts/pymacros/BasicsLib.lym scripts/extract_pad.py scripts/mag2klay.py scripts/check_ocd_macros.py scripts/pex_add_port.py macros/sg13cmos5l_IOPadSingle2Diff/layout/klayout/template/build_template.py; ls macros; ls -R macros/sg13cmos5l_IOPadDiff2Single macros/sg13cmos5l_IOPadSingle2Diff macros/IOPad | head -150
```

</details>

*[Read the pcells README on c3 (in the cloud container; 378 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3 && cat -n scripts/pcells/README.md
```

</details>

*[Read PyCell wrapper and registration files (in the cloud container; 407 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts/pcells && cat -n clamp_base_code.py __init__.py load_clamp_pcells.py Clamp_N_code.py Clamp_P_M1_code.py Clamp_N_M1_wiring_code.py DCNDiode_code.py cm_clamps_reload.py
```

</details>

*[Read clamp_engine.py first half (in the cloud container).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts/pcells && cat -n clamp_engine.py | sed -n 1,400p
```

</details>

*[Read clamp_engine.py second half (in the cloud container; 376 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts/pcells && cat -n clamp_engine.py | sed -n 400,775p
```

</details>

*[Read reference data extraction script and refdata head (in the cloud container; 401 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts/pcells && cat -n extract_clamp_refdata.py | cut -c1-220; echo ======; cut -c1-300 clamp_refdata.py | cat -n | head -60
```

</details>

*[Read GDS writer, CLI generator, verify and LVS scripts (in the cloud container; 458 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts/pcells && cat -n clamp_klayout.py gen_clamp.py verify_clamp.py lvs_clamp.py
```

</details>

*[Read swap script, netlist, BasicsLib and extract_pad (in the cloud container; 423 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts && for f in pcells/use_clamp_pcells.py pcells/clamp_netlist.py pcells/BasicsLib.py pymacros/BasicsLib.lym extract_pad.py; do echo "##### $f"; cat -n $f; done
```

</details>

*[Read test scripts for M1 clamps (in the cloud container; 439 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/scripts/pcells/test_m1 && for f in test_m1.py xor_engine.py drc_gds.py drc_negative_gds.py test_wiring.py; do echo "##### $f"; cat -n $f; done; echo "#### test_diode head"; cat -n test_diode.py | sed -n 1,60p
```

</details>

*[Read output pad macro README (in the cloud container; 326 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/macros && cat -n sg13cmos5l_IOPadDiff2Single/README.md | cut -c1-900
```

</details>

*[Read replica mockup README and pad macro Makefile (in the cloud container; 189 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/macros && cat -n sg13cmos5l_IOPadDiff2Single/layout/klayout/replica_mockup/README.md; echo ====; cat -n sg13cmos5l_IOPadDiff2Single/Makefile | head -150; ls -la sg13cmos5l_IOPadDiff2Single/verification/drc sg13cmos5l_IOPadDiff2Single/verification/lvs
```

</details>

*[Read Makefile verification targets and result dirs (in the cloud container; 205 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3/macros && cat -n sg13cmos5l_IOPadDiff2Single/Makefile | sed -n 150,330p; ls -la sg13cmos5l_IOPadDiff2Single/verification/drc/* sg13cmos5l_IOPadDiff2Single/verification/lvs/*; grep -rn "pcell\|Clamp_\|grep\b" /dev/null; grep -n -i "pcell\|clamp" ../Makefile sg13cmos5l_IOPadDiff2Single/Makefile sg13cmos5l_IOPadSingle2Diff/Makefile | head -20
```

</details>

*[Check Makefiles for pcell targets, read build_template.py (in the cloud container; 334 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3 && grep -rn -i "pcell\|scripts/pcells\|Clamp_" --include=Makefile --include='*.mk' . | head; echo ---; cat -n macros/sg13cmos5l_IOPadDiff2Single/verification/drc/*/*.rpt; echo; tail -15 macros/sg13cmos5l_IOPadDiff2Single/verification/lvs/sg13cmos5l_IOPadDiff2Single.magic.lvs/*.lvs.out; echo ---; cat -n macros/sg13cmos5l_IOPadSingle2Diff/layout/klayout/template/build_template.py; ls -R macros/sg13cmos5l_IOPadSingle2Diff/layout
```

</details>

*[Read S2D template README and layout notes (in the cloud container; 143 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3 && cat -n macros/sg13cmos5l_IOPadSingle2Diff/layout/klayout/template/README.md | cut -c1-1200; echo =====; grep -n -i "layout\|pcell\|clamp\|template\|DRC\|LVS\|ESD" macros/sg13cmos5l_IOPadSingle2Diff/README.md | cut -c1-600 | head -80
```

</details>

*[Read S2D layout section; list notes branch files on pad layout (in the cloud container; 31 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3 && sed -n 222,256p macros/sg13cmos5l_IOPadSingle2Diff/README.md | cat -n | cut -c1-900; sed -n 300,312p macros/sg13cmos5l_IOPadSingle2Diff/README.md | cut -c1-600; cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single; for b in claude/c2-pad-layout-sudel claude/c3-s2d-pad-layout-sudel sudel_buecher; do echo "=== $b"; git --no-optional-locks ls-tree -r --name-only origin/$b | grep -i -E "pad_buffer_layout|pcell|clamp|IOPadDiff2Single_build" | grep -v -E "\.(png|gds|lyrdb|log|cir|out|spc|lvsdb)$" | head -120; done
```

</details>

*[List notes branch documents and scripts on pad layout (in the cloud container; 276 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single; for b in claude/c2-pad-layout-sudel claude/c3-s2d-pad-layout-sudel sudel_buecher; do echo "=== $b"; git --no-optional-locks ls-tree -r --name-only origin/$b | grep -i -E "pad_buffer_layout|pcell|clamp|IOPadDiff2Single_build" | grep -E "\.(md|py|txt|diff|tcl|rb|lym)$" | wc -l; git --no-optional-locks ls-tree -r --name-only origin/$b | grep -i -E "pad_buffer_layout|pcell|clamp|IOPadDiff2Single_build" | grep -E "\.(md|py|diff|tcl|rb|lym)$" | grep -v agents_ | head -90; done
```

</details>

*[Create notes worktree and list pad layout note directories (in the cloud container; 77 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && S=/var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad; git worktree add --detach $S/D_c3sudel origin/claude/c3-s2d-pad-layout-sudel 2>&1 | tail -1; cd $S/D_c3sudel; ls; ls Claude/skills/*; ls sudelbuecher | head -60; ls sudelbuecher/design_considerations/pad_buffer_layout; ls sudelbuecher/design_considerations/pad_buffer_layout/pad_cell_2026-10-31 sudelbuecher/design_considerations/pad_buffer_layout/pad_cell_s2d 2>/dev/null | head -80; ls sudelbuecher/sg13cmos5l_IOPadDiff2Single_build | head -40
```

</details>

*[Read the flat-cell-to-pcell skill document (in the cloud container; 49 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel && wc -l Claude/skills/ihp-flat-cell-to-pcell/SKILL.md && cat -n Claude/skills/ihp-flat-cell-to-pcell/SKILL.md | cut -c1-1500
```

</details>

*[Measure note document sizes and list ESD-related note dirs (in the cloud container; 63 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && wc -l design_considerations/pad_buffer_layout/pad_cell_2026-10-31/{report,decisions,HANDOFF}.md design_considerations/pad_buffer_layout/pad_cell_s2d/{report,decisions}.md design_considerations/pad_buffer_layout/{layout_primitives,log}.md design_considerations/pad_buffer_layout/klayout/*.md sg13cmos5l_IOPadDiff2Single_build/*.md clamp_pcell_code_annotated/README.md esd_protection/* 2>/dev/null; ls esd_protection sg13cmos5l_IOPadAnalog sg13cmos5l_IOPadDiff2Single_build/replica_prototype sg13cmos5l_IOPadDiff2Single_build/m2_option_b_2026-10-28 sg13cmos5l_IOPadSingle2Diff_build cm_pcells_structure_visualization | head -80
```

</details>

*[Read D2S pad cell layout report (in the cloud container; 213 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && cat -n design_considerations/pad_buffer_layout/pad_cell_2026-10-31/report.md | cut -c1-1100
```

</details>

*[Look for PCell context strings in the pad GDS files (in the cloud container; 70 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad && for f in D_c3/macros/sg13cmos5l_IOPadDiff2Single/layout/klayout/sg13cmos5l_IOPadDiff2Single.klay.gds D_c3/macros/sg13cmos5l_IOPadSingle2Diff/layout/klayout/sg13cmos5l_IOPadSingle2Diff.klay.gds D_c3/macros/sg13cmos5l_IOPadSingle2Diff/layout/klayout/template/sg13cmos5l_IOPadSingle2Diff_template.gds; do echo "== $f"; ls -la $f | awk '{print $5}'; strings -n 4 $f | grep -E "Clamp|DC[NP]Diode|PCELL|LIB=|SG13_|ng=|roles|wiring|frame" | sort | uniq -c | sort -rn | head -40; done; cat D_c3/macros/sg13cmos5l_IOPadDiff2Single/layout/klayout/sg13cmos5l_IOPadDiff2Single.klay.klib 2>/dev/null | head -30
```

</details>

*[Dump PCell parameter context of the output pad GDS (in the cloud container; 66 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad && strings -n 3 D_c3/macros/sg13cmos5l_IOPadDiff2Single/layout/klayout/sg13cmos5l_IOPadDiff2Single.klay.gds | grep -n -E "^(LIB=|PCELL=|P\()" | sed -n 1,90p; cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single; git --no-optional-locks log --oneline -5 origin/claude/c2-pad-layout -- macros/sg13cmos5l_IOPadDiff2Single/layout/klayout/sg13cmos5l_IOPadDiff2Single.klay.gds
```

</details>

*[Find note scripts that instantiate the clamp PCells (in the cloud container; 11 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && find sg13cmos5l_IOPadDiff2Single_build sg13cmos5l_IOPadSingle2Diff_build design_considerations/pad_buffer_layout/pad_cell_s2d design_considerations/pad_buffer_layout/pad_cell_2026-10-31 -name "*.py" | xargs grep -l -E "SG13_cm_clamps|Clamp_[NP]_M1|generate_m1|DCNDiode" 2>/dev/null | xargs wc -l | sort -n | tail -40
```

</details>

*[Read the IO pad inventory note (in the cloud container; 195 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/sg13cmos5l_IOPadDiff2Single_build && wc -l replica_prototype/report.md m2_option_b_2026-10-28/report.md iopad_inventory.md && cat -n iopad_inventory.md | cut -c1-700
```

</details>

*[Read replica prototype report (in the cloud container; 208 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/sg13cmos5l_IOPadDiff2Single_build && cat -n replica_prototype/report.md | cut -c1-900 | sed -n 1,208p
```

</details>

*[Read C2 pad cell decisions and handoff notes (in the cloud container; 106 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/design_considerations/pad_buffer_layout && cat -n pad_cell_2026-10-31/decisions.md | cut -c1-700; echo ======; cat -n pad_cell_2026-10-31/HANDOFF.md | cut -c1-700
```

</details>

*[List S2D pad report headings and template check files (in the cloud container; 90 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/design_considerations/pad_buffer_layout && grep -n "^#" pad_cell_s2d/report.md | head -60; ls pad_cell_s2d/template pad_cell_s2d/template/* | head -60
```

</details>

*[Read S2D report frame facts and template version sections (in the cloud container; 171 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/design_considerations/pad_buffer_layout && sed -n 40,90p pad_cell_s2d/report.md | cat -n | sed 's/^ *\([0-9]*\)/L\1+39/' | cut -c1-1100; echo; sed -n 202,320p pad_cell_s2d/report.md | cut -c1-1000 | nl -v202 -ba
```

</details>

*[Search D2S build log for clamp PCell placement notes (in the cloud container; 70 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && grep -n -E "Clamp_[NP]_M1|DC[NP]Diode|comb|frame 80u|pad bar|strip_1435" sg13cmos5l_IOPadDiff2Single_build/log.md | cut -c1-420 | head -70
```

</details>

*[Read D2S build log on IHP pad wiring and PCell placement (in the cloud container; 129 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && sed -n 413,470p sg13cmos5l_IOPadDiff2Single_build/log.md | cut -c1-600 | nl -v413 -ba; sed -n 505,575p sg13cmos5l_IOPadDiff2Single_build/log.md | cut -c1-600 | nl -v505 -ba
```

</details>

*[Read option-B Metal2 comb report and generator head (in the cloud container; 155 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && sed -n 1,95p sg13cmos5l_IOPadDiff2Single_build/m2_option_b_2026-10-28/report.md | cut -c1-800 | nl -ba; sed -n 1,60p sg13cmos5l_IOPadDiff2Single_build/m2_option_b_2026-10-28/build_m2.py | nl -ba | cut -c1-240
```

</details>

*[Check how the M2 builder uses the clamp engine; read its checks and open points (in the cloud container; 151 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/sg13cmos5l_IOPadDiff2Single_build/m2_option_b_2026-10-28 && grep -n "E\.\|create_cell\|pcell" build_m2.py | head -30; sed -n 95,229p report.md | cut -c1-520 | nl -v95 -ba
```

</details>

*[List F2 agent outputs and find recorded clamp verification logs (in the cloud container; 44 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && ls sg13cmos5l_IOPadDiff2Single_build/agents_c2/F2 sg13cmos5l_IOPadDiff2Single_build/agents_c2/F2/out 2>/dev/null | head -60; find sg13cmos5l_IOPadDiff2Single_build/agents_c2/F2 -name "*.py" | head -40; grep -rn -l "verify_clamp\|lvs_clamp\|RESULT: PASS" --include=*.md --include=*.log --include=*.out --include=*.txt . 2>/dev/null | head -20
```

</details>

*[Inspect F2 pad build scripts for PCell handling (in the cloud container; 72 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/sg13cmos5l_IOPadDiff2Single_build/agents_c2/F2 && wc -l out/src/src_F/build_pad.py out/src/src_F/common.py out/src/place_A.py out/stage_A_note.md; sed -n 1,60p out/src/src_F/build_pad.py | cut -c1-260 | nl -ba; grep -n "pad_wiring_f2\|SG13_cm_clamps\|Clamp_\|write_context_info" -r out/src | cut -c1-240 | head -30; cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && git --no-optional-locks ls-tree -r --name-only origin/claude/c2-pad-layout-sudel | grep -E "agents_c2/F2/.*(pad_wiring|stage_B|build_pad_wiring|route).*\.(py|md)$" | head
```

</details>

*[Read F2 common rule lookup and annotated clamp code README (in the cloud container; 172 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher && sed -n 1,60p sg13cmos5l_IOPadDiff2Single_build/agents_c2/F2/out/src/src_F/common.py | cut -c1-220 | nl -ba; echo ====; cat -n clamp_pcell_code_annotated/README.md | cut -c1-500 | sed -n 1,111p
```

</details>

*[Summarize other layout generator scripts on toplevel (in the cloud container; 130 lines of output).]*

<details><summary>command</summary>

```sh
cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single && for f in macros/slot7_testplatform/layout/scripts/make_slot_7.py macros/slot7_testplatform/layout/scripts/pbc_row.py macros/slot7_testplatform/layout/scripts/routed_cell.py macros/slot7_testplatform/layout/scripts/tp_en_ctrl.py macros/slot7_testplatform/layout/tree/assembly/build_tree.py macros/slot7_testplatform/layout/tree/assembly/check_tree.py macros/slot7_testplatform/layout/tree/nmos/build_tree_nmos.py macros/slot7_testplatform/layout/tree/pmos/build_tree_pmos.py macros/slot7_testplatform/layout/tree/pmos/check_tree_pmos.py macros/pad_ref_rb/layout/primitives/collect_primitives.py; do n=$(git --no-optional-locks show origin/toplevel:$f 2>/dev/null | wc -l); echo "== $f ($n lines)"; git --no-optional-locks show origin/toplevel:$f 2>/dev/null | sed -n 1,12p | cut -c1-230; done 2>&1 | head -150
```

</details>

*[List root Makefile targets, check script heads, layout primitives notes (in the cloud container; 111 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3 && grep -n -E '^[a-zA-Z0-9_.-]+:.*## ' Makefile | cut -c1-160; sed -n 1,25p scripts/check_ocd_macros.py | cut -c1-200; sed -n 1,14p scripts/mag2klay.py | cut -c1-200; sed -n 1,30p scripts/check_boundary.py | cut -c1-200; cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad/D_c3sudel/sudelbuecher/design_considerations/pad_buffer_layout && grep -n -i "P7\|Clamp_\|clamp frame" layout_primitives.md | cut -c1-500 | head -20
```

</details>

*[Look for recorded pcell test logs and main-branch mentions (in the cloud container; 9 lines of output).]*

<details><summary>command</summary>

```sh
cd /var/tmp/claude-0/-home-user-gf180-cm-ip--single2diff2single/35fe6b9a-54a3-54d0-adab-73eed00fa4d5/scratchpad && grep -rn -l "test_wiring\|test_m1.py\|verify_clamp" D_c3sudel/sudelbuecher/logs 2>/dev/null | head -8; ls D_c3sudel/sudelbuecher/logs | head; cd /home/user/tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single; git --no-optional-locks grep -n -i "pcell" origin/main -- CLAUDE.md README.md Makefile | cut -c1-220 | head -12; git --no-optional-locks ls-tree -r --name-only origin/main | grep -c "scripts/pcells"; git --no-optional-locks grep -n -i "pcell\|Clamp_" origin/claude/c3-s2d-pad-layout -- CLAUDE.md docs 2>/dev/null | cut -c1-260 | head -20
```

</details>

*[Called SubagentHandback (1 lines of output).]*
