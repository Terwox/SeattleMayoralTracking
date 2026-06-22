# Data Sources

Complete list of data sources used in the Seattle Mayoral Accountability Dashboard.

## Official Government Sources

### HUD Exchange
- **URL:** https://www.hudexchange.info/programs/coc/coc-homeless-populations-and-subpopulations-reports/
- **Data:** Point-in-Time homeless population counts (biennial)
- **Format:** PDF reports, manually extracted
- **Update frequency:** Every two years (odd years)

### King County Regional Homelessness Authority (KCRHA)
- **URL:** https://kcrha.org/data-overview/
- **Data:**
  - Quarterly homeless population estimates
  - Annual PIT count coordination
  - Housing placements and system performance
- **Format:** Dashboard, PDF reports
- **Update frequency:** Quarterly

### Seattle Performance Dashboard
- **URL:** https://performance.seattle.gov/
- **Data:** City homelessness metrics, shelter capacity
- **Format:** Online dashboard
- **Update frequency:** Varies by metric

### King County Public Health - Overdose Dashboard
- **URL:** https://kingcounty.gov/dph/overdose
- **Data:** Overdose deaths by month, housing status, drug type
- **Format:** Downloadable CSV, dashboard
- **Update frequency:** Monthly (2-3 month lag)

### Seattle Budget Office
- **URL:** https://www.seattle.gov/city-budget-office
- **Data:** Annual homelessness-related spending
- **Format:** Budget documents (PDF)
- **Update frequency:** Annual (with mid-year supplementals)

## Secondary Sources

### Seattle Times
- **URL:** https://www.seattletimes.com/
- **Data:** News reporting on shelter openings, delays, policy changes
- **Usage:** Verification of "ready but locked" status, context

### Publicola
- **URL:** https://publicola.com/
- **Data:** Local journalism on homelessness policy
- **Usage:** Context, policy analysis

## Data Quality Notes

### Verification process
1. Primary data pulled from official government sources when available
2. Cross-referenced with news reporting for accuracy
3. All entries include source URL and retrieval date
4. Changes logged in CHANGELOG.md

### Known limitations
- PIT count methodology changed in 2022
- Quarterly estimates use different methodology than official counts
- Overdose data has inherent reporting lag
- Housing unit counts may not align between sources due to different definitions

### Contributing data
If you have access to official data not reflected here, please open a GitHub issue with:
1. Data source and URL
2. Date range covered
3. Any methodology notes
4. Your relationship to the data (if relevant)

## API Access

Currently, all data is manually extracted. No official APIs are available for:
- Real-time shelter availability
- Individual-level outcomes tracking
- Daily/weekly updates

If King County or Seattle opens API access to these datasets, we will integrate them.
