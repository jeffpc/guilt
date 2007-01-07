#
# Test the unapplied code
#

source scaffold
source generic_test_data

function expected_status_modify
{
	echo "add"
	echo "remove"
	echo "mode"
}

function expected_status_add
{
	echo "remove"
	echo "mode"
}

function expected_status_remove
{
	echo "mode"
}

function expected_status_mode
{
	return 0
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

	guilt-unapplied > /tmp/reg.$$

	expected_status_$t | diff -u - /tmp/reg.$$

	echo -n "[$t] "
done

rm -f /tmp/reg.$$

complete_test

