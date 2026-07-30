# Core query functions over the bundled `chokepoint_risks` dataset.

#' Query chokepoint risk data
#'
#' Find and return chokepoint risk records matching the selected parameters. Any
#' argument left as \code{NULL} (the default) is not filtered on, so
#' \code{cp_data()} returns the complete dataset.
#'
#' @param locations Character vector of chokepoint location(s).
#' @param risks Character vector of risk code(s) (see \code{\link{cp_risk}}).
#' @param levels Character vector of risk level(s): "Low risk", "Medium risk",
#'   "High risk".
#' @param category Character vector of risk category/categories.
#'
#' @return A data frame of matching rows from \code{\link{chokepoint_risks}}.
#' @export
#'
#' @seealso \code{\link{cp_location}} for the locations list,
#'   \code{\link{cp_risk}} for risk codes, and \code{\link{chokepoint_risks}} for the
#'   dataset itself.
#'
#' @examples
#' myData <- cp_data(locations = "Panama Canal", risks = "S-T")
#' myData <- cp_data(locations = c("Panama Canal", "Suez Canal"),
#'                     risks = c("S-T", "S-C"))
#' myData <- cp_data(category = "Weather and climate risk")
#' myData <- cp_data(levels = "High risk")
#' myData <- cp_data("Panama Canal", "S-T")
#' myData <- cp_data()
cp_data <- function(locations = NULL,
                      risks = NULL,
                      levels = NULL,
                      category = NULL) {
  d <- chokepoint_risks
  if (!is.null(locations)) d <- d[d$location %in% locations, , drop = FALSE]
  if (!is.null(risks))     d <- d[d$risk_code %in% risks, , drop = FALSE]
  if (!is.null(levels))    d <- d[d$level %in% levels, , drop = FALSE]
  if (!is.null(category))  d <- d[d$risk_category %in% category, , drop = FALSE]
  rownames(d) <- NULL
  d
}

#' Look up global value chain risk codes
#'
#' Return the mapping between risks (in natural language), their category and
#' their short code. Supply \code{risk} to filter to matching risks.
#'
#' @param risk Optional search string matched (case-insensitively) against the
#'   natural-language risk name. If missing, all risks are returned.
#'
#' @return A data frame with columns \code{risk}, \code{risk_category} and
#'   \code{risk_code}.
#' @export
#'
#' @seealso \code{\link{cp_location}} and \code{\link{cp_data}}.
#'
#' @examples
#' cp_risk()
#' cp_risk(risk = "storm")
#' cp_risk("attack")
cp_risk <- function(risk) {
  tab <- risk_types[, c("risk", "risk_category", "risk_code")]
  rownames(tab) <- NULL
  if (missing(risk)) {
    tab
  } else {
    hit <- grep(risk, tab$risk, ignore.case = TRUE)
    out <- tab[hit, , drop = FALSE]
    rownames(out) <- NULL
    out
  }
}

#' Look up chokepoint locations
#'
#' Return the list of chokepoint locations, optionally filtered by a search
#' string.
#'
#' @param location Optional search string matched (case-insensitively) against
#'   location names. If missing, all locations are returned.
#'
#' @return A data frame with a single \code{location} column.
#' @export
#'
#' @seealso \code{\link{cp_risk}} and \code{\link{cp_data}}.
#'
#' @examples
#' cp_location()
#' cp_location(location = "Canal")
#' cp_location("Canal")
cp_location <- function(location) {
  tab <- chokepoints[, "location", drop = FALSE]
  rownames(tab) <- NULL
  if (missing(location)) {
    tab
  } else {
    hit <- grep(location, tab$location, ignore.case = TRUE)
    out <- tab[hit, , drop = FALSE]
    rownames(out) <- NULL
    out
  }
}
