# Recent hazard signals near a chokepoint

Retrieve recent natural-hazard events near a chokepoint as a simple
resilience "signal". The current implementation queries the USGS
earthquake catalogue (public domain) within a radius of the chokepoint's
representative coordinates. Designed as a lightweight, extensible
starting point for near-real-time risk monitoring. No third-party data
is redistributed by the package; events are fetched on demand.

## Usage

``` r
cp_signals(location, days = 30, radius_km = 500, min_magnitude = 4.5)
```

## Arguments

- location:

  A chokepoint name present in
  [`chokepoints`](https://warint.github.io/chokepointR/reference/chokepoints.md).

- days:

  Look-back window in days (default 30).

- radius_km:

  Search radius around the chokepoint, in km (default 500).

- min_magnitude:

  Minimum earthquake magnitude (default 4.5).

## Value

A data frame of events (time, magnitude, place, coordinates, URL), an
empty data frame if none are found, or `NULL` if the request fails (e.g.
no internet connection).

## Data source

USGS Earthquake Hazards Program FDSN event service
(<https://earthquake.usgs.gov/fdsnws/event/1/>). USGS data are in the
public domain.

## Examples

``` r
# \donttest{
# Requires an internet connection:
sig <- cp_signals("Strait of Hormuz", days = 90, min_magnitude = 4.5)
head(sig)
#>           location                time magnitude                         place
#> 1 Strait of Hormuz 2026-06-08 21:08:42       4.9 100 km ESE of Ḩājjīābād, Iran
#> 2 Strait of Hormuz 2026-05-21 09:56:25       4.9 60 km W of Bandar Abbas, Iran
#> 3 Strait of Hormuz 2026-05-19 23:40:10       4.7 46 km W of Bandar Abbas, Iran
#> 4 Strait of Hormuz 2026-05-14 07:47:44       4.7    27 km NNW of Bardsīr, Iran
#> 5 Strait of Hormuz 2026-05-06 10:04:22       4.6  93 km ESE of Ḩājjīābād, Iran
#> 6 Strait of Hormuz 2026-05-04 20:39:33       4.5       57 km SW of Dārāb, Iran
#>   longitude latitude
#> 1   56.8733  28.0313
#> 2   55.6699  27.1259
#> 3   55.8114  27.2446
#> 4   56.5035  30.1632
#> 5   56.8077  28.0493
#> 6   54.1781  28.3447
#>                                                            url
#> 1 https://earthquake.usgs.gov/earthquakes/eventpage/us7000srlm
#> 2 https://earthquake.usgs.gov/earthquakes/eventpage/us6000sz6i
#> 3 https://earthquake.usgs.gov/earthquakes/eventpage/us6000syve
#> 4 https://earthquake.usgs.gov/earthquakes/eventpage/us6000sxm9
#> 5 https://earthquake.usgs.gov/earthquakes/eventpage/us6000svma
#> 6 https://earthquake.usgs.gov/earthquakes/eventpage/us7000si8q
# }
```
