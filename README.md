# SHS-Code v4.0.0 — Documentation Repository

**SHS-Code** is a persistent autonomous coding agent by **SHS Lab (Sazzad Hussain Shobuj)**.
Version documented here: **4.0.0** — verified from `app/__init__.py:__version__ = "4.0.0"`,
`pyproject.toml:version = "4.0.0"`, and `python main.py --version` → `SHS Code v4.0.0`.

> Source-first rule: every command, path, config key, and env var below was read from
> the v4.0.0 source tree at commit `3dad673` fix stack (prior audit `ee1c397`, no version bump).
> Anything not verifiable is explicitly marked **UNVERIFIED**.

## What is SHS-Code?

- A CLI agent that plans, edits code, runs commands, and verifies with tests.
- Single-agent mode (interactive shell + one-shot prompt), autonomous loop
  (`max_steps`, stuck detection, verification), multi-agent pipeline
  (PM → Architect → Engineer → QA), and the v4 **Team103** bounded worker pool
  (1 PM + 1 Architect + up to 100 Engineer coroutines + 1 QA).
- Tool system (23 tools), skill system (29 built-in skills), MCP client + server,
  tiered/intelligent memory, HTTP/WebSocket server, cron, webhooks, SSH gateway,
  sandbox backends, browser pool, git-provider connectors.

## Who is it for?

- **Beginners**: can run basic tasks with only a provider key (or `mock` for offline smoke tests).
- **Developers**: code search, AST index, verification, git/GitHub flows.
- **Advanced**: Team103, MCP, custom providers, sandbox/SSH, observability.

## Install (short)

```bash
git clone <shs-code-repo-url> && cd shs-code-live
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -e ".[cli,server,search]"
cp config.toml ~/.shscode/config.toml   # or pass --profile
export LLM_API_KEY=...                  # or OPENAI_API_KEY / ANTHROPIC_API_KEY
python main.py --help
python main.py "explain this repo"
```

Full steps: [INSTALLATION.md](INSTALLATION.md) · First 5 minutes: [QUICKSTART.md](QUICKSTART.md) ·
Zero-to-hero: [BEGINNER_GUIDE.md](BEGINNER_GUIDE.md)

## Run modes

| Mode | Command (verified `--help`) | Doc |
|---|---|---|
| Single-agent CLI | `python main.py [prompt] [--model M] [--session ID] [--continue]` | [SINGLE_AGENT.md](SINGLE_AGENT.md) |
| Server | `python run_server.py [--host 0.0.0.0] [--port 8765] [--reload]` | [USAGE.md](USAGE.md) |
| Multi-agent | `python run_multi_agent.py [goal] [--mode build\|plan] [--session ID]` | [MULTI_AGENT.md](MULTI_AGENT.md) |
| Team103 (via API) | `from app.v4.wiring import run_team103` (no standalone CLI flag) | [TEAM_103.md](TEAM_103.md) |
| MCP client | `python run_mcp.py [--connection stdio\|sse] [--server-url U] [--interactive] [--prompt P]` | [MCP.md](MCP.md) |
| MCP server | `python run_mcp_server.py [--host 0.0.0.0] [--port 8000]` | [MCP.md](MCP.md) |
| Cron | `shscode-cron (--run\|--list\|--add …\|--remove …\|--trigger …)` | [CRON.md](CRON.md) |

Installed console scripts (`pyproject.toml [project.scripts]`, verified):
`SHSCode`, `shscode` → `app.cli:main`; `shscode-server`; `shscode-cron`;
`shscode-multi`; `shscode-sessions`; `shscode-channels`; `shscode-webhook`.

## Learning path

**BEGINNER** → [QUICKSTART.md](QUICKSTART.md) → [BEGINNER_GUIDE.md](BEGINNER_GUIDE.md) →
[USAGE.md](USAGE.md) → [SKILLS.md](SKILLS.md) → [MEMORY.md](MEMORY.md) →
**INTERMEDIATE** → [MCP.md](MCP.md) → [BROWSER.md](BROWSER.md) → [GIT.md](GIT.md) →
[MULTI_AGENT.md](MULTI_AGENT.md) → **ADVANCED** → [TEAM_103.md](TEAM_103.md) →
[ARCHITECTURE.md](ARCHITECTURE.md) → [OPTIMIZATIONS.md](OPTIMIZATIONS.md) →
[PERFORMANCE.md](PERFORMANCE.md)

## Honest status (v4.0.0 final, commit 3dad673 fix stack; prior audit ee1c397)

- Full suite: **708 passed, 2 skipped** (`python -m pytest tests/ -q -o addopts="" -p no:cacheprovider`; prior `ee1c397`: 684 passed, 2 skipped).
- v4 slice: **37 passed** (`tests/v4/`; prior: 31 passed).
- Fixed during this audit: skill `get_relevant` stopword-tie ranking (commit `ee1c397`); plus fix stack to `3dad673` (entry `--help`, semantic-cache O(1), secrets auth, intel batch write, LLM failover, supervisor lifecycle).
- Known limits: semantic-cache difflib now pruned + LRU (FIXED `19b915c`); cold index ~0.9–1.3 s
  (tree-size dependent, prefetch hides but does not remove); per-request LLM-path
  failover PARTIAL-FIX (`a46a149`, exotic paths still manual `--continue`). See [WEAKNESSES.md](WEAKNESSES.md),
  [AUDIT.md](AUDIT.md), [PERFORMANCE.md](PERFORMANCE.md), [VERIFICATION.md](VERIFICATION.md).

## Map

User docs: QUICKSTART · INSTALLATION · BEGINNER_GUIDE · USAGE · CLI_REFERENCE ·
CONFIGURATION · MODELS · PROVIDERS · TOOLS · SKILLS · MCP · MEMORY · SINGLE_AGENT ·
AUTONOMOUS · MULTI_AGENT · TEAM_103 · BROWSER · GIT · GITHUB · WEBHOOKS · CRON · SSH ·
SANDBOX · TROUBLESHOOTING · FAQ · SECURITY.
Maintainer docs: ARCHITECTURE · OPTIMIZATIONS · PERFORMANCE · AUDIT · WEAKNESSES ·
VERIFICATION · CONTRIBUTING · DEVELOPMENT · CHANGELOG.
Examples: `examples/{basic,coding,autonomous,multi-agent,team103,skills,mcp,providers,memory}/`.
