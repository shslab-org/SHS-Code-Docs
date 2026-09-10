# TROUBLESHOOTING — SHS-Code v4.0.0 (verified)

## Install
- `No module named shscode` → use `python main.py` (verified; no `shscode` module).
- `app.server is a package` → use `python run_server.py` or `uvicorn app.server.main:app`.
- Playwright browsers missing → `python -m playwright install chromium` (UNVERIFIED here).

## LLM / provider
- `LLM_BASE_URL … no model … gpt-4o will 404` warning (verified `app/config.py:312`) →
  set `LLM_MODEL` or `[llm] model`.
- Wrong key used → fixed key-map precedence; set provider-specific `OPENAI_/ANTHROPIC_API_KEY`.
- 429/5xx mid-run → whole-run fallback/retry only; resume with `--continue` (failover incomplete — WEAKNESSES.md).

## Sessions / memory
- Stuck `running` after crash → server boot auto-recovers to `interrupted` (verified).
- Lost context → `/history`, `/sessions`, `--continue`; reset = delete `~/.shscode/*.db` (destructive).

## Skills / MCP / browser
- Skill not suggested → check `SHSCODE_SKILLS_DIR`, tags keywords, `skills_state.json` disabled list.
- MCP connect fail → host/port/command, stdio vs sse mismatch, server logs, `/tools`.
- Browser orphan → bounded pool + sweeper in v4; `cleanup()` on tool; restart as last resort.

## Diagnostics
In-app `/doctor`, `/log`, `/debug`, `/status`; logs under workspace + `~/.shscode`.
Full suite: `python -m pytest tests/ -q -o addopts="" -p no:cacheprovider` (expect 684 passed, 2 skipped).
