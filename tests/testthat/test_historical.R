library(usdc)

test_that("Ethereum historical circulation fetches tibble data frame", {
  expect_type(fetch_historical_ethereum(), "list")
})

test_that("Unsupported metric throws error", {
  expect_error(fetch_historical_ethereum(metric = "DNE"))
})
