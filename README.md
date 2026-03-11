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

