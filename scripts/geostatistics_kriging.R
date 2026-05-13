# =========================================================
# GEOSTATISTICAL MODELLING AND UNIVERSAL KRIGING
# =========================================================

# =========================================================
# Libraries
# =========================================================

library(geoR)
library(spatial)
library(scatterplot3d)
library(ggplot2)
library(dplyr)

# =========================================================
# Load data
# =========================================================

load("data/datos_geostatistics.RData")

spatial_data <- data.frame(
  x = datos$x,
  y = datos$y,
  elevation = datos$JF27921
)

geo_data <- as.geodata(spatial_data)

# =========================================================
# Initial spatial exploration
# =========================================================

png("outputs/figures/spatial_locations.png",
    width = 1200,
    height = 600)

par(mfrow = c(1,2))

plot(
  spatial_data$x,
  spatial_data$y,
  type = "n",
  xlab = "X coordinate",
  ylab = "Y coordinate",
  main = "Spatial Locations"
)

text(
  spatial_data$x,
  spatial_data$y,
  round(spatial_data$elevation,1),
  cex = 0.7
)

scatterplot3d(
  spatial_data$x,
  spatial_data$y,
  spatial_data$elevation,
  pch = 16,
  color = "steelblue",
  xlab = "X",
  ylab = "Y",
  zlab = "Elevation",
  main = "3D Spatial Surface"
)

dev.off()

# =========================================================
# Trend surface modelling
# =========================================================

trend_linear <- surf.ls(
  1,
  spatial_data$x,
  spatial_data$y,
  spatial_data$elevation
)

trend_quadratic <- surf.ls(
  2,
  spatial_data$x,
  spatial_data$y,
  spatial_data$elevation
)

surface_linear <- trmat(trend_linear, 0, 6, 0, 6, 50)
surface_quadratic <- trmat(trend_quadratic, 0, 6, 0, 6, 50)

png("outputs/figures/spatial_trend_surface.png",
    width = 1200,
    height = 600)

par(mfrow = c(1,2))

persp(
  surface_linear,
  theta = 60,
  phi = 30,
  col = "lightblue",
  shade = 0.3,
  main = "Linear Trend Surface",
  xlab = "X",
  ylab = "Y",
  zlab = "Trend"
)

persp(
  surface_quadratic,
  theta = 60,
  phi = 30,
  col = "lightgreen",
  shade = 0.3,
  main = "Quadratic Trend Surface",
  xlab = "X",
  ylab = "Y",
  zlab = "Trend"
)

dev.off()

# =========================================================
# Residual spatial process
# =========================================================

spatial_residuals <- spatial_data$elevation -
  predict(
    trend_linear,
    spatial_data$x,
    spatial_data$y
  )

residual_geo <- geo_data
residual_geo$data <- spatial_residuals

# =========================================================
# Empirical variogram estimation
# =========================================================

emp_variogram <- variog(
  residual_geo,
  uvec = seq(0, 8, 0.5),
  messages = FALSE
)

robust_variogram <- variog(
  residual_geo,
  uvec = seq(0, 8, 0.5),
  estimator.type = "modulus",
  messages = FALSE
)

png("outputs/figures/empirical_variogram.png",
    width = 1200,
    height = 600)

par(mfrow = c(1,2))

plot(
  emp_variogram,
  pch = 16,
  main = "Empirical Variogram"
)

plot(
  robust_variogram,
  pch = 16,
  main = "Robust Variogram"
)

dev.off()

# =========================================================
# Variogram model fitting
# =========================================================

initial_values <- c(3000, 3)

model_exponential <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "exp",
  messages = FALSE
)

model_spherical <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "sph",
  messages = FALSE
)

model_matern <- likfit(
  residual_geo,
  ini = initial_values,
  cov.model = "mat",
  kappa = 1.5,
  messages = FALSE
)

png("outputs/figures/variogram_models.png",
    width = 1000,
    height = 700)

plot(
  emp_variogram,
  pch = 16,
  main = "Variogram Model Comparison"
)

lines(model_exponential,
      col = "red",
      lwd = 2)

lines(model_spherical,
      col = "blue",
      lwd = 2)

lines(model_matern,
      col = "darkgreen",
      lwd = 2)

legend(
  "bottomright",
  legend = c(
    "Exponential",
    "Spherical",
    "Matérn"
  ),
  col = c(
    "red",
    "blue",
    "darkgreen"
  ),
  lwd = 2
)

dev.off()

# =========================================================
# Save variogram parameters
# =========================================================

variogram_parameters <- data.frame(
  model = c(
    "Exponential",
    "Spherical",
    "Matern"
  ),
  sill = c(
    model_exponential$cov.pars[1],
    model_spherical$cov.pars[1],
    model_matern$cov.pars[1]
  ),
  range = c(
    model_exponential$cov.pars[2],
    model_spherical$cov.pars[2],
    model_matern$cov.pars[2]
  ),
  nugget = c(
    model_exponential$nugget,
    model_spherical$nugget,
    model_matern$nugget
  )
)

write.csv(
  variogram_parameters,
  "outputs/tables/variogram_parameters.csv",
  row.names = FALSE
)

# =========================================================
# Universal kriging prediction
# =========================================================

prediction_grid <- expand.grid(
  seq(0, 6, length = 40),
  seq(0, 6, length = 40)
)

evaluate_trend <- function(surface, locations){
  predict(surface, locations[,1], locations[,2])
}

kriging_model <- krige.conv(
  geo_data,
  locations = prediction_grid,
  krige = krige.control(
    trend.d = ~evaluate_trend(
      trend_linear,
      geo_data$coords
    ),
    trend.l = ~evaluate_trend(
      trend_linear,
      prediction_grid
    ),
    cov.pars = model_matern$cov.pars,
    nugget = model_matern$nugget
  )
)

png("outputs/figures/kriging_surface.png",
    width = 1200,
    height = 600)

par(mfrow = c(1,2))

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
  main = "Prediction Standard Error"
)

dev.off()

# =========================================================
# Point prediction
# =========================================================

target_location <- data.frame(
  x = 3,
  y = 3
)

point_prediction <- krige.conv(
  geo_data,
  locations = target_location,
  krige = krige.control(
    trend.d = ~evaluate_trend(
      trend_linear,
      geo_data$coords
    ),
    trend.l = ~evaluate_trend(
      trend_linear,
      target_location
    ),
    cov.pars = model_matern$cov.pars,
    nugget = model_matern$nugget
  )
)

prediction_results <- data.frame(
  x = 3,
  y = 3,
  prediction = point_prediction$predict,
  standard_error = sqrt(point_prediction$krige.var),
  lower_95 = point_prediction$predict -
    1.96 * sqrt(point_prediction$krige.var),
  upper_95 = point_prediction$predict +
    1.96 * sqrt(point_prediction$krige.var)
)

write.csv(
  prediction_results,
  "outputs/tables/kriging_predictions.csv",
  row.names = FALSE
)
