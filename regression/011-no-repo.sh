#
# Test the init code
#

source scaffold

# the test itself
empty_repo
cd $REPODIR

tests="guilt-applied guilt-delete guilt-header guilt-new guilt-next guilt-pop guilt-prev guilt-push guilt-refresh guilt-series guilt-top guilt-unapplied"
for t in $tests; do
	shouldfail $t

	echo -n "[$t] "
done

complete_test

