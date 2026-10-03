# Messaging Channels

Chat with SHS-Code from the platform you already use. **All 12 adapters
are fully implemented as of v4.2.0** — no stubs remain. Unset
credentials degrade safely to log-only stub mode.

## Supported platforms

| Platform | Auth (env vars) | Inbound mechanism |
|---|---|---|
| Telegram | `TELEGRAM_BOT_TOKEN` | long-poll `getUpdates` |
| Discord | `DISCORD_BOT_TOKEN` (+`DISCORD_INTENTS`) | Gateway websocket (HELLO → IDENTIFY → heartbeat → RESUME) |
| Slack | `SLACK_BOT_TOKEN` + `SLACK_APP_TOKEN` | Socket Mode websocket (envelope ACKs, auto-reconnect) |
| WhatsApp | `WHATSAPP_ACCESS_TOKEN` + `WHATSAPP_BUSINESS_PHONE_ID` (+`WHATSAPP_WEBHOOK_VERIFY_TOKEN`) | Cloud API webhook → `GET/POST /messaging/webhooks/whatsapp` |
| Signal | `SIGNAL_CLI_REST_URL` + `SIGNAL_CLI_NUMBER` | signal-cli REST polling |
| Teams | `MICROSOFT_APP_ID` + `MICROSOFT_APP_PASSWORD` (+`MICROSOFT_TENANT_ID`) | Bot Framework webhook → `POST /messaging/webhooks/teams` |
| Matrix | `MATRIX_HOMESERVER` + `MATRIX_ACCESS_TOKEN` (+`MATRIX_USER_ID`) | long-poll `/sync` |
| IRC | `IRC_SERVER` + `IRC_NICK` (+`IRC_PORT`, `IRC_CHANNELS`, `IRC_PASS`) | TCP PRIVMSG loop with PING keep-alive |
| Google Chat | `GOOGLE_CHAT_SERVICE_ACCOUNT` (path to SA JSON) (+`GOOGLE_CHAT_VERIFY_TOKEN`) | event webhook → `POST /messaging/webhooks/google-chat` |
| Email | `EMAIL_SMTP_HOST` + `EMAIL_IMAP_HOST` + `EMAIL_USER` + `EMAIL_PASS` (+`EMAIL_POLL_INTERVAL`) | IMAP polling (UNSEEN → fetch → mark seen) |
| Twitch | `TWITCH_BOT_TOKEN` + `TWITCH_CHANNEL` | IRC-over-TLS chat |
| WebChat | — (internal, always on) | built-in GUI/WS bridge |

## How it works

```
 platform ──► adapter ──► MessagingGateway ──► agent (per channel/user)
                ▲                                   │
                └────────── reply ──────────────────┘
```

One adapter per platform, one cached agent instance per
`platform:user:channel` session key (128 LRU, 5-min idle eviction with
proper cleanup). Replies are truncated per-platform (2000 chars Discord,
3500 Slack, 4096 Telegram/WhatsApp, 8000 default).

## v4.2.0 — the stubs that became real

- **Discord** now speaks the full Gateway protocol: fetches the wss URL
  from `GET /gateway/bot`, heartbeats on the server-provided interval,
  IDENTIFYs with intents (Guilds | GuildMessages | MessageContent | DMs
  — Message Content must be enabled in the Developer Portal), RESUMEs
  across reconnects with `session_id` + `seq`, and dispatches
  `MESSAGE_CREATE` events (own/bot messages filtered).
- **Slack** runs real Socket Mode: `apps.connections.open` with the
  **app-level** token (`xapp-…`, scope `connections:write`), ACKs every
  `events_api` / `slash_commands` / `interactive` envelope (mandatory —
  Slack redelivers un-acked envelopes), filters bot + subtype messages,
  and reconnects with exponential backoff when the ~24h socket drops.
  With only `SLACK_BOT_TOKEN` set, the adapter works send-only.
- **Teams** implements the Bot Framework properly: OAuth2
  client-credentials against
  `login.microsoftonline.com/{tenant}/oauth2/v2.0/token`
  (scope `https://api.botframework.com/.default`, cached until 60s
  before expiry), sends activities to the regional `serviceUrl` learned
  from inbound events, and parses inbound activities from the webhook.
  *The old code sent the raw app ID as the bearer token — it could
  never deliver anything.*
- **Google Chat** signs a proper RS256 service-account JWT
  (`client_email` + `scope=chat.bot`) with the `cryptography` library
  and exchanges it at the token endpoint for an access token.
  **Bug fixed:** the old send URL was the literal
  `https://chat.googleapis.com/v1/spaces/{space}/messages` — the
  `{space}` placeholder was never filled in, so every configured send
  404'd. The space now comes from the channel id.
- **Email** polls IMAP for unread messages on a fresh connection per
  cycle (robust against server idle timeouts): `SEARCH UNSEEN` →
  `FETCH RFC822` → MIME parse (first text part, HTML stripped) →
  dispatch → `STORE +FLAGS \Seen`. SMTP send unchanged (STARTTLS +
  login + send).

## Server webhook routes (v4.2.0)

Webhook-based platforms post to the SHS-Code server, which parses,
dispatches to the gateway as a background task, and answers `200`
immediately (platforms require fast acks):

```
GET  /messaging/channels                     → which adapters are configured
GET  /messaging/webhooks/whatsapp            → Meta verification handshake
POST /messaging/webhooks/whatsapp            → inbound WhatsApp events
POST /messaging/webhooks/teams               → Bot Framework activities
POST /messaging/webhooks/google-chat         → Google Chat events
     (?token=… checked when GOOGLE_CHAT_VERIFY_TOKEN is set)
```

## Checking your configuration

```bash
shscode-channels     # lists which adapters found their credentials
```

or from the GUI/server: `GET /messaging/channels`.

## Notes

- All tokens are read from the environment only — never from committed
  files.
- Every adapter is covered by offline regression tests (mocked
  websockets/HTTP/IMAP), including the Discord identify/resume
  protocol, Slack envelope acks, Teams OAuth, Google Chat JWT signature
  verification, and the IMAP poll loop.
