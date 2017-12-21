// mk1 mission control file.

print "mk1 mission".

copy l2 from archive. run l2. wait 1.

print "cleaning files".
delete l2. delete ascentlog.

print "raising antenna".
toggle AG2. wait 2.
print "getting files".
copy deorbit from archive.
copy simpledescent from archive.
copy bb from archive.
toggle AG2.
print "RTS".
run deorbit. delete deorbit.
run simpledescent.