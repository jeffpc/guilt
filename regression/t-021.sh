#!/bin/bash
#
# Test the pop code
#

source $REG_DIR/scaffold

begin "setup_repo"
setup_repo

begin "guilt-push --all"
guilt-push --all

begin "git-log"
git-log -p

#
# incremental pop by 1
#
guilt-series | tac | while read n ; do
	begin "guilt-pop (unnamed, $n)"
	guilt-pop

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p
done

#
# push all
#
begin "guilt-push --all"
guilt-push --all

#
# pop by name (initially all applied)
#
guilt-series | tac | while read n ; do
	begin "guilt-pop $n (named, $n)"
	guilt-pop $n

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p

	begin "guilt-push --all"
	guilt-push --all
done

#
# pop by name (incrementally)
#
guilt-series | tac | while read n ; do
	begin "guilt-pop $n (name, incremental, $n)"
	guilt-pop $t

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p
done

#
# push all
#
begin "guilt-push --all"
guilt-push --all

npatches=`guilt-series | wc -l`
for n in `seq -2 $npatches`; do
	begin "guilt-pop -n $n"
	if [ $n -gt 0 ]; then
		guilt-pop -n $n
	else
		shouldfail guilt-pop -n $n 2>&1
	fi

	begin "list_files"
	list_files

	begin "git-log"
	git-log -p

	begin "guilt-push --all"
	guilt-push --all
done

begin "list_files"
list_files

# FIXME:
#   --all
#   -a
#   -n with some patches already applied
