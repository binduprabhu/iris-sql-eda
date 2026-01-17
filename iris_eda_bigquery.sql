-- Iris EDA in BigQuery (GoogleSQL)
-- Table: `iris-484612.irisdataset.iristable`
-- Dataset source: https://www.kaggle.com/datasets/uciml/iris

-- ------------------------------------------------------------
-- 1) Preview
-- ------------------------------------------------------------
SELECT *
FROM `iris-484612.irisdataset.iristable`
LIMIT 20;

-- ------------------------------------------------------------
-- 2) Row count, distinct species, and missing values
-- ------------------------------------------------------------
SELECT
  COUNT(*) AS n_rows,
  COUNT(DISTINCT Species) AS n_species,
  SUM(CASE WHEN SepalLengthCm IS NULL THEN 1 ELSE 0 END) AS null_sepal_length,
  SUM(CASE WHEN SepalWidthCm  IS NULL THEN 1 ELSE 0 END) AS null_sepal_width,
  SUM(CASE WHEN PetalLengthCm IS NULL THEN 1 ELSE 0 END) AS null_petal_length,
  SUM(CASE WHEN PetalWidthCm  IS NULL THEN 1 ELSE 0 END) AS null_petal_width,
  SUM(CASE WHEN Species IS NULL OR Species = '' THEN 1 ELSE 0 END) AS null_species
FROM `iris-484612.irisdataset.iristable`;

-- ------------------------------------------------------------
-- 3) Summary stats by species (min/avg/max)
-- ------------------------------------------------------------
SELECT
  Species,
  COUNT(*) AS n,

  ROUND(MIN(SepalLengthCm), 2) AS sepal_len_min,
  ROUND(AVG(SepalLengthCm), 2) AS sepal_len_avg,
  ROUND(MAX(SepalLengthCm), 2) AS sepal_len_max,

  ROUND(MIN(SepalWidthCm), 2)  AS sepal_w_min,
  ROUND(AVG(SepalWidthCm), 2)  AS sepal_w_avg,
  ROUND(MAX(SepalWidthCm), 2)  AS sepal_w_max,

  ROUND(MIN(PetalLengthCm), 2) AS petal_len_min,
  ROUND(AVG(PetalLengthCm), 2) AS petal_len_avg,
  ROUND(MAX(PetalLengthCm), 2) AS petal_len_max,

  ROUND(MIN(PetalWidthCm), 2)  AS petal_w_min,
  ROUND(AVG(PetalWidthCm), 2)  AS petal_w_avg,
  ROUND(MAX(PetalWidthCm), 2)  AS petal_w_max
FROM `iris-484612.irisdataset.iristable`
GROUP BY Species
ORDER BY Species;

-- ------------------------------------------------------------
-- 4) Petal ranges by species (quick overlap check)
-- ------------------------------------------------------------
SELECT
  Species,
  MIN(PetalLengthCm) AS petal_length_min,
  MAX(PetalLengthCm) AS petal_length_max,
  MIN(PetalWidthCm)  AS petal_width_min,
  MAX(PetalWidthCm)  AS petal_width_max
FROM `iris-484612.irisdataset.iristable`
GROUP BY Species
ORDER BY Species;

-- ------------------------------------------------------------
-- 5) Correlations between key measurements
-- ------------------------------------------------------------
SELECT
  CORR(PetalLengthCm, PetalWidthCm)  AS corr_petal_len_w,
  CORR(SepalLengthCm, PetalLengthCm) AS corr_sepal_len_petal_len,
  CORR(SepalWidthCm,  PetalWidthCm)  AS corr_sepal_w_petal_w,
  CORR(SepalLengthCm, SepalWidthCm)  AS corr_sepal_len_w
FROM `iris-484612.irisdataset.iristable`;

-- ------------------------------------------------------------
-- 6) Outlier candidates using 1st/99th percentiles per feature
-- ------------------------------------------------------------
WITH bounds AS (
  SELECT
    APPROX_QUANTILES(SepalLengthCm, 101)[OFFSET(1)]  AS sepal_len_p01,
    APPROX_QUANTILES(SepalLengthCm, 101)[OFFSET(99)] AS sepal_len_p99,
    APPROX_QUANTILES(SepalWidthCm, 101)[OFFSET(1)]   AS sepal_w_p01,
    APPROX_QUANTILES(SepalWidthCm, 101)[OFFSET(99)]  AS sepal_w_p99,
    APPROX_QUANTILES(PetalLengthCm, 101)[OFFSET(1)]  AS petal_len_p01,
    APPROX_QUANTILES(PetalLengthCm, 101)[OFFSET(99)] AS petal_len_p99,
    APPROX_QUANTILES(PetalWidthCm, 101)[OFFSET(1)]   AS petal_w_p01,
    APPROX_QUANTILES(PetalWidthCm, 101)[OFFSET(99)]  AS petal_w_p99
  FROM `iris-484612.irisdataset.iristable`
)
SELECT
  t.*
FROM `iris-484612.irisdataset.iristable` t
CROSS JOIN bounds b
WHERE
  t.SepalLengthCm < b.sepal_len_p01 OR t.SepalLengthCm > b.sepal_len_p99 OR
  t.SepalWidthCm  < b.sepal_w_p01   OR t.SepalWidthCm  > b.sepal_w_p99   OR
  t.PetalLengthCm < b.petal_len_p01 OR t.PetalLengthCm > b.petal_len_p99 OR
  t.PetalWidthCm  < b.petal_w_p01   OR t.PetalWidthCm  > b.petal_w_p99
ORDER BY Species, Id;

-- ------------------------------------------------------------
-- 7) Robust summary: overall min/median/max
-- ------------------------------------------------------------
SELECT
  ROUND(MIN(SepalLengthCm), 2) AS sepal_len_min,
  ROUND(APPROX_QUANTILES(SepalLengthCm, 101)[OFFSET(50)], 2) AS sepal_len_median,
  ROUND(MAX(SepalLengthCm), 2) AS sepal_len_max,

  ROUND(MIN(SepalWidthCm), 2) AS sepal_w_min,
  ROUND(APPROX_QUANTILES(SepalWidthCm, 101)[OFFSET(50)], 2) AS sepal_w_median,
  ROUND(MAX(SepalWidthCm), 2) AS sepal_w_max,

  ROUND(MIN(PetalLengthCm), 2) AS petal_len_min,
  ROUND(APPROX_QUANTILES(PetalLengthCm, 101)[OFFSET(50)], 2) AS petal_len_median,
  ROUND(MAX(PetalLengthCm), 2) AS petal_len_max,

  ROUND(MIN(PetalWidthCm), 2) AS petal_w_min,
  ROUND(APPROX_QUANTILES(PetalWidthCm, 101)[OFFSET(50)], 2) AS petal_w_median,
  ROUND(MAX(PetalWidthCm), 2) AS petal_w_max
FROM `iris-484612.irisdataset.iristable`;

-- ------------------------------------------------------------
-- 8) Quartiles by species for petal measurements (IQR)
-- ------------------------------------------------------------
SELECT
  Species,
  ROUND(APPROX_QUANTILES(PetalLengthCm, 4)[OFFSET(1)], 2) AS petal_len_q1,
  ROUND(APPROX_QUANTILES(PetalLengthCm, 4)[OFFSET(2)], 2) AS petal_len_median,
  ROUND(APPROX_QUANTILES(PetalLengthCm, 4)[OFFSET(3)], 2) AS petal_len_q3,
  ROUND(APPROX_QUANTILES(PetalWidthCm, 4)[OFFSET(1)], 2)  AS petal_w_q1,
  ROUND(APPROX_QUANTILES(PetalWidthCm, 4)[OFFSET(2)], 2)  AS petal_w_median,
  ROUND(APPROX_QUANTILES(PetalWidthCm, 4)[OFFSET(3)], 2)  AS petal_w_q3
FROM `iris-484612.irisdataset.iristable`
GROUP BY Species
ORDER BY Species;
