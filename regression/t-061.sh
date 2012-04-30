#!/bin/bash
#
# Test the branch-switching upgrade code
#

source $REG_DIR/scaffold

old_style_branch() {
	# Modify the refs so that it looks as if the patch series was applied
	# by an old version of guilt.
	cmd git update-ref refs/heads/$1 refs/heads/guilt/$1
	cmd git symbolic-ref HEAD refs/heads/$1
	cmd git update-ref -d refs/heads/guilt/$1
}

remove_topic() {
	cmd guilt pop -a
	if git rev-parse --verify --quiet guilt/master
	then
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

cmd guilt push -a
cmd list_files
cmd git for-each-ref

# Pop and push patches.  Check that the repo is converted to new-style
# refs when no patches are applied and a patch is pushed.
old_style_branch master
cmd git for-each-ref

cmd list_files

for i in `seq 5`
do
	cmd guilt pop
	cmd git for-each-ref
	cmd guilt push
	cmd git for-each-ref
	cmd guilt pop
	cmd git for-each-ref
done

# Check that "pop -a" does the right thing.
cmd guilt push -a

old_style_branch master

cmd git for-each-ref

cmd guilt pop -a

cmd git for-each-ref

# Check that pushing two patches converts the repo to now-style (since
# it currently has no patches applied).
cmd guilt push add
cmd git for-each-ref

# Check guilt branch with a few patches applied.
old_style_branch master
cmd guilt branch topic
cmd git for-each-ref

# Check that the topic branch is converted to new-style.
cmd guilt pop -a
cmd guilt push
cmd git for-each-ref

remove_topic topic

# Check guilt branch with the full patch series applied.
cmd guilt push -a
old_style_branch master
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
