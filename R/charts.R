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

medium_gray = "#a0aec0"
)

# Base theme for all charts - minimum 11pt text
theme_dashboard <- function() {
  theme_minimal() +
    theme(
      text = element_text(family = "sans", color = colors$primary, size = 11),
      plot.title = element_text(size = 14, face = "bold", margin = margin(b = 10)),
      plot.subtitle = element_text(size = 12, color = colors$medium_gray),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 11),
      legend.position = "bottom",
      legend.title = element_blank(),
      legend.text = element_text(size = 11),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

# Chart 1: PIT Counts Over Time (Total and Unsheltered)
chart_pit_counts <- function(pit_df) {
  p <- ggplot(pit_df, aes(x = date)) +
    # Total homeless bars
    geom_col(
      aes(y = total_homeless),
      fill = colors$medium_gray,
      width = 120,
      alpha = 0.5
    ) +
    # Unsheltered bars
    geom_col(
      aes(y = unsheltered),
      fill = colors$negative,
      width = 120
    ) +
    # Data labels for total
    geom_text(
      aes(y = total_homeless, label = format(total_homeless, big.mark = ",")),
      vjust = -0.5,
      size = 4,
      color = colors$primary
    ) +
    # Data labels for unsheltered
    geom_text(
      aes(y = unsheltered, label = format(unsheltered, big.mark = ",")),
      vjust = 1.5,
      size = 4,
      color = "white"
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.15))
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y"
    ) +
    labs(
      x = NULL,
      y = "People",
      caption = "Gray = Total homeless | Red = Unsheltered"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(hovermode = "x unified")
}

# Chart 2: Overdose Deaths by Year
chart_overdose <- function(overdose_df) {
  p <- ggplot(overdose_df, aes(x = factor(year), y = total_overdose_deaths)) +
    geom_col(fill = colors$negative, width = 0.7) +
    geom_text(
      aes(label = format(total_overdose_deaths, big.mark = ",")),
      vjust = -0.5,
      size = 4,
      color = colors$primary
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.15))
    ) +
    labs(
      x = NULL,
      y = "Deaths"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(hovermode = "x")
}

# Chart 3: Spending Over Time - Small Multiples by Category
chart_spending <- function(spending_df) {
  # Define year range for all categories (2018-2025)
  all_years <- 2018:2025

  # Get unique categories and create readable labels
  category_labels <- c(
    "seattle_citywide_homelessness" = "Seattle Citywide\nHomelessness",
    "seattle_to_kcrha" = "Seattle Contribution\nto KCRHA",
    "kcrha_total_budget" = "KCRHA Total\nBudget"
  )

  # Category colors
  category_colors <- c(
    "seattle_citywide_homelessness" = "#319795",
    "seattle_to_kcrha" = "#805ad5",
    "kcrha_total_budget" = "#d69e2e"
  )

  # Expand data to include all years (with NA for missing)
  expanded <- spending_df %>%
    mutate(amount_m = amount / 1e6) %>%
    tidyr::complete(
      category = unique(spending_df$category),
      year = all_years
    ) %>%
    mutate(
      category_label = category_labels[category],
      has_data = !is.na(amount_m)
    )

  # Create the faceted plot
  p <- ggplot(expanded, aes(x = factor(year), y = amount_m)) +
    # Bars for actual data
    geom_col(
      aes(fill = category),
      width = 0.7,
      na.rm = TRUE
    ) +
    # X markers for missing years
    geom_point(
      data = expanded %>% filter(is.na(amount_m)),
      aes(y = 0),
      shape = 4,
      size = 3,
      color = colors$medium_gray,
      stroke = 1.5
    ) +
    # Data labels
    geom_text(
      aes(label = ifelse(is.na(amount_m), "", paste0("$", round(amount_m), "M"))),
      vjust = -0.5,
      size = 4,
      color = colors$primary
    ) +
    scale_fill_manual(
      values = category_colors,
      guide = "none"
    ) +
    scale_y_continuous(
      labels = function(x) paste0("$", x, "M"),
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.2))
    ) +
    facet_wrap(~ category_label, ncol = 3, scales = "free_y") +
    labs(
      x = NULL,
      y = NULL
    ) +
    theme_dashboard() +
    theme(
      strip.text = element_text(size = 11, face = "bold", color = colors$primary),
      strip.background = element_rect(fill = "#f7fafc", color = NA),
      panel.spacing = unit(1, "lines"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 11)
    )

  ggplotly(p, tooltip = c("x", "y")) %>%
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
  # Create labels for program types
  program_labels <- c(
    "emergency_shelter" = "Emergency\nShelter",
    "transitional_housing" = "Transitional\nHousing",
    "rapid_rehousing" = "Rapid\nRe-Housing",
    "permanent_supportive_housing" = "Permanent\nSupportive Housing"
  )

  program_colors <- c(
    "emergency_shelter" = "#c53030",
    "transitional_housing" = "#d69e2e",
    "rapid_rehousing" = "#319795",
    "permanent_supportive_housing" = "#805ad5"
  )

  # Reshape for stacked bar
  plot_data <- hic_df %>%
    mutate(
      program_label = program_labels[program_type],
      other_funded = total_system - kcrha_funded
    ) %>%
    tidyr::pivot_longer(
      cols = c(kcrha_funded, other_funded),
      names_to = "funding_source",
      values_to = "beds"
    ) %>%
    mutate(
      funding_label = ifelse(funding_source == "kcrha_funded", "KCRHA-Funded", "Other Sources")
    )

  p <- ggplot(plot_data, aes(x = program_label, y = beds, fill = funding_source)) +
    geom_col(position = "stack", width = 0.7) +
    geom_text(
      data = hic_df,
      aes(x = program_labels[program_type], y = total_system,
          label = format(total_system, big.mark = ",")),
      inherit.aes = FALSE,
      vjust = -0.5,
      size = 4,
      color = colors$primary
    ) +
    scale_fill_manual(
      values = c("kcrha_funded" = "#319795", "other_funded" = "#e2e8f0"),
      labels = c("kcrha_funded" = "KCRHA-Funded", "other_funded" = "Other Sources")
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.15))
    ) +
    labs(
      x = NULL,
      y = "Beds/Units"
    ) +
    theme_dashboard() +
    theme(
      axis.text.x = element_text(size = 11),
      legend.position = "bottom"
    )

  ggplotly(p, tooltip = c("x", "y", "fill")) %>%
    layout(hovermode = "x unified")
}

# Chart 5: Tiny Home Village Outcomes comparison
chart_thv_outcomes <- function(thv_df) {
  # Get exit rate data across years
  exit_data <- thv_df %>%
    filter(metric == "exit_to_permanent_housing_pct") %>%
    arrange(year)

  p <- ggplot(exit_data, aes(x = factor(year), y = value)) +
    geom_col(fill = "#38a169", width = 0.6) +
    # Comparison line for congregate shelter
    geom_hline(
      yintercept = 19,
      linetype = "dashed",
      color = colors$negative,
      size = 1
    ) +
    # National average line
    geom_hline(
      yintercept = 32,
      linetype = "dashed",
      color = colors$alert,
      size = 1
    ) +
    geom_text(
      aes(label = paste0(value, "%")),
      vjust = -0.5,
      size = 4.5,
      color = colors$primary
    ) +
    scale_y_continuous(
      labels = function(x) paste0(x, "%"),
      limits = c(0, 75),
      expand = expansion(mult = c(0, 0.1))
    ) +
    labs(
      x = NULL,
      y = "Exit to Permanent Housing",
      title = "Tiny Home Villages vs Other Shelter Types",
      subtitle = "Congregate = traditional shared dorm-style shelters"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(size = 13, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 11, hjust = 0.5, color = "#718096")
    )

  # Use plotly annotations instead of ggplot annotate for better rendering
  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(
      hovermode = "x",
      annotations = list(
        list(
          x = 1, xref = "paper", xanchor = "right",
          y = 19, yref = "y", yanchor = "bottom",
          text = "Congregate shelter (19%)",
          showarrow = FALSE,
          font = list(size = 12, color = colors$negative)
        ),
        list(
          x = 1, xref = "paper", xanchor = "right",
          y = 32, yref = "y", yanchor = "bottom",
          text = "National avg (32%)",
          showarrow = FALSE,
          font = list(size = 12, color = colors$alert)
        )
      )
    )
}

# Chart 6: Locked Tiny Homes Over Time
chart_locked_units <- function(housing_df) {
  # Get locked units data
  locked_data <- housing_df %>%
    filter(status == "locked_in_storage") %>%
    arrange(date)

  # Add a future projection point for Wilson's term
  wilson_start <- as.Date("2026-01-03")

  # Create plot data with Wilson baseline
  plot_data <- locked_data %>%
    select(date, count) %>%
    bind_rows(
      tibble(
        date = wilson_start,
        count = max(locked_data$count)  # Start at current level
      )
    )

  p <- ggplot(plot_data, aes(x = date, y = count)) +
    # Area fill
    geom_area(fill = "#fef3c7", alpha = 0.7) +
    # Line
    geom_line(color = "#d97706", size = 2) +
    # Points
    geom_point(color = "#92400e", size = 4) +
    # Data labels
    geom_text(
      aes(label = count),
      vjust = -1,
      size = 5,
      fontface = "bold",
      color = "#92400e"
    ) +
    # Wilson start line
    geom_vline(
      xintercept = wilson_start,
      linetype = "dashed",
      color = "#319795",
      size = 1
    ) +
    # Annotation for Wilson
    annotate(
      "text",
      x = wilson_start + 30,
      y = max(plot_data$count) * 0.5,
      label = "Wilson\nstarts",
      hjust = 0,
      size = 4,
      color = "#319795",
      fontface = "bold"
    ) +
    scale_y_continuous(
      limits = c(0, max(plot_data$count) * 1.2),
      expand = expansion(mult = c(0, 0.05)),
      breaks = seq(0, 300, 50)
    ) +
    scale_x_date(
      date_breaks = "6 months",
      date_labels = "%b\n%Y",
      limits = c(min(plot_data$date) - 30, wilson_start + 180)
    ) +
    labs(
      x = NULL,
      y = "Units Locked in Storage",
      title = "Tiny Homes Locked in Storage"
    ) +
    theme_dashboard() +
    theme(
      plot.title = element_text(
        size = 14,
        face = "bold",
        color = "#92400e",
        hjust = 0.5
      ),
      panel.grid.major.y = element_line(color = "#e2e8f0")
    )

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(hovermode = "x unified")
}
