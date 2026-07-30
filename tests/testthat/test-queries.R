test_that("cp_data() returns the full dataset and filters correctly", {
  expect_equal(nrow(cp_data()), nrow(chokepoint_risks))

  d <- cp_data(locations = "Panama Canal")
  expect_true(all(d$location == "Panama Canal"))

  d2 <- cp_data(locations = "Panama Canal", risks = "S-T")
  expect_true(all(d2$risk_code == "S-T"))

  d3 <- cp_data(category = "Weather and climate risk")
  expect_true(all(d3$risk_category == "Weather and climate risk"))

  expect_equal(nrow(cp_data(locations = "Nowhere")), 0)
})

test_that("cp_risk() and cp_location() behave", {
  expect_equal(nrow(cp_risk()), 11)
  expect_equal(nrow(cp_risk("storm")), 1)
  expect_equal(cp_risk("storm")$risk_code, "W-S")

  expect_equal(nrow(cp_location()), 8)
  expect_setequal(cp_location("Canal")$location,
                  c("Panama Canal", "Suez Canal"))
})

test_that("cp_search() matches, ranks and handles edge cases", {
  # empty query returns everything
  expect_equal(nrow(cp_search("")), nrow(chokepoint_risks))
  expect_equal(nrow(cp_search()), nrow(chokepoint_risks))

  # AND semantics across terms
  res <- cp_search("drought Panama")
  expect_gt(nrow(res), 0)
  expect_true(all(res$location == "Panama Canal"))

  # incidents_only drops rating-only rows
  res2 <- cp_search("Panama", incidents_only = TRUE)
  expect_true(all(!is.na(res2$incident)))

  # no match -> zero rows, still a data frame with correct columns
  none <- cp_search("zzzznotathing")
  expect_s3_class(none, "data.frame")
  expect_equal(nrow(none), 0)
  expect_true("location" %in% names(none))
})

test_that("cp_map() builds a leaflet widget and validates input", {
  skip_if_not_installed("leaflet")
  m <- cp_map(levels = "High risk")
  expect_s3_class(m, "leaflet")
  expect_error(cp_map(locations = "Nowhere"), "No records")
})

test_that("cp_signals() validates location without needing the network", {
  expect_error(cp_signals("Not a chokepoint"), "Unknown location")
  expect_error(cp_signals(), "single `location`")
})

test_that("cp_resilience() returns the profile, sortable", {
  expect_equal(nrow(cp_resilience()), 8)
  v <- cp_resilience("vulnerability_index")$vulnerability_index
  expect_false(is.unsorted(rev(v)))                 # descending
  expect_equal(cp_resilience("location")$location,
               sort(chokepoint_resilience$location))
})

test_that("cp_context() returns and filters the context profile", {
  expect_equal(nrow(cp_context()), 8)
  h <- cp_context(locations = "Hormuz")
  expect_equal(nrow(h), 1)
  expect_equal(h$location, "Strait of Hormuz")
  expect_equal(nrow(cp_context(locations = "Nowhere")), 0)
})

test_that("cp_sources() filters by location and confidence", {
  expect_equal(nrow(cp_sources()), nrow(chokepoint_sources))
  # min_confidence monotonically shrinks the table
  n_all  <- nrow(cp_sources(min_confidence = "Low"))
  n_med  <- nrow(cp_sources(min_confidence = "Medium"))
  n_high <- nrow(cp_sources(min_confidence = "High"))
  expect_true(n_all >= n_med && n_med >= n_high)
  expect_true(all(cp_sources(min_confidence = "High")$confidence == "High"))
  expect_true(all(cp_sources(locations = "Suez")$location == "Suez Canal"))
})
