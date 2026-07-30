# Trade chokepoint disruption incidents

A tidy log of documented disruption and passage-restriction incidents at
major global trade chokepoints (2018 onward). Each row is a dated
incident at one chokepoint, classified by risk type and a qualitative
severity `level`, described in original wording and attributed to a
resolvable `source_url`.

## Usage

``` r
chokepoint_risks
```

## Format

A data frame with the following columns:

- location:

  Chokepoint name (see
  [`chokepoints`](https://warint.github.io/chokepointR/reference/chokepoints.md)).

- incident_year:

  Year (or year range) of the incident.

- risk:

  Risk in natural language (e.g. "Storms", "Piracy"); see
  [`risk_types`](https://warint.github.io/chokepointR/reference/risk_types.md).

- risk_category:

  One of "Weather and climate risk", "Security and conflict risk",
  "Political and institutional risk".

- risk_code:

  Short risk code (e.g. "W-S", "S-P").

- level:

  Qualitative severity: "Low risk", "Medium risk", "High risk".

- incident:

  One-sentence factual description of the incident.

- source:

  Publisher of the cited report.

- source_url:

  Resolvable URL for the source.

## Details

Coverage is incident-driven: chokepoints without a well-documented
incident in the period are absent from this table but remain listed in
the
[`chokepoints`](https://warint.github.io/chokepointR/reference/chokepoints.md)
reference. See the `DATA-PROVENANCE.md` file installed with the package
for full source and licensing notes.
