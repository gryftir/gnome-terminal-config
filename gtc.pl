#!/usr/bin/perl -w
#This gtc.pl is part of gnome-terminal-config
#
#<insert software name> is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#gnome-terminal-config is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with gnome-terminal-config.  If not, see <http://www.gnu.org/licenses/>.

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

