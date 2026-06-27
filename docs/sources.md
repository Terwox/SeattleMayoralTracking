# Data Sources

Complete list of source categories used in the Seattle Mayoral Accountability Dashboard.

## Evidence Model

The dashboard labels primary claims by evidence strength:

- **Official:** government or public-agency source directly reports the metric.
- **Reported:** credible journalism or named public statements report the fact, but no official metric exists.
- **Inferred:** dashboard calculation or reconciliation from public sources.
- **Gap:** important data that is not publicly available in a comparable, verifiable form.

## Official Government And Agency Sources

### King County Regional Homelessness Authority (KCRHA)

- **URL:** https://kcrha.org/data-overview/
- **2026 PIT/HIC PDF:** https://kcrha.org/wp-content/uploads/2026/06/KCRHA_Point-in-Time-Count-2026_Executive-Report.pdf
- **Data used:** Point-in-Time count, Housing Inventory Count, system context, and budget/system performance materials where available.
- **Format:** Dashboard pages, PDF reports, budget documents.
- **Update frequency:** Varies by report. The dashboard does not assume a comparable quarterly unsheltered estimate series.

### HUD Exchange

- **URL:** https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/
- **Data used:** Historical PIT and HIC data.
- **Format:** Downloadable reports and files.
- **Update frequency:** Annual or biennial depending on count type and reporting cycle.

### Mayor Wilson Office

- **URL:** https://wilson.seattle.gov/
- **Data used:** Official statements, legislation summaries, shelter-expansion targets, and policy changes.
- **Current key source:** March 4, 2026 Neighbor by Neighbor shelter expansion announcement.

### Seattle Performance Dashboard

- **URL:** https://performance.seattle.gov/
- **Data used:** City homelessness metrics and shelter capacity where available.
- **Format:** Online dashboard.
- **Update frequency:** Varies by metric.

### King County Public Health - Overdose Dashboard

- **URL:** https://kingcounty.gov/en/dept/dph/health-safety/disease-illness/drug-overdose
- **Data used:** Annual countywide overdose-death totals.
- **Format:** Dashboard and downloadable data where available.
- **Update frequency:** Source data may update more often, but this repository currently stores annual totals.
- **Gap:** Homeless-specific overdose deaths are not consistently available in a public, verifiable format.

### Seattle Budget Office

- **URL:** https://www.seattle.gov/city-budget-office
- **Data used:** Annual homelessness-related spending.
- **Format:** Budget documents.
- **Update frequency:** Annual, with mid-year supplementals.

## Reported Sources

### Seattle Times

- **URL:** https://www.seattletimes.com/
- **Data used:** Reporting on tiny homes in storage, shelter openings, delays, and policy context.
- **Usage:** Reported evidence where no official stored-unit inventory exists.
- **Local source note:** `docs/source-notes/seattle-times-empty-tiny-homes-2024-10-05.md`
- **Boundary:** The October 2024 Seattle Times article supports the roughly 250 stored-unit baseline. Later remaining-count estimates require separate deployment evidence.

### Axios Seattle

- **URL:** https://www.axios.com/local/seattle
- **Data used:** Harrell emergency-housing fact-check used to infer a stricter net-new baseline.
- **Usage:** Reported source for dashboard reconciliation, not an official city baseline.
- **Local source note:** `docs/source-notes/axios-harrell-pledge-2025-09-30.md`

### PubliCola and Local Outlets

- **URL:** https://publicola.com/
- **Data used:** Local homelessness policy, funding, and budget context.
- **Usage:** Context and reported source material when official datasets do not provide the needed view.

## Data Quality Notes

### Verification process

1. Prefer official public sources for counts and agency facts.
2. Use reported sources only for facts not tracked in official public data.
3. Label inferred calculations at the point of use.
4. Include source URL and retrieval date in every CSV row.
5. Record material changes in `data/changelog.csv`.

### Manual access for blocked sources

Some local-news sources may block automated access with Cloudflare, paywalls, or bot detection. When that happens:

1. Give the user the exact source URL.
2. Ask the user to open it manually in Chrome.
3. Use the user-opened Chrome history/session to verify article metadata and extract only citation facts needed by the dashboard.
4. Save a repo-local source note under `docs/source-notes/`.
5. Do not store full article text in the repository; keep source notes to metadata, paraphrased facts, evidence boundaries, and short citation context.

### Known limitations

- PIT count methodology changed in 2022, so pre-2022 comparisons require caution.
- PIT is a one-night estimate and should be treated as an undercount.
- King County PIT is regional, not Seattle-only.
- Stored tiny-home inventory is not officially tracked in a public dataset.
- Consistent cost-per-person-housed data is not available from one comparable public source.

## API Access

Currently, the dashboard uses manually curated public data. No official APIs are currently integrated for:

- Real-time shelter availability.
- Individual-level outcomes tracking.
- Stored tiny-home inventory.
- Comparable quarterly unsheltered estimates.
