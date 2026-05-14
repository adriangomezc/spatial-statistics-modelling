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

```text id="7jlwmn"
spatial-statistics-modelling/
│
├── data/
│   ├── elevation_spatial_data.csv
│   │
│   └── point_patterns/
│       ├── nests.csv
│       ├── trees.csv
│       ├── robberies.csv
│       └── truffles.csv
│
├── outputs/
│   ├── figures/
│   │   ├── spatial_locations.png
│   │   ├── trend_surfaces.png
│   │   ├── raw_variograms.png
│   │   ├── residual_variogram.png
│   │   ├── variogram_model_comparison.png
│   │   ├── universal_kriging_maps.png
│   │   │
│   │   ├── point_patterns_overview.png
│   │   ├── quadrat_analysis.png
│   │   ├── h_function_analysis.png
│   │   ├── g_function_analysis.png
│   │   ├── f_function_analysis.png
│   │   └── kernel_intensity_maps.png
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── variogram_model_parameters.csv
│       ├── point_prediction.csv
│       │
│       ├── point_pattern_summary.csv
│       ├── csr_quadrat_tests.csv
│       └── clustering_indices.csv
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

## Spatial Trend Modelling

Polynomial trend surfaces of degree 1 and degree 2 were evaluated to assess deterministic large-scale spatial variation.

The analysis revealed a strong spatial trend in elevation across the study region, violating the constant mean assumption required for ordinary kriging.

This justified the use of:

* Universal Kriging
* Residual covariance modelling after detrending

---

## Variogram Analysis

### Raw Variograms

Empirical variograms computed on the original elevation data displayed continuously increasing semivariance without stabilisation.

This behaviour confirmed:

* Non-stationarity in the mean
* Strong deterministic spatial trend

### Residual Variogram

After removing the polynomial trend surface, the residual variogram exhibited stationary behaviour:

* Nugget effect near the origin
* Increasing semivariance with distance
* Stabilisation around the sill

This confirmed the existence of structured residual spatial dependence suitable for covariance modelling.

---

## Covariance Model Comparison

Several theoretical covariance structures were compared:

* Exponential
* Spherical
* Matérn
* Powered Exponential

The fitted covariance models revealed:

| Parameter     | Approximate Range |
| ------------- | ----------------- |
| Nugget effect | 566 – 1089        |
| Sill          | 2000 – 2600       |

The nugget effect suggests:

* Local terrain variability
* Small-scale spatial heterogeneity
* Potential measurement noise

---

## Universal Kriging

The final interpolation stage combined:

* Polynomial spatial trend
* Residual covariance structure
* Universal kriging prediction

Two major outputs were generated:

### Elevation Prediction Surface

A continuous terrain elevation map was reconstructed across the entire spatial domain.

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

The moderate prediction uncertainty suggests stable interpolation performance around the central region of the study domain.

---

# Phase 2 — Spatial Point Pattern Analysis

The second stage analyses spatial point configurations under different stochastic spatial processes.

The objective is to distinguish between:

* Complete spatial randomness
* Inhibitory spatial structures
* Clustered spatial processes
* Spatial heterogeneity and hotspot formation

---

# Point Pattern Workflow

The analysis combines:

1. Exploratory spatial visualisation
2. Quadrat-based CSR testing
3. Nearest-neighbour statistics
4. Spatial interaction functions
5. Kernel intensity estimation

Four different spatial point patterns were analysed:

* Nests
* Trees
* Robberies
* Truffles

---

## Complete Spatial Randomness (CSR) Testing

CSR was evaluated using:

* Quadrat chi-square tests
* Clark–Evans nearest-neighbour index

### Main Findings

| Pattern   | Spatial Structure          |
| --------- | -------------------------- |
| Nests     | Approximately random (CSR) |
| Trees     | Inhibitory / regular       |
| Robberies | Strong clustering          |
| Truffles  | Strong clustering          |

### Key Statistical Results

#### Nests

The nests pattern behaved almost exactly as a random spatial process:

* Quadrat test p-value: **0.91**
* Clark–Evans index: **~1.0**

This indicates compatibility with Complete Spatial Randomness.

#### Trees

The tree distribution exhibited strong spatial inhibition:

* Quadrat test p-value: **0.0006**
* Clark–Evans index: **~1.45**

An index greater than 1 indicates that trees are systematically more separated than expected under random placement, suggesting competitive spatial interaction.

#### Robberies and Truffles

Both patterns strongly rejected CSR:

* Extremely small p-values
* Severe spatial clustering
* Presence of concentrated hotspots and empty regions

---

## Nearest-Neighbour Analysis

The mean nearest-neighbour distance provided additional evidence regarding local spatial interaction.

### Main Finding

Trees displayed the largest nearest-neighbour distances:

* Mean NN distance ≈ **0.071**

This confirms the existence of spatial repulsion or inhibitory processes.

Conversely:

* Robberies exhibited extremely short neighbour distances
* Strong local aggregation was observed

---

## Spatial Interaction Functions

Three complementary functional statistics were analysed:

* G function
* F function
* H/L (Besag) function

### G Function — Nearest-Neighbour Interaction

The trees pattern displayed a clear deficit of short distances relative to CSR expectations.

This behaviour confirms:

* Spatial inhibition
* Repulsion between neighbouring events

### F Function — Empty Space Function

Robberies and truffles displayed rapid increases in the F function.

This indicates:

* Large empty regions
* Highly concentrated spatial clusters
* Strong spatial heterogeneity

### H/L Function — Global Clustering

The H/L function revealed strong positive deviations for robberies and truffles.

This confirms:

* Multi-scale clustering
* Significant departure from random spatial organisation

The peaks of the curves identify the approximate spatial scale at which clustering intensity becomes maximal.

---

## Kernel Intensity Estimation

Kernel density estimation transformed discrete point events into continuous hotspot maps.

### Main Findings

#### Nests

* Relatively homogeneous intensity surface
* Weak spatial heterogeneity
* Near-random spatial organisation

#### Trees

* Smooth and uniform intensity surface
* Absence of strong hotspots
* Spatial regularity

#### Robberies

* Extreme hotspot concentration
* Strong spatial aggregation
* Large low-density regions surrounding focal clusters

#### Truffles

* Aggregated structure with spatial gradients
* Multiple density concentrations
* Combination of clustering and inhomogeneity

---

# Generated Outputs

## Figures

| Output                           | Description                                      |
| -------------------------------- | ------------------------------------------------ |
| `spatial_locations.png`          | Spatial distribution of sampled elevation points |
| `trend_surfaces.png`             | Polynomial spatial trend surfaces                |
| `raw_variograms.png`             | Variograms before detrending                     |
| `residual_variogram.png`         | Residual stationary variogram                    |
| `variogram_model_comparison.png` | Covariance model comparison                      |
| `universal_kriging_maps.png`     | Universal kriging prediction and uncertainty     |
| `point_patterns_overview.png`    | Visualisation of all point patterns              |
| `quadrat_analysis.png`           | Quadrat partition analysis                       |
| `h_function_analysis.png`        | H/L spatial interaction functions                |
| `g_function_analysis.png`        | G nearest-neighbour functions                    |
| `f_function_analysis.png`        | F empty-space functions                          |
| `kernel_intensity_maps.png`      | Kernel hotspot intensity estimation              |

## Tables

| Output                           | Description                          |
| -------------------------------- | ------------------------------------ |
| `summary_statistics.csv`         | Elevation descriptive statistics     |
| `variogram_model_parameters.csv` | Covariance model parameters          |
| `point_prediction.csv`           | Kriging point prediction             |
| `point_pattern_summary.csv`      | Point pattern descriptive statistics |
| `csr_quadrat_tests.csv`          | CSR chi-square tests                 |
| `clustering_indices.csv`         | Nearest-neighbour clustering metrics |

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
* spatstat
* sf
* spdep
* ggplot2
* dplyr
* spatial statistics
* geostatistics
* kriging
* spatial epidemiology
* point process analysis

---

# Author

**Adrián Gómez Conde**

MSc Biostatistics Candidate

Spatial Statistics · Geostatistics · Spatial Epidemiology · Applied Data Analysis
