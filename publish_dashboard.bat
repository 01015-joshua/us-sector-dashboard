@echo off
setlocal
cd /d "%~dp0"

copy /Y "outputs\US_Sector_Q2_2026_Interactive_Dashboard_v7_3_fundamentals_v98_preview.html" "public\index.html"
git add public\index.html .gitignore .github\workflows\pages.yml publish_dashboard.bat update_dashboard_data.bat

git diff --cached --quiet
if %errorlevel%==0 (
  echo No new dashboard changes to commit.
) else (
  git commit -m "Update dashboard"
  if errorlevel 1 goto fail
)

git push origin main
if errorlevel 1 goto fail

echo.
echo Dashboard published successfully.
goto done

:fail
echo.
echo Publish failed. If the message mentions certificate or SEC_E_WRONG_PRINCIPAL, try again on a different network or run:
echo git push origin main

:done

pause
