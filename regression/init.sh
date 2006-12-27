#
# Test the init code
#

source scaffold

function expected_files
{
	cat << DONE
d .
d ./.git
d ./.git/refs
d ./.git/refs/heads
d ./.git/refs/tags
d ./.git/branches
d ./.git/remotes
f ./.git/description
d ./.git/hooks
f ./.git/hooks/applypatch-msg
f ./.git/hooks/post-update
f ./.git/hooks/commit-msg
f ./.git/hooks/update
f ./.git/hooks/pre-applypatch
f ./.git/hooks/pre-commit
f ./.git/hooks/post-commit
f ./.git/hooks/pre-rebase
d ./.git/info
f ./.git/info/exclude
d ./.git/objects
d ./.git/objects/pack
d ./.git/objects/info
f ./.git/HEAD
f ./.git/config
d ./.git/patches
d ./.git/patches/master
f ./.git/patches/master/series
f ./.git/patches/master/status
DONE
}

# empty repo
empty_repo
cd $REPODIR
gq-init
expected_files | verify_repo

complete_test
