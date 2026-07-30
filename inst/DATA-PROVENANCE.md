# Data provenance and licensing

`chokepointR` is released under the MIT licence. This document explains where
the bundled data comes from and why it is redistributable.

## Guiding principle: facts, not expression

The package ships **facts** — which chokepoint, which risk, what severity, what
happened, in which year — together with an attribution (`source`) and a
resolvable citation (`source_url`). Factual information is not itself subject to
copyright; copyrighted *expression* (verbatim prose, licensed data tables) is
not reproduced. Every incident description is stated in original wording.

## `chokepoint_risks` — the incident log

Incidents (2018 onward) were compiled for this package from reputable public
reporting. Each row carries a specific date and a `source_url` that was checked
to resolve and to state the fact recorded. Publishers cited to date include
Al Jazeera, the U.S. Energy Information Administration, the United Nations, the
Council on Foreign Relations, NASA Earth Observatory, Insurance Journal and
AGBI, as recorded per row in the `source` / `source_url` columns.

## `chokepoint_resilience` — the resilience profile

Combines several open sources, all redistributable with attribution:

- **Trade-value dependency, dependent-country counts, and expected value of
  trade disrupted (EVTD):** Verschuur, J. & Hall, J. (2025), "Maritime
  chokepoint dependencies and systemic risks," *Nature Communications*. Data on
  Zenodo, **CC BY 4.0**, <https://doi.org/10.5281/zenodo.13841881> (aggregated to
  the 8 chokepoints by `data-raw/prep_zenodo.R`).
- **Oil transit (million barrels/day):** U.S. Energy Information Administration,
  *World Oil Transit Chokepoints* (**U.S. Government public domain**),
  <https://www.eia.gov/international/analysis/special-topics/World_Oil_Transit_Chokepoints>.
- **Route redundancy / bypass facts:** compiled from EIA, the IEA Strait of
  Hormuz factsheet (CC BY 4.0) and UNCTAD rerouting analysis; the
  `substitutability` score (0-1) is a documented judgment coding of those facts.
- **Network centrality** — a panel of six graph-theory indicators
  (`degree_centrality`, `strength_weighted`, `betweenness_centrality`,
  `betweenness_weighted`, `harmonic_centrality`, `pagerank`) is **computed by the
  package** (not external figures) in `data-raw/prep_zenodo.R`, on a weighted
  bipartite country-chokepoint network built from the Verschuur & Hall import
  dependencies (edge = country routes >=10% of its maritime import value through
  a chokepoint; edge weight = that dependency share). See the *Methodology*
  vignette, Section 4, for the graph definition, the threshold sensitivity, the
  interpretation, and why eigenvector/closeness/clustering/coreness are excluded.
  The measures follow Freeman (1977), Boldi & Vigna (2014) and Brin & Page (1998).
- **Composite indices** (`resilience_index`, `vulnerability_index`) are a
  transparent equally-weighted default computed in `data-raw/build_data.R`; all
  component scores ship so users can re-weight.

## `chokepoint_context` and `chokepoint_sources` — quantitative context

`chokepoint_context` is a hand-curated, per-chokepoint profile (vessel transits,
vessel and cargo mix, trade shares, top users, local economic dependence,
rerouting cost). `chokepoint_sources` is its provenance table: one row per
figure, with value, unit, year, basis, `source`, `source_url` and a
`confidence` flag (`High` / `Medium` / `Low`).

- Only **facts** are reproduced, each with attribution; no source's copyrighted
  table or prose is copied.
- Transit counts are **representative normal-year** figures with the counting
  basis stated (`transit_basis`); crisis-year magnitudes live in
  `chokepoint_risks`, not here.
- Publishers cited include the Panama Canal Authority, Suez Canal Authority,
  U.S. EIA, IEA, UNCTAD, FAO, IMF PortWatch (via trade press), the UK Maritime &
  Coastguard Agency, the Port of Dover, the Maritime and Port Authority of
  Singapore, Tanger Med and Algeciras port authorities, and the Republic of
  Turkiye MFA, as recorded per row.
- Figures found only in a secondary aggregator that does not resolve to a named
  authority are flagged `confidence = "Low"` rather than dropped, so the
  distinction is explicit and filterable (`cp_sources(min_confidence = "High")`).
  IMF PortWatch bulk data is **not** bundled (IMF terms); individual PortWatch-
  derived figures are cited as facts, not redistributed as a dataset.

## `chokepoints` — reference metadata

Representative latitude/longitude for each chokepoint are approximate indicative
points (public factual geographic information), intended for mapping and
proximity queries — not precise boundaries.

## `risk_types` — the taxonomy

The 11-risk, 3-category classification framework used to code incidents.

## Live helper (not bundled)

`cp_signals()` fetches data on demand from the USGS Earthquake Hazards Program
(public domain). No third-party data is redistributed by the package.

## Sources deliberately excluded

Sources whose terms bar redistribution under an MIT licence are **not** bundled
(for example, IMF PortWatch, subject to IMF terms; and Global Fishing Watch,
non-commercial licence). Where such a source is useful, users are pointed to it
rather than shipped its data.
