# =========================================================
# SPATIAL POINT PATTERN ANALYSIS
# =========================================================

# =========================================================
# 1. LIBRARIES
# =========================================================

library(spatstat.geom)
library(spatstat.explore)
library(spatstat.random)
library(ggplot2)
library(dplyr)
library(gridExtra)

# =========================================================
# 2. OUTPUT DIRECTORIES
# =========================================================

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)
dir.create("outputs/tables", showWarnings = FALSE)

# =========================================================
# 3. LOAD DATA
# =========================================================

nests <- read.csv("data/point_patterns/nests.csv")
trees <- read.csv("data/point_patterns/trees.csv")
robberies <- read.csv("data/point_patterns/robberies.csv")
truffles <- read.csv("data/point_patterns/truffles.csv")

# =========================================================
# 4. CREATE POINT PATTERN OBJECTS
# =========================================================

window <- owin(c(0, 1), c(0, 1))

patterns <- list(
  nests = ppp(nests$x, nests$y, window = window),
  trees = ppp(trees$x, trees$y, window = window),
  robberies = ppp(robberies$x, robberies$y, window = window),
  truffles = ppp(truffles$x, truffles$y, window = window)
)

# =========================================================
# 5. OVERVIEW FIGURE
# =========================================================

png(
  "outputs/figures/point_patterns_overview.png",
  width = 1400,
  height = 1200,
  res = 150
)

par(mfrow = c(2,2))

for(name in names(patterns)){

  plot(
    patterns[[name]],
    main = paste(
      toupper(substr(name,1,1)),
      substr(name,2,nchar(name)),
      sep=""
    ),
    pch = 16,
    cols = "black"
  )

}

dev.off()

# =========================================================
# 6. SUMMARY STATISTICS
# =========================================================

summary_table <- data.frame(
  Pattern = names(patterns),
  Number_of_Points = sapply(patterns, npoints),
  Intensity = sapply(patterns, intensity),
  Mean_NN_Distance = sapply(patterns, function(x){
    mean(nndist(x))
  }),
  SD_NN_Distance = sapply(patterns, function(x){
    sd(nndist(x))
  })
)

write.csv(
  summary_table,
  "outputs/tables/point_pattern_summary.csv",
  row.names = FALSE
)

# =========================================================
# 7. CSR QUADRAT TESTS
# =========================================================

csr_results <- lapply(names(patterns), function(name){

  qt <- quadrat.test(patterns[[name]], nx = 4, ny = 4)

  data.frame(
    Pattern = name,
    Chi_Square = as.numeric(qt$statistic),
    P_Value = qt$p.value
  )

})

csr_results <- bind_rows(csr_results)

write.csv(
  csr_results,
  "outputs/tables/csr_quadrat_tests.csv",
  row.names = FALSE
)

# =========================================================
# 8. QUADRAT FIGURES
# =========================================================

png(
  "outputs/figures/quadrat_analysis.png",
  width = 1400,
  height = 1200,
  res = 150
)

par(mfrow = c(2,2))

for(name in names(patterns)){

  plot(
    quadratcount(patterns[[name]], nx=4, ny=4),
    main = paste(name, "- Quadrat Analysis")
  )

}

dev.off()

# =========================================================
# 9. CLUSTERING INDICES
# =========================================================

clustering_indices <- lapply(names(patterns), function(name){

  nn <- nndist(patterns[[name]])

  data.frame(
    Pattern = name,
    Mean_NN = mean(nn),
    Variance_NN = var(nn),
    Clark_Evans_R = clarkevans(patterns[[name"]])$R
  )

})

clustering_indices <- bind_rows(clustering_indices)

write.csv(
  clustering_indices,
  "outputs/tables/clustering_indices.csv",
  row.names = FALSE
)

# =========================================================
# 10. H FUNCTION ANALYSIS
# =========================================================

png(
  "outputs/figures/h_function_analysis.png",
  width = 1400,
  height = 1200,
  res = 150
)

par(mfrow = c(2,2))

for(name in names(patterns)){

  K <- Kest(patterns[[name]], correction = "border")
  L <- Lest(patterns[[name]], correction = "border")

  plot(
    L,
    main = paste(name, "- H/L Function")
  )

}

dev.off()

# =========================================================
# 11. G FUNCTION ANALYSIS
# =========================================================

png(
  "outputs/figures/g_function_analysis.png",
  width = 1400,
  height = 1200,
  res = 150
)

par(mfrow = c(2,2))

for(name in names(patterns)){

  G <- Gest(patterns[[name]])

  plot(
    G,
    main = paste(name, "- G Function")
  )

}

dev.off()

# =========================================================
# 12. F FUNCTION ANALYSIS
# =========================================================

png(
  "outputs/figures/f_function_analysis.png",
  width = 1400,
  height = 1200,
  res = 150
)

par(mfrow = c(2,2))

for(name in names(patterns)){

  F <- Fest(patterns[[name]])

  plot(
    F,
    main = paste(name, "- F Function")
  )

}

dev.off()

# =========================================================
# 13. KERNEL INTENSITY ESTIMATION
# =========================================================

png(
  "outputs/figures/kernel_intensity_maps.png",
  width = 1400,
  height = 1200,
  res = 150
)

par(mfrow = c(2,2))

for(name in names(patterns)){

  den <- density(patterns[[name]])

  plot(
    den,
    main = paste(name, "- Kernel Intensity")
  )

  contour(den, add = TRUE)

}

dev.off()

# =========================================================
# 14. INTERPRETATION SUMMARY
# =========================================================

cat("\n======================================\n")
cat("SPATIAL POINT PATTERN ANALYSIS\n")
cat("======================================\n")

cat("\nExpected Interpretation:\n")

cat("\nNests:")
cat("\n- Approximately CSR / weak inhomogeneity\n")

cat("\nTrees:")
cat("\n- Regular or inhibitory process\n")

cat("\nRobberies:")
cat("\n- Strong clustered process\n")

cat("\nTruffles:")
cat("\n- Inhomogeneous clustered process\n")
