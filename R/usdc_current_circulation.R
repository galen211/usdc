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
ethereum <- function() {
  r <- GET("https://api.blockchair.com/ethereum/erc-20/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48/stats")
  stopifnot(status_code(r) == 200)
  t <- content(r, as = 'text') %>% jsonlite::fromJSON() %>% .$data
  supply <- as.numeric(t$circulation) / 10**t$decimals
}

algorand <- function() {
  r <- GET("https://algoexplorerapi.io/v1/asset/31566704")
  stopifnot(status_code(r) == 200)
  t <- content(r, as = 'text') %>% jsonlite::fromJSON()
  supply <- as.numeric(t$circulatingsupply) / 10**t$decimal
  return(supply)
}

stellar <- function() {
  params <- list(
    asset_code = 'USDC',
    asset_issuer = 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN'
  )
  r <- GET("https://horizon.stellar.org/assets", query = params)
  stopifnot(status_code(r) == 200)
  t <- content(r, as = 'text') %>% jsonlite::fromJSON() %>% .$`_embedded` %>% .$records
  supply <- as.numeric(t$amount)
  return(supply)
}

solana <- function() {
  params <- '{"jsonrpc":"2.0", "id":1, "method":"getTokenSupply", "params": ["EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"]}'

  r <- httr::POST("https://api.mainnet-beta.solana.com/",
            content_type_json(),
            body = params)
  stopifnot(status_code(r) == 200)

  t <- httr::content(r, as = 'text') %>% jsonlite::fromJSON() %>% .$result %>% .$value
  supply <- as.numeric(t$amount) / 10**t$decimals
  return(supply)
}

usdc_supply <- function() {
  usdc_ethereum <- ethereum()
  usdc_algorand <- algorand()
  usdc_stellar <- stellar()
  usdc_solana <- solana()

  last_updated <- lubridate::now()

  tb <- tibble(
    datetime = c(last_updated,last_updated,last_updated,last_updated),
    chain = c("Ethereum","Algorand","Stellar","Solana"),
    token_id = c("0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48","31566704","GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN","EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"),
    circulating_supply = c(usdc_ethereum,usdc_algorand,usdc_stellar,usdc_solana)
  )
  return(tb)
}

print_all_chains <- function() {

  usdc_ethereum <- ethereum()
  usdc_algorand <- algorand()
  usdc_stellar <- stellar()
  usdc_solana <- solana()
  all <- usdc_ethereum + usdc_algorand + usdc_stellar + usdc_solana

  print('USDC Supply')
  print(paste0('-----------------------------------------'))
  print(paste0('      Ethereum USDC: ', scales::dollar(usdc_ethereum)))
  print(paste0('      Algorand USDC: ', scales::dollar(usdc_algorand)))
  print(paste0('       Stellar USDC: ', scales::dollar(usdc_stellar)))
  print(paste0('        Solana USDC: ', scales::dollar(usdc_solana)))
  print(paste0('-----------------------------------------'))
  print(paste0('Total USDC in circulation: ', scales::dollar(all)))
}
