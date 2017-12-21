//blackbox.txt

set rtime to MISSIONTIME .
lock TRUESPEED to SQRT((VERTICALSPEED^2)+(SURFACESPEED^2)) .
lock steering to RETROGRADE .

log "Time,Alt,Verticalspeed,Surfacespeed,Totalspeed" to descentlog.

until ALT:RADAR < 1000 {
	print FLOOR(MISSIONTIME - rtime) + "," + FLOOR(VERTICALSPEED) + "," + FLOOR(SURFACESPEED) + "," + FLOOR(TRUESPEED) .
	log FLOOR(MISSIONTIME - rtime) + "," + ALTITUDE + "," + FLOOR(VERTICALSPEED) + "," + FLOOR(SURFACESPEED) + "," + FLOOR(TRUESPEED) to descentlog.
 	wait 2.
 }.

toggle AG2.

run simpledescent.
