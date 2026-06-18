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

    --denver-sky-blue: #0096d6;
    --denver-white: #ffffff;
    --denver-red: #bf0a30;

    --bg: var(--denver-white);
    --ink: var(--sunrise-charcoal);
    --muted: #5d6258;
    --line: #c9d5c3;
    --accent: var(--sunrise-orange);
    --accent-soft: #f9f1bc;
    --accent-strong: var(--denver-red);
    --gold-light: var(--sunrise-gold);
  }

  body {
    background: var(--bg);
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

  .sheet-note-emphasis {
    margin-top: -0.35rem;
    margin-bottom: 0.95rem;
  }

  .sheet-status {
    padding: 0.65rem 0.8rem;
    background: linear-gradient(90deg, var(--accent-soft), var(--denver-white));
    border-left: 4px solid var(--accent-strong);
    border-radius: 6px;
    margin-bottom: 0.8rem;
  }

  .table-shell {
    border: 1px solid var(--line);
    border-radius: 10px;
    overflow-x: auto;
    overflow-y: hidden;
    background: var(--denver-white);
    box-shadow: 0 2px 8px rgba(51, 52, 46, 0.08);
  }

  table {
    width: max-content;
    min-width: 1700px;
    border-collapse: collapse;
  }

  thead {
    position: sticky;
    top: 0;
    z-index: 1;
  }

  th,
  td {
    padding: 1rem 1.1rem;
    border-bottom: 1px solid var(--line);
    vertical-align: top;
    text-align: left;
    line-height: 1.55;
    white-space: normal;
    word-wrap: break-word;
    word-break: normal;
    overflow-wrap: break-word;
    min-width: 13rem;
    max-width: 22rem;
  }

  th {
    background: linear-gradient(180deg, #fff4a8 0%, #ffe86a 100%);
    color: var(--sunrise-charcoal);
    font-weight: 600;
    letter-spacing: 0.01em;
    font-size: 0.92rem;
  }

  tbody tr {
    transition: background-color 0.15s ease;
  }

  tbody td {
    background: var(--denver-white);
    font-size: 0.97rem;
    color: var(--ink);
  }

  tbody tr:nth-child(even) {
    background: #f7faf5;
  }

  tbody tr:hover {
    background: #eef4e8;
  }

  .candidate-link {
    color: var(--denver-sky-blue);
    font-weight: 700;
    text-decoration: underline;
    text-underline-offset: 2px;
  }

  .candidate-link:hover {
    color: var(--denver-red);
  }

  @media (max-width: 768px) {
    .sheet-note {
      font-size: 0.9rem;
    }

    th,
    td {
      padding: 0.8rem;
      font-size: 0.9rem;
      min-width: 11rem;
      max-width: 18rem;
    }

    th {
      font-size: 0.85rem;
    }
  }
</style>

## Live Candidate Responses

<p class="sheet-note">
To assess and platform more even more candidates, Sunrise Movement volunteers in the Denver area asked candidates to answer a series of questions, which have been summarized here to give voter's a fast and simple way to be informed.
</p>

<p class="sheet-note sheet-note-emphasis"><em>Candidate names open a profile page with additional details. Scroll horizontally to view all policy response columns.</em></p>

<div class="sheet-wrap">
  <div id="sheet-status" class="sheet-status">Loading latest data...</div>
  <div class="table-shell">
    <table id="sheet-table" aria-label="Candidate responses table"></table>
  </div>
</div>

<script>
  const localCsvPath = "{{ site.local_csv_path | escape }}";
  const csvUrl = "{{ site.google_sheet_csv_url | escape }}";
  const candidatePageUrl = "{{ '/candidate.html' | relative_url }}";

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
    return String(value || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function normalizeHeader(value) {
    return String(value || "")
      .replace(/\s+/g, " ")
      .trim()
      .toLowerCase();
  }

  function isDetailField(normalizedHeader) {
    return (
      normalizedHeader === "candidate website" ||
      normalizedHeader === "type of race" ||
      normalizedHeader === "party affiliation" ||
      normalizedHeader === "are you a current or former elected official?" ||
      normalizedHeader === "if so, what office(s) have you held?" ||
      normalizedHeader.startsWith("some suggested prompts:")
    );
  }

  function getHeaderHtml(column) {
    if (column.normalized.startsWith("will you run boldly on a green new deal?")) {
      return `Will you run boldly on a <a href="https://www.sunrisemovement.org/green-new-deal/" target="_blank" rel="noopener noreferrer">Green New Deal</a>?`;
    }

    if (column.normalized.startsWith("have you taken sunrise movement's green new deal pledge")) {
      return `Have you taken <a href="https://www.sunrisemovement.org/pledge" target="_blank" rel="noopener noreferrer">Sunrise Movement's Green New Deal Pledge</a> (https://www.sunrisemovement.org/pledge)`;
    }

    return escapeHtml(column.header || "");
  }

  function buildTable(rows) {
    const table = document.getElementById("sheet-table");
    const status = document.getElementById("sheet-status");

    if (!rows.length) {
      status.textContent = "No data found in the selected CSV file.";
      return;
    }

    const allHeaders = rows[0].slice(1);
    const bodyRows = rows.slice(1).map((row) => row.slice(1));

    const columns = allHeaders.map((header, index) => ({
      index,
      header,
      normalized: normalizeHeader(header),
    }));

    const visibleColumns = columns.filter((col) => !isDetailField(col.normalized));
    const candidateNameColumn = columns.find((col) => col.normalized === "candidate name");

    const normalizedRows = bodyRows.map((row) => {
      const paddedRow = row.slice(0, allHeaders.length);
      while (paddedRow.length < allHeaders.length) {
        paddedRow.push("");
      }
      return paddedRow;
    });

    const headHtml = `
      <thead>
        <tr>${visibleColumns.map((col) => `<th>${getHeaderHtml(col)}</th>`).join("")}</tr>
      </thead>
    `;

    const bodyHtml = `
      <tbody>
        ${normalizedRows
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
