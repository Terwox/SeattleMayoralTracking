# Seattle Mayoral Accountability Dashboard
# VERIFIED DATA ONLY - All sources traceable
# Tracking homelessness with public data

# Install pacman if not available, then use it for all other packages
if (!require("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(shiny, bslib, plotly, dplyr)

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
last_update <- get_last_update(data)

# UI
ui <- page_fillable(
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
        font-size: 0.9rem;
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
        font-size: 0.85rem;
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
        font-size: 0.85rem;
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
        font-size: 0.85rem;
        color: #744210;
      }
      .source-link {
        font-size: 0.75rem;
        color: #718096;
      }
      .source-link a {
        color: #319795;
      }
      .dashboard-footer {
        text-align: center;
        padding: 1rem;
        font-size: 0.8rem;
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
        font-size: 0.8rem;
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
        font-size: 0.7rem;
      }
      .housing-card {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        border: 2px solid #d97706;
      }
      .housing-stat {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem;
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
        font-size: 0.8rem;
        color: #92400e;
        font-style: italic;
        text-align: center;
        padding: 0.5rem;
        border-top: 1px solid #d97706;
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
      div(
        class = "housing-note",
        tags$strong(paste0(housing_summary$months_locked, "+ MONTHS IN STORAGE. ")),
        "First reported Oct 2022 (", format_number(housing_summary$locked_initial), " units). ",
        "As of ", format(housing_summary$locked_date, "%b %Y"), ": ",
        format_number(housing_summary$locked), " units sitting unused. ",
        tags$a(href = housing_summary$locked_source_url, target = "_blank", "(Source)")
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

  # Spending data
  layout_columns(
    col_widths = c(12),
    fill = FALSE,

    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          span("VERIFIED SPENDING DATA (LIMITED)", class = "card-title"),
          actionButton("info_spending", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_spending", height = "200px"),
        div(
          class = "source-link",
          "Note: Consistent year-over-year spending data is not publicly available. ",
          "These are verified figures from specific sources - gaps represent missing public data."
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
}

# Run the app
shinyApp(ui = ui, server = server)
