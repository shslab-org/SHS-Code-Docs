# GUI — Workspace Panel

Browse, read **and compare** the server's working directory. Two tabs
(v4.2.0): **Files** and **Changes**.

## Files tab

- **File tree** (left): expandable directories; hidden dirs, `__pycache__`,
  `node_modules`, `.git`, virtualenvs are skipped.
- **Viewer** (right): click a file to load it (`GET /workspace/file`).
  Size-capped (200 KB default, truncation flagged).

## Changes tab — the diff-viewer (v4.2.0)

A before/after comparison of everything that changed, served by
`GET /workspace/diff`:

- **File list** (left): every changed file with a status letter —
  `M` modified, `A` added, `D` deleted, `N` new/untracked — and
  per-file `+adds` / `−dels` counts. Click a file to see its diff.
- **Diff viewer** (right): line-numbered, colorized unified diff —
  green = added lines, red = removed lines, blue `@@ … @@` = hunk
  headers, grey = context. Summary chips at the top show totals
  (`N files, +adds, −dels`).
- **Three comparison modes** (buttons, top right):
  - *Working tree* — unstaged changes (default)
  - *Staged* — changes prepared for the next commit
  - *vs HEAD* — everything different from the last commit
- **Tab badge**: the Changes tab shows the number of currently-changed
  files (working-tree mode) — a quick “is anything dirty?” indicator.

### Server-side behavior

- Untracked files are synthesized as new-file diffs (directories and
  >100 KB files are skipped/not inlined).
- Output is capped (`max_bytes`, 200 KB default) with a `truncated`
  flag.
- Outside a git repository the endpoint responds gracefully with
  `is_repo: false` (the GUI shows a friendly note).

## Safety

All paths are resolved against the server's cwd and **confined** to it —
`../../etc` style escapes are rejected with HTTP 400. This is a viewer,
not an editor: the agent (or the Terminal panel) performs edits. The
Changes tab is read-only too — it shows diffs, it never applies them.
