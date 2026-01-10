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
    total_homeless = col_double(),  # Use double to handle NA values
    unsheltered = col_double(),
    sheltered = col_double(),
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

  # Filter to only the main spending categories for the chart
  # Other categories (federal_funding_gap, seattle_federal_reserve, households_at_risk)
  # are context/metadata, not actual spending
  main_categories <- c("seattle_citywide_homelessness", "seattle_to_kcrha",
                       "kcrha_total_budget", "seattle_non_kcrha")
  df <- df %>%
    filter(category %in% main_categories)

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

# Load crime statistics data
load_crime_stats <- function(path = "data/crime_stats.csv") {
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

# Get crime summary
get_crime_summary <- function(crime_df) {
  latest_year <- max(crime_df$year[!is.na(crime_df$value) & crime_df$metric == "king_county_homicides"])

  list(
    kc_homicides_2024 = crime_df %>% filter(year == 2024, metric == "king_county_homicides") %>% pull(value),
    kc_homicides_2023 = crime_df %>% filter(year == 2023, metric == "king_county_homicides") %>% pull(value),
    seattle_homicides_2024 = crime_df %>% filter(year == 2024, metric == "seattle_homicides") %>% pull(value),
    violent_crime_rate = crime_df %>% filter(year == 2024, metric == "seattle_violent_crime_rate") %>% pull(value),
    homeless_shootings_q3 = crime_df %>% filter(year == 2024, metric == "homeless_shooting_incidents_q3") %>% pull(value),
    encampment_fires_q3 = crime_df %>% filter(year == 2024, metric == "encampment_fires_q3") %>% pull(value),
    crime_ytd_change_2025 = crime_df %>% filter(year == 2025, metric == "seattle_crime_ytd_change") %>% pull(value),
    violent_ytd_change_2025 = crime_df %>% filter(year == 2025, metric == "seattle_violent_crime_ytd_change") %>% pull(value),
    source_url = crime_df$source_url[crime_df$metric == "king_county_homicides" & crime_df$year == 2024]
  )
}

# Load cost per bed data
load_cost_per_bed <- function(path = "data/cost_per_bed.csv") {
  df <- read_csv(path, col_types = cols(
    fiscal_year = col_integer(),
    shelter_type = col_character(),
    total_budget = col_double(),
    bed_count = col_integer(),
    cost_per_bed = col_integer(),
    source_documents = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Load placements data
load_placements <- function(path = "data/placements.csv") {
  df <- read_csv(path, col_types = cols(
    quarter = col_character(),
    year = col_integer(),
    permanent_housing_placements = col_integer(),
    returns_to_homelessness = col_integer(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Load emergency housing baseline data (Harrell claimed vs actual)
load_emergency_baseline <- function(path = "data/emergency_housing_baseline.csv") {
  df <- read_csv(path, col_types = cols(
    date = col_date(),
    category = col_character(),
    count = col_integer(),
    notes = col_character(),
    source = col_character(),
    source_url = col_character(),
    retrieved_date = col_date()
  ))
  return(df)
}

# Get emergency housing baseline summary
get_baseline_summary <- function(baseline_df) {
  list(
    harrell_claimed = baseline_df %>% filter(category == "harrell_dashboard_claim") %>% pull(count),
    harrell_minus_replacements = baseline_df %>% filter(category == "harrell_minus_replacements") %>% pull(count),
    harrell_net_new = baseline_df %>% filter(category == "harrell_net_new") %>% pull(count),
    replaced_units = baseline_df %>% filter(category == "replaced_relocated_units") %>% pull(count),
    pre_harrell_units = baseline_df %>% filter(category == "pre_harrell_projects") %>% pull(count),
    wilson_baseline = baseline_df %>% filter(category == "wilson_baseline") %>% pull(count),
    source_url = baseline_df %>% filter(category == "harrell_dashboard_claim") %>% pull(source_url)
  )
}

# Get cost per bed summary
get_cost_summary <- function(cost_df) {
  # Get shelter operating costs (use latest year available for shelter types)
  shelter_types <- c("congregate_shelter", "enhanced_shelter", "tiny_home", "hotel_based")
  shelter_year <- cost_df %>%
    filter(shelter_type %in% shelter_types) %>%
    pull(fiscal_year) %>%
    max()

  shelter_costs <- cost_df %>%
    filter(fiscal_year == shelter_year,
           shelter_type %in% shelter_types)

  # Get capital costs (use latest year available for capital types)
  capital_types <- c("hth_acquisition", "new_construction")
  capital_year <- cost_df %>%
    filter(shelter_type %in% capital_types) %>%
    pull(fiscal_year) %>%
    max()

  capital_costs <- cost_df %>%
    filter(fiscal_year == capital_year,
           shelter_type %in% capital_types)

  # Get statewide capital trend
  capital_trend <- cost_df %>%
    filter(shelter_type == "statewide_capital") %>%
    arrange(fiscal_year)

  list(
    year = shelter_year,
    shelter_low = min(shelter_costs$cost_per_bed, na.rm = TRUE),
    shelter_high = max(shelter_costs$cost_per_bed, na.rm = TRUE),
    shelter_avg = mean(shelter_costs$cost_per_bed, na.rm = TRUE),
    capital_low = min(capital_costs$cost_per_bed, na.rm = TRUE),
    capital_high = max(capital_costs$cost_per_bed, na.rm = TRUE),
    capital_avg = mean(capital_costs$cost_per_bed, na.rm = TRUE),
    capital_2019 = capital_trend$cost_per_bed[capital_trend$fiscal_year == 2019],
    capital_2025 = capital_trend$cost_per_bed[capital_trend$fiscal_year == 2025],
    capital_pct_change = round((capital_trend$cost_per_bed[capital_trend$fiscal_year == 2025] -
                                 capital_trend$cost_per_bed[capital_trend$fiscal_year == 2019]) /
                                capital_trend$cost_per_bed[capital_trend$fiscal_year == 2019] * 100, 1)
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
    hth = load_health_through_housing(),
    costs = load_cost_per_bed(),
    placements = load_placements(),
    crime = load_crime_stats(),
    baseline = load_emergency_baseline()
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
    max(data_list$hth$retrieved_date, na.rm = TRUE),
    max(data_list$costs$retrieved_date, na.rm = TRUE),
    max(data_list$placements$retrieved_date, na.rm = TRUE),
    max(data_list$crime$retrieved_date, na.rm = TRUE),
    max(data_list$baseline$retrieved_date, na.rm = TRUE)
  )
  max(dates)
}
