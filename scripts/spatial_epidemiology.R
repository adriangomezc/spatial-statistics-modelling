# =========================================================
# SPATIAL EPIDEMIOLOGY:
# Childhood Blood Lead Levels in Castellón (Spain)
# Adrián Gómez Conde
# =========================================================

rm(list = ls())

# =========================================================
# Libraries
# =========================================================

library(sf)
library(dplyr)
library(ggplot2)
library(spdep)
library(classInt)
library(broom)
library(patchwork)
library(RColorBrewer)

# =========================================================
# Create output folders
# =========================================================

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)
dir.create("outputs/tables", showWarnings = FALSE)

# =========================================================
# Load spatial dataset
# =========================================================

lead_data <- st_read(
  "data/castellon_lead_data.gpkg",
  quiet = TRUE
)

# =========================================================
# Define response variable
# =========================================================

# Replace with your actual variable if necessary
response_var <- "Pb_JF27921"

lead_data <- lead_data |>
  mutate(
    y = .data[[response_var]],
    n = npart,
    prevalence = y / n
  )

# =========================================================
# Summary statistics
# =========================================================

summary_table <- lead_data |>
  st_drop_geometry() |>
  summarise(
    municipalities = n(),
    total_participants = sum(n),
    total_cases = sum(y),
    overall_prevalence = sum(y) / sum(n),
    mean_income = mean(renta),
    mean_ageing = mean(edad),
    mean_unemployment = mean(paro)
  )

write.csv(
  summary_table,
  "outputs/tables/epidemiology_summary.csv",
  row.names = FALSE
)

# =========================================================
# Spatial prevalence map
# =========================================================

breaks_prev <- classIntervals(
  lead_data$prevalence,
  n = 5,
  style = "quantile"
)$brks

lead_data$prev_class <- cut(
  lead_data$prevalence,
  breaks = breaks_prev,
  include.lowest = TRUE
)

p_prev <- ggplot(lead_data) +
  geom_sf(aes(fill = prev_class),
          color = "grey40",
          linewidth = 0.1) +
  scale_fill_brewer(
    palette = "YlOrRd",
    name = "Pb prevalence"
  ) +
  labs(
    title = "Spatial Distribution of Childhood Blood Lead Prevalence"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/lead_prevalence_map.png",
  p_prev,
  width = 8,
  height = 6,
  dpi = 300
)

# =========================================================
# Spatial neighbour structure
# =========================================================

nb <- poly2nb(
  lead_data,
  queen = TRUE
)

lw <- nb2listw(
  nb,
  style = "W",
  zero.policy = TRUE
)

png(
  "outputs/figures/neighbour_structure.png",
  width = 1000,
  height = 800
)

plot(
  st_geometry(lead_data),
  border = "grey70",
  main = "Municipality Neighbour Structure"
)

plot(
  nb,
  st_coordinates(st_centroid(lead_data)),
  add = TRUE,
  col = "red"
)

dev.off()

# =========================================================
# Moran's I on prevalence
# =========================================================

moran_prev <- moran.test(
  lead_data$prevalence,
  lw,
  zero.policy = TRUE
)

# =========================================================
# Logistic regression model
# =========================================================

model_1 <- glm(
  cbind(y, n - y) ~ renta + edad + paro,
  family = binomial(link = "logit"),
  data = st_drop_geometry(lead_data)
)

results_m1 <- tidy(
  model_1,
  conf.int = TRUE,
  exponentiate = TRUE
)

# =========================================================
# Moran's I on residuals
# =========================================================

lead_data$residuals_m1 <- residuals(
  model_1,
  type = "pearson"
)

moran_residuals_m1 <- moran.test(
  lead_data$residuals_m1,
  lw,
  zero.policy = TRUE
)

# =========================================================
# Spatial lag covariate
# =========================================================

sum_neigh_y <- sapply(
  seq_along(nb),
  function(i) sum(lead_data$y[nb[[i]]], na.rm = TRUE)
)

sum_neigh_n <- sapply(
  seq_along(nb),
  function(i) sum(lead_data$n[nb[[i]]], na.rm = TRUE)
)

lead_data$lag_risk <- ifelse(
  sum_neigh_n > 0,
  sum_neigh_y / sum_neigh_n,
  NA_real_
)

lead_data$lag_risk[is.na(lead_data$lag_risk)] <-
  mean(lead_data$lag_risk, na.rm = TRUE)

# =========================================================
# Spatial logistic regression
# =========================================================

model_2 <- glm(
  cbind(y, n - y) ~
    renta + edad + paro + lag_risk,
  family = binomial(link = "logit"),
  data = st_drop_geometry(lead_data)
)

results_m2 <- tidy(
  model_2,
  conf.int = TRUE,
  exponentiate = TRUE
)

write.csv(
  results_m2,
  "outputs/tables/logistic_model_results.csv",
  row.names = FALSE
)

# =========================================================
# Model comparison
# =========================================================

comparison <- data.frame(
  model = c(
    "Baseline logistic model",
    "Spatial logistic model"
  ),
  AIC = c(
    AIC(model_1),
    AIC(model_2)
  ),
  BIC = c(
    BIC(model_1),
    BIC(model_2)
  ),
  deviance = c(
    deviance(model_1),
    deviance(model_2)
  )
)

write.csv(
  comparison,
  "outputs/tables/model_comparison.csv",
  row.names = FALSE
)

# =========================================================
# Moran statistics export
# =========================================================

moran_table <- data.frame(
  test = c(
    "Prevalence Moran's I",
    "Residual Moran's I"
  ),
  statistic = c(
    moran_prev$estimate[1],
    moran_residuals_m1$estimate[1]
  ),
  p_value = c(
    moran_prev$p.value,
    moran_residuals_m1$p.value
  )
)

write.csv(
  moran_table,
  "outputs/tables/moran_statistics.csv",
  row.names = FALSE
)

# =========================================================
# Residual map
# =========================================================

lead_data$residuals_m2 <- residuals(
  model_2,
  type = "pearson"
)

breaks_res <- classIntervals(
  lead_data$residuals_m2,
  n = 5,
  style = "quantile"
)$brks

lead_data$res_class <- cut(
  lead_data$residuals_m2,
  breaks = breaks_res,
  include.lowest = TRUE
)

p_res <- ggplot(lead_data) +
  geom_sf(
    aes(fill = res_class),
    color = "grey40",
    linewidth = 0.1
  ) +
  scale_fill_brewer(
    palette = "RdBu",
    direction = -1,
    name = "Residuals"
  ) +
  labs(
    title = "Spatial Distribution of Pearson Residuals"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/spatial_residuals_map.png",
  p_res,
  width = 8,
  height = 6,
  dpi = 300
)

# =========================================================
# Residual histogram
# =========================================================

p_hist <- ggplot(
  data.frame(residuals = lead_data$residuals_m2),
  aes(x = residuals)
) +
  geom_histogram(
    bins = 25,
    fill = "steelblue",
    color = "white"
  ) +
  labs(
    title = "Distribution of Pearson Residuals",
    x = "Residuals",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/residual_distribution.png",
  p_hist,
  width = 7,
  height = 5,
  dpi = 300
)

# =========================================================
# Console summary
# =========================================================

cat("\n====================================\n")
cat("SPATIAL EPIDEMIOLOGY ANALYSIS DONE\n")
cat("====================================\n\n")

cat("Generated tables:\n")
cat("- epidemiology_summary.csv\n")
cat("- moran_statistics.csv\n")
cat("- logistic_model_results.csv\n")
cat("- model_comparison.csv\n\n")

cat("Generated figures:\n")
cat("- lead_prevalence_map.png\n")
cat("- neighbour_structure.png\n")
cat("- spatial_residuals_map.png\n")
cat("- residual_distribution.png\n\n")
