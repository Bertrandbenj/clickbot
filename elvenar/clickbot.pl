#!/usr/bin/perl

use strict;
use Switch;

my $militaryDelay = 60;
my $collectDelay = 180;

my ($atel, $atelDelay, $manuDelay, $unit, $fdiurne, $fnocturne) = @ARGV;
my $loopFD = 60;
switch ($fdiurne) {
	case 1	{ $loopFD = 60; }
	case 2	{ $loopFD = 180; }
	case 3	{ $loopFD = 300; }
	case 4	{ $loopFD = 600; }
	else	{ $loopFD = 60; }
}

my $loopFN = 60;
switch ($fnocturne) {
	case 1	{ $loopFN = 90; }
	case 2	{ $loopFN = 240; }
	case 3	{ $loopFN = 420; }
	case 4	{ $loopFN = 540; }
	else	{ $loopFN = 90; }
}


my $nextManu = $manuDelay;
my $nextAtel = $atelDelay;
my $nextMilitary = $atelDelay;
my $nextCollect= $collectDelay;
my $nextFDiurne = $loopFD;
my $nextFNocturne = $loopFN;

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

	print "$hour:$min ---- Atelier: $nextAtel -- Manuf: $nextManu -- Caserne: $nextMilitary -- Collect: $nextCollect-- FD: $nextFDiurne -- FN: $nextFNocturne \n";
	

	if( $nextManu <= 0 || $nextAtel <= 0 || $nextMilitary <= 0 || $nextCollect<= 0 || $nextFNocturne <= 0 || $nextFDiurne <= 0 ){
	
		print "Page opening ... \n";
		`xmacroplay -d 500 < openpage > /dev/null`;
		`sleep 15`;
	

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

		if($nextFDiurne <= 0){
			print "Ferme diurne ... \n";
			foreach(`grep -1 ButtonPress fermediurne | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress $fdiurne \nKeyStrRelease $fdiurne\n";
			}
			$nextFDiurne = $loopFD;
		}


		if($nextFNocturne <= 0){
			print "Ferme nocturne ... \n";
			foreach(`grep -1 ButtonPress fermenecturne | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress $fnocturne \nKeyStrRelease $fnocturne\n";
			}
			$nextFNocturne = $loopFN;
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

		if($nextCollect<= 0){
			print "Collect 3h ... \n";
			foreach(`grep -1 ButtonPress collect3h | grep Mot`) {
				print TOOUTPUT "$_";
				print TOOUTPUT "ButtonPress 1 \nButtonRelease 1\n";
				print TOOUTPUT "KeyStrPress Escape \nKeyStrRelease Escape\n";
			}
			$nextCollect= $collectDelay;
		}




		print "Close macro ... \n";
		close TOOUTPUT or warn $! ? "Error closing macro pipe: $!" : "Exit status $?";
		print "Close page ... \n";
		`xmacroplay -d 400 < closepage > /dev/null`;

	}
	$nextManu--; $nextAtel--; $nextMilitary--; $nextCollect--; $nextFNocturne--; $nextFDiurne--;
	`sleep 60`;
}
