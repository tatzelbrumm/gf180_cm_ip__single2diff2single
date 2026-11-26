#!/usr/bin/env python3
"""Write the subagent hand-back reports of a Claude Code session verbatim to files, from the raw transcript.
The chat log exporter of this branch (chatlog/export_chatlog.py) leaves them out: they are not user messages.
The session-internal agent id in the first line of each report is replaced by "[agent id removed]"; nothing else changes.
usage: extract_handbacks.py <transcript.jsonl> <outdir> <prefix>     Prints names and sizes only."""
import json, re, sys, os
src, outdir, prefix = sys.argv[1:4]
recs = [json.loads(l) for l in open(src)]
desc = {}
for r in recs:                       # Agent tool_use id -> description; agent id from the launch result
    if r.get('type') == 'assistant':
        for b in r['message'].get('content', []):
            if b.get('type') == 'tool_use' and b.get('name') == 'Agent':
                desc[b['id']] = b['input'].get('description', 'agent')
name = {}
for r in recs:
    c = r.get('message', {}).get('content') if r.get('type') == 'user' else None
    if isinstance(c, list):
        for b in c:
            if b.get('type') == 'tool_result' and b.get('tool_use_id') in desc:
                t = b['content'] if isinstance(b['content'], str) else ' '.join(x.get('text', '') for x in b['content'] if isinstance(x, dict))
                m = re.search(r'agentId: (\w+)', t)
                if m: name[m.group(1)] = desc[b['tool_use_id']]
n = 0
for r in recs:
    a = r.get('attachment', {}) if r.get('type') == 'attachment' else {}
    p = a.get('prompt')
    if a.get('type') == 'queued_command' and (a.get('origin') or {}).get('kind') == 'peer' and isinstance(p, str):
        m = re.search(r'<agent-message from="(\w+)">', p)
        who = name.get(m.group(1), 'subagent') if m else 'subagent'
        n += 1
        f = os.path.join(outdir, f"{prefix}_subagent_report_{n}_{re.sub(r'[^A-Za-z0-9]+', '_', who).strip('_').lower()}.md")
        head = (f"<!-- Subagent hand-back report, verbatim from the session transcript (record of {r.get('timestamp', a.get('timestamp', '?'))}).\n"
                f"     Subagent task: \"{who}\". Model output of a subagent, not a message from the user and not checked text:\n"
                f"     the report docs/PAD_STRUCTURES.md says which of its statements were verified. -->\n\n")
        body = re.sub(r'(<agent-message from=")\w+(">)', r'\1[agent id removed]\2', p.rstrip())   # the id is session-internal
        open(f, 'w').write(head + body + '\n')
        print(os.path.basename(f), len(p), 'characters')
print(n, 'hand-back reports')
