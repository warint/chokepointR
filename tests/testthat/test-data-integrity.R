test_that("chokepoint_risks has the expected schema", {
  expect_s3_class(chokepoint_risks, "data.frame")
  expect_setequal(
    names(chokepoint_risks),
    c("location", "incident_year", "risk", "risk_category", "risk_code",
      "level", "incident", "source", "source_url")
  )
  expect_gt(nrow(chokepoint_risks), 0)
})

test_that("controlled vocabulary is respected", {
  expect_true(all(chokepoint_risks$location %in% chokepoints$location))
  expect_true(all(chokepoint_risks$risk_code %in% risk_types$risk_code))
  expect_true(all(chokepoint_risks$level %in%
                    c("Low risk", "Medium risk", "High risk")))
})

test_that("risk, risk_category and risk_code are mutually consistent", {
  map <- unique(chokepoint_risks[, c("risk_code", "risk", "risk_category")])
  ref <- risk_types[, c("risk_code", "risk", "risk_category")]
  merged <- merge(map, ref, by = "risk_code", suffixes = c("", ".ref"))
  expect_true(all(merged$risk == merged$risk.ref))
  expect_true(all(merged$risk_category == merged$risk_category.ref))
})

test_that("every incident carries a resolvable citation", {
  expect_true(all(!is.na(chokepoint_risks$incident)))
  expect_true(all(grepl("^https?://", chokepoint_risks$source_url)))
  expect_true(all(!is.na(chokepoint_risks$source)))
})

test_that("no legacy / Chatham House data remains", {
  expect_false(any(grepl("Chatham", chokepoint_risks$source, ignore.case = TRUE)))
  expect_false(any(grepl("chathamhouse", chokepoint_risks$source_url,
                         ignore.case = TRUE)))
})

test_that("risk_types is the full 11-risk taxonomy", {
  expect_equal(nrow(risk_types), 11)
  expect_setequal(unique(risk_types$risk_category),
                  c("Weather and climate risk", "Security and conflict risk",
                    "Political and institutional risk"))
})

test_that("chokepoints has coordinates for all 8 chokepoints", {
  expect_equal(nrow(chokepoints), 8)
  expect_true(all(is.finite(chokepoints$latitude)))
  expect_true(all(is.finite(chokepoints$longitude)))
  expect_true(all(abs(chokepoints$latitude) <= 90))
  expect_true(all(abs(chokepoints$longitude) <= 180))
})

test_that("chokepoint_resilience is well-formed", {
  d <- chokepoint_resilience
  expect_equal(nrow(d), 8)
  expect_setequal(d$location, chokepoints$location)
  # indices are on a 0-100 scale
  expect_true(all(d$resilience_index >= 0 & d$resilience_index <= 100))
  expect_true(all(d$vulnerability_index >= 0 & d$vulnerability_index <= 100))
  # dimension scores are 0-1
  for (col in c("importance_score", "dependency_score", "systemic_risk_score",
                "redundancy_score", "exposure_score"))
    expect_true(all(d[[col]] >= 0 & d[[col]] <= 1), info = col)
  # core measures present
  expect_true(all(!is.na(d$trade_value_bn_usd)))
  # network centrality present and on a 0-1 scale
  for (col in c("betweenness_centrality", "degree_centrality"))
    expect_true(all(d[[col]] >= 0 & d[[col]] <= 1), info = col)
})

test_that("chokepoint_context is well-formed", {
  d <- chokepoint_context
  expect_s3_class(d, "data.frame")
  expect_equal(nrow(d), 8)
  expect_setequal(d$location, chokepoints$location)
  expect_true(all(c("transit_basis", "primary_cargo", "dominant_vessels",
                    "top_users", "local_economic_note", "reroute_note") %in%
                    names(d)))
  # every profile carries a counting-basis note and cargo description
  expect_true(all(!is.na(d$transit_basis) & nzchar(d$transit_basis)))
  expect_true(all(!is.na(d$primary_cargo) & nzchar(d$primary_cargo)))
})

test_that("chokepoint_sources is a resolvable citation table", {
  d <- chokepoint_sources
  expect_setequal(
    names(d),
    c("location", "variable", "value", "unit", "year", "basis",
      "source", "source_url", "confidence")
  )
  expect_true(all(d$location %in% chokepoints$location))
  expect_true(all(d$confidence %in% c("High", "Medium", "Low")))
  expect_true(all(grepl("^https?://", d$source_url)))
  expect_true(all(!is.na(d$source) & nzchar(d$source)))
  # every context chokepoint has at least one sourced figure
  expect_setequal(unique(d$location), chokepoint_context$location)
})
