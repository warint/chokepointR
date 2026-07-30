# Chokepoint resilience profiles

Return the per-chokepoint resilience profile for the eight maritime
chokepoints: importance and systemic-risk measures, network centrality,
route redundancy, recent disruption counts, and composite resilience and
vulnerability indices. See
[`chokepoint_resilience`](https://warint.github.io/chokepointR/reference/chokepoint_resilience.md)
for the full column dictionary and how the composite indices are built.

## Usage

``` r
cp_resilience(
  sort_by = c("vulnerability_index", "resilience_index", "location")
)
```

## Arguments

- sort_by:

  Ordering of the returned rows: "vulnerability_index" (default, most
  vulnerable first), "resilience_index" (most resilient first), or
  "location" (alphabetical).

## Value

A data frame, one row per chokepoint: the bundled
[`chokepoint_resilience`](https://warint.github.io/chokepointR/reference/chokepoint_resilience.md)
table in the requested order.

## See also

[`cp_map`](https://warint.github.io/chokepointR/reference/cp_map.md) to
map it,
[`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md)
for the underlying incidents.

## Examples

``` r
cp_resilience()
#>                  location            type                     region
#> 1 Strait of Bab el-Mandeb Maritime strait   Red Sea / Horn of Africa
#> 2     Strait of Gibraltar Maritime strait      Western Mediterranean
#> 3       Strait of Malacca Maritime strait             Southeast Asia
#> 4              Suez Canal           Canal Middle East / North Africa
#> 5        Strait of Hormuz Maritime strait               Persian Gulf
#> 6            Dover Strait Maritime strait           Northwest Europe
#> 7            Panama Canal           Canal            Central America
#> 8         Turkish Straits Maritime strait  Black Sea / Mediterranean
#>   oil_transit_mbd oil_share_world_pct trade_value_bn_usd n_dependent_countries
#> 1             4.2                 5.3             1858.5                    45
#> 2              NA                  NA             2035.6                    52
#> 3            23.2                29.1             2428.5                    52
#> 4             4.9                 6.1             1850.3                    44
#> 5            20.9                26.2              885.1                    18
#> 6              NA                  NA             1836.2                    22
#> 7             2.3                 2.9              759.6                    15
#> 8             3.7                 4.6              551.1                    15
#>   max_dependency evtd_bn_usd betweenness_centrality betweenness_weighted
#> 1           0.79        4.16                 0.1318               0.0842
#> 2           0.94        0.06                 0.2337               0.3895
#> 3           0.83        1.07                 0.1982               0.2405
#> 4           0.58        2.07                 0.1170               0.1213
#> 5           0.89        0.46                 0.0070               0.0192
#> 6           0.78        0.00                 0.0879               0.0920
#> 7           0.69        0.56                 0.0920               0.1180
#> 8           0.70        0.17                 0.0170               0.0219
#>   degree_centrality strength_weighted harmonic_centrality pagerank
#> 1            0.9744             29.53              0.6969   0.0520
#> 2            0.9658             32.72              0.6938   0.0604
#> 3            1.0000             30.58              0.7083   0.0572
#> 4            0.9402             27.75              0.6835   0.0490
#> 5            0.2650              9.88              0.4247   0.0172
#> 6            0.6068             16.04              0.5590   0.0307
#> 7            0.2991              9.92              0.4484   0.0280
#> 8            0.4188             11.48              0.4786   0.0206
#>   has_alternative                                        alt_route extra_days
#> 1            TRUE              Cape of Good Hope or SUMED pipeline         12
#> 2           FALSE                                None (geographic)         NA
#> 3            TRUE                           Lombok or Sunda Strait          3
#> 4            TRUE                                Cape of Good Hope         12
#> 5            TRUE Saudi Petroline & UAE Habshan-Fujairah pipelines         NA
#> 6           FALSE                                None (geographic)         NA
#> 7           FALSE                Suez / Cape Horn / US land bridge         NA
#> 8           FALSE                                None (geographic)         NA
#>   bypass_capacity_mbd n_incidents importance_score dependency_score
#> 1                 2.5           5             0.44             0.81
#> 2                  NA           0             0.40             1.00
#> 3                  NA           0             1.00             1.00
#> 4                  NA           2             0.45             0.78
#> 5                 5.5           5             0.54             0.08
#> 6                  NA           0             0.34             0.19
#> 7                  NA           2             0.11             0.00
#> 8                  NA           1             0.08             0.00
#>   systemic_risk_score redundancy_score exposure_score resilience_index
#> 1                1.00             0.30           0.75               30
#> 2                0.01             0.10           0.47               10
#> 3                0.26             0.50           0.75               50
#> 4                0.50             0.40           0.58               40
#> 5                0.11             0.25           0.24               25
#> 6                0.00             0.10           0.18               10
#> 7                0.13             0.10           0.08               10
#> 8                0.04             0.10           0.04               10
#>   vulnerability_index
#> 1                  52
#> 2                  42
#> 3                  38
#> 4                  35
#> 5                  18
#> 6                  16
#> 7                   7
#> 8                   4
cp_resilience(sort_by = "resilience_index")
#>                  location            type                     region
#> 1       Strait of Malacca Maritime strait             Southeast Asia
#> 2              Suez Canal           Canal Middle East / North Africa
#> 3 Strait of Bab el-Mandeb Maritime strait   Red Sea / Horn of Africa
#> 4        Strait of Hormuz Maritime strait               Persian Gulf
#> 5     Strait of Gibraltar Maritime strait      Western Mediterranean
#> 6            Dover Strait Maritime strait           Northwest Europe
#> 7            Panama Canal           Canal            Central America
#> 8         Turkish Straits Maritime strait  Black Sea / Mediterranean
#>   oil_transit_mbd oil_share_world_pct trade_value_bn_usd n_dependent_countries
#> 1            23.2                29.1             2428.5                    52
#> 2             4.9                 6.1             1850.3                    44
#> 3             4.2                 5.3             1858.5                    45
#> 4            20.9                26.2              885.1                    18
#> 5              NA                  NA             2035.6                    52
#> 6              NA                  NA             1836.2                    22
#> 7             2.3                 2.9              759.6                    15
#> 8             3.7                 4.6              551.1                    15
#>   max_dependency evtd_bn_usd betweenness_centrality betweenness_weighted
#> 1           0.83        1.07                 0.1982               0.2405
#> 2           0.58        2.07                 0.1170               0.1213
#> 3           0.79        4.16                 0.1318               0.0842
#> 4           0.89        0.46                 0.0070               0.0192
#> 5           0.94        0.06                 0.2337               0.3895
#> 6           0.78        0.00                 0.0879               0.0920
#> 7           0.69        0.56                 0.0920               0.1180
#> 8           0.70        0.17                 0.0170               0.0219
#>   degree_centrality strength_weighted harmonic_centrality pagerank
#> 1            1.0000             30.58              0.7083   0.0572
#> 2            0.9402             27.75              0.6835   0.0490
#> 3            0.9744             29.53              0.6969   0.0520
#> 4            0.2650              9.88              0.4247   0.0172
#> 5            0.9658             32.72              0.6938   0.0604
#> 6            0.6068             16.04              0.5590   0.0307
#> 7            0.2991              9.92              0.4484   0.0280
#> 8            0.4188             11.48              0.4786   0.0206
#>   has_alternative                                        alt_route extra_days
#> 1            TRUE                           Lombok or Sunda Strait          3
#> 2            TRUE                                Cape of Good Hope         12
#> 3            TRUE              Cape of Good Hope or SUMED pipeline         12
#> 4            TRUE Saudi Petroline & UAE Habshan-Fujairah pipelines         NA
#> 5           FALSE                                None (geographic)         NA
#> 6           FALSE                                None (geographic)         NA
#> 7           FALSE                Suez / Cape Horn / US land bridge         NA
#> 8           FALSE                                None (geographic)         NA
#>   bypass_capacity_mbd n_incidents importance_score dependency_score
#> 1                  NA           0             1.00             1.00
#> 2                  NA           2             0.45             0.78
#> 3                 2.5           5             0.44             0.81
#> 4                 5.5           5             0.54             0.08
#> 5                  NA           0             0.40             1.00
#> 6                  NA           0             0.34             0.19
#> 7                  NA           2             0.11             0.00
#> 8                  NA           1             0.08             0.00
#>   systemic_risk_score redundancy_score exposure_score resilience_index
#> 1                0.26             0.50           0.75               50
#> 2                0.50             0.40           0.58               40
#> 3                1.00             0.30           0.75               30
#> 4                0.11             0.25           0.24               25
#> 5                0.01             0.10           0.47               10
#> 6                0.00             0.10           0.18               10
#> 7                0.13             0.10           0.08               10
#> 8                0.04             0.10           0.04               10
#>   vulnerability_index
#> 1                  38
#> 2                  35
#> 3                  52
#> 4                  18
#> 5                  42
#> 6                  16
#> 7                   7
#> 8                   4
cp_resilience()[, c("location", "vulnerability_index", "resilience_index")]
#>                  location vulnerability_index resilience_index
#> 1 Strait of Bab el-Mandeb                  52               30
#> 2     Strait of Gibraltar                  42               10
#> 3       Strait of Malacca                  38               50
#> 4              Suez Canal                  35               40
#> 5        Strait of Hormuz                  18               25
#> 6            Dover Strait                  16               10
#> 7            Panama Canal                   7               10
#> 8         Turkish Straits                   4               10
```
