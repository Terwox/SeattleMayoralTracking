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

# Create methodology modal content
methodology_content <- function(index_name) {
  content <- switch(index_name,
    "pit" = list(
      title = "Point-in-Time Homeless Counts",
      methodology = HTML("
        <p><strong>Data Source:</strong> KCRHA and HUD Point-in-Time Counts</p>
        <p><strong>What it measures:</strong> One-night estimate of people experiencing homelessness in King County, conducted in late January (biennial since 2022).</p>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Counts conducted on a single night in late January</li>
          <li>Methodology changed in 2022 to Respondent Driven Sampling</li>
          <li>Pre-2022 and post-2022 counts may not be directly comparable</li>
          <li>All counts are understood to be undercounts</li>
        </ul>
        <p><strong>Verified Sources:</strong> Each data point links to its original source.</p>
      ")
    ),
    "overdose" = list(
      title = "Overdose Deaths",
      methodology = HTML("
        <p><strong>Data Source:</strong> King County Medical Examiner / Public Health Seattle & King County</p>
        <p><strong>What it measures:</strong> Annual total drug overdose deaths in King County (all populations, not homeless-specific).</p>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Annual totals from official public health reporting</li>
          <li>Includes all drug overdose deaths, not limited to homeless individuals</li>
          <li>Homeless-specific overdose data is not reliably available</li>
          <li>2025 figure is preliminary (as of Dec 30)</li>
        </ul>
        <p><strong>Data Gap:</strong> Homeless-specific overdose data is not publicly reported in a verifiable way.</p>
      ")
    ),
    "spending" = list(
      title = "Homelessness Spending",
      methodology = HTML("
        <p><strong>Data Sources:</strong> Seattle City Budget, KCRHA Budget Documents, News Reports</p>
        <p><strong>What it measures:</strong> Public spending on homelessness programs.</p>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Figures come from budget documents and verified news reporting</li>
          <li>Categories vary by year as reporting changed</li>
          <li>Not comprehensive - some years have limited public data</li>
        </ul>
        <p><strong>Data Gap:</strong> Consistent year-over-year spending data is difficult to track due to changing budget categories and agency responsibilities.</p>
      ")
    ),
    "housing" = list(
      title = "Emergency Housing Units",
      methodology = HTML("
        <p><strong>Data Source:</strong> Seattle Times investigative reporting (Danny Westneat, Oct 2024)</p>
        <p><strong>What it measures:</strong> Tiny homes built but sitting unused in storage.</p>
        <p><strong>Context:</strong></p>
        <ul>
          <li>As of October 2024, 250+ tiny homes were locked in 3 SODO storage lots</li>
          <li>Homes built by Sound Foundations NW, largely with private donations</li>
          <li>KCRHA cited 'difficulty finding suitable sites' as the primary obstacle</li>
          <li>This number grew from 71 in 2022 to 250+ in 2024</li>
        </ul>
        <p><strong>Why this matters:</strong> These are ready-to-deploy units that could immediately house people but remain unused due to bureaucratic and political barriers.</p>
        <p><strong>Data Gap:</strong> No official city dashboard tracks locked/unused housing inventory. This figure comes from journalism.</p>
      ")
    )
  )
  return(content)
}
