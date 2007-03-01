#
# Test the refresh code
#

source scaffold
source generic_test_data

# the test itself
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

# test refresh when no patches are applied
echo abcdef >> def
shouldfail guilt-refresh 2> /dev/null
echo -n "[none] "

# clean things up a little
git-reset --hard HEAD > /dev/null

guilt-push > /dev/null

# test when there is a patch applied
echo abcdef >> def
guilt-refresh
echo -n "[applied] "

# FIXME: we should check that the patch actually contains what it should

complete_test

