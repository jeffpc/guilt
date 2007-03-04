#

sub format_one {
	my ($out, $name) = @_;
	my ($state, $description);
	open I, '<', "$name.txt" or die "No such file $name.txt";
	while (<I>) {
		if (/^NAME$/) {
			$state = 1;
			next;
		}
		if ($state == 1 && /^----$/) {
			$state = 2;
			next;
		}
		next if ($state != 2);
		chomp;
		$description = $_;
		last;
	}
	close I;
	if (!defined $description) {
		die "No description found in $name.txt";
	}
	if (my ($verify_name, $text) = ($description =~ /^($name) - (.*)/)) {
		print $out "guiltlink:$name\[1\]::\n";
		print $out "\t$text.\n\n";
	}
	else {
		die "Description does not match $name: $description";
	}
}

my %cmds = ();
while (<DATA>) {
	next if /^#/;

	chomp;
	my ($name, $cat) = /^(\S+)\s+(.*)$/;
	push @{$cmds{$cat}}, $name;
}

my $out = "cmds.txt";
@manpages = <guilt-*.txt>;
open O, '>', "$out+" or die "Cannot open output file $out+";
foreach $name (@manpages) {
	$name =~ m/(\S+).txt/;
	format_one(\*O, $1);
}
close O;
rename "$out+", "$out";
