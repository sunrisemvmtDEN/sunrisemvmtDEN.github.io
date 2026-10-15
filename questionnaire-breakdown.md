---
layout: default
title: Questionnaire Breakdown
---

<style>
  .questionnaire-wrap {
    max-width: 920px;
    margin-top: 1rem;
  }

  .questionnaire-intro {
    color: var(--muted);
    margin-bottom: 1rem;
  }

  .question-list {
    display: grid;
    gap: 0.75rem;
  }

  .question-item {
    border: 1px solid var(--line);
    border-radius: 8px;
    background: var(--denver-white);
    overflow: hidden;
  }

  .question-item h3 {
    margin: 0;
    padding: 0.8rem 1rem;
    background: var(--accent-soft);
    color: var(--sunrise-charcoal);
    font-size: 1rem;
    line-height: 1.4;
  }

  .question-item p {
    margin: 0;
    padding: 0.85rem 1rem;
    color: var(--ink);
    line-height: 1.55;
  }

  .question-item a {
    color: var(--denver-sky-blue);
    font-weight: 700;
    text-decoration: underline;
    text-underline-offset: 2px;
  }

  .question-item a:visited {
    color: var(--denver-sky-blue);
  }

  .question-item a:hover {
    color: var(--denver-sky-blue);
  }
</style>

<div class="questionnaire-wrap">
  <p class="sheet-note"><a href="{{ '/' | relative_url }}">Back to ballot guide</a></p>
  <h1 class="site-title">Questionnaire Breakdown</h1>
  <p class="questionnaire-intro">
    These are the current questionnaire prompts shown in the ballot guide, with context on what each one helps voters evaluate.
  </p>

  <div id="question-list" class="question-list">
    <p class="sheet-note">Loading questions...</p>
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
    return String(value || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/\"/g, "&quot;")
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

  function headerHtml(header, normalized) {
    if (normalized.startsWith("will you run boldly on a green new deal?")) {
      return 'Will you run boldly on a <a href="https://www.sunrisemovement.org/green-new-deal/" target="_blank" rel="noopener noreferrer">Green New Deal</a>?';
    }

    if (normalized.startsWith("have you taken sunrise movement's green new deal pledge")) {
      return 'Have you taken <a href="https://www.sunrisemovement.org/pledge" target="_blank" rel="noopener noreferrer">Sunrise Movement\'s Green New Deal Pledge</a>?';
    }

    return escapeHtml(header);
  }

  function getQuestionContext(normalized) {
    const contextMap = {
      // Add entries here that match current questionnaire prompts.
      // Example:
      // "do you support ...": "Explanation for why this question matters to voters."
      "state/position/district":"This provides context and allows readers to know if they a given candidate's race is even on their ballot.",
      "do you support accessible, free, and fair elections including mail in ballots and 24/7 drop off access?":"There have been many threats from the current Presidential Administration which have generated valid concerns in the legitimacy of upcoming elections, particularly the 2028 Presidential Election. As such, it's become paramount for representatives to be dedicated to upholding fair elections- something that Colorado has had issues with in the past.",
      "do you support fully funding and expansion of affordable and accessible public transit including efforts to make our communities safer and more walkable?":"Text",
      "do you support the expansion of the star program to ensure mental health professionals, rather than police, are the primary responders for non-violent 911 calls?":"Text",
      "do you support a municipal \"gig worker bill of rights\" that mandates pay transparency and prevents \"deactivation\" without a formal appeals process?":"Text",
      "do you support strong consumer protections and environmental accountability standards for ai infrastructure development in colorado?":"AI and data centers have quickly become a top threat to everyday people in terms of both their environmental impact and affordability impact. The Denver Metro Area is planned to receive multiple hyperscale data centers, increasing the areas demand by 2 or even 3 fold. This will lead to more blackouts, as well as increased utility costs. Only through strong legislature can we expect to be protected from these adverse affects, and ensure it is the data centers themselves, not tax payers, who are burdened by the costs of data centers.",
      "do you support ending \"single-family-only\" zoning city-wide to allow for the construction of middle density housing (e.g.: adus (casitas), duplexes, and triplexes) in all residential neighborhoods?":"It's well known that Denver has a high cost of , due in large part to median cost of rent being such a relatively large share of median household income, causing many residents to live on a tight budget. The high cost of rent can be partially attributed to zoning limitations, which prevent the middle density houses that help keep housing costs down in other cities in this country.",
      "do you support an immediate ban on all new natural gas hookups in both residential and commercial new construction?":"Text",
      "will you lobby the colorado state legislature to repeal the ban on rent control so denver can implement its own rent stabilization policies?":"Text",
      "do you support the creation of a publicly owned social housing authority to build and manage housing that remains permanently off the private market?":"Text",
      "will you pledge to make denver a \"sanctuary city\" for gender-affirming care, including a refusal to cooperate with out-of-state investigations into patients or providers?":"Text",
      "will you use your office and power to end city/county/state collaboration with ice?":"This one's pretty self explanatory. Most representatives have some ability to restrict/not comply/or outright remove ICE from our communities in order to protect our fellow neighbors.",
      "do you believe unions should be able to form via \"card check\" rather than requiring a second, separate election?":"Text",
      "do you pledge to refuse all donations from Corporate pacs and the fossil fuel industry?":"Text",
      "do you believe that the existence of a \"billionaire class\" is fundamentally incompatible with a fair and equitable democracy?":"Text",
      "do you support a permanent ceasefire in the middle east and an end to u.s. military aid used for the occupation of palestinian territories?":"Text",
      "will you run boldly on a green new deal?": "This question checks whether candidates support ambitious climate, jobs, and justice policies at the pace the climate crisis and its intersectional issues demand.",
      "have you taken sunrise movement's green new deal pledge": "This asks whether candidates have publicly committed to Sunrise Movement's climate standards and accountability expectations."


    };

    for (const key of Object.keys(contextMap)) {
      if (normalized.startsWith(key)) {
        return contextMap[key];
      }
    }

    return "This question is included to help voters compare candidates on an issue Sunrise Denver identified as high-impact for local communities.";
  }

  function buildQuestionList(rows) {
    const list = document.getElementById("question-list");
    if (!list) {
      return;
    }

    if (!rows.length) {
      list.innerHTML = '<p class="sheet-note">Could not find questionnaire headers.</p>';
      return;
    }

    const headers = rows[0].slice(1);
    const questions = headers
      .map((header) => ({
        header,
        normalized: normalizeHeader(header)
      }))
      .filter((item) => item.normalized && item.normalized !== "candidate name")
      .filter((item) => !isDetailField(item.normalized));

    if (!questions.length) {
      list.innerHTML = '<p class="sheet-note">No questionnaire prompts found.</p>';
      return;
    }

    list.innerHTML = questions
      .map((item) => {
        const context = getQuestionContext(item.normalized);
        return `
          <article class="question-item">
            <h3>${headerHtml(item.header, item.normalized)}</h3>
            <p>${escapeHtml(context)}</p>
          </article>
        `;
      })
      .join("");
  }

  async function loadQuestions() {
    const list = document.getElementById("question-list");
    if (!list) {
      return;
    }

    const sourceUrl = localCsvPath || csvUrl;
    if (!sourceUrl) {
      list.innerHTML = '<p class="sheet-note">Set local_csv_path or google_sheet_csv_url in _config.yaml.</p>';
      return;
    }

    try {
      const res = await fetch(sourceUrl, { cache: "no-store" });
      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }

      const csvText = await res.text();
      const rows = parseCsv(csvText);
      buildQuestionList(rows);
    } catch (err) {
      list.innerHTML = `<p class="sheet-note">Could not load questionnaire (${escapeHtml(err.message)}).</p>`;
    }
  }

  loadQuestions();
</script>
