# Banking Risk Analytics Data Warehouse

## Overview

Banks process millions of loans and borrower records daily. Effective credit risk monitoring requires consolidated, clean, and analytics-ready data. Transactional systems (OLTP databases) are optimized for operations but not for complex analytics or historical reporting.  

This project demonstrates a **Banking Risk Analytics System** built with a data warehouse architecture, SQL analytics, and an interactive Power BI dashboard.

---

## 1. Business Problem

- Track and monitor credit risk across the loan portfolio  
- Enable data-driven decision making for lending policies  
- Consolidate data from multiple sources for accurate analytics  
- Generate KPIs and dashboards for portfolio management  

Without a warehouse, banks face slow reporting, incomplete insights, and poor risk decisions.

---

## 2. Why a Data Warehouse

| Limitation of OLTP                        | How Data Warehouse Solves It                                 |
| ----------------------------------------- | ------------------------------------------------------------ |
| Queries are slow for complex aggregations | Pre-aggregated tables optimized for analytics                |
| Data spread across multiple systems       | Centralized repository integrating all sources               |
| Limited historical data                   | Stores multi-year historical records for trend analysis      |
| Not suitable for BI dashboards            | Supports fast queries and interactive visualizations        |

---

## 3. Key KPIs Tracked

- **Default Rate** – Percentage of loans in default  
- **Average Loan Size** – Mean loan amount per customer segment  
- **Expected Credit Loss (ECL)** – Probability × Exposure × Loss Given Default  
- **High Risk Borrower %** – Percentage of high-risk borrowers  
- **Portfolio Exposure** – Total loan exposure by region or segment  

---

## 4. Data Warehouse Architecture
```
Data Sources → Raw Layer → Staging Layer → Data Warehouse → Analytics Layer → Dashboard/BI
```

| Layer                   | Description                                      |
| ----------------------- | ------------------------------------------------ |
| **Data Sources**        | Loans, Customers, Transactions, Payments, Risk Scores |
| **Raw Layer**           | Stores unprocessed data (CSV/JSON/API ingestion) |
| **Staging Layer**       | Cleans and transforms data                        |
| **Data Warehouse (DW)** | Central structured storage, optimized for analytics |
| **Analytics Layer**     | Pre-aggregations, risk calculations             |
| **Dashboard / BI**      | Power BI dashboards for portfolio monitoring     |

**ETL Flow:**  
1. Extract: Load raw CSV/JSON or API data  
2. Transform: Clean, standardize, and generate derived features  
3. Load: Insert into warehouse tables for analytics  

---

## 5. Star Schema Design

### Fact Table

**loans** – central fact table with loan transactions

| Column      | Type          | Description                 |
| ----------- | ------------- | --------------------------- |
| loan_id     | INT           | Primary Key                 |
| customer_id | INT           | Foreign Key → customers     |
| loan_amnt   | DECIMAL       | Loan amount                 |
| grade       | VARCHAR       | Loan grade (A–G)            |
| issue_d     | DATE          | Loan issue date             |

### Dimension Tables

**customers** – borrower attributes

| Column        | Type        |
| ------------- | ----------- |
| customer_id   | INT PK      |
| addr_state    | VARCHAR     |
| annual_inc    | FLOAT       |
| home_ownership| VARCHAR     |

**credit_profiles** – borrower credit quality

| Column         | Type        |
| -------------- | ----------- |
| customer_id    | INT PK      |
| fico_score     | FLOAT       |
| credit_band    | VARCHAR     |

**loan_performance** – loan outcome

| Column      | Type        |
| ----------- | ----------- |
| loan_id     | INT PK      |
| loan_status | VARCHAR     |
| default_flag| INT (0/1)  |

**Credit Band Segmentation**

| Band         | Description              |
| ------------ | ------------------------ |
| Super Prime  | Excellent credit quality |
| Prime        | Strong credit quality    |
| Near Prime   | Moderate credit risk     |
| Subprime     | High credit risk         |

### Relationships

- customers → loans (1:M)  
- loans → loan_performance (1:1)  
- customers → credit_profiles (1:1)  

**ERD Diagram:** `docs/data_model.png`

---

## 6. Dataset

**Source:** [LendingClub Loan Dataset](https://www.kaggle.com/datasets/wordsforthewise/lending-club)  

Due to size constraints, GitHub includes **sample datasets**:
```
data/raw/lendingclub_raw_sample.csv
data/processed/customers_sample.csv
data/processed/credit_profiles_sample.csv
data/processed/loans_sample.csv
data/processed/loan_performance_sample.csv
```


Full dataset (~2.2M loans) was used for analytics.

---

## 7. SQL Risk Analytics

Key queries available in `sql/`:

- **portfolio_overview.sql** – total customers, loans, portfolio size, default rate  
- **credit_band_risk.sql** – default rates by credit segment  
- **geographic_risk.sql** – default rates by state  
- **risk_by_grade.sql** – risk by loan grade  
- **credit_grade_risk.sql** – credit band × loan grade analysis  
- **portfolio_trend.sql** – lending growth by year  
- **default_trend.sql** – default rates over time  

---

## 8. Power BI Dashboard

Dashboard features:

- **Portfolio KPIs:** Total Customers, Total Loans, Portfolio Exposure, Default Rate  
- **Credit Risk Analysis:** Default Rate by Credit Band, Loan Grade  
- **Geographic Distribution:** State-level default rate visualization  
- **Portfolio Growth:** Lending and default trends  

**Files:**  
```
dashboard/banking_risk_dashboard.pbix
dashboard/dashboard_preview.png
```

---


## 10. Technologies Used

- Python (Pandas, DuckDB, NumPy)  
- SQL  
- Jupyter Notebook  
- Power BI  

---

## 11. How to Reproduce

1. Clone repository:

```bash
git clone <repository-url>
```
Open the notebook:
- notebooks/banking_risk_analytics_pipeline.ipynb
- Run all cells to reproduce analysis
- Open Power BI dashboard to explore interactive visualizations

12. Future Improvements
- Predictive modeling for loan default
- Expected credit loss estimation
- Automated ETL pipeline
- Deployment as analytics web application

## Author

- Bindu Sri Majji
- Final Year Computer Science Student
- Aspiring Data Analyst / Data Scientist


---

