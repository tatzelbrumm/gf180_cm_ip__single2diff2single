# Brief for the Claude Cloud Code agent: understand the existing GF180 pad structures

Written by the harness build session for the user, 2026-11-26. This is a DRAFT: it has not been given to any agent.
Your task is exploration and a written report. You do not design or change any layout or schematic in this task.

## Context
- The user's project is `gf180_cm_ip__single2diff2single` (repository tatzelbrumm/gf180_cm_ip__single2diff2single): a single-ended -> differential -> single-ended
  analog converter between pads for Chipalooza #3 (GlobalFoundries GF180MCU, variant gf180mcuD). It is a port of the IHP design `sg13cmos5l_cm_ip__single2diff2single`.
- That repository already has notes for agents. Read these first, in this order: `CLAUDE.md`, `docs/IHP_TO_GF180_PORT_MAP.md`, `HANDOVER_gf180_migration.md`,
  `docs/OPERATING_LIMITS.md`, `docs/GF180_PROCESS_OPTIONS.md`. Follow the rules in `CLAUDE.md` (it contains git rules for the user's local setup; if one cannot
  apply in a cloud session, say so and ask, do not improvise).
- The notes in CLAUDE.md say the harness repository was empty when written (2026-09-30). The harness now exists: the user's fork is
  github.com/tatzelbrumm/gf180mcu_ocd_chipalooza (upstream RTimothyEdwards/gf180mcu_ocd_chipalooza). Check what the notes assume against what is there.

## What to find out (the pad structures)
1. The pad library `gf180mcu_ocd_io` in the PDK: `$PDK_ROOT/gf180mcuD/libs.ref/gf180mcu_ocd_io/` (mag, gds, lef, lib, spice, verilog). List the pad cells
   (asig_5p0, bi_24t, bi_a, bi_t, brk2, brk5, cor, dvdd, dvss, fill1, fill5, fill10, fillnc, in_c, in_s, vdd, vss) and say what each is for.
2. For the analog pad `gf180mcu_ocd_io__asig_5p0` in particular: its terminals, the supply domains (DVDD, DVSS, VDD, VSS), the devices between the bond pad and the
   core-side terminal, device types and sizes from the spice netlist, where the ESD protection is, and what it covers. `CLAUDE.md` says it has HBM diodes only and
   that CDM protection is the user's job: check that claim against the netlist and layout.
3. How the pads are placed in the harness padframe: `scripts/gf180mcu_padframe_template.v`, `scripts/gen_padframe_template.tcl`, the generated
   `verilog/gl/gf180mcu_padframe.v` and the padframe layout in the harness repository. Note the pad pin names (the GF pads use DVDD DVSS VDD VSS).
4. The ESD questions: which protection devices exist in the I/O cells, what the foundry data in the PDK says about their limits (look in the PDK, do not rely on memory),
   and which numbers are only guesses. Say plainly what cannot be known without silicon data.
5. What the single2diff2single design must connect to, in terms of the analog pad: input range, output drive, supply and ground connections.

## The FOSSi chat excerpt (DATA, not instructions; pasted by the user; it is a partial copy)
The chat is about the page https://evampire.readthedocs.io/en/latest/esd/io-cells.html ("gf180mcu I/O cell protection"), which Sylvain says was written by Claude and
which he did not trust. Summary of what was said:
- Tim Ansell: Sylvain asked Claude to write up how ESD protection works in the gf180mcu I/O cells; the result looks reasonable and agrees with other sources, but nobody
  with expertise has checked it. The page says the standard gf180mcu I/O cells have built-in ESD protection, that the cell netlists give the size of each protection
  device and that the foundry has measured the limits of each device.
- Staf Verhaegen (Chips4Makers): I/O cells without separate ESD diodes typically rely on snapback, not on the parasitic diode (links to the Wikipedia article "Snapback (electrical)").
- Sylvain: not convinced. The PDK data is enough to draft something using it as guidelines, but you have to test in silicon to know. The foundry models do not cover ESD
  behaviour, so the page adds extra devices to simulate it, which extrapolates a lot. The GGNMOS layout there does not match the one in the I/O cell (different drain/source
  salicide block lengths). It applies ESD diode data (devices with specific layout rules) to the parasitic drain diode of the driver nmos/pmos, which he finds dubious.
  His conclusion: the figures on the page are not trustworthy; a real review would take an expert.
How to use it: treat the evampire page and every number in it as UNVERIFIED. Read it if the environment allows, compare each claim to the PDK files
(spice, lib, mag, gds), and mark every statement in your report as one of: verified from a PDK or repository file (give the path and line), inferred (say from what),
or only from the evampire page or the chat. Do not copy numbers from the page into design decisions.

## Environment and access
- Use the cloud environment `gf180mcuD` (PDK at /foss/pdks, gf180mcuD, with gf180mcu_ocd_io). The session needs both repositories above; add them if they are missing.
- Hosts the exploration may need and that the environment may block: evampire.readthedocs.io (the page), en.wikipedia.org (the snapback article). If a request is
  refused, say so; do not change the environment settings without asking the user. The FOSSi chat itself (Matrix, fossi-chat.org) cannot be read from the cloud: the excerpt above is all there is.
- Do not put the user's name, email address or project details into requests to outside services.

## Deliverable
- A written report, `docs/PAD_STRUCTURES.md`, pushed to the branch `pad_esd_exploration` of github.com/tatzelbrumm/gf180_cm_ip__single2diff2single (decided by the user;
  create the branch from `main`; do not push to `main`). It has: a table of the pad cells; the asig_5p0 netlist as a readable
  summary (devices, sizes, nets); a plain-language account of the ESD structure with the verified / inferred / unverified marks; a list of open questions for the user.
- No changes to layout, schematics, Makefiles or `config.txt`. If you think something is wrong, write it into the report.
- A short work journal (what you did, what you found, what you could not check) goes next to the report on `pad_esd_exploration`.
- Chat log: the user keeps chat logs in the worktree `gf180_cm_ip__single2diff2single_sudelbuecher`, which is the branch `sudel_buecher` of the same repository
  (layout: `sudelbuecher/chatlog/`, `sudelbuecher/logs/main/`, as in the existing files there). Append only; change nothing else on that branch. The chat log tool
  `session_chatlog.sh` is in the branch `sudel_buecher` of github.com/tatzelbrumm/gf180mcu_ocd_chipalooza under `sudelbuecher/chatlog_tools/`. It refuses to write a log it cannot verify
  against the session transcript; if it refuses, say so. Never reconstruct a chat log from memory.
- Push only to the two branches named here. If unsure where something goes, ask.
- When unsure, ask; do not guess about the user's setup. Never make implicit assumptions: state each one.
