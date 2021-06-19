#' Plot the current USDC circulation on all official Centre blockchains
#'
#' @description
#' Queries the Algorand, Ethereum, Solana, and Stellar blockchains to retrieve the token balances of USDC
#' on each blockchain and then plots the result on a bar chart
#'
#' @export
#' @return a ggplot2 chart showing the current circulating amount of USDC
#' @examples
#' chart_current_supply_usdc()
chart_current_supply_usdc <- function() {
  fetch_supply_usdc() %>%
    dplyr::arrange(dplyr::desc(circulating_supply)) %>%
    ggplot2::ggplot(ggplot2::aes(x = chain, y = circulating_supply)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::dollar_format(scale = 1e-9, accuracy = 1)) +
    ggplot2::xlab('Blockchain') + ggplot2::ylab('USDC Supply (Billions)') +
    ggplot2::theme_light()
}

#' Plot the historical USDC circulation on Ethereum
#'
#' @description
#' Queries the CoinMetrics API to retrieve the circulating supply of USDC
#' on Ethereum and then plots the result on a line chart
#'
#' @export
#' @return a ggplot2 chart showing the historical circulating amount of USDC on Ethereum
#' @examples
#' chart_historical_supply_usdc()
chart_historical_supply_usdc <- function() {
  fetch_historical_ethereum(metric = "CapMrktCurUSD") %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = value)) +
    ggplot2::geom_line(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::dollar_format(scale = 1e-9, accuracy = 1)) +
    ggplot2::xlab('Date') + ggplot2::ylab('USDC Supply, Ethereum (Billions)') +
    ggplot2::theme_light()
}
