## bdt
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The R package **bdt** implements adapted bootstrap diagnostic tool (BDT), originally described in Bahamyirou A, Blais L, Forget A, Schnitzer ME. *Understanding and diagnosing the potential for bias when using machine learning methods with doubly robust causal estimators*. Statistical Methods in Medical Research. 2019 Jun;28(6):1637-50. Data-adaptive methods can produce a separation of the two exposure groups in terms of propensity score densities which can lead to biased finite-sample estimates of the treatment effect. Bahamyirou et al. presented a diagnostic tool to identify the instability in the estimation of marginal causal effects in the presence of near practical positivity violations.  To expedite the application of this diagnostic tool, we develop **bdt** package which is based on a bootstrap resampling of the subjects and simulation of the outcome data conditional on observed treatment and covariates.  You can install the current version of with: 

```{r, eval=FALSE}
install.packages("devtools")
devtools::install_github("Yan2020729/bdt")
```
This repository hosts the (commented) source code. For more theoretical details, please refer to the original paper: https://doi.org/10.1177%2F0962280218772065.

### Parameter of interest and positivity assumption
In the context of causal inference, identifiability of causal effects requires some assumptions that allow investigators to write the parameter of interest in terms of the distribution of the observational studies. The common assumptions include stable unit treatment value assumption, consistency, ignorability and positivity. Consider an observational data with n i.i.d. observations on the data structure O = (W, A, Y), where W be the vector of baseline covariates of an individual; A be the observed binary treatment indicator with the value equals to 1 if the subject received the treatment and 0 otherwise; Y be the observed continuous or binary outcome. The parameter of interest is the additive effect conditioning on a set of potential confounders W. Positivity assumption requires that the probability of receiving any level of treatment conditioning on every set of covariates must be positivity for all subjects in the population, i.e. P(A=a|W)>0 for any a=0 or 1. 

### Estimation
In this package, to estimate the average treatment effect (ATE), we use the augmented inverse probability of treatment weighted estimator (A-IPTW) and Targeted Maximum Likelihood Estimators (TMLEs). Doubly robust estimators A-IPTW and TMLE decrease the dependence on the correct specification of the propensity model and only require either outcome model or propensity score model to be correctly specified. To increase the chance of correct model specification, 'SuperLearner' (SL), is often recommended. SL is a non-parametric methodology that uses cross validation to find an optimal convex combination of the predictions of a library of candidate algorithms defined by the user. However, under some settings the flexibility in the propensity modeling can yield hightly variable propensity scores which can lead to unstable parameter estimates and potential bias. Overall, in the presence of potential positivity violations, flexible modeling of the propensity score give rise to the increment of the bias and variance of the causal effect estimators as compared to parametric methods. In order to address this issue, one may define different bounds to truncate the probabilities then reduce their standard errors though choice of truncation level is usually ad-hoc.

## Bootstrap diagnostic tool

Bahamyirou et al. presented an adapted version of the diagnostic tool in simulation to illustrate whether the ATE estimators were destablized by the use of SL to fit the propensity score.The diagnostic tool which is based on a bootstrap resampling of the subjects, keeps the observed treatment of each resampled subject but simulates the outcome using the information of the two observed subgroups who are treated or not being treated. To expedite the application of this diagnostic tool, we develop **bdt** package to diagnose the instability introduced when flexible modeling method is employed for the estimation of the propensity score. 

Specifically, in **bdt** package, we start to fit generalized linear regressions of continuous or binary outcomes for two treatment groups of subjects with A=1 and A=0 separately to obtain the predictions. New artificial outcomes are simulated based on the models fit. We then bootstrap the original data with replacement but substitute the observed outcomes with the simulated outcomes and implement A-IPTW and TMLE algorithms using a correct (known) parametric outcome model to obtain the estimators. In the fitting process of treatment mechanism, we use either logistic generalized linear regressions or SL methods to estimate the probabilities. By repeating the bootstrap procedure multiple times, a number of simulated datasets are produced then we can compute the average of resulting estimates. Standard errors and computed based on the influenced functions. Therefor, based on the parametric bootstrap the **bdt** package can provide an optimistic bias estimate by excluding bias due to the model mis-sepcification for the outcome models. Because the outcome model is known and correct in terms of bootstrap data, we can expect that any large estimation errors are caused by the instability of the weights. 



