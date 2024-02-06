@echo off
cls

:: Comment the below line for keeping the ARP table if is desired
arp -d *

:: Starting Menu
:Menu
echo.
echo Select VM
echo 1.  Ubuntu
echo 2.  centos
echo 3.  Debian
echo.
:: It can be a longer list, depending on how many you need.

SET /P M=Type a number for choise a VM, then press ENTER: 

::End of Menu

echo.
IF %M%==1 GOTO startubuntu
IF %M%==2 GOTO startcentos
IF %M%==3 GOTO startdebian

:startubuntu
::this PATH is an example
start "" "F:\ubuntu0\ubuntu0.vbox"
::this MAC address is an example
set md="00-00-00-00-00" 
GOTO conn 

:startcentos
::this PATH is an example
start "" "F:\centos\centos.vbox"
::this MAC address is an example
set md="01-0a-0c-0d-0e"
GOTO conn

:startdebian
::this PATH is an example
start "" "F:\debian\debian.vbox"
::this MAC address is an example
set md="01-02-a0-a1-a2"
GOTO conn

:conn

:: Modify the waiting time (timeout) if wish
echo waiting for the VM to start to obtain the IP and log in via ssh (30s)...
timeout /t 30 >nul

:: Increase or decrease the IP range if want
for /L %%i in (0,1,30) do ping -f -n 1 -w 50 192.168.1.%%i -4 | findstr -m "bytes=32"

:: Filter the IP and establish the login using OpenSSH.
SETLOCAL
for /f "tokens=1" %%a in ('arp -a ^|findstr %md%') do set ipad=%%a

::Set the proper path to find the pub key
ssh -i "c:\users\<user>\.ssh\key" worker@%ipad%

ENDLOCAL

EXIT /B 0
