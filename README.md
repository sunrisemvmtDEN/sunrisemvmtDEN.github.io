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

## Connect A Live Google Sheet Tab

1. In Google Sheets, open the tab you want to publish.
2. Click **File -> Share -> Publish to web**.
3. Choose that tab and select **Comma-separated values (.csv)**.
4. Copy the published CSV link.
5. In `_config.yaml`, set `google_sheet_csv_url` to that link.

Once committed and deployed, the homepage will render the sheet rows as a table.
