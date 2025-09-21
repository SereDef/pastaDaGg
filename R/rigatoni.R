#' @title
#' Plot rigatoni
#'
#' @description
#' Draws box ("rigatoni") plots for grouped data. 
#' This works for repeated-measures for example.
#' Various options are available for color, faceting. 
#'
#' @param data A data frame or tibble containing the data.
#' @param x Name of the grouping variable.
#' @param y Name of the outcome variable to plot on y-axis.
#' @param color_by Variable name for coloring boxplots (defaults to x)
#' @param split_by Optional, variable name for faceting the plot
#' @param split_ncol Optional, number of columns for facet_wrap.
#' @param split_nrow Optional, number of rows for facet_wrap.
#' @param hide_legend Logical; if TRUE, hides the color legend.
#' @param title Character; plot title.
#' @param y_lab Character; y-axis label (default is y variable name).
#' @param x_lab Character; x-axis label (default is x variable name).
#'
#' @importFrom ggplot2 ggplot aes geom_boxplot position_dodge stat_summary 
#' theme_minimal facet_wrap labs theme
#' 
#' @return A ggplot or plotly object.
#'
#' @examples
#' rigatoni(anthropometry, 
#'          x = 'nationality', y = 'bmi', split_by='sex')
#' @export
#' 
rigatoni <- function(
  data, x, y, 
  color_by = x,
  split_by = NULL,
  split_nrow = NULL,
  split_ncol = NULL,
  hide_legend = TRUE,
  # interactive = FALSE,
  title = 'Rigatoni',
  y_lab = y, 
  x_lab = x) {
  
  # Defensive variable checks
  if (!x %in% names(data)) stop(sprintf("x = '%s' not found in data.", x))
  if (!y %in% names(data)) stop(sprintf("y = '%s' not found in data.", y))
  if (!is.null(color_by) && !color_by %in% names(data)) stop(sprintf("color_by = '%s' not found in data.", color_by))
  if (!is.null(split_by) && !split_by %in% names(data)) stop(sprintf("split_by = '%s' not found in data.", split_by))
  
  # Construct aes mapping
  aes_args <- list(
    x = data[[x]],
    y = data[[y]]
  )
  if (!is.null(color_by)) aes_args$fill <- data[[color_by]]
  
  p <- ggplot(data, do.call(aes, aes_args)) +
    geom_boxplot(position = position_dodge(width = 0.8), width = 0.6) +
    stat_summary(
      fun = mean, geom = "point", shape = 23, size = 2, 
      color = "black", fill = "white", position = position_dodge(width = 0.8)) +
    labs(x =  x_lab, y = y_lab, title = title) +
    theme_minimal()

  # Add facet_wrap if a faceting variable is provided
  if (!is.null(split_by)) {
    # vars(!!rlang::ensym(split_by))
    p <- p + facet_wrap(rlang::parse_expr(split_by), ncol=split_ncol, nrow=split_nrow, 
                        scales = "free_y") 
  }

  if (hide_legend) {
    p <- p + theme(legend.position = "none") # e.g., if too many color levels
  }

  # if (!is.null(filename)) { ggsave(filename, width=width, height=height) }
  return(p)
}