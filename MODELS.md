# MODELS — SHS-Code v4.0.0 provider/model system (verified)

## How it is configured
`config.toml [llm]`: `provider`, `model`, `base_url`, `api_key` (prefer env),
`max_tokens 8192`, `temperature 0.0`, `max_retries 6`, `timeout 1800`.
Runtime: `/model NAME` (switch model), `/provider NAME`, `/models`, `/providers`.

## Provider values (verified in code + config comments)
`mock` (no key, offline) · `openai` · `anthropic` · `ollama` · `openrouter` ·
`universal` (any OpenAI-compatible: NVIDIA NIM, vLLM, Together, Groq…) ·
`openai-compat` · `lmstudio` · `gguf` · `huggingface`/`hf` · `google`/`gemini` ·
`mistral` · `bedrock` (each needs its optional extra + keys — extras verified in pyproject).

Default shipped `config.toml`: `provider = "universal"`, `model = "openai/gpt-oss-20b"`,
`base_url = "https://integrate.api.nvidia.com/v1"` (NVIDIA NIM example).

## Env vars (verified)
`LLM_API_KEY` (preferred generic) · `LLM_BASE_URL` · `LLM_MODEL` ·
`OPENAI_API_KEY` · `ANTHROPIC_API_KEY`. Provider-specific key picked first
(`app/config.py` `_provider_key_map` fix), so mixed keys don't cross-contaminate.

## Switching / fallback / routing
- `/model`, `/provider` persist to config (`persist_live_llm_settings`).
- `[llm.fallback] enabled=false`, `chain=["gpt-4o","claude-3-5-sonnet"]`, cooldowns — whole-run fallback.
- v4 OPT-11 smart routing: `app/v4/model_router.py` (verified module) routes by task class.
- Rate limit: `[llm.rate_limit] enabled=true, rpm=0` = provider default (NIM 40 RPM), true rolling window (`app/llm/rate_limiter.py`); per-provider custom RPM supported.

## Honest limit
Per-request LLM-path failover (provider 429/5xx/timeout mid-run with checkpoint resume) is
**incomplete** — failover is whole-run. See [WEAKNESSES.md](WEAKNESSES.md).
