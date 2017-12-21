clearscreen.

set GRAVITY to 9.81.
set DEACCELHEIGHT to 500.
set FINALAPPROACH to 100.

// Test stuff.
set testH to 1500.
print "Ascending to " + testH.
lock steering to up + R(0,45,180).
stage.
until ALT:RADAR > testH {
	lock throttle to 1.
}
lock throttle to 0.
wait 1.
stage.


print "Descent program".
print "Current velocity: " + VERTICALSPEED.
print "Current surface speed: " + SURFACESPEED.

print "Waiting for correct altitude".
until ALT:RADAR < DEACCELHEIGHT {
	lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
}.

print "Current velocity: " + VERTICALSPEED.

set I to 0.
set deactivateFlag to 0.
on AG9 set deactivateFlag to 1.

print "Braking".
print "Mass: " + mass.
set TWR to MAXTHRUST / (mass*GRAVITY).
print "TWR: " + TWR.
print "Expected Time to brake: " + mass / TWR.
set BRAKESTART to MISSIONTIME.

print "Reducing vertical speed".
until VERTICALSPEED > -20 {
//	lock steering to up.
	lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
//	set mySteer to R(0,0,0) + velocity:surface.
	lock throttle to 1.
}.

set BRAKETIME to MISSIONTIME - BRAKESTART.
print "Braking took: " + BRAKETIME.
set TargetH to ALT:RADAR.
print "Braking complete, current alt: " + TargetH.

print "Descending to FinalDescent height".
Set timepast to missiontime.
Set prefinaltime to missiontime.

until ALT:RADAR < FINALAPPROACH {
	print "waiting for final approach".
	
	until VERTICALSPEED > -20 {
		lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
		set P to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED).
		set I to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED + I).
		set thrust to P + I.
		lock throttle to thrust.
		print "pre - final approach throttle to: " + thrust.
	}.
	
	lock throttle to 0.
	set timepast to missiontime - prefinaltime.
	
	if timepast > 1 {
		set TargetH to TargetH - 20.
		set timepast to 0.
	}
}

print "FinalDescent beginning".
set DecentSpeed to 3. // desired 3ms
set LastHeight to ALT:RADAR.

until ALT:RADAR < 3 {
	set DecentStart to MISSIONTIME.
	set TargetH to ALT:RADAR - 1.
	set CurrentDecentSpeed to LastHeight -  ALT:RADAR.

	until VERTICALSPEED > -3 {
		lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
		set TWR to MAXTHRUST / (mass*GRAVITY).
		set P to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED).
		set I to 0.02*((TargetH - ALT:RADAR)-VERTICALSPEED + I).
		set thrust to 1/TWR + P + I.
		lock throttle to thrust.
		print "throttle to: " + thrust.
	}
	
	lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
	set TWR to MAXTHRUST / (mass*GRAVITY).
	set thrust to ((1/TWR)/100) * 98.
	print "throttle to 1/TWR: " + thrust.
	lock throttle to thrust.
	
	set LastHeight to ALT:RADAR.
	print "ALT:RADAR: " + ALT:RADAR.
	
}.

lock steering to R(0,0,0) + ( velocity:surface * (0-1) ).
Lock throttle to (2 * GRAVITY * mass/maxthrust).
stage.
Lock throttle to 0.
Print missiontime + " Landed.".