#!/usr/bin/perl

use strict;
use Switch;

my $militaryDelay = 60;
my $populationDelay = 300;

my ($atel, $atelDelay, $manuDelay, $unit) = @ARGV;

my $nextManu = $manuDelay;
my $nextAtel = $atelDelay;
my $nextMilitary = $militaryDelay;
my $nextPopulation = $populationDelay;

# Entry message
print "Usage : clickbot [atelier 1-4] [manufacture time left to wait (min)] [caserne unit type 1-5]\n";
print "running : clickbot.pl $atel $atelDelay $manuDelay $unit \n";


my $loopAtel = 0;
switch ($atel) {
	case 1	{ $loopAtel = 5; }
	case 2	{ $loopAtel = 15; }
	case 4	{ $loopAtel = 180; }
	else	{ $loopAtel = 60; }
}




while (1){

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

	print "At $hour h $min min  --------------------\n";
	print "Atelier     - $atel in $nextAtel min \n";
	print "Manufacture - 180 in $nextManu min\n";
	print "Caserne     - $unit in $nextMilitary min\n";
	print "Population  in $nextPopulation min\n";
	print "\n";

	if( --$nextManu < 0 || --$nextAtel < 0 || --$nextMilitary < 0 || --$nextPopulation < 0){

		`xmacroplay -d 500 < openpage > /dev/null`;
		print "Page opening ... ";
		`sleep 27`;
	

		my $output = '';
		open TOOUTPUT, ' | xmacroplay -d 500' or die "Can't open TOOUTPUT: $!";

	
		if ($nextAtel < 0){
			foreach(`grep -1 ButtonPress atelier | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress $atel \nKeyStrRelease $atel\n";
			}
			$nextAtel = $loopAtel;
			$nextManu--;
		}
		

		if($nextManu < 0){
			foreach(`grep -1 ButtonPress manufacture | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress 1 \nKeyStrRelease 1\n";
			}
			$nextManu = 180;
		}

		if($nextMilitary < 0){
			foreach(`grep -1 ButtonPress caserne | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress $unit \nKeyStrRelease $unit\n";
				print TOOUTPUT "KeyStrPress $unit \nKeyStrRelease $unit\n";
				print TOOUTPUT "KeyStrPress $unit \nKeyStrRelease $unit\n";
				print TOOUTPUT "KeyStrPress $unit \nKeyStrRelease $unit\n";
				print TOOUTPUT "KeyStrPress $unit \nKeyStrRelease $unit\n";
			}
			$nextMilitary = $militaryDelay;
		}

		if($nextPopulation == 0){
			foreach(`grep -1 ButtonPress popul | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
			}
			my $nextPopulation = $populationDelay;
		}

		close TOOUTPUT or warn $! ? "Error closing macro pipe: $!" : "Exit status $?";

		`xmacroplay -d 400 < closepage > /dev/null`;

	}
	
	`sleep 60`;
}
