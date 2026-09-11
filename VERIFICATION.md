# VERIFICATION — v4.0.0 (commands + results)

## Full suite (final code `3dad673` fix stack; prior audit `ee1c397`)
```bash
python -m pytest tests/ -q -o addopts="" -p no:cacheprovider
# → 708 passed, 2 skipped, 20 warnings in ~72 s (this host, post-fix)
# prior (`ee1c397`): 684 passed, 2 skipped, 19 warnings in ~70 s
```

## v4 slice
```bash
python -m pytest tests/v4 -q -o addopts="" -p no:cacheprovider
# → 37 passed in ~1 s (this host, post-fix; prior: 31 passed)
```

## Targeted (skill fix)
```bash
python -m pytest tests/test_deep_subsystems.py::TestSkillsRuntime tests/test_skills.py -o addopts="" -p no:cacheprovider -q
# → 10 passed (was 1 failed pre-fix)
```

## Perf re-measure (final code)
Tiered put100 0.08 ms / get100 0.05 ms; prefix 1000 builds 1.02 ms;
semantic 200 hits 2.19 ms; async-log 500+flush 2.56 ms; DAG 10x10 ms 10.0x.
Method: python3 heredoc with `sys.path.insert(0,".")` (see PERFORMANCE.md).

## CLI verification (post `3dad673` fix stack)
`main.py --help/--version`, `run_server.py --help`, `run_multi_agent.py --help`,
`run_mcp.py --help`, `run_mcp_server.py --help` — all captured. `run_flow.py --help`
exits 0 with usage (FIXED `7cde619`+`2ccec88`+`ee03690`); `python -m app --help` and
`python -m app.server --help` work (ADDED `7cde619`); `python -m shscode` still has
no module (no `shscode` package — use `python main.py` / console script `shscode`).

## Checklist
Commands ✓ · paths ✓ · config keys ✓ (21 sections) · env vars ✓ · features ✓ ·
arch ✓ · skills ✓ · MCP ✓ · providers ✓ · single/multi/103 ✓ · perf context ✓.
UNVERIFIED items explicitly marked (live LLM calls, chromium run, Termux, channels flags).
