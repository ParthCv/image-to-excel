#!/bin/bash
# ====================================================================
#  Freezer grid -> Excel.  Double-click this in Finder, or drag a photo
#  onto it. First run sets everything up (a few hundred MB, a few
#  minutes). Nothing about the photo goes online.
#
#  If double-clicking does nothing the first time, right-click ->
#  Open, or run once in Terminal:  chmod +x run_mac.command
# ====================================================================
cd "$(dirname "$0")" || exit 1

if [ ! -x ".venv/bin/python" ]; then
  echo
  echo "First-time setup. Downloading Python packages and the text"
  echo "recogniser weights. This only happens once. Please wait..."
  echo
  python3 -m venv .venv
  if [ $? -ne 0 ]; then
    echo
    echo "Could not find Python 3. Install it from https://www.python.org/downloads/"
    echo "then run this file again."
    echo
    read -r -p "Press Enter to close."
    exit 1
  fi
  source .venv/bin/activate
  pip install --upgrade pip
  pip install -r requirements.txt
  if [ $? -ne 0 ]; then
    echo
    echo "Setup failed while installing packages. Check your internet and try again."
    echo
    read -r -p "Press Enter to close."
    exit 1
  fi
else
  source .venv/bin/activate
fi

if [ -z "$1" ]; then
  read -r -p "Drag the photo into this window and press Enter: " IMG
  # strip quotes and unescape spaces that Terminal adds on drag
  IMG="${IMG%\"}"; IMG="${IMG#\"}"; IMG="${IMG//\\ / }"
else
  IMG="$1"
fi

echo
python3 main.py "$IMG"
echo
read -r -p "Press Enter to close."
