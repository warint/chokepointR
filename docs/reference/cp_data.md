# Query chokepoint risk data

Find and return chokepoint risk records matching the selected
parameters. Any argument left as `NULL` (the default) is not filtered
on, so `cp_data()` returns the complete dataset.

## Usage

``` r
cp_data(locations = NULL, risks = NULL, levels = NULL, category = NULL)
```

## Arguments

- locations:

  Character vector of chokepoint location(s).

- risks:

  Character vector of risk code(s) (see
  [`cp_risk`](https://warint.github.io/chokepointR/reference/cp_risk.md)).

- levels:

  Character vector of risk level(s): "Low risk", "Medium risk", "High
  risk".

- category:

  Character vector of risk category/categories.

## Value

A data frame of matching rows from
[`chokepoint_risks`](https://warint.github.io/chokepointR/reference/chokepoint_risks.md).

## See also

[`cp_location`](https://warint.github.io/chokepointR/reference/cp_location.md)
for the locations list,
[`cp_risk`](https://warint.github.io/chokepointR/reference/cp_risk.md)
for risk codes, and
[`chokepoint_risks`](https://warint.github.io/chokepointR/reference/chokepoint_risks.md)
for the dataset itself.

## Examples

``` r
myData <- cp_data(locations = "Panama Canal", risks = "S-T")
myData <- cp_data(locations = c("Panama Canal", "Suez Canal"),
                    risks = c("S-T", "S-C"))
myData <- cp_data(category = "Weather and climate risk")
myData <- cp_data(levels = "High risk")
myData <- cp_data("Panama Canal", "S-T")
myData <- cp_data()
```
