#!/bin/bash
#
# Test that all commands that should fail do indeed fail if the branch was
# not guilt-init'ed
#

source $REG_DIR/scaffold

cmd setup_git_repo

tests="guilt-add guilt-applied guilt-branch guilt-commit guilt-delete guilt-diff guilt-export guilt-files guilt-fold guilt-fork guilt-graph guilt-header guilt-import guilt-import-commit guilt-new guilt-next guilt-pop guilt-prev guilt-push guilt-rebase guilt-refresh guilt-rm guilt-series guilt-status guilt-top guilt-unapplied"
for t in $tests; do
	shouldfail $t
done
