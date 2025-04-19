import pandas as pd
import glob


def all_data(): 
    dfs = []
    files_path = 'raw_data/har70plus/*.csv'
    i = 0

   
    file_paths = glob.glob(files_path)

    for file_path in file_paths:
        df = pd.read_csv(file_path)
        dfs.append(df)
        i = i + 1 
    
    df = pd.concat(dfs)
    return df


all_data()



