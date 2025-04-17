import pathlib
import os
import pandas as pd
import numpy as np
import json
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import roc_auc_score, log_loss, classification_report

"""





ATTENTION, ATTENTION, ATTENTION!

To run this code, please have the files players.json and teams.json season 2017/2018 from Wyscout in the same directory as this file. 








"""

def get_clubs():
    
    path = os.path.join(str(pathlib.Path().resolve()), 'teams.json')
        
    with open(path) as f:
        
        teams_data = json.load(f)
            
        df_teams = pd.json_normalize(teams_data)
        df_clubs = df_teams[df_teams.type == 'club']
        clubs_ids = df_clubs['wyId'].tolist()
        
    return clubs_ids
  
def get_midfielders():
    
    path = os.path.join(str(pathlib.Path().resolve()), 'players.json')
    
    with open(path) as f:
        
        players_data = json.load(f)
        
    df_players = pd.json_normalize(players_data)
    
    clubs_ids = get_clubs()
    df_midfielder = df_players[df_players['currentTeamId'].isin(clubs_ids) & (df_players['role.name'] == 'Midfielder')]
    
    players_id = df_midfielder['wyId'].tolist()
    first_name_list = df_midfielder['firstName'].tolist()
    last_name_list = df_midfielder['lastName'].tolist()
    
    return players_id, first_name_list, last_name_list
    

def get_events_data_england():
    
    path = os.path.join(str(pathlib.Path().resolve()), 'events_England.json')

    with open(path) as f:
        
        data = json.load(f)

    df = pd.json_normalize(data)
    player_id, first_name_list, last_name_list = get_midfielders()
    
    df = df[df['playerId'].isin(player_id)]
    
    first_name_map = dict(zip(player_id, first_name_list))
    last_name_map = dict(zip(player_id, last_name_list))
    

    df['first_name'] = df['playerId'].map(first_name_map)
    df['last_name'] = df['playerId'].map(last_name_map)
    df['first_name'] = df['first_name'].apply(lambda x: x.encode('utf-8').decode('unicode_escape'))
    df['last_name'] = df['last_name'].apply(lambda x: x.encode('utf-8').decode('unicode_escape'))
    
    df['name'] = df['first_name'] + ' ' + df['last_name']
    
    return df

def get_events_data_all_leagues():

    df_concat = None
    player_id, first_name_list, last_name_list = get_midfielders()
    
    first_name_map = dict(zip(player_id, first_name_list))
    last_name_map = dict(zip(player_id, last_name_list))
    
    path = os.path.join(str(pathlib.Path().resolve()))
    
    countries = {
        'France' : 'events_France.json',
        'Germany' : 'events_Germany.json',
        'Italy' : 'events_Italy.json',
        'Spain' : 'events_Spain.json',
        'England' : 'events_England.json'
    }
    
    for country, file_name in countries.items():
        
        file_path = os.path.join(path, file_name)
       
        if os.path.exists(file_path):
            
            with open(os.path.join(path, file_name)) as f:
                
                data = json.load(f)
                df = pd.json_normalize(data)
                
                df = df[df['playerId'].isin(player_id)]
                
                df['first_name'] = df['playerId'].map(first_name_map)
                df['last_name'] = df['playerId'].map(last_name_map)
                df['first_name'] = df['first_name'].apply(lambda x: x.encode('utf-8').decode('unicode_escape'))
                df['last_name'] = df['last_name'].apply(lambda x: x.encode('utf-8').decode('unicode_escape'))
    
                df['name'] = df['first_name'] + ' ' + df['last_name']

                if df_concat is None: 
                    
                    df_concat = df
                    
                else: 
                
                    df_concat = pd.concat([df_concat, df], ignore_index=True)          
        else: 
            
            print(f'File {file_name} does not exist \n')
    
    if df_concat is None or df_concat.empty:
        
        return pd.DataFrame()
        
    return df_concat
            
def get_passing_data():
    
    df = get_events_data_england()
    df_all = get_events_data_all_leagues()
    
    df = df[df.eventName == 'Pass']
    df = df[df.subEventName != 'Hand pass']
    
    if df_all.empty:
        
        return df, pd.DataFrame()
    
    else:
        
        df_all = df_all[df_all.eventName == 'Pass']
        df_all = df_all[df_all.subEventName != 'Hand pass']
    
    return df, df_all

    
def set_passing_coordinates():
    
    df, df_all = get_passing_data()
     
    df['y'] = df.positions.apply(lambda x: x[0]['y'])
    df['x'] = df.positions.apply(lambda x: x[0]['x'])
    df['end_y'] = df.positions.apply(lambda x: x[1]['y'])
    df['end_x'] = df.positions.apply(lambda x: x[1]['x'])
    df = df.drop(columns='positions')
    
    if df_all.empty:
        
        return df, pd.DataFrame()
    
    else: 
        
        df_all['y'] = df_all.positions.apply(lambda x: x[0]['y'])
        df_all['x'] = df_all.positions.apply(lambda x: x[0]['x'])
        df_all['end_y'] = df_all.positions.apply(lambda x: x[1]['y'])
        df_all['end_x'] = df_all.positions.apply(lambda x: x[1]['x'])
        df_all = df_all.drop(columns='positions')
    
    return df, df_all

def set_tags_id():
    
    df, df_all = set_passing_coordinates()
    
    df['tags_id'] = df['tags'].apply(lambda x: [tag['id'] for tag in x])
    df = df.drop(columns='tags')
    mask_tags_id = (df.tags_id != 1001) & (df.tags_id != 102)
    df = df[mask_tags_id]
    
    if df_all.empty:
        
        return df, pd.DataFrame()
    else:
        
        df_all['tags_id'] = df_all['tags'].apply(lambda x: [tag['id'] for tag in x])
        df_all = df_all.drop(columns='tags')
        mask_tags_id_all = (df_all.tags_id != 1001) & (df_all.tags_id != 102)
        df_all = df_all[mask_tags_id_all]
    
    return df, df_all

def create_model_df():
    
    df, df_all = set_tags_id()
    df_model = pd.DataFrame()
    df_model_all = pd.DataFrame()
    pass_types = df.subEventName.unique()
    
    tags = {
        'foot_left' : 401, 
        'foot_right' : 402,
        'head_body_pass' : 403,
        'through_ball' : 901,
        'under_pressure' : 2001,
        'key_pass' : 302,
        'counter_attack_pass' : 1901,
        'blocked' : 2101,
        'interception' : 1401,
        'accuracy' : 1801
    }
    
    df_model['match_id'] = df.matchId
    df_model['name'] = df.name
    df_model['type_pass'] = df.subEventName
    df_model['event'] = df.eventName
    df_model['distance'] = np.sqrt((df.end_x - df.x)**2 + (df.end_y - df.y)**2)
    df_model['pass_angle'] = np.arctan2((df.end_y - df.y), (df.end_x - df.x)) * (180/np.pi)
    df_model['pass_angle'] = df_model['pass_angle'].apply(lambda angle: angle + 360 if angle < 0 else angle)

    for pass_type in pass_types:
            
        df_model[pass_type] = df.subEventName.apply(lambda x : 1 if x == pass_type else 0)
     
    if df_all.empty:
        
        for key, value in tags.items():
            
            df_model[key] = df.tags_id.apply(lambda x : 1 if value in x else 0)
        
        return df_model, pd.DataFrame()
            
    else:
        df_model_all['match_id'] = df_all.matchId
        df_model_all['name'] = df_all.name
        df_model_all['type_pass'] = df_all.subEventName
        df_model_all['event'] = df_all.eventName
        df_model_all['distance'] = np.sqrt((df_all.end_x - df_all.x)**2 + (df_all.end_y - df_all.y)**2)
        df_model_all['pass_angle'] = np.arctan2((df_all.end_y - df_all.y), (df_all.end_x - df_all.x)) * (180/np.pi)
        df_model_all['pass_angle'] = df_model_all['pass_angle'].apply(lambda angle: angle + 360 if angle < 0 else angle)

        for pass_type_all in pass_types:
                
            df_model_all[pass_type_all] = df_all.subEventName.apply(lambda x : 1 if x == pass_type_all else 0)
    
    
        for key, value in tags.items():
            
            df_model[key] = df.tags_id.apply(lambda x : 1 if value in x else 0)
            df_model_all[key] = df_all.tags_id.apply(lambda x : 1 if value in x else 0)
    
    return df_model, df_model_all

def filter_model_df():
    
    df_model, df_model_all = create_model_df()
    
    df_player_passing = df_model.groupby('name').size().reset_index(name='total passes')
    df_player_passing_filter = df_player_passing[df_player_passing['total passes'] >= 500]
    df_model_filtered = df_model[df_model['name'].isin(df_player_passing_filter['name'])]
    
    if df_model_all.empty:
    
        return df_model_filtered, pd.DataFrame()
    
    else: 
        
        df_player_passing_all = df_model_all.groupby('name').size().reset_index(name='total passes')
        df_player_passing_filter_all = df_player_passing_all[df_player_passing_all['total passes'] >= 500]
        df_model_filtered_all = df_model_all[df_model_all['name'].isin(df_player_passing_filter_all['name'])]
        
        return df_model_filtered, df_model_filtered_all
        

def get_features_and_target():
        
    df_model, df_model_all = filter_model_df()
       
    
    if df_model_all.empty:
        
        print("No data available of the other leagues")
        return df_model, pd.DataFrame()
    
    else: 
        
        return  df_model, df_model_all

def logistic_regression_model(df_model):
                    
    X = df_model.drop(columns=['match_id', 'name', 'type_pass', 'event', 'accuracy'])
    y = df_model['accuracy']
            
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
            
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
            
    model = LogisticRegression(class_weight=None)
    model.fit(X_train_scaled, y_train)
            
    y_pred_proba = model.predict_proba(X_test_scaled)[:, 1]
    y_pred = model.predict(X_test_scaled)
            
    roc_auc = roc_auc_score(y_test, y_pred_proba)
    log_loss_value = log_loss(y_test, y_pred_proba)
    classification_report_EPL = classification_report(y_test, y_pred, target_names=['0', '1'])
    
    print(f'Roc Auc score: {roc_auc}')
    print(f'Log-Loss: {log_loss_value}')
    print("Classification Report\n")
    print(classification_report_EPL)
            
            
    return model, scaler 


def predict_expected_passing(df_model, model, scalar):
    
    X = df_model.drop(columns=['match_id', 'name', 'type_pass', 'event', 'accuracy'])
    y = df_model['accuracy']
        
    X_scaled_all = scalar.transform(X)
    y_pred_all_proba = model.predict_proba(X_scaled_all)[:, 1]
    y_pred_all = model.predict(X_scaled_all)
        
    df_model['xPA'] = y_pred_all_proba
    
    roc_auc_score_all = roc_auc_score(y, y_pred_all_proba)
    log_loss_all = log_loss(y, y_pred_all_proba)
    classification_report_all = classification_report(y, y_pred_all, target_names=['0', '1'])
        
    #print(f'Roc Auc Score All: {roc_auc_score_all}')
    #print(f'Log-loss All: {log_loss_all}')
    #print("Classification Report All\n")
    #print(classification_report_all)
    
    return df_model


def aggregate_xpa_per_player(df_model_all):
    
    print("Aggregating Expected Passing per Player")
    
    df_xpa_per_player = df_model_all.groupby('name').agg({
        'xPA': 'mean',  
        'accuracy': ['sum', 'count'] 
    }).reset_index()

    df_xpa_per_player.columns = ['name', 'xPA', 'successful_passes', 'total_passes']
    df_xpa_per_player['passing_accuracy'] = df_xpa_per_player['successful_passes'] / df_xpa_per_player['total_passes']
    
    df_xpa_per_player = df_xpa_per_player.sort_values(by='xPA', ascending=False)

    print(df_xpa_per_player[['name', 'xPA', 'passing_accuracy']].head(40))

    return df_xpa_per_player



df_model, df_model_all = get_features_and_target()
model, scalar = logistic_regression_model(df_model)
df_xPA_per_pass = predict_expected_passing(df_model, model, scalar)
df_xPA_per_player = aggregate_xpa_per_player(df_xPA_per_pass)
