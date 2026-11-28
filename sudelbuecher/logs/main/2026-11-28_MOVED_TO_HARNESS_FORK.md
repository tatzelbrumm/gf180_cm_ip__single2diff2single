# 2026-11-28: harness files moved to `tatzelbrumm/gf180mcu_ocd_chipalooza`, history of this branch rewritten

On the user's instruction of 2026-11-28 ("go ahead with 1–4, move the history to gf180mcu_ocd_chipalooza"), these
files, which concern only the harness, were moved from this branch (`sudel_buecher` of
`tatzelbrumm/gf180_cm_ip__single2diff2single`) to the branch `sudel_buecher` of `tatzelbrumm/gf180mcu_ocd_chipalooza`,
directory `sudelbuecher/logs/custom_padframe/` (same file names; MANIFEST rows in that branch's `sudelbuecher/MANIFEST.tsv`):

- `2026-11-28_padframe_gds/` (2 padframe GDS of about 10 MB each, their write logs, `write_logo.sh`, `README.md`)
- `2026-11-28_custom_padframe_*.out` (9 run logs) and `2026-11-28_custom_padframe_rebase_hash_map.tsv`
- `2026-11-28_custom_pads_trial_{base_summary,base_vs_custom,custom_summary}.out`

There, each original commit is replayed as one commit with the original author, author date and message and the
original hash named (`19e3291`, `eb62a7c`, `404cf62`, `41ae970`).

Here, the history was rewritten with git-filter-repo 2.47 (`a40bce548d2c`), only for the commits from `7a08aa1` on
(`--refs 7a08aa1^..sudel_buecher`): the files above were removed from every commit, their 19 rows from every
version of `sudelbuecher/MANIFEST.tsv`; nothing else in any tree changed. Commits before `7a08aa1` (2026-11-28
01:10 UTC) keep their hashes. The rewritten commits lost their signatures (git-filter-repo removes them), so GitHub
shows them as unverified. Old → new hashes:

| old | new | commit |
| --- | --- | --- |
| `7a08aa1` | `2818248` | 2026-11-28 01:10 +0000 Claude: sudelbuecher : chat log of the custom pads session (slot 16), tr |
| `fd41e47` | (removed: it only added moved files) | 2026-11-28 03:07 +0000 Claude: sudelbuecher/logs/main: run logs of the custom_padframe harness  |
| `0272acd` | (removed: it only added moved files) | 2026-11-28 03:47 +0000 Claude: sudelbuecher/logs/main: padframe GDS of the harness fork (main 2 |
| `c9623e3` | `8076f64` | 2026-11-28 03:50 +0000 Claude: sudelbuecher/chatlog/README.md: what the repository labels A-D i |
| `619077e` | `54db65a` | 2026-11-28 04:07 +0000 Claude: sudelbuecher: map of the custom_padframe commit hashes before an |
| `19134a1` | `d3b53bd` | 2026-11-28 04:50 +0100 Christoph Maier: Merge remote-tracking branch 'origin/sudel_buecher' int |
| `25db6ad` | `9a55366` | 2026-11-28 04:52 +0100 Christoph Maier: Merge remote-tracking branch 'refs/remotes/origin/sudel |

The chat log `sudelbuecher/chatlog/2026-11-28_custom_pads_exploration.md` and the notes in
`sudelbuecher/chatlog/README.md` still name the old paths and hashes; they were not edited.
