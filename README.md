# Seattle Mayoral Accountability Dashboard

A public-facing dashboard tracking Seattle Mayor Katie Wilson's performance on homelessness, designed to create accountability through transparent measurement of promises vs. outcomes.

## Live Dashboard

[View the dashboard on shinyapps.io](https://your-username.shinyapps.io/seattle-mayor-dashboard/) *(deploy link)*

## What This Tracks

### Primary Indices

1. **Unsheltered Population Count** - People sleeping outside in Seattle
   - Wilson's commitment: Track unsheltered count over four years
   - Data: HUD PIT counts (biennial) + KCRHA quarterly estimates

2. **Emergency Housing Progress** - Progress toward 4,000 units
   - Wilson's commitment: "4,000 new emergency housing and shelter units in four years"
   - Highlights units that are "ready but locked"

3. **Homeless Overdose Deaths** - Monthly fatalities among homeless population
   - ~67% of homeless deaths in King County are overdose-related
   - Includes 12-month rolling average

4. **Cost Per Person Housed** - Spending efficiency metric
   - Total spending divided by successful permanent housing placements

## Running Locally

### Prerequisites

- R 4.0+
- Required packages:

```r
install.packages(c("shiny", "bslib", "plotly", "dplyr", "readr", "lubridate", "zoo", "scales"))
```

### Run the app

```r
# From the project directory
shiny::runApp()
```

Or open `app.R` in RStudio and click "Run App".

## Project Structure

```
seattle-mayor-dashboard/
├── app.R                    # Main Shiny application
├── R/
│   ├── data_load.R          # Data loading and validation
│   ├── charts.R             # Chart components
│   └── utils.R              # Helper functions
├── data/
│   ├── pit_counts.csv       # Point-in-Time counts
│   ├── housing_units.csv    # Emergency housing inventory
│   ├── overdose_deaths.csv  # Monthly overdose data
│   ├── spending.csv         # Annual spending
│   ├── placements.csv       # Housing placements
│   └── README.md            # Data dictionary
├── www/
│   └── custom.css           # Custom styling
├── docs/
│   ├── methodology.md       # Index calculation methodology
│   └── sources.md           # Full source list
├── CHANGELOG.md
├── README.md
└── LICENSE
```

## Data Updates

Data requires manual curation (no live APIs available). Update schedule:

- **Monthly:** Overdose deaths (with 2-3 month lag)
- **Quarterly:** Housing units, placements, KCRHA estimates
- **Annually:** Spending data, official PIT counts

See [docs/sources.md](docs/sources.md) for full source list.

## Contributing

Contributions welcome! Please:

1. Open an issue to discuss proposed changes
2. Submit PRs with clear descriptions
3. Include source URLs for any data additions
4. Update CHANGELOG.md

### Data contributions

If you have access to official data not currently tracked (especially real-time shelter availability or time-to-housing metrics), please open an issue.

## Design Philosophy

- **Data speaks for itself** - Minimal editorializing, maximum clarity
- **Confrontational through transparency** - Not rhetoric
- **Mobile-friendly** - Designed for quick checks on phones
- **Sober, professional tone** - This is a tool, not a campaign site

## License

MIT License - See [LICENSE](LICENSE) for details.

## Acknowledgments

- Data sources: HUD Exchange, KCRHA, King County Public Health, Seattle Budget Office
- Built with R Shiny, bslib, and plotly
