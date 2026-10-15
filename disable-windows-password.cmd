@echo off
:: Turns off the Windows password prompt: auto-login at boot + no password on wake.
:: Double-click to run. It asks for admin rights by itself.

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo [1/3] Allowing password sign-in options (Windows Hello passwordless off)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion /t REG_DWORD /d 0 /f >nul

echo [2/3] No password after sleep...
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 0
powercfg /SETACTIVE SCHEME_CURRENT

echo [3/3] Downloading Microsoft Sysinternals Autologon...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol='Tls12'; Invoke-WebRequest 'https://download.sysinternals.com/files/AutoLogon.zip' -OutFile '%TEMP%\AutoLogon.zip' -UseBasicParsing; Expand-Archive '%TEMP%\AutoLogon.zip' '%TEMP%\AutoLogon' -Force"

set "EXE=%TEMP%\AutoLogon\Autologon.exe"
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "EXE=%TEMP%\AutoLogon\Autologon64.exe"
if not exist "%EXE%" (
    echo.
    echo Download failed. Check the internet connection and run this file again.
    pause
    exit /b 1
)

echo.
echo In the Autologon window: check the username, type your password, click Enable.
start "" "%EXE%" /accepteula
pause
