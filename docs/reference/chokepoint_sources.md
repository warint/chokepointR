# Per-figure provenance for the context profile

A tidy, long-format citation table: one row per quantitative figure in
[`chokepoint_context`](https://warint.github.io/chokepointR/reference/chokepoint_context.md)
(and related measures), each attributed to a named source, a resolvable
URL and a confidence flag. This is the citable backbone that lets every
number in the package be traced and re-checked.

## Usage

``` r
chokepoint_sources
```

## Format

A data frame with the following columns:

- location:

  Chokepoint name.

- variable:

  Short name of the figure (e.g. "oil_transit", "toll_revenue").

- value:

  The figure, in original wording (may include a range or a crisis
  comparison).

- unit:

  Unit of the figure.

- year:

  Reference year (or year the figure describes).

- basis:

  What is counted / how the figure is defined.

- source:

  Publisher of the cited figure.

- source_url:

  Resolvable URL for the source.

- confidence:

  "High" (named authority / official statistics), "Medium" (reputable
  reporting or AIS-derived, e.g. IMF PortWatch via trade press), or
  "Low" (secondary aggregator not resolving to a named authority).
  Filter on this to keep only authoritative figures.

## Details

Following the package's "facts, not expression" principle, only factual
figures are reproduced, each with attribution; no source's copyrighted
table or prose is copied. See `DATA-PROVENANCE.md`.

## See also

[`chokepoint_context`](https://warint.github.io/chokepointR/reference/chokepoint_context.md)
