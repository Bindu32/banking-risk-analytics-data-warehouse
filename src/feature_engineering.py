feature_engineering_code = """
import pandas as pd

def create_credit_band(df):
    conditions = [
        (df['fico_score'] >= 750),
        (df['fico_score'] >= 700),
        (df['fico_score'] >= 650),
        (df['fico_score'] < 650)
    ]

    choices = [
        "Super Prime",
        "Prime",
        "Near Prime",
        "Subprime"
    ]

    df['credit_band'] = pd.Series(pd.cut(
        df['fico_score'],
        bins=[0,650,700,750,900],
        labels=["Subprime","Near Prime","Prime","Super Prime"]
    ))

    return df
"""

with open("/kaggle/working/banking-risk-analytics-system/src/feature_engineering.py", "w") as f:
    f.write(feature_engineering_code)
