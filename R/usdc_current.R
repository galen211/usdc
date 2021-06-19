#' Fetch the current USDC circulation on Ethereum
#'
#' @description
#' Queries the `blockchair` explorer to retrieve the erc-20 balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' ethereum()
ethereum <- function() {
  r <- httr::GET("https://api.blockchair.com/ethereum/erc-20/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48/stats")
  stopifnot(httr::status_code(r) == 200)
  t <- httr::content(r, as = 'text', encoding = 'UTF-8') %>% jsonlite::fromJSON() %>% .$data
  supply <- as.numeric(t$circulation) / 10**t$decimals
}

#' Fetch the current USDC circulation on Algorand
#'
#' @description
#' Queries the `AlgoExplorer` explorer to retrieve the ASA balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' algorand()
algorand <- function() {
  r <- httr::GET("https://algoexplorerapi.io/v1/asset/31566704")
  stopifnot(httr::status_code(r) == 200)
  t <- httr::content(r, as = 'text', encoding = 'UTF-8') %>% jsonlite::fromJSON()
  supply <- as.numeric(t$circulatingsupply) / 10**t$decimal
  return(supply)
}

#' Fetch the current USDC circulation on Stellar
#'
#' @description
#' Queries the `stellar` horizon explorer to retrieve the asset balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' stellar()
stellar <- function() {
  params <- list(
    asset_code = 'USDC',
    asset_issuer = 'GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN'
  )
  r <- httr::GET("https://horizon.stellar.org/assets", query = params)
  stopifnot(httr::status_code(r) == 200)
  t <- httr::content(r, as = 'text', encoding = 'UTF-8') %>% jsonlite::fromJSON() %>% .$`_embedded` %>% .$records
  supply <- as.numeric(t$amount)
  return(supply)
}

#' Fetch the current USDC circulation on Solana
#'
#' @description
#' Queries the `solana` JSON RPC api to retrieve the SPL token balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' solana()
solana <- function() {
  params <- '{"jsonrpc":"2.0", "id":1, "method":"getTokenSupply", "params": ["EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"]}'

  r <- httr::POST("https://api.mainnet-beta.solana.com/",
            httr::content_type_json(),
            body = params)
  stopifnot(httr::status_code(r) == 200)

  t <- httr::content(r, as = 'text') %>% jsonlite::fromJSON() %>% .$result %>% .$value
  supply <- as.numeric(t$amount) / 10**t$decimals
  return(supply)
}

#' Fetch the current USDC circulation on all official Centre blockchains
#'
#' @description
#' Queries the Algorand, Ethereum, Solana, and Stellar blockchains to retrieve the token balances of USDC on each blockchain
#'
#' @export
#' @return a tibble containing the current circulating amount of USDC
#' @examples
#' usdc_supply()
usdc_supply <- function() {
  usdc_ethereum <- ethereum()
  usdc_algorand <- algorand()
  usdc_stellar <- stellar()
  usdc_solana <- solana()

  last_updated <- lubridate::now()

  tb <- tibble::tibble(
    datetime = c(last_updated,last_updated,last_updated,last_updated),
    chain = c("Ethereum","Algorand","Stellar","Solana"),
    token_id = c("0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48","31566704","GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN","EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"),
    circulating_supply = c(usdc_ethereum,usdc_algorand,usdc_stellar,usdc_solana)
  )
  return(tb)
}

#' Fetch and print the current USDC circulation on all official Centre blockchains
#'
#' @description
#' Queries the Algorand, Ethereum, Solana, and Stellar blockchains to retrieve the token balances of USDC on each blockchain
#'
#' @export
#' @return prints the current circulating amount of USDC on each blockchain
#' @examples
#' print_all_chains()
print_all_chains <- function() {
  usdc_supply() %>%
    dplyr::mutate(circulating_supply = scales::dollar(circulating_supply)) %>%
    knitr::kable()
}
