#
# Test the delete code
#

source scaffold
source generic_test_data

function expected_files_after_force
{
	cat << DONE
d .git/patches
d .git/patches/master
f .git/patches/master/series
f .git/patches/master/status
f .git/patches/master/modify
f .git/patches/master/add
f .git/patches/master/remove
DONE
}

function expected_files_after
{
	expected_files_after_force
	echo "f .git/patches/master/mode"
}

function expected_series
{
	cat << DONE
modify
add
remove
DONE
}

# the test itself
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

guilt-delete mode
expected_files_after | verify_repo .git/patches
echo -n "[delete] "

expected_series | diff -u - .git/patches/master/series
echo -n "[delete-series] "

# cleanup
cd ../
rm -rf $REPODIR

# set up again
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

guilt-delete -f mode
expected_files_after_force | verify_repo .git/patches
echo -n "[force] "

expected_series | diff -u - .git/patches/master/series
echo -n "[delete-series] "

complete_test

