# Look up global value chain risk codes

Return the mapping between risks (in natural language), their category
and their short code. Supply `risk` to filter to matching risks.

## Usage

``` r
cp_risk(risk)
```

## Arguments

- risk:

  Optional search string matched (case-insensitively) against the
  natural-language risk name. If missing, all risks are returned.

## Value

A data frame with columns `risk`, `risk_category` and `risk_code`.

## See also

[`cp_location`](https://warint.github.io/chokepointR/reference/cp_location.md)
and
[`cp_data`](https://warint.github.io/chokepointR/reference/cp_data.md).

## Examples

``` r
cp_risk()
#>                          risk                    risk_category risk_code
#> 1        Temperature extremes         Weather and climate risk       W-T
#> 2           Flood and drought         Weather and climate risk     W-F/D
#> 3                      Storms         Weather and climate risk       W-S
#> 4                Haze and fog         Weather and climate risk     W-H/F
#> 5                    Conflict       Security and conflict risk       S-C
#> 6            Terrorist attack       Security and conflict risk       S-T
#> 7                      Piracy       Security and conflict risk       S-P
#> 8                 Cyberattack       Security and conflict risk     S-C/A
#> 9  Trade and transit controls Political and institutional risk       P-T
#> 10                  Disrepair Political and institutional risk       P-D
#> 11            Unforced delays Political and institutional risk       P-U
cp_risk(risk = "storm")
#>     risk            risk_category risk_code
#> 1 Storms Weather and climate risk       W-S
cp_risk("attack")
#>               risk              risk_category risk_code
#> 1 Terrorist attack Security and conflict risk       S-T
#> 2      Cyberattack Security and conflict risk     S-C/A
```
