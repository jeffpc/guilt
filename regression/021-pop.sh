#!/bin/bash
#
# Test the pop code
#

source scaffold
source generic_test_data

function expected_files
{
	cat << DONE
d .git/patches
d .git/patches/master
f .git/patches/master/series
f .git/patches/master/status
f .git/patches/master/modify
f .git/patches/master/add
f .git/patches/master/remove
f .git/patches/master/mode
DONE
}

# the test itself
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

guilt-push --all > /dev/null

# NOTE: this has to be in the reverse order as the series file
tests="mode remove add modify"

for t in $tests
do
	guilt-pop > /dev/null

	expected_files | verify_repo .git/patches

	echo -n "[unnamed-$t] "
done

guilt-push --all > /dev/null

for t in $tests
do
	guilt-pop $t > /dev/null

	expected_files | verify_repo .git/patches

	echo -n "[$t] "

	guilt-push --all > /dev/null
done

# FIXME: make sure --all and multiple patch pop works

complete_test

