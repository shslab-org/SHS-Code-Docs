# CLI_REFERENCE — SHS-Code v4.0.0 (verified `--help` output)

## `python main.py` (console script `shscode` / `SHSCode` → `app.cli:main`)

```
usage: SHSCode [-h] [--skin {default,ares,mono,slate}] [--model MODEL]
               [--profile PROFILE] [--session ID] [--continue] [--no-color]
               [--version] [prompt ...]
positional: prompt — Task prompt (omit for interactive shell)
```

## `python run_server.py` → `uvicorn app.server.main:app`

```
[--host HOST default 0.0.0.0] [--port PORT default 8765] [--reload]
```

## `python run_multi_agent.py` (`shscode-multi` → `app.multi_agent:run_cli`)

```
goal [positional, optional — else interactive input]
[--mode {build,plan} default build] [--session ID]
```

## `python run_mcp.py`

```
[--connection {stdio,sse} default stdio] [--server-url URL] [--interactive] [--prompt P]
```

## `python run_mcp_server.py`

```
[--host HOST default 0.0.0.0] [--port PORT default 8000]
```

## `shscode-cron` (`app.cron:main`, verified flags)

`--run` (scheduler loop) · `--list` · `--add ID NAME EXPR PROMPT` ·
`--output PLATFORM:CHANNEL` · `--output-channel` · `--output-target` ·
`--trigger-webhook URL` · `--remove JOB_ID` · `--trigger JOB_ID`.

## Interactive slash commands (verified in `app/cli.py`)

`/help /? /status /version /tasks /task /resume /pause /stop /continue /model
/models /providers /provider /skills /skill /mcp /tools /channels /connectors
/config /settings /context /checkpoint /history /files /search /git /doctor /log
/debug /clear /new /bg /sessions /compress /branch /exit /plan /usage /project
/env /mode /profile /rollback /verify /undo /retry /browser /memory /remember
/forget /tasks_bg`

## Server REST/WS routes (verified `app/server/main.py`)

- `GET /healthz`, `GET /`, `GET /chat`, `GET /canvas`
- `POST /run`, `POST /run/sync`, `POST /multi-agent`
- `GET /sessions`, `GET /sessions/{id}/messages`, `GET /sessions/{id}/tool_calls`
- `GET /tools`
- `WS /ws/{session_id}`, `WS /ws/chat/{session_id}`, `WS /ws/canvas/{session_id}`
- Auth: optional `SHSCODE_API_KEY` (unset = UNAUTHENTICATED, startup warning — verified).
