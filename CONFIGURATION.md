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

---

## max_steps (v4.3.0) — you decide the step budget, the runtime respects it

`max_steps` is the maximum number of steps the agent may take for one
task. **It is a top-level setting** and it must sit **above every
`[section]` header** in your config file:

```toml
# config.toml — TOP LEVEL (correct)
max_steps     = 80     # your budget for a task
workspace_dir = "workspace"

[llm]
provider = "universal"
...
```

### The bug this release fixes

The shipped example config used to place `max_steps` **inside the
`[logging]` section** — in TOML, every key after a `[section]` header
belongs to that section until the next header. The loader silently
ignored the unknown key, so a configured `80` never took effect and the
runtime kept the default `30`. v4.3.0 fixes this class of bug at the
architecture level:

- the loader performs **strict placement validation** — a top-level
  setting found inside any section is a **hard error** that names the
  key, the section, and the exact fix;
- unknown keys only produce warnings;
- `SHSCODE_CONFIG_PERMISSIVE=1` downgrades the hard error to a warning
  for legacy files;
- three further silent-replacement bugs were fixed (a hardcoded `30`
  in the API run request, a hardcoded `30` in the conversation layer,
  and the mode-scaling `max(5,…)` floor overwriting a configured 3).

### Where you control it (highest priority first)

| Surface | How | Scope |
|---|---|---|
| CLI | `SHSCode --max-steps 150 "<task>"` | this run |
| GUI Agent panel | "Steps" number box | this run |
| Env | `SHSCODE_MAX_STEPS=150` | until cleared |
| GUI Settings | "Agent Step Budget" → Set as default | persisted (0600) |
| Config file | `max_steps = 80` at the **top level** | all runs |

Precedence: explicit per-run selection > `SHSCODE_MAX_STEPS` > profile
config > home config > project `config.toml` > default (30).

### Seeing what is actually in effect

Every surface shows the **effective value and its source**, so the
runtime can never silently disagree with what you configured:

- CLI: `/config` → `max_steps: 80  (source: file config.toml)`
- run-start log line: `… max_steps=80 (source: file config.toml)`
- API/GUI: `GET /config` → `max_steps`, `max_steps_source`
- `POST /config/max-steps {"value": 80}` (or `null` to clear)
