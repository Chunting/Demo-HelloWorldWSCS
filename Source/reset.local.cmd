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
SET powerShellDir=%WINDIR%\system32\windowspowershell\v1.0
echo.

echo.
echo ========= Setting PowerShell Execution Policy ========= 
%powerShellDir%\powershell.exe -NonInteractive -Command "Set-ExecutionPolicy unrestricted"
echo Setting Execution Policy Done!

IF EXIST %WINDIR%\SysWow64 (
	SET installUtilDir=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319
) ELSE (
	SET installUtilDir=%WINDIR%\Microsoft.NET\Framework\v4.0.30319
)

ECHO ========= Installing Demo Toolkit =========
CALL %powerShellDir%\powershell.exe -Command "&'.\Reset\tasks\InstallDemoToolkit.ps1'" ..\assets\DemoToolkit

ECHO.
ECHO Demo toolkit installed sucessfully...
ECHO.

ECHO ========= Installing SnapIns =========
%installUtilDir%\installutil.exe /u .\Reset\assets\DemoToolkit\DemoToolkit.Cmdlets.dll
%installUtilDir%\installutil.exe -i .\Reset\assets\DemoToolkit\DemoToolkit.Cmdlets.dll
ECHO Installing SnapIns Done!

cls
%powerShellDir%\powershell.exe -NonInteractive -command ".\Reset\reset.local.ps1" ".\Reset\reset.local.xml"

@pause