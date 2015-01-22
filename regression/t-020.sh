#!/bin/bash
#
# Test the push code
#

source "$REG_DIR/scaffold"

function fixup_time_info
{
	cmd guilt pop
	touch -a -m -t "$TOUCH_DATE" ".git/patches/master/$1"
	cmd guilt push
}

cmd setup_repo

#
# incremental push by 1
#
guilt series | while read n ; do
	cmd guilt push

	cmd list_files

	cmd git log -p
done

#
# pop all
#
cmd guilt pop --all

#
# push by name (initially nothing applied)
#
guilt series | while read n ; do
	cmd guilt push $t

	cmd list_files

	cmd git log -p

	cmd guilt pop --all
done

#
# push by name (incrementally)
#
guilt series | while read n ; do
	cmd guilt push $t

	cmd list_files

	cmd git log -p
done

#
# pop all
#
cmd guilt pop --all

npatches=`guilt series | wc -l`
for n in `_seq -2 $npatches`; do
	if [ $n -ge 0 ]; then
		cmd guilt push -n $n
	else
		shouldfail guilt push -n $n
	fi

	cmd list_files

	cmd git log -p

	cmd guilt pop --all
done

cmd list_files

# push an empty patch with no commit message
cmd guilt new empty.patch
fixup_time_info empty.patch
cmd list_files
cmd git log -p

# Ensure we can push the empty patch even when guilt.diffstat is true.
cmd git config guilt.diffstat true
cmd guilt refresh
fixup_time_info empty.patch
cmd list_files
cmd git log -p
cmd git config guilt.diffstat false

# Let the patch have a commit message, but no data.
cat > .git/patches/master/empty.patch <<EOF
Fix a bug.

From: Per Cederqvist <ceder@lysator.liu.se>

This commit fixes a serious bug.

FIXME:
    - add a test case
    - track down the bug
    - actually fix it
EOF

fixup_time_info empty.patch
cmd list_files
cmd git log -p

# And once more, with an empty diffstat.

cmd git config guilt.diffstat true
cmd guilt refresh
fixup_time_info empty.patch
cmd list_files
cmd git log -p

# Restore the diffstat setting and remove the empty patch.
cmd git config guilt.diffstat false
cmd guilt refresh
fixup_time_info empty.patch
cmd list_files
cmd git log -p
# (Cannot delete an applied patch)
shouldfail guilt delete empty.patch
cmd guilt pop -a
cmd guilt delete -f empty.patch
cmd list_files
cmd git log -p

# FIXME:
#   --all
#   -a
#   -n with some patches already applied
