library(usdc)

test_that("Algorand circulation fetches double value", {
  expect_type(fetch_supply_algorand(), "double")
})

test_that("Ethereum circulation fetches double value", {
  expect_type(fetch_supply_ethereum(), "double")
})

test_that("Solana circulation fetches double value", {
  expect_type(fetch_supply_solana(), "double")
})

test_that("Stellar circulation fetches double value", {
  expect_type(fetch_supply_stellar(), "double")
})
