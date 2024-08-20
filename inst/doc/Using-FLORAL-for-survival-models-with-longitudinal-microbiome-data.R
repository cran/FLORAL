## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%"
)

## ----setup, warning=FALSE, message=FALSE--------------------------------------
library(FLORAL)
library(dplyr)
library(patchwork)
library(survival)
set.seed(8192024)

## ----simulation---------------------------------------------------------------

simdat <- simu(n=200, # sample size
               p=500, # number of features
               model="timedep",
               pct.sparsity = 0.8, # proportion of zeros
               rho=0, # feature-wise correlation
               longitudinal_stability = TRUE # choose to simulate longitudinal features with stable trajectories
)


## ----FLORAL, warning=FALSE, message=FALSE-------------------------------------

fit <- FLORAL(x=simdat$xcount,
              y=Surv(simdat$data_unique$t,simdat$data_unique$d),
              family="cox",
              longitudinal = TRUE,
              id = simdat$data$id,
              tobs = simdat$data$t0,
              progress=FALSE,
              plot=TRUE)

fit$selected
  

