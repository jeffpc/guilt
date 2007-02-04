#
# Test the init code
#

source scaffold

function expected_files_master
{
	cat << DONE
d .git/patches
d .git/patches/master
f .git/patches/master/series
f .git/patches/master/status
DONE
}

function expected_files_other
{
	expected_files_master
	cat << DONE
d .git/patches/other
f .git/patches/other/series
f .git/patches/other/status
DONE
}

# the test itself
empty_repo
cd $REPODIR

# make sure we have an index to work with
echo "abc" > def
git-add def 2> /dev/null > /dev/null
git-commit -m "foo" 2> /dev/null > /dev/null

branches="master other"

for b in $branches
do
	if [ "$b" != "master" ]; then
		git-branch $b
		git-checkout $b 2> /dev/null
	fi

	guilt-init
	expected_files_$b | verify_repo .git/patches
	echo -n "[$b:create] "

	shouldfail guilt-init
	echo -n "[$b:exists] "
done

complete_test

