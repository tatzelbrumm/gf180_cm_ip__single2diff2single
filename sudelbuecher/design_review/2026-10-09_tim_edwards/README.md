<!--
SPDX-FileCopyrightText: 2026 Christoph Maier
SPDX-License-Identifier: Apache-2.0
-->
# Schematic design review with Tim Edwards, 2026-10-09

`single2diff2single_review_2026-10-09.pdf` (20 pages, A4) is the review packet for both projects:
sg13cmos5l (Chipalooza #2) and GF180 (Chipalooza #3). It covers status, questions for Tim, schematic
drawings, layout state, CACE results, flows under development, and links into the logs.

- Same content as the published page "single2diff2single Schematic Review" (claude.ai artifact
  `C1hFX4Z3ikt6sPZGDw2wiw`, private until shared).
- Links point at the pushed state: sg13cmos5l `pcells` 865a7bb and `sudel_buecher` fad5834;
  gf180 `main` deddafd and `sudel_buecher` a12ad6b. Log line numbers refer to those versions.
- GF180 drawings: exported from the local working tree, so they include the hand edits of 2026-10-09
  (local commit 64f5edb, not pushed at the time). xschem 3.4.8RC built in a cloud container,
  symbols from `fossi-foundation/globalfoundries-pdk-libs-gf180mcu_fd_pr`.
- sg13cmos5l drawings: the SVG figures already committed on `sudel_buecher`
  (`design_considerations/class_ab_pad_driver/improvements/figures/`, `sg13cmos5l_IOPadInOut30mA/`,
  `sg13cmos5l_IOPadAnalog/`).
- PDF printed from the page's HTML with headless Chromium (Playwright); schematics stay vector.
- Session log: `../../chatlog/2026-10-09_opus_design_review_packet_for_tim_edwards.md`.
