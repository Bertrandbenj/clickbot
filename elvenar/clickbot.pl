#!/usr/bin/perl

use strict;
use Switch;

my $militaryDelay = 60;
my $populationDelay = 300;

my ($atel, $atelDelay, $manuDelay, $unit) = @ARGV;

my $nextManu = $manuDelay;
my $nextAtel = $atelDelay;
my $nextMilitary = $atelDelay;
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

	print "$hour:$min ---- Atelier: $nextAtel -- Manuf: $nextManu -- Caserne: $nextMilitary -- Pop: $nextPopulation \n";
	

	if( $nextManu <= 0 || $nextAtel <= 0 || $nextMilitary <= 0 || $nextPopulation <= 0){
	
		print "Page opening ... \n";
		`xmacroplay -d 500 < openpage > /dev/null`;
		`sleep 27`;
	

		my $output = 'KeyStrPress Escape \nKeyStrRelease Escape\n';
		open TOOUTPUT, ' | xmacroplay -d 500 > /dev/null' or die "Can't open TOOUTPUT: $!";

	
		if ($nextAtel <= 0){
			print "Ateliers ... \n";
			foreach(`grep -1 ButtonPress atelier | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress $atel \nKeyStrRelease $atel\n";
			}
			$nextAtel = $loopAtel;
		}
		

		if($nextManu <= 0){
			print "Manufactures ... \n";
			foreach(`grep -1 ButtonPress manufacture | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress 1 \nKeyStrRelease 1\n";
			}
			$nextManu = 180;
		}

		if($nextMilitary <= 0){
			print "Military ... \n";
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

		if($nextPopulation <= 0){
			print "Population ... \n";
			foreach(`grep -1 ButtonPress popul | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
			}
			$nextPopulation = $populationDelay;
		}

		print "Close macro ... \n";
		close TOOUTPUT or warn $! ? "Error closing macro pipe: $!" : "Exit status $?";
		print "Close page ... \n";
		`xmacroplay -d 400 < closepage > /dev/null`;

	}
	$nextManu--; $nextAtel--; $nextMilitary--; $nextPopulation--;
	`sleep 60`;
}
