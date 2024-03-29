% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/publish.glm.R
\name{publish.glm}
\alias{publish.glm}
\title{Tabulize regression coefficients with confidence intervals and p-values.}
\usage{
\method{publish}{glm}(
  object,
  confint.method,
  pvalue.method,
  digits = c(2, 4),
  print = TRUE,
  factor.reference = "extraline",
  intercept = ifelse((is.null(object$family) || object$family$family == "gaussian"), 1L,
    0L),
  units = NULL,
  ...
)
}
\arguments{
\item{object}{A \code{glm} object.}

\item{confint.method}{See \code{regressionTable}.}

\item{pvalue.method}{See \code{regressionTable}.}

\item{digits}{A vector of two integer values. These determine how to round
numbers (first value) and p-values (second value). E.g., c(1,3) would
mean 1 digit for all numbers and 3 digits for p-values.
The actual rounding is done by \code{summary.regressionTable}.}

\item{print}{If \code{FALSE} do not print results.}

\item{factor.reference}{Style for showing results for categorical. See \code{regressionTable}.}

\item{intercept}{See \code{regressionTable}.}

\item{units}{See \code{regressionTable}.}

\item{...}{passed to \code{summary.regressionTable} and also
to \code{labelUnits}.}

\item{reference}{Style for showing results for categorical
variables. If \code{"extraline"} show an additional line for the
reference category.}
}
\value{
Table with regression coefficients, confidence intervals and p-values.
}
\description{
Tabulate the results of a generalized linear regression analysis.
}
\details{
The table shows changes in mean for linear regression and
odds ratios for logistic regression (family = binomial).
}
\examples{
data(Diabetes)
## Linear regression
f = glm(bp.2s~frame+gender+age,data=Diabetes)
publish(f)
publish(f,factor.reference="inline")
publish(f,pvalue.stars=TRUE)
publish(f,ci.format="(l,u)")

### interaction
fit = glm(bp.2s~frame+gender*age,data=Diabetes)
summary(fit)
publish(fit)

Fit = glm(bp.2s~frame*gender+age,data=Diabetes)
publish(Fit)

## Logistic regression
Diabetes$hyper1 <- factor(1*(Diabetes$bp.1s>140))
lrfit <- glm(hyper1~frame+gender+age,data=Diabetes,family=binomial)
publish(lrfit)

### interaction
lrfit1 <- glm(hyper1~frame+gender*age,data=Diabetes,family=binomial)
publish(lrfit1)

lrfit2 <- glm(hyper1~frame*gender+age,data=Diabetes,family=binomial)
publish(lrfit2)

## Poisson regression
data(trace)
trace <- Units(trace,list("age"="years"))
fit <- glm(dead ~ smoking+sex+age+Time+offset(log(ObsTime)), family="poisson",data=trace)
rtf <- regressionTable(fit,factor.reference = "inline")
summary(rtf)
publish(fit)

## gls regression
if (requireNamespace("nlme",quietly=TRUE)){
    requireNamespace("lava",quietly=TRUE)
library(lava)
library(nlme)
m <- lvm(Y ~ X1 + gender + group + Interaction)
distribution(m, ~gender) <- binomial.lvm()
distribution(m, ~group) <- binomial.lvm(size = 2)
constrain(m, Interaction ~ gender + group) <- function(x){x[,1]*x[,2]}
d <- sim(m, 1e2)
d$gender <- factor(d$gender, labels = letters[1:2])
d$group <- factor(d$group)

e.gls <- gls(Y ~ X1 + gender*group, data = d,
             weights = varIdent(form = ~1|group))
publish(e.gls)

## lme
fm1 <- lme(distance ~ age*Sex, 
            random = ~1|Subject,
            data = Orthodont) 
res <- publish(fm1)
}
}
\author{
Thomas Alexander Gerds <tag@biostat.ku.dk>
}
