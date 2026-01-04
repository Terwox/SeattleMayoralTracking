# Data Loading and Validation Functions
# Seattle Mayoral Accountability Dashboard
# VERIFIED DATA ONLY - All sources traceable

library(readr)
library(dplyr)
library(lubridate)

# Load PIT counts data (verified biennial counts only)
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
    mutate(year = year(date))

  return(df)
}

# Load overdose deaths data (annual totals only - verified)
load_overdose_deaths <- function(path = "data/overdose_deaths.csv") {
  df <- read_csv(path, col_types = cols(
    year = col_integer(),
    total_overdose_deaths = col_integer(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  df <- df %>%
    arrange(year)

  return(df)
}

# Load spending data (verified budget figures only)
load_spending <- function(path = "data/spending.csv") {
  df <- read_csv(path, col_types = cols(
    year = col_integer(),
    category = col_character(),
    amount = col_double(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  return(df)
}

# Get latest unsheltered count and change
get_unsheltered_summary <- function(pit_df) {
  latest <- pit_df %>%
    filter(!is.na(unsheltered)) %>%
    slice_max(date, n = 1)

  earliest <- pit_df %>%
    filter(!is.na(unsheltered)) %>%
    slice_min(date, n = 1)

  list(
    current = latest$unsheltered,
    current_total = latest$total_homeless,
    baseline = earliest$unsheltered,
    change = latest$unsheltered - earliest$unsheltered,
    change_pct = (latest$unsheltered - earliest$unsheltered) / earliest$unsheltered * 100,
    latest_date = latest$date,
    baseline_date = earliest$date,
    latest_source = latest$source,
    latest_source_url = latest$source_url
  )
}

# Get overdose summary
get_overdose_summary <- function(overdose_df) {
  latest <- overdose_df %>%
    slice_max(year, n = 1)

  peak <- overdose_df %>%
    slice_max(total_overdose_deaths, n = 1)

  earliest <- overdose_df %>%
    slice_min(year, n = 1)

  list(
    latest_year = latest$year,
    latest_deaths = latest$total_overdose_deaths,
    peak_year = peak$year,
    peak_deaths = peak$total_overdose_deaths,
    earliest_year = earliest$year,
    earliest_deaths = earliest$total_overdose_deaths,
    change_from_earliest = latest$total_overdose_deaths - earliest$total_overdose_deaths
  )
}

# Load all data
load_all_data <- function() {
  list(
    pit = load_pit_counts(),
    overdose = load_overdose_deaths(),
    spending = load_spending()
  )
}

# Data update info
get_last_update <- function(data_list) {
  dates <- c(
    max(data_list$pit$retrieved_date, na.rm = TRUE),
    max(data_list$overdose$retrieved_date, na.rm = TRUE),
    max(data_list$spending$retrieved_date, na.rm = TRUE)
  )
  max(dates)
}
