#
# Test the init code
#

source scaffold

# the test itself
empty_repo
cd $REPODIR

tests="gq-applied gq-delete gq-header gq-new gq-next gq-pop gq-prev gq-push gq-refresh gq-series gq-top gq-unapplied"
for t in $tests; do
	shouldfail $t

	echo -n "[$t] "
done

complete_test

