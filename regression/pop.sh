#
# Test the pop code
#

source scaffold

function expected_files
{
	cat << DONE
d .git/patches
d .git/patches/master
f .git/patches/master/series
f .git/patches/master/status
f .git/patches/master/modify
f .git/patches/master/add
f .git/patches/master/remove
f .git/patches/master/mode
DONE
}


function prepare_for_tests
{
	# set up the repo so we have something interesting to run gq on
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

# the test itself
empty_repo
cd $REPODIR
gq-init

prepare_for_tests

gq-push --all > /dev/null

# NOTE: this has to be in the reverse order as the series file
tests="mode remove add modify"

for t in $tests
do
	gq-pop > /dev/null

	expected_files | verify_repo .git/patches

	echo -n "[$t] "
done

# FIXME: make sure --all and multiple patch pop works

complete_test

