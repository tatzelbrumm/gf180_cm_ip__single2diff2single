#!/usr/bin/env python3 -I
"""Verbatim export of the displayed conversation from a raw Claude Code transcript.
Includes: user text, visible assistant text, SendUserMessage text, tool calls as *[ ]* summaries.
Excludes: thinking/redacted_thinking blocks (never read), system reminders, tool results."""
import json, re, sys, datetime
from zoneinfo import ZoneInfo
src, out = sys.argv[1], sys.argv[2]
TZ = ZoneInfo("Europe/Berlin")
recs = [json.loads(l) for l in open(src)]
by = {r["uuid"]: r for r in recs if r.get("uuid")}
last = [r for r in recs if r.get("type") in ("user", "assistant")][-1]
path, r = [], last
while r:
    path.append(r); r = by.get(r.get("parentUuid"))
path.reverse()
RE_REM = re.compile(r"<system-reminder>.*?</system-reminder>", re.S)
def hhmm(r):
    t = datetime.datetime.fromisoformat(r["timestamp"].replace("Z", "+00:00")).astimezone(TZ)
    return t.strftime("%H:%M")
# tool results by id, to report outcome only
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
    if b.get("is_error"): return "error"
    return f"{len(s.splitlines())} lines of output"
def summ(b):
    n, i = b["name"], b.get("input", {})
    o = outcome(b["id"])
    if n in ("Bash", "mcp__remote-devices__device_bash"):
        where = "on the computer" if n.startswith("mcp__") else "in the cloud container"
        d = (i.get("description") or "Ran a command").rstrip(".")
        return f"{d} ({where}{'; ' + o if o else ''})."
    if n == "WebSearch": return f'Searched the web for "{i.get("query")}"{" (" + o + ")" if o else ""}.'
    if n == "WebFetch": return f'Fetched {i.get("url")}{" (" + o + ")" if o else ""}.'
    if n == "TaskCreate": return f'Created task "{i.get("subject")}".'
    if n == "TaskUpdate": return f'Set task {i.get("taskId")} to {i.get("status")}.'
    return f"Called {n}{' (' + o + ')' if o else ''}."
turns, cur = [], None
def new_turn(r):
    global cur
    cur = {"time": hhmm(r), "user": [], "items": []}; turns.append(cur)
for r in path:
    m = r.get("message", {}); c = m.get("content")
    if r["type"] == "user":
        texts = []
        if isinstance(c, str): texts = [c]
        elif isinstance(c, list): texts = [b["text"] for b in c if b.get("type") == "text"]
        texts = [RE_REM.sub("", t).strip() for t in texts]
        texts = [t for t in texts if t]
        if not texts: continue
        if cur is None or cur["items"] or not cur["user"] or all(t.startswith("[Request interrupted") for t in texts):
            if texts and all(t.startswith("[Request interrupted") for t in texts) and cur is not None:
                cur["items"].append(("note", texts[0])); continue
            new_turn(r)
        cur["user"] += texts
    elif r["type"] == "assistant" and isinstance(c, list):
        if cur is None: new_turn(r)
        for b in c:
            t = b.get("type")
            if t == "text" and b["text"].strip(): cur["items"].append(("text", b["text"].strip()))
            elif t == "tool_use":
                if b["name"] == "SendUserMessage":
                    cur["items"].append(("sum", b["input"].get("message", "").strip()))
                elif b["name"] == "AskUserQuestion":
                    qs = []
                    for q in b["input"].get("questions", []):
                        qs.append(q["question"] + " Options: " + "; ".join(o["label"] for o in q["options"]))
                    cur["items"].append(("ask", qs, outcome(b["id"])))
                else:
                    cur["items"].append(("tool", summ(b)))
            # thinking / redacted_thinking: skipped, never read
L = []
last_ts = hhmm(last)
L += ["<!--", "SPDX-FileCopyrightText: 2026 Christoph Maier", "SPDX-License-Identifier: Apache-2.0", "-->",
      "# 2026-10-06 — GF180 port: survey, harness search, skeleton", "",
      "Session `813b3a7a-4b6a-5d55-997b-52200c33afcc`, Claude (configured model `claude-sonnet-5-5`; the serving model may differ).",
      "Verbatim export of the displayed conversation: user messages, visible replies and `SendUserMessage` texts as written;",
      "tool calls as `*[ ]*` summaries (actions and observable results only). The internal reasoning trace is not included.",
      f"Times are Europe/Berlin. Exported through the record stamped {last_ts}; later turns are not in this file.", ""]
for n, t in enumerate(turns, 1):
    L += [f"## Turn {n} — {t['time']}", ""]
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
        if it[0] == "text": L += [it[1], ""]
        elif it[0] == "sum": L += ["*[SendUserMessage, shown to the user verbatim:]*", "", it[1], ""]
        elif it[0] == "ask":
            L += ["*[Question card shown to the user:]*", ""] + [f"- {q}" for q in it[1]] + ["", f"*[Result: {it[2] or 'declined by the user'}.]*", ""]
        elif it[0] == "note": L += [f"*[{it[1].strip('[]')}]*", ""]
    flush()
open(out, "w").write("\n".join(L).rstrip() + "\n")
print("turns", len(turns), "bytes", len(open(out).read().encode()))
