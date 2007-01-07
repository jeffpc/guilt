#
# Test the applied code
#

source scaffold
source generic_test_data

function expected_status_modify
{
	[ ! -z "$1" ] && echo -n "291b0c3f4133842943d568e25f3a27ac0cc3a1f0:"
	echo "modify"
}

function expected_status_add
{
	[ ! -z "$1" ] && echo -n "291b0c3f4133842943d568e25f3a27ac0cc3a1f0:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "82f68f92022dc51bed0a4099c89068d778754aad:"
	echo "add"
}

function expected_status_remove
{
	[ ! -z "$1" ] && echo -n "291b0c3f4133842943d568e25f3a27ac0cc3a1f0:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "82f68f92022dc51bed0a4099c89068d778754aad:"
	echo "add"

	[ ! -z "$1" ] && echo -n "393c0de5a289e1319cee588a7890971e5b039f46:"
	echo "remove"
}

function expected_status_mode
{
	[ ! -z "$1" ] && echo -n "291b0c3f4133842943d568e25f3a27ac0cc3a1f0:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "82f68f92022dc51bed0a4099c89068d778754aad:"
	echo "add"

	[ ! -z "$1" ] && echo -n "393c0de5a289e1319cee588a7890971e5b039f46:"
	echo "remove"

	[ ! -z "$1" ] && echo -n "5470ce3a3aea43c5fd75db78d32ba449b93df4ee:"
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

