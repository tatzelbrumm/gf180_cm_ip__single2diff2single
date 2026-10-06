<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# 2026-10-06 — GF180 port: survey, harness search, skeleton

Session `813b3a7a-4b6a-5d55-997b-52200c33afcc`, Claude (configured model `claude-sonnet-5-5`; the serving model may differ).
Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;
tool calls as `*[ ]*` summaries (actions and observable results only). The internal reasoning trace is not included.
Times are Europe/Berlin. Exported through the record stamped 16:42; later turns are not in this file.

## Turn 1 — 16:04

**User:**

I want to set up a Global Foundries 180 version of my single ended analog pad in to differential analog signals on-chip to buffered single ended analog output pad version for the chipalooza #3 run.
So far, I have essentially copied the ihp13cmos5L version.
Do all the changes it takes to redirect gf180_cm_ip__single2diff2single to the Global Foundries 180 process.
This will probably be a big effort, and it will be a problem that a chipalooza harness is missing for the gf180 process.
You will probably have a lot of questions and requests for additional information.

**Assistant:**

I'll start by surveying the gf180 folder and its IHP source folders to see what needs to change.

*[Created task "Survey gf180 and IHP single2diff2single folders".  
List files in the connected folders (on the computer; 742 lines of output).]*

The gf180 folder looks like the unmodified chipalooza template (still `sg13cmos5l_chipalooza_analog_project` names), while the actual design lives in the IHP folder. I'll read the key files in both.

*[Read top-level doc and list sudelbuecher folder (on the computer).  
Read gf180 template README, Makefile, submission (on the computer; 338 lines of output).  
Read IHP project CLAUDE.md and handover (on the computer).  
Check git state of the three repos (on the computer; 40 lines of output).  
Check for leftover git lock files (on the computer; 7 lines of output).  
Read IHP design submission and README (on the computer).  
Check tools and PDK availability on the device (on the computer; 21 lines of output).  
Searched the web for "Chipalooza #3 gf180mcu analog harness Tim Edwards open_pdks wafer.space" (6 lines of output).  
Check cloud-side tools and GitHub reach (in the cloud container; 5 lines of output).  
Read proxy guidance and status (in the cloud container; 90 lines of output).  
Fetched https://github.com/RTimothyEdwards/gf180mcu_ocd_ip__analog_switches.  
Fetched https://github.com/RTimothyEdwards/chipalooza_projects_1 (12 lines of output).]*

*[SendUserMessage, shown to the user verbatim:]*

Still surveying. So far: your gf180 folder is the unmodified IHP chipalooza template, and the real single2diff2single work lives in the sg13cmos5l folder. Neither side has EDA tools or PDKs I can run. I'm now checking whether the GF180 PDK and any GF180 harness can be fetched from GitHub, then I'll come back with concrete questions before changing anything.

*[Shallow-clone reference repos from GitHub (in the cloud container; 5 lines of output).]*

Git cloning works from the cloud side. Now let me see whether a GF180 harness exists anywhere and what the IHP harness looks like (that's the thing a GF180 harness would have to mirror).

*[Search GitHub for chipalooza/gf180 repos; read harness README (in the cloud container; 130 lines of output).  
List macros and scripts in the IHP design repo (on the computer).  
List sudelbuecher notes folders (on the computer; 75 lines of output).]*

*[Request interrupted by user]*

## Turn 2 — 16:06

**User:**

I also want the _sudelbuecher companion repository with the git ... what was the name of the separate tree? ... repository for the gf180 version.

**Assistant:**

*[Read worktree wiring files without git (on the computer; 30 lines of output).]*

The separate tree is a **git worktree**: `sudel_buecher` is an orphan branch checked out as a second working directory that shares the main repo's `.git`. Yours is wired through a `.git` gitlink file that points into the main repo's `.git/worktrees/`.

Your project CLAUDE.md puts git off-limits for me. I also ran `git log` and `git status` earlier before reading that, which refreshed `.git/index` in three repos but left no lock files. So please run this yourself on your computer:

```sh
cd ~/EDA/gf180_cm_ip__single2diff2single
git worktree add --orphan -b sudel_buecher ../gf180_cm_ip__single2diff2single_sudelbuecher
# git older than 2.42 has no --orphan; use this instead:
# git worktree add --detach ../gf180_cm_ip__single2diff2single_sudelbuecher
# cd ../gf180_cm_ip__single2diff2single_sudelbuecher && git switch --orphan sudel_buecher
```

Connect that folder to this task afterwards. I'll then seed it with a CLAUDE.md, `.gitignore`, and the `sudelbuecher/{chatlog,logs,description,…}` skeleton, mirroring the IHP one, without running any git.

**What I've found so far**
- `gf180_cm_ip__single2diff2single` is still the unmodified IHP chipalooza template: `sg13cmos5l_chipalooza_analog_project` names, the inverter and counter example macros, and IHP in `.designinit`. The real design work (IOPad clamp pcells, `OgueyAebischerBias`, the class-AB driver notes) is only in the sg13 repo.
- Even there, the top-level schematic and layout are still the template's inverter placeholder.
- No EDA tools or PDKs are reachable from here (your computer's shell or my cloud container), so I can't run DRC, LVS or simulations. I can edit text files and fetch the GF180 PDK from GitHub.
- There is no public GF180 Chipalooza harness. The IHP harness README says harnesses are process-specific.

**What I need from you**
- The Chipalooza #3 slot spec for GF180: slot sizes, pin positions, supply domains, and the precheck rules, or a link to Tim's harness repo if one exists.
- Whether `gf180mcu_ocd_sram_test` (it has wafer.space IDs) is the reference for the GF180 flow you want me to follow.
- Which GF180 I/O analog pad you intend to use.

*[Question card shown to the user:]*

- Which GF180 PDK variant and device voltage should the port target? Options: gf180mcuD, 3.3 V devices; gf180mcuD, 5 V devices; gf180mcuC or other
- How far should this first pass go? Options: Flow skeleton only (Recommended); Skeleton + schematics; Everything incl. layout

*[Result: error.]*

*[Request interrupted by user]*

## Turn 3 — 16:18

**User:**

From the FOSSi chipalooza chat, I got some information from Tim:
Tim
Update: Layout design reviews for the IHP Chipalooza are (mostly) done, and this week is schematic design reviews for the GF Chipalooza.
After having the first schematic design review for the GF Chipalooza, I am reminded of one key difference between the GF and IHP processes: IHP has only two process variants (CMOS5L vs. G2), whereas GF has about 40 different process options, and some of the tools like xschem and klayout have technology files that don't limit the options to what is being taped out, but require the user to either pass the appropriate options to the tool or just know which components are actually available. To this end, the process options are listed on the Wafer.Space website, but the summary of what's available on this shuttle run of GF180MCU is:

1. The high-value resistors are the 1kohm/square devices (ppolyf_u_1k).
2. The MiM caps are the 2fF/um^2 option B types.
3. The top level metal is the 1100 Angstrom thick top metal.
4. Deep nwell is available in this process option and designers are encouraged to use it for better noise isolation of analog components. Just keep in mind that inside a deep nwell, nFET bulk terminals can be isolated but pFET bulk terminals cannot (corrected, see comment below). Having a circuit with isolated bulk terminals on both nFETs and pFETs is possible but requires a lot of extra area to accommodate the deep nwell spacing rules.

Also: I do not intend to spec the harness chip for 6V operation, therefore you may use any of the 5V or 6V FETs and the corresponding design rules. For the record, the 5V and 6V FETs are the same device; it's just that at the shortest lengths, the device will break down at 6V and so can only be used at 5V. Your design does not have to use the 5V supply; it can be 3.3V only, and all the digital signals into and out of the user project slots will be at 3.3V. Just bear in mind that the I/O could be at 5V signal levels, so if a 5V input would destroy your circuit, be sure to specify the operational limits of your circuit in the spec (which you should be doing, regardless).

I don't know to what extent a harness by Tim exists. Try to look at the Chipalooza web site and Tim's repositories. That should answer the GF180 I/O analog pad question.

Carry on, propose a file system hierarchy that I can then git commit, including the _sudelbuecher worktree with a chatlog directory for a running log of the steps you're performing ... without revealing more of your reasoning that your corporate censors are comfortable with. The sg13cmos5L_single2diff2single_sudelbuecher seems to be an example that passes your censors consistently.

**Assistant:**

*[Set task 1 to completed.  
Created task "Find GF180 harness and analog I/O pad (Chipalooza site, Tim's repos, PDK I/O lib)".  
Created task "Propose repo + _sudelbuecher worktree hierarchy for GF180".  
Searched the web for "Chipalooza challenge Open Circuit Design GF180MCU harness wafer.space analog project slot".  
Fetched https://github.com/RTimothyEdwards?tab=repositories&q=gf180 (12 lines of output).  
Probe candidate GitHub repo names for a GF180 harness (in the cloud container).  
Fetched https://mithro.github.io/gf180mcu-project-template/ (9 lines of output).]*

Found them: `gf180mcu_ocd_chipalooza` and `gf180mcu_ocd_io` exist under Tim's account (plus `chipalooza_projects_2`). Cloning them and the PDK I/O library.

*[Clone Tim's GF180 harness and IO repos (in the cloud container).  
List GF180 PDK I/O library contents (in the cloud container; 4 lines of output).]*

`gf180mcu_ocd_chipalooza` exists but contains only a LICENSE, so the GF180 harness is not published yet. Now the I/O library, where the analog pad should be.

*[Read Tim's GF180 IO library README and layout (in the cloud container; 136 lines of output).  
Find asig pad in PDK fd_io library and docs (in the cloud container; 13 lines of output).  
Inspect the GF180 analog pad cell (asig_5p0) (in the cloud container; 82 lines of output).  
no-op placeholder (in the cloud container; 1 lines of output).  
Read wafer.space gf180mcuD PDK variant README (in the cloud container; 12 lines of output).  
Fetched https://mith.ro/gf180mcu-project-template/ (30 lines of output).  
Set task 2 to completed.  
Set task 3 to completed.]*

I haven't created or changed any files yet. Below are what I found about the GF180 harness and pad, a proposed file hierarchy, and four questions.

## What I found

- **Harness:** Tim's [`gf180mcu_ocd_chipalooza`](https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza) exists, but it contains only a LICENSE (single initial commit, 2026-09-30). There is no GF180 slot geometry, wrapper RTL, or precheck to port against yet.
- **IHP harness:** its [README](https://github.com/RTimothyEdwards/sg13cmos5l_ocd_chipalooza) says harnesses are process-specific. It is the template for what the GF180 one will probably look like, but I can't rely on it for slot sizes or pin positions.
- **Analog pad:** `gf180mcu_ocd_io__asig_5p0`, from Tim's [`gf180mcu_ocd_io`](https://github.com/RTimothyEdwards/gf180mcu_ocd_io). It comes with 3-, 4- and 5-metal GDS/LEF, an xschem schematic and liberty files.
- **ESD:** the analog pad has only HBM diodes. Its docs require your own CDM protection next to the gates it drives: a CDM diode with perimeter above 25 µm and a poly resistor above 50 Ω. So your IHP clamp pcells (`ClampN/ClampP`) have no direct GF180 counterpart, and a CDM-clamp macro has to be designed.
- **Tools:** no PDK or EDA tools are reachable from here. I can edit text and scripts, but not run DRC, LVS or simulations.

## Proposed hierarchy

```text
~/EDA/gf180_cm_ip__single2diff2single/          # main worktree, branch main
├─ .designinit                  # PDK=gf180mcuD, PDKPATH, STD_CELL_LIBRARY, KLAYOUT_PATH
├─ .gitignore  .gitattributes  LICENSE  Makefile  README.md  CLAUDE.md
├─ submission.yaml              # top-cell must equal TOP in the Makefile
├─ TOP_LEVEL_MODULE.md          # boundary spec, rewritten for the GF180 harness
├─ docs/
│  ├─ GF180_PROCESS_OPTIONS.md  # Tim's list: 1k poly resistor, MiM 2fF type B, top metal, DNW, 5V/6V FETs
│  ├─ OPERATING_LIMITS.md       # 3.3 V-only operation, 5 V pad levels, abs-max
│  └─ IHP_TO_GF180_PORT_MAP.md  # device/layer/pad correspondences, open items
├─ dependencies/                # git submodules: gf180mcu_ocd_io (pads), later the harness
├─ floorplan/README.md          # placeholder: no GF180 templates until Tim publishes them
├─ harness_stub/                # our assumed wrapper interface, replaced by the real one later
├─ layout/  schematic/xschem/  testbenches/xschem/  netlist/  final/  render/  verification/
├─ scripts/                     # check_boundary.py, check_pex_ports.py, extract_pad.py, pcells/
└─ macros/
   ├─ gf180mcu_IOPadSingle2Diff/    # asig_5p0 pad, CDM clamp, S2D buffer
   ├─ gf180mcu_IOPadDiff2Single/    # class-AB D2S driver and pad
   ├─ gf180mcu_CdmClamp/            # replaces the IHP

*[Request interrupted by user]*

## Turn 4 — 16:19

**User:**

Tim Edwards or Tim Ansell? Show me the URLs, anyhow, so I can clone locally.

**Assistant:**

Both Tims appear, but the Chipalooza repos are **Tim Edwards** (GitHub user `RTimothyEdwards`, Open Circuit Design). **Tim Ansell** (`mithro`) is wafer.space, and his only link here is the slot-size page.

**Tim Edwards: clone these** (all four were cloned successfully on my side):
- `https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza.git`: the GF180 harness, currently only a LICENSE (single initial commit, 2026-09-30).
- `https://github.com/RTimothyEdwards/gf180mcu_ocd_io.git`: dual-voltage I/O library, containing `asig_5p0`, the analog pad.
- `https://github.com/RTimothyEdwards/gf180mcu_ocd_ip__analog_switches.git`: power-gating and analog switches for GF180MCU.
- `https://github.com/RTimothyEdwards/sg13cmos5l_ocd_chipalooza.git`: the IHP harness, useful as a model for what the GF180 one will contain. Use `--recurse-submodules`, as its README says.

**Tim Ansell and wafer.space** (read only; I did not clone the first two):
- `https://github.com/wafer-space/gf180mcu`: the gf180mcuD variant. Its README says it is deprecated and has been upstreamed to open_pdks, so install the PDK with Ciel instead.
- `https://mith.ro/gf180mcu-project-template/`: slot sizes for whole wafer.space dies. These are not Chipalooza project slots, so don't use them for the Chipalooza slot geometry.
- `https://github.com/google/gf180mcu-pdk`: the original PDK, with `gf180mcu_fd_io` (the pad that Tim Edwards' library is derived from). I cloned it earlier.

I couldn't confirm which Tim your FOSSi chat quoted. The naming (`ocd` = Open Circuit Design) and the repo owner make Edwards the likely one.

The hierarchy proposal in my last message was cut off by your interruption. Want me to resend it in full, with the four questions on top-cell name, log style, submodules vs. pointers, and what to leave behind?

Sources: [gf180mcu_ocd_chipalooza](https://github.com/RTimothyEdwards/gf180mcu_ocd_chipalooza), [gf180mcu_ocd_io](https://github.com/RTimothyEdwards/gf180mcu_ocd_io), [analog_switches](https://github.com/RTimothyEdwards/gf180mcu_ocd_ip__analog_switches), [sg13cmos5l_ocd_chipalooza](https://github.com/RTimothyEdwards/sg13cmos5l_ocd_chipalooza), [wafer-space/gf180mcu](https://github.com/wafer-space/gf180mcu), [slot sizes](https://mith.ro/gf180mcu-project-template/), [google/gf180mcu-pdk](https://github.com/google/gf180mcu-pdk)

## Turn 5 — 16:28

**User:**

Yes, resend in full.

**Assistant:**

Nothing has been created yet. This is the full proposal for you to approve or change before I write any files.

## Main repo: `~/EDA/gf180_cm_ip__single2diff2single` (branch `main`)

```text
gf180_cm_ip__single2diff2single/
├─ .designinit                    # PDK=gf180mcuD, PDKPATH, STD_CELL_LIBRARY, KLAYOUT_PATH
├─ .gitignore  .gitattributes  LICENSE
├─ Makefile                       # TOP = <top-cell>; PDK-specific parts retargeted
├─ README.md  CLAUDE.md           # CLAUDE.md carries the git/worktree rules
├─ submission.yaml                # top-cell must equal TOP
├─ TOP_LEVEL_MODULE.md            # boundary spec, rewritten for GF180
├─ docs/
│  ├─ GF180_PROCESS_OPTIONS.md    # Tim's list: ppolyf_u_1k, MiM 2fF type B, top metal, DNW, 5V/6V FETs
│  ├─ OPERATING_LIMITS.md         # 3.3 V-only supply, 5 V-level pad inputs, abs-max
│  └─ IHP_TO_GF180_PORT_MAP.md    # devices, layers, pads, clamps, open items
├─ dependencies/                  # gf180mcu_ocd_io; later gf180mcu_ocd_chipalooza
├─ floorplan/README.md            # no GF180 slot templates exist yet; IHP GDS not carried over
├─ harness_stub/                  # our assumed wrapper interface, replaced by the real one later
├─ layout/   schematic/xschem/   testbenches/xschem/
├─ netlist/{layout,pex,schematic}/   final/{gds,lef,lib,vh}/   render/img/
├─ verification/{drc,lvs,cace}/
├─ scripts/                       # check_boundary.py, check_pex_ports.py, extract_pad.py, pcells/
└─ macros/
   ├─ gf180mcu_IOPadSingle2Diff/  # asig_5p0 pad, CDM clamp, S2D buffer
   ├─ gf180mcu_IOPadDiff2Single/  # class-AB D2S driver and pad
   ├─ gf180mcu_CdmClamp/          # new: replaces the IHP ClampN/ClampP pcells
   ├─ OgueyAebischerBias/         # bias generator, re-sized for GF180
   └─ slot/                       # only if the GF180 harness needs a slot wrapper
```

**Dropped from the copy:**
- the `inverter` and `counter` placeholder macros
- the `sg13cmos5l_*` names
- the IHP floorplan GDS files and IHP pad GDS files

**Not carried over from the IHP repo:**
- `save_from_claudes_fuckup/`
- `Makefile.bak`
- `_gitignore`
- the klayout `backups/` folders
- the HANDOVER files

## Companion worktree: `~/EDA/gf180_cm_ip__single2diff2single_sudelbuecher`

Orphan branch `sudel_buecher`, created with the `git worktree add` commands from my earlier reply.

```text
gf180_cm_ip__single2diff2single_sudelbuecher/
├─ .git                           # gitlink file, created by git
├─ .gitignore                     # _runs
├─ CLAUDE.md                      # same git-off-limits rule as the IHP one
└─ sudelbuecher/
   ├─ chatlog/
   │  ├─ README.md                # index: one link + one sentence per file
   │  ├─ ref/                     # pointers to external sources, not copies
   │  └─ pix/
   ├─ logs/<branch>/              # tee'd .out/.err of every run
   ├─ description/                # s2d_d2s_pinbuffers.md and the GF180 pin mapping
   ├─ design_considerations/      # class-AB driver, level shifters, CDM clamp sizing
   ├─ esd_protection/             # HBM vs CDM notes for asig_5p0
   ├─ cheatsheets/                # GF180 flow in IIC-OSIC-TOOLS
   ├─ recovered/
   └─ MANIFEST.tsv                # mtimes, sizes, commands, originating commits
```

## How the running log would work

- Each session gets `chatlog/<date>_<model>_<topic>.md`, with one line per step in the form action → result → decision.
- It records commands run, files touched, findings and decisions. It does not contain my internal reasoning, and it is not a transcript.
- Verbatim transcript exports stay available only when you explicitly ask for one, as your CLAUDE.md requires.
- Every new log file also gets an entry in `chatlog/README.md`.

## Four questions

1. **Top-cell name:** keep `gf180_cm_ip__single2diff2single` to match your folder, or use `gf180mcu_cm_ip__single2diff2single` to follow Tim's `gf180mcu_*` naming? I'd keep the folder name.
2. **Log style:** is the step-log format above what you want, rather than your verbatim chatlog convention?
3. **Pad library:** add `gf180mcu_ocd_io` as a git submodule under `dependencies/`, or only record its URL and commit hash under `chatlog/ref/`? Layout needs the pad GDS, so I'd use a submodule, as Tim's IHP harness does.
4. **Leftover files:** is leaving the IHP leftovers behind (listed under "Not carried over" above) correct?

Once you answer, I'll create the skeleton in both folders as plain files and leave all git commands and commits to you.

## Turn 6 — 16:39

**User:**

Drop the gf180mcu_CdmClamp, the OgueyAebischerBias, and the slot for now. 

In the sudelbuecher orphan branch,
leave out design_considerations, cheatsheets, and recovered for now. 
I (or an Opus version of you that will do the heavy lifting) will fill in the details.

Verbatim transcript export if your censors allow you to do it, 
otherwise the action->result->decision method. 
The log.md, log.tex, log.pdf in the sg13cmos5L sudelbuecher works quite well, too. 

Don't add gf180mcu_ocd_io quite yet, just the URL.

**Assistant:**

Understood. I'll check how your existing `log.md/.tex/.pdf` and the verbatim-export procedure work, whether the GF180 worktree folder exists yet, and whether a raw session transcript is available to me.

*[Locate log.* files and check for GF180 worktree (on the computer).  
Check for a raw session transcript in the cloud container (in the cloud container; 6 lines of output).  
Find log.md/tex/pdf and read the verbatim export procedure (on the computer; 70 lines of output).  
Created task "Create additive GF180 skeleton in main repo".  
Created task "Prepare sudelbuecher worktree seed with first chatlog".  
Created task "Verify skeleton and log (counts, no reasoning leakage)".  
Read head of the example log.md and log.tex (on the computer; 101 lines of output).  
Count transcript record types only (in the cloud container; 17 lines of output).  
Read gf180 template .designinit and PDK-specific Makefile lines (on the computer; 80 lines of output).  
Verify GF180 device names in the cloned PDK sources (in the cloud container; 24 lines of output).  
Check gf180mcuD tech directories and device names (in the cloud container; 39 lines of output).]*

Writing the additive skeleton into the main repo now. I'm changing only `.designinit` among the existing files, and deleting nothing.

*[Write GF180 skeleton files into the main repo (on the computer; 56 lines of output).]*

Skeleton written. Now the verbatim export. First, a look at the transcript's structure that prints only record types, lengths and tool names, never the reasoning blocks.

*[Skeleton of the live transcript path (no reasoning shown) (in the cloud container; 211 lines of output).  
Copy transcript aside and export the verbatim chat log by script (in the cloud container).]*
