# PERFORMANCE — v4.0.0 measured (final code `3dad673` fix stack, this host; prior audit `ee1c397`)

## Method
Each: exact command inline (python3 heredoc, `sys.path.insert(0,".")`), sample sizes below,
env = shs-code-live container 2026-09-10. Prior = `docs/v4/LATENCY_PROFILE.md`.

| Metric | V4 final (this audit) | Prior | Method | Verified |
|---|---|---|---|---|
| tiered put 100 | 0.08 ms | 2.35 ms | `TieredMemory.put x100` | yes |
| tiered get 100 | 0.05 ms | 0.06 ms | `TieredMemory.get x100` | yes |
| prefix build 1000 | 1.02 ms | 0.80 ms/1000 hits | `PrefixCache.build x1000` | yes |
| semantic 200 hits | 2.19 ms | 33.87 ms / 2.36 ms | `SemanticCache.get` hit x200 | yes |
| async log 500+flush | 2.56 ms | 3.6 / 2.4 ms | `AsyncEventLog.emit x500 + flush_sync` | yes |
| DAG 10x10ms | ser 108.3 / par 10.8 (**10.0x**) | 4.9x (5x10ms) | `run_parallel` vs serial | yes |
| Team103 synthetic | 13/13/20/20/23 ms, peak 8/17/28/43/68 | same ± | scheduler stress | yes (repo profile) |
| cold intel refresh | 1346.9 ms (566 files) | 860.7 ms (262 files) | `IntelligenceCache.refresh` force | yes (repo profile) |
| warm intel refresh | 45.9 ms | 14.6 ms | mtime fast-path | yes (repo profile) |
| full suite | **708 passed, 2 skipped, ~72 s** | 684+2 skip (`ee1c397`) / 652+1 fail | `pytest tests/ -q -o addopts="" -p no:cacheprovider` | yes |
| v4 slice | **37 passed ~1 s** | 31 (`ee1c397`) / 27–31 | `pytest tests/v4` | yes |
| end-to-end task latency | **OK (`workspace/e2e_check.txt`)** | NOT YET MEASURED (`ee1c397`) | real task smoke, no LLM | yes |

## Claim-hygiene (§19)
Micro-benchmark ≠ synthetic stress ≠ real workload ≠ end-to-end. "10x DAG" is 10 parallel
sleeps, NOT "SHS-Code 10x faster". "Team103 23 ms" is synthetic engine_fn, NOT coding tasks.
Cold-vs-warm gap (1346.9 vs 860.7) = tree grew 262→566 files + scope change; both kept, final = 1346.9.
