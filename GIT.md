# GIT — SHS-Code v4.0.0 (verified)

## Local intelligence
`app/git_intel.py` (branch/status-aware search scoping). In-shell `/git` helpers.

## Provider connectors (verified `app/connectors.py`, `app/git_providers/`)
`ConnectorRegistry`: `add(platform, username, email, …)`, `remove`, `get`, `set_enabled`,
`list(masked)`, `get_token`, `apply_to_git_providers`. Providers: `github`, `gitlab`,
`bitbucket`, `azure_devops`, `forgejo` (dirs verified). Base service
(`GitProviderService`): repos/branches with rate-limit + backoff retry.

## Example
```bash
python main.py "commit my work with a clear message and push"
python main.py "open a PR for branch feat-x"   # needs connector token configured
```
Tokens via connectors store (masked listing). See GITHUB.md for GitHub specifics.
