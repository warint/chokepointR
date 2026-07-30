# Chokepoint reference metadata

Reference metadata for the 8 maritime straits and canals tracked by the
package.

## Usage

``` r
chokepoints
```

## Format

A data frame with the following columns:

- location:

  Chokepoint name.

- type:

  "Canal", "Maritime strait", "Port cluster" or "Inland network".

- region:

  Broad geographic region.

- latitude:

  Approximate representative latitude (decimal degrees).

- longitude:

  Approximate representative longitude (decimal degrees).

## Details

Coordinates are approximate representative points for mapping and
proximity queries (e.g.
[`cp_signals`](https://warint.github.io/chokepointR/reference/cp_signals.md)),
not precise boundaries.
