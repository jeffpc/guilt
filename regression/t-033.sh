#!/bin/bash
#
# Test the graph code
#

source "$REG_DIR/scaffold"

cmd setup_repo

# Check that "guilt graph" gives a proper "No patch applied" error
# message when no patches are applied.  (An older version of guilt
# used to enter an endless loop in this situation.)
shouldfail guilt graph
