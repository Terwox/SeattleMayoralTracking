# Seattle Mayoral Accountability Dashboard
# Tracking Mayor Wilson's homelessness commitments with public data

# Install pacman if not available, then use it for all other packages
if (!require("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(shiny, bslib, plotly, dplyr, zoo)

# Source helper functions
source("R/data_load.R")
source("R/charts.R")
source("R/utils.R")

# Load all data at startup
data <- load_all_data()

# Pre-calculate summaries
housing_summary <- get_housing_summary(data$housing)
unsheltered_summary <- get_unsheltered_summary(data$pit)
overdose_summary <- get_overdose_summary(data$overdose)
cost_data <- calculate_cost_per_person(data$spending, data$placements)
last_update <- get_last_update(data)

# UI
ui <- page_fillable(
  theme = bs_theme(
    version = 5,
    bg = "#ffffff",
    fg = "#2d3748",
    primary = "#319795",
    secondary = "#a0aec0",
    success = "#319795",
    warning = "#d69e2e",
    danger = "#c53030",
    base_font = font_google("Inter"),
    heading_font = font_google("Inter")
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  # Header
  div(
    class = "dashboard-header",
    h1("SEATTLE MAYORAL ACCOUNTABILITY: HOMELESSNESS", class = "header-title"),
    p("Tracking Mayor Wilson's commitments with public data", class = "header-subtitle")
  ),

  # Main content
  layout_columns(
    col_widths = c(12),
    fill = FALSE,

    # Index 1: Unsheltered Population
    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          class = "card-header-content",
          span("UNSHELTERED POPULATION", class = "card-title"),
          actionButton("info_unsheltered", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_unsheltered", height = "250px"),
        div(
          class = "metric-summary",
          span(class = "metric-value", format_number(unsheltered_summary$current)),
          span(class = "metric-label", " current"),
          span(class = "metric-divider", " | "),
          span(class = "metric-label", "Change since Jan 2026: "),
          span(
            class = ifelse(unsheltered_summary$change >= 0, "metric-change-negative", "metric-change-positive"),
            format_change(unsheltered_summary$change)
          )
        )
      )
    ),

    # Index 2: Emergency Housing Progress
    card(
      class = "index-card housing-card",
      card_header(
        class = "card-header-custom",
        div(
          class = "card-header-content",
          span("EMERGENCY HOUSING PROGRESS", class = "card-title"),
          actionButton("info_housing", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_housing", height = "100px"),
        div(
          class = "progress-label",
          span(class = "progress-current", format_number(housing_summary$total)),
          span(" / 4,000 units")
        ),
        div(
          class = "housing-breakdown",
          div(
            class = "breakdown-row",
            span(class = "breakdown-label", "Deployed:"),
            span(class = "breakdown-value deployed", paste0(format_number(housing_summary$deployed), " units"))
          ),
          div(
            class = "breakdown-row locked-row",
            span(class = "breakdown-label locked-label", "Ready but locked:"),
            span(class = "breakdown-value locked", paste0(format_number(housing_summary$locked), " units")),
            span(class = "locked-callout", HTML("&larr; WHY ARE THESE LOCKED UP?"))
          ),
          div(
            class = "breakdown-row",
            span(class = "breakdown-label", "In construction:"),
            span(class = "breakdown-value", paste0(format_number(housing_summary$construction), " units"))
          )
        )
      )
    )
  ),

  # Second row: Overdose Deaths and Cost Per Person
  layout_columns(
    col_widths = c(6, 6),
    fill = FALSE,

    # Index 3: Overdose Deaths
    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          class = "card-header-content",
          span("OVERDOSE DEATHS", class = "card-title"),
          actionButton("info_overdose", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_overdose", height = "200px"),
        div(
          class = "metric-summary",
          span(class = "metric-value", format_number(overdose_summary$ytd_total)),
          span(class = "metric-label", paste0(" ", overdose_summary$year, " YTD (",
                                               overdose_summary$ytd_months, " months)"))
        )
      )
    ),

    # Index 4: Cost Per Person Housed
    card(
      class = "index-card",
      card_header(
        class = "card-header-custom",
        div(
          class = "card-header-content",
          span("COST PER PERSON HOUSED", class = "card-title"),
          actionButton("info_cost", "?", class = "info-btn")
        )
      ),
      card_body(
        plotlyOutput("chart_cost", height = "200px"),
        div(
          class = "metric-summary",
          span(class = "metric-label", paste0(max(cost_data$fiscal_year), ": ")),
          span(
            class = "metric-value",
            format_currency(cost_data$cost_per_person[cost_data$fiscal_year == max(cost_data$fiscal_year)])
          )
        )
      )
    )
  ),

  # Data Gaps Section
  card(
    class = "data-gaps-card",
    card_header(
      class = "card-header-gaps",
      span("DATA GAPS: What we can't track (but should)", class = "gaps-title"),
      actionButton("show_gaps", "more", class = "more-btn")
    )
  ),

  # Footer
  div(
    class = "dashboard-footer",
    tags$a(href = "docs/methodology.md", "METHODOLOGY"),
    span(" | "),
    tags$a(href = "docs/sources.md", "DATA SOURCES"),
    span(" | "),
    tags$a(href = "https://github.com/", target = "_blank", "GITHUB"),
    span(" | "),
    span(paste("LAST UPDATED:", format(last_update, "%B %d, %Y")))
  ),

  # Modals for methodology
  uiOutput("modal_unsheltered"),
  uiOutput("modal_housing"),
  uiOutput("modal_overdose"),
  uiOutput("modal_cost"),
  uiOutput("modal_gaps")
)

# Server
server <- function(input, output, session) {

  # Charts
  output$chart_unsheltered <- renderPlotly({
    chart_unsheltered(data$pit)
  })

  output$chart_housing <- renderPlotly({
    chart_housing_progress(housing_summary)
  })

  output$chart_overdose <- renderPlotly({
    chart_overdose(data$overdose)
  })

  output$chart_cost <- renderPlotly({
    chart_cost_per_person(cost_data)
  })

  # Modal handlers
  observeEvent(input$info_unsheltered, {
    content <- methodology_content("unsheltered")
    showModal(modalDialog(
      title = content$title,
      div(
        class = "methodology-modal",
        div(class = "commitment-quote", content$commitment),
        hr(),
        content$methodology
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_housing, {
    content <- methodology_content("housing")
    showModal(modalDialog(
      title = content$title,
      div(
        class = "methodology-modal",
        div(class = "commitment-quote", content$commitment),
        hr(),
        content$methodology
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_overdose, {
    content <- methodology_content("overdose")
    showModal(modalDialog(
      title = content$title,
      div(
        class = "methodology-modal",
        div(class = "commitment-quote", content$commitment),
        hr(),
        content$methodology
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_cost, {
    content <- methodology_content("cost")
    showModal(modalDialog(
      title = content$title,
      div(
        class = "methodology-modal",
        div(class = "commitment-quote", content$commitment),
        hr(),
        content$methodology
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$show_gaps, {
    showModal(modalDialog(
      title = "Data Gaps",
      div(
        class = "data-gaps-modal",
        h4("Metrics we SHOULD track but can't:"),
        tags$table(
          class = "gaps-table",
          tags$tr(
            tags$td(class = "gap-metric", "Time-to-housing"),
            tags$td(class = "gap-benchmark", "Built for Zero benchmark: ≤45 days"),
            tags$td(class = "gap-status", "Not publicly reported")
          ),
          tags$tr(
            tags$td(class = "gap-metric", "Sweeps without housing offers"),
            tags$td(class = "gap-benchmark", "Should be 0%"),
            tags$td(class = "gap-status", "Requires FOIA or news tracking")
          ),
          tags$tr(
            tags$td(class = "gap-metric", "Return-to-homelessness rate"),
            tags$td(class = "gap-benchmark", "HUD requires tracking"),
            tags$td(class = "gap-status", "Not prominently published")
          ),
          tags$tr(
            tags$td(class = "gap-metric", "Real-time shelter availability"),
            tags$td(class = "gap-benchmark", "Exists internally"),
            tags$td(class = "gap-status", "Not made public")
          )
        ),
        hr(),
        p(
          class = "gaps-note",
          "The absence of public data is itself an accountability issue. ",
          "If you have access to these metrics, please contribute to this project."
        )
      ),
      size = "l",
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
