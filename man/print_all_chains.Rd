% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/usdc-current.R
\name{print_all_chains}
\alias{print_all_chains}
\title{Fetch and print the current USDC circulation on all official Centre blockchains}
\usage{
print_all_chains()
}
\value{
prints the current circulating amount of USDC on each blockchain
}
\description{
Queries the Algorand, Ethereum, Solana, and Stellar blockchains to retrieve the token balances of USDC on each blockchain
}
\examples{
print_all_chains()
}
