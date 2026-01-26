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
        <p><strong>Data Source:</strong> <a href='https://kcrha.org/data-overview/king-county-point-in-time-count/' target='_blank'>KCRHA Point-in-Time Counts</a> and <a href='https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/' target='_blank'>HUD PIT Data</a></p>
        <p><strong>What it measures:</strong> One-night estimate of people experiencing homelessness in King County, conducted in late January (biennial since 2022).</p>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Counts conducted on a single night in late January</li>
          <li>Methodology changed in 2022 to Respondent Driven Sampling</li>
          <li>Pre-2022 and post-2022 counts may not be directly comparable</li>
          <li>All counts are understood to be undercounts</li>
        </ul>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://kcrha.org/wp-content/uploads/2024/05/Count-Us-In-2024-Final-Report.pdf' target='_blank'>2024 Count Us In Report (PDF)</a></li>
          <li><a href='https://kcrha.org/wp-content/uploads/2022/06/PIT-2022-Infograph-v7.pdf' target='_blank'>2022 PIT Infographic (PDF)</a></li>
        </ul>
      ")
    ),
    "overdose" = list(
      title = "Overdose Deaths",
      methodology = HTML("
        <p><strong>Data Source:</strong> <a href='https://kingcounty.gov/en/dept/dph/health-safety/disease-illness/drug-overdose' target='_blank'>King County Medical Examiner / Public Health Seattle & King County</a></p>
        <p><strong>What it measures:</strong> Annual total drug overdose deaths in King County (all populations, not homeless-specific).</p>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Annual totals from official public health reporting</li>
          <li>Includes all drug overdose deaths, not limited to homeless individuals</li>
          <li>Homeless-specific overdose data is not reliably available</li>
          <li>2025 figure is preliminary (as of Dec 30)</li>
        </ul>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://kingcounty.gov/en/dept/dph/health-safety/disease-illness/drug-overdose/overdose-data-dashboard' target='_blank'>King County Overdose Data Dashboard</a></li>
          <li><a href='https://www.seattletimes.com/seattle-news/health/king-county-overdose-deaths-2024/' target='_blank'>Seattle Times: King County overdose deaths coverage</a></li>
        </ul>
        <p><strong>Data Gap:</strong> Homeless-specific overdose data is not publicly reported in a verifiable way.</p>
      ")
    ),
    "spending" = list(
      title = "Homelessness Spending",
      methodology = HTML("
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattle.gov/city-budget-office/budget-archives' target='_blank'>Seattle City Budget Archives</a></li>
          <li><a href='https://kcrha.org/about/financials/' target='_blank'>KCRHA Budget Documents</a></li>
        </ul>
        <p><strong>What it measures:</strong> Public spending on homelessness programs.</p>
        <p><strong>Change History (2026):</strong></p>
        <ul>
          <li><strong>Federal funding gap:</strong> $40M shortfall from HUD CoC rule changes (30% cap on permanent housing funds) - ~4,500 households at risk</li>
          <li><strong>City response:</strong> $21.1M reserve set aside; shelter expansion PAUSED</li>
          <li><strong>KCRHA layoffs:</strong> 13 employees (22% staff reduction) due to $4.7M shortfall</li>
          <li><strong>Attribution:</strong> Federal policy change (external); budget response decisions (Wilson administration)</li>
        </ul>
        <p><strong>Methodology Notes:</strong></p>
        <ul>
          <li>Figures come from budget documents and verified news reporting</li>
          <li>Categories vary by year as reporting changed</li>
          <li>Not comprehensive - some years have limited public data</li>
        </ul>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattletimes.com/seattle-news/homeless/homeless-spending-seattle-king-county/' target='_blank'>Seattle Times: Homeless spending analysis</a></li>
          <li><a href='https://publicola.com/' target='_blank'>PubliCola: KCRHA budget coverage</a></li>
        </ul>
        <p><strong>Data Gap:</strong> Consistent year-over-year spending data is difficult to track due to changing budget categories and agency responsibilities.</p>
      ")
    ),
    "housing" = list(
      title = "Tiny Homes in Storage",
      methodology = HTML("
        <p><strong>Data Source:</strong> <a href='https://www.seattletimes.com/seattle-news/the-saga-of-seattles-empty-tiny-homes-is-building-to-a-head/' target='_blank'>Seattle Times: Danny Westneat</a></p>
        <p><strong>What it measures:</strong> Tiny homes built and awaiting placement in villages.</p>
        <p><strong>Change History:</strong></p>
        <ul>
          <li><strong>Current (Jan 2026):</strong> ~150 tiny homes in storage (<a href='https://www.seattletimes.com/seattle-news/the-saga-of-seattles-empty-tiny-homes-is-building-to-a-head/' target='_blank'>Seattle Times</a>)</li>
          <li><strong>Previously (Oct 2024):</strong> 250+ in storage</li>
          <li><strong>Change:</strong> ~100 deployed to new LIHI villages (Harrell announcement July 2025); 65 transferred to Tacoma</li>
          <li><strong>Attribution:</strong> Decrease attributable to Harrell administration actions before Jan 6, 2026</li>
        </ul>
        <p><strong>Context:</strong></p>
        <ul>
          <li>Homes built by <a href='https://www.soundfoundationsnw.org/' target='_blank'>Sound Foundations NW</a>, largely with private donations</li>
          <li>KCRHA cited 'difficulty finding suitable sites' as the primary obstacle</li>
          <li>This number grew from 71 in 2022 to 250+ in 2024, now decreasing</li>
        </ul>
        <p><strong>Why this matters:</strong> These are ready-to-deploy units awaiting site approval and permitting before they can house people.</p>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattletimes.com/seattle-news/the-saga-of-seattles-empty-tiny-homes-is-building-to-a-head/' target='_blank'>Seattle Times: The saga of Seattle's empty tiny homes</a></li>
          <li><a href='https://harrell.seattle.gov/2025/07/30/mayor-harrell-announces-expansion-of-available-shelter-adding-more-than-100-new-tiny-houses/' target='_blank'>Mayor Harrell: Expansion announcement (July 2025)</a></li>
        </ul>
        <p><strong>Data Gap:</strong> No official city dashboard tracks stored housing inventory. This figure comes from journalism.</p>
      ")
    ),
    "hic" = list(
      title = "Housing Inventory Count (HIC)",
      methodology = HTML("
        <p><strong>Data Source:</strong> <a href='https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/' target='_blank'>HUD Housing Inventory Count</a> via <a href='https://kcrha.org/data-overview/' target='_blank'>KCRHA</a></p>
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
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.huduser.gov/portal/sites/default/files/xls/2007-2024-HIC-Counts-by-CoC.xlsx' target='_blank'>HUD HIC Data (Excel download)</a></li>
          <li><a href='https://kcrha.org/data-overview/king-county-point-in-time-count/' target='_blank'>KCRHA Data Overview</a></li>
        </ul>
      ")
    ),
    "thv" = list(
      title = "Tiny Home Villages",
      methodology = HTML("
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattle.gov/human-services/reports-and-data' target='_blank'>Seattle Human Services Department</a></li>
          <li><a href='https://www.soundfoundationsnw.org/research' target='_blank'>Sound Foundations NW</a></li>
        </ul>
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
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://harrell.seattle.gov/2024/07/15/tiny-home-villages-report/' target='_blank'>Mayor Harrell Press Release (July 2024)</a></li>
          <li><a href='https://kcrha.org/wp-content/uploads/2023/04/KCRHA-Five-Year-Plan.pdf' target='_blank'>KCRHA Five Year Plan (PDF)</a></li>
        </ul>
      ")
    ),
    "vouchers" = list(
      title = "Housing Vouchers",
      methodology = HTML("
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattlehousing.org/about-us/reports/moving-to-work-reports' target='_blank'>Seattle Housing Authority MTW Reports</a></li>
          <li><a href='https://kcrha.org/emergency-housing-vouchers/' target='_blank'>KCRHA Emergency Housing Vouchers</a></li>
        </ul>
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
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattlehousing.org/about-us/reports/moving-to-work-reports' target='_blank'>SHA MTW Reports</a></li>
          <li><a href='https://www.seattletimes.com/seattle-news/homeless/seattle-housing-voucher-waitlist-opens/' target='_blank'>Seattle Times: Housing voucher waitlist coverage</a></li>
        </ul>
      ")
    ),
    "hth" = list(
      title = "Health Through Housing",
      methodology = HTML("
        <p><strong>Data Source:</strong> <a href='https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing/health-through-housing-dashboard' target='_blank'>King County Health Through Housing Dashboard</a></p>
        <p><strong>What it measures:</strong> Outcomes from King County's permanent supportive housing initiative funded by the Health Through Housing sales tax.</p>
        <p><strong>2024 Results:</strong></p>
        <ul>
          <li>1,281 people served (net increase of 370 from 2023)</li>
          <li>1,434 units across 17 locations in 7 cities</li>
          <li>95% housing retention rate</li>
        </ul>
        <p><strong>Locations:</strong> Auburn, Burien, Federal Way, Kirkland, Redmond, Renton, Seattle</p>
        <p><strong>What Makes It Different:</strong> HTH specifically serves people experiencing chronic homelessness with high acuity needs, combining housing with wraparound services.</p>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing/health-through-housing-dashboard' target='_blank'>King County HTH Dashboard</a></li>
          <li><a href='https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing' target='_blank'>HTH Program Overview</a></li>
        </ul>
      ")
    ),
    "costs" = list(
      title = "Cost Efficiency",
      methodology = HTML("
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li><a href='https://kcrha.org/about/financials/' target='_blank'>KCRHA Budget Documents</a></li>
          <li><a href='https://www.wshfc.org/mhcf/annualreports.htm' target='_blank'>WSHFC Annual Activity Reports</a></li>
          <li><a href='https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing' target='_blank'>King County HTH Reports</a></li>
        </ul>
        <p><strong>What it measures:</strong> Mean cost per shelter bed (operating) and per housing unit (capital).</p>
        <p><strong>Why Mean vs Median:</strong> For budget accountability, mean captures total spend efficiency. Median would underweight expensive outliers that still drain the budget.</p>
        <p><strong>Shelter Operating Costs (2024):</strong></p>
        <ul>
          <li><strong>Congregate:</strong> ~$16K/bed/year (lowest - shared facilities)</li>
          <li><strong>Enhanced:</strong> ~$45K/bed/year (mid-range with services)</li>
          <li><strong>Tiny Home:</strong> ~$85K/bed/year (higher per-bed due to construction + ops)</li>
          <li><strong>Hotel-based:</strong> ~$127K/bed/year (highest - commercial lease rates)</li>
        </ul>
        <p><strong>Housing Capital Costs:</strong></p>
        <ul>
          <li><strong>HTH Acquisitions:</strong> ~$270K/unit</li>
          <li><strong>New Construction:</strong> ~$400-500K/unit</li>
          <li><strong>WSHFC Statewide Trend:</strong> $207K (2019) to $406K (2025) = +96% in 6 years</li>
        </ul>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://publicola.com/2023/10/cost-per-unit-affordable-housing/' target='_blank'>PubliCola: Cost per unit analysis</a></li>
          <li><a href='https://www.seattletimes.com/seattle-news/homeless/seattle-shelter-costs-analysis/' target='_blank'>Seattle Times: Shelter costs investigation</a></li>
        </ul>
        <p><strong>Data Gap:</strong> No single official source provides consistent year-over-year per-bed cost comparisons across shelter types. These figures require manual compilation from multiple sources.</p>
        <p><strong>Methodology:</strong> Total budget by shelter category / reported bed counts = cost/bed. This conflates bed-count changes with cost changes, so both should be tracked independently.</p>
      ")
    ),
    "crime" = list(
      title = "Crime Statistics",
      methodology = HTML("
        <p><strong>Data Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattle.gov/police/information-and-data/crime-dashboard' target='_blank'>Seattle Police Department Crime Dashboard</a></li>
          <li><a href='https://kingcounty.gov/en/dept/dph/health-safety/medical-examiner' target='_blank'>King County Medical Examiner</a></li>
        </ul>
        <p><strong>What it measures:</strong> Homicides, violent crime rates, and incidents connected to homeless encampments.</p>
        <p><strong>King County Homicides (2024):</strong></p>
        <ul>
          <li>120 total homicides (down 16% from 2023 record of 143)</li>
          <li>61 occurred in Seattle (58 SPD, 3 WSP)</li>
          <li>Gun violence down 29% (fatal) and 13% (non-fatal) year-over-year</li>
        </ul>
        <p><strong>Homeless-Connected Incidents:</strong></p>
        <ul>
          <li>~20% of shots-fired calls associated with encampments</li>
          <li>15 shooting incidents connected to homelessness in Q3 2024 (down 31% YoY)</li>
          <li>202 encampment fires in Q3 2024 (down 37% YoY)</li>
        </ul>
        <p><strong>2025 Trends:</strong></p>
        <ul>
          <li>Crime down 9.6% citywide vs same period 2024</li>
          <li>Violent crime down ~20% vs 2024 pace</li>
          <li>Seattle was only major US city with zero homicides early in 2025</li>
        </ul>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattletimes.com/seattle-news/law-justice/homicides-in-king-county-dipped-in-2024-but-more-kids-among-the-dead/' target='_blank'>Seattle Times: King County homicides 2024</a></li>
          <li><a href='https://harrell.seattle.gov/2024/12/03/one-seattle-homelessness-action-plan-posts-q3-2024-data-updates/' target='_blank'>Mayor's Office Q3 2024 Report</a></li>
        </ul>
        <p><strong>Data Gap:</strong> Homeless-specific crime victimization and perpetration data is not systematically tracked or published.</p>
      ")
    ),
    "baseline" = list(
      title = "Emergency Housing Baseline: What Counts as 'New'?",
      methodology = HTML("
        <p><strong>Data Source:</strong> <a href='https://www.axios.com/local/seattle/2025/09/30/seattle-homelessness-housing-harrell-promise-shortfall' target='_blank'>Axios Seattle fact-check (September 2025)</a></p>
        <p><strong>The Problem:</strong> Mayor Harrell claimed ~2,000 units opened during his term, but this count included units that shouldn't count as 'new':</p>
        <ul>
          <li><strong>194 units</strong> were replacements/relocations (old shelter closed, new one opened = net zero)</li>
          <li><strong>556 units</strong> were from 7 projects already underway before Harrell took office</li>
        </ul>
        <p><strong>The Math:</strong></p>
        <ul>
          <li>Harrell's dashboard claim: 1,991 units</li>
          <li>After removing replacements: ~1,800 units</li>
          <li>After removing pre-Harrell projects: <strong>&lt;1,300 net new units</strong></li>
        </ul>
        <p><strong>Why This Matters for Wilson's 4,000 Goal:</strong></p>
        <ul>
          <li>Wilson pledged 4,000 'new' emergency housing units in four years</li>
          <li>To hold her accountable, we must count only <em>truly new</em> units added after Jan 6, 2026</li>
          <li>Units already in construction/acquisition shouldn't count toward her goal</li>
          <li>Replacements for closed facilities shouldn't count as 'new'</li>
        </ul>
        <p><strong>Our Methodology:</strong> This dashboard will track Wilson's progress from a baseline of ZERO on Jan 6, 2026. Only units that break ground, are acquired, or open <em>after</em> that date will count.</p>
        <p><strong>Source:</strong> <a href='https://www.axios.com/local/seattle/2025/09/30/seattle-homelessness-housing-harrell-promise-shortfall' target='_blank'>Axios Seattle: Seattle Mayor Harrell falls short on 2,000-housing-unit pledge</a></p>
      ")
    )
  )
  return(content)
}
