#!/bin/bash
# Basic single-agent smoke tests (verified main.py --help)
python main.py --version
python main.py "what is 2+2? answer briefly"
python main.py "list the files in app/v4/ and describe each in one line"
