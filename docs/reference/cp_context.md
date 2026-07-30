# Chokepoint quantitative context profile

Return the per-chokepoint context profile: traffic, cargo, dominant
vessels, top users, local economic dependence and rerouting cost. See
[`chokepoint_context`](https://warint.github.io/chokepointR/reference/chokepoint_context.md)
for the column dictionary. Every figure is traceable through
[`cp_sources`](https://warint.github.io/chokepointR/reference/cp_sources.md).

## Usage

``` r
cp_context(locations = NULL)
```

## Arguments

- locations:

  Optional character vector of chokepoint names to keep (partial,
  case-insensitive matches are honoured). `NULL` (default) returns all
  8.

## Value

A data frame, one row per chokepoint.

## See also

[`cp_sources`](https://warint.github.io/chokepointR/reference/cp_sources.md)
for per-figure citations,
[`cp_resilience`](https://warint.github.io/chokepointR/reference/cp_resilience.md)
for the resilience indices.

## Examples

``` r
cp_context()[, c("location", "daily_transits", "primary_cargo")]
#>                  location daily_transits
#> 1            Panama Canal             36
#> 2              Suez Canal             72
#> 3       Strait of Malacca            258
#> 4        Strait of Hormuz             96
#> 5 Strait of Bab el-Mandeb             66
#> 6         Turkish Straits            123
#> 7            Dover Strait            400
#> 8     Strait of Gibraltar            300
#>                                                                                  primary_cargo
#> 1  Containers, petroleum products & hydrocarbon-gas liquids, dry bulk (grain, coal), vehicles.
#> 2 Containerized manufactures (Asia-Europe), crude & refined products, LNG, dry bulk, vehicles.
#> 3                  Crude oil & LNG (Gulf->Asia), containers, dry bulk (iron ore, coal, grain).
#> 4                                               Crude oil & condensate, refined products, LNG.
#> 5       Containers, crude & products, dry bulk and grain (southern gateway to the Suez Canal).
#> 6                                Russian & Caspian crude and products, Black Sea grain, steel.
#> 7                   Containers, RoRo freight & ferries, North Sea oil & LNG, grain, chemicals.
#> 8        Container transshipment (Algeciras, Tanger Med), crude & products, dry bulk, ferries.
cp_context(locations = "Hormuz")
#>           location daily_transits annual_transits
#> 1 Strait of Hormuz             96              NA
#>                                                        transit_basis
#> 1 Commercial vessels/day, 2024 (IMF PortWatch AIS); ~21 tankers/day.
#>                                                                           share_world_trade
#> 1 ~20% of global petroleum liquids, ~25% of seaborne oil, and >20% of LNG trade (EIA; IEA).
#>                                    primary_cargo
#> 1 Crude oil & condensate, refined products, LNG.
#>                                       dominant_vessels
#> 1 Crude & product tankers (incl. VLCCs), LNG carriers.
#>                                                                                                         top_users
#> 1 Exporters: Saudi Arabia, Iraq, UAE, Iran, Kuwait, Qatar; destinations: China, India, Japan, South Korea (~74%).
#>                                                                         local_economic_note
#> 1 Vital to Gulf exporters; Qatar ~93% and UAE ~96% of LNG exports transit the strait (IEA).
#>                                                                                                        reroute_note
#> 1 Bypass pipelines (Saudi Petroline, UAE ADCOP) offer ~3.5-5 mb/d of spare capacity against ~21 mb/d of flow (IEA).
```
