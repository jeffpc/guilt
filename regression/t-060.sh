#!/bin/bash
#
# Test the guilt-files code
#

source $REG_DIR/scaffold

cmd setup_repo

# create a patch that contains a file in a subdirectory
cmd guilt-new subdir

cmd mkdir blah

cmd touch blah/sub

cmd guilt-add blah/sub

cmd guilt-refresh

# push em all for tesing
cmd guilt-push -a

#
# actual tests
#

cmd guilt-files

cmd guilt-files -l

cmd guilt-files -v -l

cmd guilt-files -a

cmd guilt-files -l -a

cmd guilt-files -v -a

cmd guilt-files -v -l -a
