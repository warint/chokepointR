# Look up chokepoint locations

Return the list of chokepoint locations, optionally filtered by a search
string.

## Usage

``` r
cp_location(location)
```

## Arguments

- location:

  Optional search string matched (case-insensitively) against location
  names. If missing, all locations are returned.

## Value

A data frame with a single `location` column.

## See also

[`cp_risk`](https://warint.github.io/chokepointR/reference/cp_risk.md)
and
[`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md).

## Examples

``` r
cp_location()
#>                  location
#> 1            Panama Canal
#> 2              Suez Canal
#> 3       Strait of Malacca
#> 4        Strait of Hormuz
#> 5 Strait of Bab el-Mandeb
#> 6         Turkish Straits
#> 7            Dover Strait
#> 8     Strait of Gibraltar
cp_location(location = "Canal")
#>       location
#> 1 Panama Canal
#> 2   Suez Canal
cp_location("Canal")
#>       location
#> 1 Panama Canal
#> 2   Suez Canal
```
