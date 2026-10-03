# GUI Documentation

The SHS-Code GUI is a single-page web application served by the same Python
runtime that powers the CLI. Start it with:

```bash
shscode-server                # default port 8765
# open http://localhost:8765/gui
# append ?api_key=… when SHSCODE_API_KEY is set
```

## Architecture — one runtime, two frontends

```
                 ┌───────────────────┐
                 │      SHS-Code     │
                 │   Agent Runtime   │
                 └─────────┬─────────┘
             ┌─────────────┴─────────────┐
             │                           │
           CLI                          GUI
             │                           │
             └─────────────┬─────────────┘
                           │
                    Shared Runtime
          (journal · sessions · memory · tools · git)
```

The GUI calls REST endpoints and consumes structured WebSocket events —
it never scrapes terminal output and contains **zero duplicated business
logic**. A session started in the CLI can be continued in the GUI and
vice versa: both read the same session DB, task journal, memory, and git
state.

## Panels

| Panel | Doc | What it does |
|---|---|---|
| Overview | [Overview](gui/OVERVIEW.md) | concepts, event model, auth |
| Dashboard | [Dashboard](gui/DASHBOARD.md) | runtime/provider/git identity overview |
| Agent | [Agent](gui/AGENT.md) | chat, live streaming, activity feed, cancel |
| Tasks | [Tasks](gui/TASKS.md) | task lifecycle + DAG visualization |
| Team103 | [Team103](gui/TEAM103.md) | 103-worker execution runs |
| Workspace | [Workspace](gui/WORKSPACE.md) | file tree + viewer |
| Terminal | [Terminal](gui/TERMINAL.md) | command execution |
| Git | [Git](gui/GIT.md) | branch/commit/push/pull/stash/diff |
| GitHub | [GitHub](gui/GITHUB.md) | PRs, issues, agent identity |
| QA | [QA](gui/QA.md) | verification runs |
| Sessions | [Sessions](gui/SESSIONS.md) | history, final vs interim, resume |
| Memory | [Memory](gui/MEMORY.md) | project/user/long-term memory |
| Logs | [Logs](gui/LOGS.md) | live log tail |
| Settings | [Settings](gui/SETTINGS.md) | config + model switching |

## Event model

While an agent runs, the server bridges internal runtime events to every
WebSocket watching the session as JSON frames:

```json
{"event": "llm_delta",  "text": "token…", "session_id": "…", "ts": 169…}
{"event": "tool_start", "tool": "bash", "args_preview": "…"}
{"event": "task_partial", "reason": "step budget exhausted…"}
{"event": "agent_done", "output": "…", "finish_reason": "final_answer", "steps": 12}
```

Internal events (planner, tools, retries, checkpoints) are displayed in
the GUI's Activity feed — they are **never** rendered as assistant
messages. The user-facing conversation stays clean by design.
