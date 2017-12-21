// deorbit

print "deorbit burn".


lock steering to retrograde.
wait 5.
lock throttle to 1.

until periapsis < 0 {
	if stage:liquidfuel < 1 { 
		print "Next Stage".
		lock throttle to 0. 
		stage. 
		wait 1. 
		lock throttle to 1.
	}
}.

set throttle to 0.
unlock throttle.

print "burn completed".