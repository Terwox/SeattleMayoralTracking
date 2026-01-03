# Utility Functions
# Seattle Mayoral Accountability Dashboard

library(htmltools)

# Format large numbers with commas
format_number <- function(x, digits = 0) {
  formatC(x, format = "f", big.mark = ",", digits = digits)
}

# Format currency
format_currency <- function(x, digits = 0) {
  paste0("$", formatC(x, format = "f", big.mark = ",", digits = digits))
}

# Format percentage
format_pct <- function(x, digits = 1) {
  paste0(formatC(x, format = "f", digits = digits), "%")
}

# Format change with + or - prefix
format_change <- function(x, digits = 0) {
  sign <- ifelse(x >= 0, "+", "")
  paste0(sign, format_number(x, digits))
}

# Calculate people that could be housed (1 person per tiny home unit)
locked_to_people <- function(locked_units, people_per_unit = 1) {
  locked_units * people_per_unit
}

# Create methodology modal content
methodology_content <- function(index_name) {
  content <- switch(index_name,
                    "unsheltered" = list(
                      title = "Unsheltered Population Count",
                      commitment = "\"How many people are sleeping unsheltered on the streets of Seattle in four years\" - Mayor Katie Wilson",
                      methodology = HTML("
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li>Official PIT counts (biennial) from HUD Exchange</li>
          <li>Quarterly estimates from KCRHA</li>
        </ul>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>PIT counts are conducted in late January</li>
          <li>Methodology changed in 2022, making direct comparisons difficult</li>
          <li>Quarterly estimates use different sampling methods</li>
          <li>Numbers represent Seattle/King County CoC</li>
        </ul>
      ")
                    ),
                    "housing" = list(
                      title = "Emergency Housing Progress",
                      commitment = "\"4,000 new emergency housing and shelter units in four years\" - Mayor Katie Wilson",
                      methodology = HTML("
        <p><strong>Unit Types Counted:</strong></p>
        <ul>
          <li><strong>Tiny homes:</strong> Individual or family units in village settings</li>
          <li><strong>Shelter beds:</strong> Emergency shelter capacity</li>
          <li><strong>Acquired units:</strong> Hotel/motel conversions, scattered site housing</li>
        </ul>
        <p><strong>Status Definitions:</strong></p>
        <ul>
          <li><strong>Deployed:</strong> Currently operational and accepting residents</li>
          <li><strong>Ready but locked:</strong> Built/acquired but not opened (regulatory, staffing, or political barriers)</li>
          <li><strong>In construction:</strong> Under development with confirmed funding</li>
        </ul>
      ")
                    ),
                    "overdose" = list(
                      title = "Homeless Overdose Deaths",
                      commitment = "No explicit commitment, but a core accountability metric given that approximately 67% of homeless deaths in King County are overdose-related.",
                      methodology = HTML("
        <p><strong>Data Source:</strong> King County Medical Examiner via Public Health Seattle & King County</p>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Data has 2-3 month reporting lag</li>
          <li>Housing status determined by death scene investigation</li>
          <li>Fentanyl/meth involvement not mutually exclusive</li>
          <li>12-month rolling average smooths seasonal variation</li>
        </ul>
      ")
                    ),
                    "cost" = list(
                      title = "Cost Per Person Housed",
                      commitment = "Accountability metric combining spending efficiency with housing outcomes.",
                      methodology = HTML("
        <p><strong>Formula:</strong> (City homelessness spending + KCRHA contribution) / Permanent housing placements</p>
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li>Numerator: Seattle adopted budget, KCRHA budget documents</li>
          <li>Denominator: KCRHA System Performance Dashboard</li>
        </ul>
        <p><strong>Limitations:</strong></p>
        <ul>
          <li>Not all spending results in placements (includes prevention, outreach, etc.)</li>
          <li>Placements may result from prior year spending</li>
          <li>Does not account for returns to homelessness</li>
        </ul>
      ")
                    )
  )
  return(content)
}

# Data update info
get_last_update <- function(data_list) {
  # Get most recent retrieved_date across all datasets
  dates <- c(
    max(data_list$pit$retrieved_date, na.rm = TRUE),
    max(data_list$housing$retrieved_date, na.rm = TRUE),
    max(data_list$overdose$retrieved_date, na.rm = TRUE),
    max(data_list$spending$raw$retrieved_date, na.rm = TRUE),
    max(data_list$placements$raw$retrieved_date, na.rm = TRUE)
  )
  max(dates)
}
