#' Store API key into Environment Variable
#'
#' This function stores the provided API key as argument in to an environment
#' variable `BITQUERY_KEY` for further use by other `usdc` functions.
#'
#' For more information regarding API keys, please refer to dedicated vignette
#' with the following command
#' `vignette("setting_up_api_key", package = "usdc")`
#'
#' @param key \[`character(1)`\]\cr{}
#'            A string giving the API key to save into the environment
#'
#' @export
#' @examples \dontrun{
#' rr_auth("BQY8IPItkNCP0iK8BqvmhSWV1pxpFqrB")
#' }
bitquery_auth <- function(key) {
  Sys.setenv("BITQUERY_KEY" = key)
}

blockchair_auth <- function(key) {
  Sys.setenv("BLOCKCHAIR_KEY" = key)
}

thegraph_auth <- function(key) {
  Sys.setenv("THEGRAPH_KEY" = key)
}
