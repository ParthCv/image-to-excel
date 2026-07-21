# Instructions: Setup and Usage Guide

This tool turns phone photos of handwritten 10×10 freezer box forms into Excel spreadsheets. Everything runs directly on your computer, meaning patient data never leaves your machine. 

Follow these instructions to set it up for the first time and use it day-to-day.

---

## Phase 1: First-Time Setup (You only do this once)

### Step 1: Download and Install Python
Your computer needs Python to run this tool. 

**For Windows:**
1. Go to [python.org/downloads](https://www.python.org/downloads/) and click the yellow **Download Python** button.
2. Open the downloaded installer.
3. **CRITICAL STEP:** At the very bottom of the installer window, check the box that says **"Add python.exe to PATH"** (or "Add Python to environment variables"). If you miss this, the tool will not work.
4. Click **Install Now** and wait for it to finish.

**For Mac:**
1. Go to [python.org/downloads](https://www.python.org/downloads/) and click the yellow **Download Python** button.
2. Open the downloaded `.pkg` file and follow the standard installation prompts (just keep clicking Continue/Agree/Install). 

### Step 2: Install the App Dependencies
Now that Python is installed, you need to set up the tool.

1. Open the folder containing this tool.
2. **Windows:** Double-click `install_windows.bat`.
3. **Mac:** Double-click `install_mac.command`.
4. A black terminal window will open. It will take a few minutes to download the necessary text-recognition files. Once it says "Done," you can close the window.

---

## Phase 2: Day-to-Day Usage (Every time you have a photo)

### Step 1: Choose Your Run Mode
There are two ways to run the tool. Choose the one you want to use and double-click it:

* **Direct to Excel (No Review):** 
  * Windows: `run_windows.bat`
  * Mac: `run_mac.command`
  * *What it does:* Reads the image and immediately spits out the Excel file. Great if you prefer to make all your corrections directly in Excel.

* **With Review Window:** 
  * Windows: `run_windows_review.bat`
  * Mac: `run_mac_review.command`
  * *What it does:* Pauses before making the Excel file to let you check the system's "first draft" and fix misreads on the spot. 

### Step 2: Run the Photo
1. Double-click your chosen run file. 
2. A window will open saying: `Drag the photo here and press Enter:`
3. Find your form photo on your computer. Click and **drag the photo file directly into the black window**, then let go. The file path will appear.
4. Press **Enter**. The system will start reading the cells.

### Step 3: Use the Review Window (If you chose Review mode)
If you ran the `_review` version, a new window will pop up showing every written cell the system found:
* **The Layout:** You will see a small cropped image of your actual handwriting, the grid location (e.g., A1), the ID, a modifier box, a DNA/RNA dropdown, and any red "Flags" explaining why the system isn't confident.
* **Making Edits:** If the system misread an ID (like `AGM-2` as `AGK-2`), you can type the correct ID in the box, or use the dropdown to quickly select common IDs it saw elsewhere on the page.
* **Saving:** When you manually edit a cell in this window, the system trusts you and removes the warning flag. Any cells you leave untouched will keep their warning flags in the final Excel file.
* **Finish:** Click the **Save & Close** button at the bottom (or just close the window) to write your changes.

### Step 4: Find Your Excel File
1. Once the terminal window says "Done," go to the exact same folder where your original photo is saved.
2. You will find a new Excel (`.xlsx`) file sitting right next to it, with the exact same name as your photo.
3. Open the Excel file. **Any cell highlighted in AMBER needs your attention.** Hover over the amber cell with your mouse to see a comment explaining why it was flagged (e.g., "low OCR confidence" or "unexpected modifier"). 
4. Make your final checks, save the Excel file, and upload it to Drive!