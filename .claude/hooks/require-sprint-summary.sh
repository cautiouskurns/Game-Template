#!/bin/bash
# Stop hook (prompt helper): Provides context for the prompt hook to evaluate.
# This script is not used directly — the prompt hook handles evaluation.
# Kept here for documentation of what the prompt hook checks.
#
# The prompt hook evaluates whether Claude's final response includes:
# 1. What sprint/phase we're currently in
# 2. What was accomplished in this interaction
# 3. What the next step is
#
# If missing, it blocks with a reason asking Claude to add the summary.
echo "This is a documentation file. The actual hook is a prompt hook in settings.json."
exit 0
