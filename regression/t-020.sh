#!/bin/bash
#
# Test the push code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

#
# incremental push by 1
#
guilt-series | while read n ; do
	begin "guilt-push (unnamed, $n)"
	guilt-push

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p
done

#
# pop all
#
begin "guilt-pop --all"
guilt-pop --all

#
# push by name (initially nothing applied)
#
guilt-series | while read n ; do
	begin "guilt-push $n (named, $n)"
	guilt-push $t

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p

	begin "guilt-pop --all"
	guilt-pop --all
done

#
# push by name (incrementally)
#
guilt-series | while read n ; do
	begin "guilt-push $n (named, incremental, $n)"
	guilt-push $t

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p
done

#
# pop all
#
begin "guilt-pop --all"
guilt-pop --all

npatches=`guilt-series | wc -l`
for n in `seq -2 $npatches`; do
	begin "guilt-push -n $n"
	if [ $n -ge 0 ]; then
		guilt-push -n $n
	else
		shouldfail guilt-push -n $n 2>&1
	fi

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p

	begin "guilt-pop --all"
	guilt-pop --all
done

begin "list_files"
list_files

# FIXME:
#   --all
#   -a
#   -n with some patches already applied
