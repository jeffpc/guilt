#
# Test the applied code
#

source scaffold
source generic_test_data

function expected_status_modify
{
	[ ! -z "$1" ] && echo -n "f502869692c06d8b437f325925d5f24109cbf128:"
	echo "modify"
}

function expected_status_add
{
	[ ! -z "$1" ] && echo -n "f502869692c06d8b437f325925d5f24109cbf128:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "cda870c14a121e8c504d12015acf695a9601fd44:"
	echo "add"
}

function expected_status_remove
{
	[ ! -z "$1" ] && echo -n "f502869692c06d8b437f325925d5f24109cbf128:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "cda870c14a121e8c504d12015acf695a9601fd44:"
	echo "add"

	[ ! -z "$1" ] && echo -n "a12f2dcfda499dc2bd77f7ad62c7611263c54b9e:"
	echo "remove"
}

function expected_status_mode
{
	[ ! -z "$1" ] && echo -n "f502869692c06d8b437f325925d5f24109cbf128:"
	echo "modify"

	[ ! -z "$1" ] && echo -n "cda870c14a121e8c504d12015acf695a9601fd44:"
	echo "add"

	[ ! -z "$1" ] && echo -n "a12f2dcfda499dc2bd77f7ad62c7611263c54b9e:"
	echo "remove"

	[ ! -z "$1" ] && echo -n "e5622521a39ab44f7a27b1fdb4dba01d60f2c8e5:"
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

