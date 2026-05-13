# Spatial Statistics and Epidemiological Modelling

> Applied spatial statistics project in R including geostatistical interpolation, spatial point pattern analysis and epidemiological spatial modelling.

This repository reproduces a realistic spatial data analysis workflow commonly used in environmental sciences, epidemiology, ecological modelling and geospatial analytics.

---

# Project Overview

The project is divided into three complementary spatial modelling frameworks:

1. Geostatistical interpolation and kriging
2. Spatial point pattern analysis
3. Epidemiological spatial regression

The analyses combine exploratory spatial analysis, statistical modelling, covariance structures, neighbour-based dependence and predictive spatial inference.

---

# Repository Structure

```text
spatial-statistics-modelling/
│
├── data/
│
├── outputs/
│   ├── figures/
│   └── tables/
│
├── scripts/
│   ├── geostatistics_kriging.R
│   ├── point_pattern_analysis.R
│   └── spatial_epidemiology.R
│
├── README.md
└── LICENSE
```
Phase 1 — Geostatistical Modelling and Kriging

The first stage focuses on spatial interpolation under non-stationary conditions using geostatistical methodologies.

Main Methods
Spatial trend surface modelling
Variogram estimation
Covariance model comparison
Matérn spatial covariance structures
Universal kriging
Spatial prediction intervals
Main Techniques
Empirical variograms
Robust variogram estimation
Maximum likelihood estimation
Weighted least squares
Universal kriging prediction

The analysis evaluates both deterministic large-scale spatial trend and residual spatial dependence.

Phase 2 — Spatial Point Pattern Analysis

The second stage analyses spatial point configurations under different spatial processes.

Main Methods
Complete Spatial Randomness (CSR) testing
Quadrat analysis
Clustering indices
Nearest-neighbour analysis
H, G and F spatial functions
Kernel intensity estimation

The objective is to distinguish between:

Random spatial processes
Clustered processes
Inhibitory spatial structures
Spatial heterogeneity
Phase 3 — Spatial Epidemiological Modelling

The final stage analyses spatial dependence in epidemiological count data across municipalities.

Main Methods
Spatial autocorrelation analysis
Moran’s I statistics
Neighbourhood structures
Spatial logistic regression
Spatial lag covariates
Residual spatial diagnostics

The workflow combines demographic covariates with neighbour-based spatial effects in order to evaluate geographically structured disease risk.

Technologies
R
sf
spdep
geoR
spatstat
ggplot2
dplyr
spatial statistics
geostatistics
Author

Adrián Gómez Conde

MSc Biostatistics Candidate

Spatial Statistics · Epidemiological Modelling · Applied Data Analysis
