clearscreen.
sas off. // Ensures SAS is OFF.

//**User Set variables.

set tOrbit to 100000.          // Sets Default Target Orbit.
set tHeading to 90.            // Sets your launch heading. Usage:0-360. 0=North.
set rpAlt to 1000.             // Sets the altitude at which to preform an initial roll.
set rProgram to -90.           // Sets the roll target. Engages at rpAlt. Usage:0-360. 180=VAB default.

set throttleLimit to 1.        // Engages throttle limits below turn1.
set tTWR to 2.                 // Sets the max TWR while throttle limited.

set Count to 0.                // Sets the number of asparagus stages.
set aspFuel to 0.              // Sets the amount of fuel in one aparagus stage.


//**Internal variables.

set yaw to 90 + tHeading.                            // Internal var to match heading to NavBall
set pitch to 90.                                     // Sets your inital pitch via heading. Usage:0-360 90=Up.
set roll to 180.                                     // Sets your inital roll. Usage:0-360. 180=VAB Default.
set x to 0.                                          // Internal var for angle calculation.
set y to 0.                                          // Internal var for angle calculation.
set z to 0.                                          // Internal var for angle calculation.
set tThr to 1.                                       // Sets throttle at lift off.
lock steering to up + R(0,0,roll) + V(x,y,z).        // Locks steering to calculated vector plus roll.
lock throttle to tThr.                               // Locks throttle to var tThr.
set orbit to 0.                                      // Sets the main loop close condition.
set hAtmo to 69500.                                  // Sets the altitude of atmosohere of Kerbin. Unit:Meters.
set turn1 to 9999.                                   // Sets the altitude of the first down range turn. Unit:Meters
set turn2 to 14999.                                  // " " Unit:Meters
set turn3 to 19999.                                  // " " Unit:Meters
set turn4 to 24999.                                  // " " Unit:Meters
set turn5 to 49999.                                  // " " Unit:Meters
set end to 0.                                        // Internal var for UI.
set bitMask to "          ".                         // Internal var for UI.
set printflag to 1.                                  // Internal var for UI.
if ag9 = "True" { toggle ag9. }.                     // Internal var for UI.
if ag8 = "True" { toggle ag8. }.                     // Internal var for UI.
if ag7 = "True" { toggle ag7. }.                     // Internal var for UI.
set TWR to (maxthrust/(mass*9.81)).                  // Preliminary TWR set.

//**Abort Procedure.
// Usage: AG2 decople/fire escape motors. AG3 decouple tower/trigger parachute.
on abort { toggle ag2. wait until verticalspeed < 0. toggle ag3. }.


//**UI Section.

until end = 1
 {
 if ag9 = "True" { set tOrbit to tOrbit + 10000. set printflag to 1. toggle ag9. }.
 if ag8 = "True" { set tOrbit to tOrbit - 10000. set printflag to 1. toggle ag8. }.
 if tOrbit < 80000 { set tOrbit to 80000. }.
 if tOrbit > 650000 { set tOrbit to 650000. }.
 if ag7 = "True"
  {
  clearscreen.
  print "You have confirmed " + tOrbit + "m" at (0,1).
  print "Lift Off in 5s." at (0,3).
  toggle ag7.
  wait 2.
  set end to 1.
  }.

 if printflag = 1
  {
  clearscreen.
  print "Select your orbit altitude." at (0,0).
  print "--------------------------------" at (0,1).
  print "Use action group 9 to add 10Km to orbit alt." at (0,3).
  print "Use action group 8 to remove 10Km from orbit alt." at (0,5).
  print "Use action group 7 to confirm orbit alt." at (0,7).
  print "You have selected " + tOrbit + "m" at (0,9).
  set printflag to 0.
  }.
 }.


//**Throttle limit section.
//**Learned a new way to lock TWR that is faster and doesn't need to be in the loop.
//**Thanks to KSP forum member Check for this better method.

if throttleLimit = 1
 {
 lock throttle to (tTWR * 9.81 * mass / maxthrust).
 when altitude > turn1 then
  { set throttleLimit to 0. lock throttle to tThr. }.
 }.


//**Values based on UI.

set xAlt to tOrbit - 100.                 // Primary M.E.C.O. Condition. Usage:xAlt=tOrbit-Meters.
set xOrbit to tOrbit + 5000.              // Secondary M.E.C.O. Condition. Usage:xOrbit=tOrbit+Meters.
set cAlt to (tOrbit - (tOrbit*.01)).      // Internal var for near MECO throttle limit. Usage:cAlt=tOrbit-5%.
set hAlt to tOrbit - 5.                   // Internal var for apoaps hold. Usage:hAlt=tOrbit-Meters.


//**Begin Countdown.

clearscreen.
print "Orbit altitude set to " + tOrbit + "m".
print "3". wait 1.
print "2". wait 1.
print "1". wait 1.
clearscreen.
print "Lift Off! Target Heading set to " + tHeading + "Deg". stage.

set StartFuel to <liquidfuel>. // Internal var for initial Total Liquid Fuel.


//**G-turn Section.

when altitude > rpAlt then set roll to rProgram.
when altitude > turn1 then set pitch to 60.
when altitude > turn2 then set pitch to 50.
when altitude > turn3 then set pitch to 30.
when altitude > turn4 then set pitch to 15.
when apoapsis > turn5 then set pitch to 0.


//**Orbit Injection control. Alter at your own risk.

when apoapsis > tOrbit then
 {
 set tThr to 0.
 toggle ag5.
 until altitude > hAtmo
  {
  if apoapsis < hAlt { set tThr to .1. }.
  if apoapsis > tOrbit { set tThr to 0. }.
  }.
 }.
when altitude > 70200 then
 {
 set Gk to 3.5316000*10^12.
 set Radius to 600000 + apoapsis.
 set sma to 600000 + ((periapsis+apoapsis)/2).
 set V1 to (Gk/Radius)^.5.
 set V2 to (Gk*((2/Radius)-(1/sma)))^.5.
 set dV to abs(V1-V2).
 set acceleration to (maxthrust/mass).
 set burnTime to (dV/acceleration).
 set tTime to (burnTime/2).
 set warp to 3.
 when eta:apoapsis < (120 + tTime) then set warp to 2.
 when eta:apoapsis < (60 + tTime) then
  { set warp to 0. wait 1. lock steering to prograde. }.
 when eta:apoapsis < tTime then set tThr to 1.
 when periapsis > cAlt then set tThr to .1.
 when periapsis > xAlt OR apoapsis > xOrbit then
  {
  set tThr to 0.
  sas on.
  clearscreen.
  print "You Are Now In Orbit".
  set orbit to 1.
  }.
 }.
 
 
//**Main Control loop. Alter at your own risk.

until orbit = 1
 {
 set x to cos(yaw) * cos(pitch).
 set y to sin(yaw) * cos(pitch).
 set z to sin(pitch).
 set StageSolid to stage:solidfuel.
 set StageLiquid to stage:liquidfuel.
 set Lfuel to <liquidfuel>.
 set TWR to maxthrust / (mass*9.81).
 if throttle < 1 { set cTWR to (TWR*throttle). }.
 if throttle > 1 OR throttle = 1 { set cTWR to TWR. }.
 print "Heading  " + heading + bitMask at (0,3).
 print "Max Surface TWR " + TWR + bitMask at (0,5).
 print "Current TWR " + cTWR + bitMask at (0,7).
 print "ETA:Apoapsis  " + eta:apoapsis + bitMask at (0,9).
 print "MaxThrust " + maxthrust + "kN" + bitMask at (0,11).

 if Lfuel < (StartFuel - aspFuel) AND Count > 0
  { stage. set StartFuel to (StartFuel-aspFuel). set Count to Count - 1. }.

 if StageSolid < 1 AND StageSolid > 0
  { stage. }.

 if StageLiquid = 0 AND StageSolid = 0
  { if Lfuel > 0 { stage. wait 1. }. }.
 }.

//**End program orbital condition print out. Extend solar pannels on AG1.

lock throttle to 0.
wait 1.
toggle ag1.
print " ".
print "Apoapsis is " + apoapsis + "m".
print " ".
print "Periapsis is " + periapsis + "m".
print " ".
print "Orbital Eccentricity is " +
(((apoapsis + 600000)-(periapsis + 600000))/((apoapsis + 600000)+(periapsis + 600000))).
print " ".
wait 2.