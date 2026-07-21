@echo off
setlocal
cd /d "%~dp0"

if not exist "venv\Scripts\activate.bat" (
  echo Setup has not been run yet.
  echo Please double-click install_windows.bat first ^(one-time^).
  echo.
  pause
  exit /b 1
)

call venv\Scripts\activate.bat

set "PHOTO=%~1"
if "%PHOTO%"=="" (
  set /p PHOTO=Drag the photo onto this window and press Enter ^(or type its path^): 
)
REM strip any quotes a dragged path may have added
set "PHOTO=%PHOTO:"=%"

if "%PHOTO%"=="" (
  echo No photo given. Nothing to do.
  echo.
  pause
  exit /b 1
)

python main.py "%PHOTO%" --review
echo.
pause
