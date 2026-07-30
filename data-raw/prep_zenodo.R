# =============================================================================
# prep_zenodo.R  (run once; caches summaries read by build_data.R)
#
# Aggregates the Verschuur & Hall maritime-chokepoint dataset to the 8 maritime
# chokepoints tracked by this package, and computes a panel of network-centrality
# measures on the full country-chokepoint trade-dependency network.
#
# Writes:
#   data-raw/zenodo_chokepoint_summary.csv  (trade value, dependency, EVTD)
#   data-raw/network_centrality.csv         (graph-theory indicator panel)
#
# Source: Verschuur, J. & Hall, J. (2025). "Maritime chokepoint dependencies and
# systemic risks." Nature Communications. Data: Zenodo, CC BY 4.0. The concept
# DOI <https://doi.org/10.5281/zenodo.13841881> always resolves to the latest
# version (currently record 19663059); we download that record's files.
# =============================================================================

suppressPackageStartupMessages({ library(dplyr); library(igraph) })

base <- "https://zenodo.org/api/records/19663059/files"
tmp  <- tempdir()
get  <- function(name) {
  dest <- file.path(tmp, name)
  utils::download.file(paste0(base, "/", name, "/content"), dest,
                       quiet = TRUE, mode = "wb")
  suppressWarnings(readr::read_csv(dest, show_col_types = FALSE))
}

imp <- get("country_import_dependency.csv")
er  <- get("chokepoint_systemic_economic_risk.csv")

# Map Zenodo canal names (note inconsistent casing, e.g. "Suez canal") to the
# package's canonical chokepoint names.
canon <- c(
  "Suez Canal" = "Suez Canal", "Suez canal" = "Suez Canal",
  "Panama Canal" = "Panama Canal",
  "Strait of Hormuz" = "Strait of Hormuz",
  "Bab el-Mandeb Strait" = "Strait of Bab el-Mandeb",
  "Malacca Strait" = "Strait of Malacca",
  "Bosporus Strait" = "Turkish Straits",
  "Gibraltar Strait" = "Strait of Gibraltar",
  "Dover Strait" = "Dover Strait"
)

imp_s <- imp %>%
  mutate(location = canon[canal]) %>%
  filter(!is.na(location)) %>%
  group_by(location) %>%
  summarise(
    trade_value_bn_usd    = round(sum(v_canal, na.rm = TRUE) / 1e9, 1),
    n_dependent_countries = sum(share_canal_v_mar > 0.25, na.rm = TRUE),
    max_dependency        = round(max(share_canal_v_mar, na.rm = TRUE), 2),
    .groups = "drop"
  )

er_s <- er %>%
  mutate(location = canon[canal]) %>%
  filter(!is.na(location)) %>%
  group_by(location) %>%
  summarise(evtd_bn_usd = round(sum(total_loss_USD, na.rm = TRUE) / 1e9, 2),
            .groups = "drop")

summary <- left_join(imp_s, er_s, by = "location")
readr::write_csv(summary, "data-raw/zenodo_chokepoint_summary.csv")
cat("Wrote data-raw/zenodo_chokepoint_summary.csv (", nrow(summary), " rows )\n")
print(as.data.frame(summary))

# =============================================================================
# Network centrality on the country-chokepoint dependency network
# -----------------------------------------------------------------------------
# We treat the Verschuur & Hall import-dependency table as a weighted bipartite
# network: one node per country (ISO3) and one per chokepoint, with an edge when
# a country routes at least DEP_THRESHOLD of its maritime import value through a
# chokepoint. The edge weight is that dependency share (share_canal_v_mar). The
# graph spans ALL chokepoints in the source (not only our 8), so centrality
# reflects each node's role in the whole maritime network; we then extract the 8.
#
# Indicators (all computed by igraph, not external figures):
#   * degree_centrality       - unweighted degree, rescaled to the busiest
#                               chokepoint (0-1): how many countries depend on it.
#   * strength_weighted       - weighted degree = sum of dependency shares of the
#                               countries routing through it (dependency "mass").
#   * betweenness_centrality  - UNWEIGHTED, normalized brokerage: how often the
#                               chokepoint lies on shortest country-country paths.
#   * betweenness_weighted    - brokerage on the weighted graph, with edge
#                               distance = 1 / share (stronger dependence = shorter
#                               path), igraph-normalized.
#   * harmonic_centrality     - normalized harmonic centrality (a
#                               disconnection-safe closeness): mean inverse
#                               distance to all other nodes; high = central/near.
#   * pagerank                - weighted PageRank (recursive influence; weights =
#                               share). Sums to 1 over all nodes.
#
# We deliberately DO NOT ship: eigenvector centrality or raw closeness (both
# degenerate / are hard to interpret on a bipartite graph); clustering
# coefficient (identically 0 on a bipartite graph: no triangles); and k-core
# coreness (low discrimination -- most nodes share one k -- and a
# threshold-unstable ranking in the sensitivity check below).
#
# DEP_THRESHOLD = 0.10 is a chosen parameter (sensitivity reported below). At
# 0.10 the graph is a single connected component (no isolates), so the
# closeness-type measures are well defined.
DEP_THRESHOLD <- 0.10

build_graph <- function(threshold) {
  e <- imp %>%
    filter(share_canal_v_mar >= threshold, !is.na(share_canal_v_mar)) %>%
    transmute(country = iso3, chokepoint = canal, share = share_canal_v_mar)
  g <- graph_from_data_frame(e[, c("country", "chokepoint")], directed = FALSE)
  E(g)$share <- e$share
  g
}

g <- build_graph(DEP_THRESHOLD)
cp_nodes <- intersect(names(canon), V(g)$name)   # chokepoint vertices present
cat("\nNetwork: ", vcount(g), " nodes, ", ecount(g), " edges, ",
    count_components(g), " component(s), ", sum(degree(g) == 0),
    " isolate(s).\n", sep = "")

deg  <- degree(g)
centrality <- tibble::tibble(
  canal                  = cp_nodes,
  betweenness_centrality = round(betweenness(g, directed = FALSE, normalized = TRUE)[cp_nodes], 4),
  betweenness_weighted   = round(betweenness(g, directed = FALSE, weights = 1 / E(g)$share,
                                             normalized = TRUE)[cp_nodes], 4),
  degree_centrality      = round(deg[cp_nodes] / max(deg[cp_nodes]), 4),
  n_countries_gt10pct    = as.integer(deg[cp_nodes]),
  strength_weighted      = round(strength(g, weights = E(g)$share)[cp_nodes], 2),
  harmonic_centrality    = round(harmonic_centrality(g, normalized = TRUE)[cp_nodes], 4),
  pagerank               = round(page_rank(g, weights = E(g)$share)$vector[cp_nodes], 4)
) %>%
  mutate(location = canon[canal]) %>%
  filter(!is.na(location)) %>%
  arrange(desc(betweenness_centrality)) %>%
  select(location, betweenness_centrality, betweenness_weighted,
         degree_centrality, n_countries_gt10pct, strength_weighted,
         harmonic_centrality, pagerank)

readr::write_csv(centrality, "data-raw/network_centrality.csv")
cat("Wrote data-raw/network_centrality.csv (", nrow(centrality), " rows )\n")
print(as.data.frame(centrality))

# ---- Threshold sensitivity (documents ranking stability) --------------------
# For each indicator we report the Spearman rank correlation of the 8
# chokepoints' scores between the reference threshold (0.10) and 0.05 / 0.25.
# Values near 1 mean the RANKING is robust to the threshold even if magnitudes
# move; this backs the stability claim in the data dictionary and Methodology.
score_at <- function(threshold) {
  gg  <- build_graph(threshold)
  cps <- intersect(names(canon), V(gg)$name)
  dg  <- degree(gg)
  data.frame(
    location             = canon[cps],
    betweenness          = betweenness(gg, normalized = TRUE)[cps],
    betweenness_weighted = betweenness(gg, weights = 1 / E(gg)$share, normalized = TRUE)[cps],
    degree               = dg[cps],
    strength_weighted    = strength(gg, weights = E(gg)$share)[cps],
    harmonic             = harmonic_centrality(gg, normalized = TRUE)[cps],
    pagerank             = page_rank(gg, weights = E(gg)$share)$vector[cps],
    row.names = NULL, stringsAsFactors = FALSE
  )
}
ref <- score_at(0.10)
cat("\nThreshold sensitivity (Spearman rank corr. vs 0.10 reference):\n")
for (thr in c(0.05, 0.25)) {
  alt  <- score_at(thr)
  m    <- merge(ref, alt, by = "location", suffixes = c("_ref", "_alt"))
  cols <- setdiff(names(ref), "location")
  rho  <- vapply(cols, function(cc)
    suppressWarnings(cor(m[[paste0(cc, "_ref")]], m[[paste0(cc, "_alt")]],
                         method = "spearman")), numeric(1))
  cat("  threshold ", thr, ": ",
      paste(sprintf("%s=%.2f", cols, rho), collapse = "  "), "\n", sep = "")
}
