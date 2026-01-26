# Data Dictionary

This directory contains the seed data for the Seattle Mayoral Accountability Dashboard.

## Change Tracking

Two files track data changes:

- **`changelog.csv`** - Structured change log (machine-readable). Records what changed, old/new values, direction (good/bad), and attribution (Harrell/Wilson/external).
- **Update Log** (below) - Narrative context for each update session.

See `CLAUDE.md` for the full update workflow.

## Files

### pit_counts.csv
Point-in-Time homeless population counts.

| Field | Type | Description |
|-------|------|-------------|
| date | date | Date of count (YYYY-MM-DD) |
| total_homeless | integer | Total homeless population |
| unsheltered | integer | People sleeping outside (NA for quarterly estimates) |
| sheltered | integer | People in shelters (NA for quarterly estimates) |
| source | string | Data source name |
| source_url | string | URL to source |
| retrieved_date | date | Date data was retrieved |

**Notes:** Official HUD PIT counts are biennial (odd years). KCRHA publishes quarterly estimates that may use different methodology.

### housing_units.csv
Emergency housing and shelter unit inventory.

| Field | Type | Description |
|-------|------|-------------|
| date | date | Date of record |
| unit_type | enum | tiny_home, shelter_bed, or acquired_unit |
| status | enum | deployed, ready_locked, or construction |
| count | integer | Number of units |
| location | string | General location |
| operator | string | Operating organization |
| source_url | string | URL to source |
| retrieved_date | date | Date data was retrieved |

### overdose_deaths.csv
Monthly overdose fatalities in King County.

| Field | Type | Description |
|-------|------|-------------|
| month | date | First day of month (YYYY-MM-DD) |
| total_overdose_deaths | integer | All overdose deaths in county |
| homeless_overdose_deaths | integer | Deaths among homeless population |
| fentanyl_involved | integer | Deaths involving fentanyl |
| meth_involved | integer | Deaths involving methamphetamine |
| source_url | string | URL to source |
| retrieved_date | date | Date data was retrieved |

**Notes:** Data has 2-3 month reporting lag. Numbers may be revised.

### spending.csv
Annual homelessness-related spending.

| Field | Type | Description |
|-------|------|-------------|
| fiscal_year | integer | Fiscal year |
| category | enum | city_homelessness or kcrha_contribution |
| amount | integer | Dollar amount |
| source | string | Data source name |
| source_url | string | URL to source |
| retrieved_date | date | Date data was retrieved |

### placements.csv
Quarterly permanent housing placements.

| Field | Type | Description |
|-------|------|-------------|
| quarter | string | Quarter (YYYY-QN format) |
| permanent_housing_placements | integer | Number of placements |
| returns_to_homelessness | integer | Returns within 12 months |
| source_url | string | URL to source |
| retrieved_date | date | Date data was retrieved |

## Data Sources

- **HUD Exchange:** https://www.hudexchange.info/programs/coc/coc-homeless-populations-and-subpopulations-reports/
- **KCRHA:** https://kcrha.org/data-overview/
- **King County Public Health:** https://kingcounty.gov/dph/overdose
- **Seattle Budget Office:** https://www.seattle.gov/city-budget-office
- **Seattle Performance Dashboard:** https://performance.seattle.gov/

## Update Schedule

- **Monthly:** Overdose deaths (with 2-3 month lag)
- **Quarterly:** Housing units, placements, KCRHA estimates
- **Annually:** Spending data, official PIT counts (odd years only)

## Update Log

### 2026-01-19

- **Wilson executive order:** Added Jan 15 EO to accelerate shelter/housing - interdepartmental team to identify sites, recommendations due March 2026. No specific targets or funding yet.
- **KCRHA layoffs:** Added 2025 layoff data - 13 employees laid off (22% staff reduction) due to $4.7M budget shortfall
- **PIT count 2026:** Count scheduled to begin Jan 26 (next week)

### 2026-01-09

- **Overdose deaths:** Confirmed 2025 final count (908) with context on decline factors
- **Housing units:** Updated tiny home storage estimates (~150 remaining after LIHI deployments and Tacoma transfer)
- **Spending:** Added 2026 budget data including federal funding crisis:
  - $40M gap from HUD CoC rule changes (30% cap on permanent housing funds)
  - ~4,500 households at risk
  - City set aside $21.1M reserve and PAUSED shelter expansion
  - KCRHA facing $4.7M shortfall with hiring freeze
- **PIT counts:** Added 2026 count dates (Jan 26 - Feb 6)
- **Context:** Wilson administration "scoping sites" for new villages but no deployments announced yet

### 2026-01-03/04

- Initial data load for dashboard launch
- Established Wilson baseline (0 units deployed as of inauguration)
