# CLAUDE.md — `_sudelbuecher` worktree

This directory is the `sudel_buecher` orphan-branch worktree of
`gf180_cm_ip__single2diff2single` — chat logs, run logs, provenance. No project files live here;
this branch shares the same `.git` object store as the main design worktree at
`~/EDA/gf180_cm_ip__single2diff2single`.

Side quests get a branch of their own, branched from `sudel_buecher` (e.g. `rodovalho`), with their
files in `sudelbuecher/<topic>/` and their chat log on that branch. General changes (tools, this
file, conventions) go on `sudel_buecher`.

**Agent git access here: off-limits.** On this bridge the sandbox can create but not
`unlink`/`rename` files in a worktree's git metadata, so even a bare `status`/`log` can leave an
unremovable `index.lock`. Fix is host-side only. No git commands without asking first; if one
locks, name the exact file and stop — don't retry.
When asked to inspect (read only): `GIT_OPTIONAL_LOCKS=0`, `git --no-optional-locks`, and
`GIT_DIR=<main worktree>/.git/worktrees/<this worktree>`, `GIT_WORK_TREE=<this worktree>` set explicitly
(the `.git` file holds the host path, which the bridge mounts elsewhere). Check for `*.lock` before and
after. Worked without leaving locks on 2026-10-08.

## What is filed where (`sudelbuecher/`)

- `chatlog/` — one file per session, `<date>_<model>_<topic>.md`, indexed in `chatlog/README.md`
  (one `[file](file)` + one sentence per file).
  - Verbatim export of the displayed conversation, built **by script** with `chatlog/export_chatlog.py`
    from the raw transcript (`~/.claude/projects/-home-claude/<session-id>.jsonl`, copied aside first):
    `python3 -I export_chatlog.py <session.jsonl> <out.md> "<title>" <session-id> <model>`.
    User messages and visible replies as written; tool calls as `*[ ]*` summaries (actions and
    observable results only); shell commands verbatim in collapsed `<details>` blocks, their output
    omitted. The reasoning trace stays out. Never retype or reconstruct.
  - The transcript exists only inside the cloud session, so the session itself runs the export, and
    re-runs it before it ends; the reply being written at that moment is never in the file.
    Fixed in the script: time zone Europe/Berlin, SPDX holder, and the tool names of a cloud session
    linked to this computer (other tools fall back to "Called <tool>").
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
`verbatim_chatlog_recovery/` with the earlier export procedure, from which `chatlog/export_chatlog.py`
is derived.
