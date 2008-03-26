#!/bin/bash
#
# Test the repair code
#

# FIXME: test status file format upgrade code

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

begin "guilt-push -a"
guilt-push -a

begin "list_files"
list_files

begin "guilt-repair"
shouldfail guilt-repair 2>&1

begin "list_files"
list_files

begin "guilt-repair --full (answer: empty)"
echo | shouldfail guilt-repair --full 2>&1

begin "list_files"
list_files

begin "guilt-repair --full (answer: n)"
yes n | shouldfail guilt-repair --full 2>&1

begin "list_files"
list_files

begin "guilt-repair --full (answer: y)"
yes y | guilt-repair --full 2>&1

begin "list_files"
list_files

begin "guilt-push -a"
guilt-push -a

begin "list_files"
list_files

begin "guilt-repair --full (answer: Y)"
yes Y | guilt-repair --full 2>&1

begin "list_files"
list_files
