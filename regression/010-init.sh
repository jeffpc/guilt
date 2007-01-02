#
# Test the init code
#

source scaffold

function expected_files
{
	cat << DONE
d .git/patches
d .git/patches/master
f .git/patches/master/series
f .git/patches/master/status
DONE
}

# the test itself
empty_repo
cd $REPODIR
guilt-init
expected_files | verify_repo .git/patches

complete_test

