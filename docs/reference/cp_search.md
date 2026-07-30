# Search chokepoint risk records in natural language

A single free-text entry point to the data: describe what you are
looking for (e.g. "drought Panama", "piracy Hormuz", "cyberattack") and
`cp_search()` returns the matching records, ranked by relevance. Every
whitespace-separated term must appear (case-insensitively) somewhere in
a record's location, risk, risk category, risk code, level or incident
text.

## Usage

``` r
cp_search(query = "", incidents_only = FALSE)
```

## Arguments

- query:

  A search string. Multiple words are treated as an AND query (all terms
  must match). If empty or missing, the full dataset is returned.

- incidents_only:

  If `TRUE`, restrict results to records that describe a documented
  incident (non-missing `incident`). Default `FALSE`.

## Value

A data frame of matching rows from
[`chokepoint_risks`](https://warint.github.io/chokepointR/reference/chokepoint_risks.md),
ordered so that the strongest matches (most terms hit, documented
incidents first) appear at the top. Returns 0 rows if nothing matches.

## See also

[`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md)
for structured filtering.

## Examples

``` r
cp_search("drought Panama")
#>       location incident_year              risk            risk_category
#> 1 Panama Canal          2023 Flood and drought Weather and climate risk
#> 2 Panama Canal       2023-24 Flood and drought Weather and climate risk
#>   risk_code     level
#> 1     W-F/D High risk
#> 2     W-F/D High risk
#>                                                                                                                                                                                               incident
#> 1                               A severe El Nino drought forced the Panama Canal Authority to cut daily transits to about 32 ships by August 2023, producing a backlog of roughly 115 waiting vessels.
#> 2 Record-low water in Gatun Lake pushed the canal to reduce daily crossings to 24 from 7 November 2023 with tightened draft limits before rains allowed transit slots to be raised again through 2024.
#>       source
#> 1 Al Jazeera
#> 2   U.S. EIA
#>                                                                                                      source_url
#> 1 https://www.aljazeera.com/news/2023/8/25/panama-canal-announces-prolonged-transit-restrictions-due-to-drought
#> 2                                                         https://www.eia.gov/todayinenergy/detail.php?id=62408
cp_search("piracy")
#> [1] location      incident_year risk          risk_category risk_code    
#> [6] level         incident      source        source_url   
#> <0 rows> (or 0-length row.names)
cp_search("Suez storm", incidents_only = TRUE)
#> [1] location      incident_year risk          risk_category risk_code    
#> [6] level         incident      source        source_url   
#> <0 rows> (or 0-length row.names)
cp_search("Red Sea")
#>                  location incident_year     risk              risk_category
#> 1              Suez Canal          2024 Conflict Security and conflict risk
#> 2 Strait of Bab el-Mandeb          2023 Conflict Security and conflict risk
#> 3 Strait of Bab el-Mandeb          2024 Conflict Security and conflict risk
#> 4 Strait of Bab el-Mandeb          2025 Conflict Security and conflict risk
#>   risk_code     level
#> 1       S-C High risk
#> 2       S-C High risk
#> 3       S-C High risk
#> 4       S-C High risk
#>                                                                                                                                                                                               incident
#> 1 Houthi attacks in the Red Sea drove most shippers to reroute around the Cape of Good Hope, cutting Suez Canal traffic by roughly half by early 2024 and reducing canal revenues by up to 60 percent.
#> 2                          Houthi forces used a helicopter to board and seize the vehicle carrier Galaxy Leader in the southern Red Sea on 19 November 2023, holding its 25 crew for more than a year.
#> 3                             The fertiliser-laden bulk carrier Rubymar, struck by a Houthi missile on 18 February 2024, sank on 2 March 2024, becoming the first vessel lost in the Red Sea campaign.
#> 4         Houthi forces sank the bulk carriers Magic Seas and Eternity C in the Red Sea in early July 2025, killing at least three crew and taking others captive in a sharp re-escalation of attacks.
#>       source
#> 1       AGBI
#> 2 Al Jazeera
#> 3 Al Jazeera
#> 4 Al Jazeera
#>                                                                                                          source_url
#> 1                         https://www.agbi.com/economy/2024/09/suez-canal-revenues-fall-by-6bn-as-unrest-continues/
#> 2     https://www.aljazeera.com/news/2023/11/19/yemens-houthi-rebels-seize-cargo-ship-in-red-sea-israel-blames-iran
#> 3 https://www.aljazeera.com/news/2024/3/2/rubymar-cargo-ship-earlier-hit-by-houthis-has-sunk-yemeni-government-says
#> 4   https://www.aljazeera.com/news/2025/7/9/five-rescued-after-suspected-attack-by-yemens-houthis-on-red-sea-vessel
```
