#!/bin/bash
#
# Test that the guilt.reusebranch=true setting works.
#

source $REG_DIR/scaffold

remove_topic() {
	cmd guilt pop -a
	if git rev-parse --verify --quiet guilt/master >/dev/null; then
		cmd git checkout guilt/master
	else
		cmd git checkout master
	fi
	cmd guilt pop -a
	cmd git branch -d $1
	cmd rm -r .git/patches/$1
	cmd git for-each-ref
	cmd list_files
}

function fixup_time_info
{
	touch -a -m -t "$TOUCH_DATE" ".git/patches/master/$1"
}

cmd setup_repo

cmd git config guilt.reusebranch true

cmd guilt push -a
cmd list_files
cmd git for-each-ref

for i in `seq 5`; do
	if [ $i -ge 5 ]; then
		shouldfail guilt pop
	else
		cmd guilt pop
	fi
	cmd git for-each-ref
	cmd guilt push
	cmd git for-each-ref
	cmd guilt pop
	cmd git for-each-ref
done

# Check that "pop -a" properly pops all patches.
cmd guilt push -a
cmd git for-each-ref
cmd guilt pop -a
cmd git for-each-ref

# Check that pushing two patches converts the repo to now-style (since
# it currently has no patches applied).
cmd guilt push add
cmd git for-each-ref

# Check guilt branch with a few patches applied.
cmd guilt branch topic
cmd git for-each-ref

# Check that the topic branch is converted to new-style.
cmd guilt pop -a
cmd guilt push
cmd git for-each-ref

remove_topic topic

# Check guilt branch with the full patch series applied.
cmd guilt push -a
cmd guilt branch topic
cmd git for-each-ref

remove_topic topic

# Check guilt branch with no patches applied.
# This gives us a new-style checkout.
cmd guilt branch topic
cmd git for-each-ref
cmd list_files

remove_topic topic

# Check guilt branch in a new-style directory with all patches
# applied.  (Strictly speaking, this test should probably move to a
# file devoted to testing "guilt branch".)
cmd guilt push -a
cmd guilt branch topic
cmd git for-each-ref
cmd list_files
cmd guilt pop -a
cmd git for-each-ref

remove_topic topic

# Check that "guilt new" does the right thing when no patches are
# applied.  (Strictly speaking, this test should maybe move to
# t-025.sh).

cmd guilt new newpatch
cmd git for-each-ref '--format=%(refname)'
cmd guilt pop
fixup_time_info newpatch
cmd guilt push
cmd git for-each-ref

# Check that "guilt commit" does the right thing when committing all
# applied patches.  (Strictly speaking, this test should maybe move to
# t-030.sh).
cmd git branch
cmd guilt applied
cmd guilt commit -a
cmd git for-each-ref
cmd git branch

# Check that "guilt commit" does the right thing when committing only
# a few of the applied patches.  (Strictly speaking, this test should
# maybe move to t-030.sh).
cmd guilt push -a
cmd guilt applied
cmd git branch
cmd git for-each-ref
cmd guilt commit -n 2
cmd git for-each-ref
cmd git branch
cmd guilt commit -n 2
cmd git for-each-ref
cmd git branch
cmd guilt series
