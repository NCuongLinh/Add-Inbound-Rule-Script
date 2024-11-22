@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

setlocal enabledelayedexpansion

:menu
cls
echo ==============================================
echo Firewall Rule Blocker
echo ==============================================
echo 1) Block inbound rules for all .exe files in the current folder
echo 2) Block inbound rules for all files in the current folder
echo 3) Block outbound rules for all .exe files in the current folder
echo 4) Block outbound rules for all files in the current folder
echo 5) Exit
echo ==============================================
set /p choice="Choose an option (1-5): "

if "%choice%"=="1" goto block_exe_inbound
if "%choice%"=="2" goto block_all_files_inbound
if "%choice%"=="3" goto block_exe_outbound
if "%choice%"=="4" goto block_all_files_outbound
if "%choice%"=="5" exit
echo Invalid choice! Please try again.
pause
goto menu

:block_exe_inbound
echo Blocking inbound rules for all .exe files in the current folder...
for %%F in (*.exe) do (
    echo Blocking inbound rule for %%F
    netsh advfirewall firewall add rule name="Block IN %%~nF" dir=in action=block program="%cd%\%%F" enable=yes
)
echo Done!
pause
goto menu

:block_all_files_inbound
echo Blocking inbound rules for all files in the current folder...
for %%F in (*) do (
    echo Blocking inbound rule for %%F
    netsh advfirewall firewall add rule name="Block IN %%~nF" dir=in action=block program="%cd%\%%F" enable=yes
)
echo Done!
pause
goto menu

:block_exe_outbound
echo Blocking outbound rules for all .exe files in the current folder...
for %%F in (*.exe) do (
    echo Blocking outbound rule for %%F
    netsh advfirewall firewall add rule name="Block OUT %%~nF" dir=out action=block program="%cd%\%%F" enable=yes
)
echo Done!
pause
goto menu

:block_all_files_outbound
echo Blocking outbound rules for all files in the current folder...
for %%F in (*) do (
    echo Blocking outbound rule for %%F
    netsh advfirewall firewall add rule name="Block OUT %%~nF" dir=out action=block program="%cd%\%%F" enable=yes
)
echo Done!
pause
goto menu