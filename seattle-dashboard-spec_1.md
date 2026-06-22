# Seattle Mayoral Accountability Dashboard — Technical Spec

## Project Overview

**Purpose:** Public-facing dashboard tracking Seattle Mayor Katie Wilson's performance on homelessness, designed to create accountability through transparent measurement of promises vs. outcomes.

**Target Audience:** 
- Primary: Mayor Wilson's office and city officials (accountability use case)
- Secondary: Engaged Seattle residents, journalists, advocates

**Design Philosophy:** 
- Data speaks for itself—minimal editorializing, maximum clarity
- Confrontational through transparency, not rhetoric
- Mobile-friendly (council members checking on phones)

---

## Technical Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Framework | **R Shiny** or **Python Shiny** (implementer's choice) | Rapid development, good for data-heavy dashboards |
| Hosting | **shinyapps.io** (free tier) or **Posit Connect** | Easy deployment, no server management |
| Data storage | **CSV/Parquet files in repo** | Transparency, version control, no database overhead |
| Version control | **GitHub** (public repo) | Open source requirement |
| Styling | **bslib** with minimal custom CSS | Clean, professional, not flashy |

---

## Data Sources

### 1. Point-in-Time Count (Unsheltered Population)
- **Source:** KCRHA annual reports + HUD Exchange
- **URL:** https://kcrha.org/data-overview/ and https://www.hudexchange.info/programs/coc/coc-homeless-populations-and-subpopulations-reports/
- **Frequency:** Biennial (January of odd years), but KCRHA publishes quarterly encampment estimates
- **Format:** Manual entry from PDF reports → CSV
- **Fields:** `date`, `total_homeless`, `unsheltered`, `sheltered`, `source`

### 2. Emergency Housing Units
- **Source:** City budget documents, KCRHA dashboard, news reports
- **URL:** https://performance.seattle.gov/, KCRHA Households Served Dashboard
- **Frequency:** Quarterly updates
- **Format:** Manual curation → CSV
- **Fields:** `date`, `unit_type` (tiny_home | shelter_bed | acquired_unit), `status` (deployed | ready_locked | construction), `count`, `location`, `operator`, `source_url`

### 3. Overdose Deaths (Homeless Population)
- **Source:** King County Medical Examiner, Public Health Seattle & King County
- **URL:** https://kingcounty.gov/dph/overdose
- **Frequency:** Monthly (with 2-3 month lag)
- **Format:** Downloadable CSV or manual extraction
- **Fields:** `month`, `total_overdose_deaths`, `homeless_overdose_deaths`, `fentanyl_involved`, `meth_involved`

### 4. Spending Data
- **Source:** Seattle adopted budget, KCRHA budget
- **URL:** City of Seattle Budget Office
- **Frequency:** Annual (with mid-year supplementals)
- **Format:** Manual extraction → CSV
- **Fields:** `fiscal_year`, `category`, `amount`, `source`

### 4a. Cost Per Bed/Unit (Derived Metric)
- **What:** Mean annual operating cost per shelter bed; mean capital cost per housing unit
- **Why mean, not median:** For budget accountability, mean captures total spend efficiency. Median would underweight expensive outliers that still drain the budget.
- **Known ranges (2024-2025):**
  - Shelter operating: $16,000–$127,000/bed/year (8x variation by type—congregate cheapest, tiny homes most expensive per bed)
  - Housing capital: $270,000–$500,000/unit (HTH acquisitions ~$270K; new construction ~$400K+)
  - WSHFC statewide trend: $207K/unit (2019) → $406K/unit (2025), +95.8% over 6 years
- **Data gap:** No single official source provides consistent year-over-year per-bed cost comparisons across shelter types. Must manually combine:
  1. KCRHA annual budget by program type (kcrha.org board packets)
  2. King County Health Through Housing reports (kingcounty.gov)
  3. Seattle HSD shelter contracts (via public records or budget backup)
  4. WSHFC Annual Activity Reports for capital cost trends (wshfc.org)
- **Methodology note:** Total budget by shelter category ÷ reported bed counts = cost/bed. This conflates bed-count changes with cost changes, so track both independently.
- **Fields:** `fiscal_year`, `shelter_type`, `total_budget`, `bed_count`, `cost_per_bed`, `source_documents`

### 5. Housing Placements (for cost-per-person calculation)
- **Source:** KCRHA System Performance Dashboard
- **URL:** https://kcrha.org/data-overview/
- **Frequency:** Quarterly
- **Format:** Manual extraction → CSV
- **Fields:** `quarter`, `permanent_housing_placements`, `returns_to_homelessness`

---

## Index Definitions

### Primary Indices (Landing Page)

#### Index 1: Unsheltered Population Count
- **What it measures:** People sleeping outside in Seattle
- **Wilson's commitment:** "How many people are sleeping unsheltered on the streets of Seattle in four years"
- **Visualization:** Time series line chart
- **Key elements:**
  - Vertical reference lines at mayoral transitions (Harrell: Jan 2022, Wilson: Jan 2026)
  - Dual data series: official PIT count (dots, biennial) + KCRHA quarterly estimates (line)
  - Y-axis starts at 0
  - Annotation showing % change since Wilson took office

#### Index 2: Emergency Housing Progress (to 4,000)
- **What it measures:** Progress toward Wilson's 4,000-unit commitment
- **Wilson's commitment:** "4,000 new emergency housing and shelter units in four years"
- **Visualization:** Stacked progress bar + decomposition table
- **Key elements:**
  - Main progress bar: current total vs. 4,000 target
  - Breakdown showing:
    - `Deployed` (currently operational)
    - `Ready but locked` ← HIGHLIGHTED with "WHY?" link
    - `In construction`
  - Sub-text: "250 locked units ≈ 750 people who could be sheltered tonight"
  - Time series below showing unit additions over time

#### Index 3: Homeless Overdose Deaths
- **What it measures:** Monthly overdose fatalities among homeless population
- **Why it matters:** Direct mortality cost of inadequate services; 67% of homeless deaths are overdose
- **Visualization:** Time series area chart
- **Key elements:**
  - Monthly data with 12-month rolling average overlay
  - Vertical reference lines at mayoral transitions
  - Breakout by drug type available on hover/click

#### Index 4: Cost Efficiency (Cost per Bed / Cost per Unit)
- **What it measures:** Mean cost per shelter bed (operating) and per housing unit (capital)
- **Why it matters:** Tests whether Wilson can reduce costs while increasing supply—currently Seattle's numbers are poor relative to peer cities
- **Visualization:** Dual bar chart by year (operating vs. capital costs) + trend lines
- **Key elements:**
  - Cost per shelter bed by type (congregate, enhanced, tiny home, hotel-based)
  - Cost per housing unit (HTH acquisition vs. new construction)
  - Comparison: WSHFC statewide trends showing capital cost inflation
  - Wilson accountability: Can she bend these curves down while adding units?
- **Data note:** Requires annual manual compilation from multiple sources (see Data Sources 4a). No official year-over-year comparison exists.

### Secondary Indices (Accessible via tabs or scroll)

#### Index 5: Data Gaps
- **What it measures:** Metrics we SHOULD track but can't
- **Why it matters:** Absence of data is itself an accountability issue
- **Visualization:** Simple table/cards
- **Items to flag:**
  - Time-to-housing (Built for Zero benchmark: ≤45 days) — not publicly reported
  - Sweeps without housing offers — requires FOIA or manual news tracking
  - Return-to-homelessness rate — HUD-required but not prominently published
  - Real-time shelter bed availability — exists internally, not public

---

## UI/UX Specification

### Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  SEATTLE MAYORAL ACCOUNTABILITY: HOMELESSNESS                   │
│  Tracking Mayor Wilson's commitments with public data           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ UNSHELTERED POPULATION                          [?]     │   │
│  │ [time series chart]                                     │   │
│  │ Current: 9,847  |  Change since Jan 2026: --           │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ EMERGENCY HOUSING PROGRESS                      [?]     │   │
│  │ [███████░░░░░░░░░░░░░░░░░░░░░░░░] 847 / 4,000          │   │
│  │                                                         │   │
│  │   Deployed:           597 units                         │   │
│  │   Ready but locked:   250 units  ← WHY ARE THESE       │   │
│  │   In construction:     38 units     LOCKED UP?         │   │
│  │                                                         │   │
│  │ 250 locked units ≈ 750 people who could be sheltered   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────┐ ┌──────────────────────────┐     │
│  │ OVERDOSE DEATHS          │ │ COST EFFICIENCY          │     │
│  │ [area chart]             │ │ [dual bar chart]         │     │
│  │ 2025 YTD: 247            │ │ $47K/bed  |  $312K/unit  │     │
│  └──────────────────────────┘ └──────────────────────────┘     │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│  DATA GAPS: What we can't track (but should)           [more]  │
├─────────────────────────────────────────────────────────────────┤
│  METHODOLOGY  |  DATA SOURCES  |  GITHUB  |  LAST UPDATED      │
└─────────────────────────────────────────────────────────────────┘
```

### Interactions
- **[?] buttons:** Expand to show methodology, data source, Wilson's exact quote/commitment
- **"WHY ARE THESE LOCKED UP?":** Links to Seattle Times article and explainer
- **Charts:** Hover for exact values; click to expand full-screen
- **Mobile:** Stack all cards vertically; progress bar and charts scale responsively

### Visual Design
- **Color palette:** Muted, professional. No partisan colors.
  - Primary: Dark slate (#2d3748)
  - Accent: Teal (#319795) for positive/progress
  - Alert: Amber (#d69e2e) for the "locked units" callout
  - Negative: Muted red (#c53030) for deaths/regression
- **Typography:** System fonts, no custom fonts needed
- **Tone:** Sober, data-forward. This is a tool, not a campaign site.

---

## Data Update Workflow

Since data requires manual curation (no live APIs), the workflow is:

1. **Monthly:** Check King County overdose dashboard, update `data/overdose_deaths.csv`
2. **Quarterly:** Check KCRHA dashboards, update housing units and placements CSVs
3. **As needed:** Monitor news for tiny home deployments, policy changes
4. **Annually:** Update spending data from adopted budget

Each CSV should have a `source_url` and `retrieved_date` column for transparency.

Consider adding a `CHANGELOG.md` documenting each data update.

---

## File Structure

```
seattle-mayor-dashboard/
├── app.R (or app.py)           # Main Shiny application
├── R/ (or src/)
│   ├── data_load.R             # Functions to load and validate CSVs
│   ├── charts.R                # Reusable chart components
│   └── utils.R                 # Helper functions
├── data/
│   ├── pit_counts.csv
│   ├── housing_units.csv
│   ├── overdose_deaths.csv
│   ├── spending.csv
│   ├── placements.csv
│   └── README.md               # Data dictionary
├── www/
│   └── custom.css              # Minimal custom styling
├── docs/
│   ├── methodology.md          # Detailed methodology for each index
│   └── sources.md              # Full source list with URLs
├── CHANGELOG.md
├── README.md
└── LICENSE                     # MIT or similar
```

---

## Seed Data

Create initial CSVs with historical data to enable the time series visualizations. Minimum viable:

- **PIT counts:** 2015-2024 (biennial)
- **Housing units:** Current snapshot + any historical if findable
- **Overdose deaths:** 2020-2025 monthly
- **Spending:** 2014-2025 annual
- **Placements:** 2020-2025 quarterly

This provides ~10 years of context to show trendlines across multiple administrations.

---

## MVP Scope

**For v0.1 (MVP):**
- [ ] Landing page with 4 primary index cards
- [ ] Static seed data (no live updates yet)
- [ ] Basic interactivity (hover values, expand methodology)
- [ ] Mobile-responsive layout
- [ ] Deployed to shinyapps.io
- [ ] Public GitHub repo with README

**Deferred to v0.2+:**
- [ ] Data gaps section
- [ ] Downloadable data exports
- [ ] Embeddable widgets for journalists
- [ ] Email alerts on data updates
- [ ] Comparison to other cities

---

## Success Criteria

The dashboard succeeds if:
1. A city council staffer can check progress on their phone in 30 seconds
2. A journalist can find sourced data and methodology for a story
3. The "ready but locked" callout is immediately visible and comprehensible
4. Wilson's team could plausibly use this to track their own progress (even if they won't admit it)

---

## Notes for Implementation

- **Don't over-engineer.** This is a side project. Perfect is the enemy of deployed.
- **Seed data is the hard part.** Budget time for manual data entry and source verification.
- **The "locked units" callout is the rhetorical core.** Make sure it's visually prominent without being garish.
- **Vertical reference lines on time series are essential.** They're the whole point—showing mayoral transitions.
- **Include uncertainty where relevant.** PIT counts are estimates with known methodology limitations. Say so.
