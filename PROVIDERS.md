# PROVIDERS — setup examples (verified keys, UNVERIFIED live calls)

## OpenAI
```toml
[llm]
provider = "openai"
model = "gpt-4o"
# api_key via OPENAI_API_KEY
```

## Anthropic
```toml
[llm]
provider = "anthropic"
model = "claude-3-5-sonnet"
# api_key via ANTHROPIC_API_KEY
```

## NVIDIA NIM / any OpenAI-compatible (shipped default)
```toml
[llm]
provider = "universal"
model = "openai/gpt-oss-20b"
base_url = "https://integrate.api.nvidia.com/v1"
# api_key via LLM_API_KEY
```

## Ollama (local)
```toml
[llm]
provider = "ollama"
model = "llama3.1"
base_url = "http://localhost:11434/v1"
```
Needs `pip install -e ".[ollama]"`. Local serving itself is environmental (UNVERIFIED here).

## Mock (offline smoke test)
```toml
[llm]
provider = "mock"
model = "mock"
```

## Registry & health (verified modules)
`app/providers.py` (`ProviderRegistry`, `providers.json` under home), `app/provider_health.py`,
`app/llm/{fallback,rate_limiter,credential_pool}.py`. Credential pools + rotation exist;
per-request mid-run failover remains incomplete (see WEAKNESSES.md).
