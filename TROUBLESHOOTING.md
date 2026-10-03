# TROUBLESHOOTING — SHS-Code v4.0.0 (verified)

## Install
- `No module named shscode` → use `python main.py` (verified; no `shscode` package — console script `shscode` works when installed).
- `app.server is a package` → FIXED (`7cde619`): `python -m app.server --help` works; or use `python run_server.py` / `uvicorn app.server.main:app`.
- Playwright browsers missing → `python -m playwright install chromium` (UNVERIFIED here).

## LLM / provider
- `LLM_BASE_URL … no model … gpt-4o will 404` warning (verified `app/config.py:312`) →
  set `LLM_MODEL` or `[llm] model`.
- Wrong key used → fixed key-map precedence; set provider-specific `OPENAI_/ANTHROPIC_API_KEY`.
- 429/5xx mid-run → PARTIAL-FIX (`a46a149`): per-request key pool + model fallback chain; exotic paths still resume with `--continue` (see WEAKNESSES.md).

## Sessions / memory
- Stuck `running` after crash → server boot auto-recovers to `interrupted` (verified).
- Lost context → `/history`, `/sessions`, `--continue`; reset = delete `~/.shscode/*.db` (destructive).

## Skills / MCP / browser
- Skill not suggested → check `SHSCODE_SKILLS_DIR`, tags keywords, `skills_state.json` disabled list.
- MCP connect fail → host/port/command, stdio vs sse mismatch, server logs, `/tools`.
- Browser orphan → bounded pool + sweeper in v4; `cleanup()` on tool; restart as last resort.

## Diagnostics
In-app `/doctor`, `/log`, `/debug`, `/status`; logs under workspace + `~/.shscode`.
Full suite: `python -m pytest tests/ -q -o addopts="" -p no:cacheprovider` (expect 708 passed, 2 skipped).
