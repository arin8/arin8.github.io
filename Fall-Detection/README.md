# Fall Detection
In this project, **LSTM-based neural network** models are developed to detect falls from wearable inertial sensors data, with a focus on balancing accuracy and training efficency. The first model uses a simple two-layer LSTM architecture trained over 10 epoches with batch size 32. It achieved a test accuracy of 98% with a test loss of 0.044. 

The second model introduces a deeper architecture by increasing the batch size to 64 for faster learning, and with early stopping to avoid overfitting. The model achieved a test accruacy of 98% as well but an increase in test loss to 0.049. 

The final model uses knowledge distillation to create a smaller, faster student model based on the second model. The student model requires less training time while still maintaing a test accuracy of 98% but a slight increase of test loss to 0.059. 

Overall, the project required advanced data preprocessing and highlighted the efficiency of neural networks in handling time-series classification tasks.

# Folder Contents
- Arin_Rahim_assignment3.ipynb: The projects jupyter notebook file including discussions about model performance.
  
- processes: Contain Data preprocessing functions.
  
- models: Contain the LSTM model.
  
-  requirement.txt: Python packages required to run the Jupyter notebook.

# Tools and Libraries 
- Python 3.10.4.
- [KFall Data](https://sites.google.com/view/kfalldataset#h.r86ppf1oq5qm).
- Tensorflow, Matplotlib, Pandas. 
