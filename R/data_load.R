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

# Load housing units data (verified figures only)
load_housing_units <- function(path = "data/housing_units.csv") {
  df <- read_csv(path, col_types = cols(
    date = col_date(),
    unit_type = col_character(),
    status = col_character(),
    count = col_integer(),
    notes = col_character(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))

  return(df)
}

# Get housing summary
get_housing_summary <- function(housing_df) {
  # Get the latest locked count
  locked_row <- housing_df %>%
    filter(status == "locked_in_storage") %>%
    slice_max(date, n = 1)

  # Get the earliest locked record to calculate duration
  first_locked <- housing_df %>%
    filter(status == "locked_in_storage") %>%
    slice_min(date, n = 1)

  deployed_wilson <- housing_df %>%
    filter(status == "deployed_wilson") %>%
    summarise(total = sum(count, na.rm = TRUE)) %>%
    pull(total)

  # Calculate months locked - use first() to get scalar values
  first_locked_date <- first_locked$date[1]
  months_locked <- as.numeric(difftime(Sys.Date(), first_locked_date, units = "days")) / 30.44

  list(
    locked = locked_row$count[1],
    locked_initial = first_locked$count[1],
    locked_initial_date = first_locked_date,
    deployed_wilson = deployed_wilson,
    locked_source = locked_row$source[1],
    locked_source_url = locked_row$source_url[1],
    locked_date = locked_row$date[1],
    months_locked = round(months_locked)
  )
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

# Load HIC inventory data (HUD Housing Inventory Count)
load_hic_inventory <- function(path = "data/hic_inventory.csv") {
  df <- read_csv(path, col_types = cols(
    year = col_integer(),
    program_type = col_character(),
    kcrha_funded = col_integer(),
    total_system = col_integer(),
    pct_of_system = col_integer(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Load tiny home villages data
load_tiny_home_villages <- function(path = "data/tiny_home_villages.csv") {
  df <- read_csv(path, col_types = cols(
    year = col_integer(),
    metric = col_character(),
    value = col_double(),
    comparison_value = col_double(),
    comparison_type = col_character(),
    notes = col_character(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Load housing vouchers data
load_housing_vouchers <- function(path = "data/housing_vouchers.csv") {
  df <- read_csv(path, col_types = cols(
    year = col_integer(),
    agency = col_character(),
    voucher_type = col_character(),
    count = col_integer(),
    notes = col_character(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Load Health Through Housing data
load_health_through_housing <- function(path = "data/health_through_housing.csv") {
  df <- read_csv(path, col_types = cols(
    year = col_integer(),
    metric = col_character(),
    value = col_double(),
    notes = col_character(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Get tiny home village summary
get_thv_summary <- function(thv_df) {
  latest_year <- max(thv_df$year[thv_df$metric == "total_capacity"])

  list(
    villages = thv_df %>% filter(year == latest_year, metric == "villages_count") %>% pull(value),
    capacity = thv_df %>% filter(year == latest_year, metric == "total_capacity") %>% pull(value),
    households_served = thv_df %>% filter(year == latest_year, metric == "households_served") %>% pull(value),
    exit_rate = thv_df %>% filter(year == latest_year, metric == "exit_to_permanent_housing_pct") %>% pull(value),
    exit_rate_comparison = thv_df %>% filter(year == latest_year, metric == "exit_to_permanent_housing_pct") %>% pull(comparison_value),
    return_rate = thv_df %>% filter(year == latest_year, metric == "return_rate_pct") %>% pull(value),
    utilization = thv_df %>% filter(year == latest_year, metric == "utilization_rate_pct") %>% pull(value),
    utilization_comparison = thv_df %>% filter(year == latest_year, metric == "utilization_rate_pct") %>% pull(comparison_value),
    source_url = thv_df %>% filter(year == latest_year, metric == "total_capacity") %>% pull(source_url)
  )
}

# Get HIC summary
get_hic_summary <- function(hic_df) {
  latest_year <- max(hic_df$year)

  total_kcrha <- sum(hic_df$kcrha_funded[hic_df$year == latest_year])
  total_system <- sum(hic_df$total_system[hic_df$year == latest_year])

  list(
    year = latest_year,
    emergency_shelter_kcrha = hic_df %>% filter(year == latest_year, program_type == "emergency_shelter") %>% pull(kcrha_funded),
    emergency_shelter_total = hic_df %>% filter(year == latest_year, program_type == "emergency_shelter") %>% pull(total_system),
    transitional_kcrha = hic_df %>% filter(year == latest_year, program_type == "transitional_housing") %>% pull(kcrha_funded),
    transitional_total = hic_df %>% filter(year == latest_year, program_type == "transitional_housing") %>% pull(total_system),
    rrh_kcrha = hic_df %>% filter(year == latest_year, program_type == "rapid_rehousing") %>% pull(kcrha_funded),
    rrh_total = hic_df %>% filter(year == latest_year, program_type == "rapid_rehousing") %>% pull(total_system),
    psh_kcrha = hic_df %>% filter(year == latest_year, program_type == "permanent_supportive_housing") %>% pull(kcrha_funded),
    psh_total = hic_df %>% filter(year == latest_year, program_type == "permanent_supportive_housing") %>% pull(total_system),
    total_kcrha = total_kcrha,
    total_system = total_system,
    source_url = hic_df$source_url[1]
  )
}

# Get voucher summary
get_voucher_summary <- function(voucher_df) {
  latest_year <- max(voucher_df$year)

  list(
    ehv_total = voucher_df %>% filter(year == latest_year, agency == "King_County_Total", voucher_type == "emergency_housing_voucher") %>% pull(count),
    ehv_sha = voucher_df %>% filter(year == latest_year, agency == "SHA", voucher_type == "emergency_housing_voucher") %>% pull(count),
    ehv_kcha = voucher_df %>% filter(year == latest_year, agency == "KCHA", voucher_type == "emergency_housing_voucher") %>% pull(count),
    hcv_waitlist = voucher_df %>% filter(year == latest_year, agency == "SHA", voucher_type == "housing_choice_voucher_waitlist") %>% pull(count),
    ph_waitlist = voucher_df %>% filter(year == latest_year, agency == "SHA", voucher_type == "public_housing_waitlist") %>% pull(count),
    pbv_sha = voucher_df %>% filter(year == latest_year, agency == "SHA", voucher_type == "project_based_vouchers") %>% pull(count),
    source_url = voucher_df$source_url[1]
  )
}

# Get Health Through Housing summary
get_hth_summary <- function(hth_df) {
  latest_year <- max(hth_df$year)

  list(
    people_served = hth_df %>% filter(year == latest_year, metric == "people_served") %>% pull(value),
    units = hth_df %>% filter(year == latest_year, metric == "secured_units") %>% pull(value),
    locations = hth_df %>% filter(year == latest_year, metric == "locations") %>% pull(value),
    retention_rate = hth_df %>% filter(year == latest_year, metric == "housing_retention_rate_pct") %>% pull(value),
    source_url = hth_df$source_url[1]
  )
}

# Load all data
load_all_data <- function() {
  list(
    pit = load_pit_counts(),
    overdose = load_overdose_deaths(),
    spending = load_spending(),
    housing = load_housing_units(),
    hic = load_hic_inventory(),
    thv = load_tiny_home_villages(),
    vouchers = load_housing_vouchers(),
    hth = load_health_through_housing()
  )
}

# Data update info
get_last_update <- function(data_list) {
  dates <- c(
    max(data_list$pit$retrieved_date, na.rm = TRUE),
    max(data_list$overdose$retrieved_date, na.rm = TRUE),
    max(data_list$spending$retrieved_date, na.rm = TRUE),
    max(data_list$housing$retrieved_date, na.rm = TRUE),
    max(data_list$hic$retrieved_date, na.rm = TRUE),
    max(data_list$thv$retrieved_date, na.rm = TRUE),
    max(data_list$vouchers$retrieved_date, na.rm = TRUE),
    max(data_list$hth$retrieved_date, na.rm = TRUE)
  )
  max(dates)
}
