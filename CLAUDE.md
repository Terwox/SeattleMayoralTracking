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
