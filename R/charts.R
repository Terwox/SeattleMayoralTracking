# Chart Components
# Seattle Mayoral Accountability Dashboard

library(ggplot2)
library(scales)
library(plotly)

# Color palette
colors <- list(
  primary = "#2d3748",      # Dark slate
  accent = "#319795",       # Teal
  alert = "#d69e2e",        # Amber
  negative = "#c53030",     # Muted red
  light_gray = "#e2e8f0",
  medium_gray = "#a0aec0",
  deployed = "#319795",     # Teal
  locked = "#d69e2e",       # Amber
  construction = "#a0aec0"  # Gray
)

# Mayoral transition dates
mayoral_transitions <- data.frame(
  date = as.Date(c("2022-01-01", "2026-01-01")),
  mayor = c("Harrell", "Wilson")
)

# Base theme for all charts
theme_dashboard <- function() {
  theme_minimal() +
    theme(
      text = element_text(family = "sans", color = colors$primary),
      plot.title = element_text(size = 14, face = "bold", margin = margin(b = 10)),
      plot.subtitle = element_text(size = 11, color = colors$medium_gray),
      axis.title = element_text(size = 10),
      axis.text = element_text(size = 9),
      legend.position = "bottom",
      legend.title = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

# Chart 1: Unsheltered Population Time Series
chart_unsheltered <- function(pit_df) {
  # Separate official PIT counts from estimates
  official <- pit_df %>% filter(is_official_pit)
  estimates <- pit_df %>% filter(!is_official_pit)

  p <- ggplot() +
    # Mayoral transition lines
    geom_vline(
      data = mayoral_transitions,
      aes(xintercept = date),
      linetype = "dashed",
      color = colors$medium_gray,
      linewidth = 0.5
    ) +
    # Mayoral labels
    geom_text(
      data = mayoral_transitions,
      aes(x = date, y = Inf, label = mayor),
      hjust = -0.1, vjust = 1.5,
      size = 3, color = colors$medium_gray
    ) +
    # Quarterly estimates line
    geom_line(
      data = estimates,
      aes(x = date, y = total_homeless),
      color = colors$accent,
      linewidth = 1,
      alpha = 0.7
    ) +
    # Official PIT points
    geom_point(
      data = official,
      aes(x = date, y = unsheltered),
      color = colors$primary,
      size = 3
    ) +
    # Official PIT connecting line
    geom_line(
      data = official,
      aes(x = date, y = unsheltered),
      color = colors$primary,
      linewidth = 0.5,
      linetype = "dotted"
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.1))
    ) +
    scale_x_date(
      date_breaks = "2 years",
      date_labels = "%Y"
    ) +
    labs(
      x = NULL,
      y = "People"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(
      hovermode = "x unified",
      legend = list(orientation = "h", y = -0.15)
    )
}

# Chart 2: Housing Progress Bar (returns HTML/plot components)
chart_housing_progress <- function(housing_summary) {
  # Create data for stacked bar
  bar_data <- data.frame(
    status = factor(
      c("Deployed", "Ready (Locked)", "Construction"),
      levels = c("Construction", "Ready (Locked)", "Deployed")
    ),
    count = c(
      housing_summary$deployed,
      housing_summary$locked,
      housing_summary$construction
    ),
    color = c(colors$deployed, colors$alert, colors$construction)
  )

  p <- ggplot(bar_data, aes(x = 1, y = count, fill = status)) +
    geom_col(width = 0.6) +
    geom_hline(yintercept = 4000, linetype = "dashed", color = colors$primary, linewidth = 1) +
    annotate("text", x = 1.4, y = 4000, label = "4,000 Target",
             hjust = 0, size = 3, color = colors$primary) +
    coord_flip() +
    scale_fill_manual(
      values = c(
        "Deployed" = colors$deployed,
        "Ready (Locked)" = colors$alert,
        "Construction" = colors$construction
      )
    ) +
    scale_y_continuous(
      limits = c(0, 4500),
      labels = comma,
      expand = c(0, 0)
    ) +
    labs(x = NULL, y = "Units") +
    theme_dashboard() +
    theme(
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.grid.major.y = element_blank()
    )

  ggplotly(p, tooltip = c("fill", "y")) %>%
    layout(legend = list(orientation = "h", y = -0.3))
}

# Chart 3: Overdose Deaths Area Chart
chart_overdose <- function(overdose_df) {
  p <- ggplot(overdose_df, aes(x = month)) +
    # Mayoral transition lines
    geom_vline(
      data = mayoral_transitions,
      aes(xintercept = date),
      linetype = "dashed",
      color = colors$medium_gray,
      linewidth = 0.5
    ) +
    # Area for homeless deaths
    geom_area(
      aes(y = homeless_overdose_deaths),
      fill = colors$negative,
      alpha = 0.3
    ) +
    # Line for monthly values
    geom_line(
      aes(y = homeless_overdose_deaths),
      color = colors$negative,
      linewidth = 0.5
    ) +
    # Rolling average overlay
    geom_line(
      aes(y = rolling_avg),
      color = colors$primary,
      linewidth = 1.2,
      na.rm = TRUE
    ) +
    scale_y_continuous(
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.1))
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y"
    ) +
    labs(
      x = NULL,
      y = "Deaths"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(hovermode = "x unified")
}

# Chart 4: Cost Per Person Housed Bar Chart
chart_cost_per_person <- function(cost_data) {
  p <- ggplot(cost_data, aes(x = factor(fiscal_year), y = cost_per_person)) +
    geom_col(fill = colors$accent, width = 0.7) +
    geom_line(
      aes(x = as.numeric(factor(fiscal_year)), y = cost_per_person),
      color = colors$primary,
      linewidth = 1,
      group = 1
    ) +
    geom_point(
      aes(x = as.numeric(factor(fiscal_year)), y = cost_per_person),
      color = colors$primary,
      size = 2
    ) +
    scale_y_continuous(
      labels = dollar,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.1))
    ) +
    labs(
      x = NULL,
      y = "Cost per placement"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(hovermode = "x")
}

# Supplementary chart: Housing units over time
chart_housing_timeline <- function(housing_df) {
  # Aggregate by date and status
  timeline_data <- housing_df %>%
    group_by(date, status) %>%
    summarise(total = sum(count), .groups = "drop") %>%
    mutate(status = factor(status,
                           levels = c("construction", "ready_locked", "deployed"),
                           labels = c("Construction", "Ready (Locked)", "Deployed")))

  p <- ggplot(timeline_data, aes(x = date, y = total, fill = status)) +
    geom_area(position = "stack", alpha = 0.8) +
    scale_fill_manual(
      values = c(
        "Deployed" = colors$deployed,
        "Ready (Locked)" = colors$alert,
        "Construction" = colors$construction
      )
    ) +
    scale_y_continuous(
      labels = comma,
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.1))
    ) +
    labs(x = NULL, y = "Units") +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y", "fill")) %>%
    layout(legend = list(orientation = "h", y = -0.15))
}
