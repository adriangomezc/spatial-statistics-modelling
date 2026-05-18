[![es](https://img.shields.io/badge/lang-es-yellow.svg)](README.md)
# Estadística Espacial y Modelización Epidemiológica

> Proyecto de estadística espacial aplicada en R que incluye interpolación geoestadística, análisis de patrones de puntos espaciales y modelización epidemiológica espacial.

Este repositorio reproduce flujos de trabajo reales de ciencia de datos espaciales utilizados habitualmente en ciencias ambientales, epidemiología, modelización ecológica y analítica geoespacial.

El proyecto combina:

* Interpolación geoestadística
* Análisis de procesos de puntos espaciales
* Modelización de la autocorrelación espacial
* Epidemiología espacial
* Inferencia espacial predictiva

---

# Visión general

El repositorio está organizado en tres marcos de modelización espacial complementarios:

1. **Modelización geoestadística y kriging universal:** Modelado de la elevación con tendencias no estacionarias.
2. **Análisis de patrones de puntos espaciales:** Evaluación de la CSR (Aleatoriedad Espacial Completa) y escalas de interacción en patrones biológicos y sociales.
3. **Modelización epidemiológica espacial:** Análisis de la prevalencia de plomo mediante regresión espacial y estructuras de vecindad.

---

# Estructura del Repositorio

```text
spatial-statistics-modelling/
│
├── data/
│   ├── elevation_spatial_data.csv
│   │
│   └── point_patterns/
│       ├── nests.csv
│       ├── trees.csv
│       ├── robberies.csv
│       └── truffles.csv
│
├── outputs/
│   ├── figures/
│   │   ├── spatial_locations.png
│   │   ├── trend_surfaces.png
│   │   ├── raw_variograms.png
│   │   ├── residual_variogram.png
│   │   ├── variogram_model_comparison.png
│   │   ├── universal_kriging_maps.png
│   │   │
│   │   ├── point_patterns_overview.png
│   │   ├── quadrat_analysis.png
│   │   ├── h_function_analysis.png
│   │   ├── g_function_analysis.png
│   │   ├── f_function_analysis.png
│   │   └── kernel_intensity_maps.png
│   │
│   │   ├── lead_prevalence_map.jpg
│   │   ├── neighbour_structure.png
│   │   ├── residual_distribution.png
│   │   └── spatial_residuals_map.jpg
│   │
│   └── tables/
│       ├── summary_statistics.csv
│       ├── variogram_model_parameters.csv
│       ├── point_prediction.csv
│       │
│       ├── point_pattern_summary.csv
│       ├── csr_quadrat_tests.csv
│       ├── clustering_indices.csv
│       │
│       ├── epidemiology_summary.csv
│       ├── logistic_model_results.csv
│       ├── moran_statistics.csv
│       └── model_comparison.csv
│
├── scripts/
│   ├── geostatistics_kriging.R
│   ├── point_pattern_analysis.R
│   └── spatial_epidemiology.R
│
├── README.md
└── LICENSE

```

---

# Fase 1 — Modelización geoestadística y Kriging Universal

La primera etapa se centra en la interpolación espacial bajo condiciones de no estacionariedad utilizando metodologías geoestadísticas.

El objetivo es modelar la elevación del terreno teniendo en cuenta las tendencias espaciales a gran escala y la dependencia espacial residual.

---

## Conjunto de datos

* **Observaciones:** 100 ubicaciones espaciales
* **Variables:** coordenadas espaciales (`x`, `y`) y elevación (`alt`)
* **Variable de respuesta:** elevación del terreno (metros)

### Estadísticos

| Métrica | Valor |
| --- | --- |
| Elevación media | 1143,79 m |
| Elevación mínima | 885,11 m |
| Elevación máxima | 1462,68 m |
| Desviación estándar | 142,55 m |

El diseño del muestreo espacial proporciona una cobertura homogénea en el territorio, sin grandes vacíos sin muestrear.

---

# Flujo de trabajo

El análisis sigue una metodología clásica de modelización geoestadística:

1. Análisis espacial exploratorio
2. Modelado de la superficie de tendencia espacial
3. Estimación del variograma empírico
4. Ajuste del modelo de covarianza
5. Interpolación por kriging universal
6. Cuantificación de la incertidumbre espacial

---

## Modelado de la tendencia espacial

Se evaluaron superficies de tendencia polinómica de primer y segundo grado para analizar la variación espacial determinista.

Se detectó una fuerte tendencia espacial en la elevación, lo que infringe el supuesto de media constante requerido para el kriging ordinario. Aunque se acabó utilizando una superficie de segundo grado, se debe tener precaución, ya que los polinomios de grados superiores pueden forzar artificialmente la curvatura y provocar una sobre-extrapolación cerca de los límites del área de estudio.

Esto justificó el uso de:

* Kriging universal
* Modelización de la covarianza residual tras eliminar la tendencia (*detrending*)

---

## Análisis del variograma

### Variogramas brutos

Los variogramas empíricos calculados sobre los valores originales de elevación mostraron una semivarianza continuamente creciente sin estabilización.

Este comportamiento confirmó:

* La presencia de no estacionariedad en la media
* Una fuerte tendencia espacial determinista

### Variograma residual

Tras eliminar la superficie de tendencia polinómica, el variograma residual mostró un comportamiento estacionario:

* Efecto pepita (*nugget*) cerca del origen
* Semivarianza creciente con la distancia
* Estabilización alrededor de la meseta (*sill*)

Esto confirmó la existencia de una dependencia espacial residual estructurada, idónea para la modelización de la covarianza.

---

## Comparación de modelos de covarianza

Se compararon varias estructuras teóricas de covarianza:

* Exponencial
* Esférica
* Matérn
* Exponencial potencial (*Powered Exponential*)

### Principales parámetros espaciales

| Parámetro | Rango Aproximado |
| --- | --- |
| Efecto pepita (*Nugget*) | 566 – 1089 |
| Meseta (*Sill*) | 2000 – 2600 |

El efecto pepita —que representa casi el 40-50% de la varianza total— sugiere:

* Una variabilidad local sustancial del terreno y heterogeneidad a microescala
* Un proceso espacial con mucho "ruido", donde una gran parte de la varianza no está estructurada espacialmente a la escala muestreada
* Posible ruido de medición

---

## Kriging universal

La etapa de interpolación final combinó:

* La tendencia espacial polinómica
* La estructura de covarianza residual
* La predicción por kriging universal

### Principales resultados

#### Superficie de predicción de la elevación

Se reconstruyó un mapa continuo de la elevación del terreno para toda la región de estudio.

#### Superficie de varianza del kriging

La incertidumbre de la predicción se cuantificó espacialmente.

Como era de esperar:

* La incertidumbre de predicción es mínima cerca de las ubicaciones muestreadas
* La incertidumbre aumenta cerca de los límites del mapa y en las regiones con muestreo disperso

---

## Predicción puntual

El objetivo final consistió en predecir la elevación en:

* **Coordenadas:** (3, 3)

### Predicción por Kriging Universal

| Métrica | Valor |
| --- | --- |
| Elevación predicha | 1161,19 m |
| Error estándar | 52,80 m |
| Intervalo de confianza del 95% | [1057,70, 1264,69] |

El error estándar de la predicción (52,80 m) es considerable en relación con la desviación estándar total de la serie (142,55 m). Esto refleja el alto efecto pepita observado en el variograma, lo que indica que la interpolación final depende en gran medida de la superficie de tendencia polinómica determinista más que de una fuerte correlación espacial local.

---

# Fase 2 — Análisis de patrones de puntos espaciales

La segunda etapa analiza las configuraciones de puntos espaciales bajo diferentes procesos espaciales estocásticos.

El objetivo es distinguir entre:

* Aleatoriedad espacial completa (*Complete Spatial Randomness*, CSR)
* Estructuras espaciales de inhibición
* Procesos espaciales agregados (en clústeres)
* Heterogeneidad espacial y formación de puntos calientes (*hotspots*)

---

# Flujo de trabajo

El análisis combina:

1. Visualización espacial exploratoria
2. Evaluación de la CSR basada en cuadrantes
3. Estadísticos del vecino más próximo
4. Funciones de interacción espacial
5. Estimación de la intensidad por kernel

Se analizaron cuatro patrones de puntos espaciales:

* Nidos (*Nests*)
* Árboles (*Trees*)
* Robos (*Robberies*)
* Trufas (*Truffles*)

---

## Evaluación de la Aleatoriedad Espacial Completa (CSR)

La CSR se evaluó mediante:

* Pruebas de chi-cuadrado por cuadrantes
* Índice de Clark-Evans del vecino más próximo (evaluando múltiples correcciones de borde como Donnelly y Guard)

### Principales hallazgos

| Patrón | Estructura Espacial |
| --- | --- |
| Nidos | Aproximadamente aleatorio (CSR) |
| Árboles | De inhibición / regular |
| Robos | Fuertemente agregado |
| Trufas | Fuertemente agregado |

### Resultados clave

#### Nidos

El patrón de los nidos se comportó casi exactamente como un proceso espacial aleatorio:

* Valor p de la prueba de cuadrantes: **0,91**
* Índice de Clark-Evans: **~1,0**

Esto indica compatibilidad con la Aleatoriedad Espacial Completa.

#### Árboles

La distribución de los árboles mostró una fuerte inhibición espacial:

* Valor p de la prueba de cuadrantes: **0,0006**
* Índice de Clark-Evans: **~1,45**

Un índice superior a 1 indica que los árboles están sistemáticamente más separados de lo esperado bajo una distribución aleatoria, lo que apunta a una competencia biológica por los recursos.

#### Robos y Trufas

Ambos patrones rechazaron contundentemente la CSR:

* Valores p extremadamente pequeños
* Fuerte agregación espacial a escalas cortas
* Presencia de puntos calientes (*hotspots*) concentrados

---

## Análisis del Vecino más Próximo

La distancia media al vecino más próximo aportó evidencia adicional sobre la interacción espacial local.

### Principal hallazgo

Los árboles presentaron las distancias más largas al vecino más próximo:

* Distancia media al vecino más próximo ≈ **0,071**

Esto confirma la existencia de una interacción espacial de inhibición a escala local.

Por el contrario:

* Los robos mostraron distancias extremadamente cortas entre vecinos
* Se observó una fuerte agregación local, coherente con la densidad urbana y los puntos calientes socioeconómicos.

---

## Funciones de interacción espacial

Se analizaron tres estadísticos funcionales complementarios:

* Función G
* Función F
* Función H/L (Besag)

### Función G

El patrón de los árboles mostró un déficit de distancias cortas en comparación con lo esperado bajo CSR.

Esto confirma:

* Inhibición espacial a radios cortos
* Repulsión entre eventos vecinos motivada por restricciones ecológicas

### Función F

Los robos y las trufas mostraron incrementos rápidos en la función de espacio vacío.

Esto indica:

* Grandes regiones vacías
* Clústeres espaciales concentrados
* Una fuerte heterogeneidad espacial condicionada por variables ambientales o sociales

### Función H/L

La función H/L reveló fuertes desviaciones positivas para los robos y las trufas.

Esto confirma:

* Agregación multiescala
* Una desviación significativa de la organización espacial aleatoria, alcanzando su punto máximo en distancias de interacción específicas.

---

## Estimación de la intensidad por Kernel

La estimación de densidad por kernel transformó los eventos de puntos discretos en mapas continuos de puntos calientes (*hotspots*).

### Principales hallazgos

#### Nidos

* Superficie de intensidad relativamente homogénea
* Heterogeneidad espacial débil
* Organización cuasi aleatoria

#### Árboles

* Intensidad espacial suave y regular
* Ausencia de puntos calientes marcados
* Estructura de inhibición

#### Robos

* Fuerte concentración de puntos calientes
* Agregación espacial extrema
* Extensas áreas circundantes de baja densidad

#### Trufas

* Múltiples regiones de densidad agregada
* Gradientes espaciales en la intensidad
* Estructura de puntos agregada

---

# Fase 3 — Modelización epidemiológica espacial

La tercera etapa analiza la concentración de plomo en sangre en niños de varios municipios de la provincia de Castellón.

El objetivo es evaluar la relación entre la prevalencia de plomo y covariables demográficas o socioeconómicas, analizando al mismo tiempo la dependencia espacial residual.

---

# Flujo de trabajo

El análisis combina:

1. Análisis exploratorio de la prevalencia
2. Visualización espacial de la carga de la enfermedad
3. Modelado mediante regresión logística
4. Construcción de estructuras de vecindad espacial
5. Análisis de autocorrelación con la I de Moran
6. Comparación de modelos de regresión espacial
7. Diagnóstico espacial de residuos

---

## Conjunto de datos

### Población de Estudio

| Métrica | Valor |
| --- | --- |
| Municipios | 135 |
| Participantes totales | 2001 |
| Casos positivos | 1026 |
| Prevalencia global | 51,27% |

El mapa de prevalencia reveló una distribución espacial heterogénea de la alta prevalencia de plomo en sangre entre los distintos municipios.

---

## Análisis de Regresión Logística

El modelo epidemiológico evaluó la asociación entre la prevalencia y varias covariables socioeconómicas:

* Ingresos (*Income*)
* Envejecimiento / estructura demográfica (*Edad*)
* Desempleo (*Unemployment*)

### Principales hallazgos

Solo el envejecimiento demográfico (`edad`) mostró significación estadística:

| Variable | Significación Estadística |
| --- | --- |
| Edad | p = 0,039 |
| Ingresos | p = 0,42 |
| Desempleo | p = 0,32 |

Los resultados sugieren que la composición demográfica explica la variación de la prevalencia con mayor fuerza que los indicadores económicos. La falta de significación estadística en las variables económicas también podría estar influenciada por una multicolinealidad subyacente o factores locales no medidos.

---

## Autocorrelación espacial

Se construyeron estructuras de vecindad espacial para evaluar la dependencia a nivel municipal. La autocorrelación se analizó mediante el estadístico I de Moran.

### Principales resultados

| Variable | Valor p de la prueba de Moran |
| --- | --- |
| Prevalencia de la enfermedad | 0,109 |
| Residuos del modelo | 0,063 |

### Interpretación

La prueba de la I de Moran para los residuos arrojó un valor p marginal (0,063). Aunque no es estrictamente significativo al nivel clásico del 5%, este resultado limítrofe sugiere una estructura espacial latente potencial que justifica un modelado espacial más profundo, en lugar de una ausencia absoluta de efectos de desborde (*spillover*) espacial. *(Nota: Esta sensibilidad depende en gran medida de la matriz de contigüidad/pesos elegida, la cual puede tratar de manera diferente a los municipios grandes del interior y a los pequeños de la costa).*

---

## Comparación de modelos espaciales

Se comparó un modelo de regresión logística clásico con un modelo epidemiológico que incorpora información espacial.

### Principales resultados

| Modelo | AIC |
| --- | --- |
| Modelo logístico clásico | 704,21 |
| Modelo logístico espacial | 700,06 |

El modelo espacial también logró valores de devianza más bajos.

### Interpretación

A pesar del valor p marginal de la I de Moran, la incorporación de información de vecindad mejoró de forma activa el rendimiento predictivo y explicativo (reduciendo el AIC). Esto confirma la presencia de una sutil estructura espacial latente que las covariables demográficas estándar no logran capturar por completo.

---

## Diagnósticos espaciales de residuos

El análisis de residuos confirmó que el modelo espacial final logró un comportamiento de errores relativamente equilibrado.

### Principales hallazgos

* Las distribuciones de residuos no mostraron sesgos sistemáticos importantes.
* Los mapas de residuos espaciales identificaron clústeres de municipios específicos donde la variación local no explicada seguía siendo elevada.
* Es probable que estas zonas representen factores socioeconómicos o ambientales locales no medidos y no incluidos en el conjunto de datos principal.

---

# Resultados generados

## Figuras

| Archivo | Descripción |
| --- | --- |
| `spatial_locations.png` | Distribución espacial de los puntos de elevación muestreados |
| `trend_surfaces.png` | Superficies de tendencia espacial polinómica |
| `raw_variograms.png` | Variogramas antes de eliminar la tendencia (*detrending*) |
| `residual_variogram.png` | Variograma residual stationary |
| `variogram_model_comparison.png` | Comparación de modelos de covarianza |
| `universal_kriging_maps.png` | Predicción e incertidumbre por kriging universal |
| `point_patterns_overview.png` | Visualización de todos los patrones de puntos |
| `quadrat_analysis.png` | Análisis de partición por cuadrantes |
| `h_function_analysis.png` | Funciones de interacción espacial H/L |
| `g_function_analysis.png` | Funciones G del vecino más próximo |
| `f_function_analysis.png` | Funciones F de espacio vacío |
| `kernel_intensity_maps.png` | Estimación de la intensidad de puntos calientes por kernel |
| `lead_prevalence_map.jpg` | Distribución de la prevalencia municipal |
| `neighbour_structure.png` | Red de vecindad espacial |
| `residual_distribution.png` | Histograma de los residuos del modelo |
| `spatial_residuals_map.jpg` | Distribución espacial de los residuos |

---

## Tablas

| Archivo | Descripción |
| --- | --- |
| `summary_statistics.csv` | Estadísticos descriptivos de la elevación |
| `variogram_model_parameters.csv` | Parámetros del modelo de covarianza |
| `point_prediction.csv` | Predicción puntual por kriging |
| `point_pattern_summary.csv` | Estadísticos descriptivos de patrones de puntos |
| `csr_quadrat_tests.csv` | Pruebas de chi-cuadrado para CSR |
| `clustering_indices.csv` | Métricas de agregación del vecino más próximo |
| `epidemiology_summary.csv` | Estadísticos descriptivos epidemiológicos |
| `logistic_model_results.csv` | Coeficientes de la regresión logística |
| `moran_statistics.csv` | Estadísticos de autocorrelación espacial |
| `model_comparison.csv` | Comparación entre el modelo espacial y el clásico |

---

# Tecnologías

* R
* geoR
* spatstat
* sf
* spdep
* spatialreg
* ggplot2
* dplyr
* estadística espacial
* geoestadística
* kriging
* análisis de procesos de puntos
* epidemiología espacial
* autocorrelación espacial
* regresión logística

---

# Metodologías

El repositorio demuestra aplicaciones prácticas de:

* Kriging universal
* Modelización de variogramas
* Estimación de covarianza espacial
* Análisis de procesos de puntos
* Evaluación de la aleatoriedad espacial completa
* Estimación de densidad por kernel
* Autocorrelación espacial (I de Moran)
* Regresión logística espacial
* Modelado de grafos de vecindad
* Diagnóstico espacial de residuos

---

# Autor

**Adrián Gómez Conde**

Estudiante de Máster en Bioestadística

Estadística Espacial · Geoestadística · Epidemiología Espacial · Análisis de Datos Aplicado
