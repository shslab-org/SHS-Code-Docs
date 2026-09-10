# BEGINNER_GUIDE — "I installed it, now what?" (v4.0.0)

Glossary first (plain language):
- **Agent**: program that takes your goal, uses tools, and works until done.
- **Tool**: a capability the agent can call (run shell, edit file, search web…).
- **Skill**: reusable how-to knowledge (e.g. `python`, `debugging`) loaded into context.
- **Provider/Model**: company endpoint + AI model that does the thinking (`universal` + URL covers NVIDIA NIM, vLLM, Together, Groq…).
- **MCP**: standard way to plug external tools/servers into the agent.
- **Memory**: SQLite + Markdown persistence across sessions.
- **Context**: working text the model sees; condensed when too long.
- **Task DAG**: tasks with dependencies run in waves.
- **Worker/Orchestration**: parallel sub-agents coordinated by PM/Architect/QA.

## LEVEL 1 — Single-agent basics
What: ask anything. Command: `python main.py "summarise README in 5 bullets"`.
Worked if: answer + tool log. Try `/help`, `/status`, `/doctor`.

## LEVEL 2 — Coding tasks
`python main.py "fix the failing test in tests/test_x.py and show the diff"`.
Agent uses `str_replace_editor` + `bash` + `verify`. Check `git diff` after.

## LEVEL 3 — Autonomous tasks
`python main.py "migrate all print() to logger in app/util/ and run tests"`.
`max_steps = 30` bounds the loop; `/pause`, `/stop`, `/continue` control it.

## LEVEL 4 — Memory
`/remember prefer pytest -q` stores a fact; `/memory` recalls; sessions persist in SQLite (`~/.shscode/` + workspace DB). Resume: `python main.py --continue` or `--session ID`.

## LEVEL 5 — Skills
`/skills` lists 29 built-ins (`python`, `debugging`, `git`…); `/skill python` shows one.
Skills live in `app/skills/builtin/*.md` + user dir (`SHSCODE_SKILLS_DIR` or `~/.shscode/skills`).
Full tutorial: [SKILLS.md](SKILLS.md).

## LEVEL 6 — MCP
`python run_mcp.py --interactive` connects a server; `/mcp` in shell manages it.
Needs an MCP server command/URL. Full guide: [MCP.md](MCP.md).

## LEVEL 7 — Browser/web
`web_search` (duckduckgo/bing), `crawl`, `browser_use` (needs `pip install -e ".[browser]"` + `playwright install chromium` — UNVERIFIED here). See [BROWSER.md](BROWSER.md).

## LEVEL 8 — Git/GitHub
`/git` helpers + provider connectors (`app/git_providers/`: github, gitlab, bitbucket, azure_devops, forgejo). Needs tokens via connectors store. See [GIT.md](GIT.md), [GITHUB.md](GITHUB.md).

## LEVEL 9 — Multi-agent
`python run_multi_agent.py "add auth to the API" --mode build` (or `--mode plan` for approval-gated).
Pipeline: PM → Architect → Engineer → QA. See [MULTI_AGENT.md](MULTI_AGENT.md).

## LEVEL 10 — 103-agent team
No standalone CLI flag (verified). API: `from app.v4.wiring import run_team103`.
Bounded pool (NOT 103 LLM loops): 1 PM + 1 Architect + ≤100 coroutine Engineers + 1 QA,
AIMD 8→100, dependency waves, file locks, checkpoints, QA gate. See [TEAM_103.md](TEAM_103.md).
