# Banking Risk Analytics Data Warehouse
## Step 1: Business Problem
Banks deal with massive amounts of loan and borrower data daily. Effective credit risk monitoring and loan decision-making require consolidated, clean, and analytics-ready data. Transactional systems (OLTP databases) are optimized for day-to-day operations but are not designed for complex analytics, historical reporting, or large-scale aggregations.

A data warehouse allows banks to:
- Store historical and structured data from multiple sources
- Perform analytics and risk modeling efficiently
- Support dashboards for portfolio monitoring and executive reporting
- Enable regulatory compliance and risk assessments
Without a warehouse, banks risk slow reporting, incomplete insights, and poor risk decision-making.

## 2. Why a Data Warehouse is Required
| Limitation of OLTP                        | How Data Warehouse Solves It                                 |
| ----------------------------------------- | ------------------------------------------------------------ |
| Queries are slow for complex aggregations | Pre-aggregated tables optimized for analytics                |
| Data spread across multiple systems       | Centralized repository integrating all sources               |
| Limited historical data                   | Stores years of historical records for trend analysis        |
| Not suitable for BI dashboards            | Supports fast queries and visualizations in Power BI/Tableau |

## 3. Key KPIs Tracked
- **Default Rate** – Percentage of loans in default
- **Average Loan Size** – Mean loan amount per customer segment
- **Expected Credit Loss (ECL)** – Probability × Exposure × Loss Given Default
- **High Risk Borrower %** – Percentage of borrowers flagged as high risk
- **Portfolio Exposure** – Total loan exposure by region or segment
These KPIs form the foundation for risk dashboards, executive reports, and analytics models.

## Step-2: Data Warehouse Architecture
To support the Banking Risk Analytics System, a modern data warehouse architecture is designed to handle loan, borrower, and transaction data efficiently. This architecture ensures clean, historical, and analytics-ready data for risk dashboards and reporting.

### 2.1 Architecture Overview
The data flows through multiple layers:
```
Data Sources → Raw Layer → Staging Layer → Data Warehouse → Analytics Layer → Dashboard/BI
```

| Layer                   | Description                                      | Key Operations                                              |
| ----------------------- | ------------------------------------------------ | ----------------------------------------------------------- |
| **Data Sources**        | Operational banking systems providing raw data   | Loans, Customers, Transactions, Payments, Risk Scores       |
| **Raw Layer**           | Stores unprocessed data as-is                    | CSV/JSON import, API ingestion, logs                        |
| **Staging Layer**       | Temporary tables for cleaning and transformation | Remove duplicates, handle missing values, type conversion   |
| **Data Warehouse (DW)** | Centralized, structured storage                  | Star schema / normalized tables optimized for analytics     |
| **Analytics Layer**     | Pre-aggregations, risk calculations              | Default rates, expected credit loss, portfolio exposure     |
| **Dashboard / BI**      | Interactive visualization for business users     | Power BI or Tableau dashboards for KPIs and risk monitoring |

### 2.2 ETL Flow
**Extract**
- Pull raw data from CSV, APIs, or transactional databases
- Example: pandas.read_csv(), requests.get()
**Transform**
- Clean missing or inconsistent values
- Standardize data types and formats
- Generate derived fields (e.g., risk score bands, default flags)
**Load**
- Insert cleaned and transformed data into warehouse tables
- Handle incremental loads, duplicates, and data validation
**ETL Flow:**
  ```
  Raw CSV → Staging Tables → Cleaned Tables → Data Warehouse Tables → Analytics Queries → Dashboard
  ```

### 2.3 Key Features of This Architecture
- **Historical Tracking:** Stores multi-year data for trend analysis
- **Performance Optimization:** Indexing and partitioning for fast queries
- **Scalability:** Can handle increasing volume of loans and transactions
- **Auditability:** Logs each ETL step for error tracking and data validation

<img width="1536" height="1024" alt="ChatGPT Image Mar 11, 2026, 05_50_22 PM" src="https://github.com/user-attachments/assets/aecc8fce-dc9c-4cba-85aa-7c96a63acd19" />

## Step-3: Data Modeling & Schema Design
Goal: Design tables with all columns, keys, and constraints. This is the backbone of your warehouse.
### 3.1 Required Tools
- Database: PostgreSQL (recommended) or MySQL
- SQL Client: DBeaver / pgAdmin / MySQL Workbench
- Diagram Tool: draw.io / dbdiagram.io

### 3.2 Create Project Folder Structure
```
bank-risk-data-warehouse/
│
├── data/          # datasets
├── sql/           # SQL scripts
├── etl/           # Python ETL scripts
├── dashboard/     # Power BI or Tableau files
├── diagrams/      # ERD and architecture diagrams
└── README.md      # project documentation
```

### 3.3 Table List & Columns (Definite)
**1. customers (dimension table)**
| Column        | Type        | Constraint                |
| ------------- | ----------- | ------------------------- |
| customer_id   | INT         | PK, NOT NULL              |
| first_name    | VARCHAR(50) | NOT NULL                  |
| last_name     | VARCHAR(50) | NOT NULL                  |
| date_of_birth | DATE        | NOT NULL                  |
| gender        | VARCHAR(10) | NOT NULL                  |
| region        | VARCHAR(50) | NOT NULL                  |
| created_at    | TIMESTAMP   | default CURRENT_TIMESTAMP |

**2. loans (fact table)**
| Column        | Type          | Constraint                     |
| ------------- | ------------- | ------------------------------ |
| loan_id       | INT           | PK, NOT NULL                   |
| customer_id   | INT           | FK → customers.customer_id     |
| loan_amount   | DECIMAL(12,2) | NOT NULL                       |
| loan_type     | VARCHAR(20)   | NOT NULL                       |
| start_date    | DATE          | NOT NULL                       |
| end_date      | DATE          | NULL                           |
| status        | VARCHAR(20)   | NOT NULL                       |
| risk_score_id | INT           | FK → risk_scores.risk_score_id |
| created_at    | TIMESTAMP     | default CURRENT_TIMESTAMP      |

**3. loan_payments (fact/detail table)**
| Column         | Type          | Constraint                |
| -------------- | ------------- | ------------------------- |
| payment_id     | INT           | PK, NOT NULL              |
| loan_id        | INT           | FK → loans.loan_id        |
| payment_date   | DATE          | NOT NULL                  |
| payment_amount | DECIMAL(12,2) | NOT NULL                  |
| payment_status | VARCHAR(20)   | NOT NULL                  |
| created_at     | TIMESTAMP     | default CURRENT_TIMESTAMP |

**4. transactions (fact/detail table)**
| Column             | Type          | Constraint                |
| ------------------ | ------------- | ------------------------- |
| transaction_id     | INT           | PK, NOT NULL              |
| loan_id            | INT           | FK → loans.loan_id        |
| transaction_date   | DATE          | NOT NULL                  |
| transaction_amount | DECIMAL(12,2) | NOT NULL                  |
| transaction_type   | VARCHAR(20)   | NOT NULL                  |
| created_at         | TIMESTAMP     | default CURRENT_TIMESTAMP |

**5. risk_scores (dimension table)**
| Column              | Type         | Constraint                 |
| ------------------- | ------------ | -------------------------- |
| risk_score_id       | INT          | PK, NOT NULL               |
| customer_id         | INT          | FK → customers.customer_id |
| credit_score        | INT          | NOT NULL                   |
| probability_default | DECIMAL(5,4) | NOT NULL                   |
| tier_id             | INT          | FK → risk_tiers.tier_id    |
| created_at          | TIMESTAMP    | default CURRENT_TIMESTAMP  |

**6. risk_tiers (dimension table)**
| Column      | Type         | Constraint                 |
| ----------- | ------------ | -------------------------- |
| tier_id     | INT          | PK, NOT NULL               |
| tier_name   | VARCHAR(20)  | NOT NULL (Low/Medium/High) |
| description | VARCHAR(100) | NULL                       |
| created_at  | TIMESTAMP    | default CURRENT_TIMESTAMP  |

### 3.4 Table Relationships
- customers → loans (1:M)
- loans → loan_payments (1:M)
- loans → transactions (1:M)
- customers → risk_scores (1:1)
- risk_scores → risk_tiers (M:1)

### 3.5 ERD Diagram
- Use draw.io
- Create boxes for each table with all columns
- Bold the primary key columns
- Draw arrows for all foreign keys
- Save diagram as diagrams/erd.png

 Monitor portfolio-level credit risk indicators

---

## Dataset

This project uses the **LendingClub Loan Dataset**, a widely used dataset for credit risk analytics.

Dataset source:
https://www.kaggle.com/datasets/wordsforthewise/lending-club

Due to GitHub file size limits, the repository includes **sample datasets** to reproduce the analysis pipeline.

| Dataset                     | Description                         |
| --------------------------- | ----------------------------------- |
| lendingclub_raw_sample.csv  | Sample of the original raw dataset  |
| customers_sample.csv        | Customer dimension table            |
| credit_profiles_sample.csv  | Credit attributes and segmentation  |
| loans_sample.csv            | Loan transaction records            |
| loan_performance_sample.csv | Loan outcome and default indicators |

The full dataset contains **~2.2 million loan records** and was used during analysis.

---

## Project Architecture

The analytics pipeline follows a simplified **data warehouse workflow**.

Raw Data
→ Data Cleaning
→ Feature Engineering
→ Analytical Data Model
→ SQL Risk Analytics
→ Dashboard Reporting

The architecture diagram can be found in:

```
docs/project_architecture.png
```

---

## Data Modeling (Star Schema)

To enable efficient analytics, the dataset is modeled using a **Star Schema**.

The central **Fact Table** contains loan transactions, while surrounding **Dimension Tables** provide borrower and credit attributes.

### Fact Table

**loans**

Contains the core lending transactions.

Key columns:

* loan_id
* customer_id
* loan_amnt
* grade
* issue_d

---

### Dimension Tables

**customers**

Borrower demographic attributes.

Columns:

* customer_id
* addr_state
* annual_inc
* home_ownership

---

**credit_profiles**

Borrower credit quality segmentation.

Columns:

* customer_id
* fico_score
* credit_band

Credit band segmentation:

| Credit Band | Description              |
| ----------- | ------------------------ |
| Super Prime | Excellent credit quality |
| Prime       | Strong credit quality    |
| Near Prime  | Moderate credit risk     |
| Subprime    | High credit risk         |

---

**loan_performance**

Loan repayment outcome.

Columns:

* loan_id
* loan_status
* default_flag

---

### Schema Diagram

The analytical data model is illustrated in:

```
docs/data_model.png
```

This schema enables efficient risk analytics using SQL and BI tools.

---

## SQL Risk Analytics

Several SQL queries were used to analyze portfolio risk and lending patterns.

Query files are available in the `sql/` directory.

### Portfolio Overview

Measures the overall portfolio size and default rate.

Key metrics:

* Total customers
* Total loans
* Total lending exposure
* Portfolio default rate

---

### Credit Band Risk Analysis

Evaluates default rates across borrower credit segments.

Insights:

* Subprime borrowers show the highest risk
* Super Prime borrowers have the lowest default probability

---

### Geographic Risk Analysis

Identifies states with elevated loan default rates.

States with small loan volumes were filtered to avoid misleading statistics.

---

### Risk by Loan Grade

Analyzes default risk across LendingClub loan grades (A–G).

Higher grades generally correspond to higher default probabilities.

---

### Credit Band vs Loan Grade Risk

Combines borrower credit quality and loan grade to detect high-risk portfolio segments.

---

### Portfolio Growth Trend

Analyzes lending volume growth over time.

---

### Default Rate Trend

Tracks how loan default rates evolve across different lending years.

---

## Dashboard (Power BI)

An interactive dashboard was built using **Microsoft Power BI** to visualize portfolio risk metrics.

Dashboard features include:

### Portfolio KPIs

* Total Customers
* Total Loans
* Total Lending Exposure
* Portfolio Default Rate
* High Risk Share

---

### Credit Risk Analysis

Visualizations include:

* Default Rate by Credit Band
* Default Rate by Loan Grade

These help identify borrower segments contributing most to portfolio risk.

---

### Geographic Risk Distribution

State-level visualization showing regions with higher default rates.

---

### Portfolio Growth Monitoring

Line charts showing:

* Lending growth by year
* Default rate trends over time

---

### Dashboard Preview

A preview of the dashboard is available in:

```
dashboard/dashboard_preview.png
```

The full dashboard file can be found here:

```
dashboard/banking_risk_dashboard.pbix
```

---

## Key Insights

Key findings from the analysis include:

* Lending volume increased significantly after 2012.
* Higher loan grades (D–G) exhibit significantly higher default rates.
* Borrowers in lower credit bands show elevated credit risk.
* Certain geographic regions show consistently higher default probabilities.
* Portfolio risk varies substantially across borrower credit segments.

These insights demonstrate how credit analytics can be used to monitor and manage lending risk.

---

## Repository Structure

```
banking-risk-analytics-system
│
├── README.md
│
├── data
│   ├── raw
│   │   └── lendingclub_raw_sample.csv
│   │
│   └── processed
│       ├── customers_sample.csv
│       ├── credit_profiles_sample.csv
│       ├── loans_sample.csv
│       └── loan_performance_sample.csv
│
├── notebooks
│   └── banking_risk_analytics_pipeline.ipynb
│
├── sql
│   ├── portfolio_overview.sql
│   ├── credit_band_risk.sql
│   ├── geographic_risk.sql
│   ├── risk_by_grade.sql
│   ├── credit_grade_risk.sql
│   ├── portfolio_trend.sql
│   └── default_trend.sql
│
├── dashboard
│   ├── banking_risk_dashboard.pbix
│   └── dashboard_preview.png
│
└── docs
    ├── data_model.png
    └── project_architecture.png
```

---

## Technologies Used

* Python
* Pandas
* SQL
* DuckDB
* Power BI
* Jupyter Notebook

---

## How to Reproduce the Project

1. Clone the repository

```
git clone <repository-url>
```

2. Open the notebook

```
notebooks/banking_risk_analytics_pipeline.ipynb
```

3. Run the notebook cells to reproduce the data preparation and analysis.

4. Open the Power BI dashboard file to explore interactive visualizations.

---

## Future Improvements

Potential extensions for this project include:

* Predictive modeling for loan default prediction
* Expected loss estimation
* Credit risk scoring models
* Automated ETL pipeline implementation
* Deployment as a data analytics application

---

## Author

Bindu Sri Majji
Final Year Computer Science Student
Aspiring Data Analyst / Data Scientist
