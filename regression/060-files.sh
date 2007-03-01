#
# Test the series parsing code
#

source scaffold
source generic_test_data

# the test itself
empty_repo
cd $REPODIR
guilt-init

generic_prepare_for_tests

function expected_files
{
	echo "def"
}

function expected_files_label
{
	echo "mode def"
}

function expected_files_verbose_label
{
	echo "[mode] def"
}

function expected_files_all
{
	echo "def"
	echo "abd"
	echo "abd"
	echo "def"
}

function expected_files_label_all
{
	echo "modify def"
	echo "add abd"
	echo "remove abd"
	echo "mode def"
}

function expected_files_verbose_all
{
	echo "modify"
	echo "  def"
	echo "add"
	echo "+ abd"
	echo "remove"
	echo "- abd"
	echo "mode"
	echo "  def"
}

function expected_files_verbose_label_all
{
	echo "[modify] def"
	echo "[add] abd"
	echo "[remove] abd"
	echo "[mode] def"

}

# push em all for tesing
guilt-push -a > /dev/null

guilt-files > /tmp/reg.$$
expected_files | diff -u - /tmp/reg.$$
echo -n "[files] "

guilt-files -l > /tmp/reg.$$
expected_files_label | diff -u - /tmp/reg.$$
echo -n "[label] "

guilt-files -v -l > /tmp/reg.$$
expected_files_verbose_label | diff -u - /tmp/reg.$$
echo -n "[verbose label] "

guilt-files -a > /tmp/reg.$$
expected_files_all | diff -u - /tmp/reg.$$
echo -n "[all] "

guilt-files -l -a > /tmp/reg.$$
expected_files_label_all | diff -u - /tmp/reg.$$
echo -n "[label all] "

guilt-files -v -a > /tmp/reg.$$
expected_files_verbose_all | diff -u - /tmp/reg.$$
echo -n "[verbose all] "

guilt-files -v -l -a > /tmp/reg.$$
expected_files_verbose_label_all | diff -u - /tmp/reg.$$
echo -n "[verbose label all] "

rm -f /tmp/reg.$$

complete_test

