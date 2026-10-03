# GUI — Memory Panel

The agent's persistent memory surfaces (`GET /memory`):

- **Project memory** — `workspace/MEMORY.md` (per-project notes the agent
  reads and writes via the memory tool)
- **User memory** — `workspace/USER.md` (stable user preferences)
- **Long-term memory** — the SQLite store (`workspace/.memory/long_term.db`):
  entry count + recent entries with timestamps

Read-only view; the agent updates memory through its memory tool during
runs. See [MEMORY.md](../MEMORY.md) for the memory architecture.
