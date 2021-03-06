\name{summary.bdt}
\alias{summary.bdt}
\alias{print.summary.bdt}
\title{Summarization of the results of a call to the bdt function}
\description{These functions are \link{methods} for class \code{bdt}, \code{summary.bdt} objects}
\usage{
  \method{summary}{bdt}(object, \dots)
  \method{print}{summary.bdt}(x, \dots)
}

\arguments{
  \item{object}{an object of class \code{bdt} for summary functions.}
  \item{x}{an object of class \code{summary.bdt} for print functions.}
  \item{\dots}{currently ignored.}
}

\value{
  \item{true_Effect}{the true ate of simulated bootstrap datasets}
  \item{gbound}{the bounding for propensity scores used defined}
  \item{gGLM}{'GLM' or 'SL' method user defined to estimate ps}
  \item{bias.aiptw}{the Min., 1st Qu., Median, Mean, 3rd Qu., Max value of AIPTW bias ate over \code{M} replications }
  \item{bias.tmle}{the Min., 1st Qu., Median, Mean, 3rd Qu., Max value of TMLE bias ate over \code{M} replications }
  \item{sd.aiptw}{the average standard error of AIPTW estimatorover \code{M} replications}
  \item{sd.tmle}{the average standard error of TMLE over \code{M} replications}
  \item{cov.aiptw}{the coverage rate of AIPTW estimator over \code{M} replications}
  \item{cov.tmle}{the coverage rate of TMLE over \code{M} replications}
  \item{coverage}{coverage rates of TMLE and AIPTW over \code{M} replications}
  \item{sd}{influence function based standard errors of TMLE and AIPTW over \code{M} replications}
  \item{bias}{a data frame of summaries of three bias over \code{M} replications}
  \item{ps}{a data frame of summaries of pooled probabilities over \code{M} replications}
}

\details{\code{print.summary.bdt}, called indirectly by entering the command \kbd{summary(result)} (where \code{result} has class \code{bdt}).}


\seealso{
\code{\link{bdt}}
}
\examples{
# Example
  set.seed(1250)
  n <- 1000
  sigma <- matrix(c(2, 1, 1, 1), ncol = 2)
  X <- matrix(rnorm(n*2), ncol = nrow(sigma)) %*% chol(sigma)
  X <- X + matrix(rep(c(.5, 1),each = n), byrow = FALSE, ncol = 2)
  I1 <- rnorm(n,mean = 1, sd = 2)
  I2 <- rnorm(n,mean = 1, sd = 1.9)
  P1 <- rnorm(n,mean = 1, sd = 1.5)
  W <- data.frame(X, I1, I2, P1)
  colnames(W) <- c("W1", "W2", "I1", "I2",  "P1")
  A <- rbinom(n, 1, plogis(0.2 + W[,"W1"] + 0.3*W[,"I1"] + W[,"W1"]*W[,"I1"]
  - 0.2*(W[,"W2"] + W[,"I2"])^2 ))
  Y <-  1 + A + W[,"W1"] + 2*W[,"W2"] + 0.5*(W[,"W1"] + W[,"P1"])^2 + rnorm(n)

  result <- bdt(Y, A, W, outcome_type = "continuous", gGLM = TRUE, gform = "A~W2+W1+I1", M = 60)
  summary(result)
}

