#!/bin/bash
#
# Test the guilt-files code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

# create a patch that contains a file in a subdirectory
begin "guilt-new"
guilt-new subdir

begin "mkdir blah"
mkdir blah

begin "touch blah/sub"
touch blah/sub

begin "guilt-add blah/sub"
guilt-add blah/sub

begin "guilt-refresh"
guilt-refresh

# push em all for tesing
begin "guilt-push -a"
guilt-push -a

#
# actual tests
#

begin "guilt-files"
guilt-files

begin "guilt-files -l"
guilt-files -l

begin "guilt-files -v -l"
guilt-files -v -l

begin "guilt-files -a"
guilt-files -a

begin "guilt-files -l -a"
guilt-files -l -a

begin "guilt-files -v -a"
guilt-files -v -a

begin "guilt-files -v -l -a"
guilt-files -v -l -a
