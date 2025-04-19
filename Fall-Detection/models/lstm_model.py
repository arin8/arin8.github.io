import tensorflow as tf 
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout

def create_lstm_model(input_shape, lstm_units, dense_units=[], lstm_dropout=0.2, dense_dropout=0.2, output_activation='sigmoid'):
    
    model = Sequential()

    for i, units in enumerate(lstm_units):
        return_sequences = i < len(lstm_units) - 1  
        if i == 0:
            model.add(LSTM(units, input_shape=input_shape, return_sequences=return_sequences))
        else:
            model.add(LSTM(units, return_sequences=return_sequences))
        model.add(Dropout(lstm_dropout))

    
    for units in dense_units:
        model.add(Dense(units, activation='relu'))
        model.add(Dropout(int(dense_dropout)))


    model.add(Dense(1, activation=output_activation))

    return model