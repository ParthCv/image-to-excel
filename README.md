# Image to Excel

Turns a phone photo of a handwritten 10×10 form into an `.xlsx` you
check and upload to Drive. One photo - one spreadsheet.

The image is read **entirely on this machine**. Nothing about the photo is ever
sent anywhere. (The one model it uses, EasyOCR, downloads its weights once on the
first run and then runs locally — including with the internet off.)

---

## For the person running it (no setup knowledge needed)

1. Put your photo somewhere easy to find.
2. **Windows:** double-click `run_windows.bat`. **Mac:** double-click `run_mac.command`.
   - You can also just **drag the photo onto that file** to skip the prompt.
3. The **first time only**, it spends a few minutes installing itself. After that
   it's quick.
4. When it says "Drag the photo here and press Enter," do that (or type the path).
5. It writes an Excel file **next to your photo** with the same name.
6. **Open the Excel file and check any cell highlighted amber.** Hover over an
   amber cell to see why it was flagged. Fix anything wrong, then upload to Drive.

### If it refuses

Sometimes it will say it **can't read the grid** and writes nothing. That's on
purpose — a wrong spreadsheet is worse than none. Almost always it's the photo.
Retake it and it'll work:

- Shoot at a **slight angle**, not straight down. (Straight-on shots wash out one
  edge and lose grid lines — this is the single most common cause.)
- Fill the frame with the form.
- Even lighting, no glare, whole form visible.

---

## What the amber flags mean

Every automated check only **raises a flag** — the tool never silently changes a
reading. A cell is highlighted when something looks off:

- the ID doesn't fit the `AAA-####` pattern (e.g. `AG-2`)
- no clear `DNA`/`RNA` line
- the recogniser wasn't confident
- ink level was borderline (blank, or a very faint entry?)
- an ID appears once but is one character off an ID that appears several times
  (aliquots are usually written in runs, so this is often a misread — **often, not
  always**; you decide)

Empty positions are written as the literal text `(blank)`.

---

## For the developer (handoff notes)

Single file: **`main.py`**. No package, no modules to wire up. Sections inside are
labelled 1–7.

### Pipeline

```
photo.jpg
  - detect_grid()      OpenCV only: downscale - find table - perspective-warp -
                       tight-crop to ruled area - find rule lines - REFUSE if the
                       grid isn't a clean 10×10 with low spacing-cv
  - extract_cells()    100 crops; blank/written/uncertain decided by ink fraction
                       BEFORE any OCR runs
  - Recognizer         EasyOCR (lazy torch import), 2× upscaled crop, allowlist-
                       constrained to A–Z 0–9 - . space
  - assemble_cell()    lines - Cell(id, modifier, type); structural flags only
  - vocab_flags()      run-length / Levenshtein neighbour check; flag only
  - write_xlsx()       matches example.xlsx; amber fill + comment on flagged cells
```

180° rotation is handled: if the upright read yields few valid IDs, it re-reads
rotated and keeps whichever orientation produces more `AAA-####` matches.

### Grid detection — validated on the 5 supplied photos

| photo | result |
|-------|--------|
| 1, 2, 3 (page A; incl. upside-down, desk-in-frame) | 10×10 ✓ |
| 5 (page B, angled) | 10×10 ✓ |
| 4, 6 (same straight-on shot, washed-out right edge) | resolves to 10×7 - **correctly refused** |

Key decision baked into the guard: the ruled grid is **pre-printed and always
10×10** — empty cells are still ruled cells. So *any* detection that isn't 10×10 is
a detection failure, never a genuinely smaller grid. `detect_grid()` refuses in that
case rather than emit a short sheet. This is the geometry-only defence against a
"dropped column"; it costs nothing and never rejects a valid grid. If a site ever
uses a different fixed size, change `EXPECTED_ROWS/COLS` at the top of `main.py`.

Everything above the OCR line was tested end-to-end against the real photos.

### The one thing still unvalidated: OCR accuracy

EasyOCR was **not run** during development (no offline weights available in that
environment), so per-character accuracy on these block-capital codes is unmeasured —
same open question as the old TrOCR plan, but with a recogniser that actually fits
printed/block text instead of cursive IAM. First real task on a live machine is the
go/no-go:

- Run it on `3.jpg`, open the sheet, and compare against the paper.
- What matters is **silent errors** (confident-and-wrong, unflagged), not raw
  accuracy. 85% with every miss flagged is usable; 95% with a few silent misses is
  not.
- If accuracy is poor, the tuning knobs are all constants at the top of `main.py`
  (`OCR_CONF_FLAG`, ink thresholds, allowlist). If it's *badly* off on the codes,
  the fallback in the original handoff (glyph clustering, human labels each glyph
  once) still stands and needs no model at all.

### Config knobs (top of `main.py`)

`EXPECTED_ROWS/COLS`, `GRID_TOLERANCE`, `MAX_SPACING_CV`, `WORK_RES`,
`INK_BLANK_MAX`, `INK_WRITTEN_MIN`, `OCR_ALLOWLIST`, `OCR_CONF_FLAG`, `ID_RE`,
`TYPES`, `MODIFIER_RE`.

### xlsx format note

Matches `example.xlsx`: value `"ID\nTYPE"` in one cell (modifier joins the ID line
with a space, e.g. `"PRC-14 MB-CP\nDNA"`), empty = `"(blank)"`, Arial bold centered,
10 columns, no header row. One deliberate addition: `wrap_text=True`, so the newline
actually displays as two lines in Excel. Same stored value, just visible.

### Not yet done (from the original TODO)

- `Freezer:` / `Rack:` metadata at the page bottom isn't parsed — only used to name
  the output file if you wire it in.
- No `pyproject.toml`. Not needed with the launcher approach; the `.bat`/`.command`
  build a venv and `pip install -r requirements.txt`.

### If you want a true single-file `.exe` / `.app` later

The launchers install Python + deps into a local `.venv` — that's the simplest
"double-click" that also stays small. For a self-contained binary the operator can
run with no Python at all:

```
pip install pyinstaller
pyinstaller --onefile --name freezer_grid main.py
```

Expect a large binary (~2 GB, mostly torch) and build it **on the target OS**
(PyInstaller doesn't cross-compile — build the Windows exe on Windows, the Mac app
on macOS).
