# OPTIMIZATIONS — v4.0.0 all 20 (verified `app/v4/*.py`)

| # | Name | File | What / when / failure |
|---|---|---|---|
| 1 | Prefix cache | `prefix_cache.py` | static prompt hash reuse; per-request; miss = rebuild |
| 2 | Semantic cache | `semantic_cache.py` | query+ctx fingerprint, thr 0.82, TTL 600s; difflib scan O(store) — see WEAKNESSES |
| 3 | Async DAG | `async_dag.py` | `run_dag`/`run_parallel`; fan-out; timeout cancels |
| 4 | Streaming parser | `stream_parser.py` (`StreamToolParser`) | brace-match dispatch, 1MB bound; malformed stays buffered |
| 5 | Speculative exec | `speculative.py` | (verified module; detailed policy UNVERIFIED) |
| 6 | Prefetch | `prefetch.py` | background index warm; hides ~1.3s cold, doesn't remove compute |
| 7 | Tiered memory | `memory_tiers.py` | L1(512)+SQLite batch; 100 puts 0.08ms / gets 0.05ms |
| 8 | Intelligent memory | `intel_memory.py` | classify + 3R retrieval + contradictions |
| 9 | Context mgmt | `context_mgmt.py` | `summarize_output` head/tail+excerpts |
| 10 | Smart routing | `model_router.py` | task-class routing |
| 11 | Plan cache | `plan_cache.py` | reuse plans |
| 12 | Risk-aware verify | `risk_verify.py` | tiers save full-suite cost on low-risk edits |
| 13 | Robust recovery | `recovery.py` + `app/recovery.py` | retry/checkpoint/resume |
| 14 | Browser pool | `browser_pool.py` | bounded + sweeper (orphan fix) |
| 15 | Async observability | `async_log.py` (`AsyncEventLog`) | 500 events+flush 2.56ms |
| 16 | Dedup/locks | `dedup.py` (`DedupRegistry`) | file/symbol locks serialize conflicts |
| 17 | Result merging | `merger.py` (`merge_results`) | wave result merge |
| 18 | Continuous QA | `cont_qa.py` | targeted + final gate |
| 19 | Role specialization | `roles.py` (8 roles + TaskSpec) | task-specific slices |
| 20 | Wiring/singletons | `wiring.py` | lazy `get_*` + `run_team103` entry |

Measured evidence: PERFORMANCE.md; historical baselines: POSTMORTEM/LATENCY_PROFILE in main repo `docs/v4/`.
