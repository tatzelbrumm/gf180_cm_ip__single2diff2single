# Chatlog index

One `[file](file)` + one sentence per log. The logs are made with [`export_chatlog.py`](export_chatlog.py)
(usage and conventions: `CLAUDE.md` at the worktree root).

[2026-10-06_sonnet_gf180_port_survey_and_skeleton.md](2026-10-06_sonnet_gf180_port_survey_and_skeleton.md)
: Survey of the GF180 template copy and the IHP design, search for the GF180 harness and analog pad, process options from Tim Edwards, and the proposal and first files of the GF180 repo and this worktree.

[2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md](2026-10-06_opus_gf180_bias_port_cace_and_iopad_poc.md)
: Port of the IHP Oguey–Aebischer bias to GF180 in 03v3 and 06v0 variants with re-derived sizes, CACE suites built and run in a cloud toolchain, CDM input front end and input-range deck for gf180mcu_IOPadSingle2Diff, and the restore of the 2026-10-06 schematic versions (06–08 October).

[2026-10-08_fable_gf180_bandgap_reference_redesign.md](2026-10-08_fable_gf180_bandgap_reference_redesign.md)
: GF180 re-design of the class-AB driver's bandgap reference (ClassABBiasBG, wide-swing cascode, 3k poly resistors, deep-n-well variant compared), RefCoreEnable, round trip and four CACE suites, driver with the real reference (8–9 October).

[2026-10-09_opus_design_review_packet_for_tim_edwards.md](2026-10-09_opus_design_review_packet_for_tim_edwards.md)
: Review packet for the schematic design review with Tim Edwards on 2026-10-09: survey of both repos and their notes worktrees, GF180 sheets exported with a cloud-built xschem, published review page with schematic plates, layout and CACE status, flows, log links and questions for Tim.

[2026-11-26_fable_pad_structures_and_esd_exploration.md](2026-11-26_fable_pad_structures_and_esd_exploration.md)
: Exploration of the existing GF180 pad structures for the brief `docs/AGENT_BRIEF_PAD_STRUCTURES.md` (branch `pad_esd_exploration`): the pad library `gf180mcu_ocd_io` and its analog pad `asig_5p0` from netlist and GDS, the pads in the harness padframe, the foundry manual's ESD data, the evampire page checked against the files, the IHP parametric cells, and proposals for `claude-cloud-config`; chat log convention chosen during the session (this branch's `export_chatlog.py`, checked with the harness fork's `verify_chatlog.py`). Rebuilt later the same day to add the second part: KLayout support of the PDK and of the pads measured, and a search of other public sources for ESD data. Note: the first message, shown as "User", is the session's seed prompt, sent by the session that created this one, not typed by Christoph here; his own messages are the four sent while the assistant was working and the one that opens the second turn. Three subagent reports are not in the log; they are filed verbatim in `../logs/pad_esd_exploration/`.

[2026-11-26_fable_pad_structures_subagent_1_ihp_parametric_cells_survey.md](2026-11-26_fable_pad_structures_subagent_1_ihp_parametric_cells_survey.md)
: Subagent of the pad structure session (started by the assistant, not by Christoph): survey of the IHP repository's parametric clamp, diode and pad-wiring generators; the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_2_ihp_parametric_cells_survey.md`.

[2026-11-26_fable_pad_structures_subagent_2_extract_evampire_esd_page_claims.md](2026-11-26_fable_pad_structures_subagent_2_extract_evampire_esd_page_claims.md)
: Subagent of the pad structure session: extraction of the claims of the evampire page on gf180mcu I/O cell protection and five sibling pages (web fetches only); the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_1_extract_evampire_esd_page_claims.md`.

[2026-11-26_fable_pad_structures_subagent_3_public_gf180_esd_sources_search.md](2026-11-26_fable_pad_structures_subagent_3_public_gf180_esd_sources_search.md)
: Subagent of the pad structure session: search of public sources for ESD data on the open GF180 pads (web searches, GitHub searches, public repositories); the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_3_public_gf180_esd_sources_search.md`.
