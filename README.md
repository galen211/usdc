<img src="https://cryptologos.cc/logos/usd-coin-usdc-logo.png" width="50"/>

# usdc

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/rnoaa)](https://cranchecks.info/pkgs/rnoaa)
[![R-check](https://github.com/ropensci/rnoaa/workflows/R-check/badge.svg)](https://github.com/ropensci/rnoaa/actions)
[![codecov.io](https://codecov.io/github/ropensci/rnoaa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rnoaa?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rnoaa?color=C9A115)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rnoaa)](https://cran.r-project.org/package=rnoaa)

`usdc` is an R interface to data sources that can be used to track USDC in circulation on multiple blockchains and over time.  This package is under active development and currently only covers historical circulation data on Ethereum.  USDC is a US dollar-backed stablecoin issued by the [Centre Consortium](https://www.centre.io/).  This is not an official project of the Centre Consortium and there is no express or implied warranty regarding the accuracy of any information provided through this package.  Detailed information about Centre can be found on their website and in their [whitepaper](https://f.hubspotusercontent30.net/hubfs/9304636/PDF/centre-whitepaper.pdf).  More information about the data sources used to provide current and historical USDC data can be found below.

## Usage

Print the value of current circulating supply to the console
```r
library(usdc)
print_all_chains()
```
|datetime            |chain    |token_id                                                 |circulating_supply |
|:-------------------|:--------|:--------------------------------------------------------|:------------------|
|2021-06-19 09:20:40 |Ethereum |0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48               |$23,523,192,840    |
|2021-06-19 09:20:40 |Algorand |31566704                                                 |$180,804,866       |
|2021-06-19 09:20:40 |Stellar  |GA5ZSEJYB37JRC5AVCIA5MOP4RHTM335X2KGX3IHOJAPP5RE34K4KZVN |$12,896,127        |
|2021-06-19 09:20:40 |Solana   |EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v             |$785,000,020       |

Store the current circulating supply in a tibble data frame
```r
library(usdc)
df <- usdc_supply()
```



## Data sources in `usdc`

* Current USDC in circulation on each of the officially supported blockchains is provided through the webservices listed below:
    * **Algorand**: explorer API service through [AlgoExplorer](https://algoexplorer.io/)
    * **Ethereum**: explorer API service through [Blockchair](https://blockchair.com/)
    * **Solana**: JSON RPC API provided by [Solana](https://docs.solana.com/developing/clients/jsonrpc-api)
    * **Stellar**: explorer API service through [Stellar Foundation](https://www.stellar.org/)

## Roadmap
The purpose of this project is to be a one-stop shop for analytics on Centre-issued Stablecoins for R users who want to use data science to understand the use of stablecoins on public blockchains.  Centre has a [subgraph](https://thegraph.com/explorer/subgraph/centrehq/usdc) hosted on the Graph Protocol, which is under development and may eventually expose some of the desired functionality on the roadmap below.

Outstanding Items:
- Track each chains historical balance of USDC (currently, only the Ethereum balance is available in this package)
- Track USDC token balances deposited in different lending and DEX protocols
- Add ability to query the USDC subgraph using the Graph protocol


# Scratch Code
```r

  # usdc_ethereum <- ethereum()
  # usdc_algorand <- algorand()
  # usdc_stellar <- stellar()
  # usdc_solana <- solana()
  # all <- usdc_ethereum + usdc_algorand + usdc_stellar + usdc_solana
  #
  # print('USDC Supply')
  # print(paste0('-----------------------------------------'))
  # print(paste0('      Ethereum USDC: ', scales::dollar(usdc_ethereum)))
  # print(paste0('      Algorand USDC: ', scales::dollar(usdc_algorand)))
  # print(paste0('       Stellar USDC: ', scales::dollar(usdc_stellar)))
  # print(paste0('        Solana USDC: ', scales::dollar(usdc_solana)))
  # print(paste0('-----------------------------------------'))
  # print(paste0('Total USDC in circulation: ', scales::dollar(all)))
```
