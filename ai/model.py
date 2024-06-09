# ai/model.py
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, LSTM, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from sklearn.preprocessing import MinMaxScaler

class OmegaPiAI:
    def __init__(self, input_shape, output_shape):
        self.input_shape = input_shape
        self.output_shape = output_shape
        self.model = self.create_model()

    def create_model(self):
        # Create a deep neural network model with LSTM layers
        model = Sequential()
        model.add(LSTM(units=128, return_sequences=True, input_shape=self.input_shape))
        model.add(Dropout(0.2))
        model.add(LSTM(units=64, return_sequences=False))
        model.add(Dropout(0.2))
        model.add(Dense(units=32, activation='relu'))
        model.add(Dense(units=self.output_shape, activation='sigmoid'))
        model.compile(optimizer=Adam(lr=0.001), loss='binary_crossentropy', metrics=['accuracy'])
        return model

    def train(self, X_train, y_train, X_val, y_val):
        # Train the model using early stopping and model checkpointing
        early_stopping = EarlyStopping(monitor='val_loss', patience=5, min_delta=0.001)
        model_checkpoint = ModelCheckpoint('model.h5', monitor='val_loss', save_best_only=True, mode='min')
        self.model.fit(X_train, y_train, epochs=50, batch_size=32, validation_data=(X_val, y_val), 
                        callbacks=[early_stopping, model_checkpoint])

    def predict(self, X_test):
        # Make predictions on the test data
        return self.model.predict(X_test)

    def evaluate(self, X_test, y_test):
        # Evaluate the model on the test data
        loss, accuracy = self.model.evaluate(X_test, y_test)
        return loss, accuracy

    def save_model(self):
        # Save the model to a file
        self.model.save('model.h5')

    def load_model(self):
        # Load the model from a file
        self.model = tf.keras.models.load_model('model.h5')
