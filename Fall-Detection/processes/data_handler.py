import pandas as pd 
import os 
import re

def seperate_files(): 
    
    base_dir = 'raw_data/sensor_data/'
    sensor_files = {}
    
    for subject_id in range(6, 39):
        if subject_id == 34:
            continue
        sensor_files[subject_id] = [file for file in os.listdir(base_dir + f'SA{subject_id:02}') if file.endswith('.csv')]
    
    return sensor_files

def seperate_fall_no_fall_files(sensor_files):
    
    fall_taskId = ['20', '21','22', '23','24', '25', '26', '27', 
               '28', '29', '30', '31', '32', '33','34']
    
    fall_files = []
    non_fall_files = []
    
    for subject_id, files in sensor_files.items():
        for file in files:
            
            task_id = file.split('T')[1].split('R')[0]
            
            if task_id in fall_taskId:
                fall_files.append((subject_id, file))
            else:
                non_fall_files.append((subject_id, file))
    
    return fall_files, non_fall_files

def load_label_data():
    base_label_directory = 'raw_data/label_data/'
    label_data = {}

    for subject_id in range(6, 39):
        if subject_id == 34:  
            continue

        label_file_path = os.path.join(base_label_directory, f'SA{subject_id:02}_label.xlsx')
        
        label_df = pd.read_excel(label_file_path, engine='openpyxl')

        current_task = None
        task_start_index = 0

        for index, row in label_df.iterrows():
            if pd.notna(row['Task Code (Task ID)']): 
                if current_task is not None:
                    
                    label_df.loc[task_start_index:index-1, 'Task Code (Task ID)'] = label_df.loc[task_start_index, 'Task Code (Task ID)']
                    label_df.loc[task_start_index:index-1, 'Description'] = label_df.loc[task_start_index, 'Description']

                current_task = row['Task Code (Task ID)']
                task_start_index = index

    
        label_df.loc[task_start_index:, 'Task Code (Task ID)'] = label_df.loc[task_start_index, 'Task Code (Task ID)']
        label_df.loc[task_start_index:, 'Description'] = label_df.loc[task_start_index, 'Description']

        
        label_df['Task Code (Task ID)'] = label_df['Task Code (Task ID)'].apply(
            lambda x: re.search(r'\((\d+)\)', x).group(1) if pd.notna(x) else x
        )
        
        label_df.rename(columns={'Task Code (Task ID)': 'Task ID'}, inplace=True)

        label_data[f'SA{subject_id:02}'] = label_df

    return label_data

def extract_all_data(fall_files, non_fall_files, label_data):
    all_data = []

    # Process non-fall files
    for subject_id, file_name in non_fall_files:
        sensor_file_path = os.path.join('raw_data/sensor_data', f'SA{subject_id:02}', file_name)
        sensor_df = pd.read_csv(sensor_file_path)

        sensor_df['Subject ID'] = f'SA{subject_id:02}'
        sensor_df['Task ID'] = file_name.split('T')[1].split('R')[0]
        sensor_df['Trial ID'] = file_name.split('R')[1].split('.')[0]
        sensor_df['fall_label'] = 0
        all_data.append(sensor_df)

    # Process fall files
    for subject_id, file_name in fall_files:
        task_id = file_name.split('T')[1].split('R')[0]
        trial_id = file_name.split('R')[1].split('.')[0]

        label_df = label_data.get(f'SA{subject_id:02}')
        if label_df is not None:
            fall_info = label_df[(label_df['Task ID'] == task_id) & (label_df['Trial ID'] == int(trial_id))]

            sensor_file_path = os.path.join('raw_data/sensor_data', f'SA{subject_id:02}', file_name)
            sensor_df = pd.read_csv(sensor_file_path)

            if not fall_info.empty:
                for _, row in fall_info.iterrows():
                    fall_start_frame = row['Fall_onset_frame']
                    fall_end_frame = row['Fall_impact_frame']

                    fall_segment = sensor_df[(sensor_df['FrameCounter'] >= fall_start_frame) & (sensor_df['FrameCounter'] <= fall_end_frame)].copy()
                    fall_segment['Subject ID'] = f'SA{subject_id:02}'
                    fall_segment['Task ID'] = task_id
                    fall_segment['Trial ID'] = trial_id
                    fall_segment['fall_label'] = 1
                    all_data.append(fall_segment)

                    non_fall_segment_before = sensor_df[sensor_df['FrameCounter'] < fall_start_frame].copy()
                    non_fall_segment_after = sensor_df[sensor_df['FrameCounter'] > fall_end_frame].copy()
                    for segment in [non_fall_segment_before, non_fall_segment_after]:
                        segment['Subject ID'] = f'SA{subject_id:02}'
                        segment['Task ID'] = task_id
                        segment['Trial ID'] = trial_id
                        segment['fall_label'] = 0
                        all_data.append(segment)

    combined_data = pd.concat(all_data, ignore_index=True)
    combined_data.to_csv('raw_data/combined_data.csv', index=False)

    return combined_data

#def extract_fall_segments(sensor_files, label_data): 
    
    all_fall_data_segments = []
    for subject_id, files in sensor_files.items():
        subject_key = f'SA{subject_id:02}'
        label_df = label_data.get(subject_key)

        if label_df is not None:
            for _, row in label_df.iterrows():
                task_id = row['Task Code (Task ID)']
                trial_id = row['Trial ID']  # Trial number is a single integer
                fall_start_frame = row['Fall_onset_frame']
                fall_end_frame = row['Fall_impact_frame']

                # Construct the expected sensor data filename without leading zeros for the trial number
                file_name = f'{subject_key}T{task_id:02}R{trial_id}.csv'  # Note: {trial_id} without :02

                # Check if the file exists in the sensor_files list for the subject
                file_path = [f for f in files if file_name in f]

                if file_path:
                    sensor_df = pd.read_csv(file_path[0])
                    print("File path: ", file_path[0])

                    # Extract the fall event data
                    fall_segment = sensor_df[(sensor_df['FrameCounter'] >= fall_start_frame) &
                                             (sensor_df['FrameCounter'] <= fall_end_frame)]

                    # Add identifiers to the extracted segment
                    fall_segment['TaskID'] = task_id
                    fall_segment['TrialID'] = trial_id
                    fall_segment['SubjectID'] = subject_id

                    all_fall_data_segments.append(fall_segment)

    # Merge all extracted fall data segments into a single DataFrame
    merged_fall_data = pd.concat(all_fall_data_segments, ignore_index=True)
    return merged_fall_data


