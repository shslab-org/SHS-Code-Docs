# WEAKNESSES — v4.0.0 register (severity / status / evidence / impact / recommendation)

1. **Semantic-cache difflib scan** — MEDIUM / FIXED (`3dad673` stack: `19b915c`) / `app/v4/semantic_cache.py` now exact O(1) fast-path + per-ctx bucket + length-bound prune before difflib + bounded LRU + thread safety. Measured this host: exact 0.0011 ms (n=1000, 50 samples), miss 4.266 ms. Semantic matching preserved.
2. **Cold index cost ~0.9–1.3 s** — MEDIUM / MITIGATED / `IntelligenceCache.refresh` (566 files 1346.9 ms; 262 files 860.7 ms). Prefetch hides, doesn't remove. Rec: incremental/background index.
3. **Per-request LLM failover incomplete** — HIGH / PARTIAL-FIX (`a46a149`) / `app/llm/llm.py::_fallback_models` + `credential_pool.build_pool_from_config(extra_api_keys)` now wires per-request key pool + model fallback chain with retry/rotation tests (`test_credential_pool`, `test_rate_limit_architecture` 429). Whole-run fallback retained; exotic provider paths remain manual `--continue`.
4. **Orchestration amplification 4x** — MEDIUM / OPEN / `app/agent/orchestrator.py` serial roles. Rec: DAG fan-out for independent roles.
5. **LLM request count** — MEDIUM / MITIGATED / routing + caches reduce count; reasoning models still heavy. Rec: keep router/cache tuned.
6. **Verification cost** — LOW / MITIGATED / `risk_verify.py` tiers. Rec: keep tiers; don't skip QA gate.
7. **Browser orphans** — LOW / MITIGATED / bounded pool + sweeper; `cleanup()` lacks guaranteed hook. Rec: atexit/timeout-kill.
8. **Tool parallelism limits** — LOW / MITIGATED / `run_parallel(limit=16)`; serial read-only queue gone but semaphore caps bursts. Rec: tune limit.
9. **MCP limits** — LOW / PARTIAL-FIX (`ac2e3e0`) / secrets endpoints now require API key + router mounted + MCP call-time key read; stdio+SSE transport unchanged. Rec: front with key/localhost.
10. **Skill UX** — LOW / FIXED (ranking `ee1c397`) / remaining: discovery relies on keyword tags. Rec: richer metadata.
11. **Memory limits** — LOW / OPEN / LRU 512 cap; SQLite WAL tuning manual. Rec: document tuning.
12. **Beginner complexity** — MEDIUM / MITIGATED / this repo's Levels 1–10 path. Rec: keep quickstart first.
13. **Platform/deps** — LOW / OPEN / Termux UNVERIFIED; browser/cron/ollama extras separate. Rec: explicit extras docs (done).
14. **`run_flow.py --help` side effects** — LOW / FIXED (`7cde619` + `2ccec88` + `ee03690`) / argparse help path + bare/embedded `--help` guard; `run_flow.py --help` exits 0 with usage, no agent task, no LLM. Regression: `tests/test_entry_points.py` (7 tests).
