# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

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
