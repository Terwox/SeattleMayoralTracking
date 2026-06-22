# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Major Restructure: Spec v2 (2026-01-04)
- Reorganized entire dashboard around 5-beat narrative:
  1. **Promise** — 4,000 units by Jan 2030
  2. **Baseline** — Harrell claimed (~1,991) vs verified (~1,300)
  3. **Gimme** — 250 locked tiny homes as day-one test
  4. **Outcome** — Unsheltered PIT count (Wilson's own stated metric)
  5. **Efficiency Test** — Cost per bed/unit trends
- Added "Politics as Usual" vs "Stretch Goal" framing for 4K target
- Created secondary "Context" dashboard for demoted metrics
- Demoted to Context: crime/safety, overdose deaths, detailed spending, vouchers, HUD HIC breakdown
- Primary dashboard now fits single screen with clear narrative arc
- New spec file: `seattle-dashboard-spec_2.md`

### Added
- **Wilson's 4,000 Unit Baseline Card** - Shows what counts as "new" for accountability:
  - Harrell's dashboard claim: 1,991 units (crossed out)
  - Axios fact-check: <1,300 net new units after removing replacements and pre-Harrell projects
  - 194 units were replacements/relocations (not net new)
  - 556 units were from projects already underway before Harrell took office
  - New data file: `data/emergency_housing_baseline.csv`
  - Wilson's baseline starts at ZERO on Jan 6, 2026
- **Public Safety Card** - Crime statistics with homeless connection:
  - King County homicides (2023: 143, 2024: 120 - down 16%)
  - Seattle homicides (61 in 2024)
  - 2025 YTD trends (crime down 9.6%, violent crime down 20%)
  - Homeless-connected incidents: ~20% of shots-fired calls
  - New data file: `data/crime_stats.csv`
  - Chart function: `chart_homicides()`
- **Index 4: Cost Efficiency** - Two new visualization cards:
  - Shelter Operating Costs by type (congregate, enhanced, tiny home, hotel-based)
  - Housing Capital Costs trend (WSHFC statewide 2019-2025)
- New data files:
  - `data/cost_per_bed.csv` - Shelter operating and capital cost data
  - `data/placements.csv` - Quarterly placement tracking (placeholder for future data)
  - `data/emergency_housing_baseline.csv` - Harrell claimed vs actual baseline
- Mayoral transition vertical lines on PIT chart (Harrell 2022, Wilson 2026)
- Cost efficiency methodology modal explaining mean vs median choice
- Baseline methodology modal explaining why Wilson's count starts at zero
- New chart functions: `chart_shelter_costs()`, `chart_capital_trend()`
- Data loading functions: `load_cost_per_bed()`, `load_placements()`, `get_cost_summary()`, `load_emergency_baseline()`, `get_baseline_summary()`

### Changed
- Refactored Index 4 from "Cost Per Person Housed" to "Cost Efficiency (Cost per Bed / Cost per Unit)"
- Now tracks mean cost per shelter bed (operating) and per housing unit (capital) separately
- Added Data Source 4a documenting cost derivation methodology
- Clarified mean vs median choice: mean captures total budget efficiency for accountability
- PIT chart now shows mayoral transition markers with labels
- Improved Plotly tooltips: removed underscore artifacts, cleaned up hover text formatting

### Data
- Verified cost ranges: shelter operating $16K-$127K/bed; housing capital $270K-$500K/unit
- WSHFC statewide trend data showing +96% capital cost increase (2019-2025)
- Documentation of manual compilation requirement (no single official source exists)

### Removed
- Dropped unverified $800K→$400K cost reduction claim

## [0.1.0] - 2026-01-03

### Added
- Initial release of Seattle Mayoral Accountability Dashboard
- Four primary index cards:
  - Unsheltered Population Count with time series visualization
  - Emergency Housing Progress with stacked progress bar
  - Homeless Overdose Deaths with area chart and rolling average
  - Cost Per Person Housed with bar chart
- Seed data covering:
  - PIT counts: 2015-2025
  - Housing units: Current snapshot with status breakdown
  - Overdose deaths: 2020-2025 monthly
  - Spending: 2014-2025 annual
  - Placements: 2020-2025 quarterly
- Methodology modals for each index
- Data gaps section highlighting unavailable metrics
- Mobile-responsive layout
- Custom CSS styling with professional color palette
- Full documentation (methodology, sources, data dictionary)

### Data Sources
- HUD Exchange PIT counts
- KCRHA data overview and dashboards
- King County Public Health overdose data
- Seattle Budget Office

---

## Data Update Log

### 2026-01-03
- Initial seed data loaded from public sources
- All data verified against source documents
- Retrieved dates documented in each CSV

---

## How to Log Updates

When updating data, add an entry below with:
- Date of update
- Which CSV files were modified
- Source of new data
- Any methodology notes

Example:
```
### 2026-02-15
- Updated overdose_deaths.csv with November 2025 data
- Source: King County Public Health dashboard
- Note: October 2025 figures revised upward by 3
```
