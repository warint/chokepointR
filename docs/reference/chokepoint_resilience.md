# Chokepoint resilience profiles

A per-chokepoint profile combining how much world trade depends on each
of the 8 maritime chokepoints, how substitutable it is, how much
disruption it has seen, and composite resilience and vulnerability
indices.

## Usage

``` r
chokepoint_resilience
```

## Format

A data frame with one row per chokepoint and the columns:

- location, type, region:

  Chokepoint identity (see
  [`chokepoints`](https://warint.github.io/chokepointR/reference/chokepoints.md)).

- oil_transit_mbd:

  Crude + petroleum-liquids transit, million barrels/day (`NA` for
  non-oil chokepoints).

- oil_share_world_pct:

  That transit as a share of world seaborne oil.

- trade_value_bn_usd:

  Annual maritime trade value routed through the chokepoint, USD
  billions.

- n_dependent_countries:

  Countries sending \>25% of their maritime trade value through the
  chokepoint.

- max_dependency:

  Highest single-country dependency share (0-1).

- evtd_bn_usd:

  Expected value of trade disrupted (systemic economic risk), USD
  billions.

- betweenness_centrality:

  *Unweighted* betweenness centrality in the country-chokepoint
  trade-dependency network (0-1, igraph-normalised). A brokerage
  measure: how often the chokepoint lies on shortest paths linking
  countries. Computed by the package, not an external figure.

- betweenness_weighted:

  Betweenness on the *weighted* graph, with edge distance
  `= 1 / dependency share` so a stronger dependence is a shorter path
  (0-1, igraph-normalised). Brokerage weighted by how heavily countries
  rely on the chokepoint.

- degree_centrality:

  Number of countries routing \>=10% of their maritime import value
  through the chokepoint, rescaled to the busiest chokepoint in the
  network (0-1). Saturates near 1 for the busiest arteries.

- strength_weighted:

  Weighted degree: the sum of the dependency shares of the countries
  routing \>=10% of their maritime imports through the chokepoint (a
  dependency "mass"; higher = more total reliance). Adds the magnitude
  information that the unweighted `degree_centrality` drops.

- harmonic_centrality:

  Normalised harmonic centrality (0-1), a disconnection-safe closeness:
  the mean inverse network distance from the chokepoint to all other
  nodes. Higher = more central/near in the network.

- pagerank:

  Weighted PageRank (edge weight = dependency share): a recursive
  influence score in which a chokepoint is important when important
  countries depend on it. Sums to 1 over *all* nodes in the network, so
  chokepoint values are small positive numbers.

- has_alternative, alt_route, extra_days, bypass_capacity_mbd:

  Route redundancy: whether a viable alternative exists, what it is, the
  extra transit time, and any bypass-pipeline capacity.

- n_incidents:

  Documented incidents in
  [`chokepoint_risks`](https://warint.github.io/chokepointR/reference/chokepoint_risks.md).

- importance_score, dependency_score, systemic_risk_score,
  redundancy_score, exposure_score:

  Dimension scores scaled 0-1 relative to these 8 chokepoints
  (redundancy: higher = more substitutable).

- resilience_index:

  0-100; `100 * redundancy_score`. Higher = more able to absorb a
  disruption via rerouting.

- vulnerability_index:

  0-100; `100 * exposure_score * (1 - redundancy_score)`. Higher = high
  stakes with few alternatives.

## Source

Trade value, dependency and expected-value-of-trade-disrupted:
Verschuur, J. & Hall, J. (2025), "Maritime chokepoint dependencies and
systemic risks", *Nature Communications*; data on Zenodo (CC BY 4.0),
[doi:10.5281/zenodo.13841881](https://doi.org/10.5281/zenodo.13841881) .
Oil transit: U.S. Energy Information Administration, World Oil Transit
Chokepoints (public domain). Route redundancy: compiled from EIA, IEA
and UNCTAD; see `DATA-PROVENANCE.md`.

## Details

The composite indices are a transparent, equally-weighted default, not a
canonical measure; all component scores ship alongside so users can
re-weight. `importance_score` blends normalised trade value and oil
transit; `exposure_score` averages importance, dependency and systemic
risk. Scores are relative to these 8 chokepoints only.

**Network centrality.** The six graph-theory indicators
(`betweenness_centrality`, `betweenness_weighted`, `degree_centrality`,
`strength_weighted`, `harmonic_centrality`, `pagerank`) are computed in
`data-raw/prep_zenodo.R` on a bipartite country-chokepoint network built
from the Verschuur & Hall import dependencies: an edge links a country
to a chokepoint when it routes at least 10% of its maritime import value
through it, with the dependency share as the edge weight, over *all*
chokepoints in the source (not only these 8). At the 10% threshold the
network is a single connected component, so the closeness-type measure
is well defined. The 10% threshold is a chosen parameter; a sensitivity
check (Spearman rank correlation of the 8 chokepoints' scores at
0.05/0.10/0.25) shows the *weighted* indicators are very robust to it
(weighted betweenness, weighted strength and PageRank all \>=0.90),
while the unweighted betweenness/degree and harmonic rankings are
moderately stable (~0.75-0.88); magnitudes move more than ranks.
Eigenvector/raw-closeness, clustering (identically 0 here) and k-core
coreness are deliberately not shipped – they degenerate on, or are
threshold-unstable over, this bipartite graph. Centrality is a distinct
dimension from oil importance – the Strait of Hormuz is a high-volume
oil *source* but a low-betweenness broker, whereas Gibraltar and Malacca
are the top brokers. See the *Methodology* vignette for the full
construction and limitations.

## References

Verschuur, J. & Hall, J. (2025). Maritime chokepoint dependencies and
systemic risks. *Nature Communications*.
[doi:10.5281/zenodo.13841881](https://doi.org/10.5281/zenodo.13841881)

Freeman, L. C. (1977). A set of measures of centrality based on
betweenness. *Sociometry*, 40(1), 35-41.
[doi:10.2307/3033543](https://doi.org/10.2307/3033543)

Boldi, P. & Vigna, S. (2014). Axioms for centrality. *Internet
Mathematics*, 10(3-4), 222-262.
[doi:10.1080/15427951.2013.865686](https://doi.org/10.1080/15427951.2013.865686)

Brin, S. & Page, L. (1998). The anatomy of a large-scale hypertextual
Web search engine. *Computer Networks and ISDN Systems*, 30(1-7),
107-117.
[doi:10.1016/S0169-7552(98)00110-X](https://doi.org/10.1016/S0169-7552%2898%2900110-X)
