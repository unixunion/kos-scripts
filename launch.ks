print "Launch Computer...".
print "Preparing to launch...". wait 1.

// VARS
set orbitAltitude to 100000.

// Set heading and fire the engines
lock steering to up + R(0,0,180).
print "Full throttle".
lock throttle to 1.
stage.

// remember if we dumped the solid boosters or not.
// set to 1 if no dump required
set BOOSTERDUMP to 0.

//wait until altitude > 1000.

// While ascending, monitor the fuel and stage as needed.
until altitude >10000 {

		//lock pVal to -1*(1.25*(altitude/1000)+(45*(apoapsis/tAlt)^2)).
		//lock steering to up + R(0,0,180) + R(0,pVal,0).

		if stage:liquidfuel <1 { print "Next Stage". stage. }

		if stage:solidfuel < 1 AND BOOSTERDUMP = 0 {
			print "Boosters Depleted".
			stage.
			set BOOSTERDUMP to 1.
		}

		wait 0.25.
}

print "10,000m reached. begin gravity turn".
lock steering to up + R(0,0,180) + R(0,-60,0).

set BOOSTERDUMP to 0.

until apoapsis > 100200 {
	if stage:liquidfuel <1 { print "Next Stage". stage. }

	if stage:solidfuel < 1 AND BOOSTERDUMP = 0 {
		print "Boosters Depleted".
		stage.
		set BOOSTERDUMP to 1.
	}
	wait 0.25.
}

print "Target AP reached, fuel cut, re-orientating".
lock throttle to 0.
lock steering to prograde.
print "Waiting for circularization burn.".

until eta:apoapsis < 15 {
	if apoapsis < 101500 {
		lock throttle to 1.
	}.
	lock throttle to 0.
}.

print "Burn.".
lock steering to prograde + R(0,0,5).
lock throttle to 1.

until periapsis > 99500 {
	if stage:liquidfuel < 1 {
		print "Next Stage".
		lock throttle to 0.
		stage.
		wait 1.
		lock throttle to 1.
	}
}.

lock throttle to 0.
print "Orbit acheived".

unlock throttle.
unlock steering.
