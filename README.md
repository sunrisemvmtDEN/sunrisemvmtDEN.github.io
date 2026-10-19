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
Measure blurbs can also be bullet lists (thanks Prop 137): put each item on a separate line
starting with `- ` inside the quoted CSV field. Markdown links work in each item.
Use `**bold text**` for bold and `*italic text*` for italics in blurb text.
Paragraphs can appear before, after, or between bullet lists in the same field.
Use actual line breaks, not literal `\n` text: a blank line starts a new paragraph
or list, and a single line break within a paragraph is preserved.
Edit the source CSVs in `data/`; Jekyll copies them into `_site/data/` when it
builds the site.
