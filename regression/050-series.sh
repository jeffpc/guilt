#!/bin/bash
#
# Test the series parsing code
#

source scaffold
source generic_test_data

function prepare_for_tests
{
	generic_prepare_for_tests

	# change the series file
	cat << DONE > .git/patches/master/series
#

#
# foo
#              
           
    #
    #    
    #  some text
    #  some text    
modify
add

remove
mode
#sure
DONE
}

function expected_series
{
	echo "modify"
	echo "add"
	echo "remove"
	echo "mode"
}

function expected_series_with_v
{
	echo "+ modify"
	echo "+ add"
	echo "= remove"
	echo "  mode"
}

function expected_series_with_v_all_unapplied
{
	echo "  modify"
	echo "  add"
	echo "  remove"
	echo "  mode"
}

# the test itself
empty_repo
cd $REPODIR
guilt-init

prepare_for_tests

# NOTE: this has to be in the same order as the series file
tests="empty modify add remove mode"

for t in $tests
do
	[ "$t" != "empty" ] && guilt-push > /dev/null

	guilt-series > /tmp/reg.$$

	expected_series | diff -u - /tmp/reg.$$

	echo -n "[$t] "
done

# test for -v
# pop the last patch for test
guilt-pop > /dev/null
guilt-series -v > /tmp/reg.$$
expected_series_with_v | diff -u - /tmp/reg.$$
echo -n "[verbose] "

guilt-pop -a > /dev/null
guilt-series -v > /tmp/reg.$$
expected_series_with_v_all_unapplied | diff -u - /tmp/reg.$$
echo -n "[verbose none] "

rm -f /tmp/reg.$$

complete_test

