import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split

class OmegaPiAnalytics:
    def __init__(self, data: pd.DataFrame):
        self.data = data

    def predict_transaction_volumes(self):
        X = self.data.drop(['transaction_volume'], axis=1)
        y = self.data['transaction_volume']
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        model = RandomForestRegressor(n_estimators=100)
        model.fit(X_train, y_train)
        return model.predict(X_test)
