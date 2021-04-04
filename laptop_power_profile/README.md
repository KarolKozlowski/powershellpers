# Laptop power profile

Script for changing standby timeout for a docked laptop.
It runs periodically from the task scheduler (~15 minutes) and checks if a peer host is up:
 - if it is it sets the online timeout to 0 (disabled)
 - if not then sets the timeout to 15 minutes
(which will put to sleep this host if its peer is unaccessible)



