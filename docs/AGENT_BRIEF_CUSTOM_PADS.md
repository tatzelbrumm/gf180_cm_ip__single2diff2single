# Brief for the Claude Cloud Code agent: how to replace the slot 16 pads with custom analog pads

> **Edited after the fact (2026-11-28).** On the user's instruction ("Your A and B labels are obfuscating. Don't use them.
> Replace them everywhere and correct the logs accordingly.") the repository labels were replaced by the full repository names in
> this brief; nothing else in the text was changed. The labels came from the brief `docs/AGENT_BRIEF_CUSTOM_PADS.md` (commits `5488b24`, `536a19e`, 2026-11-26).
> Older versions of this file, the commit messages up to this edit and the verified chat log on `sudel_buecher` still use them:
> A = `tatzelbrumm/gf180_cm_ip__single2diff2single`, B = `tatzelbrumm/gf180mcu_ocd_chipalooza`, C = `tatzelbrumm/claude-cloud-config`, D = `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single`, Upstream = `RTimothyEdwards/gf180mcu_ocd_chipalooza`. Those were not rewritten (that would need a force-push).

Written by the harness build session for the user, 2026-11-28. Model and effort set by the user: Sonnet 5.5, high.

## Task and scope
Find out how the two dedicated analog pads of slot 16 (this project) can be replaced by **custom analog pads of the same form factor**, which the user will design later.
You design no pad. You write a plan, and you may prove the flow in a scratch copy (below).

The user's idea, which you evaluate (and criticise if it does not hold):
- Make two renamed copies of the standard analog pad `gf180mcu_ocd_io__asig_5p0`, same views and same size, as two new pad types: an **input pad type**
  (for the macro `gf180mcu_IOPadSingle2Diff` of this project) and an **output pad type** (for `gf180mcu_IOPadDiff2Single`). Slot 16's `s16_an[0]` would become the input type
  and `s16_an[1]` the output type.
- The copies are placeholders ("fill-in"). Later the user replaces each placeholder by a custom pad cell without changing the flow again.
- The harness fork (`tatzelbrumm/gf180mcu_ocd_chipalooza`) is the user's playground precisely so that such changes can be made without jeopardizing the upstream harness.

## Repositories
- `tatzelbrumm/gf180_cm_ip__single2diff2single` (the design repository): the source of this session, at the branch `custom_pads_exploration`. Read `CLAUDE.md` first (git is granted in cloud sessions), then
  `docs/AGENT_BRIEF_PAD_STRUCTURES.md`, the brief of another agent (Fable) that explores the existing pad structures and ESD protection and will write `docs/PAD_STRUCTURES.md` on the branch
  `pad_esd_exploration`. That branch belongs to the other agent: you may read it (fetch it) and use its report when it exists, you never push to it.
- `tatzelbrumm/gf180mcu_ocd_chipalooza`: the user's fork of the Chipalooza #3 harness (upstream `RTimothyEdwards/gf180mcu_ocd_chipalooza`). Attach it with `add_repo` (read access) and
  clone it. Read only: never push to `tatzelbrumm/gf180mcu_ocd_chipalooza`. If you build, work in a scratch copy of the clone (a separate directory); nothing from it is pushed. Branches of `tatzelbrumm/gf180mcu_ocd_chipalooza` worth reading:
  `chipalooza_artifacts_run1` (directory `fixes/`: patches and issue drafts from a full harness build; `fixes/pad_pins/` the pad pin name fix) and `chipalooza_artifacts_run2` (`fixes/TIM_SUMMARY.md`,
  `fixes/SLOT_PROJECT_ISSUES.md`, run 2 DRC and LVS results). Its `main` still has the IHP pad pin names (`.iovdd/.iovss`) in the padframe verilog template; the fix is in `fixes/pad_pins/`.
- `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single`: the IHP reference design (public, read only, anonymous clone). Optional: see how it relates its own pad macros to the harness pads.
- Nothing is expected from `claude-cloud-config` in this task.

## What to find out
1. **Where the pad type matters.** What in the harness depends on the pad type, with file and line for each place: `config.txt` (the key `s16_an[0]`, `s16_an[1]` and the six valid types in its header comment),
   `scripts/parse_config.py`, `scripts/gen_padframe_template.tcl`, `scripts/gf180mcu_padframe_template.v`, the generated `scripts/gen_padframe.tcl` and `verilog/gl/gf180mcu_padframe.v`, the slot wrappers
   and their pinout, the harness core, `scripts/gen_xschem_sym.py`, the LVS scripts under `validate/`, `Makefile` and `README`. The author of this brief saw, on the fork's `main` at `2f18cd4`, that
   `parse_config.py` handles `gf180mcu_ocd_io__asig_5p0` in hard-coded branches (around lines 148, 196, 213, 265 and 382) and stops with "Bad pad type" for any other name; verify that and find the rest.
2. **What "same form factor" means exactly**: pad cell size, the terminal positions on the abutting edges, metal layers, supply rail connections, bond pad position. Measure it from the PDK views of
   `gf180mcu_ocd_io__asig_5p0` and from the padframe (`$PDK_ROOT/gf180mcuD/libs.ref/gf180mcu_ocd_io/`, and the harness script `pad_abutment_check.tcl` in the branch `sudel_buecher` of `tatzelbrumm/gf180mcu_ocd_chipalooza`,
   `sudelbuecher/harness_tools/`). State the constraints a custom pad has to meet to abut its neighbours and the rails.
3. **What a custom pad must provide**: which views (mag, gds, lef, spice, verilog; others?), under which names and in which library directory, so that the padframe generator, the
   top-level GDS assembly, the extraction and the LVS find them. The PDK is read only: say where the custom cells would live (for example a directory of the harness or of this project) and what
   has to point there (Magic search path, netgen setup, KLayout).
4. **The placeholder flow, tried.** In a scratch copy of `tatzelbrumm/gf180mcu_ocd_chipalooza`, apply your plan with two renamed copies of the analog pad as stand-ins, and run the quick steps only: `make clean-config`, `config`, `padframe`,
   `wrappers`, `symbols`, and the pad abutment check. Report what worked, what failed (first error, exactly), and which edits were needed (as patch files). Do NOT run `drc-final`, the full-chip LVS or
   `extract-top` (hours); if you think one of them is needed, say which and why, and ask. Do not run `make setup` (the script does not exist in the repository). Known facts about building the
   harness are in the `fixes/` directories of `tatzelbrumm/gf180mcu_ocd_chipalooza` (see above) and in `chipalooza_logs_run1` (step logs).
5. **What else changes in this repository (`tatzelbrumm/gf180_cm_ip__single2diff2single`)** when the pads change: the macros `gf180mcu_IOPadSingle2Diff` and `gf180mcu_IOPadDiff2Single`, `harness_stub/`, `submission.yaml` (`analog-pins`, `slot-size`),
   `CLAUDE.md` section 1 (top cell name `gf180_cm_ip__single2diff2single` versus the harness convention `slot_16`, described in section 5). List them; change none.
6. **Coordination and risk**: what has to be agreed with the harness maintainer (Tim Edwards) and the slot owner, whether the change can stay in the user's fork, and what the harness build does at tapeout
   with the new types. Mark what you could not check.

## Deliverables
All on the branch `custom_pads_exploration` of `tatzelbrumm/gf180_cm_ip__single2diff2single`, as commits on top of it:
- `docs/CUSTOM_PADS_PLAN.md`: the answers to the six questions above, an ordered step-by-step plan, the evaluation of the user's placeholder idea (what holds, what does not, alternatives), and a list of open
  questions for the user. Mark every statement **verified** (give file and line, or the command and its output), **inferred** (say from what) or **unverified**.
- `docs/custom_pads/`: the patch files of your scratch trial, a short README on how to apply them to the harness fork, and the logs of the steps you ran (exact commands, first errors).
- A short work journal next to the plan.
- A chat log on the branch `sudel_buecher` of `tatzelbrumm/gf180_cm_ip__single2diff2single` (the user's local worktree `gf180_cm_ip__single2diff2single_sudelbuecher`): layout `sudelbuecher/chatlog/` and `sudelbuecher/logs/main/` as in the existing files;
  append only, change nothing else on that branch. Use `session_chatlog.sh` from `tatzelbrumm/gf180mcu_ocd_chipalooza` (branch `sudel_buecher`, `sudelbuecher/chatlog_tools/`). It refuses to write a log it cannot verify against the session
  transcript; if it refuses, say so. Never reconstruct a chat log from memory.

## Rules
- Push only to `custom_pads_exploration` and `sudel_buecher` of `tatzelbrumm/gf180_cm_ip__single2diff2single`. Never push to `main` or `pad_esd_exploration` of `tatzelbrumm/gf180_cm_ip__single2diff2single`, never force-push, never rebase. Never push to `tatzelbrumm/gf180mcu_ocd_chipalooza`, `tatzelbrumm/claude-cloud-config` or `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single`.
- Do not change the environment settings; if a request is refused, say so and ask the user.
- Do not put the user's name, email address or project details into requests to outside services.
- When unsure, ask; do not guess about the user's setup. Never make implicit assumptions: state each one.
