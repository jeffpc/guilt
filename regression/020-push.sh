#!/bin/bash
#
# Test the push code
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

patches=4

# the test itself
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

# NOTE: this has to be in the same order as the series file
tests="modify add remove mode"

for t in $tests
do
	guilt-push > /dev/null

	expected_files | verify_repo .git/patches

	echo -n "[unnamed-$t] "
done

guilt-pop --all > /dev/null

for t in $tests
do
	guilt-push $t > /dev/null

	expected_files | verify_repo .git/patches

	echo -n "[$t] "

	guilt-pop --all > /dev/null
done

guilt-pop --all > /dev/null

for n in `seq -1 $patches`
do
	if [ $n -ge 0 ]; then
		guilt-push -n $n > /dev/null
	else
		shouldfail guilt-push -n $n > /dev/null
	fi

	expected_files | verify_repo .git/patches

	echo -n "[-n:$n] "

	guilt-pop --all > /dev/null
done

# FIXME: make sure --all and multiple patch push works

complete_test

