@echo off
setlocal

set "DASHBOARD_URL=https://raw.githubusercontent.com/01015-joshua/us-sector-dashboard/main/public/index.html"
set "TARGET_DIR=%USERPROFILE%\Documents\US_Sector_Dashboard"
set "TARGET_FILE=%TARGET_DIR%\index.html"

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Downloading latest dashboard...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DASHBOARD_URL%' -OutFile '%TARGET_FILE%' -UseBasicParsing"

if errorlevel 1 (
  echo.
  echo Download failed. Please check GitHub access and network connection.
  pause
  exit /b 1
)

echo.
echo Saved to:
echo %TARGET_FILE%
echo.

set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%CHROME%" (
  start "" "%CHROME%" "%TARGET_FILE%"
) else (
  set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  if exist "%CHROME%" (
    start "" "%CHROME%" "%TARGET_FILE%"
  ) else (
    start "" "%TARGET_FILE%"
  )
)

endlocal
