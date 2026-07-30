# Per-figure provenance for the context profile

Return the citation table behind
[`cp_context`](https://warint.github.io/chokepointR/reference/cp_context.md):
one row per quantitative figure, with source, URL, year and a confidence
flag. See
[`chokepoint_sources`](https://warint.github.io/chokepointR/reference/chokepoint_sources.md)
for the column dictionary.

## Usage

``` r
cp_sources(locations = NULL, min_confidence = c("Low", "Medium", "High"))
```

## Arguments

- locations:

  Optional character vector of chokepoint names to keep (partial,
  case-insensitive matches). `NULL` (default) returns all.

- min_confidence:

  Keep only figures at or above this confidence: one of "Low" (default,
  keep all), "Medium" or "High".

## Value

A data frame, one row per sourced figure.

## See also

[`cp_context`](https://warint.github.io/chokepointR/reference/cp_context.md)

## Examples

``` r
cp_sources(locations = "Suez")
#>     location           variable
#> 1 Suez Canal    annual_transits
#> 2 Suez Canal annual_net_tonnage
#> 3 Suez Canal  share_world_trade
#> 4 Suez Canal    container_share
#> 5 Suez Canal       toll_revenue
#> 6 Suez Canal       reroute_cost
#>                                                value
#> 1                  26434 (2023 record); 13213 (2024)
#> 2                          1568 (2023); 524.5 (2024)
#> 3                                             ~12-15
#> 4                                                ~30
#> 5                       10.3 (2023); ~4 (2024, -60%)
#> 6 +3,000-3,500 nm / +10-14 days; ~+US$1M fuel/voyage
#>                            unit year            basis
#> 1                      ships/yr 2023      All vessels
#> 2              million net tons 2023  SCA net tonnage
#> 3              % of world trade 2023  UNCTAD estimate
#> 4 % of global container traffic 2023  UNCTAD estimate
#> 5                        US$ bn 2023 SCA toll revenue
#> 6             Cape of Good Hope 2024    Asia-N.Europe
#>                                    source
#> 1     Suez Canal Authority (via Statista)
#> 2 Suez Canal Authority (via Ahram Online)
#> 3                                  UNCTAD
#> 4                                  UNCTAD
#> 5         Suez Canal Authority (via AGBI)
#> 6                       Supply Chain Dive
#>                                                                                            source_url
#> 1           https://www.statista.com/statistics/1252568/number-of-transits-in-the-suez-cana-annually/
#> 2                                                       https://english.ahram.org.eg/News/537603.aspx
#> 3                   https://unctad.org/news/red-sea-crisis-and-implications-trade-facilitation-africa
#> 4                   https://unctad.org/news/red-sea-crisis-and-implications-trade-facilitation-africa
#> 5       https://www.agbi.com/logistics/2024/12/suez-canal-revenue-drops-7bn-amid-red-sea-instability/
#> 6 https://www.supplychaindive.com/news/suez-cape-good-hope-ever-given-evergreen-blocked-stuck/597402/
#>   confidence
#> 1       High
#> 2       High
#> 3       High
#> 4       High
#> 5       High
#> 6     Medium
cp_sources(min_confidence = "High")[, c("location", "variable", "source")]
#>                   location           variable
#> 1             Panama Canal    annual_transits
#> 2             Panama Canal     daily_transits
#> 3             Panama Canal       toll_revenue
#> 4               Suez Canal    annual_transits
#> 5               Suez Canal annual_net_tonnage
#> 6               Suez Canal  share_world_trade
#> 7               Suez Canal    container_share
#> 8               Suez Canal       toll_revenue
#> 9        Strait of Malacca        oil_transit
#> 10       Strait of Malacca      singapore_hub
#> 11        Strait of Hormuz        oil_transit
#> 12        Strait of Hormuz          oil_share
#> 13        Strait of Hormuz          lng_share
#> 14        Strait of Hormuz    bypass_capacity
#> 15        Strait of Hormuz  destination_share
#> 16 Strait of Bab el-Mandeb        oil_transit
#> 17 Strait of Bab el-Mandeb  share_world_trade
#> 18 Strait of Bab el-Mandeb      crisis_impact
#> 19 Strait of Bab el-Mandeb       freight_rate
#> 20 Strait of Bab el-Mandeb       sumed_bypass
#> 21         Turkish Straits    annual_transits
#> 22         Turkish Straits        oil_transit
#> 23         Turkish Straits        grain_share
#> 24         Turkish Straits   grain_initiative
#> 25         Turkish Straits         governance
#> 26            Dover Strait     daily_transits
#> 27            Dover Strait        trade_value
#> 28            Dover Strait      ferry_volumes
#> 29            Dover Strait     traffic_scheme
#> 30     Strait of Gibraltar     tanger_med_teu
#> 31     Strait of Gibraltar  algeciras_tonnage
#> 32     Strait of Gibraltar               role
#>                                            source
#> 1                    Panama Canal Authority (ACP)
#> 2                                        U.S. EIA
#> 3                    Panama Canal Authority (ACP)
#> 4             Suez Canal Authority (via Statista)
#> 5         Suez Canal Authority (via Ahram Online)
#> 6                                          UNCTAD
#> 7                                          UNCTAD
#> 8                 Suez Canal Authority (via AGBI)
#> 9          U.S. EIA World Oil Transit Chokepoints
#> 10 Maritime and Port Authority of Singapore (MPA)
#> 11         U.S. EIA World Oil Transit Chokepoints
#> 12                          IEA, Strait of Hormuz
#> 13                                       U.S. EIA
#> 14                          IEA, Strait of Hormuz
#> 15                                       U.S. EIA
#> 16         U.S. EIA World Oil Transit Chokepoints
#> 17                                         UNCTAD
#> 18                                         UNCTAD
#> 19                                         UNCTAD
#> 20                                       U.S. EIA
#> 21         U.S. EIA World Oil Transit Chokepoints
#> 22         U.S. EIA World Oil Transit Chokepoints
#> 23                                       FAO / UN
#> 24                                         UNCTAD
#> 25                        Republic of Turkiye MFA
#> 26         UK Maritime & Coastguard Agency (CNIS)
#> 27                                  Port of Dover
#> 28                                  Port of Dover
#> 29                                  UK MCA (CNIS)
#> 30                      Tanger Med Port Authority
#> 31         Autoridad Portuaria Bahia de Algeciras
#> 32                        IMF PortWatch (context)
```
