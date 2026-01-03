# Methodology

This document describes the methodology used to calculate each index in the Seattle Mayoral Accountability Dashboard.

## Index 1: Unsheltered Population Count

### What it measures
The number of people sleeping outside (unsheltered) in Seattle/King County.

### Mayor Wilson's commitment
> "How many people are sleeping unsheltered on the streets of Seattle in four years"

### Data sources
- **Official PIT counts (biennial):** HUD Point-in-Time counts conducted in late January of odd years
- **Quarterly estimates:** KCRHA encampment estimates published quarterly

### Calculation
- We display the official PIT unsheltered count as primary data points
- Quarterly KCRHA estimates shown as trend line between official counts
- Change since Wilson's inauguration calculated from closest pre-Jan 2026 data point

### Limitations
- PIT methodology changed significantly in 2022 (switched from sampling to comprehensive count)
- Direct year-over-year comparisons before/after 2022 should be interpreted with caution
- Quarterly estimates use different methodology than official PIT counts
- Weather, time of count, and volunteer availability affect counts

---

## Index 2: Emergency Housing Progress

### What it measures
Progress toward Mayor Wilson's commitment to add 4,000 emergency housing and shelter units.

### Mayor Wilson's commitment
> "4,000 new emergency housing and shelter units in four years"

### Unit types counted
| Type | Description |
|------|-------------|
| Tiny homes | Individual or family units in village settings (e.g., LIHI villages) |
| Shelter beds | Traditional emergency shelter capacity |
| Acquired units | Hotel/motel conversions, scattered-site housing |

### Status definitions
| Status | Definition |
|--------|------------|
| Deployed | Currently operational and accepting residents |
| Ready but locked | Physically complete but not operational (regulatory, staffing, funding, or political barriers) |
| In construction | Under development with confirmed funding and timeline |

### Calculation
- Total progress = Deployed + Ready (Locked) + In Construction
- Progress percentage = Total / 4,000 × 100
- "People who could be sheltered" estimate assumes 3 people per unit average

### Limitations
- Unit counts compiled from multiple sources with different reporting standards
- "Ready but locked" status requires subjective determination from news reports
- Does not distinguish between new units and replacements for closed facilities

---

## Index 3: Homeless Overdose Deaths

### What it measures
Monthly overdose fatalities among people experiencing homelessness in King County.

### Why it matters
Approximately 67% of deaths among people experiencing homelessness in King County are overdose-related. This metric captures the direct mortality cost of inadequate housing and services.

### Data sources
- King County Medical Examiner via Public Health Seattle & King County
- Monthly reporting with 2-3 month lag for case verification

### Calculation
- Monthly counts from Medical Examiner data
- 12-month rolling average calculated to smooth seasonal variation
- Drug involvement (fentanyl, meth) tracked but categories are not mutually exclusive

### Limitations
- Housing status determined at death scene, may not capture all homeless individuals
- Data has 2-3 month reporting lag and may be revised
- Does not capture non-fatal overdoses

---

## Index 4: Cost Per Person Housed

### What it measures
The total cost of homelessness response divided by the number of successful permanent housing placements.

### Why it matters
Accountability requires measuring both spending levels AND outcomes. This metric shows efficiency of the overall system, not just inputs.

### Calculation
```
Cost per person = (City homelessness spending + KCRHA contribution) / Permanent housing placements
```

### Data sources
- **Numerator:** Seattle adopted budget (homelessness categories) + KCRHA operating budget
- **Denominator:** KCRHA System Performance Dashboard permanent housing placements

### Limitations
- Not all spending is intended to result in placements (includes prevention, outreach, administration)
- Placements in a given year may result from prior-year spending
- Does not account for returns to homelessness (though we track this separately)
- Category definitions may vary across budget years
- KCRHA contribution represents Seattle's share, not full regional spending

---

## General Notes

### Data currency
All data is manually curated from public sources. Update frequency:
- **Monthly:** Overdose deaths (with 2-3 month lag)
- **Quarterly:** Housing units, KCRHA estimates, placements
- **Annually:** Spending data, official PIT counts

### Mayoral transition dates
- **Bruce Harrell:** January 1, 2022
- **Katie Wilson:** January 1, 2026

### Transparency
All source data is available in the `data/` directory with full provenance (source URLs, retrieval dates). We welcome corrections and additional data sources via GitHub issues.
