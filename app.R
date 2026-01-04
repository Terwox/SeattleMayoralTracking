# Seattle Mayoral Accountability Dashboard
# VERIFIED DATA ONLY - All sources traceable
# Tracking homelessness with public data

# Install pacman if not available, then use it for all other packages
if (!require("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(shiny, bslib, plotly, dplyr, tidyr)

# Source helper functions
source("R/data_load.R")
source("R/charts.R")
source("R/utils.R")

# Load all data at startup
data <- load_all_data()

# Pre-calculate summaries
unsheltered_summary <- get_unsheltered_summary(data$pit)
overdose_summary <- get_overdose_summary(data$overdose)
housing_summary <- get_housing_summary(data$housing)
hic_summary <- get_hic_summary(data$hic)
thv_summary <- get_thv_summary(data$thv)
voucher_summary <- get_voucher_summary(data$vouchers)
hth_summary <- get_hth_summary(data$hth)
last_update <- get_last_update(data)

# UI
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bg = "#ffffff",
    fg = "#2d3748",
    primary = "#319795",
    secondary = "#a0aec0",
    danger = "#c53030",
    base_font = font_google("Inter"),
    heading_font = font_google("Inter")
  ),
  tags$head(
    tags$style(HTML("
      .dashboard-header {
        background: linear-gradient(135deg, #2d3748 0%, #4a5568 100%);
        color: white;
        padding: 1.5rem 2rem;
        margin: -1rem -1rem 1rem -1rem;
      }
      .header-title {
        font-size: 1.5rem;
        font-weight: 700;
        margin: 0;
        letter-spacing: 0.05em;
      }
      .header-subtitle {
        font-size: 1rem;
        opacity: 0.8;
        margin: 0.25rem 0 0 0;
      }
      .index-card {
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        margin-bottom: 1rem;
      }
      .card-header-custom {
        background: #f7fafc;
        border-bottom: 1px solid #e2e8f0;
        padding: 0.75rem 1rem;
      }
      .card-title {
        font-weight: 600;
        font-size: 0.9rem;
        letter-spacing: 0.05em;
        color: #2d3748;
      }
      .info-btn {
        float: right;
        padding: 0.1rem 0.5rem;
        font-size: 0.75rem;
        background: #e2e8f0;
        border: none;
        border-radius: 50%;
        color: #4a5568;
      }
      .metric-summary {
        text-align: center;
        padding: 0.5rem;
        background: #f7fafc;
        border-radius: 4px;
        margin-top: 0.5rem;
      }
      .metric-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #2d3748;
      }
      .metric-label {
        font-size: 0.9rem;
        color: #718096;
      }
      .metric-change-positive {
        color: #38a169;
        font-weight: 600;
      }
      .metric-change-negative {
        color: #c53030;
        font-weight: 600;
      }
      .data-warning {
        background: #fffbeb;
        border: 1px solid #f6e05e;
        border-radius: 8px;
        padding: 1rem;
        margin-bottom: 1rem;
      }
      .data-warning-title {
        font-weight: 600;
        color: #744210;
        margin-bottom: 0.5rem;
      }
      .data-warning-text {
        font-size: 0.9rem;
        color: #744210;
      }
      .source-link {
        font-size: 0.85rem;
        color: #718096;
      }
      .source-link a {
        color: #319795;
      }
      .dashboard-footer {
        text-align: center;
        padding: 1rem;
        font-size: 0.9rem;
        color: #718096;
        border-top: 1px solid #e2e8f0;
        margin-top: 1rem;
      }
      .dashboard-footer a {
        color: #319795;
        text-decoration: none;
      }
      .data-table {
        width: 100%;
        font-size: 0.9rem;
        margin-top: 0.5rem;
      }
      .data-table th {
        text-align: left;
        padding: 0.25rem 0.5rem;
        border-bottom: 1px solid #e2e8f0;
        color: #718096;
      }
      .data-table td {
        padding: 0.25rem 0.5rem;
        border-bottom: 1px solid #f7fafc;
      }
      .data-table a {
        color: #319795;
        font-size: 0.85rem;
      }
      .housing-card {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%) !important;
        border: 2px solid #d97706 !important;
        min-height: 180px;
      }
      .housing-card .card-body {
        padding: 1rem !important;
      }
      .housing-stat {
        display: flex;
        flex-direction: row;
        justify-content: space-around;
        align-items: center;
        padding: 1rem;
        gap: 2rem;
      }
      .housing-locked {
        text-align: center;
      }
      .housing-locked-number {
        font-size: 3rem;
        font-weight: 700;
        color: #92400e;
      }
      .housing-locked-label {
        font-size: 0.9rem;
        color: #92400e;
        font-weight: 600;
      }
      .housing-deployed {
        text-align: center;
      }
      .housing-deployed-number {
        font-size: 3rem;
        font-weight: 700;
        color: #065f46;
      }
      .housing-deployed-label {
        font-size: 0.9rem;
        color: #065f46;
        font-weight: 600;
      }
      .housing-arrow {
        font-size: 2rem;
        color: #d97706;
      }
      .housing-note {
        font-size: 0.9rem;
        color: #92400e;
        font-style: italic;
        text-align: center;
        padding: 0.5rem;
        border-top: 1px solid #d97706;
      }
      .housing-timeline {
        border-top: 1px solid #d97706;
        padding: 0.75rem 1rem;
        background: rgba(255,255,255,0.3);
      }
      .timeline-title {
        text-align: center;
        font-weight: 700;
        color: #92400e;
        font-size: 0.9rem;
        margin-bottom: 0.5rem;
      }
      .timeline-bar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 1rem;
      }
      .timeline-point {
        text-align: center;
        min-width: 80px;
      }
      .timeline-date {
        font-size: 0.85rem;
        color: #92400e;
        font-weight: 600;
      }
      .timeline-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #92400e;
      }
      .timeline-end .timeline-value {
        color: #c53030;
      }
      .timeline-label {
        font-size: 0.85rem;
        color: #92400e;
        opacity: 0.8;
      }
      .timeline-line {
        flex-grow: 1;
        height: 3px;
        background: linear-gradient(90deg, #92400e 0%, #c53030 100%);
        margin: 0 1rem;
        position: relative;
      }
      .timeline-line::after {
        content: '\\2192';
        position: absolute;
        right: -8px;
        top: -10px;
        font-size: 1.2rem;
        color: #c53030;
      }
      .timeline-source {
        text-align: center;
        margin-top: 0.5rem;
      }
      .timeline-source a {
        font-size: 0.85rem;
        color: #92400e;
      }
      .resource-card {
        background: linear-gradient(135deg, #e6fffa 0%, #b2f5ea 100%) !important;
        border: 2px solid #319795 !important;
      }
      .resource-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1rem;
        padding: 1rem;
      }
      .resource-item {
        text-align: center;
        padding: 0.75rem;
        background: rgba(255,255,255,0.5);
        border-radius: 8px;
      }
      .resource-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #234e52;
      }
      .resource-label {
        font-size: 0.85rem;
        color: #285e61;
        font-weight: 600;
      }
      .resource-sublabel {
        font-size: 0.8rem;
        color: #4a5568;
      }
      .thv-card {
        background: linear-gradient(135deg, #f0fff4 0%, #c6f6d5 100%) !important;
        border: 2px solid #38a169 !important;
      }
      .thv-stats {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1rem;
        padding: 1rem;
      }
      .thv-stat {
        text-align: center;
        padding: 0.5rem;
      }
      .thv-value {
        font-size: 2rem;
        font-weight: 700;
        color: #22543d;
      }
      .thv-label {
        font-size: 0.85rem;
        color: #276749;
        font-weight: 600;
      }
      .thv-compare {
        font-size: 0.8rem;
        color: #48bb78;
      }
      .voucher-card {
        background: linear-gradient(135deg, #ebf8ff 0%, #bee3f8 100%) !important;
        border: 2px solid #3182ce !important;
      }
      .voucher-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1rem;
        padding: 1rem;
      }
      .voucher-item {
        text-align: center;
        padding: 0.5rem;
        background: rgba(255,255,255,0.5);
        border-radius: 8px;
      }
      .voucher-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #2c5282;
      }
      .voucher-label {
        font-size: 0.85rem;
        color: #2b6cb0;
        font-weight: 600;
      }
      .hth-card {
        background: linear-gradient(135deg, #faf5ff 0%, #e9d8fd 100%) !important;
        border: 2px solid #805ad5 !important;
      }
      .hth-stats {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1rem;
        padding: 1rem;
      }
      .hth-stat {
        text-align: center;
        padding: 0.5rem;
      }
      .hth-value {
        font-size: 1.5rem;
        font-weight: 700;
        color: #553c9a;
      }
      .hth-label {
        font-size: 0.85rem;
        color: #6b46c1;
        font-weight: 600;
      }
      .thv-locked-timeline {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        border: 2px solid #d97706;
        border-radius: 8px;
        padding: 0.75rem 1rem;
        margin: 1rem 0;
      }
      .locked-timeline-title {
        text-align: center;
        font-weight: 700;
        color: #92400e;
        font-size: 0.85rem;
        margin-bottom: 0.5rem;
      }
      .locked-value {
        color: #c53030 !important;
      }
      .locked-line {
        background: linear-gradient(90deg, #92400e 0%, #c53030 100%) !important;
      }
      .locked-note {
        text-align: center;
        font-size: 0.85rem;
        color: #92400e;
        font-style: italic;
        margin-top: 0.5rem;
      }
    "))
  ),

  # Header
  div(
    class = "dashboard-header",
    h1("SEATTLE/KING COUNTY HOMELESSNESS DATA", class = "header-title"),
    p("Verified public data only - all sources traceable", class = "header-subtitle")
  ),

  # Data integrity warning
  div(
    class = "data-warning",
    div(class = "data-warning-title", "Data Integrity Notice"),
    div(
      class = "data-warning-text",
      "This dashboard shows ONLY verified data with traceable sources. ",
      "Many commonly cited metrics (quarterly estimates, homeless-specific overdose deaths, ",
      "cost-per-person-housed) cannot be verified from public sources ",
      "and are NOT included. Click the (?) buttons for methodology details."
    )
  ),

  # Emergency Housing Card (highlighted)
  card(
    class = "index-card housing-card",
    card_header(
      class = "card-header-custom",
      div(
        span("EMERGENCY HOUSING: MAYOR WILSON'S STARTING POINT", class = "card-title"),
        actionButton("info_housing", "?", class = "info-btn")
      )
    ),
    card_body(
      div(
        class = "housing-stat",
        div(
          class = "housing-locked",
          div(class = "housing-locked-number", format_number(housing_summary$locked)),
          div(class = "housing-locked-label", "TINY HOMES LOCKED IN STORAGE")
        ),
        div(class = "housing-arrow", HTML("&rarr;")),
        div(
          class = "housing-deployed",
          div(class = "housing-deployed-number", format_number(housing_summary$deployed_wilson)),
          div(class = "housing-deployed-label", "NEW UNITS DEPLOYED (WILSON)")
        )
      ),
      # Timeline showing growth of locked units
      div(
        class = "housing-timeline",
        div(class = "timeline-title", paste0(housing_summary$months_locked, "+ MONTHS IN STORAGE")),
        div(
          class = "timeline-bar",
          div(
            class = "timeline-point timeline-start",
            div(class = "timeline-date", "Oct 2022"),
            div(class = "timeline-value", format_number(housing_summary$locked_initial)),
            div(class = "timeline-label", "first reported")
          ),
          div(class = "timeline-line"),
          div(
            class = "timeline-point timeline-end",
            div(class = "timeline-date", format(housing_summary$locked_date, "%b %Y")),
            div(class = "timeline-value", format_number(housing_summary$locked)),
            div(class = "timeline-label", "now")
          )
        ),
        div(
          class = "timeline-source",
          tags$a(href = housing_summary$locked_source_url, target = "_blank", "Source: Seattle Times")
        )
      )
    )
  ),

  # Main content
  layout_columns(
    col_widths = c(6, 6),
    fill = FALSE,

    # Index 1: PIT Counts
    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          span("POINT-IN-TIME HOMELESS COUNTS", class = "card-title"),
          actionButton("info_pit", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_pit", height = "280px"),
        div(
          class = "metric-summary",
          span(class = "metric-value", format_number(unsheltered_summary$current)),
          span(class = "metric-label", " unsheltered ("),
          span(class = "metric-label", format(unsheltered_summary$latest_date, "%b %Y")),
          span(class = "metric-label", ")"),
          br(),
          span(class = "metric-label", "Change since 2019: "),
          span(
            class = ifelse(unsheltered_summary$change >= 0, "metric-change-negative", "metric-change-positive"),
            format_change(unsheltered_summary$change)
          ),
          span(class = "metric-label", paste0(" (", format_pct(unsheltered_summary$change_pct), ")"))
        ),
        div(
          class = "source-link",
          "Source: ",
          tags$a(href = unsheltered_summary$latest_source_url, target = "_blank",
                 unsheltered_summary$latest_source)
        )
      )
    ),

    # Index 2: Overdose Deaths
    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          span("OVERDOSE DEATHS (ALL POPULATIONS)", class = "card-title"),
          actionButton("info_overdose", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_overdose", height = "280px"),
        div(
          class = "metric-summary",
          span(class = "metric-value", format_number(overdose_summary$latest_deaths)),
          span(class = "metric-label", paste0(" deaths in ", overdose_summary$latest_year)),
          br(),
          span(class = "metric-label", paste0("Peak: ", format_number(overdose_summary$peak_deaths),
                                               " in ", overdose_summary$peak_year)),
          br(),
          span(class = "metric-label", "Note: This is ALL overdose deaths, not homeless-specific")
        )
      )
    )
  ),

  # Spending data - small multiples
  layout_columns(
    col_widths = c(12),
    fill = FALSE,

    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          span("VERIFIED SPENDING DATA BY CATEGORY", class = "card-title"),
          actionButton("info_spending", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_spending", height = "280px"),
        div(
          class = "source-link",
          style = "margin-top: 0.5rem;",
          HTML("<strong>X</strong> = No verified data available for that year"),
          br(),
          tags$span(style = "color: #319795; font-weight: 600;", "Seattle Citywide: "),
          "KOMO News Analysis",
          tags$span(style = "margin-left: 1rem; color: #805ad5; font-weight: 600;", "Seattle to KCRHA: "),
          "Cascade PBS, Seattle HSD",
          tags$span(style = "margin-left: 1rem; color: #d69e2e; font-weight: 600;", "KCRHA Budget: "),
          "KCRHA Financials"
        )
      )
    )
  ),

  # RESOURCE METRICS SECTION
  h4("SYSTEM RESOURCES (2024 HUD Housing Inventory Count)", style = "margin-top: 1.5rem; margin-bottom: 0.5rem; color: #2d3748; font-weight: 600;"),

  # Housing Inventory Count Card
  card(
    class = "index-card resource-card",
    card_header(
      class = "card-header-custom",
      div(
        span("SHELTER & HOUSING INVENTORY (HUD HIC 2024)", class = "card-title"),
        actionButton("info_hic", "?", class = "info-btn")
      )
    ),
    card_body(
      div(
        class = "resource-grid",
        div(
          class = "resource-item",
          div(class = "resource-value", format_number(hic_summary$emergency_shelter_total)),
          div(class = "resource-label", "EMERGENCY SHELTER"),
          div(class = "resource-sublabel", paste0(format_number(hic_summary$emergency_shelter_kcrha), " KCRHA-funded"))
        ),
        div(
          class = "resource-item",
          div(class = "resource-value", format_number(hic_summary$transitional_total)),
          div(class = "resource-label", "TRANSITIONAL HOUSING"),
          div(class = "resource-sublabel", paste0(format_number(hic_summary$transitional_kcrha), " KCRHA-funded"))
        ),
        div(
          class = "resource-item",
          div(class = "resource-value", format_number(hic_summary$rrh_total)),
          div(class = "resource-label", "RAPID RE-HOUSING"),
          div(class = "resource-sublabel", paste0(format_number(hic_summary$rrh_kcrha), " KCRHA-funded"))
        ),
        div(
          class = "resource-item",
          div(class = "resource-value", format_number(hic_summary$psh_total)),
          div(class = "resource-label", "PERMANENT SUPPORTIVE"),
          div(class = "resource-sublabel", paste0(format_number(hic_summary$psh_kcrha), " KCRHA-funded"))
        )
      ),
      div(
        class = "source-link", style = "text-align: center;",
        "Source: ",
        tags$a(href = hic_summary$source_url, target = "_blank", "KCRHA Implementation Board (HUD HIC data)")
      )
    )
  ),

  # Tiny Home Villages Card
  card(
    class = "index-card thv-card",
    card_header(
      class = "card-header-custom",
      div(
        span("TINY HOME VILLAGES: HIGH-PERFORMING SHELTER MODEL", class = "card-title"),
        actionButton("info_thv", "?", class = "info-btn")
      )
    ),
    card_body(
      div(
        class = "thv-stats",
        div(
          class = "thv-stat",
          div(class = "thv-value", format_number(thv_summary$capacity)),
          div(class = "thv-label", paste0("UNITS (", format_number(thv_summary$villages), " VILLAGES)")),
          div(class = "thv-compare", paste0(format_number(thv_summary$households_served), " households served in 2024"))
        ),
        div(
          class = "thv-stat",
          div(class = "thv-value", paste0(thv_summary$exit_rate, "%")),
          div(class = "thv-label", "EXIT TO PERMANENT HOUSING"),
          div(class = "thv-compare", paste0("vs ", thv_summary$exit_rate_comparison, "% national avg"))
        ),
        div(
          class = "thv-stat",
          div(class = "thv-value", paste0(thv_summary$return_rate, "%")),
          div(class = "thv-label", "RETURN TO HOMELESSNESS"),
          div(class = "thv-compare", "within 6 months of exit")
        )
      ),
      # Chart showing locked units over time (zero-based y-axis)
      div(
        class = "thv-locked-timeline",
        plotlyOutput("chart_locked", height = "200px"),
        div(
          class = "locked-note",
          "Built by Sound Foundations NW - waiting for sites. Goal: Get this to ZERO."
        )
      ),
      plotlyOutput("chart_thv", height = "200px"),
      div(
        class = "source-link", style = "text-align: center;",
        "Sources: Seattle HSD, Mayor's Office, Sound Foundations NW, Seattle Times"
      )
    )
  ),

  # Housing Vouchers Card
  layout_columns(
    col_widths = c(6, 6),
    fill = FALSE,

    card(
      class = "index-card voucher-card",
      card_header(
        class = "card-header-custom",
        div(
          span("HOUSING VOUCHERS (SHA/KCHA)", class = "card-title"),
          actionButton("info_vouchers", "?", class = "info-btn")
        )
      ),
      card_body(
        div(
          class = "voucher-grid",
          div(
            class = "voucher-item",
            div(class = "voucher-value", format_number(voucher_summary$ehv_total)),
            div(class = "voucher-label", "EMERGENCY HOUSING VOUCHERS"),
            div(class = "resource-sublabel", "King County total (ends 2026)")
          ),
          div(
            class = "voucher-item",
            div(class = "voucher-value", format_number(voucher_summary$hcv_waitlist)),
            div(class = "voucher-label", "HCV WAITLIST (SHA)"),
            div(class = "resource-sublabel", "Households waiting")
          ),
          div(
            class = "voucher-item",
            div(class = "voucher-value", format_number(voucher_summary$pbv_sha)),
            div(class = "voucher-label", "PROJECT-BASED (SHA)"),
            div(class = "resource-sublabel", "Across 190+ projects")
          )
        ),
        div(
          class = "source-link", style = "text-align: center;",
          "Source: ",
          tags$a(href = voucher_summary$source_url, target = "_blank", "SHA MTW Plan, KCRHA EHV FAQ")
        )
      )
    ),

    # Health Through Housing Card
    card(
      class = "index-card hth-card",
      card_header(
        class = "card-header-custom",
        div(
          span("HEALTH THROUGH HOUSING (KC)", class = "card-title"),
          actionButton("info_hth", "?", class = "info-btn")
        )
      ),
      card_body(
        div(
          class = "hth-stats",
          div(
            class = "hth-stat",
            div(class = "hth-value", format_number(hth_summary$people_served)),
            div(class = "hth-label", "PEOPLE SERVED")
          ),
          div(
            class = "hth-stat",
            div(class = "hth-value", format_number(hth_summary$units)),
            div(class = "hth-label", "UNITS")
          ),
          div(
            class = "hth-stat",
            div(class = "hth-value", format_number(hth_summary$locations)),
            div(class = "hth-label", "LOCATIONS")
          ),
          div(
            class = "hth-stat",
            div(class = "hth-value", paste0(hth_summary$retention_rate, "%")),
            div(class = "hth-label", "RETENTION RATE")
          )
        ),
        div(
          class = "source-link", style = "text-align: center;",
          "Source: ",
          tags$a(href = hth_summary$source_url, target = "_blank", "King County HTH Dashboard")
        )
      )
    )
  ),

  # Data Sources Table
  card(
    class = "index-card",
    card_header(
      class = "card-header-custom",
      span("RAW DATA WITH SOURCES", class = "card-title")
    ),
    card_body(
      h5("PIT Counts"),
      tableOutput("pit_table"),
      hr(),
      h5("Overdose Deaths"),
      tableOutput("overdose_table"),
      hr(),
      h5("Spending"),
      tableOutput("spending_table")
    )
  ),

  # What's Missing Section
  card(
    class = "index-card",
    card_header(
      class = "card-header-custom",
      span("WHAT'S MISSING (AND WHY)", class = "card-title")
    ),
    card_body(
      tags$ul(
        tags$li(tags$strong("Quarterly homeless estimates: "), "KCRHA does not publish these. Only biennial PIT counts exist."),
        tags$li(tags$strong("Homeless-specific overdose deaths: "), "Not publicly reported by King County in a verifiable format."),
        tags$li(tags$strong("Total deployed shelter capacity: "), "No consistent public reporting. Mayor's dashboard data disputed by Axios."),
        tags$li(tags$strong("Cost per person housed: "), "Requires placement data that KCRHA does not publish quarterly."),
        tags$li(tags$strong("Current locked unit count: "), "250 figure is from Oct 2024. No official tracking exists.")
      ),
      p(
        style = "font-style: italic; color: #718096;",
        "The absence of verifiable public data is itself an accountability issue."
      )
    )
  ),

  # Footer
  div(
    class = "dashboard-footer",
    span(paste("DATA VERIFIED:", format(last_update, "%B %d, %Y"))),
    span(" | "),
    span("All data points link to original sources")
  )
)

# Server
server <- function(input, output, session) {

  # Charts
  output$chart_pit <- renderPlotly({
    chart_pit_counts(data$pit)
  })

  output$chart_overdose <- renderPlotly({
    chart_overdose(data$overdose)
  })

  output$chart_spending <- renderPlotly({
    chart_spending(data$spending)
  })

  output$chart_thv <- renderPlotly({
    chart_thv_outcomes(data$thv)
  })

  output$chart_locked <- renderPlotly({
    chart_locked_units(data$housing)
  })

  # Data tables
  output$pit_table <- renderTable({
    data$pit %>%
      mutate(
        Date = format(date, "%Y-%m-%d"),
        Total = format(total_homeless, big.mark = ","),
        Unsheltered = format(unsheltered, big.mark = ","),
        Sheltered = format(sheltered, big.mark = ","),
        Source = paste0('<a href="', source_url, '" target="_blank">', source, '</a>')
      ) %>%
      select(Date, Total, Unsheltered, Sheltered, Source)
  }, sanitize.text.function = function(x) x, class = "data-table")

  output$overdose_table <- renderTable({
    data$overdose %>%
      mutate(
        Year = year,
        Deaths = format(total_overdose_deaths, big.mark = ","),
        Source = paste0('<a href="', source_url, '" target="_blank">', source, '</a>')
      ) %>%
      select(Year, Deaths, Source)
  }, sanitize.text.function = function(x) x, class = "data-table")

  output$spending_table <- renderTable({
    data$spending %>%
      mutate(
        Year = year,
        Category = category,
        Amount = paste0("$", format(amount / 1e6, nsmall = 1), "M"),
        Source = paste0('<a href="', source_url, '" target="_blank">', source, '</a>')
      ) %>%
      select(Year, Category, Amount, Source)
  }, sanitize.text.function = function(x) x, class = "data-table")

  # Modal handlers
  observeEvent(input$info_pit, {
    content <- methodology_content("pit")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_overdose, {
    content <- methodology_content("overdose")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_spending, {
    content <- methodology_content("spending")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_housing, {
    content <- methodology_content("housing")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_hic, {
    content <- methodology_content("hic")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_thv, {
    content <- methodology_content("thv")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_vouchers, {
    content <- methodology_content("vouchers")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_hth, {
    content <- methodology_content("hth")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
