#' Map chokepoint risk levels
#'
#' Launch an interactive map of the chokepoints, coloured by risk level, for the
#' dimensions you select. Filtering works exactly like \code{\link{cp_data}}:
#' choose any combination of locations, risks, risk levels and category, and the
#' map shows the matching records. Each chokepoint is drawn as a circle coloured
#' by its highest matching risk level and sized by how many matching records it
#' has; the popup lists the risks, levels and documented incidents.
#'
#' @param locations,risks,levels,category Optional filters passed through to
#'   \code{\link{cp_data}} (any left \code{NULL} is not filtered on).
#' @param incidents_only If \code{TRUE}, map only records with a documented
#'   incident. Default \code{FALSE}.
#'
#' @return A \pkg{leaflet} map widget (invisibly returned; auto-prints in
#'   interactive sessions). Requires the suggested package \pkg{leaflet}.
#' @export
#'
#' @seealso \code{\link{cp_data}}, \code{\link{cp_search}}.
#'
#' @examples
#' \donttest{
#' if (requireNamespace("leaflet", quietly = TRUE)) {
#'   # All high risks:
#'   cp_map(levels = "High risk")
#'   # Weather and climate risks only:
#'   cp_map(category = "Weather and climate risk")
#' }
#' }
cp_map <- function(locations = NULL,
                     risks = NULL,
                     levels = NULL,
                     category = NULL,
                     incidents_only = FALSE) {
  if (!requireNamespace("leaflet", quietly = TRUE))
    stop("Package 'leaflet' is required for cp_map(). ",
         "Install it with install.packages('leaflet').", call. = FALSE)

  d <- cp_data(locations = locations, risks = risks,
                 levels = levels, category = category)
  if (isTRUE(incidents_only)) d <- d[!is.na(d$incident), , drop = FALSE]
  if (nrow(d) == 0L)
    stop("No records match the selected dimensions.", call. = FALSE)

  lvl_rank <- c("Low risk" = 1L, "Medium risk" = 2L, "High risk" = 3L)

  # Per-location summary.
  agg <- lapply(split(d, d$location), function(g) {
    top <- names(lvl_rank)[max(lvl_rank[g$level], na.rm = TRUE)]
    inc <- g[!is.na(g$incident), , drop = FALSE]
    inc_txt <- if (nrow(inc)) paste0(
      "<br/><b>Incidents:</b><ul>",
      paste0("<li>", inc$incident, " <i>(", inc$risk, ", ",
             ifelse(is.na(inc$incident_year), "", inc$incident_year),
             ")</i></li>", collapse = ""),
      "</ul>"
    ) else ""
    popup <- paste0(
      "<b>", g$location[1], "</b><br/>",
      "Top risk level: <b>", top, "</b><br/>",
      "Matching records: ", nrow(g),
      " (", nrow(inc), " documented incidents)",
      inc_txt
    )
    data.frame(location = g$location[1], top_level = top,
               n_records = nrow(g), n_incidents = nrow(inc),
               popup = popup, stringsAsFactors = FALSE)
  })
  agg <- do.call(rbind, agg)

  m <- merge(agg, chokepoints, by = "location")
  m$top_level <- factor(m$top_level,
                        levels = c("Low risk", "Medium risk", "High risk"))

  pal <- leaflet::colorFactor(
    palette = c("#2ca25f", "#f0a30a", "#d7301f"),
    domain  = c("Low risk", "Medium risk", "High risk")
  )

  map <- leaflet::leaflet(m)
  map <- leaflet::addTiles(map)
  map <- leaflet::addCircleMarkers(
    map,
    lng = ~longitude, lat = ~latitude,
    radius = ~ 6 + 2.2 * n_records,
    color = ~ pal(top_level), fillColor = ~ pal(top_level),
    weight = 1, opacity = 1, fillOpacity = 0.7,
    label = ~location, popup = ~popup
  )
  map <- leaflet::addLegend(
    map, position = "bottomright", pal = pal,
    values = ~top_level, title = "Top risk level", opacity = 1
  )
  map
}
