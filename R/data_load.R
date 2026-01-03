# Data Loading and Validation Functions
# Seattle Mayoral Accountability Dashboard

library(readr)
library(dplyr)
library(lubridate)

# Load PIT counts data
load_pit_counts <- function(path = "data/pit_counts.csv") {
  df <- read_csv(path, col_types = cols(
    date = col_date(),
    total_homeless = col_integer(),
    unsheltered = col_integer(),
    sheltered = col_integer(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  df <- df %>%
    arrange(date) %>%
    mutate(
      is_official_pit = grepl("HUD|Annual", source),
      year = year(date)
    )

  return(df)
}

# Load housing units data
load_housing_units <- function(path = "data/housing_units.csv") {
  df <- read_csv(path, col_types = cols(
    date = col_date(),
    unit_type = col_character(),
    status = col_character(),
    count = col_integer(),
    location = col_character(),
    operator = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  df <- df %>%
    arrange(date, unit_type, status)

  return(df)
}

# Load overdose deaths data
load_overdose_deaths <- function(path = "data/overdose_deaths.csv") {
  df <- read_csv(path, col_types = cols(
    month = col_date(),
    total_overdose_deaths = col_integer(),
    homeless_overdose_deaths = col_integer(),
    fentanyl_involved = col_integer(),
    meth_involved = col_integer(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  df <- df %>%
    arrange(month) %>%
    mutate(
      year = year(month),
      month_num = month(month),
      # Calculate 12-month rolling average
      rolling_avg = zoo::rollmean(homeless_overdose_deaths, k = 12, fill = NA, align = "right")
    )

  return(df)
}

# Load spending data
load_spending <- function(path = "data/spending.csv") {
  df <- read_csv(path, col_types = cols(
    fiscal_year = col_integer(),
    category = col_character(),
    amount = col_double(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  # Aggregate total spending by year
  spending_by_year <- df %>%
    group_by(fiscal_year) %>%
    summarise(
      total_spending = sum(amount),
      city_spending = sum(amount[category == "city_homelessness"]),
      kcrha_spending = sum(amount[category == "kcrha_contribution"]),
      .groups = "drop"
    )

  return(list(raw = df, by_year = spending_by_year))
}

# Load placements data
load_placements <- function(path = "data/placements.csv") {
  df <- read_csv(path, col_types = cols(
    quarter = col_character(),
    permanent_housing_placements = col_integer(),
    returns_to_homelessness = col_integer(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  df <- df %>%
    mutate(
      year = as.integer(substr(quarter, 1, 4)),
      q = as.integer(substr(quarter, 7, 7))
    ) %>%
    arrange(year, q)

  # Aggregate by year
  placements_by_year <- df %>%
    group_by(year) %>%
    summarise(
      total_placements = sum(permanent_housing_placements),
      total_returns = sum(returns_to_homelessness),
      return_rate = total_returns / total_placements,
      .groups = "drop"
    )

  return(list(raw = df, by_year = placements_by_year))
}

# Calculate cost per person housed
calculate_cost_per_person <- function(spending, placements) {
  cost_data <- spending$by_year %>%
    inner_join(placements$by_year, by = c("fiscal_year" = "year")) %>%
    mutate(
      cost_per_person = total_spending / total_placements
    )

  return(cost_data)
}

# Get current housing summary (latest date)
get_housing_summary <- function(housing_df) {
  latest_date <- max(housing_df$date)

  summary <- housing_df %>%
    filter(date == latest_date) %>%
    group_by(status) %>%
    summarise(
      total_units = sum(count),
      .groups = "drop"
    )

  deployed <- sum(summary$total_units[summary$status == "deployed"])
  locked <- sum(summary$total_units[summary$status == "ready_locked"])
  construction <- sum(summary$total_units[summary$status == "construction"])

  list(
    deployed = deployed,
    locked = locked,
    construction = construction,
    total = deployed + locked + construction,
    target = 4000,
    progress_pct = (deployed + locked + construction) / 4000 * 100,
    date = latest_date
  )
}

# Get latest unsheltered count and change since Wilson
get_unsheltered_summary <- function(pit_df) {
  wilson_start <- as.Date("2026-01-01")

  latest <- pit_df %>%
    filter(!is.na(unsheltered) | !is.na(total_homeless)) %>%
    slice_max(date, n = 1)

  # Find closest data point to Wilson's start
  pre_wilson <- pit_df %>%
    filter(date < wilson_start) %>%
    filter(!is.na(unsheltered) | !is.na(total_homeless)) %>%
    slice_max(date, n = 1)

  # Use unsheltered if available, otherwise use estimates
  latest_count <- ifelse(!is.na(latest$unsheltered), latest$unsheltered, latest$total_homeless)
  baseline_count <- ifelse(!is.na(pre_wilson$unsheltered), pre_wilson$unsheltered, pre_wilson$total_homeless)

  list(
    current = latest_count,
    baseline = baseline_count,
    change = latest_count - baseline_count,
    change_pct = (latest_count - baseline_count) / baseline_count * 100,
    latest_date = latest$date,
    baseline_date = pre_wilson$date
  )
}

# Get overdose YTD summary
get_overdose_summary <- function(overdose_df, year = NULL) {
  if (is.null(year)) {
    year <- max(overdose_df$year)
  }

  ytd_data <- overdose_df %>%
    filter(year == !!year)

  list(
    ytd_total = sum(ytd_data$homeless_overdose_deaths),
    ytd_months = nrow(ytd_data),
    latest_month = max(ytd_data$month),
    avg_monthly = mean(ytd_data$homeless_overdose_deaths),
    year = year
  )
}

# Load all data
load_all_data <- function() {
  list(
    pit = load_pit_counts(),
    housing = load_housing_units(),
    overdose = load_overdose_deaths(),
    spending = load_spending(),
    placements = load_placements()
  )
}
