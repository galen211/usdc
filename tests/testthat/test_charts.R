library(usdc)

test_that("Current supply chart builds successfully", {
  expect_s3_class(chart_current_supply_usdc(), c("gg","ggplot"), exact = TRUE)
})


test_that("Historical supply chart builds successfully", {
  expect_s3_class(chart_historical_supply_usdc(), c("gg","ggplot"), exact = TRUE)
})
