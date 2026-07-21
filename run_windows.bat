@echo off
REM ====================================================================
REM  Freezer grid -> Excel.  Double-click this, or drag a photo onto it.
REM  First run sets everything up (downloads ~a few hundred MB, a few
REM  minutes). After that it's fast. Nothing about the photo goes online.
REM ====================================================================
setlocal
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
  echo.
  echo First-time setup. This downloads Python packages and the text
  echo recogniser weights. It only happens once. Please wait...
  echo.
  python -m venv .venv
  if errorlevel 1 (
    echo.
    echo Could not find Python 3. Install it from https://www.python.org/downloads/
    echo IMPORTANT: tick "Add Python to PATH" in the installer, then run this again.
    echo.
    pause
    exit /b 1
  )
  call ".venv\Scripts\activate.bat"
  python -m pip install --upgrade pip
  pip install -r requirements.txt
  if errorlevel 1 (
    echo.
    echo Setup failed while installing packages. Check your internet connection
    echo and run this file again.
    echo.
    pause
    exit /b 1
  )
) else (
  call ".venv\Scripts\activate.bat"
)

if "%~1"=="" (
  set /p IMG="Drag the photo into this window and press Enter: "
) else (
  set "IMG=%~1"
)
REM strip any surrounding quotes a drag-and-drop may add
set IMG=%IMG:"=%

echo.
python main.py "%IMG%"
echo.
pause
