@echo off
setlocal
cd /d "%~dp0"

copy /Y "outputs\US_Sector_Q2_2026_Interactive_Dashboard_v7_3_fundamentals_v98_preview.html" "public\index.html"
git add public\index.html .gitignore .github\workflows\pages.yml publish_dashboard.bat
git commit -m "Update dashboard"
git push

pause
