#
# Test the applied code
#

source scaffold

function prepare_for_tests
{
	# set up the repo so we have something interesting to run guilt on
	echo "abc" > def
	git-add def
	git-commit -s -m "initial" 2> /dev/null > /dev/null

	# patch to modify a file
	cat << DONE > .git/patches/master/modify
diff --git a/def b/def
index 8baef1b..7d69c2f 100644
--- a/def
+++ b/def
@@ -1 +1,2 @@
 abc
+asjhfksad
DONE

	# patch to add a new file
	cat << DONE > .git/patches/master/add
diff --git a/abd b/abd
new file mode 100644
index 0000000..489450e
--- /dev/null
+++ b/abd
@@ -0,0 +1 @@
+qweert
DONE

	# patch to remove an existing file
	cat << DONE > .git/patches/master/remove
diff --git a/abd b/abd
deleted file mode 100644
index 489450e..0000000
--- a/abd
+++ /dev/null
@@ -1 +0,0 @@
-qweert
DONE

	# patch to change a mode
	cat << DONE > .git/patches/master/mode
diff --git a/def b/def
old mode 100644
new mode 100755
DONE

	# the series file of all the things
	cat << DONE > .git/patches/master/series
modify
add
remove
mode
DONE
}

function expected_status_modify
{
	echo "modify"
}

function expected_status_add
{
	echo "modify"
	echo "add"
}

function expected_status_remove
{
	echo "modify"
	echo "add"
	echo "remove"
}

function expected_status_mode
{
	echo "modify"
	echo "add"
	echo "remove"
	echo "mode"
}

# the test itself
empty_repo
cd $REPODIR
guilt-init

prepare_for_tests

# NOTE: this has to be in the same order as the series file
tests="modify add remove mode"

for t in $tests
do
	guilt-push > /dev/null

	guilt-applied > /tmp/reg.$$

	expected_status_$t | diff -u - /tmp/reg.$$
	expected_status_$t | diff -u - $REPODIR/.git/patches/master/status

	echo -n "[$t] "
done

rm -f /tmp/reg.$$

complete_test

