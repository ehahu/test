	(
		cd "$1" &&
		shift &&
		for name
		do
			echo "$name" >"$name" &&
			git add "$name" &&
			test_tick &&
			git commit -m "Add $name" || exit
		done >/dev/null &&
		git rev-parse --short --verify HEAD
	)
fullhead1=$(cd sm1; git rev-parse --verify HEAD)
test_expect_success 'added submodule' '
	Submodule sm1 0000000...$head1 (new submodule)
	EOF
	test_cmp expected actual
'

test_expect_success 'added submodule, set diff.submodule' '
	git config diff.submodule log &&
	git add sm1 &&
	git diff --cached >actual &&
	cat >expected <<-EOF &&
	Submodule sm1 0000000...$head1 (new submodule)
	EOF
	git config --unset diff.submodule &&
	test_cmp expected actual
'

test_expect_success '--submodule=short overrides diff.submodule' '
	test_config diff.submodule log &&
	git add sm1 &&
	git diff --submodule=short --cached >actual &&
	cat >expected <<-EOF &&
	diff --git a/sm1 b/sm1
	new file mode 160000
	index 0000000..$head1
	--- /dev/null
	+++ b/sm1
	@@ -0,0 +1 @@
	+Subproject commit $fullhead1
	EOF
'

test_expect_success 'diff.submodule does not affect plumbing' '
	test_config diff.submodule log &&
	git diff-index -p HEAD >actual &&
	cat >expected <<-EOF &&
	diff --git a/sm1 b/sm1
	new file mode 160000
	index 0000000..$head1
	--- /dev/null
	+++ b/sm1
	@@ -0,0 +1 @@
	+Subproject commit $fullhead1
	EOF
	test_cmp expected actual
'
test_expect_success 'modified submodule(forward)' '
	Submodule sm1 $head1..$head2:
	  > Add foo3
	EOF
'
test_expect_success 'modified submodule(forward)' '
	Submodule sm1 $head1..$head2:
	  > Add foo3
	EOF
'
test_expect_success 'modified submodule(forward) --submodule' '
	Submodule sm1 $head1..$head2:
	  > Add foo3
	EOF
'
fullhead2=$(cd sm1; git rev-parse --verify HEAD)
test_expect_success 'modified submodule(forward) --submodule=short' '
	diff --git a/sm1 b/sm1
	index $head1..$head2 160000
	--- a/sm1
	+++ b/sm1
	@@ -1 +1 @@
	-Subproject commit $fullhead1
	+Subproject commit $fullhead2
	EOF
'
	git rev-parse --short --verify HEAD
test_expect_success 'modified submodule(backward)' '
	Submodule sm1 $head2..$head3 (rewind):
	  < Add foo3
	  < Add foo2
	EOF
'
head4=$(add_file sm1 foo4 foo5)
test_expect_success 'modified submodule(backward and forward)' '
	Submodule sm1 $head2...$head4:
	  > Add foo5
	  > Add foo4
	  < Add foo3
	  < Add foo2
	EOF
'
test_expect_success 'typechanged submodule(submodule->blob), --cached' '
	Submodule sm1 $head4...0000000 (submodule deleted)
	diff --git a/sm1 b/sm1
	new file mode 100644
	index 0000000..$head5
	--- /dev/null
	+++ b/sm1
	@@ -0,0 +1 @@
	+sm1
	EOF
'
test_expect_success 'typechanged submodule(submodule->blob)' '
	diff --git a/sm1 b/sm1
	deleted file mode 100644
	index $head5..0000000
	--- a/sm1
	+++ /dev/null
	@@ -1 +0,0 @@
	-sm1
	Submodule sm1 0000000...$head4 (new submodule)
	EOF
'
test_expect_success 'typechanged submodule(submodule->blob)' '
	Submodule sm1 $head4...0000000 (submodule deleted)
	diff --git a/sm1 b/sm1
	new file mode 100644
	index 0000000..$head5
	--- /dev/null
	+++ b/sm1
	@@ -0,0 +1 @@
	+sm1
	EOF
'
fullhead6=$(cd sm1; git rev-parse --verify HEAD)
test_expect_success 'nonexistent commit' '
	Submodule sm1 $head4...$head6 (commits not present)
	EOF
'
test_expect_success 'typechanged submodule(blob->submodule)' '
	diff --git a/sm1 b/sm1
	deleted file mode 100644
	index $head5..0000000
	--- a/sm1
	+++ /dev/null
	@@ -1 +0,0 @@
	-sm1
	Submodule sm1 0000000...$head6 (new submodule)
	EOF
'
test_expect_success 'submodule is up to date' '
	EOF
'
test_expect_success 'submodule contains untracked content' '
	Submodule sm1 contains untracked content
	EOF
'
test_expect_success 'submodule contains untracked content (untracked ignored)' '
'
test_expect_success 'submodule contains untracked content (dirty ignored)' '
'
test_expect_success 'submodule contains untracked content (all ignored)' '
'
test_expect_success 'submodule contains untracked and modifed content' '
	Submodule sm1 contains untracked content
	Submodule sm1 contains modified content
	EOF
'
test_expect_success 'submodule contains untracked and modifed content (untracked ignored)' '
	Submodule sm1 contains modified content
	EOF
'
test_expect_success 'submodule contains untracked and modifed content (dirty ignored)' '
'
test_expect_success 'submodule contains untracked and modifed content (all ignored)' '
'
test_expect_success 'submodule contains modifed content' '
	Submodule sm1 contains modified content
	EOF
'
head8=$(cd sm1; git rev-parse --short --verify HEAD) &&
test_expect_success 'submodule is modified' '
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked content' '
	Submodule sm1 contains untracked content
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked content (untracked ignored)' '
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked content (dirty ignored)' '
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked content (all ignored)' '
'
test_expect_success 'modified submodule contains untracked and modifed content' '
	Submodule sm1 contains untracked content
	Submodule sm1 contains modified content
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked and modifed content (untracked ignored)' '
	Submodule sm1 contains modified content
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked and modifed content (dirty ignored)' '
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'modified submodule contains untracked and modifed content (all ignored)' '
'
test_expect_success 'modified submodule contains modifed content' '
	Submodule sm1 contains modified content
	Submodule sm1 $head6..$head8:
	  > change
	EOF
'
test_expect_success 'deleted submodule' '
	Submodule sm1 $head6...0000000 (submodule deleted)
	EOF
'
test_expect_success 'multiple submodules' '
	Submodule sm1 $head6...0000000 (submodule deleted)
	Submodule sm2 0000000...$head7 (new submodule)
	EOF
'
test_expect_success 'path filter' '
	Submodule sm2 0000000...$head7 (new submodule)
	EOF
'
test_expect_success 'given commit' '
	Submodule sm1 $head6...0000000 (submodule deleted)
	Submodule sm2 0000000...$head7 (new submodule)
	EOF
'
test_expect_success 'given commit --submodule' '
	Submodule sm1 $head6...0000000 (submodule deleted)
	Submodule sm2 0000000...$head7 (new submodule)
	EOF
'
fullhead7=$(cd sm2; git rev-parse --verify HEAD)
test_expect_success 'given commit --submodule=short' '
	diff --git a/sm1 b/sm1
	deleted file mode 160000
	index $head6..0000000
	--- a/sm1
	+++ /dev/null
	@@ -1 +0,0 @@
	-Subproject commit $fullhead6
	diff --git a/sm2 b/sm2
	new file mode 160000
	index 0000000..$head7
	--- /dev/null
	+++ b/sm2
	@@ -0,0 +1 @@
	+Subproject commit $fullhead7
	EOF
	test_cmp expected actual
'
	Submodule sm1 $head6...0000000 (submodule deleted)
	Submodule sm2 0000000...$head7 (new submodule)
	EOF