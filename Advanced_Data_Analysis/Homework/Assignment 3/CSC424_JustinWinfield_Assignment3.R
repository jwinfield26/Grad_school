#Set Working Directory
setwd("/Users/justinwinfield/Box Sync/DePaul/Classes/CSC 424 - Advanced Data Analysis/Homework/Assignment 3")

#Load libraries
library(ca)
library(CCA)
library(yacca)
library(MASS)
library(ggplot2)


###################################################################
# This is a nice function for computing the Wilks lambdas for 
# CCA data from the CCA library's method
# It computes the wilkes lambas the degrees of freedom and te 
# p-values
###################################################################

ccaWilks = function(set1, set2, cca)
{
  ev = ((1 - cca$cor^2))
  ev
  
  n = dim(set1)[1]
  p = length(set1)
  q = length(set2)
  k = min(p, q)
  m = n - 3/2 - (p + q)/2
  m
  
  w = rev(cumprod(rev(ev)))
  
  # initialize
  d1 = d2 = f = vector("numeric", k)
  
  for (i in 1:k) 
  {
    s = sqrt((p^2 * q^2 - 4)/(p^2 + q^2 - 5))
    si = 1/s
    d1[i] = p * q
    d2[i] = m * s - p * q/2 + 1
    r = (1 - w[i]^si)/w[i]^si
    f[i] = r * d2[i]/d1[i]
    p = p - 1
    q = q - 1
  }
  
  pv = pf(f, d1, d2, lower.tail = FALSE)
  dmat = cbind(WilksL = w, F = f, df1 = d1, df2 = d2, p = pv)
}

##################################################################################################
# PROBLEM 2 - Correspondence Analysis on our final project dataset

#Read in the data
final <- read.csv("divvy_sorted.csv", header=T, sep=",")
head(final, 3)
subFinal <- final[c(7,10)] #Subsetting the 3 categorical variables from the dataset. Won't be Gender at this time. 
head(subFinal, 3)

View(subFinal)
table.final <- table(subFinal, dnn=c("From_ID", "To_ID"))
table.final
margin.table(table.final, 2)
caFit <- ca(table.final)
summary(caFit)
plot(caFit)

##################################################################################################
# PROBLEM 5 - Canonical Correlation

#Read table
canon <- read.table("canon.txt", header=T, sep="\t")
upcanon <- canon[,2:10]
head(upcanon)

att <- upcanon[c("esteem", "control", "attmar", "attrole")]
health <- upcanon[c("timedrs", "attdrug", "phyheal", "menheal", "druguse")]
matcor(att, health)

ccCanon <- cc(att, health)
round(ccCanon$cor,4)
loadingCanon <- comput(att, health, ccCanon)
wilksCanon <- ccaWilks(att, health, ccCanon)
loadingCanon$corr.X.xscores
loadingCanon$corr.Y.yscores

##################################################################################################
# EXTRA CREDIT - Correspondence Analysis

library(vcd)
library(dplyr)
sports <- read.table("sports.csv", header=T, sep=",") 
head(sports)

