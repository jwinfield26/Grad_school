#Set Working Directory
setwd("/Users/justinwinfield/Box Sync/DePaul/Classes/CSC 424 - Advanced Data Analysis/Homework/Assignment 4")

#Load Libraries
library(readxl)
library(MASS)

p3.training <- read_excel("BondRating.xls", sheet = "training") #Reviewing the training dataset for Bond Rating

# Linear Discriminate Analysis
p3.training.LDA <- lda(p3.training$CODERTG ~ p3.training$LOPMAR + p3.training$LFIXCHAR + p3.training$LGEARRAT +
                         p3.training$LTDCAP + p3.training$LLEVER + p3.training$LCASHLTD + p3.training$LACIDRAT +
                         p3.training$LCURRAT + p3.training$LRECTURN + p3.training$LASSLTD, data=p3.training)
plot(p3.training.LDA)
p = predict(p3.training.LDA, newdata=p3.training[,4:13])$class

# Compare the results of the prediction
table(p, p3.training$CODERTG)

# Linear Discriminate Analysis on Validation Data
p3.validation <- read_excel("BondRating.xls", sheet = "validation") #Reviewing the validation dataset for Bond Rating

p3.validation$OBS <- NULL
p3.validation$RATING <- NULL
View(p3.validation)
cor(p3.validation)

# Removing highly correlated variabels
p3.validation$LGEARRAT <- NULL
p3.validation$LASSLTD <- NULL
p3.validation$LCASHLTD <- NULL


"p3.validation.LDA <- lda(p3.validation$CODERTG ~ p3.validation$LOPMAR + p3.validation$LFIXCHAR + p3.validation$LGEARRAT +
                           p3.validation$LTDCAP + p3.validation$LLEVER + p3.validation$LCASHLTD + p3.validation$LACIDRAT +
                           p3.validation$LCURRAT + p3.validation$LRECTURN + p3.validation$LASSLTD, data=p3.validation)"


p3.validation.LDA <- lda(p3.validation$CODERTG ~ p3.validation$LOPMAR + p3.validation$LFIXCHAR +
                           p3.validation$LTDCAP + p3.validation$LLEVER +  p3.validation$LACIDRAT +
                           p3.validation$LCURRAT + p3.validation$LRECTURN, data=p3.validation)

"p3.validation.LDA <- lda(p3.validation$CODERTG ~ ., data=p3.validation)"

plot(p3.validation.LDA)
p1 = predict(p3.validation.LDA, newdata1=p3.validation[,4:13])$class

# Compare the results of the prediction
table(p1, p3.validation$CODERTG)
