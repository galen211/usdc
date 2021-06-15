# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

library(httr)

erc20 <- function() {
  r <- GET("https://api.blockchair.com/ethereum/erc-20/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48/stats")
  return(-1) # Number((res.data.data.circulation / (10 ** 6)).toFixed(2))
}

algorand <- function() {
  r <- GET("https://algoexplorerapi.io/v1/asset/31566704")
  return()
}

stellar <- function() {
  params <- list(
    asset_code = 'USDC',
    asset_issuer = 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN'
  )
  r <- GET("https://horizon.stellar.org/assets")
  # if (res.data && res.data._embedded && res.data._embedded.records &&
  #     res.data._embedded.records[0] && res.data._embedded.records[0].amount)
  #   return Number(Number(res.data._embedded.records[0].amount).toFixed(2));
}

solana <- function() {
  params <- list(
    jsonrpc = '2.0',
    id = 1,
    method = 'getTokenSupply',
    params = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'
  )

  r <- POST("https://api.mainnet-beta.solana.com/")
  # if (res.data && res.data.result && res.data.result.value &&
  #     res.data.result.value.amount && res.data.result.value.decimals)
  #   return Number((res.data.result.value.amount / (10 ** res.data.result.value.decimals)).toFixed(2));
}

all_chains <- function() {
  print('USDC Supply')
  print('-----------------------------------------');
  print('      Ethereum USDC:', -1);
  print('      Algorand USDC:', -1);
  print('       Stellar USDC:', -1);
  print('        Solana USDC:', -1);
  print('-----------------------------------------');
  print('USDC in circulation:', -1);
}
