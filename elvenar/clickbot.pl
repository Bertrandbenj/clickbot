#!/usr/bin/perl

use strict;
use Switch;

# Entry message
print "clickbot [atelier 1-6] [manufacture time] [caserne 1-5]\n";
print "usage clickbot 3 0 2\n";
print "Atelier : $1 \n";
print "Manufacture : $2\n";
print "Caserne : $3 \n";

my $loop = 60; # minute in seconds


switch ($1) {
	case 1	{ $loop *= 5}
	case 2	{ $loop *= 15 }
	case 3	{ $loop *= 60 }
	case 4	{ $loop *= 3 * 60 }
	case 5	{ $loop *= 9 * 60 }
	case 6	{ $loop *= 24 * 60 }
	else	{ $loop *= 60 }
}


while (1){
	`xmacroplay -d 400 < openpage`;
	`sleep 25; echo page open`;


	my $output = '';
	open TOOUTPUT, ' | xmacroplay -d 400' or die "Can't open TOOUTPUT: $!";


	foreach(`grep -1 ButtonPress atelier | grep Mot`) {
		print TOOUTPUT "$_";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress $1 \nKeyStrRelease $1\n";
	}

	foreach(`grep -1 ButtonPress manufacture | grep Mot`) {
		print TOOUTPUT "$_";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress 1 \nKeyStrRelease 1\n";
	}

	foreach(`grep -1 ButtonPress caserne | grep Mot`) {
		print TOOUTPUT "$_";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress $3 \nKeyStrRelease $3\n";
		print TOOUTPUT "KeyStrPress $3 \nKeyStrRelease $3\n";
		print TOOUTPUT "KeyStrPress $3 \nKeyStrRelease $3\n";
		print TOOUTPUT "KeyStrPress $3 \nKeyStrRelease $3\n";
		print TOOUTPUT "KeyStrPress $3 \nKeyStrRelease $3\n";
	}

	foreach(`grep -1 ButtonPress popul | grep Mot`) {
		print TOOUTPUT "$_";
		print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
		print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
	}

	close TOOUTPUT or warn $! ? "Error closing macro pipe: $!" : "Exit status $?";

	`xmacroplay -d 400 < closepage > /dev/null`;

	`sleep $loop; echo page open`;
}
