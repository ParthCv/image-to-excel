@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo  Image to Excel - one-time setup
echo  This builds a local Python environment and downloads the
echo  packages it needs. It can take a few minutes the first time.
echo ============================================================
echo.

python -m venv venv
if errorlevel 1 (
  echo.
  echo ERROR: could not create the virtual environment.
  echo Make sure Python 3 is installed and ticked "Add to PATH".
  echo Get it from https://www.python.org/downloads/
  echo.
  pause
  exit /b 1
)

call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
  echo.
  echo ERROR: package install failed.
  echo Check your internet connection and run this file again.
  echo.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  Setup complete.
echo  From now on use:
echo    run_windows.bat          (read a photo, straight to Excel)
echo    run_windows_review.bat   (check/fix every cell first)
echo ============================================================
echo.
pause
