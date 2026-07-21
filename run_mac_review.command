#!/bin/bash
cd "$(dirname "$0")"

if [ ! -f "venv/bin/activate" ]; then
  echo "Setup has not been run yet."
  echo "Please double-click install_mac.command first (one-time)."
  echo ""
  read -n1 -s -p "Press any key to close..."
  echo ""
  exit 1
fi

source venv/bin/activate

PHOTO="$1"
if [ -z "$PHOTO" ]; then
  read -e -p "Drag the photo onto this window and press Enter (or type its path): " PHOTO
fi
# un-escape backslash-spaces a drag adds, and strip surrounding quotes
PHOTO="${PHOTO//\\ / }"
PHOTO="${PHOTO%\"}"
PHOTO="${PHOTO#\"}"

if [ -z "$PHOTO" ]; then
  echo "No photo given. Nothing to do."
  echo ""
  read -n1 -s -p "Press any key to close..."
  echo ""
  exit 1
fi

python main.py "$PHOTO" --review
echo ""
read -n1 -s -p "Press any key to close..."
echo ""
