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
    Candidate names open a profile page with additional details. Scroll horizontally to view all policy response columns.
    margin-bottom: 0.8rem;
  }

  .sheet-status {
        overflow-x: auto;
        overflow-y: hidden;
    background: linear-gradient(90deg, var(--accent-soft), #ffffff);
    border-left: 4px solid var(--accent-strong);
    border-radius: 6px;
    margin-bottom: 0.8rem;
  }
        width: max-content;
        min-width: 1700px;
  .table-shell {
    border: 1px solid var(--line);
    border-radius: 10px;
    overflow: auto;
        word-wrap: break-word;
        word-break: normal;
        overflow-wrap: break-word;
        min-width: 13rem;
        max-width: 22rem;

  table {
    width: 100%;
    border-collapse: collapse;
  }


      .candidate-link {
        color: #0b57d0;
        font-weight: 700;
        text-decoration: underline;
        text-underline-offset: 2px;
      }

      .candidate-link:hover {
        color: #083b8f;
      }
  thead {
    position: sticky;
    top: 0;
    z-index: 1;
          min-width: 11rem;
          max-width: 18rem;
  }

  th,
  td {
      const candidatePageUrl = "{{ '/candidate.html' | relative_url }}";
    padding: 1rem 1.1rem;
    border-bottom: 1px solid var(--line);
    vertical-align: top;
    text-align: left;
    line-height: 1.65;
    word-wrap: break-word;
    word-break: break-word;
    overflow-wrap: anywhere;

      function normalizeHeader(value) {
        return String(value || "")
          .replace(/\s+/g, " ")
          .trim()
          .toLowerCase();
      }

      function isDetailField(normalizedHeader) {
        return (
          normalizedHeader === "state/position/district" ||
          normalizedHeader === "candidate website" ||
          normalizedHeader === "party affiliation" ||
          normalizedHeader === "are you a current or former elected official?" ||
          normalizedHeader === "if so, what office(s) have you held?" ||
          normalizedHeader.startsWith("some suggested prompts:")
        );
      }
  }
        const headers = rows[0].slice(1);
  th {

        const columns = headers.map((header, index) => ({
          index,
          header,
          normalized: normalizeHeader(header),
        }));

        const visibleColumns = columns.filter((col) => !isDetailField(col.normalized));
        const candidateNameColumn = columns.find((col) => col.normalized === "candidate name");
    background: linear-gradient(180deg, #fff4a8 0%, #ffe86a 100%);
    color: var(--sunrise-charcoal);
            <tr>${visibleColumns.map((col) => `<th>${escapeHtml(col.header || "")}</th>`).join("")}</tr>
    letter-spacing: 0.01em;
    font-size: 0.92rem;
  }

  tbody tr {
    transition: background-color 0.15s ease;
              .map((row, rowIndex) => {
                const rowCells = visibleColumns
                  .map((col) => {
                    const cell = row[col.index] || "";
                    if (candidateNameColumn && col.index === candidateNameColumn.index) {
                      const href = `${candidatePageUrl}?id=${encodeURIComponent(rowIndex)}`;
                      return `<td><a class="candidate-link" href="${href}">${escapeHtml(cell)}</a></td>`;
                    }
                    return `<td>${escapeHtml(cell)}</td>`;
                  })
                  .join("");
                return `<tr>${rowCells}</tr>`;
              })

  tbody td {
    background: #ffffff;
  }

  tbody tr:nth-child(even) {
    background: #f7faf5;
  }

  tbody tr:hover {
    background: #eef4e8;
  }

  td {
    font-size: 0.97rem;
    color: var(--ink);
    white-space: normal;
  }

  @media (max-width: 768px) {
    .sheet-note {
      font-size: 0.9rem;
    }

    th,
    td {
      padding: 0.8rem;
      font-size: 0.9rem;
    }

    th {
      font-size: 0.85rem;
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
  const localCsvPath = "{{ site.local_csv_path | escape }}";
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

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function buildTable(rows) {
    const table = document.getElementById("sheet-table");
    const status = document.getElementById("sheet-status");

    if (!rows.length) {
      status.textContent = "No data found in the selected Google Sheet tab.";
      return;
    }

    // Remove timestamp column if present in the first position.
    const headers = rows[0].slice(1);
    const bodyRows = rows.slice(1).map((row) => row.slice(1));

    const normalizedRows = bodyRows.map((row) => {
      const paddedRow = row.slice(0, headers.length);
      while (paddedRow.length < headers.length) {
        paddedRow.push("");
      }
      return paddedRow;
    });

    const headHtml = `
      <thead>
        <tr>${headers.map((h) => `<th>${escapeHtml(h || "")}</th>`).join("")}</tr>
      </thead>
    `;

    const bodyHtml = `
      <tbody>
        ${normalizedRows
          .map((row) => `<tr>${row.map((cell) => `<td>${escapeHtml(cell)}</td>`).join("")}</tr>`)
          .join("")}
      </tbody>
    `;

    table.innerHTML = headHtml + bodyHtml;
    status.textContent = `Showing ${normalizedRows.length} response${normalizedRows.length === 1 ? "" : "s"}.`;
  }

  async function loadSheet() {
    const status = document.getElementById("sheet-status");
    const sourceUrl = localCsvPath || csvUrl;
    const sourceLabel = localCsvPath ? "local CSV file" : "Google Sheet CSV";

    if (!sourceUrl) {
      status.textContent = "Set local_csv_path or google_sheet_csv_url in _config.yaml.";
      return;
    }

    try {
      const res = await fetch(sourceUrl, { cache: "no-store" });
      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }
      const csvText = await res.text();

      if (/<!doctype html|<html|\.gb_[A-Za-z0-9_-]+\{|<head|<body/i.test(csvText)) {
        throw new Error(`${sourceLabel} returned HTML instead of CSV`);
      }

      const rows = parseCsv(csvText);
      if (!rows.length) {
        throw new Error(`${sourceLabel} did not contain any CSV rows`);
      }
      buildTable(rows);
    } catch (err) {
      status.textContent = `Could not load table data (${err.message}).`;
    }
  }

  loadSheet();
</script>