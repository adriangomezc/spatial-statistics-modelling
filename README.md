# Spatial Statistics and Epidemiological Modelling

> Applied spatial statistics project in R including geostatistical interpolation, spatial point pattern analysis and spatial epidemiological modelling.

This repository reproduces realistic spatial data science workflows commonly used in environmental sciences, epidemiology, ecological modelling and geospatial analytics.

The project combines:

* Geostatistical interpolation
* Spatial point process analysis
* Spatial autocorrelation modelling
* Spatial epidemiology
* Predictive spatial inference

---

# Project Overview

The repository is organised into three complementary spatial modelling frameworks:

1. Geostatistical modelling and universal kriging: Modeling elevation with non-stationary trends.
2. Spatial point pattern analysis: Testing CSR and interaction scales in biological and social patterns.
3. Spatial epidemiological modelling: Analyzing lead prevalence using spatial regression and neighbor structures.

---

# Repository Structure

```text
spatial-statistics-modelling/
│
├── data/
│   ├── elevation_spatial_data.csv
│   │
│   └── point_patterns/
│       ├── nests.csv
│       ├── trees.csv
│       ├── robberies.csv
│       └── truffles.csv
│
├── outputs/
│   ├── figures/
│   │   ├── spatial_locations.png
│   │   ├── trend_surfaces.png
│   │   ├── raw_variograms.png
│   │   ├── residual_variogram.png
│   │   ├── variogram_model_comparison.png
│   │   ├── universal_kriging_maps.png
│   │   │
│   │   ├── point_patterns_overview.png
│   │   ├── quadrat_analysis.png
│   │   ├── h_function_analysis.png
│   │   ├── g_function_analysis.png
│   │   ├── f_function_analysis.png
│   │   └── kernel_intensity_maps.png
│   │
│   │   ├── lead_prevalence_map.jpg
│   │   ├── neighbour_structure.png
│   │   ├── residual_distribution.png
│   │   └── spatial_residuals_map.jpg
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── variogram_model_parameters.csv
│       ├── point_prediction.csv
│       │
│       ├── point_pattern_summary.csv
│       ├── csr_quadrat_tests.csv
│       ├── clustering_indices.csv
│       │
│       ├── epidemiology_summary.csv
│       ├── logistic_model_results.csv
│       ├── moran_statistics.csv
│       └── model_comparison.csv
│
├── scripts/
│   ├── geostatistics_kriging.R
│   ├── point_pattern_analysis.R
│   └── spatial_epidemiology.R
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
* **Response variable:** terrain elevation (meters)

### Summary Statistics

| Metric | Value |
| --- | --- |
| Mean elevation | 1143.79 m |
| Minimum elevation | 885.11 m |
| Maximum elevation | 1462.68 m |
| Standard deviation | 142.55 m |

The spatial sampling design provides homogeneous spatial coverage without major unsampled gaps.

---

# Geostatistical Workflow

The analysis follows a classical geostatistical modelling pipeline:

1. Exploratory spatial analysis
2. Spatial trend surface modelling
3. Empirical variogram estimation
4. Covariance model fitting
5. Universal kriging interpolation
6. Spatial uncertainty quantification

---

## Spatial Trend Modelling

Polynomial trend surfaces of degree 1 and degree 2 were evaluated to assess deterministic spatial variation.

A strong spatial trend in elevation was detected, violating the constant mean assumption required for ordinary kriging.

This justified the use of:

* Universal kriging
* Residual covariance modelling after detrending

---

## Variogram Analysis

### Raw Variograms

Empirical variograms computed on the original elevation values displayed continuously increasing semivariance without stabilisation.

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

### Main Spatial Parameters

| Parameter | Approximate Range |
| --- | --- |
| Nugget effect | 566 – 1089 |
| Sill | 2000 – 2600 |

The nugget effect—representing nearly 40-50% of the total variance—suggests:

* Substantial local terrain variability and micro-scale heterogeneity
* A highly "noisy" spatial process where a large portion of the variance is not spatially structured at the sampled scale
* Potential measurement noise

---

## Universal Kriging

The final interpolation stage combined:

* Polynomial spatial trend
* Residual covariance structure
* Universal kriging prediction

### Main Outputs

#### Elevation Prediction Surface

A continuous terrain elevation map was reconstructed across the study region.

#### Kriging Variance Surface

Prediction uncertainty was quantified spatially.

As expected:

* Prediction uncertainty is lowest near sampled locations
* Uncertainty increases near borders and sparsely sampled regions

---

## Point Prediction

The final objective consisted of predicting elevation at:

* **Coordinates:** (3, 3)

### Universal Kriging Prediction

| Metric | Value |
| --- | --- |
| Predicted elevation | 1161.19 m |
| Standard error | 52.80 m |
| 95% confidence interval | [1057.70, 1264.69] |

The prediction standard error (52.80 m) is substantial relative to the total standard deviation of the series (142.55 m). This reflects the high nugget effect observed in the variogram, indicating that the final interpolation relies heavily on the deterministic polynomial trend surface rather than strong local spatial correlation.

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

Four spatial point patterns were analysed:

* Nests
* Trees
* Robberies
* Truffles

---

## Complete Spatial Randomness (CSR) Testing

CSR was evaluated using:

* Quadrat chi-square tests
* Clark–Evans nearest-neighbour index (evaluating multiple edge corrections such as Donnelly and Guard)

### Main Findings

| Pattern | Spatial Structure |
| --- | --- |
| Nests | Approximately random (CSR) |
| Trees | Inhibitory / regular |
| Robberies | Strong clustering |
| Truffles | Strong clustering |

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

An index greater than 1 indicates that trees are systematically more separated than expected under random placement, pointing towards biological competition for resources.

#### Robberies and Truffles

Both patterns strongly rejected CSR:

* Extremely small p-values
* Severe spatial clustering at short scales
* Presence of concentrated hotspots

---

## Nearest-Neighbour Analysis

The mean nearest-neighbour distance provided additional evidence regarding local spatial interaction.

### Main Finding

Trees displayed the largest nearest-neighbour distances:

* Mean NN distance ≈ **0.071**

This confirms the existence of inhibitory spatial interaction at a local scale.

Conversely:

* Robberies exhibited extremely short neighbour distances
* Strong local aggregation was observed, consistent with urban density and socio-economic hotspots.

---

## Spatial Interaction Functions

Three complementary functional statistics were analysed:

* G function
* F function
* H/L (Besag) function

### G Function

The trees pattern displayed a deficit of short distances relative to CSR expectations.

This confirms:

* Spatial inhibition at short radii
* Repulsion between neighbouring events driven by ecological constraints

### F Function

Robberies and truffles displayed rapid increases in the empty-space function.

This indicates:

* Large empty regions
* Concentrated spatial clusters
* Strong spatial heterogeneity driven by environmental or social variables

### H/L Function

The H/L function revealed strong positive deviations for robberies and truffles.

This confirms:

* Multi-scale clustering
* Significant departure from random spatial organisation, peaking at distinct interaction distances.

---

## Kernel Intensity Estimation

Kernel density estimation transformed discrete point events into continuous hotspot maps.

### Main Findings

#### Nests

* Relatively homogeneous intensity surface
* Weak spatial heterogeneity
* Near-random organisation

#### Trees

* Smooth and regular spatial intensity
* Absence of strong hotspots
* Inhibitory structure

#### Robberies

* Strong hotspot concentration
* Extreme spatial aggregation
* Large low-density surrounding areas

#### Truffles

* Multiple clustered density regions
* Spatial gradients in intensity
* Aggregated point structure

---

# Phase 3 — Spatial Epidemiological Modelling

The third stage analyses blood lead concentration in children across municipalities in Castellón province.

The objective is to evaluate the relationship between lead prevalence and demographic or socioeconomic covariates while assessing residual spatial dependence.

---

# Epidemiological Workflow

The analysis combines:

1. Exploratory prevalence analysis
2. Spatial visualisation of disease burden
3. Logistic regression modelling
4. Spatial neighbour structure construction
5. Moran’s I autocorrelation analysis
6. Spatial regression comparison
7. Residual spatial diagnostics

---

## Epidemiological Dataset

### Study Population

| Metric | Value |
| --- | --- |
| Municipalities | 135 |
| Total participants | 2001 |
| Positive cases | 1026 |
| Global prevalence | 51.27% |

The prevalence map revealed heterogeneous spatial distribution of elevated blood lead prevalence across municipalities.

---

## Logistic Regression Analysis

The epidemiological model evaluated the association between prevalence and several socioeconomic covariates:

* Income
* Ageing / demographic structure
* Unemployment

### Main Findings

Only demographic ageing (`edad`) showed statistical significance:

| Variable | Statistical Significance |
| --- | --- |
| Edad | p = 0.039 |
| Income | p = 0.42 |
| Unemployment | p = 0.32 |

The results suggest that demographic composition explains prevalence variation more strongly than economic indicators (which lacked statistical significance) in this dataset.

---

## Spatial Autocorrelation

Spatial neighbour structures were constructed to evaluate municipality-level dependence.

Autocorrelation was assessed using Moran’s I statistics.

### Main Results

| Variable | Moran Test p-value |
| --- | --- |
| Disease prevalence | 0.109 |
| Model residuals | 0.063 |

### Interpretation

The residual Moran's I test yielded a marginal p-value (0.063). While not strictly significant at the classical 5% level, this borderline result suggests a potential latent spatial structure that warrants further spatial modelling, rather than an absolute absence of spatial spillover effects.

---

## Spatial Model Comparison

A classical logistic regression model was compared against a spatially informed epidemiological model.

### Main Results

| Model | AIC |
| --- | --- |
| Classical logistic model | 704.21 |
| Spatial logistic model | 700.06 |

The spatial model also achieved lower deviance values.

### Interpretation

Despite the marginal Moran's I p-value, incorporating neighbourhood information actively improved the predictive and explanatory performance (lowering the AIC). This confirms the presence of subtle latent spatial structure not fully captured by standard demographic covariates.

---

## Residual Spatial Diagnostics

Residual analysis confirmed that the final spatial model achieved relatively balanced error behaviour.

### Main Findings

* Residual distributions showed no major systematic bias
* Spatial residual maps identified specific municipality clusters where local unexplained variation remained elevated
* These areas likely represent unmeasured local environmental or socioeconomic factors not included in the primary dataset

---

# Generated Outputs

## Figures

| Output | Description |
| --- | --- |
| `spatial_locations.png` | Spatial distribution of sampled elevation points |
| `trend_surfaces.png` | Polynomial spatial trend surfaces |
| `raw_variograms.png` | Variograms before detrending |
| `residual_variogram.png` | Residual stationary variogram |
| `variogram_model_comparison.png` | Covariance model comparison |
| `universal_kriging_maps.png` | Universal kriging prediction and uncertainty |
| `point_patterns_overview.png` | Visualisation of all point patterns |
| `quadrat_analysis.png` | Quadrat partition analysis |
| `h_function_analysis.png` | H/L spatial interaction functions |
| `g_function_analysis.png` | G nearest-neighbour functions |
| `f_function_analysis.png` | F empty-space functions |
| `kernel_intensity_maps.png` | Kernel hotspot intensity estimation |
| `lead_prevalence_map.jpg` | Municipal prevalence distribution |
| `neighbour_structure.png` | Spatial neighbour network |
| `residual_distribution.png` | Histogram of model residuals |
| `spatial_residuals_map.jpg` | Spatial distribution of residuals |

---

## Tables

| Output | Description |
| --- | --- |
| `summary_statistics.csv` | Elevation descriptive statistics |
| `variogram_model_parameters.csv` | Covariance model parameters |
| `point_prediction.csv` | Kriging point prediction |
| `point_pattern_summary.csv` | Point pattern descriptive statistics |
| `csr_quadrat_tests.csv` | CSR chi-square tests |
| `clustering_indices.csv` | Nearest-neighbour clustering metrics |
| `epidemiology_summary.csv` | Epidemiological descriptive statistics |
| `logistic_model_results.csv` | Logistic regression coefficients |
| `moran_statistics.csv` | Spatial autocorrelation statistics |
| `model_comparison.csv` | Spatial vs classical model comparison |

---

# Technologies

* R
* geoR
* spatstat
* sf
* spdep
* spatialreg
* ggplot2
* dplyr
* spatial statistics
* geostatistics
* kriging
* point process analysis
* spatial epidemiology
* spatial autocorrelation
* logistic regression

---

# Key Spatial Methodologies

The repository demonstrates applied implementations of:

* Universal kriging
* Variogram modelling
* Spatial covariance estimation
* Point process analysis
* Complete Spatial Randomness testing
* Kernel density estimation
* Moran’s I spatial autocorrelation
* Spatial logistic regression
* Neighbourhood graph modelling
* Residual spatial diagnostics

---

# Author

**Adrián Gómez Conde**

MSc Biostatistics Candidate

Spatial Statistics · Geostatistics · Spatial Epidemiology · Applied Data Analysis
