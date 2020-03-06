# Import Libraries
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import csv
import math
from sklearn.preprocessing import MinMaxScaler, scale
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn import model_selection
from sklearn.model_selection import train_test_split, cross_val_score, validation_curve
from sklearn.neural_network import MLPRegressor
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor, AdaBoostRegressor, VotingClassifier

# Reading in the data files: train, test, and scenario(validation) sets
wind_train = pd.read_csv("wind_train.csv")
wind_test = pd.read_csv("wind_test.csv")
wind_scenario = pd.read_csv("wind_scenario.csv")

print(f"Shape of Train: {wind_train.shape}")
print(f"Shape of Test: {wind_test.shape}")
print(f"Shape of Scenario: {wind_scenario.shape}")

wind_train.info()
wind_test.info()
wind_scenario.info()


#-------------------------
# EXPLORATION
#-------------------------

# Scatterplot
wind_train.describe(include="all")
plt.figure(figsize=[12,12])
sns.set(style="darkgrid")
sns.scatterplot(x="Wind_Speed_AVG", y="Electricity_KW_HR_AVG", data=wind_train)
plt.show()

# Correlation Matrix
plt.figure(figsize=(15,15))
plt.title("Correlation Matrix of Wind Training Set", fontsize=18)
sns.heatmap(wind_train.corr())
plt.show()


#-------------------------
# PRE-PROCESSING
#-------------------------

# split X and Y
wind_attr = wind_train.drop(columns=["Electricity_KW_HR_AVG"])
wind_target = wind_train["Electricity_KW_HR_AVG"]

wind_attr.head(2)
wind_target.head(2)

# lets convert the pandas dataframe as a Numpy array
x_train = np.asarray(wind_attr)
y_train = np.asarray(wind_target)

# Let's do the same thing for the test dataset
wind_attr_test = wind_test.drop(columns=["Electricity_KW_HR_AVG"])
wind_target_test = wind_test["Electricity_KW_HR_AVG"]

# Convert to Numpy array
x_test = np.asarray(wind_attr_test)
y_test = np.asarray(wind_target_test)

# double check the shape of each of the train/test of X and Y
print(f"Shape of x_train: {x_train.shape}")
print(f"Shape of x_test: {x_test.shape}")
print(f"Shape of y_train: {y_train.shape}")
print(f"Shape of y_test: {y_test.shape}")

# Set Seed to have repeatable results
random_seed = 498

#-------------------------
# MODEL BUILDING
#-------------------------

# BASELINE
#==============

## Neural Network
wind_nn = MLPRegressor(random_state=random_seed)
wind_nn.fit(x_train, y_train)
wind_pred_nn = wind_nn.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Score for Training: {wind_nn.score(x_train, y_train)}")
print(f"Score for Testing: {wind_nn.score(x_test, y_test)}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Neural Network: {wind_nn.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Neural Network: {wind_nn.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
mse_nn = mean_squared_error(y_test, wind_pred_nn)
print(f"RMSE for Neural Network model: {math.sqrt(mse_nn):.4f}")

r2_nn = r2_score(y_test, wind_pred_nn)
print(f"R2 Score for Neural Network: {r2_nn:.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=wind_pred_nn, y=y_test, lowess=True, color="purple")
plt.show()


# Gradient Boosting
wind_grad = GradientBoostingRegressor(random_state=random_seed)
wind_grad.fit(x_train, y_train)
wind_pred_grad = wind_grad.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {wind_grad.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {wind_grad.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Gradient Boosting: {wind_grad.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Gradient Boosting: {wind_grad.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Neural Gradient Boosting: {math.sqrt(mean_squared_error(y_test, wind_pred_grad)):.4f}")
print(f"R2 Score for Gradient Boosting: {r2_score(y_test, wind_pred_grad):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=wind_pred_grad, y=y_test, lowess=True, color="green")
plt.show()


# AdaBoost
wind_ada = AdaBoostRegressor(random_state=random_seed)
wind_ada.fit(x_train, y_train)
wind_pred_ada = wind_ada.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {wind_ada.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {wind_ada.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for AdaBoost: {wind_ada.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for AdaBoost: {wind_ada.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for AdaBoost: {math.sqrt(mean_squared_error(y_test, wind_pred_ada)):.4f}")
print(f"R2 Score for AdaBoost: {r2_score(y_test, wind_pred_ada):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=wind_pred_ada, y=y_test, lowess=True, color="red")
plt.show()


# Random Forest
wind_rf = RandomForestRegressor(random_state=random_seed)
wind_rf.fit(x_train, y_train)
wind_pred_rf = wind_rf.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {wind_rf.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {wind_rf.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Random Forest: {wind_rf.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Random Forest: {wind_rf.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, wind_pred_rf)):.4f}")
print(f"R2 Score for Random Forest: {r2_score(y_test, wind_pred_rf):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=wind_pred_rf, y=y_test, lowess=True, color="blue")
plt.show()


# GRID/RANDOMIZED SEARCH
#========================

# Neural Network
params_neural = {"activation" : ["logistic", "tanh", "relu"],
                "solver" : ["lbfgs", "sgd"],
                 "alpha" : [0.0001, 0.0005, 0.00005],
                "hidden_layer_sizes": [(1,), (50,), (100,)]}
wind_nn2 = MLPRegressor(max_iter=10000, random_state=random_seed)
rs_nn = RandomizedSearchCV(estimator=wind_nn2, param_distributions=params_neural, cv=5)
rs_nn.fit(x_train, y_train)

rs_pred_nn = rs_nn.predict(x_test)
# Best parameters
print(f"------PARAMETERS------")
print(f"Best Parameters: {rs_nn.best_params_}")
print(f"\n")

# Scoring
print(f"------SCORING------")
print(f"Score for Training: {rs_nn.score(x_train, y_train)}")
print(f"Score for Testing: {rs_nn.score(x_test, y_test)}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Randomized Search Neural Network: {rs_nn.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Randomized Search Neural Network: {rs_nn.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for  Randomized Search Neural Network: {math.sqrt(mean_squared_error(y_test, rs_pred_nn)):.4f}")
print(f"R2 Score for Randomized Search Neural Network: {r2_score(y_test, rs_pred_nn):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Randomized Search Neural Network")
sns.residplot(x=rs_pred_nn, y=y_test, lowess=True, color="purple")
plt.show()


# Gradient Boosting
params_grad = {"n_estimators" : [50, 100, 200],
              "learning_rate" : [0.1, 0.05, 0.01],
              "max_depth" : [1, 3, 5, 7],
              "min_samples_split" : [3, 5, 7],
               "criterion" : ["mse", "mae", "friedman_mse"]}
wind_grad2 = GradientBoostingRegressor(random_state=random_seed)
rs_grad = GridSearchCV(estimator=wind_grad2, param_grid=params_grad, cv=5)
rs_grad.fit(x_train, y_train)
rs_pred_grad = rs_grad.predict(x_test)
# Best parameters
print(f"------PARAMETERS------")
print(f"Best Parameters: {rs_grad.best_params_}")
print(f"\n")

# Scoring
print(f"------SCORING------")
print(f"Score for Training: {rs_grad.score(x_train, y_train)}")
print(f"Score for Testing: {rs_grad.score(x_test, y_test)}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Grid Search Gradient Boosting: {rs_grad.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Grid Search Gradient Boosting: {rs_grad.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Neural Grid Search Gradient Boosting: {math.sqrt(mean_squared_error(y_test, rs_pred_grad)):.4f}")
print(f"R2 Score for Grid Search Gradient Boosting: {r2_score(y_test, rs_pred_grad):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Grid Search Gradient Boosting - 5-Fold Cross-Validation")
sns.residplot(x=rs_pred_grad, y=y_test, lowess=True, color="green")
plt.show()


# AdaBoost
params_ada = {"n_estimators" : [50, 100, 150, 200],
             "learning_rate" : [1, 0.1, 0.01, 0.001],
             "loss" : ["linear", "square", "exponential"]}
wind_ada2 = AdaBoostRegressor(random_state=random_seed)
rs_ada = GridSearchCV(estimator=wind_ada2, param_grid=params_ada, cv=5)
rs_ada.fit(x_train, y_train)
rs_pred_ada = rs_ada.predict(x_test)

# Best parameters
print(f"------PARAMETERS------")
print(f"Best Parameters: {rs_ada.best_params_}")
print(f"\n")

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {rs_ada.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {rs_ada.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for AdaBoost: {rs_ada.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for AdaBoost: {rs_ada.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for AdaBoost: {math.sqrt(mean_squared_error(y_test, rs_pred_ada)):.4f}")
print(f"R2 Score for AdaBoost: {r2_score(y_test, rs_pred_ada):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Grid Search AdaBoost - 5-Fold Cross-Validation")
sns.residplot(x=rs_pred_ada, y=y_test, lowess=True, color="red")
plt.show()


# Random Forest
params_forest = {"n_estimators" : [10, 50, 100, 200],
                "criterion" : ["mse", "mae"],
                "min_samples_split" : [3, 4, 5, 6, 7]}

wind_rf2 = RandomForestRegressor(random_state=random_seed)
rs_rf = GridSearchCV(estimator=wind_rf2, param_grid=params_forest, cv=5)
rs_rf.fit(x_train, y_train)
rs_pred_rf = rs_rf.predict(x_test)

# Best parameters
print(f"------PARAMETERS------")
print(f"Best Parameters: {rs_rf.best_params_}")
print(f"\n")

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {rs_rf.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {rs_rf.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Random Forest: {rs_rf.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Random Forest: {rs_rf.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, rs_pred_rf)):.4f}")
print(f"R2 Score for Random Forest: {r2_score(y_test, rs_pred_rf):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Grid Search Random Forest - 5-Fold Cross-Validation")
sns.residplot(x=rs_pred_rf, y=y_test, lowess=True, color="blue")
plt.show()



# MANUAL TUNING
#===============

# Neural Network
wind_nn3 = MLPRegressor(activation="relu", solver='lbfgs', alpha=0.001, max_iter=1000, hidden_layer_sizes=(48,), random_state=random_seed)
wind_nn3.fit(x_train, y_train)
wind_nn3.fit(x_train, y_train)
wind_pred_nn3 = wind_nn3.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Score for Training: {wind_nn3.score(x_train, y_train)}")
print(f"Score for Testing: {wind_nn3.score(x_test, y_test)}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Neural Network: {wind_nn3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Neural Network: {wind_nn3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------") 
print(f"RMSE for Neural Network model: {math.sqrt(mean_squared_error(y_test, wind_pred_nn3)):.4f}")
print(f"R2 Score for Neural Network: {r2_score(y_test, wind_pred_nn3):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Neural Network - Manual Hyperparameter Tuning")
sns.residplot(x=wind_pred_nn3, y=y_test, lowess=True, color="purple")
plt.show()


# Gradient Boosting
wind_grad3 = GradientBoostingRegressor(n_estimators=100, learning_rate=0.1, max_depth=3, min_samples_split=3, random_state=random_seed)
wind_grad3.fit(x_train, y_train)
wind_pred_grad3 = wind_grad3.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {wind_grad3.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {wind_grad3.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Gradient Boosting: {wind_grad3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Gradient Boosting: {wind_grad3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Neural Gradient Boosting: {math.sqrt(mean_squared_error(y_test, wind_pred_grad3)):.4f}")
print(f"R2 Score for Gradient Boosting: {r2_score(y_test, wind_pred_grad3):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Gradient Boosting - Manual Hyperparameter Tuning")
sns.residplot(x=wind_pred_grad3, y=y_test, lowess=True, color="green")
plt.show()


# AdaBoost
wind_ada3 = AdaBoostRegressor(n_estimators=100, base_estimator=None, learning_rate=0.1, random_state=random_seed)
wind_ada3.fit(x_train, y_train)
wind_pred_ada3 = wind_ada3.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {wind_ada3.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {wind_ada3.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for AdaBoost: {wind_ada3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for AdaBoost: {wind_ada3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for AdaBoost: {math.sqrt(mean_squared_error(y_test, wind_pred_ada3)):.4f}")
print(f"R2 Score for AdaBoost: {r2_score(y_test, wind_pred_ada3):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - AdaBoost - Manual Hyperparameter Tuning")
sns.residplot(x=wind_pred_ada3, y=y_test, lowess=True, color="red")
plt.show()


# Random Forest
wind_rf3 = RandomForestRegressor(n_estimators = 100, max_depth = None, min_samples_split = 3, criterion = "mse", random_state = random_seed)
wind_rf3.fit(x_train, y_train)
wind_pred_rf3 = wind_rf3.predict(x_test)


# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {wind_rf3.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {wind_rf3.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Random Forest: {wind_rf3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Random Forest: {wind_rf3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, wind_pred_rf3)):.4f}")
print(f"R2 Score for Random Forest: {r2_score(y_test, wind_pred_rf3):.4f}")
print(f"\n")


plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Grid Search Random Forest - 5-Fold Cross-Validation")
sns.residplot(x=wind_pred_rf3, y=y_test, lowess=True, color="blue")
plt.show()


#-------------------------
# BEST MODEL
#-------------------------

wind_rf4 = RandomForestRegressor(min_samples_split=7, n_estimators=200, criterion="mse", random_state=random_seed)
wind_rf4.fit(x_train, y_train)
wind_pred_rf4 = wind_rf4.predict(x_test)
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, wind_pred_rf4)):.4f}")

# Feature Importances
feature_importances_rf = pd.DataFrame(wind_rf4.feature_importances_,index = wind_attr.columns, columns=['Importance'])\
                        .sort_values('Importance',ascending=False)

# Export to CSV
feature_importances_rf.to_csv("featureImportances_wind.csv")



#-------------------------
# PREDICTIONS - SCENARIO
#-------------------------

# Predicting Dates
march15 = wind_scenario[wind_scenario["Date_Time"] == "03/15/91"].drop(columns=["Date_Time"])
june26 = wind_scenario[wind_scenario["Date_Time"] == "06/26/91"].drop(columns=["Date_Time"])
july3 = wind_scenario[wind_scenario["Date_Time"] == "07/03/91"].drop(columns=["Date_Time"])
october13 = wind_scenario[wind_scenario["Date_Time"] == "10/13/91"].drop(columns=["Date_Time"])
november19 = wind_scenario[wind_scenario["Date_Time"] == "11/19/91"].drop(columns=["Date_Time"])
december25 = wind_scenario[wind_scenario["Date_Time"] == "12/25/91"].drop(columns=["Date_Time"])

# Prediction Using the Random Forest Model
pred_march15 = rs_rf.predict(march15)
pred_june26 = rs_rf.predict(june26)
pred_july3 = rs_rf.predict(july3)
pred_october13 = rs_rf.predict(october13)
pred_november19 = rs_rf.predict(november19)
pred_december25 = rs_rf.predict(december25)

print("\n")
print("------PREDICTED ELECTRICITY (KW/HR)------ \n")
print(f"Prediction of Wind Production for March 15th Using Random Forest: {pred_march15}")
print(f"Prediction of Wind Production for June 26th Using Random Forest: {pred_june26}")
print(f"Prediction of Wind Production for July 3rd Using Random Forest: {pred_july3}")
print(f"Prediction of Wind Production for October 13th Using Random Forest: {pred_october13}")
print(f"Prediction of Wind Production for November 19th Using Random Forest: {pred_november19}")
print(f"Prediction of Wind Production for December 25th Using Random Forest: {pred_december25}")

# Creating Dataframe for date and predictions
scenario_df = pd.DataFrame(rs_rf.predict(wind_scenario.drop(columns=["Date_Time"])), index=wind_scenario["Date_Time"], columns=["Predicted"])

# Export to CSV
scenario_df.to_csv("predicted_electricity_wind.csv")

plt.figure(figsize=[30,15])
ax = plt.axes(facecolor='#E6E6E6')
ax.set_axisbelow(True)
plt.grid(color='w', linestyle='solid')


plt.title("Predicted Mean Wind Electricity for Scenario Year", fontsize=18)
sns.lineplot(x=scenario_df.index, y=scenario_df.Predicted, color="red")
plt.ylabel("Electricity kW/Hr", fontsize=14)
plt.show()

