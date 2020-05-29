#' @title algae
#' @description Algae data set. The data contains the status of algae
#' in 274 measurement sites in Finnish lakes and rivers.
#' @format A vector with 274 elements:
#' \describe{
#'   \item{1}{Algae present}
#'   \item{0}{No algae present}
#' }
"algae"

#' @title bioassay
#' @description Bioassay data set. Taken from Table 3.1
#' in the BDA book
#' @format A data frame with 4 rows and 3 variables:
#' \describe{
#'   \item{x}{dose [log g/ml]}
#'   \item{n}{number of animals}
#'   \item{y}{number of deaths}
#' }
"bioassay"

#' @title bioassay_posterior
#' @description Sample from the posterior of the bioassay model.
#' @format A data frame with 1000 rows and 2 variables:
#' \describe{
#'   \item{alpha}{Parameter of the bioassay model}
#'   \item{beta}{Parameter of the bioassay model}
#' }
"bioassay_posterior"

#' @title drowning
#' @description drowning data set. The data contains the number of people
#' who have drowned per year in Finland between 1980 and 2016.
#' @format A data frame with 37 rows and 2 variables:
#' \describe{
#'   \item{year}{year}
#'   \item{drownings}{number of drownings in Finland}
#' }
"drowning"

#' @title factory
#' @description factory data set. The data contains quality control measurements
#' from 6 machines in a factory.
#' @format A data frame with 5 rows and 6 variables:
#' \describe{
#'   \item{V1}{Machine 1}
#'   \item{V2}{Machine 2}
#'   \item{V3}{Machine 3}
#'   \item{V4}{Machine 4}
#'   \item{V5}{Machine 5}
#'   \item{V6}{Machine 6}
#' }
"factory"

#' @title windshieldy1
#' @description windshieldy1 data set. The data represents a sample of
#' windshields whose hardness has been measured.
#' @format A vector with 9 elements
"windshieldy1"

#' @title windshieldy2
#' @description windshieldy2 data set. The data represents a sample of
#' windshields whose hardness has been measured.
#' @format A vector with 13 elements
"windshieldy2"
