#!/bin/bash
#
# Test the delete code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

begin "guilt-delete mode"
guilt-delete mode

begin "list_files"
list_files

begin "guilt-delete mode (again)"
guilt-delete mode 2>&1
# FIXME: this should return a non-zero status, no?

begin "list_files"
list_files

begin "guilt-delete add"
guilt-delete add

begin "list_files"
list_files

# FIXME: test delete -f
