set throttle to 1.
stage.
ADD NODE(TIME:SECONDS +10, 0, 0, (0-1) * VERTICALSPEED ).

until ALT:RADAR > 500 {
	print "waiting".
}.

