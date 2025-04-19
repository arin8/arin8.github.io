from scipy.stats import mode
import numpy as np
import pandas as pd

def apply_window(data, window_size, step_size):
    features = []
    window_labels = []

    for start in range(0, len(data) - window_size + 1, step_size):
        end = start + window_size
        window = data[start:end]
        window_label = mode(window['label'])
        
        
        window_features = []
        for axis in ['back_x', 'back_y', 'back_z', 'thigh_x', 'thigh_y', 'thigh_z']:
            window_features.extend([window[axis].mean(), window[axis].std(), window[axis].min(), window[axis].max()])
        
        features.append(window_features)
        window_labels.append(window_label[0])
        
    X_windowed = np.array(features)
    y_windowed = np.array(window_labels)
    

    return X_windowed, y_windowed

# Test code for the function
data = pd.read_csv('raw_data/har70plus/502.csv')
test_data = data.drop(['timestamp'], axis=1)
text_windowed, y_windowed = apply_window(test_data, 128, 64)

