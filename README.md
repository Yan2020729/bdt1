### bdt
The R package **bdt** implements adapted bootstrap diagnostic tool (BDT), originally described in Bahamyirou A, Blais L, Forget A, Schnitzer ME. *Understanding and diagnosing the potential for bias when using machine learning methods with doubly robust causal estimators*. Statistical Methods in Medical Research. 2019 Jun;28(6):1637-50. Data-adaptive methods can produce a separation of the two exposure groups in terms of propensity score densities which can lead to biased finite-sample estimates of the treatment effect. Bahamyirou et al. presented a diagnostic tool to identify the instability in the estimation of marginal causal effects in the presence of near practical positivity violations.  To expedite the application of this diagnostic tool, we develop **bdt** package which is based on a bootstrap resampling of the subjects and simulation of the outcome data conditional on observed treatment and covariates.  You can install the current version of with: 

```{r, eval=FALSE}
install.packages("devtools")
devtools::install_github("Yan2020729/bdt")
```
This repository hosts the (commented) source code. For more theoretical details, please refer to the original paper: https://doi.org/10.1177%2F0962280218772065.

### Parameter of interest and positivity assumption
In the context of causal inference, identifiability of causal effects requires some untestable assumptions that allow investigators to write the parameter of interest in terms of the distribution of the observational studies. The common assumptions include stable unit treatment value assumption, consistency, ignorability and positivity. Consider an observational data with n i.i.d. observations on the data structure O = (W, A, Y), where W be the vector of baseline covariates of an individual; A be the observed binary treatment indicator with the value equals to 1 if the subject received the treatment and 0 otherwise; Y be the observed continuous or binary outcome. The parameter of interest is the additive effect conditioning on a set of potential confounders W. Positivity assumption requires that the probability of receiving any level of treatment conditioning on every set of covariates must be positivity for all subjects in the population, i.e. P(A=a|W)>0 for any a=0 or 1. 

### Estimation
In this package, to estimate the average treatment effect (ATE), we use the inverse probability of treatment weighting (IPTW), augmented inverse probability of treatment weighted estimator (A-IPTW) and Targeted Maximum Likelihood Estimators (TMLEs). To estimate the unbiased or consistent estimator, the correct specification of treatment assignment model is required for IPTW. Doubly robust estimators A-IPTW and TMLE decrease the dependence on the correct specification of the propensity model and only require either outcome model or propensity score model to be correctly specified. 

In practice, researchers are typically unaware of the true specification of the propensity score model. To increase the chance of correct model specification, flexible prediction methods, in particular the ensemble learner called 'SuperLearner' (SL), are often recommended. SL is a nonparametric methodology that uses cross validation to find an optimal convex combination of the predictions of a library of candidate algorithms defined by the user. However, the flexibility in the propensity modeling can lead to the selection of strong predictors of the treatment which would give rise to extreme value of propensity score. Both A-IPTW and TMLE involve the inverse of propensity scores and practical positivity violations can lead to unstable parameter estimates and potential bias due to highly variable weights. Therefore, **bdt** package is to identify the instability in the estimation of marginal causal effects in the presence of near practical positivity violations in the finite sample. 


### Stages
- Stage 1: Propensity scores estimation. For a given observed dataset (Y, A, W) with n i.i.d. observations where the outcome Y could be a continuous or a binary variable, the treatment A is a binary variable and W is a vector, matrix or dataframe containging baseline covariates, the propensity scores are estimated by logistic regression and/or SL methods. User could define two choices of regression formula and two vectors of SL algorithms. Results could be presented by `summary()` and `plot()`.
- Stage 2: Fitting outcome models. For the two treatment subgroups of subjects with A=1 and A=0, fit a linear regression of the outcome Y on baseline covariates W respectively where the model only contains main terms of W. We denote the estimated coefficients and their corresponding variance.
- Stage 3: Computing the "true" effect for the bootstrap data generating distribution. It is obtained by computing the difference of the two potential outcomes for all subjects using the estimated coefficients from 2nd step.
- Stage 4: Simulation of the bootstrap datasets. Sample the n subjects with replacement then replace their observed outcomes with new outcome values which are estimated based on the coefficients obtained in the 2nd step. 
- Stage 5: Estimation of target parameters. For the resampled data with simulated outcomes, three candidate estimators TMLE, A-IPTW and IPTW are applied to estimate the targeted parameter using the "true" specification of the outcome model (same with the linear regression model in step 2) and the propensity score is modeled by logistic regression and/or SL. User could define specific bounds for the values of propensity scores where the default value is 0.025. 
- Stage 6: Bias and coverage rates estimation. Repeat steps (3) and (5) M times. Then bias could be calculated by comparing the mean of the estimates across M bootstrap samples with the true value of the target parameter under the bootstrap data generating distribution. Command `bias()` can show the estimated bias. In addition, the coverage rates of three estimators are computed based on the 95% confidence intervals over M bootstrap data sets. Results could be also presented by `summary()` or `plot()`. Furthermore, the command `summary()` contains the summary of pooled propensity scores of all bootstrap samples. 



