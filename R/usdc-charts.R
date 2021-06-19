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
  circulating_supply <- chain <- NULL
  df <- fetch_supply_usdc()
  total_supply = sum(df$circulating_supply)
  df %>%
    dplyr::arrange(dplyr::desc(circulating_supply)) %>%
    ggplot2::ggplot(ggplot2::aes(x = chain, y = circulating_supply)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::dollar_format(scale = 1e-9, accuracy = 1)) +
    ggplot2::xlab("\nBlockchain") +
    ggplot2::ylab("USD Billions\n") +
    ggplot2::ggtitle("Current USDC Supply\n", subtitle = paste("Total Supply:", scales::dollar(total_supply, scale = 1e-9, accuracy = 0.1), "Billion")) +
    ggthemes::theme_economist_white(
      gray_bg = FALSE,
      base_size = 12
    )
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
  circulating_supply <- date <- value <- NULL
  fetch_historical_ethereum(metric = "CapMrktCurUSD") %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = value)) +
    ggplot2::geom_line(stat = "identity") +
    ggplot2::scale_y_continuous(labels = scales::dollar_format(scale = 1e-9, accuracy = 1)) +
    ggplot2::xlab("\nDate") +
    ggplot2::ylab("USD Billions\n") +
    ggplot2::ggtitle("Historical USDC Supply\n", subtitle = "Ethereum") +
    ggthemes::theme_economist_white(
      gray_bg = FALSE,
      base_size = 12
    )
}
