#!/usr/bin/env python3
"""Export the chat logs of all subagents of a Claude Code session with this branch's chatlog/export_chatlog.py
(unchanged) and check each with verify_chatlog.py (from tatzelbrumm/gf180mcu_ocd_chipalooza, branch sudel_buecher).
Subagent transcripts: ~/.claude/projects/<project>/<session>/subagents/agent-<id>.jsonl; each is copied aside first.
Files are named by task, in the order the subagents started; the internal agent id is not used in names or headers.
usage: export_subagent_logs.py <main transcript.jsonl> <chatlog dir> <prefix> <session label> <verify_chatlog.py>
Prints one line per subagent (name, counts). Existing files are rebuilt."""
import json, re, sys, os, glob, shutil, subprocess, collections
main, outdir, prefix, label, verify = sys.argv[1:6]
recs = [json.loads(l) for l in open(main)]
desc = {}
for r in recs:
    if r.get('type') == 'assistant':
        for b in r['message'].get('content', []):
            if b.get('type') == 'tool_use' and b.get('name') == 'Agent':
                desc[b['id']] = (b['input'].get('description', 'agent'), b['input'].get('subagent_type', 'general-purpose'))
name = {}
for r in recs:
    c = r.get('message', {}).get('content') if r.get('type') == 'user' else None
    if isinstance(c, list):
        for b in c:
            if b.get('type') == 'tool_result' and b.get('tool_use_id') in desc:
                t = b['content'] if isinstance(b['content'], str) else ' '.join(x.get('text', '') for x in b['content'] if isinstance(x, dict))
                m = re.search(r'agentId: (\w+)', t)
                if m: name[m.group(1)] = desc[b['tool_use_id']]
subdir = os.path.join(os.path.dirname(main) if os.path.isdir(os.path.join(os.path.dirname(main), os.path.basename(main)[:-6])) else '', '')
files = sorted(glob.glob(os.path.join(os.path.expanduser('~/.claude/projects'), '*', os.path.basename(main)[:-6], 'subagents', 'agent-*.jsonl')))
subs = []
for f in files:
    aid = os.path.basename(f)[len('agent-'):-len('.jsonl')]
    rs = [json.loads(l) for l in open(f)]
    subs.append((rs[0].get('timestamp', ''), aid, f, rs))
subs.sort()
here = os.path.dirname(os.path.abspath(__file__))
exporter = os.path.join(outdir, 'export_chatlog.py')
for n, (t0, aid, f, rs) in enumerate(subs, 1):
    d, kind = name.get(aid, ('subagent', '?'))
    models = collections.Counter(r['message'].get('model') for r in rs if r.get('type') == 'assistant' and r.get('message', {}).get('model'))
    model = ', '.join(sorted(models)) or 'unknown'
    slug = re.sub(r'[^A-Za-z0-9]+', '_', d).strip('_').lower()
    out = f"{prefix}_subagent_{n}_{slug}.md"
    copy = os.path.join('/var/tmp/transcripts', f"subagent_{n}.jsonl"); os.makedirs('/var/tmp/transcripts', exist_ok=True); shutil.copy(f, copy)
    title = (f"Subagent {n} of the session \"{label}\": {d} (agent type {kind}). The message shown as \"User\" is the brief written by the "
             "main session's assistant, not a message from Christoph; the subagent's final report went back through a hand-back call "
             "and is filed verbatim in sudelbuecher/logs/")
    e = subprocess.run([sys.executable, '-I', 'export_chatlog.py', copy, out, title, f"{label}, subagent {n}", model], cwd=outdir, capture_output=True, text=True)
    v = subprocess.run([sys.executable, '-I', verify, copy, os.path.join(outdir, out)], capture_output=True, text=True)
    txt = open(os.path.join(outdir, out)).read()
    print(f"{out} | started {t0[:19]}Z | {e.stdout.strip()} | " + ' | '.join(v.stdout.strip().split('\n')) + f" | agent id in the file: {aid in txt}")
