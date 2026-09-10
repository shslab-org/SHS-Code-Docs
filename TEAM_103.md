# TEAM_103 — v4.0.0 bounded 103-agent team (verified `app/team103/scheduler.py`)

## Are there 103 independent LLM loops? NO.
Verified docstring: "NOT 103 full LLM loops: workers are lightweight coroutines
sharing engine_fn." Reality: **1 PM + 1 Architect + ≤100 coroutine Engineers + 1 QA**
over a bounded pool with AIMD concurrency, DAG waves, file locks, checkpoints, QA gate.

## Config (verified `TeamConfig`)
`max_workers 100` · `start_concurrency 8` · `max_concurrency 100` ·
`task_timeout_s 600.0` · `max_retries 2` · `queue_path workspace/v4/team103_events.jsonl`.

## How it runs (verified)
1. **PM**: `decompose_goal(goal, max_tasks=12)` → `TaskSpec[]` (title, files, priority, risk, subsystem, complexity, role_hint, depends_on, acceptance, context_slice).
2. **Architect**: `_waves()` topological waves by `depends_on`; role specialization (`app/v4/roles.py` 8 roles); context slices; conflict plan.
3. **Engineers**: per-wave `asyncio.gather`, `_acquire_slot()` gate (`active < AIMD limit`);
   AIMD: start 8, +1/success up to 100, halve on failure; file-conflict serialization
   (`dedup.py` locks); timeout/retry/checkpoint; work-stealing via gather; `merge_results`.
4. **QA**: continuous targeted checks + final full relevant verification gate (`cont_qa.py`, `risk_verify.py`).

## Invoke (verified `app/v4/wiring.py`)
No standalone CLI flag. Python API:
```python
from app.v4.wiring import run_team103
res = await run_team103("migrate to async logging", engine_fn=my_engine_fn)
# res: TeamResult(tasks, successful, failed, retries, peak_concurrency, …)
```

## Measured (synthetic stress, LATENCY_PROFILE + re-measured)
10/25/50/75/100 workers → ~13/13/20/20/23 ms wall, peak ~8/17/28/43/68, AIMD 8→100, no deadlock.
**Do NOT read as "100-agent coding tasks in 23 ms"** — engine_fn was synthetic; real LLM
workloads are LLM-bound. See PERFORMANCE.md §19 rule.
