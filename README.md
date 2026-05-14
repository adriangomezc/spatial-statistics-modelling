# Spatial Statistics and Epidemiological Modelling

> Applied spatial statistics project in R including geostatistical interpolation, spatial point pattern analysis and epidemiological spatial modelling.

This repository reproduces realistic spatial data science workflows commonly used in environmental sciences, epidemiology, ecological modelling and geospatial analytics.

---

# Project Overview

The repository is organised into three complementary spatial modelling frameworks:

1. Geostatistical interpolation and kriging
2. Spatial point pattern analysis
3. Spatial epidemiological modelling

The analyses combine exploratory spatial analysis, covariance modelling, neighbour-based dependence structures and predictive spatial inference.

---

# Repository Structure

```text
spatial-statistics-modelling/
│
├── data/
│   └── elevation_spatial_data.csv
│
├── outputs/
│   ├── figures/
│   │   ├── spatial_locations.png
│   │   ├── trend_surfaces.png
│   │   ├── raw_variograms.png
│   │   ├── residual_variogram.png
│   │   ├── variogram_model_comparison.png
│   │   └── universal_kriging_maps.png
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── variogram_model_parameters.csv
│       └── point_prediction.csv
│
├── scripts/
│   ├── geostatistics_kriging.R
│   ├── point_pattern_analysis.R
│   └── spatial_epidemiology.R
│
├── README.md
└── LICENSE
```

---

# Phase 1 — Geostatistical Modelling and Universal Kriging

The first stage focuses on spatial interpolation under non-stationary conditions using geostatistical methodologies.

The objective is to model terrain elevation while accounting for large-scale spatial trends and residual spatial dependence.

---

## Dataset

* **Observations:** 100 spatial locations
* **Variables:** spatial coordinates (`x`, `y`) and elevation (`alt`)
* **Spatial domain:** continuous 2D terrain surface
* **Response variable:** elevation (meters)

### Summary Statistics

| Metric             | Value     |
| ------------------ | --------- |
| Mean elevation     | 1143.79 m |
| Minimum elevation  | 885.11 m  |
| Maximum elevation  | 1462.68 m |
| Standard deviation | 142.55 m  |

The spatial sampling design provides relatively homogeneous coverage of the study region without major unsampled gaps.

---

# Geostatistical Workflow

The analysis follows a standard geostatistical modelling pipeline:

1. Exploratory spatial analysis
2. Spatial trend modelling
3. Empirical variogram estimation
4. Variogram model fitting
5. Universal kriging interpolation
6. Spatial uncertainty quantification

---

## Main Methods

### Spatial Trend Surface Modelling

Polynomial trend surfaces of degree 1 and degree 2 were evaluated in order to assess large-scale deterministic spatial variation.

The analysis identified a strong spatial trend in elevation across the study region, violating the constant mean assumption required for ordinary kriging.

This justified the use of:

* **Universal Kriging**
* Residual spatial modelling after detrending

---

## Variogram Analysis

### Raw Variograms

Empirical variograms computed on the original elevation data displayed continuously increasing semivariance without stabilisation.

This behaviour confirmed:

* Non-stationarity in the mean
* Strong deterministic spatial trend

### Residual Variogram

After removing the polynomial trend surface, the residual variogram displayed the expected stationary behaviour:

* Initial nugget effect
* Increasing semivariance with distance
* Stabilisation around a sill

This confirmed the presence of structured residual spatial dependence suitable for covariance modelling.

---

## Covariance Model Comparison

Several theoretical covariance families were compared:

* Exponential
* Spherical
* Matérn
* Powered Exponential

The fitted models were estimated using likelihood-based methodologies and compared visually against the empirical residual variogram.

### Main Spatial Parameters

The fitted covariance structures revealed:

| Parameter     | Approximate Range |
| ------------- | ----------------- |
| Nugget effect | 566 – 1089        |
| Sill          | 2000 – 2600       |

The nugget effect indicates the presence of:

* Small-scale spatial variability
* Local terrain irregularities
* Potential measurement noise

---

## Universal Kriging

The final interpolation stage combined:

* Polynomial spatial trend
* Residual covariance structure
* Universal kriging prediction

Two major outputs were generated:

### Elevation Prediction Surface

A continuous terrain elevation map was reconstructed across the entire study region.

### Kriging Variance Surface

Prediction uncertainty was quantified spatially.

As expected:

* Prediction uncertainty is lowest near sampled locations
* Uncertainty increases near borders and sparsely sampled regions

---

## Point Prediction

The final objective consisted of predicting elevation at the unsampled spatial location:

* **Coordinates:** (3, 3)

### Universal Kriging Prediction

| Metric                  | Value              |
| ----------------------- | ------------------ |
| Predicted elevation     | 1161.19 m          |
| Standard error          | 52.80 m            |
| 95% confidence interval | [1057.70, 1264.69] |

The relatively moderate prediction uncertainty suggests stable interpolation performance around the central region of the study domain.

---

# Generated Outputs

## Figures

| Output                           | Description                                       |
| -------------------------------- | ------------------------------------------------- |
| `spatial_locations.png`          | Spatial distribution of sampled locations         |
| `trend_surfaces.png`             | Polynomial trend surface visualisation            |
| `raw_variograms.png`             | Empirical variograms before detrending            |
| `residual_variogram.png`         | Residual stationary variogram                     |
| `variogram_model_comparison.png` | Covariance model comparison                       |
| `universal_kriging_maps.png`     | Universal kriging prediction and uncertainty maps |

## Tables

| Output                           | Description                      |
| -------------------------------- | -------------------------------- |
| `summary_statistics.csv`         | Descriptive statistics           |
| `variogram_model_parameters.csv` | Fitted covariance parameters     |
| `point_prediction.csv`           | Final kriging prediction results |

---

# Phase 2 — Spatial Point Pattern Analysis

The second stage analyses spatial point configurations under different spatial processes.

Main methodologies include:

* Complete Spatial Randomness (CSR) testing
* Quadrat analysis
* Clustering indices
* Nearest-neighbour analysis
* H, G and F spatial functions
* Kernel intensity estimation

The objective is to distinguish between:

* Random spatial processes
* Clustered processes
* Inhibitory spatial structures
* Spatial heterogeneity

---

# Phase 3 — Spatial Epidemiological Modelling

The final stage analyses spatial dependence in epidemiological count data across municipalities.

Main methodologies include:

* Spatial autocorrelation analysis
* Moran’s I statistics
* Neighbourhood structures
* Spatial logistic regression
* Spatial lag covariates
* Residual spatial diagnostics

The workflow combines demographic covariates with neighbour-based spatial effects to evaluate geographically structured disease risk.

---

# Technologies

* R
* geoR
* sf
* spdep
* spatstat
* ggplot2
* dplyr
* spatial statistics
* geostatistics
* kriging
* spatial epidemiology

---

# Author

**Adrián Gómez Conde**

MSc Biostatistics Candidate

Spatial Statistics · Geostatistics · Epidemiological Modelling · Applied Data Analysis
