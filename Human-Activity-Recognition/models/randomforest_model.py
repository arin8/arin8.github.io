from sklearn.ensemble import RandomForestClassifier

def random_forest_model(X_train, y_train):
    rf_model = RandomForestClassifier(random_state=42)
    rf_model.fit(X_train, y_train)
    return rf_model