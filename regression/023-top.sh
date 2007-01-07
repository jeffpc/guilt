#
# Test the applied code
#

source scaffold
source generic_test_data

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

	[ "`guilt-top`" = "$t" ]

	echo -n "[$t] "
done

complete_test

