@echo off

echo Starting Selenium 3.3.1 node... With OS Detect and hostname Browser Version
set pkgpath=\\EC2AMAZ-E4IPV5P\installs\Selenium
set hub_ip_address=10.0.0.142
set node_ip_address_string="IP Address"

mkdir c:\temp

setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "6.1" (
	for /f "usebackq tokens=2 delims=:" %%f in (`netsh interface ip show addresses "Local Area Connection" ^| findstr /c:%node_ip_address_string%`) do (
		echo "%%f"
		powershell -Command "(gc Z:\Selenium\Server\node7.cfg.json) -replace '<hostname>','%COMPUTERNAME%' | Out-file c:\temp\node.json"
		
		REM  adds extra blank line to the end of file
		set LINES=1
		call:PrintFirstNLine > c:\temp\node2.json
		
		"C:\Program Files\Java\jdk1.8.0_121\bin\java" -Dwebdriver.ie.driver=%pkgpath%\Drivers\Selenium.IEDriver\3.3.0\x86\IEDriverServer.exe -Dwebdriver.gecko.driver=%pkgpath%\Drivers\Selenium.GeckoDriver\0.15\x64\geckodriver.exe -Dwebdriver.chrome.driver=%pkgpath%\Drivers\Selenium.ChromeDriver\2.33\x86\chromedriver.exe -jar "%pkgpath%\Server\selenium-server-standalone-3.8.1.jar" -role node -nodeConfig C:\temp\node2.json -host %%f -hub http://%hub_ip_address%:4444/grid/register
		
	)
)
if "%version%" == "10.0" (
	for /f "usebackq tokens=2 delims=:" %%f in (`netsh interface ip show addresses "Ethernet 3" ^| findstr /c:%node_ip_address_string%`) do (
		echo "%%f"
		copy Z:\Selenium\Server\node10.cfg.json C:\temp\node.org.json
		powershell -Command "(gc Z:\Selenium\Server\node10.cfg.json) -replace '<hostname>','%COMPUTERNAME%' | Out-file c:\temp\node.json"
		
		REM  adds extra blank line to the end of file
		set LINES=1
		call:PrintFirstNLine > c:\temp\node2.json
		
		"C:\Program Files\Java\jdk1.8.0_121\bin\java" -Dwebdriver.ie.driver=%pkgpath%\Drivers\Selenium.IEDriver\3.3.0\x86\IEDriverServer.exe -Dwebdriver.gecko.driver=%pkgpath%\Drivers\Selenium.GeckoDriver\0.15\x64\geckodriver.exe -Dwebdriver.chrome.driver=%pkgpath%\Drivers\Selenium.ChromeDriver\2.33\x86\chromedriver.exe -jar "%pkgpath%\Server\selenium-server-standalone-3.8.1.jar" -role node -nodeConfig C:\temp\node2.json -host %%f -hub http://%hub_ip_address%:4444/grid/register
		
	)
)
rem etc etc
endlocal

goto EOF

:PrintFirstNLine
set cur=0
for /F "tokens=1* delims=]" %%I in ('type "c:\temp\node.json" ^| find /V /N ""') do (
   if "%%J"=="" (echo.) else (
        echo.%%J
        set /a cur=cur+1    
        )  

   if "!cur!"=="%LINES%" goto EOF
)

:EOF