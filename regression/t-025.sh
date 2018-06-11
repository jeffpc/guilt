#!/bin/bash
#
# Test the new code
#

source "$REG_DIR/scaffold"

cmd setup_repo

function fixup_time_info
{
	touch -a -m -t "$TOUCH_DATE" ".git/patches/master/$1"
}

for pname in file dir/file dir/subdir/file ; do
	cmd guilt new "$pname"
	cmd guilt pop
	fixup_time_info "$pname"
	cmd guilt push

	cmd list_files
done

cmd guilt push --all

cmd guilt new append
cmd guilt pop
fixup_time_info append
cmd guilt push

cmd list_files

cmd guilt pop --all

cmd guilt new prepend
cmd guilt pop
fixup_time_info prepend
cmd guilt push

cmd list_files

shouldfail guilt new "white space"

cmd list_files

b()
{
    printf "%b" "$1"
}

for pname in prepend mode /abc ./blah ../blah abc/./blah abc/../blah abc/. \
	abc/.. abc/ abc.lock a/b.lock/c `b 'cr\r'` `b 'ctrl-a\001'` \
	`b 'formfeed\f'` `b 'del\177'` "tilde~" "caret^" "colon:" \
	"questionmark?" "asterisk*" "open[bracket" "consecutive//slashes" \
	"trailing-dot." "bad@{seq" "@" "backslash\\"
do
	shouldfail guilt new "$pname"

	cmd list_files
done

#
# Test the -f option
#

# modify the working dir file
cmd echo qwerty >> def
cmd git diff --no-ext-diff

# try to make a new patch, without -f
shouldfail guilt new uncommitted-changes
cmd git diff --no-ext-diff
cmd list_files

# give new -f, to force things
cmd guilt new -f uncommitted-changes
cmd git diff --no-ext-diff
cmd guilt pop
fixup_time_info uncommitted-changes
cmd guilt push
cmd list_files

# modify the working dir file (again)
cmd echo dvorak >> def
cmd git update-index def
cmd git diff --no-ext-diff
cmd git diff --no-ext-diff HEAD

# try to make a new patch, without -f
shouldfail guilt new uncommitted-changes2
cmd git diff --no-ext-diff
cmd git diff --no-ext-diff HEAD
cmd list_files

# give new -f, to force things
cmd guilt new -f uncommitted-changes2
cmd git diff --no-ext-diff
cmd git diff --no-ext-diff HEAD
cmd guilt pop
fixup_time_info uncommitted-changes2
cmd guilt push
cmd list_files
