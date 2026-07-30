# Chokepoint quantitative context profile

A readable, per-chokepoint profile of traffic, cargo and economic
context for the 8 chokepoints: how busy each is, what kind of trade and
vessels move through it, who depends on it, and what rerouting costs
when it is disrupted. Each figure is a fact stated in original wording;
the full provenance (value, unit, year, basis, source, URL and a
confidence flag) for every figure is in
[`chokepoint_sources`](https://warint.github.io/chokepointR/reference/chokepoint_sources.md).

## Usage

``` r
chokepoint_context
```

## Format

A data frame with one row per chokepoint and the columns:

- location:

  Chokepoint name (see
  [`chokepoints`](https://warint.github.io/chokepointR/reference/chokepoints.md)).

- daily_transits, annual_transits:

  Representative *normal-year* vessel counts (`NA` where no
  authoritative normal-year figure was found). Crisis-year snapshots are
  deliberately excluded; disruption magnitudes live in
  [`chokepoint_risks`](https://warint.github.io/chokepointR/reference/chokepoint_risks.md).

- transit_basis:

  What the transit counts actually measure – all vessels vs deep-draft,
  single strait vs combined straits, reference year, and any crisis
  caveat. **Read this before comparing counts across chokepoints.**

- share_world_trade:

  Share of world trade routed through the chokepoint, with the
  denominator (volume, value or oil) named in the text.

- primary_cargo:

  Dominant cargo/commodity types.

- dominant_vessels:

  Dominant vessel classes (with 2024 counts where available).

- top_users:

  Principal user countries or carriers.

- local_economic_note:

  Local/regional economic dependence, quantified where possible (canal
  revenue, GDP share, adjacent-port throughput).

- reroute_note:

  Main alternative route(s) and the extra distance, time or bypass
  capacity involved.

## Details

Transit counts come from different counting conventions and cannot be
compared blindly; always consult `transit_basis`. See
[`chokepoint_sources`](https://warint.github.io/chokepointR/reference/chokepoint_sources.md)
for per-figure citations and `DATA-PROVENANCE.md` for licensing.

## See also

[`chokepoint_sources`](https://warint.github.io/chokepointR/reference/chokepoint_sources.md),
[`chokepoint_resilience`](https://warint.github.io/chokepointR/reference/chokepoint_resilience.md)
