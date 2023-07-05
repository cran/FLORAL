## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%"
)

## ----setup, warning=FALSE, message=FALSE--------------------------------------
library(FLORAL)
library(dplyr)
library(patchwork)

## ----getData------------------------------------------------------------------
load(system.file("extdata", "YachidaS_2019.Rdata", package="FLORAL"))

## ----floral-------------------------------------------------------------------

x <- x[y %in% c("CRC","healthy"),]
x <- x[,colSums(x >= 100) >= nrow(x)*0.2] # filter low abundance taxa

colnames(x) <- sapply(colnames(x), function(x) strsplit(x,split="[|]")[[1]][length(strsplit(x,split="[|]")[[1]])])

y <- as.numeric(as.factor(y[y %in% c("CRC","healthy")]))-1
fit <- FLORAL(x = x, y = y, family="binomial", ncv=10, progress=TRUE)

## ----plots,fig.height=4,fig.width=10,dpi=300----------------------------------
fit$pmse + fit$pcoef

## ----viewTaxa-----------------------------------------------------------------

head(fit$selected.feature$min)

head(sort(fit$best.beta$min))


## ----view2step----------------------------------------------------------------

head(fit$step2.ratios$`1se`)

fit$step2.ratios$`1se.idx`


## ----viewTable----------------------------------------------------------------

fit$step2.tables$`1se`


## ----mcv----------------------------------------------------------------------

mcv.fit <- mcv.FLORAL(mcv=2,
                      ncore=1,
                      x = x, 
                      y = y, 
                      family = "binomial", 
                      ncv = 3,
                      progress=TRUE)


## ----mcvplots,fig.height=6,fig.width=10,dpi=300-------------------------------

mcv.fit$p_min

#Other options are also available
#mcv.fit$p_min_ratio
#mcv.fit$p_1se
#mcv.fit$p_1se_ratio


## ----a.floral,out.width = '50%',fig.height=4,fig.width=4,dpi=300--------------

a.fit <- a.FLORAL(a = c(0.1,1),
                  ncore = 1,
                  x = x, 
                  y = y, 
                  family = "binomial", 
                  ncv = 3,
                  progress=TRUE)

a.fit


