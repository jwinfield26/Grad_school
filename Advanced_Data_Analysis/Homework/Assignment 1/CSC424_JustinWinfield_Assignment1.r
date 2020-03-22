#Problem 2
Z <- matrix(c(1,1,1,1,4,2,-5,8), ncol=2)
Y <- matrix(c(-1,1,3,2), ncol=1)
M <- matrix(c(1,20,0,5,10,15,0,5,5), ncol=3)
N <- matrix(c(-20,-5,0,0,20,5,20,10,20), ncol=3)
v <-  matrix(c(-4,4,8), ncol=1)
w <-  matrix(c(-5,-1,3), ncol=1)

#part A
t(v) %*% w
#part B
-3 * w
#part C
M * as.vector(v)
#part D
M + N
#part E
M - N
#part F
transposeZ <- t(Z)
#part G
transposeZ %*% Z
#part H
productZ <- transposeZ%*%Z
diag(nrow(productZ))
#part I
transposeZ %*% Y
#part J
I <- diag(nrow(productZ))
productZ %*% I
#part K
det(productZ)


#Problem 4
#Part A
library(car)
library(MASS)
housing <- read.table("~/Box Sync/DePaul/Classes/CSC 424 - Advanced Data Analysis/Homework/Assignment 1/housedata.csv", sep=",", header=TRUE)
head(housing)
View(housing)
#allVariables <- paste('price ~', paste(names(housing)[-3], collapse=' + '))
#allVariables
fullModel <- lm(price ~ bedrooms + bathrooms + sqft_living + sqft_lot + floors + waterfront + view + condition + grade + sqft_above + sqft_basement + yr_built + yr_renovated + zipcode + lat + long + sqft_living15 + sqft_lot15, data=housing)
vif(fullModel)
alias(fullModel)

#Removed sqft_living, sqft_above, and sqft_lot15 from model
fullModel2 <- lm(price ~ bedrooms + bathrooms + sqft_lot + floors + waterfront + view + condition + grade + sqft_basement + yr_built + yr_renovated + zipcode + lat + long + sqft_living15, data=housing)
vif(fullModel2)

#Part B - 1
summary(fullModel2)


#Part B - 2
null <- lm(price ~ 1, data=housing)
forwardSelection <- step(null, scope = list(lower=null, upper=fullModel2), direction="forward")
summary(forwardSelection)
boxplot(housing$price ~ housing$zipcode)
