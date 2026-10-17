---
layout: default
title: 2026 Ballot Guide
---

<style>
  :root {
    --sunrise-gold: #ffde16;
    --sunrise-charcoal: #33342e;
    --sunrise-orange: #fd9014;
    --sunrise-maroon: #8f0d56;
    --denver-sky-blue: #0096d6;
    --denver-white: #ffffff;
    --line: var(--sunrise-maroon);
    --muted: #5d6258;
  }

  body {
    background: var(--denver-white);
    color: var(--sunrise-charcoal);
  }

  .site-content a,
  .site-content a:visited,
  .site-content a:hover,
  .site-content a:focus {
    color: var(--denver-sky-blue);
  }

  .site-title,
  .site-content h2 {
    display: block;
    background: var(--sunrise-gold);
    padding: 0.35rem 0.7rem;
    border-radius: 4px;
  }

  .site-title {
    display: inline-block;
  }

  .site-content h2 {
    margin-top: 2rem;
    border: 1px solid var(--line);
  }

  .card-grid {
    display: grid;
    gap: 0.75rem;
    margin: 1rem 0 1.5rem;
  }

  .candidate-card,
  .measure-card {
    border: 1px solid var(--line);
    border-radius: 10px;
    background: var(--denver-white);
    box-shadow: 0 2px 8px rgba(51, 52, 46, 0.08);
    overflow: hidden;
  }

  .candidate-card {
    display: grid;
    grid-template-columns: 200px 1fr;
    grid-template-rows: auto 1fr;
    gap: 0.75rem 1rem;
    padding: 0.85rem;
    align-items: start;
  }

  .candidate-name,
  .measure-title {
    margin: 0;
    font-size: 1.45rem;
    line-height: 1.2;
    font-weight: 700;
    color: var(--sunrise-charcoal);
  }

  .candidate-name {
    grid-column: 1 / -1;
  }

  .candidate-name a {
    text-decoration: underline;
    text-underline-offset: 2px;
  }

  .candidate-headshot {
    display: block;
    width: 100%;
    aspect-ratio: 1 / 1;
    border: 1px solid var(--line);
    border-radius: 8px;
    object-fit: cover;
  }

  .candidate-description,
  .measure-blurb {
    margin: 0;
    line-height: 1.55;
  }

  .measure-card {
    padding: 0.85rem 1rem;
  }

  .measure-title {
    margin-bottom: 0.4rem;
  }

  .measure-recommendation {
    margin: 0 0 0.65rem;
  }

  .recommendation-badge {
    display: inline-block;
    padding: 0.2rem 0.65rem;
    border-radius: 999px;
    font-size: 20px;
    font-weight: 700;
    line-height: 1.2;
  }

  .recommendation-endorse,
  .recommendation-recommend {
    background: #d9efdf;
    color: #174d2b;
  }

  .recommendation-oppose {
    background: #f8dddd;
    color: #7b1f1f;
  }

  .recommendation-abstain {
    background: #e5e7eb;
    color: #374151;
  }

  .loading-note {
    margin: 0;
    color: var(--muted);
  }

  .faq-list {
    display: grid;
    gap: 0.65rem;
    margin: 1rem 0 1.5rem;
  }

  .faq-item {
    border: 1px solid var(--line);
    border-radius: 8px;
    background: var(--denver-white);
    overflow: hidden;
  }

  .faq-item summary {
    cursor: pointer;
    padding: 0.9rem 1rem;
    font-weight: 600;
    color: var(--sunrise-charcoal);
    background: #f9f1bc;
  }

  .faq-answer {
    margin: 0;
    padding: 0.9rem 1rem;
    border-top: 1px solid var(--line);
  }

  @media (max-width: 600px) {
    .site-content h2 {
      padding: 0.3rem 0.55rem;
    }

    .candidate-card {
      grid-template-columns: 1fr;
    }

    .candidate-name {
      grid-column: 1;
    }

    .candidate-headshot {
      max-width: 220px;
    }
  }
</style>

## Endorsed Candidates

<section aria-label="Endorsed candidates">
  <div class="card-grid" id="endorsed-candidates-grid" aria-live="polite">
    <p class="loading-note">Loading endorsed candidates...</p>
  </div>
</section>

## Recommendations for Candidate Races

<section aria-label="Recommendations for candidate races">
  <div class="card-grid" id="recommended-candidates-grid" aria-live="polite">
    <p class="loading-note">Loading candidate recommendations...</p>
  </div>
</section>

## Endorsed Ballot Measures

<section aria-label="Endorsed ballot measures">
  <div class="card-grid" id="endorsed-measures-grid" aria-live="polite">
    <p class="loading-note">Loading endorsed ballot measures...</p>
  </div>
</section>

## Recommendations for Ballot Measures

<section aria-label="Recommendations for ballot measures">
  <div class="card-grid" id="recommended-measures-grid" aria-live="polite">
    <p class="loading-note">Loading ballot measure recommendations...</p>
  </div>
</section>

## FAQ

<section aria-label="Frequently asked questions">
  <div class="faq-list" id="faq-list" aria-live="polite">
    <p class="loading-note">Loading FAQ...</p>
  </div>
</section>

<script>
  const dataFiles = {
    endorsedCandidates: "{{ '/data/candidates_endorsed.csv' | relative_url }}",
    recommendedCandidates: "{{ '/data/candidates_recommended.csv' | relative_url }}",
    endorsedMeasures: "{{ '/data/measure_endorsed.csv' | relative_url }}",
    recommendedMeasures: "{{ '/data/measure_recommendation.csv' | relative_url }}",
    faq: "{{ '/data/faq.csv' | relative_url }}"
  };

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
    return String(value || "").replace(/\s+/g, " ").trim().toLowerCase();
  }

  function toUrl(value) {
    const trimmed = String(value || "").trim();
    if (!trimmed) {
      return "";
    }
    if (/^https?:\/\//i.test(trimmed) || trimmed.startsWith("/")) {
      return trimmed;
    }
    return `https://${trimmed}`;
  }

  function linkifyText(value) {
    const raw = String(value || "");
    const markdownLinkRegex = /\[([^\]]+)\]\(([^\s)]+)\)/g;
    const urlRegex = /https?:\/\/[^\s<>'"]+/g;

    function linkifyPlainText(text) {
      let html = "";
      let lastIndex = 0;
      let match;
      while ((match = urlRegex.exec(text)) !== null) {
        html += escapeHtml(text.slice(lastIndex, match.index));
        html += `<a href="${escapeHtml(match[0])}" target="_blank" rel="noopener noreferrer">${escapeHtml(match[0])}</a>`;
        lastIndex = match.index + match[0].length;
      }
      html += escapeHtml(text.slice(lastIndex)).replace(/\*([^*\n]+)\*/g, "<em>$1</em>");
      return html;
    }

    let html = "";
    let lastIndex = 0;
    let match;
    while ((match = markdownLinkRegex.exec(raw)) !== null) {
      html += linkifyPlainText(raw.slice(lastIndex, match.index));
      const href = toUrl(match[2]);
      html += href
        ? `<a href="${escapeHtml(href)}" target="_blank" rel="noopener noreferrer">${escapeHtml(match[1])}</a>`
        : escapeHtml(match[0]);
      lastIndex = match.index + match[0].length;
    }
    return html + linkifyPlainText(raw.slice(lastIndex));
  }

  function getValue(row, headers, key) {
    const index = headers.indexOf(key);
    return index < 0 ? "" : row[index] || "";
  }

  async function loadCsv(url, target, render, emptyMessage) {
    try {
      const response = await fetch(url, { cache: "no-store" });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const rows = parseCsv(await response.text());
      if (rows.length < 2) {
        target.innerHTML = `<p class="loading-note">${escapeHtml(emptyMessage)}</p>`;
        return;
      }
      render(rows, target);
    } catch (error) {
      target.innerHTML = `<p class="loading-note">Could not load this section (${escapeHtml(error.message)}).</p>`;
    }
  }

  function renderCandidates(rows, target, emptyMessage) {
    const headers = rows[0].map(normalizeHeader);
    const cards = rows.slice(1)
      .filter((row) => row.some((cell) => String(cell || "").trim() !== ""))
      .map((row) => {
        const name = getValue(row, headers, "name");
        const url = toUrl(getValue(row, headers, "url"));
        const headshot = toUrl(getValue(row, headers, "headshot"));
        const description = getValue(row, headers, "description");
        const nameHtml = url
          ? `<a href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">${escapeHtml(name)}</a>`
          : escapeHtml(name);
        const imageHtml = headshot
          ? `<img class="candidate-headshot" src="${escapeHtml(headshot)}" alt="Photo of ${escapeHtml(name)}">`
          : "";

        return `<article class="candidate-card">
          <h3 class="candidate-name">${nameHtml}</h3>
          ${imageHtml}
          <p class="candidate-description">${linkifyText(description)}</p>
        </article>`;
      });
    target.innerHTML = cards.join("") || `<p class="loading-note">${escapeHtml(emptyMessage)}</p>`;
  }

  function renderMeasures(rows, target, emptyMessage) {
    const headers = rows[0].map(normalizeHeader);
    const cards = rows.slice(1)
      .filter((row) => row.some((cell) => String(cell || "").trim() !== ""))
      .map((row) => {
        const title = getValue(row, headers, "measure title");
        const recommendation = getValue(row, headers, "recommendation");
        const blurb = getValue(row, headers, "blurb");
        const recommendationClass = normalizeHeader(recommendation);
        return `<article class="measure-card">
          <h3 class="measure-title">${escapeHtml(title)}</h3>
          <p class="measure-recommendation"><span class="recommendation-badge recommendation-${escapeHtml(recommendationClass)}">${escapeHtml(recommendation)}</span></p>
          <p class="measure-blurb">${linkifyText(blurb)}</p>
        </article>`;
      });
    target.innerHTML = cards.join("") || `<p class="loading-note">${escapeHtml(emptyMessage)}</p>`;
  }

  function renderFaq(rows, target) {
    const headers = rows[0].map(normalizeHeader);
    const questionIndex = headers.indexOf("question");
    const answerIndex = headers.indexOf("answer");
    if (questionIndex < 0 || answerIndex < 0) {
      throw new Error("FAQ CSV must include question and answer columns");
    }

    const items = rows.slice(1)
      .filter((row) => String(row[questionIndex] || "").trim() !== "")
      .map((row) => `<details class="faq-item">
        <summary>${escapeHtml(row[questionIndex])}</summary>
        <p class="faq-answer">${linkifyText(row[answerIndex] || "")}</p>
      </details>`);
    target.innerHTML = items.join("") || '<p class="loading-note">No FAQ items found.</p>';
  }

  loadCsv(dataFiles.endorsedCandidates, document.getElementById("endorsed-candidates-grid"),
    (rows, target) => renderCandidates(rows, target, "No endorsed candidates found."),
    "No endorsed candidates found.");
  loadCsv(dataFiles.recommendedCandidates, document.getElementById("recommended-candidates-grid"),
    (rows, target) => renderCandidates(rows, target, "No candidate recommendations found."),
    "No candidate recommendations found.");
  loadCsv(dataFiles.endorsedMeasures, document.getElementById("endorsed-measures-grid"),
    (rows, target) => renderMeasures(rows, target, "No endorsed ballot measures found."),
    "No endorsed ballot measures found.");
  loadCsv(dataFiles.recommendedMeasures, document.getElementById("recommended-measures-grid"),
    (rows, target) => renderMeasures(rows, target, "No ballot measure recommendations found."),
    "No ballot measure recommendations found.");
  loadCsv(dataFiles.faq, document.getElementById("faq-list"),
    renderFaq,
    "No FAQ items found.");
</script>
