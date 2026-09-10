# USAGE — SHS-Code v4.0.0 everyday workflows

## Interactive shell (main loop)
`python main.py` → prompt + `/help`. Useful: `/status` (session/model), `/model NAME`,
`/provider NAME`, `/skills`, `/tools`, `/mcp`, `/context`, `/checkpoint`, `/history`,
`/sessions`, `/compress` (condense), `/branch`, `/new`, `/clear`, `/doctor`, `/log`, `/debug`.

## One-shot tasks
`python main.py "do X" --model openai/gpt-oss-20b --profile work`.

## Sessions & resume
`python main.py --session <ID>` · `python main.py --continue` · `shscode-sessions` CLI
(`app/session_tools.py`: list/history/send/spawn/delete/export). Backed by `app/db/session.py` SQLite.

## Server mode
`python run_server.py --port 8765` → REST (`POST /run`, `/run/sync`, `/multi-agent`,
`GET /sessions…`, `GET /tools`) + WS (`/ws/{id}`, `/ws/chat/{id}`, `/ws/canvas/{id}`) +
pages (`/chat`, `/canvas`). Auth via `SHSCODE_API_KEY` (optional; unset = open + warning).

## Multi-agent & Team103
`python run_multi_agent.py "goal" --mode build|plan` · Team103 via
`await run_team103(goal, engine_fn=…)` — see [MULTI_AGENT.md](MULTI_AGENT.md), [TEAM_103.md](TEAM_103.md).

## Cron / webhooks / channels
`shscode-cron --add ID NAME EXPR PROMPT` + `--run/--list/--trigger/--remove` ·
webhooks: HMAC-SHA256, persisted in SessionDB (`app/server/webhooks.py`), CLI `shscode-webhook` ·
channels: `shscode-channels` (verified script entry; detailed flags UNVERIFIED — see [WEBHOOKS.md](WEBHOOKS.md)).
