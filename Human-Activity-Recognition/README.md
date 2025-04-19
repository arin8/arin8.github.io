# Human Activity Recognition 
In this project, sensor data from wearable devices is used to classify human activities such as walking, sitting, or standing. The dataset is segmented using a sliding window approach and then analyzed through two classification models: **Gradient Bossting and Random Forest**. Emphasis is placed on preprocessing sequential time-series data and evaluating the models using standard classification metrics. Feature engineering is also applied to identify the minimal set of features that can predict each activity. 

The Random Forest model achieved an accuracy of 94%, while the Gradient Boosting model reached 91% accuracy on the test set. A minimal set of four features — specifically the X and Z axes of sensors placed on the back and thigh — were found to predict activities with 84-86% accuracy. 

# Folder Contents 
- models: Contain implementations of the respective models.
  
- apply_window.py: Applies a sliding window to the sensor data to segment time-series data.
  
- one_df.py & all_data.py: Handle the merging and formatting of the dataset.
  
- plots: Contain plots like violinplot, heatmap, and frecuancy of lables.
  
- assignment2.ipynb: The projects jupyter notebook file.
  
- requirements.txt: Python packages required to run the project.

# Tools and Libraries 
Python 3.10.4.
[Har70 Data](https://archive.ics.uci.edu/dataset/780/har70)
[MHealth Data](https://archive.ics.uci.edu/dataset/319/mhealth+dataset)
Numpy, Matplotlib, Seaborn, SKlearn, Pandas. 
