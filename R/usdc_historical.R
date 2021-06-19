#' Fetch historical USDC metrics on Ethereum
#'
#' @description
#' Queries the `CoinMetrics` API to retrieve historical USDC metrics
#'
#' @export
#'
#' @param metric (character) A valid CoinMetrics asset metric
#' @return a dataframe with the historical USDC metrics (see: https://docs.coinmetrics.io/api/v4#operation/getCatalogAllMetrics)
#' @examples
#' fetch_historical_ethereum(metric = 'CapMrktCurUSD')
fetch_historical_ethereum <- function(metric = 'CapMrktCurUSD') {
  `time` <- asset <- value <- . <- NULL

  match.arg(metric, coinmetrics_supported_metrics, several.ok = FALSE)

  params <- list(
    assets = 'usdc',
    metrics = metric,
    page_size = 10000
  )
  r <- httr::GET("https://community-api.coinmetrics.io/v4/timeseries/asset-metrics", query = params)
  stopifnot(httr::status_code(r) == 200)
  t <- httr::content(r, as = 'text', encoding = 'UTF-8') %>%
    jsonlite::fromJSON() %>%
    .$data %>%
    dplyr::rename(
      date = `time`,
      value = metric) %>%
    dplyr::select(-asset) %>%
    dplyr::mutate(
      date = lubridate::as_date(date),
      measurement = metric,
      value = as.numeric(value),
      blockchain = 'Ethereum') %>%
    dplyr::as_tibble()

  return(t)
}

#' Supported CoinMetrics metrics for USDC
#'
coinmetrics_supported_metrics <- c(
  'CapMrktCurUSD','SplyAct1d',
  'SplyAct7d','SplyAct30d',
  'SplyAct90d','SplyAct180d',
  'SplyAct1yr','SplyAct2yr',
  'SplyAct3yr','SplyAct4yr',
  'SplyAdrTop100','SplyAdrTop10Pct',
  'SplyAdrTop1Pct','AdrBalUSD1MCnt',
  'AdrBalUSD10MCnt','AdrBalUSD100KCnt',
  'AdrBalUSD10KCnt','AdrBalUSD1KCnt',
  'AdrBalUSD100Cnt','AdrBalUSD10Cnt',
  'AdrBalUSD1Cnt','TxCnt',
  'TxTfrValAdjNtv','TxTfrValMedNtv',
  'FlowInExNtv','FlowOutExNtv'
)
