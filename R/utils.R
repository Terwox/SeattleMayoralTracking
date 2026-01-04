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
    ),
    "hic" = list(
      title = "Housing Inventory Count (HIC)",
      methodology = HTML("
        <p><strong>Data Source:</strong> HUD Housing Inventory Count via KCRHA</p>
        <p><strong>What it measures:</strong> Point-in-time count of beds and units available in the homeless response system.</p>
        <p><strong>Categories:</strong></p>
        <ul>
          <li><strong>Emergency Shelter:</strong> Short-term crisis beds</li>
          <li><strong>Transitional Housing:</strong> Time-limited housing with services</li>
          <li><strong>Rapid Re-Housing:</strong> Short-term rental assistance</li>
          <li><strong>Permanent Supportive Housing:</strong> Long-term housing with ongoing support</li>
        </ul>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>HIC is conducted annually alongside PIT count (January)</li>
          <li>Includes both HUD-funded and non-HUD funded projects</li>
          <li>KCRHA-funded subset represents direct regional authority investment</li>
          <li>18 years of historical data available (2007-2024)</li>
        </ul>
        <p><strong>Source:</strong> <a href='https://www.huduser.gov/portal/sites/default/files/xls/2007-2024-HIC-Counts-by-CoC.xlsx' target='_blank'>HUD HIC Data</a></p>
      ")
    ),
    "thv" = list(
      title = "Tiny Home Villages",
      methodology = HTML("
        <p><strong>Data Source:</strong> Seattle HSD, Mayor's Office Press Releases, Sound Foundations NW</p>
        <p><strong>What it measures:</strong> Capacity and outcomes for city-funded tiny home villages.</p>
        <p><strong>Key Findings:</strong></p>
        <ul>
          <li>16 villages with 636 units serving 1,142 households (2024)</li>
          <li>46% exit to permanent housing (vs 32% national average)</li>
          <li>Only 4% return to homelessness within 6 months</li>
          <li>90% utilization rate (vs 77% system-wide)</li>
        </ul>
        <p><strong>Why This Model Works:</strong></p>
        <ul>
          <li>Private, secure space increases acceptance rates</li>
          <li>59% enrollment rate at Friendship Heights vs 21% at DESC Navigation Center</li>
          <li>KCRHA Five Year Plan calls THV 'the region's best hope at resolving the unsheltered crisis'</li>
        </ul>
        <p><strong>Sources:</strong> Mayor Harrell Press Release (July 2025), Sound Foundations NW research</p>
      ")
    ),
    "vouchers" = list(
      title = "Housing Vouchers",
      methodology = HTML("
        <p><strong>Data Sources:</strong> Seattle Housing Authority MTW Reports, KCRHA EHV FAQ</p>
        <p><strong>What it measures:</strong> Federal housing assistance vouchers allocated to King County.</p>
        <p><strong>Voucher Types:</strong></p>
        <ul>
          <li><strong>Emergency Housing Vouchers (EHV):</strong> 1,314 allocated to King County (ends 2026)</li>
          <li><strong>Housing Choice Vouchers (HCV):</strong> Tenant-based rental assistance</li>
          <li><strong>Project-Based Vouchers (PBV):</strong> Tied to specific affordable housing projects</li>
        </ul>
        <p><strong>Waitlist Context:</strong></p>
        <ul>
          <li>~24,000 households on SHA Housing Choice Voucher waitlist</li>
          <li>~5,500 households on public housing waitlist</li>
          <li>SHA opened HCV waitlist in 2024 for first time since 2017</li>
        </ul>
        <p><strong>Source:</strong> <a href='https://www.seattlehousing.org/about-us/reports/moving-to-work-reports' target='_blank'>SHA MTW Reports</a></p>
      ")
    ),
    "hth" = list(
      title = "Health Through Housing",
      methodology = HTML("
        <p><strong>Data Source:</strong> King County Health Through Housing Dashboard</p>
        <p><strong>What it measures:</strong> Outcomes from King County's permanent supportive housing initiative funded by the Health Through Housing sales tax.</p>
        <p><strong>2024 Results:</strong></p>
        <ul>
          <li>1,281 people served (net increase of 370 from 2023)</li>
          <li>1,434 units across 17 locations in 7 cities</li>
          <li>95% housing retention rate</li>
        </ul>
        <p><strong>Locations:</strong> Auburn, Burien, Federal Way, Kirkland, Redmond, Renton, Seattle</p>
        <p><strong>What Makes It Different:</strong> HTH specifically serves people experiencing chronic homelessness with high acuity needs, combining housing with wraparound services.</p>
        <p><strong>Source:</strong> <a href='https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing/health-through-housing-dashboard' target='_blank'>King County HTH Dashboard</a></p>
      ")
    )
  )
  return(content)
}
