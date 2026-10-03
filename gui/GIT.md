# GUI — Git Panel

Local repository operations with SHS-Code-Agent attribution.

| Action | Endpoint | Notes |
|---|---|---|
| Status | `GET /git/status` | branch + porcelain changes |
| Create branch | `POST /github/branch` | `checkout -B <name>` |
| Commit | `POST /github/commit` | message + trailer (below) |
| Push | `POST /github/push` | one-shot authenticated URL |
| Pull | `POST /github/pull` | |
| Stash / Pop | `POST /github/stash` | |
| Diff | `GET /github/diff?staged=` | unstaged or staged |
| Log | `GET /github/log` | recent commits |

## Attribution

Every commit made through this panel (and the CLI `/github commit`) gets:

```
Generated with SHS-Code

Co-Authored-By: SHS-Code-Agent <SHS-Code-Agent@users.noreply.github.com>
```

Tokens used for pushing are injected into a one-shot URL and **never**
written to the stored remote configuration.
