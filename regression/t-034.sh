#!/bin/bash
#
# Test import-commit
#

function create_commit
{
	echo $1 >> $1 &&
		git add $1 &&
		git commit -m"$2"
}

source "$REG_DIR/scaffold"

b()
{
	printf "%b" "$1"
}

cmd setup_git_repo

cmd git tag base

# Create a series of commits whose first line of the commit message
# each violates one of the rules in get-check-ref-format(1).

cmd create_commit a "The sequence /. is forbidden."
cmd create_commit a "The sequence .lock/ is forbidden."
cmd create_commit a "A/component/may/not/end/in/foo.lock"
cmd create_commit a "Two consecutive dots (..) is forbidden."
cmd create_commit a "Check/multiple/../dots/...../foo..patch"
cmd create_commit a "Space is forbidden."
cmd create_commit a "Tilde~is~forbidden."
cmd create_commit a "Caret^is^forbidden."
cmd create_commit a "Colon:is:forbidden."
cmd create_commit a `b 'Del\177is\177forbidden.'`
# Create a branch and a tag from the current commit, to ensure that
# doing so does not affect how the commit is imported.
cmd git branch some-branch
cmd git tag some-tag
cmd create_commit a `b 'Ctrl\001is\002forbidden.'`
cmd create_commit a `b 'CR\ris\ralso\rforbidden.'`
cmd create_commit a "Question-mark?is?forbidden."
cmd create_commit a "Asterisk*is*forbidden."
cmd create_commit a "Open[bracket[is[forbidden."
cmd create_commit a "Multiple/slashes//are//forbidden."
cmd create_commit a "Cannot/end/in/slash/"
cmd create_commit a "Cannot end in .."
cmd create_commit a "Cannot@{have@{the@{sequence@{at-brace."
cmd create_commit a "@"
cmd create_commit a "Backslash\\is\\forbidden."

# Slash is sometimes allowed; this is not problematic.
cmd create_commit a "Can/have/embedded/single/slashes"

cmd git log

# Import all the commits to guilt.
cmd guilt init
cmd guilt import-commit base..HEAD

for patch in .git/patches/master/*.patch; do
	touch -a -m -t "$TOUCH_DATE" "$patch"
done

# If push and pop works, the names we created are good.
cmd guilt push -a
cmd git log --decorate
cmd git log --decorate some-branch
cmd list_files
cmd guilt pop -a
