@echo off

echo Starting Selenium 3.8.1 node...

set pkgpath=..\Drivers
set hub_ip_address=localhost
set node_ip_address_string="IPv4 Address"

for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%node_ip_address_string%`) do (
	java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=4001,suspend=n -Dwebdriver.ie.driver=%pkgpath%\Selenium.IEDriver\3.8\x86\IEDriverServer.exe -Dwebdriver.gecko.driver=%pkgpath%\Selenium.GeckoDriver\0.19.1\x64\geckodriver.exe -Dwebdriver.chrome.driver=%pkgpath%\Selenium.ChromeDriver\2.33\x32\chromedriver.exe -jar "selenium-server-standalone-3.8.1.jar" -role node -nodeConfig node.cfg.json -host %%f -hub http://%hub_ip_address%:4444/grid/register > node.log 2>&1
)