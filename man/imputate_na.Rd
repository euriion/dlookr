% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/imputation.R
\name{imputate_na}
\alias{imputate_na}
\title{Imputate Missing values}
\usage{
imputate_na(.data, xvar, yvar, method, seed, print_flag)
}
\arguments{
\item{.data}{a data.frame or a \code{\link{tbl_df}}.}

\item{xvar}{variable name to replace missing value.}

\item{yvar}{target variable.}

\item{method}{method of missing values imputation.}

\item{seed}{integer. the random seed used in mice. only used "mice" method.}

\item{print_flag}{logical. If TRUE, mice will print history on console.
Use print_flag=FALSE for silent computation. Used only when method is "mice".}
}
\value{
An object of imputation class.
Attributes of imputation class is as follows.
\itemize{
\item var_type : the data type of predictor to replace missing value.
\item method : method of missing value imputation.
\itemize{
  \item predictor is numerical variable
  \itemize{
    \item "mean" : arithmetic mean
    \item "median" : median
    \item "mode" : mode
    \item "knn" : K-nearest neighbors
    \item "rpart" : Recursive Partitioning and Regression Trees
    \item "mice" : Multivariate Imputation by Chained Equations
  }
  \item predictor is categorical variable
  \itemize{
    \item "mode" : mode
    \item "rpart" : Recursive Partitioning and Regression Trees
    \item "mice" : Multivariate Imputation by Chained Equations
  }
}
\item na_pos : position of missing value in predictor.
\item seed : the random seed used in mice. only used "mice" method.
\item type : "missing values". type of imputation.
}
}
\description{
Missing values are imputated with some representative values and
statistical methods.
}
\details{
imputate_na () creates an imputation class.
The `imputation` class includes missing value position, imputated value,
and method of missing value imputation, etc.
The `imputation` class compares the imputated value with the original value
to help determine whether the imputated value is used in the analysis.

See vignette("transformation") for an introduction to these concepts.
}
\examples{
\dontrun{
# Generate data for the example
carseats <- ISLR::Carseats
carseats[sample(seq(NROW(carseats)), 20), "Income"] <- NA
carseats[sample(seq(NROW(carseats)), 5), "Urban"] <- NA

# Replace the missing value of the Income variable with median
imputate_na(carseats, Income, method = "median")

# Replace the missing value of the Income variable with rpart
# The target variable is US.
imputate_na(carseats, Income, US, method = "rpart")

# Replace the missing value of the Urban variable with median
imputate_na(carseats, Urban, method = "mode")

# Replace the missing value of the Urban variable with mice
# The target variable is US.
imputate_na(carseats, Urban, US, method = "mice")

## using dplyr -------------------------------------
library(dplyr)

# The mean before and after the imputation of the Income variable
carseats \%>\%
  mutate(Income_imp = imputate_na(carseats, Income, US, method = "knn")) \%>\%
  group_by(US) \%>\%
  summarise(orig = mean(Income, na.rm = TRUE),
    imputation = mean(Income_imp))

# If the variable of interest is a numarical variable
income <- imputate_na(carseats, Income, US, method = "rpart")
income
summary(income)
plot(income)

# If the variable of interest is a categorical variable
urban <- imputate_na(carseats, Urban, US, method = "mice")
urban
summary(urban)
plot(urban)
}
}
\seealso{
\code{\link{imputate_outlier}}.
}
