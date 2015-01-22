#!/bin/bash
#
# Test the fold code
#

source "$REG_DIR/scaffold"

cmd setup_repo

function fixup_time_info
{
	cmd guilt pop
	touch -a -m -t "$TOUCH_DATE" ".git/patches/master/$1"
	cmd guilt push
}

function empty_patch
{
	cmd guilt new "empty$1"
	fixup_time_info "empty$1"
}

function nonempty_patch
{
	if [ "$1" = -2 ]; then
		msg="Another commit message."
	else
		msg="A commit message."
	fi

	cmd guilt new -f -s -m "$msg" "nonempty$1"
	fixup_time_info "nonempty$1"
}

for using_diffstat in true false; do
	cmd git config guilt.diffstat $using_diffstat
	for patcha in empty nonempty; do
		for patchb in empty nonempty; do

			if [ $patcha = $patchb ]; then
				suffixa=-1
				suffixb=-2
			else
				suffixa=
				suffixb=
			fi

			echo "%% $patcha + $patchb (diffstat=$using_diffstat)"
			${patcha}_patch $suffixa
			${patchb}_patch $suffixb
			cmd guilt pop
			cmd guilt fold $patchb$suffixb
			fixup_time_info $patcha$suffixa
			cmd list_files
			cmd guilt pop
			cmd guilt delete -f $patcha$suffixa
			cmd list_files

		done
	done
done
