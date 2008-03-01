#!/bin/bash
#
# Test the repair code
#

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

begin "guilt-repair -f (answer: empty)"
echo | shouldfail guilt-repair -f 2>&1

begin "list_files"
list_files

begin "guilt-repair -f (answer: n)"
yes n | shouldfail guilt-repair -f 2>&1

begin "list_files"
list_files

begin "guilt-repair -f (answer: y)"
yes y | guilt-repair -f

begin "list_files"
list_files

begin "guilt-push -a"
guilt-push -a

begin "list_files"
list_files

begin "guilt-repair -f (answer: Y)"
yes Y | guilt-repair -f

begin "list_files"
list_files
