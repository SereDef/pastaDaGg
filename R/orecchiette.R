#' @title
#' Plot orecchiette
#'
#' @description
#' Draws density ("orecchiette") plots for multilevel data. 
#' This works for repeated-measures for example.
#' Various options are available for color, faceting. 
#'
#' @param data A data frame or tibble containing the data.
#' @param x Name of the outcome variable to plot on x-axis.
#' @param color_by Variable name for coloring boxplots (defaults to x)
#' @param split_by Optional, variable name for faceting the plot
#' @param hide_legend Logical; if TRUE, hides the color legend.
#' @param title Character; plot title.
#' @param y_lab Character; y-axis label (default is "Density").
#' @param x_lab Character; x-axis label (default is x variable name).
#'
#' @importFrom ggplot2 ggplot aes geom_density theme_minimal facet_grid labs theme
#' 
#' @return A ggplot or plotly object.
#'
#' @examples
#' orecchiette(anthropometry, x='head_circumference', 
#'             color_by = 'sex', split_by = 'sex~timepoint')
#' @export
#' 
orecchiette <- function(
  data, x, 
  color_by = x, 
  split_by = NULL,
  hide_legend = TRUE,
  title = 'Orecchiette',
  x_lab = x,
  y_lab = 'Density') {
  
  # Defensive variable checks
  if (!x %in% names(data)) stop(sprintf("x = '%s' not found in data.", x))
  if (!is.null(color_by) && !color_by %in% names(data)) stop(sprintf("color_by = '%s' not found in data.", color_by))

  if (!is.null(split_by)){
    split_vars = stringr::str_split(split_by, "~")[[1]]
    if (!all(split_vars %in% names(data))) stop(sprintf("split_by variables '%s' not found in data.", split_by))
  }
  
  # Construct aes mapping
  aes_args <- list(x = data[[x]])
  if (!is.null(color_by)) aes_args$color <- data[[color_by]]

  p <- ggplot(data, do.call(aes, aes_args)) +
    geom_density(na.rm = TRUE) +
    labs(x = x_lab, y = y_lab, title = title) + 
    theme_minimal()
  
  # Add facet_wrap if a faceting variable is provided
  if (!is.null(split_by)) {
    p <- p + facet_grid(rlang::parse_expr(split_by))
  }

  if (hide_legend) {
    p <- p + theme(legend.position = "none") # e.g., if too many color levels
  }
  
  # if (!is.null(filename)) { ggsave(filename, width=width, height=height) }
  return(p)
}
