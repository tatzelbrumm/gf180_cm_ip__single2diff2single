# CLAUDE.md — `_sudelbuecher` worktree

This directory is the `sudel_buecher` orphan-branch worktree of
`gf180_cm_ip__single2diff2single` — chat logs, run logs, provenance. No project files live here;
this branch shares the same `.git` object store as the main design worktree at
`~/EDA/gf180_cm_ip__single2diff2single`.

**Agent git access here: off-limits.** On this bridge the sandbox can create but not
`unlink`/`rename` files in a worktree's git metadata, so even a bare `status`/`log` can leave an
unremovable `index.lock`. Fix is host-side only. No git commands without asking first; if one
locks, name the exact file and stop — don't retry.

## What is filed where (`sudelbuecher/`)

- `chatlog/` — one file per session, `<date>_<model>_<topic>.md`, indexed in `chatlog/README.md`
  (one `[file](file)` + one sentence per file).
  - Verbatim export of the displayed conversation, built **by script** from the raw transcript
    (`~/.claude/projects/-home-claude/<session-id>.jsonl`, copied aside first). User messages and
    visible replies as written; tool calls as `*[ ]*` summaries (actions and observable results
    only). The reasoning trace stays out. Never retype or reconstruct.
  - If a verbatim export is not possible: action → result → decision entries in a running
    `log.md` (optionally `log.tex` / `log.pdf`).
  - `chatlog/ref/` — pointers to external sources, one file per session. Index, do not copy.
  - `chatlog/pix/` — images that belong to a session's notes.
- `logs/<branch>/` — tee'd `.out`/`.err` of every run.
- `description/` — design descriptions and pin mappings for this project.
- `esd_protection/` — notes on pad protection (HBM vs CDM) for the GF180 analog pad.
- `MANIFEST.tsv` — original mtimes, sizes, commands, originating commits.

Not created yet (left to the next session): `design_considerations/`, `cheatsheets/`, `recovered/`.
The IHP sibling worktree `sg13cmos5l_cm_ip__single2diff2single_sudelbuecher` has all three, plus
`verbatim_chatlog_recovery/` with the export procedure used here.
