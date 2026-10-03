# CRON — SHS-Code v4.0.0 (verified `app/cron.py`)

Needs `pip install -e ".[cron]"` (`croniter`).

## Flags (verified)
`--run` (scheduler loop) · `--list` · `--add ID NAME EXPR PROMPT` ·
`--output PLATFORM:CHANNEL` · `--output-channel` · `--output-target` ·
`--trigger-webhook URL` · `--remove JOB_ID` · `--trigger JOB_ID`.

## Examples
```bash
shscode-cron --add nightly-tests "Nightly tests" "0 2 * * *" "run pytest -q and report"
shscode-cron --list
shscode-cron --trigger nightly-tests
shscode-cron --run
```
Cron expressions are standard 5-field (croniter). Outputs can route to channels/webhooks.
