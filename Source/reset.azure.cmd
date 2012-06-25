@echo off
setlocal
CD /d "%~dp0"

::Test If script has Admin Privileges/is elevated
REG QUERY "HKU\S-1-5-19"
IF %ERRORLEVEL% NEQ 0 (
    ECHO Please run this script as an administrator
    pause
    EXIT /B 1
)
cls

REM --------- Variables ---------
Set APPCMD="%systemroot%\system32\inetsrv\APPCMD"
SET powerShellDir=%WINDIR%\system32\windowspowershell\v1.0
echo.

echo.
echo ========= Setting PowerShell Execution Policy ========= 
%powerShellDir%\powershell.exe -NonInteractive -Command "Set-ExecutionPolicy unrestricted"
echo Setting Execution Policy Done!

cls
%powerShellDir%\powershell.exe -NonInteractive -command ".\tasks\reset.azure.ps1" ".\reset.azure.xml"

@pause