# WEBHOOKS — SHS-Code v4.0.0 (verified `app/server/webhooks.py`)

## What
Incoming webhooks with **HMAC-SHA256** verification. Trigger formats a prompt from
template + payload and runs the agent in background. Configs persist in SessionDB SQLite
(`webhooks` table: hook_id, url, prompt_template, hmac_secret, target_session, enabled).

## CLI (verified script entry `shscode-webhook` → `main_cli`; flags UNVERIFIED in detail)
`shscode-webhook --help` for exact flags. Manager: `WebhookManager` (register/verify/trigger/list).

## Channels (related, verified entry only)
`shscode-channels` → `app.messaging:main_channels` (verified in pyproject).
Detailed channel flags are UNVERIFIED — run `shscode-channels --help`.

## Example
Register hook → `POST` signed payload → agent runs templated prompt → check session history.
Rotate `hmac_secret` regularly (see SECURITY.md).
