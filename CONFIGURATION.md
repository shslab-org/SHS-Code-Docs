# CONFIGURATION — SHS-Code v4.0.0

Source: `config.toml` (repo root, verified). All sections below are literal
`[section]` headers from that file.

## File locations

- Repo default: `./config.toml`. User copy: `~/.shscode/config.toml`.
- Runtime slash persistence (`app/config.py`): `/model`, `/provider`, `/mcp add`
  persist to the resolved config path — verified in `persist_live_llm_settings`.

## Sections (verified list)

`[llm]`, `[llm.rate_limit]`, `[llm.streaming]`, `[llm.fallback]`, `[browser]`,
`[search]`, `[sandbox]`, `[runflow]`, `[logging]`, `[ssh]`, `[security]`,
`[hooks]`, `[context]`, `[conversation]`, `[observability]`, `[secrets]`,
`[file_store]`, `[git_providers]`, `[integrations]`, `[parallel_executor]`, `[migrations]`.

## Key settings (verified defaults)

```toml
[llm]
provider = "universal"
model    = "openai/gpt-oss-20b"
base_url = "https://integrate.api.nvidia.com/v1"
max_tokens = 8192
temperature = 0.0
max_retries = 6
timeout = 1800

[llm.rate_limit]
enabled = true
rpm = 0            # 0 = provider default (e.g. NVIDIA NIM 40 RPM), no artificial throttle

[llm.streaming]
enabled = true
buffer_size = 4096
chunk_timeout = 30

[llm.fallback]
enabled = false
chain = ["gpt-4o", "claude-3-5-sonnet"]

workspace_dir = "workspace"
max_steps = 30

[context]
max_events = 200
max_tokens = 80000
condenser_type = "rolling"   # noop | rolling | llm_summarizing

[conversation]
max_iterations = 30
confirmation_mode = "confirm_risky"
stuck_detection = true
stuck_threshold = 3
```

## Provider coercion rule (verified `app/config.py`)

`_coerce_provider`: unknown/empty provider with no key and no base_url → `mock`.
Known providers (`openai anthropic google gemini mistral bedrock`) are NOT coerced.
`universal`/`openai-compat` + non-OpenAI `base_url` with no model warns (gpt-4o 404 risk).

## Env vars (verified)

`SHSCODE_HOME`, `SHSCODE_WORKSPACE`, `SHSCODE_SKILLS_DIR`, `SHSCODE_API_KEY`,
`SHSCODE_ALLOWED_ORIGINS`, `SHSCODE_SSH_PORT`, `SHSCODE_SSH_HOST_KEY`,
`SHSCODE_CIPHER_KEY`, `LLM_API_KEY`, `LLM_BASE_URL`, `LLM_MODEL`,
`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`. Legacy `MANUSCLAW_*` mirrors `SHSCODE_*`.
