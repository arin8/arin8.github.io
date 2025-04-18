# Evaluating Player 
For this project, an **expected passing accuracy** (xPA) model was created to evaluate passing abilities of all the midfielders across the **top five European first divisions**. The model was built using logistic regression for binary classification with Wysscout data from the 2017/2018 season, aiming to predict the success or failure of each pass based on contextual match features. Players exceeding their xPA were flagged as intresting. These players were furthur evalauted based on their market price, age, and current club context to assess their potential for recruitment or development. 

The model achieved an accuracy of 87-88% on the test set, indicating strong performance in predicting pass outcomes. 

# Folder Contents 
- Evaluating_player_individual.py: A python script with functions for data cleaning, player filtering, and logistic regression model training for xPA
  
- Assignment_2_Evaluation_player.pdf: Text document with a short evaluation of the result and a more detailed explanation of the model.
  
- requirements.txt: Required Python packages for running the python script.

# Tools and libraries 
- Python 3.10.4.
- [Wyscout data](https://github.com/koenvo/wyscout-soccer-match-event-dataset).
- Numpy, Pandas, SKlearn.

