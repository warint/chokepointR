# The eight-chokepoint API and datasets: stable schema and behaviour.

test_that("cp_resilience() default returns the 8-maritime resilience object", {
  d <- cp_resilience()
  expect_equal(nrow(d), 8)
  # identical (up to row order) to the bundled object it has always returned
  expect_setequal(names(d), names(chokepoint_resilience))
  expect_setequal(d$location, chokepoint_resilience$location)
  # default sort is by vulnerability_index descending, as before
  expect_false(is.unsorted(rev(d$vulnerability_index)))
  # positional legacy call still works
  expect_equal(cp_resilience("location")$location,
               sort(chokepoint_resilience$location))
  # the legacy composite columns are byte-stable
  ref <- chokepoint_resilience[order(chokepoint_resilience$location), ]
  got <- cp_resilience("location")
  expect_equal(got$vulnerability_index, ref$vulnerability_index)
  expect_equal(got$resilience_index, ref$resilience_index)
})

test_that("the six datasets keep their schemas", {
  expect_equal(nrow(chokepoints), 8)
  expect_equal(nrow(risk_types), 11)
  expect_true(all(c("location", "type", "region", "latitude", "longitude") %in%
                    names(chokepoints)))
  expect_true("vulnerability_index" %in% names(chokepoint_resilience))
})

test_that("the query functions return the maritime tables", {
  expect_equal(nrow(cp_data()), nrow(chokepoint_risks))
  expect_equal(nrow(cp_location()), 8)
  expect_equal(nrow(cp_risk()), 11)
  expect_equal(nrow(cp_context()), 8)
})
