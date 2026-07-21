#!/bin/bash
cd "$(dirname "$0")"

echo "============================================================"
echo " Freezer Grid - one-time setup"
echo " This builds a local Python environment and downloads the"
echo " packages it needs. It can take a few minutes the first time."
echo "============================================================"
echo ""

python3 -m venv venv
if [ $? -ne 0 ]; then
  echo ""
  echo "ERROR: could not create the virtual environment."
  echo "Install Python 3 from https://www.python.org/downloads/ and try again."
  echo ""
  read -n1 -s -p "Press any key to close..."
  echo ""
  exit 1
fi

source venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
if [ $? -ne 0 ]; then
  echo ""
  echo "ERROR: package install failed."
  echo "Check your internet connection and run this file again."
  echo ""
  read -n1 -s -p "Press any key to close..."
  echo ""
  exit 1
fi

echo ""
echo "============================================================"
echo " Setup complete."
echo " From now on use:"
echo "   run_mac.command          (read a photo, straight to Excel)"
echo "   run_mac_review.command   (check/fix every cell first)"
echo "============================================================"
echo ""
read -n1 -s -p "Press any key to close..."
echo ""
