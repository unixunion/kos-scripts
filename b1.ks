lock steering to UP + R(0,0,180).
lock throttle to 1.
stage.
wait 1.

set x to 1.

until 0 {
	print "altitude: " + floor(altitude) + " prograde:yaw: " + round(prograde:yaw,1) + " steering:yaw: " + round(steering:yaw,1).
	log "altitude: " + floor(altitude) +  " prograde:yaw: " + round(prograde:yaw,1) + " steering:yaw: " + round(steering:yaw,1) to mylog.
	wait 0.5.
}