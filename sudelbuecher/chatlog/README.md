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

[2026-11-13_sonnet-opus_iic_osic_tools_cloud_config_setup.md](2026-11-13_sonnet-opus_iic_osic_tools_cloud_config_setup.md)
: Whole chat "IIC-OSIC-TOOLS cloud config setup", 2026-11-13 to 2026-11-20 (156 user messages): claude-cloud-config for sky130 and gf180; the GF180 harness flow in the IIC container (PDK overlay, timestamp mismatches, Magic bugs `is_locked` and `GDS_FILE`, `set_user_id.py` port, Magic 8.3.705, ciel PDK e7a6777, Tim's `bf1d19b`); hand-off. Extracted by `build_chatlog_claudeai.py` from the conversation JSON, checked by `verify_chatlog_claudeai.py`; references in [`ref/2026-11-13_sonnet-opus_references.md`](ref/2026-11-13_sonnet-opus_references.md); supersedes the text-copy log below; reasoning not included.

[2026-11-13_sonnet_cloud_config_and_gf180_pad_work.md](2026-11-13_sonnet_cloud_config_and_gf180_pad_work.md)
: Whole chat of 2026-11-13 to 2026-11-18 (48 user messages): claude-cloud-config for sky130 and gf180, logging scheme, git consistency check, KLayout technology, PDK overlay, make padframe, GDS export, font/alpha/SRAM libraries; built by `build_chatlog_fragments.py` from nine text copies of the app chat, not a script export of a raw transcript; markup of replies restored by heuristic, reasoning not included.

[2026-11-26_fable_pad_structures_and_esd_exploration.md](2026-11-26_fable_pad_structures_and_esd_exploration.md)
: Exploration of the existing GF180 pad structures for the brief `docs/AGENT_BRIEF_PAD_STRUCTURES.md` (branch `pad_esd_exploration`): the pad library `gf180mcu_ocd_io` and its analog pad `asig_5p0` from netlist and GDS, the pads in the harness padframe, the foundry manual's ESD data, the evampire page checked against the files, the IHP parametric cells, and proposals for `claude-cloud-config`; chat log convention chosen during the session (this branch's `export_chatlog.py`, checked with the harness fork's `verify_chatlog.py`). Rebuilt later the same day to add the second part: KLayout support of the PDK and of the pads measured, and a search of other public sources for ESD data. Note: the first message, shown as "User", is the session's seed prompt, sent by the session that created this one, not typed by Christoph here; his own messages are the four sent while the assistant was working and the one that opens the second turn. Three subagent reports are not in the log; they are filed verbatim in `../logs/pad_esd_exploration/`.

[2026-11-26_fable_pad_structures_subagent_1_ihp_parametric_cells_survey.md](2026-11-26_fable_pad_structures_subagent_1_ihp_parametric_cells_survey.md)
: Subagent of the pad structure session (started by the assistant, not by Christoph): survey of the IHP repository's parametric clamp, diode and pad-wiring generators; the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_2_ihp_parametric_cells_survey.md`.

[2026-11-26_fable_pad_structures_subagent_2_extract_evampire_esd_page_claims.md](2026-11-26_fable_pad_structures_subagent_2_extract_evampire_esd_page_claims.md)
: Subagent of the pad structure session: extraction of the claims of the evampire page on gf180mcu I/O cell protection and five sibling pages (web fetches only); the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_1_extract_evampire_esd_page_claims.md`.

[2026-11-26_fable_pad_structures_subagent_3_public_gf180_esd_sources_search.md](2026-11-26_fable_pad_structures_subagent_3_public_gf180_esd_sources_search.md)
: Subagent of the pad structure session: search of public sources for ESD data on the open GF180 pads (web searches, GitHub searches, public repositories); the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_3_public_gf180_esd_sources_search.md`.

[2026-11-26_fable_pad_structures_subagent_4_ieee_abstracts_on_esd_pulse_limits.md](2026-11-26_fable_pad_structures_subagent_4_ieee_abstracts_on_esd_pulse_limits.md)
: Subagent of the pad structure session: attempt to read four public IEEE Xplore abstract pages on pulsed current limits (page-fetch tool only; all four fetches failed because the tool could not resolve the host); the message shown as "User" is the assistant's brief. Its report: `../logs/pad_esd_exploration/2026-11-26_fable_subagent_report_4_ieee_abstracts_on_esd_pulse_limits.md`.

[2026-11-28_custom_pads_exploration.md](2026-11-28_custom_pads_exploration.md)
: Custom analog pads for slot 16, for the brief `docs/AGENT_BRIEF_CUSTOM_PADS.md` (branch `custom_pads_exploration`): where the harness depends on the pad type, the form factor measured from the PDK views, the views a custom pad needs, and a scratch trial of two renamed copies of the analog pad as placeholders (silent failures found, three harness patches make the quick steps run clean); the message shown as "User" is the task prompt the session was started with. Made with `session_chatlog.sh` of the harness fork (branch `sudel_buecher`) as the brief asks, not with `export_chatlog.py`; model not named in the file name.
  Repository labels in this chat log (note added 2026-11-28, later the same day): the log is the verified transcript and
  uses the labels of the brief as they were said, A = `tatzelbrumm/gf180_cm_ip__single2diff2single`,
  B = `tatzelbrumm/gf180mcu_ocd_chipalooza`, C = `tatzelbrumm/claude-cloud-config`,
  D = `tatzelbrumm/sg13cmos5l_cm_ip__single2diff2single`, Upstream = `RTimothyEdwards/gf180mcu_ocd_chipalooza`. On the
  user's instruction ("Your A and B labels are obfuscating. Don't use them. Replace them everywhere and correct the logs
  accordingly.") the labels were replaced by these names in the brief, plan and journal on `custom_pads_exploration`
  (commit `8ee0074`) and in the fork's `custom_padframe` (`be10078`); the chat log itself was not edited, because a
  changed transcript would no longer match its check file and the session it was verified against.
