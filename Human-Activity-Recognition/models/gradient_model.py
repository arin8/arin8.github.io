from sklearn.ensemble import GradientBoostingClassifier

def gradient_model(X_train, y_train): 
    gb_model = GradientBoostingClassifier(random_state=42)
    gb_model.fit(X_train, y_train)
    return gb_model

# Example usage:
# X_train, y_train = get_data()
# model = gradient_model(X_train, y_train)