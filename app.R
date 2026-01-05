# Wilson's Homelessness Scorecard
# Tracking the 4,000-unit promise with verified public data
# VERIFIED DATA ONLY - All sources traceable

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
cost_summary <- get_cost_summary(data$costs)
crime_summary <- get_crime_summary(data$crime)
baseline_summary <- get_baseline_summary(data$baseline)
last_update <- get_last_update(data)

# Calculate progress toward 4,000
wilson_target <- 4000
wilson_current <- 0  # Starting from verified baseline on Jan 6, 2026
wilson_inherited <- baseline_summary$harrell_net_new  # ~1,300 verified
wilson_locked_gimme <- housing_summary$locked  # 250+ easy wins
politics_path_total <- wilson_inherited + wilson_locked_gimme  # ~1,550 "inherited"
politics_path_needed <- wilson_target - politics_path_total  # ~2,450 new needed

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
      /* Header */
      .dashboard-header {
        background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);
        color: white;
        padding: 1.5rem 2rem;
        margin: -1rem -1rem 1.5rem -1rem;
      }
      .header-title {
        font-size: 1.75rem;
        font-weight: 700;
        margin: 0;
        letter-spacing: 0.02em;
      }
      .header-subtitle {
        font-size: 1rem;
        opacity: 0.85;
        margin: 0.5rem 0 0 0;
      }

      /* Beat cards */
      .beat-card {
        border-radius: 12px;
        margin-bottom: 1.5rem;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      }
      .beat-header {
        padding: 0.75rem 1.25rem;
        border-bottom: 1px solid rgba(0,0,0,0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      .beat-label {
        font-size: 0.7rem;
        font-weight: 700;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        opacity: 0.7;
      }
      .beat-title {
        font-size: 1rem;
        font-weight: 700;
        margin: 0.25rem 0 0 0;
      }
      .info-btn {
        padding: 0.1rem 0.5rem;
        font-size: 0.75rem;
        background: rgba(0,0,0,0.1);
        border: none;
        border-radius: 50%;
        color: inherit;
        opacity: 0.7;
      }
      .info-btn:hover {
        opacity: 1;
        background: rgba(0,0,0,0.2);
      }

      /* Beat 1: The Promise */
      .promise-card {
        background: linear-gradient(135deg, #ebf8ff 0%, #bee3f8 100%);
        border: 2px solid #3182ce;
      }
      .promise-card .beat-header {
        color: #2c5282;
      }
      .promise-content {
        padding: 1.5rem;
        text-align: center;
      }
      .promise-target {
        font-size: 3.5rem;
        font-weight: 800;
        color: #2c5282;
        line-height: 1;
      }
      .promise-target-label {
        font-size: 1rem;
        color: #4a5568;
        margin-top: 0.5rem;
      }
      .progress-container {
        margin: 1.5rem 0;
        padding: 0 2rem;
      }
      .progress-bar-wrapper {
        background: rgba(255,255,255,0.7);
        border-radius: 12px;
        height: 40px;
        overflow: hidden;
        position: relative;
      }
      .progress-bar-fill {
        height: 100%;
        background: linear-gradient(90deg, #3182ce 0%, #63b3ed 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding-right: 1rem;
        color: white;
        font-weight: 700;
        min-width: 60px;
      }
      .progress-labels {
        display: flex;
        justify-content: space-between;
        margin-top: 0.5rem;
        font-size: 0.85rem;
        color: #4a5568;
      }
      .pace-info {
        margin-top: 1rem;
        font-size: 0.9rem;
        color: #4a5568;
      }
      .pace-needed {
        font-weight: 700;
        color: #2c5282;
      }

      /* Beat 2: The Baseline */
      .baseline-card {
        background: linear-gradient(135deg, #fdf2f8 0%, #fce7f3 100%);
        border: 2px solid #db2777;
      }
      .baseline-card .beat-header {
        color: #831843;
      }
      .baseline-content {
        padding: 1.25rem;
      }
      .baseline-compare {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 2rem;
      }
      .baseline-item {
        text-align: center;
      }
      .baseline-value {
        font-size: 2.5rem;
        font-weight: 700;
      }
      .baseline-crossed {
        color: #9ca3af;
        text-decoration: line-through;
      }
      .baseline-actual {
        color: #831843;
      }
      .baseline-label {
        font-size: 0.85rem;
        color: #6b7280;
        font-weight: 600;
      }
      .baseline-arrow {
        font-size: 2rem;
        color: #db2777;
      }
      .baseline-explain {
        margin-top: 1rem;
        padding: 0.75rem;
        background: rgba(255,255,255,0.6);
        border-radius: 8px;
        font-size: 0.85rem;
        color: #831843;
        text-align: center;
      }

      /* Beat 3: The Gimme */
      .gimme-card {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        border: 2px solid #d97706;
      }
      .gimme-card .beat-header {
        color: #92400e;
      }
      .gimme-content {
        padding: 1.5rem;
        text-align: center;
      }
      .gimme-number {
        font-size: 4rem;
        font-weight: 800;
        color: #92400e;
        line-height: 1;
      }
      .gimme-label {
        font-size: 1.1rem;
        color: #92400e;
        font-weight: 600;
        margin-top: 0.5rem;
      }
      .gimme-sublabel {
        font-size: 0.9rem;
        color: #78350f;
        margin-top: 0.25rem;
      }
      .gimme-status {
        margin-top: 1rem;
        display: inline-block;
        padding: 0.5rem 1.5rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.9rem;
      }
      .status-waiting {
        background: #fef3c7;
        border: 2px solid #d97706;
        color: #92400e;
      }
      .status-deployed {
        background: #d1fae5;
        border: 2px solid #059669;
        color: #065f46;
      }
      .gimme-timeline {
        margin-top: 1rem;
        font-size: 0.85rem;
        color: #92400e;
      }
      .gimme-callout {
        margin-top: 1rem;
        padding: 0.75rem;
        background: rgba(255,255,255,0.6);
        border-radius: 8px;
        font-size: 0.85rem;
        color: #78350f;
      }

      /* Beat 4: The Outcome */
      .outcome-card {
        background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
        border: 2px solid #16a34a;
      }
      .outcome-card .beat-header {
        color: #166534;
      }
      .outcome-content {
        padding: 1rem;
      }
      .outcome-quote {
        font-style: italic;
        color: #166534;
        padding: 0.75rem 1rem;
        border-left: 4px solid #16a34a;
        background: rgba(255,255,255,0.5);
        margin-bottom: 1rem;
        font-size: 0.9rem;
      }
      .outcome-metric {
        display: flex;
        justify-content: center;
        align-items: baseline;
        gap: 0.5rem;
        margin-bottom: 0.5rem;
      }
      .outcome-value {
        font-size: 2.5rem;
        font-weight: 700;
        color: #166534;
      }
      .outcome-label {
        font-size: 0.9rem;
        color: #4a5568;
      }

      /* Beat 5: Efficiency */
      .efficiency-card {
        background: linear-gradient(135deg, #fefce8 0%, #fef9c3 100%);
        border: 2px solid #ca8a04;
      }
      .efficiency-card .beat-header {
        color: #854d0e;
      }
      .efficiency-content {
        padding: 1rem;
      }
      .efficiency-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
      }
      .efficiency-item {
        text-align: center;
        padding: 0.75rem;
        background: rgba(255,255,255,0.5);
        border-radius: 8px;
      }
      .efficiency-range {
        font-size: 1.25rem;
        font-weight: 700;
        color: #854d0e;
      }
      .efficiency-type {
        font-size: 0.8rem;
        color: #78350f;
        font-weight: 600;
        margin-top: 0.25rem;
      }

      /* Context Section */
      .context-section {
        margin-top: 2rem;
        border-top: 2px solid #e2e8f0;
        padding-top: 1.5rem;
      }
      .context-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        cursor: pointer;
        padding: 0.75rem;
        background: #f7fafc;
        border-radius: 8px;
        margin-bottom: 1rem;
      }
      .context-title {
        font-size: 1rem;
        font-weight: 700;
        color: #4a5568;
      }
      .context-toggle {
        font-size: 1.25rem;
        color: #718096;
      }
      .context-card {
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        margin-bottom: 1rem;
      }
      .context-card-header {
        background: #f7fafc;
        padding: 0.5rem 1rem;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      .context-card-title {
        font-weight: 600;
        font-size: 0.85rem;
        color: #4a5568;
      }

      /* Misc */
      .source-link {
        font-size: 0.8rem;
        color: #718096;
        text-align: center;
        margin-top: 0.5rem;
      }
      .source-link a {
        color: #319795;
      }
      .dashboard-footer {
        text-align: center;
        padding: 1.5rem;
        font-size: 0.85rem;
        color: #718096;
        border-top: 1px solid #e2e8f0;
        margin-top: 2rem;
      }
      .metric-summary {
        text-align: center;
        padding: 0.5rem;
        background: rgba(255,255,255,0.5);
        border-radius: 4px;
        margin-top: 0.5rem;
      }
      .metric-change-positive { color: #38a169; font-weight: 600; }
      .metric-change-negative { color: #c53030; font-weight: 600; }
    "))
  ),

  # ============================================
  # HEADER
  # ============================================
  div(
    class = "dashboard-header",
    h1("WILSON'S HOMELESSNESS SCORECARD", class = "header-title"),
    p("Tracking the 4,000-unit promise with verified public data", class = "header-subtitle")
  ),

  # ============================================
  # BEAT 1: THE PROMISE
  # ============================================
  div(
    class = "beat-card promise-card",
    div(
      class = "beat-header",
      div(
        div(class = "beat-title", "THE PROMISE")
      ),
      actionButton("info_promise", "?", class = "info-btn")
    ),
    div(
      class = "promise-content",
      div(class = "promise-target", format_number(wilson_target)),
      div(class = "promise-target-label", "new emergency housing & shelter units by January 2030"),
      div(
        class = "progress-container",
        div(
          class = "progress-bar-wrapper",
          div(
            class = "progress-bar-fill",
            style = paste0("width: ", max(1, round(wilson_current / wilson_target * 100)), "%;"),
            format_number(wilson_current)
          )
        ),
        div(
          class = "progress-labels",
          span("0"),
          span(paste0(format_number(wilson_target), " target"))
        )
      ),
      div(
        class = "pace-info",
        "Pace needed: ", span(class = "pace-needed", "1,000 units/year"),
        " | Current pace: ", span(class = "pace-needed", "TBD (just started)")
      )
    )
  ),

  # ============================================
  # BEAT 2 & 3: BASELINE + GIMME (side by side)
  # ============================================
  layout_columns(
    col_widths = c(6, 6),
    fill = FALSE,

    # Beat 2: The Baseline
    div(
      class = "beat-card baseline-card",
      div(
        class = "beat-header",
        div(
          div(class = "beat-title", "THE BASELINE")
        ),
        actionButton("info_baseline", "?", class = "info-btn")
      ),
      div(
        class = "baseline-content",
        div(
          class = "baseline-compare",
          div(
            class = "baseline-item",
            div(class = "baseline-value baseline-crossed", format_number(baseline_summary$harrell_claimed)),
            div(class = "baseline-label", "Harrell claimed")
          ),
          div(class = "baseline-arrow", HTML("&rarr;")),
          div(
            class = "baseline-item",
            div(class = "baseline-value baseline-actual", paste0("<", format_number(baseline_summary$harrell_net_new))),
            div(class = "baseline-label", "Verified actual")
          )
        ),
        div(
          class = "baseline-explain",
          HTML(paste0(
            "Gap: ", format_number(baseline_summary$replaced_units), " replacements + ",
            format_number(baseline_summary$pre_harrell_units), " pre-Harrell projects"
          ))
        ),
        div(
          class = "source-link",
          tags$a(href = baseline_summary$source_url, target = "_blank", "Source: Axios Seattle")
        )
      )
    ),

    # Beat 3: The Gimme
    div(
      class = "beat-card gimme-card",
      div(
        class = "beat-header",
        div(
          div(class = "beat-title", "THE GIMME")
        ),
        actionButton("info_gimme", "?", class = "info-btn")
      ),
      div(
        class = "gimme-content",
        div(class = "gimme-number", format_number(housing_summary$locked)),
        div(class = "gimme-label", "TINY HOMES IN STORAGE"),
        div(class = "gimme-sublabel", "Built by volunteers. Ready to deploy."),
        div(
          class = "gimme-status status-waiting",
          HTML("&#9888; AWAITING SITES")
        ),
        div(
          class = "gimme-timeline",
          paste0("Time in storage: ", housing_summary$months_locked, "+ months")
        ),
        div(
          class = "gimme-callout",
          "Zero capital cost required. Awaiting site approval."
        )
      )
    )
  ),

  # ============================================
  # BEAT 4 & 5: OUTCOME + EFFICIENCY (side by side)
  # ============================================
  layout_columns(
    col_widths = c(6, 6),
    fill = FALSE,

    # Beat 4: The Outcome
    div(
      class = "beat-card outcome-card",
      div(
        class = "beat-header",
        div(
          div(class = "beat-title", "THE OUTCOME")
        ),
        actionButton("info_outcome", "?", class = "info-btn")
      ),
      div(
        class = "outcome-content",
        div(
          class = "outcome-quote",
          "\"How many people are sleeping unsheltered on the streets of Seattle in four years\" — Wilson's stated success metric"
        ),
        div(
          class = "outcome-metric",
          span(class = "outcome-value", format_number(unsheltered_summary$current)),
          span(class = "outcome-label", "unsheltered (Jan 2024 baseline)")
        ),
        plotlyOutput("chart_pit", height = "200px"),
        div(
          class = "source-link",
          tags$a(href = unsheltered_summary$latest_source_url, target = "_blank",
                 paste0("Source: ", unsheltered_summary$latest_source))
        )
      )
    ),

    # Beat 5: Efficiency Test
    div(
      class = "beat-card efficiency-card",
      div(
        class = "beat-header",
        div(
          div(class = "beat-title", "THE EFFICIENCY TEST")
        ),
        actionButton("info_efficiency", "?", class = "info-btn")
      ),
      div(
        class = "efficiency-content",
        p(style = "font-size: 0.85rem; color: #78350f; text-align: center; margin-bottom: 1rem;",
          "What does it cost to house one person?"),
        div(
          class = "efficiency-grid",
          div(
            class = "efficiency-item",
            div(class = "efficiency-range",
                paste0("$", format_number(cost_summary$shelter_low/1000), "K - $",
                       format_number(cost_summary$shelter_high/1000), "K")),
            div(class = "efficiency-type", "per shelter bed/year")
          ),
          div(
            class = "efficiency-item",
            div(class = "efficiency-range",
                paste0("$", format_number(cost_summary$capital_low/1000), "K - $",
                       format_number(cost_summary$capital_high/1000), "K")),
            div(class = "efficiency-type", "per housing unit (capital)")
          )
        ),
        plotlyOutput("chart_homeless_capital", height = "180px")
      )
    )
  ),

  # ============================================
  # WHAT'S MISSING (Moved up for visibility)
  # ============================================
  div(
    class = "context-card",
    style = "margin: 1rem; max-width: 100%;",
    div(
      class = "context-card-header",
      span(class = "context-card-title", "WHAT'S MISSING (AND WHY)")
    ),
    div(style = "padding: 0.75rem;",
      tags$ul(style = "font-size: 0.85rem; color: #4a5568; margin: 0;",
        tags$li(tags$strong("Quarterly homeless estimates: "),
                "KCRHA does not publish these. Only biennial PIT counts exist."),
        tags$li(tags$strong("Homeless-specific overdose deaths: "),
                "Not publicly reported in verifiable format."),
        tags$li(tags$strong("Cost per person housed: "),
                "Requires placement data KCRHA doesn't publish quarterly."),
        tags$li(tags$strong("Current locked unit count: "),
                "250 figure from Oct 2024. No official tracking exists.")
      ),
      p(style = "font-style: italic; color: #718096; font-size: 0.8rem; margin: 0.5rem 0 0 0;",
        "The absence of verifiable public data is itself an accountability issue.")
    )
  ),

  # ============================================
  # THE EVIDENCE (Collapsible supporting data)
  # ============================================
  div(
    class = "context-section",
    div(
      class = "context-header",
      onclick = "Shiny.setInputValue('toggle_context', Math.random())",
      span(class = "context-title", "THE EVIDENCE"),
      span(class = "context-toggle", id = "context_arrow", HTML("&#9660;"))
    ),
    conditionalPanel(
      condition = "output.show_context == true",

      # Row 1: Overdose + Crime
      layout_columns(
        col_widths = c(6, 6),
        fill = FALSE,

        # Overdose
        div(
          class = "context-card",
          div(
            class = "context-card-header",
            span(class = "context-card-title", "OVERDOSE DEATHS (All Populations)"),
            actionButton("info_overdose", "?", class = "info-btn",
                        style = "padding: 0 0.4rem; font-size: 0.7rem;")
          ),
          div(style = "padding: 0.75rem;",
            plotlyOutput("chart_overdose", height = "200px"),
            div(class = "metric-summary",
              span(style = "font-weight: 700;", format_number(overdose_summary$latest_deaths)),
              span(style = "color: #718096;", paste0(" deaths in ", overdose_summary$latest_year)),
              br(),
              span(style = "font-size: 0.8rem; color: #718096;",
                   "Note: ALL overdose deaths, not homeless-specific")
            )
          )
        ),

        # Crime
        div(
          class = "context-card",
          div(
            class = "context-card-header",
            span(class = "context-card-title", "PUBLIC SAFETY"),
            actionButton("info_crime", "?", class = "info-btn",
                        style = "padding: 0 0.4rem; font-size: 0.7rem;")
          ),
          div(style = "padding: 0.75rem;",
            plotlyOutput("chart_homicides", height = "200px"),
            div(class = "metric-summary",
              span(style = "font-weight: 700;", crime_summary$kc_homicides_2024),
              span(style = "color: #718096;", " King County homicides (2024)"),
              br(),
              span(style = "font-size: 0.8rem; color: #38a169; font-weight: 600;",
                   paste0(crime_summary$kc_homicides_change, " from 2023 record"))
            )
          )
        )
      ),

      # Row 2: Spending
      div(
        class = "context-card",
        div(
          class = "context-card-header",
          span(class = "context-card-title", "SPENDING BREAKDOWN"),
          actionButton("info_spending", "?", class = "info-btn",
                      style = "padding: 0 0.4rem; font-size: 0.7rem;")
        ),
        div(style = "padding: 0.75rem;",
          plotlyOutput("chart_spending", height = "180px")
        )
      ),

      # Row 3: System Resources + THV Performance
      layout_columns(
        col_widths = c(6, 6),
        fill = FALSE,

        # HIC Inventory
        div(
          class = "context-card",
          div(
            class = "context-card-header",
            span(class = "context-card-title", "SYSTEM RESOURCES (HUD HIC)"),
            actionButton("info_hic", "?", class = "info-btn",
                        style = "padding: 0 0.4rem; font-size: 0.7rem;")
          ),
          div(style = "padding: 0.75rem;",
            plotlyOutput("chart_hic", height = "200px"),
            div(class = "metric-summary",
              span(style = "font-weight: 700;", format_number(hic_summary$total_system)),
              span(style = "color: #718096;", " total beds/units in system"),
              br(),
              span(style = "font-size: 0.8rem; color: #718096;",
                   paste0(format_number(hic_summary$kcrha_funded), " KCRHA-funded"))
            )
          )
        ),

        # THV Performance
        div(
          class = "context-card",
          div(
            class = "context-card-header",
            span(class = "context-card-title", "TINY HOME VILLAGE OUTCOMES"),
            actionButton("info_thv", "?", class = "info-btn",
                        style = "padding: 0 0.4rem; font-size: 0.7rem;")
          ),
          div(style = "padding: 0.75rem;",
            plotlyOutput("chart_thv", height = "200px"),
            div(class = "metric-summary",
              span(style = "font-weight: 700; color: #38a169;", paste0(thv_summary$exit_rate, "%")),
              span(style = "color: #718096;", " exit to permanent housing"),
              br(),
              span(style = "font-size: 0.8rem; color: #718096;",
                   paste0("vs ", thv_summary$national_avg, "% national avg"))
            )
          )
        )
      ),

      # Row 4: Shelter Costs + Locked Units Timeline
      layout_columns(
        col_widths = c(6, 6),
        fill = FALSE,

        # Shelter Operating Costs
        div(
          class = "context-card",
          div(
            class = "context-card-header",
            span(class = "context-card-title", "SHELTER OPERATING COSTS"),
            actionButton("info_costs", "?", class = "info-btn",
                        style = "padding: 0 0.4rem; font-size: 0.7rem;")
          ),
          div(style = "padding: 0.75rem;",
            plotlyOutput("chart_shelter_costs", height = "200px")
          )
        ),

        # Locked Units Timeline
        div(
          class = "context-card",
          div(
            class = "context-card-header",
            span(class = "context-card-title", "TINY HOMES IN STORAGE OVER TIME"),
            actionButton("info_housing", "?", class = "info-btn",
                        style = "padding: 0 0.4rem; font-size: 0.7rem;")
          ),
          div(style = "padding: 0.75rem;",
            plotlyOutput("chart_locked", height = "200px")
          )
        )
      ),

    )
  ),

  # ============================================
  # FOOTER
  # ============================================
  div(
    class = "dashboard-footer",
    span(paste("DATA VERIFIED:", format(last_update, "%B %d, %Y"))),
    span(" | "),
    span("All data points link to original sources")
  )
)

# Server
server <- function(input, output, session) {

  # Context panel toggle
  show_context <- reactiveVal(FALSE)

  observeEvent(input$toggle_context, {
    show_context(!show_context())
  })

  output$show_context <- reactive({ show_context() })
  outputOptions(output, "show_context", suspendWhenHidden = FALSE)

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

  output$chart_shelter_costs <- renderPlotly({
    chart_shelter_costs(data$costs)
  })

  output$chart_homeless_capital <- renderPlotly({
    chart_homeless_capital(data$costs)
  })

  output$chart_homicides <- renderPlotly({
    chart_homicides(data$crime)
  })

  output$chart_hic <- renderPlotly({
    chart_hic_inventory(data$hic)
  })

  # Modal handlers
  observeEvent(input$info_promise, {
    showModal(modalDialog(
      title = "The Promise: 4,000 Units",
      HTML("
        <p><strong>What she said:</strong> Mayor Wilson pledged 4,000 new emergency housing and shelter units in her four-year term (Jan 2026 - Jan 2030).</p>
        <p><strong>Pace check:</strong> To hit the target, she needs to average 1,000 units per year.</p>
        <p><strong>Our methodology:</strong> We count only units that break ground, are acquired, or become operational AFTER January 6, 2026. No credit for inherited projects.</p>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.king5.com/article/news/local/seattle/katie-wilson-to-be-inaugurated-friday-as-seattle-mayor-becoming-third-woman-to-lead-city/281-8979c5a3-ce20-4f55-90eb-15e79be912aa' target='_blank'>KING 5: Wilson inauguration coverage</a></li>
          <li><a href='https://www.fox13seattle.com/news/katie-wilson-sworn-in-seattle-mayor' target='_blank'>FOX 13: Wilson sworn in, pledges focus on affordability</a></li>
        </ul>
      "),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_baseline, {
    content <- methodology_content("baseline")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_gimme, {
    content <- methodology_content("housing")
    showModal(modalDialog(
      title = "The Gimme: Tiny Homes in Storage",
      HTML("
        <p><strong>What it is:</strong> 250+ tiny homes built by <a href='https://www.soundfoundationsnw.org/' target='_blank'>Sound Foundations NW</a> volunteers, currently in SODO storage awaiting placement.</p>
        <p><strong>Why it matters:</strong> These are ready-to-deploy units with zero capital cost. Deployment requires site approval and permitting.</p>
        <p><strong>Context:</strong> Sound Foundations has indicated these units are earmarked for planned villages. Tracking deployment progress helps measure system capacity.</p>
        <p><strong>Verified Sources:</strong></p>
        <ul>
          <li><a href='https://www.seattletimes.com/seattle-news/the-saga-of-seattles-empty-tiny-homes-is-building-to-a-head/' target='_blank'>Seattle Times: The saga of Seattle's empty tiny homes (Oct 2024)</a></li>
          <li><a href='https://www.kiro7.com/news/local/governor-seattle-mayor-visit-factory-back-tiny-house-villages-efficient-homelessness-solution/R6L2MYFB7RG35H2C5W4KHBQG7Q/' target='_blank'>KIRO 7: Governor, Mayor visit Sound Foundations factory</a></li>
        </ul>
      "),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_outcome, {
    content <- methodology_content("pit")
    showModal(modalDialog(
      title = content$title,
      content$methodology,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })

  observeEvent(input$info_efficiency, {
    content <- methodology_content("costs")
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

  observeEvent(input$info_crime, {
    content <- methodology_content("crime")
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

  observeEvent(input$info_costs, {
    content <- methodology_content("costs")
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
