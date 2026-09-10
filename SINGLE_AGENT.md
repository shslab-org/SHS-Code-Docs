# SINGLE_AGENT — SHS-Code v4.0.0 (verified end-to-end)

## Entry
`python main.py [prompt] [--model M] [--profile P] [--session ID] [--continue] [--skin …] [--no-color]`
Omit prompt → interactive shell. Console script `shscode` identical.

## Loop (verified `app/cli.py`, `app/agent/`)
1. Prompt → session (SQLite, resume via `--session/--continue`).
2. LLM call (provider/model from `[llm]` + env).
3. Tool-calls dispatched (23 tools) with `[security]` gating (`confirm_risky`).
4. `verify` before done-claims; stuck detection (`stuck_threshold 3`) + `/retry`.
5. Memory write (`MEMORY.md`, SQLite, TieredMemory).

## Verified smoke tests (this audit)
- `python main.py "what is 2+2?"` → answer.
- File create/edit via `str_replace_editor` + `bash` run + `verify` — works.
- `/doctor`, `/status`, `/model`, `/skills`, `/tools` — all respond.
- Resume `--continue` restores history (SessionDB).

## Config that matters
`max_steps 30`, `max_iterations 30`, `confirmation_mode confirm_risky`,
`condenser_type rolling`, `[llm] timeout 1800 max_retries 6`.
