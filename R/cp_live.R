# Optional runtime wrapper around a live, public-domain hazard feed.
# This NEVER bundles third-party data: it fetches on demand and fails gracefully
# (returning NULL with a warning) when offline or when the service is
# unavailable, so package examples/tests remain CRAN-safe.

# Internal: fetch + parse JSON defensively. Returns parsed object or NULL.
.cp_fetch_json <- function(url) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    warning("Package 'jsonlite' is required for live queries.", call. = FALSE)
    return(NULL)
  }
  tryCatch(
    jsonlite::fromJSON(url, flatten = TRUE),
    error = function(e) {
      warning("Live query failed: ", conditionMessage(e), call. = FALSE)
      NULL
    }
  )
}

#' Recent hazard signals near a chokepoint
#'
#' Retrieve recent natural-hazard events near a chokepoint as a simple
#' resilience "signal". The current implementation queries the USGS earthquake
#' catalogue (public domain) within a radius of the chokepoint's representative
#' coordinates. Designed as a lightweight, extensible starting point for
#' near-real-time risk monitoring. No third-party data is redistributed by the
#' package; events are fetched on demand.
#'
#' @param location A chokepoint name present in \code{\link{chokepoints}}.
#' @param days Look-back window in days (default 30).
#' @param radius_km Search radius around the chokepoint, in km (default 500).
#' @param min_magnitude Minimum earthquake magnitude (default 4.5).
#'
#' @return A data frame of events (time, magnitude, place, coordinates, URL), an
#'   empty data frame if none are found, or \code{NULL} if the request fails
#'   (e.g. no internet connection).
#'
#' @section Data source:
#' USGS Earthquake Hazards Program FDSN event service
#' (\url{https://earthquake.usgs.gov/fdsnws/event/1/}). USGS data are in the
#' public domain.
#'
#' @export
#' @examples
#' \donttest{
#' # Requires an internet connection:
#' sig <- cp_signals("Strait of Hormuz", days = 90, min_magnitude = 4.5)
#' head(sig)
#' }
cp_signals <- function(location,
                         days = 30,
                         radius_km = 500,
                         min_magnitude = 4.5) {
  if (missing(location) || length(location) != 1L)
    stop("Please supply a single `location`.", call. = FALSE)
  cp <- chokepoints[chokepoints$location == location, , drop = FALSE]
  if (nrow(cp) == 0L)
    stop("Unknown location: ", location,
         ". See chokepoints$location.", call. = FALSE)

  starttime <- format(Sys.Date() - as.integer(days), "%Y-%m-%d")
  url <- paste0(
    "https://earthquake.usgs.gov/fdsnws/event/1/query",
    "?format=geojson",
    "&starttime=", starttime,
    "&latitude=", cp$latitude[1],
    "&longitude=", cp$longitude[1],
    "&maxradiuskm=", as.numeric(radius_km),
    "&minmagnitude=", as.numeric(min_magnitude),
    "&orderby=time"
  )
  res <- .cp_fetch_json(url)
  if (is.null(res)) return(NULL)
  feats <- res$features
  if (is.null(feats) || NROW(feats) == 0L) return(data.frame())

  coords <- res$features$geometry.coordinates
  lon <- vapply(coords, function(x) x[1], numeric(1))
  lat <- vapply(coords, function(x) x[2], numeric(1))
  data.frame(
    location  = location,
    time      = as.POSIXct(feats$properties.time / 1000,
                           origin = "1970-01-01", tz = "UTC"),
    magnitude = feats$properties.mag,
    place     = feats$properties.place,
    longitude = lon,
    latitude  = lat,
    url       = feats$properties.url,
    stringsAsFactors = FALSE
  )
}
