## R CMD check results

0 errors | 0 warnings | 1 note

* The one NOTE is the standard "New submission" / maintainer note (this version
  is not yet on CRAN). No other notes.

## Release summary

* 0.6.0 refocuses the package on the eight real maritime chokepoints. The
  earlier 0.5.x "multimodal" layer shipped synthetic (labelled `example`)
  seaport/airport/rail throughput and network edges to demonstrate a generic
  engine; shipping fabricated numbers as bundled data was inappropriate, so that
  layer and its functions have been removed. This is a breaking change (see
  NEWS.md for the removed datasets and functions).
* `chokepoint_resilience` now carries a panel of six graph-theory centrality
  indicators computed on the real, weighted, bipartite country-chokepoint
  dependency network (Verschuur & Hall 2025, CC BY 4.0). Every value is a
  deterministic function of the published data; nothing is synthetic.
* `igraph` moves from Imports to Suggests: it is used only by the offline
  `data-raw/prep_zenodo.R` build script, not by any exported function.

## Network access

* The package does not access the internet on load; data is bundled in `data/`
  and lazy-loaded.
* The only network-using helper, `cp_signals()`, accesses a public-domain feed
  (USGS) only when explicitly called; its examples are wrapped in `\donttest{}`
  and it fails gracefully (returning `NULL`) when offline.
* `data-raw/` build scripts that download source data are not part of the built
  package (`.Rbuildignore`d); vignettes build entirely from bundled data.

## Suggested-package guarding

* `cp_map()` requires the suggested package `leaflet`; its use is guarded with
  `requireNamespace()` and examples are wrapped in `\donttest{}`.

## Data provenance and licensing

* Bundled data records factual figures with attribution, not any source's
  copyrighted expression. The eight maritime passages use redistributable
  sources (Verschuur & Hall 2025, CC BY 4.0; U.S. EIA, public domain).
* For seaports, cargo airports and rail gateways the node identities are public
  facts, but the throughput values and network edges are **synthetic,
  seeded, clearly labelled example fixtures** (`data_status = "example"`,
  `observed_or_estimated = "example"`) used only to demonstrate the framework —
  they are not observations. No facility-level trade value in USD is fabricated.
* Proprietary sources (UNCTAD, World Bank CPPI, ACI, UNECE) are not bundled;
  users import their own licensed files via `cp_import_throughput()`, which
  records the licence and gates non-redistributable data.
* Full provenance is in `DATA-PROVENANCE.md`.

## Test environments

* Local: R 4.6.0 on Linux.
