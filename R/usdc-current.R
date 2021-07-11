#' Fetch the current USDC circulation on Ethereum
#'
#' @description
#' Queries the `blockchair` explorer to retrieve the erc-20 balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' fetch_supply_ethereum()
#' @importFrom rlang .data
fetch_supply_ethereum <- function() {
  . <- NULL
  r <- httr::GET("https://api.blockchair.com/ethereum/erc-20/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48/stats")
  if(httr::http_error(r)){ 	warning("BlockChair webservice is unable to retrieve USDC balance on Ethereum") }
  t <- httr::content(r, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON() %>%
    .$data
  supply <- as.numeric(t$circulation) / 10**t$decimals
  return(supply)
}

#' Fetch the current USDC circulation on Algorand
#'
#' @description
#' Queries the `AlgoExplorer` explorer to retrieve the ASA balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' fetch_supply_algorand()
#' @importFrom rlang .data
fetch_supply_algorand <- function() {
  r <- httr::GET("https://algoexplorerapi.io/v1/asset/31566704")
  if(httr::http_error(r)){ 	warning("AlgoExplorer webservice is unable to retrieve USDC balance on Algorand") }
  t <- httr::content(r, as = "text", encoding = "UTF-8") %>% jsonlite::fromJSON()
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
#' fetch_supply_stellar()
#' @importFrom rlang .data
fetch_supply_stellar <- function() {
  . <- NULL
  params <- list(
    asset_code = "USDC",
    asset_issuer = "GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN"
  )
  r <- httr::GET("https://horizon.stellar.org/assets", query = params)
  if(httr::http_error(r)){ 	warning("Horizon webservice is unable to retrieve USDC balance on Stellar") }
  t <- httr::content(r, as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON() %>%
    .$`_embedded` %>%
    .$records
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
#' fetch_supply_solana()
#' @importFrom rlang .data
fetch_supply_solana <- function() {
  . <- NULL
  params <- '{"jsonrpc":"2.0", "id":1, "method":"getTokenSupply", "params": ["EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"]}'

  r <- httr::POST("https://api.mainnet-beta.solana.com/",
    httr::content_type_json(),
    body = params
  )
  if(httr::http_error(r)){ 	warning("Solana RPC webservice is unable to retrieve USDC balance on Solana") }

  t <- httr::content(r, as = "text") %>%
    jsonlite::fromJSON() %>%
    .$result %>%
    .$value
  supply <- as.numeric(t$amount) / 10**t$decimals
  return(supply)
}

#' Fetch the current USDC circulation on TRON
#'
#' @description
#' Queries the `tronscan` explorer to retrieve the TRC-20 balance of USDC
#'
#' @export
#' @return the current circulating amount of USDC
#' @examples
#' fetch_supply_tron()
#' @importFrom rlang .data
fetch_supply_tron <- function() {
  . <- NULL
  r <- httr::GET("https://apilist.tronscan.org/api/token_trc20?contract=TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8&showAll=1")
  if(httr::http_error(r)){ 	warning("TronScan webservice is unable to retrieve USDC balance on TRON") }
  t <- httr::content(r, as = "text", encoding = "UTF-8") %>% jsonlite::fromJSON() %>%
    .$trc20_tokens
  supply <- as.numeric(t$total_supply_with_decimals) / 10**6
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
#' fetch_supply_usdc()
fetch_supply_usdc <- function() {
  ethereum_supply <- fetch_supply_ethereum()
  algorand_supply <- fetch_supply_algorand()
  stellar_supply <- fetch_supply_stellar()
  solana_supply <- fetch_supply_solana()
  tron_supply <- fetch_supply_tron()

  last_updated <- lubridate::now()

  tb <- tibble::tibble(
    datetime = c(last_updated, last_updated, last_updated, last_updated, last_updated),
    chain = c("Ethereum", "Algorand", "Stellar", "Solana", "TRON"),
    token_id = c("0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
                 "31566704",
                 "GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN",
                 "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
                 "TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8"),
    circulating_supply = c(ethereum_supply, algorand_supply, stellar_supply, solana_supply, tron_supply)
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
  circulating_supply <- NULL
  fetch_supply_usdc() %>%
    dplyr::mutate(circulating_supply = scales::dollar(circulating_supply)) %>%
    knitr::kable()
}
