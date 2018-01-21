#This script is intended to be used on Mac and other ~nix environments setup to support HIVVS automated test development
#It assumes that its location is in the same folder as the server standalone

#!/bin/bash

#Soft fail on errors
set -e

echo Starting Selenium 3.8.1 hub...

java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=4000,suspend=n -jar "selenium-server-standalone-3.8.1.jar" -role hub -hubConfig hub.cfg.json > hub.log 2>&1

exit 0