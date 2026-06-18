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

  .site-content a,
  .site-content a:visited,
  .site-content a:hover,
  .site-content a:focus {
    color: var(--denver-sky-blue);
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

  .endorsed-candidates {
    margin: 0 0 1rem;
  }

  .endorsed-intro {
    margin: 0 0 0.95rem;
    font-size: 0.95rem;
    color: var(--muted);
  }

  .endorsed-grid {
    display: grid;
    gap: 0.75rem;
  }

  .endorsed-card {
    display: flex;
    gap: 0.9rem;
    align-items: flex-start;
    padding: 0.75rem;
    border: 1px solid #dce7d6;
    border-radius: 8px;
    background: #ffffff;
  }

  .endorsed-headshot {
    width: 92px;
    height: 92px;
    border-radius: 8px;
    object-fit: cover;
    border: 1px solid #d5e0ce;
    background: #f3f7ef;
    flex: 0 0 auto;
  }

  .endorsed-content {
    min-width: 0;
  }

  .endorsed-name {
    margin: 0 0 0.35rem;
    font-size: 1.2rem;
    line-height: 1.2;
  }

  .endorsed-name a {
    text-decoration: underline;
    text-underline-offset: 2px;
    font-weight: 700;
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
    color: var(--denver-sky-blue);
  }

  @media (max-width: 768px) {
    .sheet-note {
      font-size: 0.9rem;
    }

    .endorsed-card {
      flex-direction: column;
      align-items: stretch;
    }

    .endorsed-headshot {
      width: 100%;
      height: auto;
      max-height: 220px;
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

## Endorsed Candidates

<section class="endorsed-candidates">
  <p class="endorsed-intro">Starting over a year ago, Sunrise Denver volunteers began keeping tabs on the primary races. After meeting with dozens of candidates, the Electoral subteam presented the following 3 candidates as endorsement recommendations- the Denver Hub Members voted unanimously to endorse each one! 
  </p>

<p class="sheet-note sheet-note-emphasis"><em> Candidate names link to their pages. Our endorsement means we are pushing local Sunrisers to commit time and effort in aiding these campaigns success. This is why we limited to 3 endorsements. More awesome candidates can be found in the next section.</em></p>

  <div class="endorsed-grid" id="endorsed-grid">
    <p class="sheet-note">Loading endorsed candidates...</p>
  </div>
</section>

## Additional Candidate Responses

<p class="sheet-note">
To assess and platform more even more candidates, Sunrise Movement volunteers in the Denver area asked candidates to answer a series of questions, which have been summarized here to give voter's a fast and simple way to be informed.
</p>

<p class="sheet-note sheet-note-emphasis"><em>Candidate names open a profile page with additional details. Scroll horizontally to view all policy response columns.</em></p>

<div class="sheet-wrap">
  <div class="table-shell">
    <table id="sheet-table" aria-label="Candidate responses table"></table>
  </div>
</div>

<script>
  const localCsvPath = "{{ site.local_csv_path | escape }}";
  const csvUrl = "{{ site.google_sheet_csv_url | escape }}";
  const candidatePageUrl = "{{ '/candidate.html' | relative_url }}";
  const endorsedCsvPath = "{{ '/data/endorsed_candidates.csv' | relative_url }}";

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

  function toUrl(value) {
    const trimmed = String(value || "").trim();
    if (!trimmed) {
      return "";
    }

    if (/^https?:\/\//i.test(trimmed)) {
      return trimmed;
    }

    if (trimmed.startsWith("/")) {
      return trimmed;
    }

    return `https://${trimmed}`;
  }

  function buildEndorsedCandidates(rows) {
    const grid = document.getElementById("endorsed-grid");
    if (!grid) {
      return;
    }

    if (!rows.length || rows.length < 2) {
      grid.innerHTML = "<p class=\"sheet-note\">No endorsed candidates found.</p>";
      return;
    }

    const headers = rows[0].map((h) => normalizeHeader(h));
    const getValue = (row, key) => {
      const idx = headers.indexOf(key);
      return idx >= 0 ? (row[idx] || "") : "";
    };

    const cards = rows
      .slice(1)
      .filter((row) => row.some((cell) => String(cell || "").trim() !== ""))
      .map((row) => {
        const name = getValue(row, "name");
        const url = toUrl(getValue(row, "url"));
        const headshot = toUrl(getValue(row, "headshot"));
        const description = getValue(row, "description");

        const nameHtml = url
          ? `<a href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">${escapeHtml(name)}</a>`
          : escapeHtml(name);

        const imageHtml = headshot
          ? `<img class="endorsed-headshot" src="${escapeHtml(headshot)}" alt="Headshot of ${escapeHtml(name)}">`
          : "";

        return `
          <article class="endorsed-card">
            ${imageHtml}
            <div class="endorsed-content">
              <h3 class="endorsed-name">${nameHtml}</h3>
              <p>${escapeHtml(description)}</p>
            </div>
          </article>
        `;
      })
      .join("");

    grid.innerHTML = cards || "<p class=\"sheet-note\">No endorsed candidates found.</p>";
  }

  async function loadEndorsedCandidates() {
    const grid = document.getElementById("endorsed-grid");
    if (!grid) {
      return;
    }

    try {
      const res = await fetch(endorsedCsvPath, { cache: "no-store" });
      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }

      const csvText = await res.text();
      const rows = parseCsv(csvText);
      buildEndorsedCandidates(rows);
    } catch (err) {
      grid.innerHTML = `<p class=\"sheet-note\">Could not load endorsed candidates (${escapeHtml(err.message)}).</p>`;
    }
  }

  function buildTable(rows) {
    const table = document.getElementById("sheet-table");

    if (!rows.length) {
      table.innerHTML = "";
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
  }

  async function loadSheet() {
    const sourceUrl = localCsvPath || csvUrl;
    const sourceLabel = localCsvPath ? "local CSV file" : "Google Sheet CSV";

    if (!sourceUrl) {
      console.error("Set local_csv_path or google_sheet_csv_url in _config.yaml.");
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
      console.error(`Could not load table data (${err.message}).`);
    }
  }

  loadEndorsedCandidates();
  loadSheet();
</script>
