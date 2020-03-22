#Set Workding Directory
setwd("~/Box Sync/DePaul/Classes/CSC 424 - Advanced Data Analysis/Homework/Assignment 2")
#Load libraries
library(corrplot)
library(psych)
library(ggplot2)
source("PCA_Plot.R") #Loading function found in working directory

#######################################################################################################################
#Problem 5
bfi <- read.csv("bfi.csv", header=T, sep=",")
head(bfi)
View(bfi)
bfi.mod <- bfi[, 2:26]
bfi.mod.remove <- na.omit(bfi.mod) #Remove all the NAs in the dataset
complete.cases(bfi.mod.remove)
head(bfi.mod.remove)
cor.bfi <- cor(bfi.mod.remove)
corrplot(cor.bfi, method="color")
pbfi <- prcomp(bfi.mod.remove, center=T, scale=F)
summary(pbfi)
plot(pbfi)
pbfi2 <- psych::principal(bfi.mod.remove, rotate = "varimax", nfactors = 5, scores=TRUE)
pbfi2
print(pbfi2$loadings, cutoff=0.4, sort=T)

#Creating and obtaining the scores for each principal component
scores_df <- data.frame(bfi.mod.remove[,1], pbfi2$scores[, 1:5])
View(scores_df)
scorePC <- matrix(c(min(scores_df[2]), max(scores_df[2]), 
               min(scores_df[3]), max(scores_df[3]), 
               min(scores_df[4]), max(scores_df[4]), 
               min(scores_df[5]), max(scores_df[5]), 
               min(scores_df[6]), max(scores_df[6])), ncol=2, byrow=TRUE)
colnames(scorePC) <- c("Min", "Max")
rownames(scorePC) <- c("PC2", "PC1", "PC3", "PC5", "PC4")
print(scorePC)

#Common Factor Analysis
fitFact <- factanal(bfi.mod.remove, 5)
print(fitFact$loadings, cutoff=.4, sort=T)

#######################################################################################################################
#Problem 6
census <- read.csv("census2.csv", header=TRUE, sep=",")
head(census)
censusMod <- census[, 2:5]
head(censusMod)

p.cen <- prcomp(censusMod, scale=F)
summary(p.cen)
plot(p.cen)

#Modify MedianHomeVal to be scaled down by 100,000
attach(censusMod)
censusMod$MedianHomeVal <- censusMod$MedianHomeVal/100000
detach(censusMod)
head(censusMod)

p.cen1 <- prcomp(censusMod, scale=TRUE)
summary(p.cen1)
plot(p.cen1)

cor.census <- cor(censusMod)
corrplot(cor.census, method="number")

#######################################################################################################################
#Problem 7
doc <- read.csv("GSS_2002_Health_PCA.csv", header=T, sep=",")
head(doc)
View(doc)
doc1 <- doc[2:37]
head(doc1)
cor.doc <- cor(doc1)
corrplot(cor.doc, method="color") #There are some variables that have weak correlation. We will need to remove them

#Removing variables with weak correlation
doc1.strong <- doc1[c(1:6, 13, 17:24, 26:34)]
head(doc1.strong)
corrplot(cor(doc1.strong), method="color")

#Principal Component Analysis
p.doc <- prcomp(doc1.strong, scale=T)
summary(p.doc)
plot(p.doc)
abline(1,0)
p.doc1 <- psych::principal(doc1.strong, rotate = "varimax", nfactors = 3, scores = T)
p.doc1
print(p.doc1$loadings, cutoff = 0.4, sort = T)

#Common Factor Analysis
fitDoc <- factanal(doc1.strong, 3)
print(fitDoc$loadings, cutoff=.4, sort=T)
