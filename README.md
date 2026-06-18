# sunrisemvmtDEN.github.io
This is a first attempt at finding a pretty way to publish the ballot guide virtually.

## Local Preview

### Quick Start
Run one of these to preview the site locally at `http://127.0.0.1:4000`:

**Windows (Batch) - Simplest:**
```batch
serve.bat
```

**PowerShell:**
```powershell
.\serve.ps1
```

The preview server includes live-reload, so changes update automatically when you edit files.

## Preferred Data Workflow

Use a checked-in CSV file for the table data.

1. Export your sheet tab as a CSV file.
2. Save it into this repo, for example as `data/ballot-guide.csv`.
3. In `_config.yaml`, set `local_csv_path` to that file path, for example `"/data/ballot-guide.csv"`.
4. Commit and push the updated CSV whenever the content changes.

This is more reliable than loading directly from Google Sheets and is usually easier to debug.

## Optional Google Sheet Source

1. In Google Sheets, open the tab you want to publish.
2. Click **File -> Share -> Publish to web**.
3. Choose that tab and select **Comma-separated values (.csv)**.
4. Copy the published CSV link.
5. In `_config.yaml`, set `google_sheet_csv_url` to that link.

If `local_csv_path` is set, the site will use that first. Otherwise it will fall back to `google_sheet_csv_url`.
