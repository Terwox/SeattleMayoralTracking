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
| unsheltered | integer | People sleeping outside (NA only when a source does not report it) |
| sheltered | integer | People in shelters (NA only when a source does not report it) |
| source | string | Data source name |
| source_url | string | URL to source or repo-local source-note path |
| retrieved_date | date | Date data was retrieved |

**Notes:** The dashboard uses official full PIT counts as the benchmark. KCRHA's 2022, 2024, and 2026 counts use respondent-driven sampling and are not directly comparable to pre-2022 methodology. No comparable quarterly unsheltered estimate series is used here.

### housing_units.csv
Emergency housing and shelter unit inventory.

| Field | Type | Description |
|-------|------|-------------|
| date | date | Date of record |
| unit_type | enum | tiny_home, shelter_bed, or acquired_unit |
| status | enum | locked_in_storage, announced_deployment, deployed_wilson, executive_order, proposed_west_seattle, confirmed_west_seattle, or wilson_legislation_target |
| count | integer | Number of units |
| notes | string | Context and counting caveats |
| source | string | Source name |
| source_url | string | URL to source or repo-local source-note path |
| retrieved_date | date | Date data was retrieved |

### overdose_deaths.csv
Annual overdose fatalities in King County.

| Field | Type | Description |
|-------|------|-------------|
| year | integer | Calendar year |
| total_overdose_deaths | integer | All overdose deaths in county |
| source | string | Data source name |
| source_url | string | URL to source or repo-local source-note path |
| retrieved_date | date | Date data was retrieved |

**Notes:** This file does not contain homeless-specific overdose deaths. The dashboard treats that as a public-data gap rather than inferring a subgroup count.

### spending.csv
Annual homelessness-related spending.

| Field | Type | Description |
|-------|------|-------------|
| fiscal_year | integer | Fiscal year |
| category | enum | city_homelessness or kcrha_contribution |
| amount | integer | Dollar amount |
| source | string | Data source name |
| source_url | string | URL to source or repo-local source-note path |
| retrieved_date | date | Date data was retrieved |

### placements.csv
Quarterly permanent housing placements.

| Field | Type | Description |
|-------|------|-------------|
| quarter | string | Quarter (YYYY-QN format) |
| permanent_housing_placements | integer | Number of placements |
| returns_to_homelessness | integer | Returns within 12 months |
| source_url | string | URL to source or repo-local source-note path |
| retrieved_date | date | Date data was retrieved |

## Data Sources

- **HUD Exchange:** https://www.hudexchange.info/programs/coc/coc-homeless-populations-and-subpopulations-reports/
- **KCRHA:** https://kcrha.org/data-overview/
- **King County Public Health:** https://kingcounty.gov/dph/overdose
- **Seattle Budget Office:** https://www.seattle.gov/city-budget-office
- **Seattle Performance Dashboard:** https://performance.seattle.gov/

## Update Schedule

- **Monthly:** Overdose deaths (with 2-3 month lag)
- **As reported:** Housing units, placements, and policy changes
- **When released:** Spending data and official PIT/HIC counts

## Update Log

### 2026-06-27

Methodology and data-framing update:

- **Official 2026 PIT/HIC values added:** KCRHA's 2026 initial report records **18,365** total people experiencing homelessness in King County: **11,829 unsheltered** and **6,536 sheltered**. This replaces the prior placeholder row.
- **Evidence tiers added:** Primary dashboard beats now distinguish official, reported, inferred, and gap claims at point of use.
- **Methodology tightened:** Baseline and cost-efficiency cards are now framed as inferred calculations/signals rather than official counts or clean cost-per-person outcomes.
- **Source docs corrected:** Removed stale language implying KCRHA quarterly homeless estimates are available for this dashboard.

### 2026-04-30

Q1 2026 sweep (76 days since last refresh):

- **Crime stats correction:** SPD Year in Review (Feb 2 2026) put 2025 Seattle homicides at **37** — not 25 as previously recorded from a Center Square mid-count projection. Overall crime fell 18% (also revised from -23% projection). Added gunfire (-36% victims), stolen vehicles (-24%), burglaries (-18%), and firearm recoveries (1,500, +74%).
- **Wilson EO follow-up landed:** March 4 "Neighbor by Neighbor" legislation announced — 1,000-unit shelter target for 2026; $4.8M reallocated ($3.3M revolving loan + $1.5M dormant Downtown Health fund); per-site cap raised 100→150, with 250-per-district allowed; FAS Director gets direct lease-signing authority. Mayor's office cited LA as the model for larger villages (April 2026 community briefing).
- **First Wilson-era village deployed:** Olympic Hills (Lake City, 3121 NE 133rd St) opened February 2026 — 45 units, 24/7 staffing, LIHI + PDA partnership.
- **West Seattle site officially announced** in Feb (was a January proposal); religious sponsor revealed.
- **HUD funding gap firmed up:** NOFO max confirmed at $19M (71% cut from typical $65M). King County Councilmember Mosqueda's amendment acknowledged the gap at "at least $36M" and asked for a March supplemental reserve.
- **Health Through Housing milestone:** >1,000 formerly homeless KC residents now housed. Booker House opened Jan 2026 in South KC; Sweetgrass Flats (Chief Seattle Club, 84 PSH units) leasing up Q1 2026; 100 more PSH units anticipated Q4 2026.
- **PIT 2026 status at that time:** count complete (Jan 26-Feb 6), before report release. Superseded by the 2026-06-27 update above.
- **Overdose 2025:** 908 confirmed final (no change); 13.3% drop from 2024's 1,047, 32.2% drop from 2023 peak of 1,340.

### 2026-01-30

- **Crime stats:** Added 2025 year-end data - Seattle homicides down to ~25 (53% decline from 2024), total crime projected down 23%
- **Health Through Housing:** Major update with 2025 data release - 1,900 cumulative served, 954 units open, 480 in development, $33K/year operating cost
- **Housing vouchers:** Added SHA 2025 portfolio (37,495 individuals, 8,114 vouchers, 8,777 units); EHV funding ending 2026; KCHA waitlist still closed
- **Tiny home villages:** West Seattle combined RV/THV proposal on state land; Raven Village (Ballard) LIHI/Chief Seattle Club; LIHI requesting 6 more villages; 18 total LIHI villages
- **PIT count:** Updated to UNDERWAY status (started Jan 26); uses respondent-driven sampling with UW
- **KCRHA budget:** Revised total to $199M (was $205M); budget vote still pending due to board quorum issues
- **Housing units:** Added West Seattle proposal

### 2026-01-19

- **Wilson executive order:** Added Jan 15 EO to accelerate shelter/housing - interdepartmental team to identify sites, recommendations due March 2026. No specific targets or funding yet.
- **KCRHA layoffs:** Added 2025 layoff data - 13 employees laid off (22% staff reduction) due to $4.7M budget shortfall
- **PIT count 2026:** Count scheduled to begin Jan 26 (next week)

### 2026-01-09

- **Overdose deaths:** Confirmed 2025 final count (908) with context on decline factors
- **Housing units:** Updated tiny home storage estimate (~150 remaining after 104 Harrell-announced LIHI units); this is an inferred estimate from a reported baseline, not an official inventory
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
