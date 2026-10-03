# MEMORY — SHS-Code v4.0.0 (verified)

## Layers
| Layer | Impl (verified) | What / when |
|---|---|---|
| L1 RAM | `app/v4/memory_tiers.py::LRU` (cap 512) | hot reads; measured 100 gets 0.05 ms |
| L2 dict + SQLite | `TieredMemory` (`db_path`, batched flush) | durable; measured 100 puts 0.08 ms (final code) |
| Markdown sidecar | `md_path` in `TieredMemory` | human-readable mirror |
| Short-term | `app/memory/short_term.py` | session working set |
| Long-term | `app/memory/long_term.py` | cross-session facts |
| Intelligent | `app/v4/intel_memory.py` (`classify`, relevance/recency/reliability, contradictions, confidence) | retrieval ranking |
| Agent notebook | `memory` tool → `MEMORY.md` / `USER.md` | `/remember`, `/forget`, `/memory` |
| Sessions | `app/db/session.py` SQLite | goals, messages, tool calls, branches, compression |

## Paths
Home `SHSCODE_HOME` (default `~/.shscode`), workspace `SHSCODE_WORKSPACE` (default `workspace`),
SessionDB shared path with legacy pre-rename fallback (`app/db/session.py::_default_db_path`).

## Inspect / reset
`/memory`, `/history`, `shscode-sessions --help`; reset = delete `~/.shscode/*.db` + `MEMORY.md`
(careful — destroys recall). Context condenser (`[context]`, `rolling` default, `max_events 200`,
`max_tokens 80000`) compacts without destroying durable memory.
