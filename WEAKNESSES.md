# WEAKNESSES — v4.0.0 register (severity / status / evidence / impact / recommendation)

1. **Semantic-cache difflib scan** — MEDIUM / OPEN / `app/v4/semantic_cache.py::_sim` O(store) per lookup; measured 2–34 ms by store size. Impact: tail latency at scale. Rec: index-backed similarity.
2. **Cold index cost ~0.9–1.3 s** — MEDIUM / MITIGATED / `IntelligenceCache.refresh` (566 files 1346.9 ms; 262 files 860.7 ms). Prefetch hides, doesn't remove. Rec: incremental/background index.
3. **Per-request LLM failover incomplete** — HIGH / OPEN / `app/llm/fallback.py` whole-run only. Impact: 429/5xx mid-run needs manual `--continue`. Rec: checkpointed per-request retry.
4. **Orchestration amplification 4x** — MEDIUM / OPEN / `app/agent/orchestrator.py` serial roles. Rec: DAG fan-out for independent roles.
5. **LLM request count** — MEDIUM / MITIGATED / routing + caches reduce count; reasoning models still heavy. Rec: keep router/cache tuned.
6. **Verification cost** — LOW / MITIGATED / `risk_verify.py` tiers. Rec: keep tiers; don't skip QA gate.
7. **Browser orphans** — LOW / MITIGATED / bounded pool + sweeper; `cleanup()` lacks guaranteed hook. Rec: atexit/timeout-kill.
8. **Tool parallelism limits** — LOW / MITIGATED / `run_parallel(limit=16)`; serial read-only queue gone but semaphore caps bursts. Rec: tune limit.
9. **MCP limits** — LOW / OPEN / stdio+SSE only, minimal auth. Rec: front with key/localhost.
10. **Skill UX** — LOW / FIXED (ranking `ee1c397`) / remaining: discovery relies on keyword tags. Rec: richer metadata.
11. **Memory limits** — LOW / OPEN / LRU 512 cap; SQLite WAL tuning manual. Rec: document tuning.
12. **Beginner complexity** — MEDIUM / MITIGATED / this repo's Levels 1–10 path. Rec: keep quickstart first.
13. **Platform/deps** — LOW / OPEN / Termux UNVERIFIED; browser/cron/ollama extras separate. Rec: explicit extras docs (done).
14. **`run_flow.py --help` side effects** — LOW / OPEN / PlanningFlow agent-not-idle errors on `--help`. Rec: owner triage (lazy import guard).
