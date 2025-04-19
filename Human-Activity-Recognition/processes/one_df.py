import pandas as pd 
import os

def one_df(file_name):
    
    file_path = f'raw_data/har70plus/{file_name}.csv'
    
    df = pd.read_csv(file_path)
    
    return df