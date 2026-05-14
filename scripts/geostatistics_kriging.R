# =========================================================
# Spatial Statistics Modelling
# Geostatistical Modelling and Universal Kriging
# Author: Adrián Gómez Conde
# =========================================================

# =========================================================
# Libraries
# =========================================================

library(tidyverse)
library(geoR)
library(spatial)
library(scatterplot3d)

# =========================================================
# Create Output Directories
# =========================================================

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE, recursive = TRUE)
dir.create("outputs/tables", showWarnings = FALSE, recursive = TRUE)

# =========================================================
# 1. Load Data
# =========================================================

elevation_data <- read.csv("data/elevation_spatial_data.csv")

geo_data <- as.geodata(
  elevation_data,
  coords.col = 2:3,
  data.col = 4
)

# =========================================================
# 2. Initial Spatial Exploration
# =========================================================

png(
  "outputs/figures/spatial_locations.png",
  width = 1200,
  height = 600,
  res = 140
)

par(mfrow = c(1, 2))

plot(
  elevation_data$x,
  elevation_data$y,
  type = "n",
  xlab = "X coordinate",
  ylab = "Y coordinate",
  main = "Spatial Locations"
)

text(
  elevation_data$x,
  elevation_data$y,
  round(elevation_data$alt, 1),
  cex = 0.6
)

scatterplot3d(
  elevation_data$x,
  elevation_data$y,
  elevation_data$alt,
  xlab = "X",
  ylab = "Y",
  zlab = "Elevation",
  main = "3D Elevation Surface",
  pch = 16,
  color = "steelblue"
)

dev.off()

# =========================================================
# 3. Exploratory Geostatistics
# =========================================================

png(
  "outputs/figures/raw_variograms.png",
  width = 1400,
  height = 1200,
  res = 140
)

par(mfrow = c(2, 2))

cloud_variogram <- variog(
  geo_data,
  option = "cloud",
  messages = FALSE
)

plot(
  cloud_variogram,
  pch = 20,
  main = "Variogram Cloud"
)

emp_variogram_raw <- variog(
  geo_data,
  uvec = seq(0, 8, 0.5),
  messages = FALSE
)

plot(
  emp_variogram_raw,
  pch = 20,
  main = "Empirical Variogram"
)

bin_variogram <- variog(
  geo_data,
  uvec = seq(0, 8, 1),
  bin.cloud = TRUE,
  messages = FALSE
)

plot(
  bin_variogram,
  bin.cloud = TRUE,
  main = "Binned Variogram"
)

robust_variogram <- variog(
  geo_data,
  uvec = seq(0, 8, 0.5),
  estimator.type = "modulus",
  messages = FALSE
)

plot(
  robust_variogram,
  pch = 20,
  main = "Robust Variogram"
)

dev.off()

# =========================================================
# 4. Trend Surface Modelling
# =========================================================

trend_linear <- surf.ls(
  1,
  elevation_data$x,
  elevation_data$y,
  elevation_data$alt
)

trend_quadratic <- surf.ls(
  2,
  elevation_data$x,
  elevation_data$y,
  elevation_data$alt
)

trend_surface_linear <- trmat(
  trend_linear,
  0, 6,
  0, 6,
  50
)

trend_surface_quadratic <- trmat(
  trend_quadratic,
  0, 6,
  0, 6,
  50
)

png(
  "outputs/figures/trend_surfaces.png",
  width = 1400,
  height = 700,
  res = 140
)

par(mfrow = c(1, 2))

persp(
  trend_surface_linear,
  theta = 60,
  phi = 30,
  col = "lightblue",
  shade = 0.25,
  xlab = "X",
  ylab = "Y",
  zlab = "Trend",
  main = "Linear Trend Surface"
)

persp(
  trend_surface_quadratic,
  theta = 60,
  phi = 30,
  col = "lightgreen",
  shade = 0.25,
  xlab = "X",
  ylab = "Y",
  zlab = "Trend",
  main = "Quadratic Trend Surface"
)

dev.off()

# =========================================================
# 5. Residual Spatial Process
# =========================================================

trend_values <- predict(
  trend_linear,
  elevation_data$x,
  elevation_data$y
)

spatial_residuals <- elevation_data$alt - trend_values

residual_data <- data.frame(
  x = elevation_data$x,
  y = elevation_data$y,
  residuals = spatial_residuals
)

residual_geo <- as.geodata(
  residual_data,
  coords.col = 1:2,
  data.col = 3
)

png(
  "outputs/figures/residual_variogram.png",
  width = 1200,
  height = 600,
  res = 140
)

par(mfrow = c(1, 2))

plot.geodata(residual_geo)
title(main = "Residual Spatial Process")

emp_variogram <- variog(
  residual_geo,
  uvec = seq(0, 8, 0.5),
  messages = FALSE
)

plot(
  emp_variogram,
  pch = 20,
  main = "Residual Empirical Variogram"
)

dev.off()

# =========================================================
# 6. Variogram Modelling
# =========================================================

initial_values <- c(3000, 3)

model_exp <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "exp",
  messages = FALSE
)

model_sph <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "sph",
  messages = FALSE
)

model_mat <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "mat",
  kappa = 1.5,
  messages = FALSE
)

model_pow <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "powered.exponential",
  kappa = 1.75,
  messages = FALSE
)

png(
  "outputs/figures/variogram_model_comparison.png",
  width = 1400,
  height = 700,
  res = 140
)

par(mfrow = c(1, 2))

plot(
  emp_variogram,
  main = "Variogram Model Families"
)

lines(model_exp, max.dist = 8, col = "magenta", lwd = 2)
lines(model_sph, max.dist = 8, col = "orange", lwd = 2)
lines(model_mat, max.dist = 8, col = "blue", lwd = 2)
lines(model_pow, max.dist = 8, col = "darkgreen", lwd = 2)

legend(
  "bottomright",
  legend = c(
    "Exponential",
    "Spherical",
    "Matérn",
    "Powered Exponential"
  ),
  col = c(
    "magenta",
    "orange",
    "blue",
    "darkgreen"
  ),
  lty = 1,
  lwd = 2,
  cex = 0.8
)

model_mat_rml <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "mat",
  kappa = 1.5,
  method = "RML",
  messages = FALSE
)

model_mat_ols <- variofit(
  emp_variogram,
  ini = initial_values,
  cov.model = "mat",
  kappa = 1.5,
  weights = "equal",
  messages = FALSE
)

model_mat_wls <- variofit(
  emp_variogram,
  ini = initial_values,
  cov.model = "mat",
  kappa = 1.5,
  weights = "npairs",
  messages = FALSE
)

plot(
  emp_variogram,
  main = "Variogram Estimation Methods"
)

lines(model_mat, max.dist = 8, lwd = 2, col = "blue")
lines(model_mat_rml, max.dist = 8, lwd = 2, col = "red", lty = 2)
lines(model_mat_ols, max.dist = 8, lwd = 2, col = "orange", lty = 3)
lines(model_mat_wls, max.dist = 8, lwd = 2, col = "darkgreen", lty = 4)

legend(
  "bottomright",
  legend = c(
    "ML",
    "RML",
    "OLS",
    "WLS"
  ),
  col = c(
    "blue",
    "red",
    "orange",
    "darkgreen"
  ),
  lty = 1:4,
  lwd = 2,
  cex = 0.8
)

dev.off()

# =========================================================
# 7. Universal Kriging
# =========================================================

prediction_grid <- expand.grid(
  seq(0, 6, length = 40),
  seq(0, 6, length = 40)
)

evaluate_trend <- function(surface, points) {
  predict(surface, points[, 1], points[, 2])
}

kriging_model <- krige.conv(
  geo_data,
  locations = prediction_grid,
  krige = krige.control(
    trend.d = ~ evaluate_trend(
      trend_linear,
      geo_data$coords
    ),
    trend.l = ~ evaluate_trend(
      trend_linear,
      prediction_grid
    ),
    cov.pars = model_mat$cov.pars,
    nugget = model_mat$nugget
  )
)

png(
  "outputs/figures/universal_kriging_maps.png",
  width = 1400,
  height = 1400,
  res = 140
)

par(mfrow = c(2, 2))

image(
  kriging_model,
  loc = prediction_grid,
  main = "Universal Kriging Prediction"
)

contour(
  kriging_model,
  loc = prediction_grid,
  add = TRUE
)

image(
  kriging_model,
  loc = prediction_grid,
  val = sqrt(kriging_model$krige.var),
  main = "Kriging Standard Error"
)

persp(
  kriging_model,
  loc = prediction_grid,
  main = "Prediction Surface",
  phi = 30,
  theta = 45,
  col = "lightgreen",
  shade = 0.5
)

persp(
  kriging_model,
  loc = prediction_grid,
  val = sqrt(kriging_model$krige.var),
  main = "Prediction Error Surface",
  phi = 30,
  theta = 45,
  col = "salmon",
  shade = 0.5
)

dev.off()

# =========================================================
# 8. Point Prediction
# =========================================================

target_point <- data.frame(
  x = 3,
  y = 3
)

kriging_point <- krige.conv(
  geo_data,
  locations = target_point,
  krige = krige.control(
    trend.d = ~ evaluate_trend(
      trend_linear,
      geo_data$coords
    ),
    trend.l = ~ evaluate_trend(
      trend_linear,
      target_point
    ),
    cov.pars = model_mat$cov.pars,
    nugget = model_mat$nugget
  )
)

prediction_value <- kriging_point$predict

standard_error <- sqrt(
  kriging_point$krige.var
)

ci_lower <- prediction_value - 1.96 * standard_error
ci_upper <- prediction_value + 1.96 * standard_error

prediction_results <- data.frame(
  x = 3,
  y = 3,
  predicted_elevation = prediction_value,
  standard_error = standard_error,
  ci_lower_95 = ci_lower,
  ci_upper_95 = ci_upper
)

write.csv(
  prediction_results,
  "outputs/tables/point_prediction.csv",
  row.names = FALSE
)

# =========================================================
# 9. Model Summary Tables
# =========================================================

variogram_models <- data.frame(
  model = c(
    "Exponential",
    "Spherical",
    "Matern",
    "Powered Exponential"
  ),
  nugget = c(
    model_exp$nugget,
    model_sph$nugget,
    model_mat$nugget,
    model_pow$nugget
  ),
  sill = c(
    model_exp$cov.pars[1],
    model_sph$cov.pars[1],
    model_mat$cov.pars[1],
    model_pow$cov.pars[1]
  ),
  range = c(
    model_exp$cov.pars[2],
    model_sph$cov.pars[2],
    model_mat$cov.pars[2],
    model_pow$cov.pars[2]
  )
)

write.csv(
  variogram_models,
  "outputs/tables/variogram_model_parameters.csv",
  row.names = FALSE
)

summary_statistics <- elevation_data %>%
  summarise(
    observations = n(),
    mean_elevation = mean(alt),
    sd_elevation = sd(alt),
    min_elevation = min(alt),
    max_elevation = max(alt)
  )

write.csv(
  summary_statistics,
  "outputs/tables/summary_statistics.csv",
  row.names = FALSE
)

cat("\n")
cat("========================================\n")
cat("Spatial modelling completed successfully\n")
cat("========================================\n")
cat("\n")
