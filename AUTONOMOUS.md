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
