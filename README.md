# Banking Risk Analytics Data Warehouse
## 1. Business Problem
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
