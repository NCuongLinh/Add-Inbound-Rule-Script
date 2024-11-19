@echo off
setlocal enabledelayedexpansion

:menu
cls
echo ==============================================
echo Firewall Rule Adder
echo ==============================================
echo 1) Add firewall rules for all files in the current folder
echo 2) Add firewall rules for all .exe files in the current folder
echo 3) Exit
echo ==============================================
set /p choice="Choose an option (1-3): "

if "%choice%"=="1" goto add_all_files
if "%choice%"=="2" goto add_exe_files
if "%choice%"=="3" exit
echo Invalid choice! Please try again.
pause
goto menu

:add_all_files
echo Adding firewall rules for all files in the current folder...
for %%F in (*) do (
    echo Adding firewall rule for %%F
    netsh advfirewall firewall add rule name="Allow %%~nF" dir=in action=allow program="%cd%\%%F" enable=yes
)
echo Done!
pause
goto menu

:add_exe_files
echo Adding firewall rules for all .exe files in the current folder...
for %%F in (*.exe) do (
    echo Adding firewall rule for %%F
    netsh advfirewall firewall add rule name="Allow %%~nF" dir=in action=allow program="%cd%\%%F" enable=yes
)
echo Done!
pause
goto menu