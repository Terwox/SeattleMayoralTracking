# Seattle Mayoral Accountability Dashboard

A public-facing dashboard tracking Seattle Mayor Katie Wilson's performance on homelessness, designed to create accountability through transparent measurement of promises vs. outcomes.

## Live Dashboard

[View the dashboard on shinyapps.io](https://your-username.shinyapps.io/seattle-mayor-dashboard/) *(deploy link)*

## What This Tracks

### Primary Indices

1. **The Promise** - Progress toward 4,000 new emergency housing and shelter units
   - Wilson's commitment: "4,000 new emergency housing and shelter units in four years"
   - Shows the reported four-year pledge separately from the official 2026 package

2. **The Baseline** - Reconciles inherited claims against stricter net-new counting
   - Inferred from public reporting, not an official city baseline
   - Separates replacement, pre-existing, and Wilson-era operational capacity

3. **The Gimme** - Reported deployable tiny-home capacity blocked by sites and operations
   - Uses reported evidence because no official stored-unit dashboard exists
   - Distinguishes capital-ready from operational

4. **The Outcome** - King County unsheltered PIT proxy
   - Uses official PIT/HIC counts, with methodology caveats
   - Not a Seattle-only street count and not a causal policy measure

5. **The Efficiency Test** - Cost pressure across shelter beds and housing units
   - Inferred comparison from heterogeneous public cost sources
   - Not a clean cost-per-person-housed denominator

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
│   ├── overdose_deaths.csv  # Annual King County overdose totals
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

- **Annually/as released:** King County overdose totals
- **As reported:** Housing units, placements, and policy changes
- **When released:** Spending data and official PIT/HIC counts

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

- **Evidence-labeled data** - Readers can see what is official, reported, inferred, or missing
- **Confrontational through transparency** - Sharp accountability with visible claim boundaries
- **Mobile-friendly** - Designed for quick checks on phones
- **Sober, professional tone** - This is a tool, not a campaign site

## License

MIT License - See [LICENSE](LICENSE) for details.

## Acknowledgments

- Data sources: HUD Exchange, KCRHA, King County Public Health, Seattle Budget Office
- Built with R Shiny, bslib, and plotly
