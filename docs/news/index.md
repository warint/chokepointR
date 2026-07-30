# Changelog

## chokepointR 0.6.0

### Refocus on the eight real maritime chokepoints (breaking)

The package is now, and only, about the eight real maritime chokepoints.
The 0.5.x “multimodal” layer shipped a large body of **synthetic**
seaport, cargo-airport and rail throughput and network edges (labelled
`example`) to demonstrate a generic engine. Shipping fabricated numbers
as a bundled dataset was the wrong call, so that layer has been removed
entirely.

**Removed** (breaking):

- Datasets `cp_nodes_data`, `cp_throughput_data`, `cp_edges_data`,
  `cp_provenance_data`, `cp_selection_data`.
- Functions `cp_select()`, `cp_compare_thresholds()`, `cp_network()`,
  `cp_metrics()`, `cp_simulate_disruption()`, `cp_rank()`, `cp_nodes()`,
  `cp_provenance()`, `cp_import_throughput()`, `cp_import_nodes()`,
  `cp_validate()`.
- The `mode`/`...` arguments of
  [`cp_resilience()`](https://warint.github.io/chokepointR/reference/cp_resilience.md)
  (it is maritime-only again).
- The *Multimodal* vignette, the design note and
  `data-raw/build_multimodal.R`.

Everything that remains is real, cited data: the resilience profile (now
with the graph-theory panel below), quantitative context, per-figure
sources, the incident log, reference metadata and the risk taxonomy.
`igraph` moves from Imports to Suggests (used only by
`data-raw/prep_zenodo.R`).

### New graph-theory indicators for the eight maritime chokepoints

- `chokepoint_resilience` gains four graph-theory indicators, computed
  on the real, weighted, bipartite country–chokepoint dependency network
  (Verschuur & Hall 2025, CC BY 4.0) alongside the existing
  `betweenness_centrality` and `degree_centrality`:
  - `strength_weighted` — weighted degree (sum of dependency shares):
    the dependency *mass* the unweighted degree drops;
  - `betweenness_weighted` — brokerage on the weighted graph (edge
    distance `1/share`);
  - `harmonic_centrality` — a disconnection-safe closeness;
  - `pagerank` — share-weighted recursive influence.
- All indicators are precomputed offline in `data-raw/prep_zenodo.R`,
  which now also reports a threshold-sensitivity check (Spearman rank
  correlation at 0.05/0.10/0.25). The weighted rankings are very robust
  to the 10% edge threshold (\>=0.90); the unweighted ones are
  moderately stable.
- Eigenvector/raw-closeness, clustering (identically 0 on a bipartite
  graph) and k-core coreness are deliberately **not** shipped — each
  degenerates on, or is threshold-unstable over, this network. The
  *Methodology* vignette Section 4 documents the full panel, the
  weighting and the exclusions.

No data was fabricated: every indicator is a deterministic function of
the published Verschuur & Hall dependencies.

## chokepointR 0.5.1

### Documentation

- **Scientific-reproducibility reframe of the multimodal framework.**
  The *Multimodal* vignette is rewritten as a paper-grade “Data and
  Methods” reference: the five-table data model, the step-by-step
  dataset-constitution pipeline, descriptive statistics computed live
  from the bundled data, formal algorithm statements (eligibility,
  three-year median, type-7 quantile cutoff, ties, canonical maritime;
  network cost/importance weight semantics; scoring pillar equations), a
  metric-by-metric citation table, the bring-your-own licensed-data
  workflow, coverage limits, a source/licence matrix, and a
  ready-to-adapt methods paragraph. The README multimodal section and
  the pkgdown home page are rewritten to match, and method/source
  references are added to the bibliography.
- Throughout, the synthetic seaport/airport/rail throughput and network
  edges are labelled as illustrative fixtures (never observations), with
  `cp_import_throughput()` documented as the path to real research.

No code or data changes; the API and all bundled datasets are unchanged.

## chokepointR 0.5.0

### Multimodal generalization

Version 0.5.0 generalizes the package from eight maritime passages to a
**multimodal** framework — maritime passages, seaports (container / bulk
/ mixed), cargo airports, and (experimental) rail gateways — while
keeping the original eight-chokepoint API **byte-for-byte unchanged**.
[`cp_resilience()`](https://warint.github.io/chokepointR/reference/cp_resilience.md)
with no arguments still returns the original maritime profile; the
multimodal functions are strictly additive.

#### New long-form datasets

- `cp_nodes_data` — canonical multimodal node registry (identities,
  codes, coordinates, `data_status`).
- `cp_throughput_data` — long-form physical throughput (native units).
- `cp_edges_data` — directed, weighted, temporal, multilayer edge list.
- `cp_provenance_data` — one row per observation/estimate, full
  provenance schema (source, URL, licence, redistribution flag,
  observed/estimated/example, confidence, method version).
- `cp_selection_data` — snapshot of the top-quartile selection with
  per-group metadata (cutoff, counts, quantile method).

**Honesty of the data.** Maritime passages are real.
Seaport/airport/rail node *identities* are public geographic facts, but
their *throughput* is **synthetic, labelled `example` data** — never
fabricated observations. No facility-level `trade_value_usd` is invented
(country-pair UNCTAD values are not presented as facility values).

#### New functions

- `cp_select()` / `cp_compare_thresholds()` — percentile-based node
  selection per mode × subtype (container = TEU, bulk/mixed = tonnes,
  cargo airport = freight+mail tonnes, rail = freight tonnes; units
  never pooled; ties at the cutoff included; maritime
  canonical-include), with 0.65/0.75/0.85 sensitivity (counts, cutoffs,
  Jaccard overlap).
- `cp_network()` — directed weighted multilayer graph with correct
  igraph weight semantics (`distance = 1/(flow + eps)` for path metrics,
  `flow` for PageRank/strength).
- `cp_metrics()` — node- and network-level metrics: harmonic centrality,
  weighted directed betweenness, weighted PageRank, coreness,
  articulation status, community participation and within-module
  z-score, origin/destination HHI and entropy, per-node removal impact
  (Δ efficiency, Δ largest component), plus density, reciprocity,
  modularity, global efficiency, centralization and assortativity.
- `cp_simulate_disruption()` — single-node, targeted, seeded
  random-ensemble, two-node compound, and partial-capacity scenarios;
  topological impact reported separately from model-based rerouting;
  robustness-curve AUC.
- `cp_rank()` — five transparent scoring pillars, within-mode
  empirical-percentile normalization on the full eligible universe,
  equal or user weights, collinearity diagnostics (\|Spearman ρ\| \>
  0.85 flagged), leave-one-pillar-out sensitivity, and
  `criticality_score` / `resilience_score` / `vulnerability_score`.
- `cp_nodes()`, `cp_provenance()` — accessors for the new registry and
  ledger.
- `cp_import_throughput()`, `cp_import_nodes()`, `cp_validate()` —
  importers for user-supplied **licensed** data (World Bank CPPI, ACI
  cargo, UNCTAD, national statistics — none bundled), schema validation,
  provenance-completeness checks and a licence/redistribution gate.

#### Extended functions

- `cp_resilience(mode = ...)` — opt-in multimodal scoring view (default
  `"maritime"` unchanged).
- `cp_map(mode = ...)` — opt-in multimodal node map (major nodes
  highlighted).

#### Documentation

- New **Multimodal chokepoints** vignette: eligible universe, realized
  (illustrative) cutoffs, multilayer graph, centrality vs. disruption,
  hidden systemic nodes, threshold sensitivity, coverage limitations,
  and a source/ licence matrix. Builds entirely offline from bundled
  data.

`igraph` is now an **Imports** dependency: the multimodal network
functions (`cp_network()`, `cp_metrics()`, `cp_simulate_disruption()`,
`cp_rank()`) are core API, so `igraph` is required rather than
suggested. `leaflet` remains a Suggests dependency (guarded with
graceful failure) for the optional maps.

## chokepointR 0.4.0

### Major changes

- **Network centrality.** `chokepoint_resilience` gains
  `betweenness_centrality` and `degree_centrality`, computed
  reproducibly in `data-raw/prep_zenodo.R` on a bipartite
  country–chokepoint dependency network built from Verschuur & Hall
  (2025). Betweenness captures *brokerage* — a distinct signal from oil
  volume (Hormuz is a high-volume source but a low-betweenness broker;
  Gibraltar and Malacca are the top brokers). The existing indices are
  unchanged.

- **Quantitative context, fully sourced.** New dataset
  `chokepoint_context`
  ([`cp_context()`](https://warint.github.io/chokepointR/reference/cp_context.md)):
  a per-chokepoint profile of vessel transits, vessel and cargo mix,
  world-trade shares, top users, local economic dependence and rerouting
  cost. Transit counts are representative **normal-year** figures with
  the counting basis stated (`transit_basis`); crisis magnitudes stay in
  `chokepoint_risks`.

- **Per-figure provenance.** New dataset `chokepoint_sources`
  ([`cp_sources()`](https://warint.github.io/chokepointR/reference/cp_sources.md)):
  one row per quantitative figure with value, unit, year, basis, source,
  URL and a `confidence` flag (`High`/`Medium`/`Low`) —
  `cp_sources(min_confidence = "High")` keeps only authoritative
  figures.

- **Methodology article.** A new vignette documents the framework, every
  definition, index construction, the centrality network (with threshold
  sensitivity) and limitations, with a DOI reference list, for citation
  in academic work.

- **r-universe.** README now carries r-universe status/download badges
  and an
  `install.packages(..., repos = "https://warint.r-universe.dev")`
  route.

## chokepointR 0.3.0

### Major changes

- **Resilience framework.** New dataset `chokepoint_resilience` and
  function
  [`cp_resilience()`](https://warint.github.io/chokepointR/reference/cp_resilience.md):
  a per-chokepoint profile combining maritime trade-value dependency,
  systemic economic risk (expected value of trade disrupted), oil
  transit, route redundancy and incident counts, with transparent
  composite `resilience_index` and `vulnerability_index` (all component
  scores shipped so users can re-weight).

- **Scope narrowed to the 8 maritime straits/canals** — Suez, Panama,
  Hormuz, Bab el-Mandeb, Malacca, Gibraltar, Turkish Straits, Dover —
  where chokepoint-level open data is rich and commensurable.
  Non-maritime nodes (ports, inland rail/road) were removed;
  `chokepoints` and `chokepoint_risks` are scoped accordingly.

- **New open data sources:** Verschuur & Hall (2025, *Nature
  Communications*; Zenodo, CC BY 4.0) for trade dependency and systemic
  risk, and the U.S. EIA World Oil Transit Chokepoints (public domain)
  for oil transit.

## chokepointR 0.2.0

This release renames the package (from `gvcR`) and refocuses it as a
trade-chokepoint disruption **risk register**.

### Major changes

- **Renamed to `chokepointR`.** Functions now use the `cp_` prefix
  ([`cp_data()`](https://warint.github.io/chokepointR/reference/cp_data.md),
  [`cp_risk()`](https://warint.github.io/chokepointR/reference/cp_risk.md),
  [`cp_location()`](https://warint.github.io/chokepointR/reference/cp_location.md),
  [`cp_search()`](https://warint.github.io/chokepointR/reference/cp_search.md),
  [`cp_map()`](https://warint.github.io/chokepointR/reference/cp_map.md),
  [`cp_signals()`](https://warint.github.io/chokepointR/reference/cp_signals.md)).
  The main dataset is `chokepoint_risks`.

- **CRAN-ready data handling.** Data is bundled and lazy-loaded. The
  previous behaviour — downloading a CSV from a remote server via `curl`
  on load — has been removed. The package no longer accesses the network
  on load.

- **Incident log, 2018 onward.** `chokepoint_risks` is a log of
  documented chokepoint disruption incidents (e.g. the 2021 *Ever Given*
  grounding, the 2023–24 Panama Canal drought, Red Sea shipping attacks,
  and the Black Sea grain-corridor disruptions). Each incident is stated
  in original wording and carries a resolvable `source_url`. Legacy
  historical data has been phased out.

- **Reference framework decoupled from coverage.** The 14 chokepoints
  (`chokepoints`) and the 11-risk taxonomy (`risk_types`) are shipped as
  reference datasets, so the framework is complete even where no
  incident is yet recorded.

### New features

- [`cp_search()`](https://warint.github.io/chokepointR/reference/cp_search.md)
  — free-text search across the data (“drought Panama”, “piracy”, …),
  returning matches ranked by relevance.
- [`cp_map()`](https://warint.github.io/chokepointR/reference/cp_map.md)
  — one-call interactive **leaflet** map, coloured by risk level and
  filtered by the dimensions you select.
- [`cp_signals()`](https://warint.github.io/chokepointR/reference/cp_signals.md)
  — optional helper that fetches recent natural-hazard events
  (public-domain USGS earthquake data) near a chokepoint. No third-party
  data is redistributed.
- New bundled datasets `chokepoints` (type, region, coordinates) and
  `risk_types` (the taxonomy).

### Schema

- `chokepoint_risks` columns: `location`, `incident_year`, `risk`,
  `risk_category`, `risk_code`, `level`, `incident`, `source`,
  `source_url`.

### Other

- Runtime dependencies are minimal (`jsonlite`, `utils`); `dplyr`,
  `ggplot2`, `leaflet`, `kableExtra` are Suggests.
- Added a test suite, a reproducible `data-raw/` build pipeline and a
  data-provenance document (`DATA-PROVENANCE.md`).
