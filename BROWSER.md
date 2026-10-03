# BROWSER — SHS-Code v4.0.0 (verified)

## Tools
- `web_search` (`app/tool/web_search.py`): DuckDuckGo→Bing fallback, `[search] engines/max_results`.
- `crawl` (`app/tool/crawl4ai.py`): clean text extraction; JS-heavy needs `browser` extra.
- `browser_use` (`app/tool/browser_use_tool.py`): Playwright navigate/click/type/screenshot;
  `execute(action, url, …)`, `cleanup()`, v4 pool stats via `_v4_pool_stats()`.

## Pool (verified `app/v4/browser_pool.py`)
Bounded pool + orphan sweeper (fixes v3 leftover-Chromium weakness). Headless/security caps
from `[browser]`: `headless=true`, `disable_security=false`, `max_content_length=10000`.

## Install (UNVERIFIED live browser run here)
```bash
pip install -e ".[browser]"
python -m playwright install chromium
```

## Example
`python main.py "search the web for FastAPI lifespan docs and summarise"` →
`web_search` → `crawl` → summary. In-shell `/browser`, `/search`.
