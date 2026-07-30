#' Chokepoint resilience profiles
#'
#' Return the per-chokepoint resilience profile for the eight maritime
#' chokepoints: importance and systemic-risk measures, network centrality, route
#' redundancy, recent disruption counts, and composite resilience and
#' vulnerability indices. See \code{\link{chokepoint_resilience}} for the full
#' column dictionary and how the composite indices are built.
#'
#' @param sort_by Ordering of the returned rows: "vulnerability_index"
#'   (default, most vulnerable first), "resilience_index" (most resilient
#'   first), or "location" (alphabetical).
#'
#' @return A data frame, one row per chokepoint: the bundled
#'   \code{\link{chokepoint_resilience}} table in the requested order.
#' @export
#'
#' @seealso \code{\link{cp_map}} to map it, \code{\link{cp_data}} for the
#'   underlying incidents.
#'
#' @examples
#' cp_resilience()
#' cp_resilience(sort_by = "resilience_index")
#' cp_resilience()[, c("location", "vulnerability_index", "resilience_index")]
cp_resilience <- function(sort_by = c("vulnerability_index",
                                      "resilience_index", "location")) {
  sort_by <- match.arg(sort_by)
  d <- chokepoint_resilience
  ord <- if (sort_by == "location") order(d$location) else order(-d[[sort_by]])
  d <- d[ord, , drop = FALSE]
  rownames(d) <- NULL
  d
}
