@echo off
setlocal
cd /d "%~dp0"

set "APP_HOME=%~dp0"
set "ENGINE_DIR=%APP_HOME%engine"
set "DASHBOARD_ROOT=%APP_HOME%"
set "DASHBOARD_OUTPUT_DIR=%APP_HOME%outputs"
set "PYTHONUTF8=1"
set "PYTHON_EXE=%APP_HOME%.venv\Scripts\python.exe"
if not exist "%PYTHON_EXE%" (
  echo Missing project Python environment. Install blpapi in .venv first.
  exit /b 1
)

echo Updating dashboard data...
echo.

cd /d "%ENGINE_DIR%"
"%PYTHON_EXE%" "refresh_macro_fred_data.py"
if errorlevel 1 goto fail
"%PYTHON_EXE%" "refresh_macro_contributions.py"
if errorlevel 1 goto fail
"%PYTHON_EXE%" "refresh_technical_data.py"
if errorlevel 1 goto fail
"%PYTHON_EXE%" "refresh_breadth_data.py"
if errorlevel 1 goto fail
"%PYTHON_EXE%" "refresh_fear_greed_data.py"
if errorlevel 1 goto fail
"%PYTHON_EXE%" "build_nonmacro_fixed.py"
if errorlevel 1 goto fail

cd /d "%APP_HOME%"
copy /Y "outputs\US_Sector_Q2_2026_Interactive_Dashboard_v7_3_fundamentals_v98_preview.html" "public\index.html"
if errorlevel 1 goto fail

echo.
echo Dashboard data updated. public\index.html is ready for review.
echo If everything looks OK, run publish_dashboard.bat.
set "RESULT=0"
goto done

:fail
set "RESULT=1"
echo.
echo Update failed. Check the message above, or open logs if this was run from the dashboard button.

:done
if not "%DASHBOARD_NO_PAUSE%"=="1" pause
endlocal & exit /b %RESULT%
