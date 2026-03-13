run_analysis_code = """
import pandas as pd
import duckdb

customers = pd.read_csv("../data/processed/customers_sample.csv")
credit_profiles = pd.read_csv("../data/processed/credit_profiles_sample.csv")
loans = pd.read_csv("../data/processed/loans_sample.csv")
loan_performance = pd.read_csv("../data/processed/loan_performance_sample.csv")

con = duckdb.connect()

con.register("customers", customers)
con.register("credit_profiles", credit_profiles)
con.register("loans", loans)
con.register("loan_performance", loan_performance)

result = con.execute(\"\"\"
SELECT
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT loan_id) AS loans
FROM loans
\"\"\").fetchdf()

print(result)
"""

with open("/kaggle/working/banking-risk-analytics-system/src/run_analysis.py", "w") as f:
    f.write(run_analysis_code)
