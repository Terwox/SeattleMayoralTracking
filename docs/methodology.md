# Methodology

This dashboard is a public accountability scorecard, not an official government reporting system. It uses source-traced public data and labels each primary beat by evidence strength so readers can see what is official, reported, inferred, or missing.

## Evidence Tiers

| Tier | Meaning | How it is used |
|------|---------|----------------|
| Official | A government or public agency directly reports the metric. | KCRHA PIT/HIC counts and other agency dashboards or reports. |
| Reported | Credible public reporting or named public statements describe the fact, but no official metric exists. | Tiny homes in storage and some shelter-opening context. |
| Inferred | The dashboard calculates or reconciles a claim from public sources. | Net-new baseline, progress rules, and cost-pressure comparisons. |
| Gap | The metric matters but is not publicly available in a verifiable form. | Quarterly unsheltered estimates, homeless-specific overdose deaths, and consistent cost-per-person outcomes. |

## Primary Beat 1: The Promise

### What it measures
Progress toward Mayor Wilson's public commitment to add 4,000 new emergency housing and shelter units during her term.

### Evidence basis
This beat carries two evidence labels. The four-year pledge is **Reported** from public campaign/inauguration reporting. The March 4, 2026 "Neighbor by Neighbor" package is **Official** because it is a mayoral statement setting a first-year target of 1,000 new shelter and emergency housing units.

### Counting rule
Wilson-era progress starts at zero on January 6, 2026. Units count only when they break ground, are acquired, or become operational after that date. Inherited projects, replacements for closed facilities, proposed sites, and expected future units are kept separate until there is operational evidence.

## Primary Beat 2: The Baseline

### What it measures
The difference between a prior administration's reported unit claim and a stricter net-new baseline.

### Evidence basis
**Inferred.** The dashboard reconciles a public fact-check against the dashboard's own counting rule. This is not an official city baseline.

### Calculation
- Start with Harrell-era reported units.
- Remove replacement or relocation units that do not increase net capacity.
- Remove projects already underway before that mayoral term.
- Use the resulting value as context for why Wilson-era units must be counted from a clean January 6, 2026 starting line.

## Primary Beat 3: The Gimme

### What it measures
Reported tiny homes in storage that could become shelter capacity if sites, permits, operations, and staffing are solved.

### Evidence basis
**Reported.** The stored-unit count comes from local reporting. There is no official public dashboard for stored tiny homes.

### Counting rule
Stored tiny homes do not count as Wilson deployed units. They remain a pressure point until an opening, operator, site, and capacity are publicly confirmed.

## Primary Beat 4: The Outcome

### What it measures
King County unsheltered homelessness from the Point-in-Time count, used as the closest official public outcome proxy for Wilson's stated interest in how many people are sleeping outside.

### Evidence basis
**Official.** The latest data point is the KCRHA 2026 PIT/HIC Initial Report: 18,365 total people experiencing homelessness, including 11,829 unsheltered and 6,536 sheltered.

### Limitations
- PIT is a one-night estimate and is understood to undercount homelessness.
- KCRHA's 2022, 2024, and 2026 counts use respondent-driven sampling. These should not be compared casually to pre-2022 counts.
- The metric is King County-wide, not Seattle-only.
- PIT cannot prove causation for a mayoral policy change.

## Primary Beat 5: The Efficiency Test

### What it measures
Cost pressure across shelter operating costs and housing capital costs.

### Evidence basis
**Inferred.** Public cost sources use different categories, geographies, and denominators. The dashboard compares cost signals; it does not claim a clean cost per person housed.

### Interpretation rule
The card should be read as "what does capacity cost?" rather than "what did one successful outcome cost?" A true cost-per-person-housed metric would need consistent placement, retention, and spending data that are not publicly available in one comparable series.

## General Data Rules

- Prefer official sources for counts and public-system facts.
- Use journalism only when official sources do not track the fact being measured.
- Keep proposed, expected, reported, and operational units distinct.
- Do not infer causation from PIT, overdose, spending, crime, or cost trends.
- Update source URLs and retrieval dates whenever a CSV value changes.

## Data Currency

All data is manually curated from public sources.

- PIT/HIC counts: official public reports when released.
- Housing and shelter units: manual public-source updates as new openings or official announcements occur.
- Overdose, spending, crime, and other context metrics: updated when agency dashboards or reports publish new values.

## Mayoral Transition Dates

- Bruce Harrell: January 1, 2022.
- Katie Wilson: January 6, 2026.

## Transparency

All source data is available in `data/` with source URLs and retrieval dates. Known data gaps are shown in the app because the absence of comparable public data is itself an accountability finding.
