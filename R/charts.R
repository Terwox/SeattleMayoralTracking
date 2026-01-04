# Chart Components
# Seattle Mayoral Accountability Dashboard
# VERIFIED DATA ONLY

library(ggplot2)
library(scales)
library(plotly)

# Color palette
colors <- list(
  primary = "#2d3748",
  accent = "#319795",
  alert = "#d69e2e",
  negative = "#c53030",
  light_gray = "#e2e8f0",

medium_gray = "#a0aec0"
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
      size = 3,
      color = colors$primary
    ) +
    # Data labels for unsheltered
    geom_text(
      aes(y = unsheltered, label = format(unsheltered, big.mark = ",")),
      vjust = 1.5,
      size = 2.5,
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
      size = 3,
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

# Chart 3: Spending Over Time
chart_spending <- function(spending_df) {
  # Aggregate by year
  by_year <- spending_df %>%
    group_by(year) %>%
    summarise(total = sum(amount) / 1e6, .groups = "drop")

  p <- ggplot(by_year, aes(x = factor(year), y = total)) +
    geom_col(fill = colors$accent, width = 0.7) +
    geom_text(
      aes(label = paste0("$", round(total), "M")),
      vjust = -0.5,
      size = 3,
      color = colors$primary
    ) +
    scale_y_continuous(
      labels = function(x) paste0("$", x, "M"),
      limits = c(0, NA),
      expand = expansion(mult = c(0, 0.15))
    ) +
    labs(
      x = NULL,
      y = "Millions"
    ) +
    theme_dashboard()

  ggplotly(p, tooltip = c("x", "y")) %>%
    layout(hovermode = "x")
}
