#' Plot (broken) spaghetti
#'
#' Draws subject-wise longitudinal ("spaghetti") plots for repeated-measures data, 
#' with options for color, faceting, and interactivity.
#'
#' @param data A data frame or tibble containing the data.
#' @param y Name of the outcome variable to plot on y-axis.
#' @param id Name of the subject ID variable.
#' @param x Name of the time variable (default is "age").
#' @param color_by Optional, variable name for coloring lines/points by group (e.g., sex).
#' @param split_by Optional, variable name for faceting the plot (e.g., nationality).
#' @param split_ncol Optional, number of columns for facet_wrap.
#' @param split_nrow Optional, number of rows for facet_wrap.
#' @param hide_legend Logical; if TRUE, hides the color legend.
#' @param interactive Logical; if TRUE, returns an interactive plotly plot.
#' @param title Character; plot title.
#' @param ... Additional arguments passed to geom_point().
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point theme_bw facet_wrap labs theme
#' 
#' @return A ggplot or plotly object.
#'
#' @examples
#' # Basic spaghetti plot
#' spaghetti(anthropometry, y = "head_circumference", id = "id")
#' # Facet by nationality, color by sex
#' spaghetti(anthropometry, y = "height", id = "id", color_by = "sex", split_by = "nationality")
#' # Interactive plot
#' spaghetti(anthropometry, y = "bmi", id = "id", color_by = "sex", interactive = TRUE)
#'
#' @export
spaghetti <- function(data, y, id, x="age",
  color_by = NULL, 
                      split_by = NULL, 
                      split_ncol = NULL,
                      split_nrow = NULL, 
                      hide_legend = FALSE, 
                      interactive = FALSE, 
                      title = 'Spaghetti',
                    ...) {

  # Defensive variable checks
  if (!x %in% names(data)) stop(sprintf("x = '%s' not found in data.", x))
  if (!y %in% names(data)) stop(sprintf("y = '%s' not found in data.", y))
  if (!id %in% names(data)) stop(sprintf("id = '%s' not found in data.", id))
  if (!is.null(color_by) && !color_by %in% names(data)) stop(sprintf("color_by = '%s' not found in data.", color_by))
  if (!is.null(split_by) && !split_by %in% names(data)) stop(sprintf("split_by = '%s' not found in data.", split_by))
  
  # tmp
  y_lab <- y
  x_lab <- x
  point_size <- 1

  # Construct aes mapping
  aes_args <- list(
    x = data[[x]],
    y = data[[y]],
    group = data[[id]],
    text = paste("ID:", data[[id]]) # Add id info for tooltip
  )
  if (!is.null(color_by)) aes_args$color <- data[[color_by]]

  p <- ggplot(data, do.call(aes, aes_args)) +
    geom_line(alpha = 0.2, na.rm = TRUE) + # Semi-transparent lines for each subject
    geom_point(size = 1, na.rm = TRUE, ...) + # Points at each measurement
    labs(x = x_lab, y = y_lab, title = title) +
    theme_bw()
  
  if (hide_legend) {
    p <- p + theme(legend.position = "none") # e.g., if too many color levels
  }
  
  # Add facet_wrap if a faceting variable is provided
  if (!is.null(split_by)) {
    p <- p + facet_wrap(rlang::parse_expr(split_by), ncol=split_ncol, nrow=split_nrow)
  }
  
  if (interactive) {
    if (!requireNamespace("plotly", quietly = TRUE)) stop("Please install 'plotly' for interactive plots.")
    # Make interactive, show only ID on hover
    plotly::ggplotly(p, tooltip = "text")
  } else {
    p
  }

  # if (!is.null(filename)) { ggsave(filename, width=width, height=height) }
  return(p)
} 