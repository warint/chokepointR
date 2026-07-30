#' Chokepoint quantitative context profile
#'
#' Return the per-chokepoint context profile: traffic, cargo, dominant vessels,
#' top users, local economic dependence and rerouting cost. See
#' \code{\link{chokepoint_context}} for the column dictionary. Every figure is
#' traceable through \code{\link{cp_sources}}.
#'
#' @param locations Optional character vector of chokepoint names to keep
#'   (partial, case-insensitive matches are honoured). \code{NULL} (default)
#'   returns all 8.
#'
#' @return A data frame, one row per chokepoint.
#' @export
#'
#' @seealso \code{\link{cp_sources}} for per-figure citations,
#'   \code{\link{cp_resilience}} for the resilience indices.
#'
#' @examples
#' cp_context()[, c("location", "daily_transits", "primary_cargo")]
#' cp_context(locations = "Hormuz")
cp_context <- function(locations = NULL) {
  d <- chokepoint_context
  if (!is.null(locations)) {
    pat <- paste(locations, collapse = "|")
    d <- d[grepl(pat, d$location, ignore.case = TRUE), , drop = FALSE]
  }
  rownames(d) <- NULL
  d
}

#' Per-figure provenance for the context profile
#'
#' Return the citation table behind \code{\link{cp_context}}: one row per
#' quantitative figure, with source, URL, year and a confidence flag. See
#' \code{\link{chokepoint_sources}} for the column dictionary.
#'
#' @param locations Optional character vector of chokepoint names to keep
#'   (partial, case-insensitive matches). \code{NULL} (default) returns all.
#' @param min_confidence Keep only figures at or above this confidence: one of
#'   "Low" (default, keep all), "Medium" or "High".
#'
#' @return A data frame, one row per sourced figure.
#' @export
#'
#' @seealso \code{\link{cp_context}}
#'
#' @examples
#' cp_sources(locations = "Suez")
#' cp_sources(min_confidence = "High")[, c("location", "variable", "source")]
cp_sources <- function(locations = NULL,
                       min_confidence = c("Low", "Medium", "High")) {
  min_confidence <- match.arg(min_confidence)
  d <- chokepoint_sources
  rank <- c(Low = 1L, Medium = 2L, High = 3L)
  d <- d[rank[d$confidence] >= rank[[min_confidence]], , drop = FALSE]
  if (!is.null(locations)) {
    pat <- paste(locations, collapse = "|")
    d <- d[grepl(pat, d$location, ignore.case = TRUE), , drop = FALSE]
  }
  rownames(d) <- NULL
  d
}
