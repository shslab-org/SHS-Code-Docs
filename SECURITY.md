# SECURITY — SHS-Code v4.0.0 (verified)

## Gates (verified `[security]`, `[conversation]`)
`enabled=true`, `analyzers=["pattern","rails"]`, `confirmation_threshold="medium"`,
`confirmation_mode="confirm_risky"`. Risky tools confirm before running.

## Secrets (verified `[secrets]`, connectors)
Backend `file|env`; prefer env (`LLM_API_KEY`, `*_API_KEY`, `SHSCODE_CIPHER_KEY` for Fernet).
Connector tokens masked in `list(masked=True)`. Never commit `config.toml` secrets.

## Server surface (verified)
`SHSCODE_API_KEY` optional — unset = UNAUTHENTICATED + startup warning.
`SHSCODE_ALLOWED_ORIGINS` unset = CORS allow-all + warning. Bind `127.0.0.1` for local-only.
Webhooks HMAC-SHA256 — rotate secrets. SSH key-only, restricted shell.

## Sandbox
Disabled by default; enable for untrusted code. Still review diffs — sandbox limits blast radius, not intent.
