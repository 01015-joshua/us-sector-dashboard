@echo off
setlocal
cd /d "%~dp0"
set "RESULT=1"
set "APP_HOME=%~dp0"
set "GIT_EXE=git"
set "BUNDLED_GIT=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git"
if exist "%BUNDLED_GIT%\cmd\git.exe" (
  set "GIT_EXE=%BUNDLED_GIT%\cmd\git.exe"
  set "GIT_EXEC_PATH=%BUNDLED_GIT%\mingw64\bin"
)
set "GIT_CONFIG_COUNT=2"
set "GIT_CONFIG_KEY_0=safe.directory"
set "GIT_CONFIG_VALUE_0=%CD%"
set "GIT_CONFIG_KEY_1=http.sslBackend"
set "GIT_CONFIG_VALUE_1=openssl"
set "PREVIEW=outputs\US_Sector_Q2_2026_Interactive_Dashboard_v7_3_fundamentals_v98_preview.html"

"%GIT_EXE%" --version >nul 2>&1
if errorlevel 1 (
  echo ERROR: Git is unavailable.
  goto done
)
if not exist ".git\HEAD" (
  echo ERROR: This project is missing its Git repository. Restore origin/main first.
  goto done
)
if not exist "%PREVIEW%" (
  echo ERROR: Generated dashboard not found. Run update_dashboard_data.bat first.
  goto done
)
set "CURRENT_BRANCH="
for /f "delims=" %%B in ('"%GIT_EXE%" symbolic-ref --short HEAD') do set "CURRENT_BRANCH=%%B"
if not "%CURRENT_BRANCH%"=="main" (
  echo ERROR: Publishing requires the main branch.
  goto done
)
"%GIT_EXE%" config --get user.name >nul
if errorlevel 1 (
  echo ERROR: Set your Git user.name before publishing.
  goto done
)
"%GIT_EXE%" config --get user.email >nul
if errorlevel 1 (
  echo ERROR: Set your Git user.email before publishing.
  goto done
)
echo Checking GitHub connection and main branch...
"%GIT_EXE%" fetch origin main
if errorlevel 1 goto fail
"%GIT_EXE%" merge-base --is-ancestor origin/main HEAD
if errorlevel 1 (
  echo ERROR: GitHub has newer commits. Reconcile changes before publishing.
  goto done
)
if /i "%~1"=="--check" (
  "%GIT_EXE%" push --dry-run origin main
  if errorlevel 1 goto fail
  echo Publish checks passed. Nothing was committed or uploaded.
  set "RESULT=0"
  goto done
)
copy /Y "%PREVIEW%" "public\index.html"
if errorlevel 1 goto fail
"%GIT_EXE%" add -- public/index.html .gitignore .github/workflows/pages.yml publish_dashboard.bat update_dashboard_data.bat
if errorlevel 1 goto fail
"%GIT_EXE%" diff --cached --quiet -- public/index.html .gitignore .github/workflows/pages.yml publish_dashboard.bat update_dashboard_data.bat
if errorlevel 2 goto fail
if errorlevel 1 (
  "%GIT_EXE%" commit --only -m "Update dashboard" -- public/index.html .gitignore .github/workflows/pages.yml publish_dashboard.bat update_dashboard_data.bat
  if errorlevel 1 goto fail
) else (
  echo No new dashboard changes to commit.
)
"%GIT_EXE%" push origin main
if errorlevel 1 goto fail
echo.
echo Dashboard uploaded to GitHub. GitHub Pages deployment may take a few minutes.
echo https://01015-joshua.github.io/us-sector-dashboard/
set "RESULT=0"
goto done

:fail
echo.
echo Publish failed. Read the error above.
echo If authentication failed, sign in to GitHub and retry. Your local dashboard is retained.

:done
if not "%DASHBOARD_NO_PAUSE%"=="1" pause
endlocal & exit /b %RESULT%
