# Seattle Mayoral Tracking Dashboard

## Deployment

Published to shinyapps.io:
- **App URL**: https://terwox.shinyapps.io/SeattleMayoralTracking/
- **Admin**: https://www.shinyapps.io/admin/#/application/16376595
- **App Name**: `SeattleMayoralTracking`

Deploy with:
```r
rsconnect::deployApp(appName='SeattleMayoralTracking', forceUpdate=TRUE)
```

## Data Updates

Data files are in `data/`. Key files:
- `pit_counts.csv` - Point-in-Time homeless counts (biennial)
- `spending.csv` - Budget data by category
- `housing_units.csv` - Tiny home storage/deployment tracking
- `overdose_deaths.csv` - King County overdose deaths

After updating data, update `retrieved_date` column and add notes to `data/README.md` update log.

## Architecture

- `app.R` - Main Shiny app (UI + server)
- `R/charts.R` - Plotly chart functions
- `R/data_load.R` - Data loading and summary functions
- `R/utils.R` - Utilities and methodology modal content

## Data Update Workflow

### Before Any Update
1. `git pull` to get latest
2. Check `data/README.md` update log for recent context

### Per-Metric Update Process

For EACH metric:

1. **Search** for latest data from authoritative source (see queries below)
2. **Compare** to current value in CSV
3. **If changed:**
   - Add new row to source CSV with `retrieved_date = today`
   - Add entry to `data/changelog.csv` with direction + attribution
   - Add narrative to `data/README.md` if notable
4. **Audit methodology modal** in `R/utils.R`:
   - Are the source URLs still valid?
   - Is the "what it measures" description still accurate?
   - Update change history section with old -> new values
   - Verify all "Verified Sources" links still work

### Attribution Rules

| Value | Definition |
|-------|------------|
| `harrell` | Action taken before 2026-01-06 (even if measured later) |
| `wilson` | Action initiated after 2026-01-06 |
| `external` | Federal, state, KCRHA, or non-mayoral cause |
| `prior` | Pre-Harrell historical data |

### Direction Values

| Value | Meaning |
|-------|---------|
| `increase_good` | More is better (e.g., deployed units) |
| `increase_bad` | More is worse (e.g., overdose deaths) |
| `decrease_good` | Less is better (e.g., homes in storage) |
| `decrease_bad` | Less is worse (e.g., budget cuts) |
| `neutral` | No value judgment |

### Update Search Queries by Metric

| Metric | Search Query |
|--------|--------------|
| PIT count | `site:kcrha.org point-in-time [year]` |
| Overdose | `site:kingcounty.gov overdose deaths [year]` |
| Spending | `site:seattle.gov budget homelessness [year]` |
| Tiny homes | `seattle tiny home village site:seattletimes.com` |
| Crime | `site:seattle.gov/police crime statistics` |
| HIC | `site:hudexchange.info housing inventory count` |

### After Updating
1. Deploy if ready: `rsconnect::deployApp(appName='SeattleMayoralTracking', forceUpdate=TRUE)`
2. Ship: `git add -A && git commit -m "Update data: [summary]" && git push`
