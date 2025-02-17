## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(phyloseq)

## -----------------------------------------------------------------------------
#this file has duplicate rows, and has multiple rows per pool
samples <- read.csv("https://figshare.com/ndownloader/files/33076496") %>% distinct() %>% 
  select(-Pool, -Run, -ShotgunBatchID) %>% distinct()
samples <- samples[1:100,] # Using the first 100 samples only.
counts <- read.csv("https://figshare.com/ndownloader/files/26393788") 
counts <- counts %>%
  filter(SampleID %in% samples$SampleID)
taxonomy <- read.csv("https://figshare.com/ndownloader/files/26770997")

phy <- phyloseq(
  sample_data(samples %>% column_to_rownames("SampleID")),
  tax_table(taxonomy %>% select(ASV, Kingdom:Genus) %>% column_to_rownames("ASV") %>% as.matrix()),
  otu_table(counts  %>% pivot_wider(names_from = "SampleID", values_from = "Count", values_fill = 0) %>% column_to_rownames("ASV") %>% as.matrix(), taxa_are_rows = TRUE)
) %>%  subset_samples(DayRelativeToNearestHCT > -30 & DayRelativeToNearestHCT < 0) %>% 
  tax_glom("Genus")

## -----------------------------------------------------------------------------
dat <- FLORAL::phy_to_floral_data(phy, covariates=c("Consistency"), y = "DayRelativeToNearestHCT")

## -----------------------------------------------------------------------------
res <- FLORAL::FLORAL(y = dat$y, x = dat$xcount, ncov = dat$ncov, family = "gaussian", ncv=NULL, progress=FALSE)

