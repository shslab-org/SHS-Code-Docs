#!/bin/bash
# Coding task: agent edits, runs tests, verifies (verified tool chain)
python main.py "add function is_even(n) in workspace/demo.py with a test, then run the test"
git diff --stat
python -m pytest tests/v4 -q -o addopts="" -p no:cacheprovider | tail -2
