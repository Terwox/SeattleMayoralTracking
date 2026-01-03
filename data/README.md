# Data Dictionary

This directory contains the seed data for the Seattle Mayoral Accountability Dashboard.

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
