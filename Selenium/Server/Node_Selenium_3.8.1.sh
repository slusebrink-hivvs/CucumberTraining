#This script is intended to be used on Mac and other ~nix environments setup to support HIVVS automated test development
#It assumes that its location is at a sibling folder of the Drivers folder containing all Selenium drivers

#!/bin/bash

#Soft fail on errors
set -e

echo Starting Selenium 3.8.1 node...

java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=4001,suspend=n -jar "selenium-server-standalone-3.8.1.jar" -role node -nodeConfig node.cfg.json -hub http://localhost:4444/grid/register > node.log 2>&1

pause