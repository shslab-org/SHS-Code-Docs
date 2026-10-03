# Token Streaming

> Verified against SHS-Code v4.0.1 source: `app/llm/llm.py`
> (UniversalClient._post_stream), `app/agent/toolcall.py`, `app/server/main.py`,
> `app/cli.py`.

Real SSE token streaming for OpenAI-compatible endpoints:

```
provider ──SSE──▶ UniversalClient._post_stream
                      │ on_delta(text fragment)
                      ▼
                LLM.ask_tool(on_delta=…)
                      │ ActivityBus emit("llm_delta")
                      ├──▶ CLI: growing live line (final answer not duplicated)
                      └──▶ Server: WS frame {event: "llm_delta", text}
                                └──▶ GUI: streaming chat message
```

- Tool-call argument fragments are accumulated (id/name/arguments, indexed
  per the OpenAI streaming protocol) and never streamed to the user channel
- The accumulated response matches the non-streaming shape exactly — retries,
  model fallback, and token accounting are unchanged
- Backends that reject `stream: true` fall back to the plain call transparently
- Empty accumulated arguments default to `"{}"` (strict providers 400 on
  echoed invalid JSON — live-tested against the Agnes API)
- Works with any `LLM_BASE_URL` provider (e.g. Agnes, NVIDIA NIM, OpenRouter)
