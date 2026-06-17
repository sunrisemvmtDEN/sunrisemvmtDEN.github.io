---
layout: default
title: 2026 Ballot Guide
---

<style>
  :root {
    --sunrise-gold: #ffde16;
    --sunrise-charcoal: #33342e;
    --sunrise-sage: #e3eddf;
    --sunrise-orange: #fd9014;
    --sunrise-maroon: #8f0d56;

    --bg: var(--sunrise-sage);
    --ink: var(--sunrise-charcoal);
    --muted: #5d6258;
    --line: #c9d5c3;
    --accent: var(--sunrise-orange);
    --accent-soft: #f9f1bc;
    --accent-strong: var(--sunrise-maroon);
    --gold-light: var(--sunrise-gold);
  }

  body {
    background:
      radial-gradient(circle at top right, rgba(255, 222, 22, 0.26) 0%, transparent 30%),
      radial-gradient(circle at bottom left, rgba(253, 144, 20, 0.12) 0%, transparent 35%),
      linear-gradient(180deg, #f7fbf3 0%, var(--bg) 55%, #eef5e8 100%);
    color: var(--ink);
  }

  .sheet-wrap {
    margin-top: 1rem;
  }

  .sheet-note {
    color: var(--muted);
    font-size: 0.95rem;
    margin-bottom: 0.8rem;
  }

  .sheet-status {
    padding: 0.65rem 0.8rem;
    background: linear-gradient(90deg, var(--accent-soft), #ffffff);
    border-left: 4px solid var(--accent-strong);
    border-radius: 6px;
    margin-bottom: 0.8rem;
  }

  .table-shell {
    border: 1px solid var(--line);
    border-radius: 10px;
    overflow: auto;
    background: rgba(255, 252, 247, 0.9);
    box-shadow: 0 8px 24px rgba(25, 45, 35, 0.08);
  }

  table {
    width: 100%;
    border-collapse: collapse;
    min-width: 720px;
  }

  thead {
    position: sticky;
    top: 0;
    z-index: 1;
  }

  th,
  td {
    padding: 0.72rem 0.7rem;
    border-bottom: 1px solid var(--line);
    vertical-align: top;
    text-align: left;
    line-height: 1.35;
  }

  th {
    background: linear-gradient(180deg, var(--gold-light), #f4ca00);
    color: var(--sunrise-charcoal);
    font-weight: 600;
    letter-spacing: 0.01em;
  }

  tbody tr:nth-child(even) {
    background: #f8fbf5;
  }

  tbody tr:hover {
    background: #fff0b8;
  }

  @media (max-width: 740px) {
    .sheet-note {
      font-size: 0.9rem;
    }

    th,
    td {
      padding: 0.6rem;
    }
  }
</style>

## Live Candidate Responses

<p class="sheet-note">
This table is loaded live from Google Sheets. Update the sheet and this page updates automatically.
</p>

<div class="sheet-wrap">
  <div id="sheet-status" class="sheet-status">Loading latest data...</div>
  <div class="table-shell">
    <table id="sheet-table" aria-label="Candidate responses table"></table>
  </div>
</div>

<script>
  const csvUrl = "{{ site.google_sheet_csv_url | escape }}";

  function parseCsv(text) {
    const rows = [];
    let row = [];
    let value = "";
    let inQuotes = false;

    for (let i = 0; i < text.length; i += 1) {
      const ch = text[i];
      const next = text[i + 1];

      if (ch === '"') {
        if (inQuotes && next === '"') {
          value += '"';
          i += 1;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (ch === "," && !inQuotes) {
        row.push(value.trim());
        value = "";
      } else if ((ch === "\n" || ch === "\r") && !inQuotes) {
        if (ch === "\r" && next === "\n") {
          i += 1;
        }
        row.push(value.trim());
        value = "";
        if (row.some((cell) => cell !== "")) {
          rows.push(row);
        }
        row = [];
      } else {
        value += ch;
      }
    }

    if (value.length > 0 || row.length > 0) {
      row.push(value.trim());
      if (row.some((cell) => cell !== "")) {
        rows.push(row);
      }
    }

    return rows;
  }

  function buildTable(rows) {
    const table = document.getElementById("sheet-table");
    const status = document.getElementById("sheet-status");

    if (!rows.length) {
      status.textContent = "No data found in the selected Google Sheet tab.";
      return;
    }

    const headers = rows[0];
    const bodyRows = rows.slice(1);

    const headHtml = `
      <thead>
        <tr>${headers.map((h) => `<th>${h || ""}</th>`).join("")}</tr>
      </thead>
    `;

    const bodyHtml = `
      <tbody>
        ${bodyRows
          .map((r) => `<tr>${headers.map((_, i) => `<td>${r[i] || ""}</td>`).join("")}</tr>`)
          .join("")}
      </tbody>
    `;

    table.innerHTML = headHtml + bodyHtml;
    status.textContent = `Showing ${bodyRows.length} row${bodyRows.length === 1 ? "" : "s"}.`;
  }

  async function loadSheet() {
    const status = document.getElementById("sheet-status");

    if (!csvUrl) {
      status.textContent = "Set google_sheet_csv_url in _config.yaml to your published Google Sheet CSV link.";
      return;
    }

    try {
      const res = await fetch(csvUrl, { cache: "no-store" });
      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }
      const csvText = await res.text();
      const rows = parseCsv(csvText);
      buildTable(rows);
    } catch (err) {
      status.textContent = `Could not load Google Sheet data (${err.message}). Confirm the tab is published and the URL is a CSV publish link.`;
    }
  }

  loadSheet();
</script>