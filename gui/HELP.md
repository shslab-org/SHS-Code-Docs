# Help / Guide Panel (v4.1.0)

The **Help / Guide** panel is the 14th GUI panel — a condensed, always-available
version of the full [GUI_GUIDE.md](../GUI_GUIDE.md), written for people who
have never used an agent before.

```
shscode-server                # then open http://localhost:8765/gui
→ left navigation → Help / Guide
```

## What it contains

| Section | Content |
|---|---|
| Start here | Your first task in 3 steps (open Agent → type request → watch activity) |
| What each panel does | One-line plain-language reference for all 14 panels |
| Showing and hiding the left menu | The three toggle paths + persistence + phone behavior |
| Understanding the Agent panel | Chat vs activity feed, Run Progress, cancel, finish reasons |
| What the task statuses mean | Color-coded legend: pending → ready → running → partial/retryable → failed/blocked → completed |
| Keyboard shortcuts | Ctrl/Cmd+B, Enter, Shift+Enter, Esc |
| Troubleshooting | WebSocket reconnect, api_key URL, model config, where conversations are saved |
| How the GUI relates to the CLI | One runtime, two frontends — same sessions, tasks, memory |

## Collapsible navigation (slide / hide sidebar)

v4.1.0 adds the user-requested ability to slide the whole left navigation out
of the way:

| How to toggle | Action |
|---|---|
| Top-bar button | Click **☰** at the far left of the top bar |
| Edge tab | While hidden, click the vertical **☰ MENU** tab at the left screen edge |
| Keyboard | <kbd>Ctrl</kbd>+<kbd>B</kbd> (Windows/Linux) / <kbd>Cmd</kbd>+<kbd>B</kbd> (Mac) |

Behavior details:

- **Animated** slide (280 ms cubic-bezier transition on `margin-left`).
- **Persisted** — the choice is stored in `localStorage`
  (key `shs-gui-nav-hidden`) and survives browser restarts.
- **Small screens (≤820px)** — the sidebar becomes an overlay drawer:
  closed by default, dark backdrop + <kbd>Esc</kbd> to close, and it
  auto-closes after you pick a panel.
- Implemented purely client-side in `app/server/static/gui.html`
  (`toggleNav` / `navApply`); no server changes, no new endpoints.

## Why an in-app guide?

- Normal users shouldn't need to leave the app to learn the basics.
- The guide doubles as honest documentation of the GUI's behavior model
  (final vs interim messages, honest finish reasons, never fake success).
- It lives in the shipped `gui.html`, so it works offline / air-gapped.

## Related

- [GUI_GUIDE.md](../GUI_GUIDE.md) — the complete 15-chapter guide
- [Overview](OVERVIEW.md) — architecture, event model, auth
- [Troubleshooting](../TROUBLESHOOTING.md) — system-level troubleshooting
