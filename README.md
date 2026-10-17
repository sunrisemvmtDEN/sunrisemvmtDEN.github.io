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

## Ballot Guide Data

The homepage loads its cards from these checked-in CSV files:

- `data/candidates_endorsed.csv`
- `data/candidates_recommended.csv`
- `data/measure_endorsed.csv`
- `data/measure_recommendation.csv`
- `data/faq.csv`

Candidate CSVs use `name,race,url,headshot,description` columns. The race is
shown above each candidate's name. Measure CSVs use
`measure title,recommendation,blurb` columns. Recommendation values are
`Endorse`, `Recommend`, `Abstain`, or `Oppose`. The FAQ CSV uses
`question,answer` columns.
Edit the source CSVs in `data/`; Jekyll copies them into `_site/data/` when it
builds the site.
