#!/usr/bin/perl -w
use strict;
use File::Temp;

sub get_temp_filename {
	my $fh = File::Temp->new(
		TEMPLATE => 'tempXXXXX',
		SUFFIX   => '.dat',
	);

	return $fh->filename;
}

my $filename = get_temp_filename();
system("gnome-terminal","--save-config=$filename");
open FILE, "<", $filename
	or die "could not open $filename: $!";
my $geo;
while (<FILE>) {
	if (/^Geometry=(.*)/) {
		$geo = $1;
		last;
	}
}
if ($geo) {
	my $line ="gnome-terminal --geometry=$geo";
	print "$line\n" ;
	if (-e "/usr/bin/xclip") {
		system( "echo '$line' | xclip -selection clipboard");
		print "xclip found, command copied to clipboard\n";
	}
}
close FILE;
unlink $filename;

