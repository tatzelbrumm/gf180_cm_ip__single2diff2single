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
: Whole chat "IIC-OSIC-TOOLS cloud config setup" of 2026-11-13 to 2026-11-19 (138 user messages): cloud config for sky130 and gf180, PDK overlay, make padframe, timestamp mismatches, Magic 8.3.693, overlay from GDS, Magic is_locked bug, wrappers, symbols, gds-slots, set_user_id.py port, gds-prefill, the missing fill tech file, hand-off; extracted by `build_chatlog_claudeai.py` from the conversation JSON saved from claude.ai and checked by `verify_chatlog_claudeai.py`; supersedes the text-copy log below as the verbatim source; reasoning not included.

[2026-11-13_sonnet_cloud_config_and_gf180_pad_work.md](2026-11-13_sonnet_cloud_config_and_gf180_pad_work.md)
: Whole chat of 2026-11-13 to 2026-11-18 (48 user messages): claude-cloud-config for sky130 and gf180, logging scheme, git consistency check, KLayout technology, PDK overlay, make padframe, GDS export, font/alpha/SRAM libraries; built by `build_chatlog_fragments.py` from nine text copies of the app chat, not a script export of a raw transcript; markup of replies restored by heuristic, reasoning not included.
