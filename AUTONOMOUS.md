# AUTONOMOUS — SHS-Code v4.0.0

## What it is
Single-agent loop without per-step approval (bounded by `max_steps 30` /
`max_iterations 30`), with stuck detection, verification gate, checkpoints,
and session resume. NOT a separate binary — it's `python main.py "big goal"` +
`[conversation]` + `[context]` settings.

## Controls (verified)
- `/pause` `/stop` `/continue` `/retry` `/checkpoint` `/compress` `/branch`
- `confirmation_mode = "confirm_risky"` — risky tools still confirm.
- `stuck_detection = true`, `stuck_threshold = 3`.
- Context: `max_events 200`, `max_tokens 80000`, `condenser_type rolling|llm_summarizing|noop`.

## Example
```bash
python main.py "migrate print() to logger in app/util/ and run tests"
# watch: /status ; pause: /pause ; resume: /continue
```

## Recovery (verified)
Crash → stale `running` sessions recovered to `interrupted` on server boot
(`app/server/main.py _lifespan`); CLI resume via `--continue`.
Retry policy per-tool + `max_retries 6` LLM-level.

---

## Detached execution (v4.3.0) — long tasks that survive everything

A plain background process (`&`, `nohup` inside a dying session) dies
with the session that started it. v4.3.0 gives long-running autonomous
work a real daemonization path:

```bash
# start a task that survives the terminal, SSH disconnects, and the
# process-tree cleanup of the tool that launched it
SHSCode --detach "Refactor the auth module and update all tests"

# list detached runs (registry + live process liveness)
SHSCode --runs

# follow a run's log live (Ctrl+C detaches; the run continues)
SHSCode --attach run-20261003-182501-60988e
```

What happens under the hood:

- **double-fork + `setsid`** — the daemon is reparented to init (its
  parent becomes PID 1), gets its own session, ignores `SIGHUP`, and
  writes its output to `~/.shscode/runs/<run_id>/output.log`;
- the run registers itself in `~/.shscode/runs/<run_id>/run.json`
  (pid, session id, prompt, timestamps) — `--runs` checks real process
  liveness, never a stale flag;
- **graceful interruption**: `SIGTERM`/`SIGHUP` cancel the run *after*
  checkpointing — the session closes as `interrupted` and
  `SHSCode --continue` (or `/resume`) restores the full context. A
  killed task is never silently lost.

The GUI gets the same capability: the Agent panel's **"detached"**
checkbox (and `POST /run {"detach": true}`) spawn the detached process
from the server — the task survives **even a server restart**. The
Sessions panel shows the detached-run registry with live state.

### Verified behaviors (real Agnes runs, v4.3.0)

- a detached run survived the launching shell's death and completed
  its task (files + agent-attributed commit);
- `SIGTERM` mid-run → session `interrupted` at step 11 with all
  created files intact → `--continue` finished the remaining work and
  committed (agent-attributed);
- rate-limit waits during detached runs preserved state (rolling
  window retry, attempts logged).
