data_processing_code = """
import pandas as pd

def load_raw_data(path):
    df = pd.read_csv(path)
    return df

def basic_cleaning(df):
    df = df.drop_duplicates()
    df = df.dropna(subset=["loan_amnt"])
    return df
"""

with open("/kaggle/working/banking-risk-analytics-system/src/data_processing.py", "w") as f:
    f.write(data_processing_code)
