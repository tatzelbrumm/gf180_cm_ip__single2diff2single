#!/usr/bin/env python3 -I
"""Verbatim export of the displayed conversation from a raw Claude Code transcript.
Includes: user text, visible assistant text, SendUserMessage text, tool calls as *[ ]* summaries.
Excludes: thinking/redacted_thinking blocks (never read), system reminders, meta records
(skill bodies, image-size notes), tool results (only their outcome is reported).
Usage: export_chatlog.py <session.jsonl> <out.md> <title> <session-id> <configured-model>
Derived from the 2026-10-06 export_chatlog.py: header made a parameter, isMeta records skipped,
more tool kinds summarized, refused tool calls reported as such.
2026-10-08 (Opus session): user messages sent while the assistant was working (attachment records of
type queued_command, humanTurn) are exported where they arrived; text files the user attached
(attachment type file) are exported verbatim under the user's message; turn headers carry the date
when the session spans more than one day. All other attachment records stay excluded. Refusal detection looks at the head of a result only.
2026-10-08 (same session, after an automatic context compaction): the compaction summary is not a user message and
is not exported. A compaction rewrites the transcript, so the turns before it exist only in an earlier export; for
appending to that export, environment variables (optional):
  CHATLOG_TURN_OFFSET   number of turns already in the earlier export (turn numbers continue after it)
  CHATLOG_BODY_ONLY=1   write the turns only, without the file header
  CHATLOG_COMPACT_USER  text shown as the user message of the turn the compaction interrupted
  CHATLOG_COMPACT_TIME  its time label (e.g. "2026-10-08 19:22")
2026-10-09 (second compaction): it removed records instead of a turn's beginning only, so the surviving transcript
can start with an assistant record:
  CHATLOG_HEAD_USER     user message (reconstructed) for that headless first turn
  CHATLOG_HEAD_TIME     its time label;  CHATLOG_HEAD_NOTE  a note placed before its first surviving reply
  CHATLOG_COMPACT_INLINE=1  a compaction summary only adds a note to the current turn (no new turn)"""
import json, re, sys, datetime, os
from zoneinfo import ZoneInfo
src, out, title, sid, model = sys.argv[1:6]
TZ = ZoneInfo("Europe/Berlin")
recs = [json.loads(l) for l in open(src)]
by = {r["uuid"]: r for r in recs if r.get("uuid")}
last = [r for r in recs if r.get("type") in ("user", "assistant")][-1]
path, r = [], last
while r:
    path.append(r); r = by.get(r.get("parentUuid")) or by.get(r.get("logicalParentUuid"))  # across compact boundaries
path.reverse()
RE_REM = re.compile(r"<system-reminder>.*?</system-reminder>", re.S)
def stamp(r, fmt="%H:%M"):
    t = datetime.datetime.fromisoformat(r["timestamp"].replace("Z", "+00:00")).astimezone(TZ)
    return t.strftime(fmt)
results = {}
for r in path:
    c = r.get("message", {}).get("content")
    if r["type"] == "user" and isinstance(c, list):
        for b in c:
            if b.get("type") == "tool_result":
                results[b["tool_use_id"]] = b
def outcome(tid):
    b = results.get(tid)
    if not b: return None
    c = b.get("content")
    s = c if isinstance(c, str) else "".join(x.get("text", "") for x in c if isinstance(x, dict))
    if "doesn't want to proceed" in s[:200]: return "refused by the user"   # only the head: output that merely quotes the phrase is not a refusal
    if b.get("is_error"): return "error"
    if isinstance(c, list) and any(x.get("type") == "image" for x in c if isinstance(x, dict)):
        return "image shown to the assistant"
    return f"{len(s.splitlines())} lines of output"
def base(p): return os.path.basename(p or "")
def summ(b):
    n, i = b["name"], b.get("input", {})
    o = outcome(b["id"]); tail = f" ({o})" if o else ""
    if n in ("Bash", "mcp__remote-devices__device_bash"):
        where = "on the computer" if n.startswith("mcp__") else "in the cloud container"
        d = (i.get("description") or "Ran a command").rstrip(".")
        return (f"{d} ({where}{'; ' + o if o else ''}).", i.get("command", ""))
    if n == "mcp__remote-devices__device_stage_files":
        return f"Copied {len(i.get('paths', []))} files from the computer to the cloud container{tail}."
    if n == "mcp__remote-devices__device_commit_files":
        return f"Copied {len(i.get('files', []))} files from the cloud container to the computer{tail}."
    if n == "Skill": return f'Loaded skill "{i.get("skill")}".'
    if n == "Write": return f"Wrote {base(i.get('file_path'))} (in the cloud container{"; " + o if o else ""})."
    if n == "Edit": return f"Edited {base(i.get('file_path'))} (in the cloud container{"; " + o if o else ""})."
    if n == "Read": return f"Read {base(i.get('file_path'))} (in the cloud container{"; " + o if o else ""})."
    if n == "WebSearch": return f'Searched the web for "{i.get("query")}"{tail}.'
    if n == "WebFetch": return f'Fetched {i.get("url")}{tail}.'
    if n == "TaskCreate": return f'Created task "{i.get("subject")}".'
    if n == "TaskUpdate": return f'Set task {i.get("taskId")} to {i.get("status")}.'
    return f"Called {n}{tail}."
turns, cur = [], None
def new_turn(r):
    global cur
    cur = {"time": stamp(r), "day": stamp(r, "%Y-%m-%d"), "user": [], "items": []}; turns.append(cur)
def block_texts(c):
    if isinstance(c, str): return [c]
    return [b.get("text", "") for b in c if isinstance(b, dict) and b.get("type") == "text"]
for r in path:
    if r.get("isMeta"): continue
    if r.get("isCompactSummary") and os.environ.get("CHATLOG_COMPACT_INLINE") == "1" and cur is not None:
        cur["items"].append(("note", f"[The context was compacted automatically at {stamp(r)}; the summary is not exported. The turn continues below.]"))
        continue
    if r.get("isCompactSummary"):
        new_turn(r)
        if os.environ.get("CHATLOG_COMPACT_TIME"): cur["label"] = os.environ["CHATLOG_COMPACT_TIME"]
        if os.environ.get("CHATLOG_COMPACT_USER"): cur["user"].append(os.environ["CHATLOG_COMPACT_USER"])
        cur["items"].append(("note", f"[The context was compacted automatically at {stamp(r)}. The record of this turn up to that point "
                                     "was replaced by a summary, which is not exported; the turn continues below.]"))
        continue
    if r["type"] == "attachment":
        a = r.get("attachment", {})
        if a.get("type") == "queued_command" and a.get("humanTurn") and (a.get("origin") or {}).get("kind") == "human":
            t = "\n".join(x for x in (RE_REM.sub("", y).strip() for y in block_texts(a.get("prompt", ""))) if x)
            if t:
                if cur is None: new_turn(r)
                cur["items"].append(("queued", t, stamp(r)))
        elif a.get("type") == "file":
            f = (a.get("content") or {}).get("file") or {}
            body = f.get("content", "")
            if body and cur is not None and not cur["items"]:
                fence = "~~~~" if "```" in body else "```"
                cur["user"].append(f"*[Attached file `{os.path.basename(a.get('filename', ''))}`, verbatim:]*\n\n{fence}text\n{body.rstrip()}\n{fence}")
        continue
    m = r.get("message", {}); c = m.get("content")
    if r["type"] == "user":
        texts = []
        if isinstance(c, str): texts = [c]
        elif isinstance(c, list): texts = [b["text"] for b in c if b.get("type") == "text"]
        texts = [RE_REM.sub("", t).strip() for t in texts]
        texts = [t for t in texts if t]
        if not texts: continue
        if all(t.startswith("[Request interrupted") for t in texts) and cur is not None:
            cur["items"].append(("note", texts[0])); continue
        if cur is None or cur["items"] or not cur["user"]:
            new_turn(r)
        cur["user"] += texts
    elif r["type"] == "assistant" and isinstance(c, list):
        if cur is None:
            new_turn(r)
            if os.environ.get("CHATLOG_HEAD_TIME"): cur["label"] = os.environ["CHATLOG_HEAD_TIME"]
            if os.environ.get("CHATLOG_HEAD_USER"): cur["user"].append(os.environ["CHATLOG_HEAD_USER"])
            if os.environ.get("CHATLOG_HEAD_NOTE"): cur["items"].append(("note", os.environ["CHATLOG_HEAD_NOTE"]))
        for b in c:
            t = b.get("type")
            if t == "text" and b["text"].strip(): cur["items"].append(("text", b["text"].strip()))
            elif t == "tool_use":
                if b["name"] == "SendUserMessage":
                    cur["items"].append(("sum", b["input"].get("message", "").strip()))
                elif b["name"] == "AskUserQuestion":
                    qs = [q["question"] + " Options: " + "; ".join(o["label"] for o in q["options"])
                          for q in b["input"].get("questions", [])]
                    cur["items"].append(("ask", qs, outcome(b["id"])))
                else:
                    sm = summ(b)
                    if isinstance(sm, tuple):
                        cur["items"].append(("cmd", sm[0], sm[1]))
                    else:
                        cur["items"].append(("tool", sm))
            # thinking / redacted_thinking: skipped, never read
L = ["<!--", "SPDX-FileCopyrightText: 2026 Christoph Maier", "SPDX-License-Identifier: Apache-2.0", "-->",
     f"# {title}", "",
     f"Session `{sid}`, Claude (configured model `{model}`; the serving model may differ).",
     "Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;",
     "tool calls as `*[ ]*` summaries (actions and observable results only); shell commands verbatim in collapsed blocks, their output omitted.",
     "The internal reasoning trace is not included.",
     f"Times are Europe/Berlin. Exported through the record stamped {stamp(last, '%Y-%m-%d %H:%M')}; later turns are not in this file.", ""]
multiday = len({t["day"] for t in turns}) > 1 or bool(os.environ.get("CHATLOG_TURN_OFFSET"))
if os.environ.get("CHATLOG_BODY_ONLY") == "1": L = []
for n, t in enumerate(turns, 1 + int(os.environ.get("CHATLOG_TURN_OFFSET", "0"))):
    L += [f"## Turn {n} — {t.get('label') or ((t['day'] + ' ' if multiday else '') + t['time'])}", ""]
    for u in t["user"]:
        L += ["**User:**", "", u, ""]
    if t["items"]:
        L += ["**Assistant:**", ""]
    run = []
    def flush():
        global run
        if run:
            L.append("*[" + "  \n".join(run) + "]*"); L.append(""); run = []
    for it in t["items"]:
        if it[0] == "tool": run.append(it[1]); continue
        flush()
        if it[0] == "cmd":
            fence = "~~~~" if "```" in it[2] else "```"
            L += [f"*[{it[1]}]*", "", "<details><summary>command</summary>", "",
                  fence + "sh", it[2].rstrip(), fence, "", "</details>", ""]
            continue
        if it[0] == "text": L += [it[1], ""]
        elif it[0] == "sum": L += ["*[SendUserMessage, shown to the user verbatim:]*", "", it[1], ""]
        elif it[0] == "ask":
            L += ["*[Question card shown to the user:]*", ""] + [f"- {q}" for q in it[1]] + ["", f"*[Result: {it[2] or 'declined by the user'}.]*", ""]
        elif it[0] == "note": L += [f"*[{it[1].strip('[]')}]*", ""]
        elif it[0] == "queued": L += [f"**User (sent at {it[2]} while the assistant was working):**", "", it[1], ""]
    flush()
open(out, "w").write("\n".join(L).rstrip() + "\n")
print("turns", len(turns), "bytes", len(open(out).read().encode()))
