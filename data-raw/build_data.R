# =============================================================================
# build_data.R
#
# Reproducible build of the bundled datasets shipped in data/:
#   * chokepoints          - reference metadata for the 8 maritime chokepoints
#   * risk_types           - the risk taxonomy (11 risks in 3 categories)
#   * chokepoint_risks     - documented disruption incidents (2018 on)
#   * chokepoint_resilience- per-chokepoint resilience profile + composite index
#
# Inputs (data-raw/): chokepoints.csv, incidents_recent.csv, eia_oil_transit.csv,
#   chokepoint_redundancy.csv, zenodo_chokepoint_summary.csv +
#   network_centrality.csv (from prep_zenodo.R), and chokepoint_context.csv +
#   chokepoint_sources.csv (from prep_context.R).
#
# Run from the package root:  Rscript data-raw/build_data.R
# =============================================================================

suppressPackageStartupMessages({ library(dplyr); library(readr) })
here <- function(...) file.path("data-raw", ...)
norm01 <- function(x) {
  r <- range(x, na.rm = TRUE)
  if (diff(r) == 0) rep(0.5, length(x)) else (x - r[1]) / diff(r)
}

# ---- Risk taxonomy (reference) ---------------------------------------------
risk_types <- tibble::tribble(
  ~risk_code, ~risk,                        ~risk_category,
  "W-T",      "Temperature extremes",       "Weather and climate risk",
  "W-F/D",    "Flood and drought",          "Weather and climate risk",
  "W-S",      "Storms",                     "Weather and climate risk",
  "W-H/F",    "Haze and fog",               "Weather and climate risk",
  "S-C",      "Conflict",                   "Security and conflict risk",
  "S-T",      "Terrorist attack",           "Security and conflict risk",
  "S-P",      "Piracy",                     "Security and conflict risk",
  "S-C/A",    "Cyberattack",                "Security and conflict risk",
  "P-T",      "Trade and transit controls", "Political and institutional risk",
  "P-D",      "Disrepair",                  "Political and institutional risk",
  "P-U",      "Unforced delays",            "Political and institutional risk"
) |> as.data.frame(stringsAsFactors = FALSE)
VALID_LEVELS <- c("Low risk", "Medium risk", "High risk")

# ---- Chokepoint reference (8 maritime straits/canals) ----------------------
chokepoints <- read_csv(here("chokepoints.csv"), show_col_types = FALSE) |>
  as.data.frame(stringsAsFactors = FALSE)
VALID_LOCATIONS <- chokepoints$location

# ---- Incident log (2018 on), scoped to the 8 chokepoints -------------------
cols <- c("location", "incident_year", "risk", "risk_category", "risk_code",
          "level", "incident", "source", "source_url")
raw <- suppressWarnings(read_csv(here("incidents_recent.csv"), show_col_types = FALSE)) |>
  mutate(incident_year = as.character(incident_year))
dropped <- sort(unique(raw$location[!raw$location %in% VALID_LOCATIONS]))
if (length(dropped))
  message("Scoping incidents to maritime chokepoints; dropping: ", toString(dropped))
chokepoint_risks <- raw |> filter(location %in% VALID_LOCATIONS)

stopifnot(all(chokepoint_risks$risk_code %in% risk_types$risk_code),
          all(chokepoint_risks$level %in% VALID_LEVELS),
          all(grepl("^https?://", chokepoint_risks$source_url)))
chokepoint_risks <- chokepoint_risks[cols] |>
  mutate(across(everything(), ~ ifelse(.x == "", NA, .x))) |>
  as.data.frame(stringsAsFactors = FALSE)

# ---- Resilience profile + composite index ----------------------------------
eia    <- read_csv(here("eia_oil_transit.csv"), show_col_types = FALSE)
redund <- read_csv(here("chokepoint_redundancy.csv"), show_col_types = FALSE)
zsum   <- read_csv(here("zenodo_chokepoint_summary.csv"), show_col_types = FALSE)
cent   <- read_csv(here("network_centrality.csv"), show_col_types = FALSE)
inc_n  <- chokepoint_risks |> count(location, name = "n_incidents")

WORLD_MARITIME_OIL_MBD <- 79.8  # EIA, 1H2025 baseline

chokepoint_resilience <- chokepoints |>
  select(location, type, region) |>
  left_join(eia,    by = "location") |>
  left_join(zsum,   by = "location") |>
  left_join(redund, by = "location") |>
  left_join(cent,   by = "location") |>
  left_join(inc_n,  by = "location") |>
  mutate(
    n_incidents         = coalesce(as.integer(n_incidents), 0L),
    oil_share_world_pct = round(oil_transit_mbd / WORLD_MARITIME_OIL_MBD * 100, 1),
    # importance blends total maritime trade value with strategic oil transit
    # (oil missing => 0), so oil chokepoints like Hormuz are not understated.
    importance_score    = round((norm01(trade_value_bn_usd) +
                                 norm01(coalesce(oil_transit_mbd, 0))) / 2, 2),
    dependency_score    = round(norm01(n_dependent_countries), 2),
    systemic_risk_score = round(norm01(evtd_bn_usd), 2),
    redundancy_score    = substitutability,   # already 0-1 (higher = more alternatives)
    exposure_score      = round((importance_score + dependency_score + systemic_risk_score) / 3, 2),
    resilience_index    = round(100 * redundancy_score),
    vulnerability_index = round(100 * exposure_score * (1 - redundancy_score))
  ) |>
  arrange(desc(vulnerability_index)) |>
  select(location, type, region,
         oil_transit_mbd, oil_share_world_pct,
         trade_value_bn_usd, n_dependent_countries, max_dependency, evtd_bn_usd,
         betweenness_centrality, betweenness_weighted,
         degree_centrality, strength_weighted, harmonic_centrality, pagerank,
         has_alternative, alt_route, extra_days, bypass_capacity_mbd,
         n_incidents,
         importance_score, dependency_score, systemic_risk_score,
         redundancy_score, exposure_score,
         resilience_index, vulnerability_index) |>
  as.data.frame(stringsAsFactors = FALSE)

# ---- Context profile + per-figure provenance -------------------------------
chokepoint_context <- read_csv(here("chokepoint_context.csv"), show_col_types = FALSE) |>
  as.data.frame(stringsAsFactors = FALSE)
chokepoint_sources <- read_csv(here("chokepoint_sources.csv"), show_col_types = FALSE) |>
  as.data.frame(stringsAsFactors = FALSE)

stopifnot(setequal(chokepoint_context$location, VALID_LOCATIONS),
          all(chokepoint_sources$location %in% VALID_LOCATIONS),
          all(chokepoint_sources$confidence %in% c("High", "Medium", "Low")))

# ---- Write ------------------------------------------------------------------
usethis::use_data(chokepoints, overwrite = TRUE, compress = "xz")
usethis::use_data(risk_types, overwrite = TRUE, compress = "xz")
usethis::use_data(chokepoint_risks, overwrite = TRUE, compress = "xz")
usethis::use_data(chokepoint_resilience, overwrite = TRUE, compress = "xz")
usethis::use_data(chokepoint_context, overwrite = TRUE, compress = "xz")
usethis::use_data(chokepoint_sources, overwrite = TRUE, compress = "xz")

message("Built: chokepoints (", nrow(chokepoints), "), risk_types (",
        nrow(risk_types), "), chokepoint_risks (", nrow(chokepoint_risks),
        "), chokepoint_resilience (", nrow(chokepoint_resilience),
        "), chokepoint_context (", nrow(chokepoint_context),
        "), chokepoint_sources (", nrow(chokepoint_sources), ").")
