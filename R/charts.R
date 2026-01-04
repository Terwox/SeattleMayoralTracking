# Chart Components
# Seattle Mayoral Accountability Dashboard
# VERIFIED DATA ONLY

library(ggplot2)
library(scales)
library(plotly)
library(tidyr)

# Color palette
colors <- list(
  primary = "#2d3748",
  accent = "#319795",
  alert = "#d69e2e",
  negative = "#c53030",
  light_gray = "#e2e8f0",
  medium_gray = "#a0aec0",
  mayor_line = "#6366f1"
)

# Mayoral transition dates (constant across all charts)
MAYORAL_TRANSITIONS <- list(
  durkan = list(date = as.Date("2017-11-28"), label = "Durkan"),
  harrell = list(date = as.Date("2022-01-03"), label = "Harrell"),
  wilson = list(date = as.Date("2026-01-06"), label = "Wilson")
)

# Helper function to add mayoral lines to plotly
add_mayor_lines <- function(p, date_range, y_max = NULL) {
  annotations <- list()
  shapes <- list()

  for (mayor in names(MAYORAL_TRANSITIONS)) {
    m <- MAYORAL_TRANSITIONS[[mayor]]
    # Only add if date falls within range
    if (m$date >= date_range[1] && m$date <= date_range[2]) {
      # Add shape (vertical line)
      shapes <- append(shapes, list(
        list(
          type = "line",
          x0 = m$date, x1 = m$date,
          y0 = 0, y1 = 1,
          xref = "x", yref = "paper",
          line = list(color = colors$mayor_line, width = 1.5, dash = "dash")
        )
      ))
      # Add annotation (label)
      annotations <- append(annotations, list(
        list(
          x = m$date, xref = "x",
          y = 1.02, yref = "paper", yanchor = "bottom",
          text = m$label,
          showarrow = FALSE,
          font = list(size = 11, color = colors$mayor_line, family = "Inter")
        )
      ))
    }
  }

  p %>% layout(shapes = shapes, annotations = annotations)
}

# Base theme for all charts - clean, minimal
theme_dashboard <- function() {
  theme_minimal() +
    theme(
      text = element_text(family = "sans", color = colors$primary, size = 11),
      plot.title = element_text(size = 13, face = "bold", margin = margin(b = 8)),
      plot.subtitle = element_text(size = 11, color = colors$medium_gray),
      axis.title = element_text(size = 11),
      axis.text = element_text(size = 10),
      axis.text.x = element_text(angle = 0, hjust = 0.5),
      legend.position = "bottom",
      legend.title = element_blank(),
      legend.text = element_text(size = 10),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

# Chart 1: PIT Counts Over Time (Total and Unsheltered)
chart_pit_counts <- function(pit_df) {
  # Prepare data with clean tooltips
  plot_data <- pit_df %>%
    mutate(
      Year = format(date, "%Y"),
      hover_text = paste0(
        Year, "\n",
        "Total: ", format(total_homeless, big.mark = ","), "\n",
        "Unsheltered: ", format(unsheltered, big.mark = ",")
      ),
      total_label = format(total_homeless, big.mark = ","),
      # Only show labels for key years: 2019 (baseline) and 2024 (current)
      unsheltered_label = ifelse(
        Year %in% c("2019", "2024") & !is.na(unsheltered),
        format(unsheltered, big.mark = ","),
        ""
      )
    )

  date_range <- c(min(plot_data$date) - 60, MAYORAL_TRANSITIONS$wilson$date + 90)
  y_max <- max(plot_data$total_homeless, na.rm = TRUE) * 1.15

  p <- ggplot(plot_data, aes(x = date, text = hover_text)) +
    # Total homeless bars (background)
    geom_col(
      aes(y = total_homeless),
      fill = colors$medium_gray,
      width = 100,
      alpha = 0.6
    ) +
    # Unsheltered bars (foreground)
    geom_col(
      aes(y = unsheltered),
      fill = colors$negative,
      width = 100
    ) +
    # Label for unsheltered - only key years (2019 baseline, 2024 current)
    geom_text(
      data = plot_data %>% filter(Year %in% c("2019", "2024"), !is.na(unsheltered)),
      aes(y = unsheltered + y_max * 0.04, label = format(unsheltered, big.mark = ",")),
      size = 5,
      fontface = "bold",
      color = colors$negative
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, y_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      limits = date_range
    ) +
    labs(
      x = NULL,
      y = "People"
    ) +
    theme_dashboard()

  # No extra unsheltered annotations - handled by geom_text above
  unsheltered_annotations <- list()
  unsheltered_shapes <- list()

  # Build mayor shapes and annotations inline
  mayor_shapes <- list()
  mayor_annotations <- list()
  for (mayor in names(MAYORAL_TRANSITIONS)) {
    m <- MAYORAL_TRANSITIONS[[mayor]]
    if (m$date >= date_range[1] && m$date <= date_range[2]) {
      mayor_shapes <- append(mayor_shapes, list(
        list(
          type = "line",
          x0 = m$date, x1 = m$date,
          y0 = 0, y1 = 1,
          xref = "x", yref = "paper",
          line = list(color = colors$mayor_line, width = 1.5, dash = "dash")
        )
      ))
      mayor_annotations <- append(mayor_annotations, list(
        list(
          x = m$date, xref = "x",
          y = 1.02, yref = "paper", yanchor = "bottom",
          text = m$label,
          showarrow = FALSE,
          font = list(size = 11, color = colors$mayor_line, family = "Inter")
        )
      ))
    }
  }

  # Combine all shapes and annotations
  all_shapes <- c(unsheltered_shapes, mayor_shapes)
  all_annotations <- c(unsheltered_annotations, mayor_annotations)

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 3) %>%
    # Force text size directly in plotly (ggplot2 size doesn't translate)
    style(textfont = list(size = 14, color = colors$negative, weight = "bold"), traces = 3) %>%
    layout(
      hovermode = "x unified",
      shapes = all_shapes,
      annotations = all_annotations
    )
}

# Chart 2: Overdose Deaths by Year
chart_overdose <- function(overdose_df) {
  plot_data <- overdose_df %>%
    mutate(
      hover_text = paste0(year, ": ", format(total_overdose_deaths, big.mark = ","), " deaths"),
      death_label = format(total_overdose_deaths, big.mark = ",")
    )

  y_max <- max(plot_data$total_overdose_deaths, na.rm = TRUE) * 1.15

  p <- ggplot(plot_data, aes(x = factor(year), y = total_overdose_deaths, text = hover_text)) +
    geom_col(fill = colors$negative, width = 0.6) +
    # Data labels above bars
    geom_text(
      aes(y = total_overdose_deaths + y_max * 0.02, label = death_label),
      size = 3.5,
      color = colors$primary
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, y_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    labs(
      x = NULL,
      y = "Deaths"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 2) %>%  # Skip text label trace
    layout(hovermode = "x")
}

# Chart 3: Spending Over Time - Small Multiples by Category (shared Y-axis)
chart_spending <- function(spending_df) {
  all_years <- 2018:2025

  category_labels <- c(
    "seattle_citywide_homelessness" = "Seattle Citywide",
    "seattle_to_kcrha" = "Seattle to KCRHA",
    "kcrha_total_budget" = "KCRHA Budget"
  )

  expanded <- spending_df %>%
    mutate(amount_m = amount / 1e6) %>%
    tidyr::complete(
      category = unique(spending_df$category),
      year = all_years
    ) %>%
    mutate(
      category_label = category_labels[category],
      has_data = !is.na(amount_m),
      hover_text = ifelse(is.na(amount_m),
                          paste0(year, ": No data"),
                          paste0(year, ": $", round(amount_m), "M")),
      bar_label = ifelse(is.na(amount_m), "", paste0("$", round(amount_m), "M"))
    )

  # Shared max for all facets (for proper comparison)
  global_max <- max(expanded$amount_m, na.rm = TRUE) * 1.15

  p <- ggplot(expanded, aes(x = factor(year), y = amount_m, text = hover_text)) +
    geom_col(
      aes(fill = category_label),
      width = 0.6,
      na.rm = TRUE
    ) +
    geom_point(
      data = expanded %>% filter(is.na(amount_m)),
      aes(y = 0),
      shape = 4,
      size = 2,
      color = colors$medium_gray,
      stroke = 1
    ) +
    # Data labels above bars
    geom_text(
      aes(y = ifelse(is.na(amount_m), NA, amount_m + global_max * 0.02), label = bar_label),
      size = 2.5,
      color = colors$primary,
      na.rm = TRUE
    ) +
    scale_fill_manual(
      values = c("KCRHA Budget" = "#d69e2e", "Seattle Citywide" = "#319795", "Seattle to KCRHA" = "#805ad5"),
      guide = "none"
    ) +
    scale_y_continuous(
      labels = function(x) paste0("$", x, "M"),
      limits = c(0, global_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    facet_wrap(~ category_label, ncol = 3) +
    labs(x = NULL, y = NULL) +
    theme_dashboard() +
    theme(
      strip.text = element_text(size = 10, face = "bold", color = colors$primary),
      strip.background = element_rect(fill = "#f7fafc", color = NA),
      panel.spacing = unit(0.8, "lines"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 9)
    )

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 4:9) %>%  # Skip X markers and text labels
    layout(hovermode = "x unified")
}

# Get spending sources by category for display
get_spending_sources <- function(spending_df) {
  spending_df %>%
    group_by(category) %>%
    summarise(
      sources = paste(unique(source), collapse = ", "),
      .groups = "drop"
    )
}

# Chart 4: Housing Inventory Count - Stacked bar by program type
chart_hic_inventory <- function(hic_df) {
  program_labels <- c(
    "emergency_shelter" = "Emergency",
    "transitional_housing" = "Transitional",
    "rapid_rehousing" = "Rapid ReHousing",
    "permanent_supportive_housing" = "Perm Supportive"
  )

  program_display <- c(
    "emergency_shelter" = "Emergency Shelter",
    "transitional_housing" = "Transitional Housing",
    "rapid_rehousing" = "Rapid Re-Housing",
    "permanent_supportive_housing" = "Permanent Supportive Housing"
  )

  plot_data <- hic_df %>%
    mutate(
      program_label = program_labels[program_type],
      program_clean = program_display[program_type],
      other_funded = total_system - kcrha_funded
    ) %>%
    tidyr::pivot_longer(
      cols = c(kcrha_funded, other_funded),
      names_to = "funding_source",
      values_to = "beds"
    ) %>%
    mutate(
      funding_label = ifelse(funding_source == "kcrha_funded", "KCRHA-Funded", "Other Sources"),
      hover_text = paste0(program_clean, "\n", funding_label, ": ", format(beds, big.mark = ","))
    )

  p <- ggplot(plot_data, aes(x = program_label, y = beds, fill = funding_source, text = hover_text)) +
    geom_col(position = "stack", width = 0.6) +
    scale_fill_manual(
      values = c("kcrha_funded" = "#319795", "other_funded" = "#e2e8f0"),
      labels = c("kcrha_funded" = "KCRHA", "other_funded" = "Other")
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.1))
    ) +
    labs(x = NULL, y = "Beds/Units") +
    theme_dashboard() +
    theme(
      axis.text.x = element_text(size = 9, angle = 0),
      legend.position = "bottom"
    )

  ggplotly(p, tooltip = "text") %>%
    layout(hovermode = "x unified")
}

# Chart 5: Tiny Home Village Outcomes comparison
chart_thv_outcomes <- function(thv_df) {
  exit_data <- thv_df %>%
    filter(metric == "exit_to_permanent_housing_pct") %>%
    arrange(year) %>%
    mutate(
      hover_text = paste0(year, ": ", value, "% exit to permanent housing"),
      bar_label = paste0(value, "%")
    )

  y_max <- 75

  p <- ggplot(exit_data, aes(x = factor(year), y = value, text = hover_text)) +
    geom_col(fill = "#38a169", width = 0.5) +
    geom_hline(yintercept = 19, linetype = "dashed", color = colors$negative, size = 0.8) +
    geom_hline(yintercept = 32, linetype = "dashed", color = colors$alert, size = 0.8) +
    # Data labels above bars
    geom_text(
      aes(y = value + 3, label = bar_label),
      size = 3.5,
      fontface = "bold",
      color = colors$primary
    ) +
    scale_y_continuous(
      labels = function(x) paste0(x, "%"),
      limits = c(0, y_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    labs(
      x = NULL,
      y = "Exit Rate",
      title = "THV Exit to Permanent Housing"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 12, face = "bold", hjust = 0.5)
    )

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 2:4) %>%  # Skip hlines and text labels
    layout(
      hovermode = "x",
      annotations = list(
        list(
          x = 1, xref = "paper", xanchor = "right",
          y = 19, yref = "y", yanchor = "bottom",
          text = "Congregate (19%)",
          showarrow = FALSE,
          font = list(size = 10, color = colors$negative)
        ),
        list(
          x = 1, xref = "paper", xanchor = "right",
          y = 32, yref = "y", yanchor = "bottom",
          text = "Nat'l avg (32%)",
          showarrow = FALSE,
          font = list(size = 10, color = colors$alert)
        )
      )
    )
}

# Chart 6: Locked Tiny Homes Over Time
chart_locked_units <- function(housing_df) {
  locked_data <- housing_df %>%
    filter(status == "locked_in_storage") %>%
    arrange(date)

  wilson_start <- MAYORAL_TRANSITIONS$wilson$date
  harrell_start <- MAYORAL_TRANSITIONS$harrell$date

  plot_data <- locked_data %>%
    select(date, count) %>%
    bind_rows(
      tibble(
        date = wilson_start,
        count = max(locked_data$count)
      )
    ) %>%
    mutate(
      hover_text = paste0(format(date, "%b %Y"), ": ", count, " units")
    )

  date_range <- c(min(plot_data$date) - 30, wilson_start + 120)
  y_max <- max(plot_data$count) * 1.3

  p <- ggplot(plot_data, aes(x = date, y = count, text = hover_text)) +
    geom_area(fill = "#fef3c7", alpha = 0.7) +
    geom_line(color = "#d97706", size = 1.5) +
    geom_point(color = "#92400e", size = 3) +
    scale_y_continuous(
      limits = c(0, y_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    scale_x_date(
      date_breaks = "6 months",
      date_labels = "%b '%y",
      limits = date_range
    ) +
    labs(
      x = NULL,
      y = "Units Locked",
      title = "Tiny Homes in Storage"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 12, face = "bold", color = "#92400e", hjust = 0.5),
      axis.text.x = element_text(size = 9)
    )

  # Create plotly annotations for labels (positioned above points)
  label_annotations <- lapply(1:nrow(plot_data), function(i) {
    list(
      x = as.numeric(plot_data$date[i]) * 1000,  # Convert to milliseconds for plotly
      y = plot_data$count[i] + y_max * 0.08,
      text = as.character(plot_data$count[i]),
      showarrow = FALSE,
      font = list(size = 12, color = "#92400e", family = "Inter"),
      xanchor = "center",
      yanchor = "bottom"
    )
  })

  ggplotly(p, tooltip = "text") %>%
    layout(
      hovermode = "x unified",
      annotations = label_annotations
    ) %>%
    add_mayor_lines(date_range)
}

# Chart 7: Cost Efficiency - Shelter Operating Costs by Type
chart_shelter_costs <- function(cost_df) {
  shelter_data <- cost_df %>%
    filter(shelter_type %in% c("congregate_shelter", "enhanced_shelter", "tiny_home", "hotel_based")) %>%
    mutate(
      shelter_label = case_when(
        shelter_type == "congregate_shelter" ~ "Congregate",
        shelter_type == "enhanced_shelter" ~ "Enhanced",
        shelter_type == "tiny_home" ~ "Tiny Home",
        shelter_type == "hotel_based" ~ "Hotel"
      ),
      cost_k = cost_per_bed / 1000,
      hover_text = paste0(shelter_label, ": $", format(cost_per_bed, big.mark = ","), "/bed/yr"),
      bar_label = paste0("$", round(cost_k), "K")
    )

  x_max <- max(shelter_data$cost_k) * 1.25

  p <- ggplot(shelter_data, aes(x = reorder(shelter_label, cost_per_bed), y = cost_k, text = hover_text)) +
    geom_col(fill = colors$accent, width = 0.5) +
    # Data labels to the right of bars
    geom_text(
      aes(y = cost_k + x_max * 0.03, label = bar_label),
      size = 3.5,
      hjust = 0,
      fontface = "bold",
      color = colors$primary
    ) +
    coord_flip() +
    scale_y_continuous(
      labels = function(x) paste0("$", x, "K"),
      limits = c(0, x_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    labs(
      x = NULL,
      y = "Cost/Bed/Year",
      title = "Shelter Operating Costs"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
      axis.text.y = element_text(size = 10)
    )

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 2) %>%  # Skip text label trace
    layout(hovermode = "y unified")
}

# Chart 8: Homeless Housing Capital Costs (HTH + New Construction)
chart_homeless_capital <- function(cost_df) {
  capital_data <- cost_df %>%
    filter(shelter_type %in% c("hth_acquisition", "new_construction")) %>%
    mutate(
      capital_label = case_when(
        shelter_type == "hth_acquisition" ~ "HTH Acquisition",
        shelter_type == "new_construction" ~ "New PSH Construction"
      ),
      cost_k = cost_per_bed / 1000,
      hover_text = paste0(capital_label, ": $", format(cost_per_bed, big.mark = ","), "/unit"),
      bar_label = paste0("$", round(cost_k), "K")
    )

  x_max <- max(capital_data$cost_k) * 1.25

  p <- ggplot(capital_data, aes(x = reorder(capital_label, cost_per_bed), y = cost_k, text = hover_text)) +
    geom_col(fill = colors$alert, width = 0.5) +
    geom_text(
      aes(y = cost_k + x_max * 0.03, label = bar_label),
      size = 3.5,
      hjust = 0,
      fontface = "bold",
      color = colors$primary
    ) +
    coord_flip() +
    scale_y_continuous(
      labels = function(x) paste0("$", x, "K"),
      limits = c(0, x_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    labs(
      x = NULL,
      y = "Cost/Unit",
      title = "Homeless Housing Capital Costs"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
      axis.text.y = element_text(size = 10)
    )

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 2) %>%
    layout(hovermode = "y unified")
}

# Chart 8b: Capital Cost Trend (WSHFC statewide - context)
chart_capital_trend <- function(cost_df) {
  capital_data <- cost_df %>%
    filter(shelter_type == "statewide_capital") %>%
    mutate(
      cost_k = cost_per_bed / 1000,
      hover_text = paste0(fiscal_year, ": $", format(cost_per_bed, big.mark = ","), "/unit"),
      point_label = paste0("$", round(cost_k), "K")
    )

  y_max <- max(capital_data$cost_k) * 1.3

  p <- ggplot(capital_data, aes(x = fiscal_year, y = cost_k, text = hover_text)) +
    geom_line(color = colors$alert, size = 1.2) +
    geom_point(color = colors$alert, size = 2.5) +
    scale_y_continuous(
      labels = function(x) paste0("$", x, "K"),
      limits = c(0, y_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    scale_x_continuous(
      breaks = seq(min(capital_data$fiscal_year), max(capital_data$fiscal_year), by = 2)
    ) +
    labs(
      x = NULL,
      y = "Cost/Unit",
      title = "Statewide Housing Costs (All Affordable)"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
      axis.text.x = element_text(size = 9)
    )

  # Create plotly annotations for labels (positioned above points)
  label_annotations <- lapply(1:nrow(capital_data), function(i) {
    list(
      x = capital_data$fiscal_year[i],
      y = capital_data$cost_k[i] + y_max * 0.06,
      text = capital_data$point_label[i],
      showarrow = FALSE,
      font = list(size = 10, color = colors$primary, family = "Inter"),
      xanchor = "center",
      yanchor = "bottom"
    )
  })

  ggplotly(p, tooltip = "text") %>%
    layout(
      hovermode = "x unified",
      annotations = label_annotations
    )
}

# Chart 9: Homicides Over Time
chart_homicides <- function(crime_df) {
  homicide_data <- crime_df %>%
    filter(metric == "king_county_homicides", !is.na(value)) %>%
    arrange(year) %>%
    mutate(
      hover_text = paste0(year, ": ", value, " homicides")
    )

  # Calculate max for proper label spacing
  y_max <- max(homicide_data$value) * 1.2

  p <- ggplot(homicide_data, aes(x = factor(year), y = value, text = hover_text)) +
    geom_col(fill = colors$negative, width = 0.5) +
    # Data labels positioned ABOVE bars with room
    geom_text(
      aes(label = value, y = value + y_max * 0.03),
      size = 4,
      fontface = "bold",
      color = colors$primary
    ) +
    scale_y_continuous(
      limits = c(0, y_max),
      expand = expansion(mult = c(0, 0.02))
    ) +
    labs(
      x = NULL,
      y = "Homicides",
      title = "King County Homicides"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 12, face = "bold", hjust = 0.5)
    )

  ggplotly(p, tooltip = "text") %>%
    style(hoverinfo = "skip", traces = 2) %>%  # Skip text label trace
    layout(hovermode = "x")
}
