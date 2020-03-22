# Import Libraries
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
#%matplotlib inline
import csv
import math 
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV
from sklearn.neural_network import MLPRegressor
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor, AdaBoostRegressor
from sklearn.metrics import mean_squared_error, r2_score

# Reading in the concatenated solar dataset
solar_train = pd.read_csv("solar_train.csv")
solar_test = pd.read_csv("solar_test.csv")
solar_scenario = pd.read_csv("solar_scenario.csv")

print(f"Solar Train Shape: {solar_train.shape}")
print(f"Solar Test Shape: {solar_test.shape}")
print(f"Solar Scenario Shape: {solar_scenario.shape}")

solar_train.info()
solar_test.info()
solar_scenario.info()


#-------------------------
# EXPLORATION
#-------------------------

solar_train.head(2)
solar_test.head(2)
solar_scenario.head(2)

solar_train.describe(include="all")

explore_solar = solar_train.iloc[:,0:10]
plt.figure(figsize=(12,12))
plt.title("Correlation Matrix of Solar Training Dataset - Numerical Variables Only", fontsize=18)
sns.heatmap(explore_solar.corr())
plt.show()

plt.figure(figsize=[12,12])
sns.pairplot(data=explore_solar)
plt.show()

#-------------------------
# PRE-PROCESSING
#-------------------------

# split X and Y
solar_attr = solar_train.drop(columns=["Electricity_KW_HR_AVG"])
solar_target = solar_train["Electricity_KW_HR_AVG"]

solar_attr.head(2)
solar_target.head(2)


# lets convert the pandas dataframe as a Numpy array
x_train = np.asarray(solar_attr)
y_train = np.asarray(solar_target)

# Let's do the same thing for the test dataset
solar_attr_test = solar_test.drop(columns=["Electricity_KW_HR_AVG"])
solar_target_test = solar_test["Electricity_KW_HR_AVG"]

# Convert to Numpy array
x_test = np.asarray(solar_attr_test)
y_test = np.asarray(solar_target_test)

# double check the shape of each of the train/test of X and Y
print(f"Shape of x_train: {x_train.shape}")
print(f"Shape of x_test: {x_test.shape}")
print(f"Shape of y_train: {y_train.shape}")
print(f"Shape of y_test: {y_test.shape}")

# Set Random Seed to have repeatable results
random_seed = 213

#-------------------------
# MODEL BUILDING
#-------------------------

# BASELINE
#==============
# Neural Network Model
solar_nn = MLPRegressor(random_state=random_seed)
solar_nn.fit(x_train, y_train)
solar_pred_nn = solar_nn.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Score for Training: {solar_nn.score(x_train, y_train)}")
print(f"Score for Testing: {solar_nn.score(x_test, y_test)}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Neural Network: {solar_nn.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Neural Network: {solar_nn.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Neural Network model: {math.sqrt(mean_squared_error(y_test, solar_pred_nn)):.4f}")
print(f"R2 Score for Neural Network: {r2_score(y_test, solar_pred_nn):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Neural Network Baseline")
sns.residplot(x=solar_pred_nn, y=y_test, lowess=True, color="purple")
plt.show()


# Gradient Boosting

solar_grad = GradientBoostingRegressor(random_state=random_seed)
solar_grad.fit(x_train, y_train)
solar_pred_grad = solar_grad.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {solar_grad.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {solar_grad.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Gradient Boosting: {solar_grad.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Gradient Boosting: {solar_grad.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Neural Gradient Boosting: {math.sqrt(mean_squared_error(y_test, solar_pred_grad)):.4f}")
print(f"R2 Score for Gradient Boosting: {r2_score(y_test, solar_pred_grad):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=solar_pred_grad, y=y_test, lowess=True, color="green")
plt.show()


# AdaBoost
solar_ada = AdaBoostRegressor(random_state=random_seed)
solar_ada.fit(x_train, y_train)
solar_pred_ada = solar_ada.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {solar_ada.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {solar_ada.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for AdaBoost: {solar_ada.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for AdaBoost: {solar_ada.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for AdaBoost: {math.sqrt(mean_squared_error(y_test, solar_pred_ada)):.4f}")
print(f"R2 Score for AdaBoost: {r2_score(y_test, solar_pred_ada):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=solar_pred_ada, y=y_test, lowess=True, color="red")
plt.show()

# Random Forest
solar_rf = RandomForestRegressor(random_state=random_seed)
solar_rf.fit(x_train, y_train)
solar_pred_rf = solar_rf.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {solar_rf.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {solar_rf.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Random Forest: {solar_rf.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Random Forest: {solar_rf.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, solar_pred_rf)):.4f}")
print(f"R2 Score for Random Forest: {r2_score(y_test, solar_pred_rf):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
sns.residplot(x=solar_pred_rf, y=y_test, lowess=True, color="blue")
plt.show()


# GRID/RANDOMIZED SEARCH
#========================

# Neural Network
params_neural = {"activation" : ["logistic", "tanh", "relu"],
                "solver" : ["lbfgs", "sgd"],
                 "alpha" : [0.0001, 0.0005, 0.00005],
                "hidden_layer_sizes": [(1,), (50,), (100,)]}
solar_nn2 = MLPRegressor(max_iter=10000, random_state=random_seed)
rs_nn = RandomizedSearchCV(estimator=solar_nn2, param_distributions=params_neural, cv=5)
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
solar_grad2 = GradientBoostingRegressor(random_state=random_seed)
rs_grad = GridSearchCV(estimator=solar_grad2, param_grid=params_grad, cv=5)
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
solar_ada2 = AdaBoostRegressor(random_state=random_seed)
rs_ada = GridSearchCV(estimator=solar_ada2, param_grid=params_ada, cv=5)
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

solar_rf2 = RandomForestRegressor(random_state=random_seed)
rs_rf = GridSearchCV(estimator=solar_rf2, param_grid=params_forest, cv=5)
rs_rf.fit(x_train, y_train)
rs_pred_rf = rs_rf.predict(x_test)

# Best parameters
print(f"------PARAMETERS------")
print(f"Best Parameters: {rs_rf.best_params_}")
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
solar_nn3 = MLPRegressor(activation="relu", solver='lbfgs', alpha=0.0001, max_iter=1000, hidden_layer_sizes=(100,), random_state=random_seed)
solar_nn3.fit(x_train, y_train)
solar_pred_nn3 = solar_nn3.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Score for Training: {solar_nn3.score(x_train, y_train)}")
print(f"Score for Testing: {solar_nn3.score(x_test, y_test)}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Neural Network: {solar_nn3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Neural Network: {solar_nn3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------") 
print(f"RMSE for Neural Network model: {math.sqrt(mean_squared_error(y_test, solar_pred_nn3)):.4f}")
print(f"R2 Score for Neural Network: {r2_score(y_test, solar_pred_nn3):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Neural Network - Manual Hyperparameter Tuning")
sns.residplot(x=solar_pred_nn3, y=y_test, lowess=True, color="purple")
plt.show()


# Gradient Boosting
solar_grad3 = GradientBoostingRegressor(n_estimators=100, learning_rate=0.1, max_depth=3, min_samples_split=3, random_state=random_seed)
solar_grad3.fit(x_train, y_train)
solar_pred_grad3 = solar_grad3.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {solar_grad3.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {solar_grad3.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Gradient Boosting: {solar_grad3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Gradient Boosting: {solar_grad3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Neural Gradient Boosting: {math.sqrt(mean_squared_error(y_test, solar_pred_grad3)):.4f}")
print(f"R2 Score for Gradient Boosting: {r2_score(y_test, solar_pred_grad3):.4f}")
print(f"\n")


plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Gradient Boosting - Manual Hyperparameter Tuning")
sns.residplot(x=solar_pred_grad3, y=y_test, lowess=True, color="green")
plt.show()


# AdaBoost
solar_ada3 = AdaBoostRegressor(n_estimators=100, base_estimator=None, learning_rate=0.1, random_state=random_seed)
solar_ada3.fit(x_train, y_train)
solar_pred_ada3 = solar_ada3.predict(x_test)

# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {solar_ada3.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {solar_ada3.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for AdaBoost: {solar_ada3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for AdaBoost: {solar_ada3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for AdaBoost: {math.sqrt(mean_squared_error(y_test, solar_pred_ada3)):.4f}")
print(f"R2 Score for AdaBoost: {r2_score(y_test, solar_pred_ada3):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - AdaBoost - Manual Hyperparameter Tuning")
sns.residplot(x=solar_pred_ada3, y=y_test, lowess=True, color="red")
plt.show()


# Random Forest
solar_rf3 = RandomForestRegressor(n_estimators = 100, max_depth = None, min_samples_split = 3, criterion = "mse", random_state = random_seed)
solar_rf3.fit(x_train, y_train)
solar_pred_rf3 = solar_rf3.predict(x_test)


# Scoring
print(f"------SCORING------")
print(f"Scoring on Training: {solar_rf3.score(x_train, y_train):.4f}")      
print(f"Scoring on Testing: {solar_rf3.score(x_test, y_test):.4f}")
print(f"\n")

# Accuracy
print(f"------ACCURACY------")
print(f"Overall Training Accuracy for Random Forest: {solar_rf3.score(x_train, y_train).mean():.4f}")
print(f"Overall Testing Accuracy for Random Forest: {solar_rf3.score(x_test, y_test).mean():.4f}")
print(f"\n")

# Performance
print(f"------PERFORMANCE------")
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, solar_pred_rf3)):.4f}")
print(f"R2 Score for Random Forest: {r2_score(y_test, solar_pred_rf3):.4f}")
print(f"\n")

plt.figure(figsize=[10,4])
plt.title("Predicted vs Actual - Grid Search Random Forest - 5-Fold Cross-Validation")
sns.residplot(x=solar_pred_rf3, y=y_test, lowess=True, color="blue")
plt.show()


#-------------------------
# BEST MODEL
#-------------------------
best_rf = RandomForestRegressor(min_samples_split=6, n_estimators=200, criterion="mae", random_state=random_seed)
best_rf.fit(x_train, y_train)
pred_brf = best_rf.predict(x_test)
print(f"RMSE for Random Forest: {math.sqrt(mean_squared_error(y_test, pred_brf)):.4f}")

# Feature Importances
feature_importances_rf = pd.DataFrame(best_rf.feature_importances_,index = solar_attr.columns, columns=['Importance'])\
                        .sort_values('Importance',ascending=False)


# Export to CSV
feature_importances_rf.to_csv("featureImportance_solar.csv")

#-------------------------
# PREDICTIONS - SCENARIO
#-------------------------
# Predicting Dates
march15 = solar_scenario[solar_scenario["Date_Time"] == "03/15/91"].drop(columns=["Date_Time"])
june26 = solar_scenario[solar_scenario["Date_Time"] == "06/26/91"].drop(columns=["Date_Time"])
july3 = solar_scenario[solar_scenario["Date_Time"] == "07/03/91"].drop(columns=["Date_Time"])
october13 = solar_scenario[solar_scenario["Date_Time"] == "10/13/91"].drop(columns=["Date_Time"])
november19 = solar_scenario[solar_scenario["Date_Time"] == "11/19/91"].drop(columns=["Date_Time"])
december25 = solar_scenario[solar_scenario["Date_Time"] == "12/25/91"].drop(columns=["Date_Time"])

# Prediction Using the Random Forest Model
pred_march15 = best_rf.predict(march15)
pred_june26 = best_rf.predict(june26)
pred_july3 = best_rf.predict(july3)
pred_october13 = best_rf.predict(october13)
pred_november19 = best_rf.predict(november19)
pred_december25 = best_rf.predict(december25)

print(f"Prediction of Solar Production for March 15th Using Random Forest: {pred_march15}")
print(f"Prediction of Solar Production for June 26th Using Random Forest: {pred_june26}")
print(f"Prediction of Solar Production for July 3rd Using Random Forest: {pred_july3}")
print(f"Prediction of Solar Production for October 13th Using Random Forest: {pred_october13}")
print(f"Prediction of Solar Production for November 19th Using Random Forest: {pred_november19}")
print(f"Prediction of Solar Production for December 25th Using Random Forest: {pred_december25}")

scenario_df = pd.DataFrame(best_rf.predict(solar_scenario.drop(columns=["Date_Time"])), index=solar_scenario["Date_Time"], columns=["Predicted"])

# Export to CSV
scenario_df.to_csv("predicted_electricity_solar.csv")

plt.figure(figsize=[20,10])
plt.xticks(np.arange(1,365, step=30))
plt.title("Predicted Mean Solar Electricity for Scenario Year", fontsize=18)
plt.ylabel("kW/Hr", fontsize=14)
sns.lineplot(x=scenario_df.index, y=scenario_df.Predicted, color="red")
plt.show()
