# Brief for the Claude Cloud Code agent: understand the existing GF180 pad structures

Written by the harness build session for the user, 2026-11-26. This is a DRAFT: it has not been given to any agent.
Your task is exploration and a written report. You do not design or change any layout or schematic in this task.

## Context
- The user's project is `gf180_cm_ip__single2diff2single` (repository tatzelbrumm/gf180_cm_ip__single2diff2single): a single-ended -> differential -> single-ended
  analog converter between pads for Chipalooza #3 (GlobalFoundries GF180MCU, variant gf180mcuD). It is a port of the IHP design `sg13cmos5l_cm_ip__single2diff2single`.
- That repository already has notes for agents. Read these first, in this order: `CLAUDE.md`, `docs/IHP_TO_GF180_PORT_MAP.md`, `HANDOVER_gf180_migration.md`,
  `docs/OPERATING_LIMITS.md`, `docs/GF180_PROCESS_OPTIONS.md`. Follow the rules in `CLAUDE.md`. Its section 3 now says: git is granted in cloud sessions (use it normally, for the two branches named below);
  in the user's local `~/EDA` setup only read-only git without lock files is allowed. Section 5 was updated on 2026-11-26 to what the harness and the PDK now contain.
  The `CLAUDE.md` you read is the one in the checkout of the branch `pad_esd_exploration`; this task does not change it any further.
  Check its section 5 against what you find; if something there is wrong, say so in your report.
- The notes in CLAUDE.md say the harness repository was empty when written (2026-09-30). The harness now exists: the user's fork is
  github.com/tatzelbrumm/gf180mcu_ocd_chipalooza (upstream RTimothyEdwards/gf180mcu_ocd_chipalooza). Check what the notes assume against what is there.

## Repositories (A, B, C), by full name
- **A** `tatzelbrumm/gf180_cm_ip__single2diff2single`: the user's design repository, the source of this session. Push only to its branch `pad_esd_exploration`
  (report, journal, proposals) and append chat logs to its branch `sudel_buecher`. Never push to `main`.
- **B** `tatzelbrumm/gf180mcu_ocd_chipalooza`: the user's fork of the Chipalooza #3 harness (upstream RTimothyEdwards/gf180mcu_ocd_chipalooza). Read only.
  Attach it with `add_repo` (read access) and clone it; it has the padframe scripts, the slot wrappers, and the chat log tool on its branch `sudel_buecher`.
- **C** `tatzelbrumm/claude-cloud-config`: public, read only. Clone it anonymously (no attachment needed); never push to it. It builds the cloud environment (toolchain,
  PDK install scripts); it holds no process specification and no design rules (checked 2026-11-26 on its `main` branch: `README.md`, `CLAUDE.md`, `parts/`, `setup-*.sh`).
  Your use of C: while you work, note what information about the process, the PDK, the pad library and the harness you had to dig out, and propose what
  `claude-cloud-config` should carry so the next agent finds it directly (see "Deliverable", proposals).
- The FOSSi chat excerpt below names no repository, only two web pages (the evampire page and a Wikipedia article). Both are public. The environment now allows
  `evampire.readthedocs.io` and `en.wikipedia.org`. If the evampire page links to its source repository on github.com, you may read that (public, read only).

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
- Hosts: `evampire.readthedocs.io` (the page) and `en.wikipedia.org` (the snapback article) were added to the environment's allowed hosts on 2026-11-26 and answered HTTP 200.
  If a request is refused anyway, say so; do not change the environment settings without asking the user. The FOSSi chat itself (Matrix, fossi-chat.org) cannot be read from the cloud: the excerpt above is all there is.
- Do not put the user's name, email address or project details into requests to outside services.

## Deliverable
- A written report, `docs/PAD_STRUCTURES.md`, pushed to the branch `pad_esd_exploration` of github.com/tatzelbrumm/gf180_cm_ip__single2diff2single (decided by the user;
  the branch already exists and holds this brief: check it out and add your commits on top of it; never push to `main`, never force-push, never rebase it).
  It has: a table of the pad cells; the asig_5p0 netlist as a readable
  summary (devices, sizes, nets); a plain-language account of the ESD structure with the verified / inferred / unverified marks; a list of open questions for the user.
- No changes to layout, schematics, Makefiles or `config.txt`. If you think something is wrong, write it into the report.
- Proposals for `claude-cloud-config`: a file `docs/PROPOSALS_FOR_CLAUDE_CLOUD_CONFIG.md` on `pad_esd_exploration`. For each proposal: what to add (file name and a draft of its
  content, or an outline), why (what you had to search for and where you found it), and a source for every fact (PDK path, repository path, URL). Keep process facts, design rules,
  pad library facts and the slot interface apart, and mark every statement verified / inferred / unverified as in the report. The user will hand the proposals over to
  `claude-cloud-config` when they ask; you never push there.
- A short work journal (what you did, what you found, what you could not check) goes next to the report on `pad_esd_exploration`.
- Chat log: the user keeps chat logs in the worktree `gf180_cm_ip__single2diff2single_sudelbuecher`, which is the branch `sudel_buecher` of the same repository
  (layout: `sudelbuecher/chatlog/`, `sudelbuecher/logs/main/`, as in the existing files there). Append only; change nothing else on that branch. The chat log tool
  `session_chatlog.sh` is in the branch `sudel_buecher` of github.com/tatzelbrumm/gf180mcu_ocd_chipalooza under `sudelbuecher/chatlog_tools/`. It refuses to write a log it cannot verify
  against the session transcript; if it refuses, say so. Never reconstruct a chat log from memory.
- Push only to the two branches named here. If unsure where something goes, ask.
- When unsure, ask; do not guess about the user's setup. Never make implicit assumptions: state each one.
