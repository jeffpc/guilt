#!/bin/bash
#
# Test the applied code
#

source scaffold
source generic_test_data

function expected_status_modify
{
	[ ! -z "$1" ] && echo -n "33633e7a1aa31972f125878baf7807be57b1672d:"
	echo "modify"
}

function expected_status_add
{
	[ ! -z "$1" ] && echo -n "33633e7a1aa31972f125878baf7807be57b1672d:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "68f33a015dcfd09c3896f15d152378b54eaa4eb6:"
	echo "add"
}

function expected_status_remove
{
	[ ! -z "$1" ] && echo -n "33633e7a1aa31972f125878baf7807be57b1672d:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "68f33a015dcfd09c3896f15d152378b54eaa4eb6:"
	echo "add"

	[ ! -z "$1" ] && echo -n "e67345cf1e7e9594c73efad7381a994f1fe63b14:"
	echo "remove"
}

function expected_status_mode
{
	[ ! -z "$1" ] && echo -n "33633e7a1aa31972f125878baf7807be57b1672d:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "68f33a015dcfd09c3896f15d152378b54eaa4eb6:"
	echo "add"

	[ ! -z "$1" ] && echo -n "e67345cf1e7e9594c73efad7381a994f1fe63b14:"
	echo "remove"

	[ ! -z "$1" ] && echo -n "632ca0f5ec27a961990b45673dfc751f1da830f3:"
	echo "mode"
}

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

	guilt-applied > /tmp/reg.$$

	expected_status_$t | diff -u - /tmp/reg.$$
	expected_status_$t "file" | diff -u - $REPODIR/.git/patches/master/status

	echo -n "[$t] "
done

rm -f /tmp/reg.$$

complete_test

