print "Launch Computer...".
print "Preparing to launch...". wait 1.

// Constants
set gConst to 6.67384*10^(0-11).
set e to 2.718281828459.
set atmToPres to 1.2230948554874.
set bodyMass to Body("Kerbin"):mass.
set bodyRadius to Body("Kerbin"):radius.
set bodyAtmSea to Body("Kerbin"):atm:sealevelpressure.
lock atmP to Body("Kerbin"):atm:altitudepressure(altitude).
lock atmD to atmP * 1.2230948554874. // air density calculation
lock fD to 0.5 * atmD * (AIRSPEED)^2 * cD * a. // force of drag at velocity
set cD to 0.2.
lock gravhere to gConst*bodyMass/((altitude+bodyRadius)^2).

// other
set a to 0.008 * MASS. // the area of effect for atmospheric drag.

set thrustAdjustment to 0.1.

// VARS
set orbitAltitude to 100000.
set thrust to 1.
set myheading to up + R(0,0,180).

// Set myheading and fire the engines
lock steering to myheading.
lock throttle to thrust.

LOG "a,atmP,atmD,fD,vs,ss,fuel" to ascentlog.

//SAS ON.
print "LAUNCH".

stage.
wait 0.2.
toggle AG1. // the supports

print "Wait for turn sequence".

set BOOSTERDUMP to 0.
set x to 0.
set pVal to 0.

until apoapsis > orbitAltitude {

	// calculations
	set a to 0.008 * MASS. // the area of effect for atmospheric drag.
	//set atmP to 2.718^((0-ALTITUDE)/5000). // air pressure calculation


	//set herepress to (atmToPres*bodyAtmSea) * e^((0-altitude)/bodyAtmScale).
	//set termv to sqrt( (250*gravhere)/( herepress * cD )).
	//set fdrag to 0.5*( (atmToPres*bodyAtmSea) * e^((0-altitude)/bodyAtmScale))*(velocity:surface:mag)^2*cD*0.008*mass.

	//print "herepress: " + herepress + " termv: " + termv + " fdrag: " + fdrag.
	//print "a: " + round(a,2) + " atmP: " + round(atmP,2) + " atmD: " + round(atmD,2) + " fD: " + round(fD,2).
	// round(fdrag,2) +","+
	log round(a,2) +","+ round(atmP,2) +","+ round(atmD,2) +","+ round(fD,2) +","+ round(VERTICALSPEED,2)  + "," + round(GROUNDSPEED,2) + "," + round(ship:liquidfuel,2) to ascentlog.

	// After 1000 meters, start turning
	if altitude > 1000 {
		lock pVal to -1*(1.25*(altitude/1000)+(45*(apoapsis/orbitAltitude)^2)).
	}

	//if fD > (MAXTHRUST/2)+10 {
	//	print "reducing thrust. fD: " + fD.
	//	set thrust to thrust - thrustAdjustment.
	//}

	//if fD < (MAXTHRUST/2)-10 AND THRUST <1 {
	//	print "increasing thrust. fD:" + fD.
	//	set thrust to thrust + thrustAdjustment	.
	//}

	// Keep the thrust in the sweet spot where there is no excess force
	// thrust = (maxthrust/2) / fluidDensity
	if ( fD > 0.0 ) {
		if (((MAXTHRUST/2) / fD) < 1.0) {
			set thrust to ((MAXTHRUST/2) / fD).
		}
	} else {
		print "in vacuum".
	}

	// if pitch exceeds 85, lock it there.
	if pVal > 85 { set pVal to 85. }.

	//set myheading to R(0,280+pVal,180).

	set attackAngle to steering:yaw - prograde:yaw.
	if attackAngle > 5 AND attackAngle < -5 {
		print "warning!".
	}

	//print "atk: " + round(attackAngle,1) + " pro:yaw: " + round(prograde:yaw,1) + " steer:yaw: " + round(steering:yaw,1).

	set myheading to up + R(0,pVal,180).


	//if stage:liquidfuel <1 {
	//	print "Next Stage". stage.
	//}

	if MAXTHRUST = 0 {
		print "Next Stage". stage.
	}

	// check for dead boosters
	set dumpEngines to 0.
	LIST ENGINES IN myEngines.
	FOR engine IN myEngines {
			if engine:maxthrust = 0 {
				if engine:stage = stage:number {
					print "engine fuel depleted: " + engine:name.
					set dumpEngines to 1.
				}
			}
	}

	if dumpEngines = 1 {
		print "dumping engines".
		stage.
	}

	//if stage:solidfuel < 1 AND BOOSTERDUMP = 0 {
	//	print "Next Stage". stage. set BOOSTERDUMP to 1.
	//}

	//if VERTICALSPEED > 102.9 * (1.000105*altitude) {
	//	set thrust to thrust - 0.05.
	//}

	//if VERTICALSPEED < 102.9 * (1.000105*altitude) {
	//	set thrust to thrust + 0.05.
	//}
}

log "done" to ascentlog.
set thrust to 0.
print "Target apoapsis reached.".

print "enabling SAS".
//SET SASMODE TO "PROGRADE".
//SAS ON.

//wait 5.

// lock steering to 5 degrees above prograde
set WARP to 3.
print "Waiting for circularization burn.".

until eta:apoapsis < 15 {
	//set myheading to prograde + R(0,-5,0).
	if apoapsis < (orbitAltitude + 1500) {
		set WARP to 0.
		wait 0.25.
		set thrust to 0.85.
		wait 0.25.
	}.
	set WARP to 3.
	set thrust to 0.
}.
set WARP to 0.

//PRINT "setting SAS to STABILITYASSIST".
//SET SASMODE to "STABILITYASSIST".
//SAS OFF.

print "Burn.".
set thrust to .85.
set tpa to apoapsis-2000.
set x to 0.

// Time = Delta-V / (TWR * 9.81)

print "Raising periapsis".
until (apoapsis - periapsis) < 2000 {

	//print "VERTICALSPEED: " + VERTICALSPEED.
	//set HEADINGADJUST to (360 / VERTICALSPEED) / 10.
	//print "HEADING ADJ: " + HEADINGADJUST.
	if VERTICALSPEED < -1 {
		//set myheading to prograde + R(0,5,0).
		set myheading to HEADING(90,5).
	}

	if VERTICALSPEED > 1 {
		//set myheading to prograde + R(0,-5,0).
		set myheading to HEADING(90,-5).
	}

	if MAXTHRUST = 0 {
	//if stage:liquidfuel < 1 {
		print "liquidfuel depletion, Next Stage".
		stage.
	}

	if periapsis > .9*(apoapsis-2000) AND x=0 {
		print "90% of pa".
		set thrust to (10*MASS)/MAXTHRUST.
		set x to 1.
	}

	if periapsis >.99*(apoapsis-2000) AND x = 1 {
		print "99% of pa".
		set thrust to MASS/MAXTHRUST.
	}.

	if (apoapsis - periapsis) < 2000 {
		print "100% of pa".
		set thrust to 0.
	}.
}.

set thrust to 0.
set myheading to prograde.
print "Orbit achieved".

unlock throttle.
unlock steering.
