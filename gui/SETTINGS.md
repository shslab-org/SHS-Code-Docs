# GUI — Settings Panel

- **Effective configuration** (`GET /config`): provider, model, base URL,
  **masked** API key, max tokens/temperature/steps, version. Secrets are
  never returned raw.
- **Switch model / provider** (`POST /settings/model`): set provider,
  model, base URL and/or API key. Persisted with 0600 permissions and
  applied to agents created after the switch — in-flight runs keep their
  backend (context is never destroyed mid-run).
