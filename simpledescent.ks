clearscreen.
//copy tfXYZtoENU from 0.

set GRAVITY to 9.81.
//if body = "Kerbin" { set GRAVITY to 9.81. }.
//if body = "Mun" { set GRAVITY to 1.1. }.

set DECENTTOP to 70000. // atmosphere starts here!
set DEACCELHEIGHT to 600.
set FINALAPPROACH to 100.
set FINALSTAGEHEIGHT to 3.
set DEACCELSPEED to -20. // we want fall at -20 meters per second
set DECENTSPEED to -3. // final landing speed
set ENGINEISP to 300.
set TWR to MAXTHRUST / (MASS*GRAVITY).

// Constants that DONT change per body
set e to 2.718281828459. // euler
set pi to 3.14159265359.
set atmToPres to 1.2230948554874. // presure at 1.0 Atm's.
set gConst to 6.67384*10^(0-11).

// slope seeker
set slope to 0.  // Slope detected under lander.
set gHeight to 0.  // Height of ground above sea level.
set pgHeight to 0.  // previous Height of ground above sea.
set pTime to missiontime. // Previous elapsed time.

// Actual speed vertical + horizontal
lock TRUESPEED to SQRT((VERTICALSPEED^2) + (SURFACESPEED^2)).
set thrust to 0.
lock throttle to thrust.

// Test stuff.
set testH to 500.
if ALT:RADAR < testH {
	print "launching to test altitude".
	lock steering to up + R(0,15,180).
	stage.
	until STAGE:LIQUIDFUEL < 1 {
		set thrust to 1.
	}
	print "Complete.".
	set thrust to 0.
	wait 1.
}


lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
//lock DEACCELSPEED to -1 * (ALTITUDE / 30).
lock DEACCELSPEED to ((ALTITUDE / 70000) * 4000)/2.7.

print "Airbraking".
set HIGHBURNSTART to MISSIONTIME.
set TargetH to ALT:RADAR.
Set lastupdate to missiontime.
until ALT:RADAR < DEACCELHEIGHT {

	set TargetH to TargetH - ((-1 * DEACCELSPEED) * (missiontime - lastupdate)).
	
	//set TRUESPEED to SQRT((VERTICALSPEED^2) + (SURFACESPEED^2)).
	print "VERTICALSPEED: " + VERTICALSPEED + ", TRUESPEED: " + TRUESPEED .
	print "DEACCELSPEED: " + DEACCELSPEED.
	print "TARGETH: " + TargetH.

	until TRUESPEED > DEACCELSPEED {
		set P to 0.02*((TargetH - ALT:RADAR)-TRUESPEED).
		set I to 0.02*((TargetH - ALT:RADAR)-TRUESPEED + I).
		//set thrust to P + I.
	}.
	set thrust to 0.

	set lastupdate to missiontime.
	wait 1.

}.

//H = 600
//S = 20 *(0-1)
//S = ALT / 30

//print "VERTICALSPEED: " + VERTICALSPEED.
//print "MASS: " + MASS.
//set FINALMASS to MASS / SQRT((((0-1) * VERTICALSPEED) / ENGINEISP) / GRAVITY).
//print "FINALMASS: " + FINALMASS.
//set AVGTWR to MAXTHRUST / ((MASS + FINALMASS) / 2 ).
//print "AVGTWR: " + AVGTWR. 
//print "Expected Time to brake: " + VERTICALSPEED / (AVGTWR / GRAVITY).
//set TWR to MAXTHRUST / (MASS*GRAVITY).
//print "Expected Time to brake: " + VERTICALSPEED / (TWR / GRAVITY).
//set BRAKESTART to MISSIONTIME.
set thrust to 0.


print "Burn...".
// Time = Delta-V / (TWR * 9.81)
until VERTICALSPEED > DEACCELSPEED {
	lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
	set thrust to 1.
	if STAGE:LIQUIDFUEL < 1 {
		stage.
	}
}.

print "Dumping heavy stage".
set thrust to 0.
wait 0.25.
stage.
set thrust to 0.25.
lock throttle to thrust.


set TargetH to ALT:RADAR.
print "Descending to FinalDescent height: " + FINALAPPROACH.
Set lastupdate to missiontime.
set I to 0.
print "Maintaining vertical speed of: " + DEACCELSPEED.
until ALT:RADAR < FINALAPPROACH {
	
	set TargetH to TargetH - (((0-1)*DEACCELSPEED) * (missiontime - lastupdate)).

	until VERTICALSPEED > DEACCELSPEED {
		set P to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED).
		set I to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED + I).
		set thrust to P + I.
	}.
	
	set thrust to 0.
	//set timepast to missiontime - prefinaltime.
	
	print "Deltatime: " + (missiontime - lastupdate). 
	print "Deltaheight: " + ((0-1)*DEACCELSPEED) * (missiontime - lastupdate).
	print "Verticalspeed: " + VERTICALSPEED.
	print "DEACCELSPEED: " + DEACCELSPEED.
	print "TargetH: " + TargetH.
 

	//print TargetH.

	//if timepast > 1 {
	//	set TargetH to TargetH - 20.
	//	set timepast to 0.
	//}

	if STAGE:LIQUIDFUEL < 1 {
		stage.
	}

	set lastupdate to missiontime.

	//wait 0.25.

}

print "FinalDescent...".
set LastHeight to ALT:RADAR.
print "Gear Down".
TOGGLE GEAR.

// search for flat spot
//print "seeking level ground".
//set LAND to 0.

//set height to ALT:RADAR.
//until LAND = 1 {
//	lock steering to up + R(0,2,0).
//	set TWR to MAXTHRUST / (mass*GRAVITY).
//	//set P to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED).
//	//set I to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED + I).
//	set thrust to 0.5*(MAXTHRUST / TWR).
//	lock throttle to thrust.
//	print ALT:RADAR.
//}


until ALT:RADAR < FINALSTAGEHEIGHT {
	set DecentStart to MISSIONTIME.
	set TargetH to ALT:RADAR - 1.
	set CurrentDecentSpeed to LastHeight -  ALT:RADAR.

	until VERTICALSPEED > DECENTSPEED {
		lock steering to up.
		set TWR to MAXTHRUST / (mass*GRAVITY).
		set P to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED).
		set I to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED + I).
		set thrust to 1/TWR + P + I.
		lock throttle to thrust.
		//print "throttle to: " + thrust.
	}

	if STAGE:LIQUIDFUEL < 1 {
		stage.
	}

	//if STATUS = "LANDED" OR STATUS = "SPLASHED" {
	//	BREAK.
	//}.
	
	lock steering to up.
	set TWR to MAXTHRUST / (mass*GRAVITY).
	set thrust to ((1/TWR)/100) * 98.
	lock throttle to thrust.
	set LastHeight to ALT:RADAR.
}.

lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
Lock throttle to (2 * GRAVITY * mass/maxthrust).
stage.
Lock throttle to 0.
Print missiontime + " Landed.".



