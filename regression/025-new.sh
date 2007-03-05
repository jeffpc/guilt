#
# Test the new code
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

function patch_name_dir
{
	echo "aaa"
}
function expected_files_dir
{
	expected_files
	cat << DONE
f .git/patches/master/aaa
DONE
}

function patch_name_subdir
{
	echo "abc/def"
}
function expected_files_subdir
{
	expected_files_dir
	cat << DONE
d .git/patches/master/abc
f .git/patches/master/abc/def
DONE
}

function patch_name_subsubdir
{
	echo "foo/bar/patch"
}
function expected_files_subsubdir
{
	expected_files_subdir
	cat << DONE
d .git/patches/master/foo
d .git/patches/master/foo/bar
f .git/patches/master/foo/bar/patch
DONE
}

function expected_files_append
{
	expected_files_subsubdir
	echo "f .git/patches/master/append"
}

function expected_files_prepend
{
	expected_files_append
	echo "f .git/patches/master/prepend"
}

# the test itself
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

tests="dir subdir subsubdir"

for t in $tests; do
	guilt-new `patch_name_$t`

	expected_files_$t | verify_repo .git/patches

	echo -n "[$t] "
done

guilt-push --all > /dev/null

guilt-new append
expected_files_append | verify_repo .git/patches
echo -n "[append] "

guilt-pop -a > /dev/null

guilt-new prepend
expected_files_prepend | verify_repo .git/patches
echo -n "[prepend] "

guilt-pop -a > /dev/null

guilt-new "white space"
echo -n "[whitespace] "

shouldfail guilt-new prepend
echo -n "[dup] "

shouldfail guilt-new /abc
echo -n "[abs] "

shouldfail guilt-new ./blah
echo -n "[prefix-dot] "

shouldfail guilt-new ../blah
echo -n "[prefix-dotdot] "

shouldfail guilt-new abc/./blah
echo -n "[infix-dot] "

shouldfail guilt-new abc/../blah
echo -n "[infix-dotdot] "

shouldfail guilt-new abc/.
echo -n "[postfix-dot] "

shouldfail guilt-new abc/..
echo -n "[postfix-dotdot] "

shouldfail guilt-new abc/
echo -n "[postfix-slash] "

complete_test

