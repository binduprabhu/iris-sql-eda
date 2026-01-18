# 🌸 Iris Project: Exploratory Data Analysis (EDA) in BigQuery

This repository containing a comprehensive Exploratory Data Analysis (EDA) suite for the classic **Iris Dataset**, specifically optimized for **Google BigQuery (GoogleSQL)**.

The project provides a turn-key SQL script to audit data quality, extract statistical insights, and prepare for machine learning workflows directly within the data warehouse.

---

## 🎯 Project Overview

The goal of this analysis is to demonstrate robust data exploration techniques using SQL. By leveraging BigQuery's analytical functions, we can understand the distribution and relationships within the Iris dataset without needing to export data to external tools like Python or R.

### Key Analysis areas:
- ✅ **Data Integrity:** Identification of nulls and missing values.
- 📊 **Statistical Profiling:** Aggregated distributions by species (Min, Max, Avg, Median).
- 🧬 **Biological Correlation:** Relationships between sepal and petal dimensions.
- 🚨 **Outlier Detection:** Statistical flagging of extreme values using percentiles.
- 📈 **Distribution Analysis:** Quartile and IQR calculations for feature engineering.

---

## 🏗️ The SQL Architecture

The analysis is structured into 8 distinct logical blocks within `iris_eda_bigquery.sql`:

1.  **Quick Preview:** Initial data inspection.
2.  **Integrity Check:** High-level audit of row counts, species diversity, and NULL values across all features.
3.  **Species Profiling:** Comprehensive summary statistics (Min/Avg/Max) grouped by flower species.
4.  **Range Analysis:** Focused check on petal boundaries to identify species overlap.
5.  **Correlative Statistics:** Using `CORR()` to determine multi-feature dependencies.
6.  **Anomaly Detection:** Identification of records falling outside the 1st and 99th percentiles (potential outliers).
7.  **Robust Global Stats:** Central tendency analysis using medians to mitigate the impact of outliers.
8.  **Quartile Distribution:** Deep dive into petal dispersion using Interquartile Ranges (IQR).

---

## 🚀 Getting Started

### Prerequisites

- A **Google Cloud Project** with the BigQuery API enabled.
- A dataset containing the Iris table.
- **Dataset Source:** [Iris Dataset on Kaggle](https://www.kaggle.com/datasets/uciml/iris)

### Setup & Usage

1.  **Data Ingestion:** Upload the Iris dataset to your BigQuery project.
2.  **Configuration:** Update the table reference at the top of the script:
    ```sql
    -- Change this to your specific table path
    `iris-484612.irisdataset.iristable`
    ```
3.  **Execution:** Copy the contents of `iris_eda_bigquery.sql` into the [BigQuery Console](https://console.cloud.google.com/bigquery) and run.

---

## 📄 License & Attribution

- **Dataset Credit:** UCI Machine Learning Repository via Kaggle.
- **SQL Implementation:** Built for performance on GoogleSQL.
