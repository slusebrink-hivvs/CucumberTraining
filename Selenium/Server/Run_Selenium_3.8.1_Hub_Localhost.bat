@echo off

echo Starting Selenium 3.8.1 hub...

java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=4000,suspend=n -jar "selenium-server-standalone-3.8.1.jar" -role hub -hubConfig hub.cfg.json > hub.log 2>&1
