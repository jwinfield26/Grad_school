/************************************
CSC 423 - Data Analysis and Regression
Final Project - Winter 2018
By: Justin Winfield
*************************************/

*#Import dataset;
*proc import datafile = "S:\CSC 423\Final Project\JustinWinfield_LifeExpectacyData.csv" out=lifeExpect replace;
proc import datafile = "JustinWinfield_LifeExpectacyData.csv" out=lifeExpect replace;
delimiter = ",";
getnames;
run;

proc print data=lifeExpect (obs=50);
run;

*#Creating dummy variable for Status - Developed will be the baseline
*#Creating another dummy variable for Region - North America will be the baseline:
		Asia
		Middle East
		Europe
		South America
		Sub-Saharhan Africa
		Oceania
		Central American & Caribbean
*#Adding Interaction Variable
	Hepatitis B and Polio3 immunization;
data updateLifeExpect;
set lifeExpect;
d_status=(Status="Developed");
d_Asia=(Region="Asia");
d_MiddleEast=(Region="Middle East");
d_SouthAmerica=(Region="South Ameri");
d_SubAfrica=(Region="Sub Saharan");
d_Oceania=(Region="Oceania");
d_Europe=(Region="Europe");
d_Central=(Region="Central Ame");
iv_HepBPol3=Hepatitis_B*Polio;
run;

proc print data=updateLifeExpect; *Print the first 50 observations;
run;

*Exploratory Analysis;

*Creating Histogram for Life Expectancy;
title "Histogram for Life Expectancy";
proc univariate data=updateLifeExpect;
var Life_expectancy;
histogram/normal(mu=est sigma=est);
run;

*Creating scatterplots between Life Expectancy and all predictors, excluding dummy variables;
title "Scatterplots: Life Expectancy Between All Predictors";
proc gplot data=updateLifeExpect;
plot Life_Expectancy*(Status Adult_Mortality infant_deaths Alcohol
percentage_expenditure Hepatitis_B Measles _BMI under_five_deaths Polio
Total_expenditure Diphtheria _HIV_AIDS GDP Population _thinness__1_19_years
_thinness_5_9_years Income_composition_of_resources Schooling Region iv_HepBPol3);
run;
quit;

*Boxplots between Status, Region, and Life Expectancy;

*Sort the data first;
proc sort;
by d_status;
run;
proc sort;
by d_Asia;
run;
proc sort;
by d_MiddleEast;
run;
proc sort;
by d_SouthAmerica;
run;
proc sort;
by d_SubAfrica;
run;
proc sort;
by d_Central;
run;
proc sort;
by d_Oceania;
run;
proc sort;
by d_Europe;
run;
proc boxplot;
title "Boxplot between Life Expectancy and Development Status";
plot Life_Expectancy*d_status;
run;
proc boxplot;
title "Boxplot beteeen Life Expectancy and Asia";
plot Life_Expectancy*d_Asia;
run;
proc boxplot;
title "Boxplot between Life Expectancy and Middle East, North Africa";
plot Life_Expectancy*d_MiddleEast;
run;
proc boxplot;
title "Boxplot between Life Expectancy and South America";
plot Life_Expectancy*d_SouthAmerica;
run;
proc boxplot;
title "Boxplot between Life Expectancy and Sub-Saharan Africa";
plot Life_Expectancy*d_SubAfrica;
run;
proc boxplot;
title "Boxplot betweeen Life Expectancy and Central American & Caribbean";
plot Life_Expectancy*d_Central;
run;
proc boxplot;
title "Boxplot between Life Expectancy and Australia & Oceania";
plot Life_Expectancy*d_Oceania;
run;
proc boxplot;
title "Boxplot between Life Expectancy and Central American & Caribbean";
plot Life_Expectancy*d_Europe;
run;

*#Create correlation matrices to check between the different predictors;
proc corr data=updateLifeExpect;
title "Pearson Correlation Matrix between Life Expectancy and all Predictors";
var Life_Expectancy Adult_Mortality infant_deaths Alcohol
percentage_expenditure Hepatitis_B Measles _BMI under_five_deaths Polio
Total_expenditure Diphtheria _HIV_AIDS GDP Population _thinness__1_19_years
_thinness_5_9_years Income_composition_of_resources Schooling d_status
d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Central d_Oceania
d_Europe iv_HepBPol3;
run;

*#Run the full model
 #Removed infant_deaths and under_five_deaths since Correlation between is nearly perfect (0.99663)
 #Check for outliers & influential points;
proc reg data=updateLifeExpect;
title "Regression Analysis on Full Model Life Expectancy";
model Life_Expectancy = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Measles _BMI Polio Total_expenditure Diphtheria _HIV_AIDS GDP Population
_thinness__1_19_years _thinness_5_9_years Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Central d_Oceania
d_Europe iv_HepBPol3/influence r;
run;
quit;

*Removing outlier and influential points from dataset where Cook's D > 0.002
and the residuals are outside the [-3,3] band;
data cleanLifeExpect;
set updateLifeExpect;
if _n_=14 then delete;
if _n_=16 then delete;
if _n_=55 then delete;
if _n_=75 then delete;
if _n_=76 then delete;
if _n_=77 then delete;
if _n_=78 then delete;
if _n_=79 then delete;
if _n_=124 then delete;
if _n_=133 then delete;
if _n_=196 then delete;
if _n_=242 then delete;
if _n_=243 then delete;
if _n_=300 then delete;
if _n_=317 then delete;
if _n_=331 then delete;
if _n_=332 then delete;
if _n_=410 then delete;
if _n_=453 then delete;
if _n_=462 then delete;
if _n_=491 then delete;
if _n_=502 then delete;
if _n_=504 then delete;
if _n_=506 then delete;
if _n_=547 then delete;
if _n_=548 then delete;
if _n_=568 then delete;
if _n_=569 then delete;
if _n_=570 then delete;
if _n_=571 then delete;
if _n_=632 then delete;
if _n_=641 then delete;
if _n_=760 then delete;
if _n_=836 then delete;
if _n_=856 then delete;
if _n_=858 then delete;
if _n_=864 then delete;
if _n_=889 then delete;
if _n_=938 then delete;
if _n_=939 then delete;
if _n_=940 then delete;
if _n_=978 then delete;
if _n_=994 then delete;
if _n_=998 then delete;
if _n_=1024 then delete;
if _n_=1028 then delete;
if _n_=1056 then delete;
if _n_=1057 then delete;
if _n_=1190 then delete;
if _n_=1193 then delete;
if _n_=1195 then delete;
if _n_=1238 then delete;
if _n_=1239 then delete;
if _n_=1383 then delete;
if _n_=1385 then delete;
if _n_=1386 then delete;
if _n_=1469 then delete;
if _n_=1473 then delete;
if _n_=1479 then delete;
if _n_=1494 then delete;
if _n_=1534 then delete;
if _n_=1540 then delete;
if _n_=1541 then delete;
if _n_=1543 then delete;
if _n_=1546 then delete;
if _n_=1548 then delete;
if _n_=1565 then delete;
if _n_=1574 then delete;
if _n_=1576 then delete;
if _n_=1581 then delete;
if _n_=1584 then delete;
if _n_=1715 then delete;
if _n_=1771 then delete;
if _n_=1775 then delete;
if _n_=1779 then delete;
if _n_=1851 then delete;
if _n_=1852 then delete;
if _n_=1880 then delete;
if _n_=1895 then delete;
if _n_=1904 then delete;
if _n_=1942 then delete;
if _n_=2057 then delete;
if _n_=2145 then delete;
if _n_=2150 then delete;
if _n_=2164 then delete;
if _n_=2213 then delete;
if _n_=2297 then delete;
if _n_=2299 then delete;
if _n_=2300 then delete;
if _n_=2301 then delete;
if _n_=2302 then delete;
if _n_=2303 then delete;
if _n_=2304 then delete;
if _n_=2305 then delete;
if _n_=2306 then delete;
if _n_=2323 then delete;
if _n_=2396 then delete;
if _n_=2406 then delete;
if _n_=2407 then delete;
if _n_=2434 then delete;
if _n_=2497 then delete;
if _n_=2499 then delete;
if _n_=2503 then delete;
if _n_=2504 then delete;
if _n_=2505 then delete;
if _n_=2727 then delete;
if _n_=2849 then delete;
if _n_=2853 then delete;
if _n_=2854 then delete;
if _n_=2855 then delete;
if _n_=2856 then delete;
if _n_=2857 then delete;
if _n_=2914 then delete;
if _n_=2931 then delete;
if _n_=2932 then delete;
if _n_=2935 then delete;
if _n_=2936 then delete;
if _n_=2937 then delete;
if _n_=2938 then delete;
run;

*#Splitting the dataset between training and test;
proc surveyselect data=cleanLifeExpect out=training seed=020688 samprate=0.75 outall;
title "Training Data @ 75%";
run;
proc print data=training (obs=100);
run;

data training;
set training;
if selected then train_y=Life_Expectancy;
run;
proc print data=training (obs=100);
run;

*#Run the full model
 #Check for Multicollinearity
 #Check for linearity, normality, constant variance, and independence;
proc reg data=training;
title "Regression Analysis on Life Expectancy (Training Data)";
model train_y = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Measles _BMI Polio Total_expenditure Diphtheria _HIV_AIDS GDP Population
_thinness__1_19_years _thinness_5_9_years Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Central d_Oceania
d_Europe iv_HepBPol3/vif stb;
plot npp.*student.;
plot student.*predicted.;
run;
quit;

*#Model selection with the adjusted model with the updated dataset.
	Leveraging Backward, and Stepwise;
proc reg data=training;
title "Regression Analysis on Life Expectancy - Model Selection";
model train_y = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Measles _BMI Polio Total_expenditure Diphtheria _HIV_AIDS GDP Population
_thinness__1_19_years _thinness_5_9_years Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Central d_Oceania
d_Europe iv_HepBPol3/selection=backward;

model train_y = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Measles _BMI Polio Total_expenditure Diphtheria _HIV_AIDS GDP Population
_thinness__1_19_years _thinness_5_9_years Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Central d_Oceania
d_Europe iv_HepBPol3/selection=stepwise;
run;
quit;

*#Run the final model
 #Output predicted values for test set--;
proc reg data=training;
title "Regression Analysis on Final Model Life Expectancy";
model train_y = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Total_expenditure Diphtheria _HIV_AIDS Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Oceania d_Europe iv_HepBPol3 /stb;
output out=outm1(where=(train_y=.)) p=yhat;
run;
quit;
proc print data=outm1;
run;
*Summarize final model results
Compute Predictive Statistics;
data sumOut;
set outm1;
diff=Life_Expectancy-yhat;
absdiff=abs(diff);
run;
proc print data=sumOut (obs=50);
run;
proc summary data=sumOut;
var diff absdiff;
output out=sumOutStats std(diff)=rmse mean(absdiff)=mae;
run;
proc print data=sumOutStats (obs=100);
title "Validation statistics for Model";
run;
proc corr data=outm1;
var Life_Expectancy yhat;
run;

*Make a prediction -
Adult Mortality = 70 per 1000, Alcohol = 10.5 liters, Percentage expenditure on health = 80%, Hepatitis B immunization coverage = 85,
Diphtheria immunization coverage = 75, HIV/AIDS death = 0.1 per 1000, total expenditure = 10%, income index = 0.75 schooling = 15 years,
Developing status, in the European region Immunization for both Hepatitis B and Polio is 6375 ;

data pred;
input Adult_Mortality Alcohol percentage_expenditure Hepatitis_B Total_expenditure Diphtheria _HIV_AIDS Income_composition_of_resources Schooling d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Oceania d_Europe iv_HepBPol3;
datalines;
70 10.5 45 85 25 70 0.1 0.75 15	0 0	0 0	0 0	1 6375

;
run;
proc print data=pred;
run;

data predLife;
set pred training;
run;
proc print data=predLife (obs=20);
run;

proc reg data=predLife;
model Life_Expectancy = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Total_expenditure Diphtheria _HIV_AIDS Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Oceania d_Europe iv_HepBPol3 /p cli alpha=0.05;
run;
quit;

data pred2;
input Adult_Mortality Alcohol percentage_expenditure Hepatitis_B Total_expenditure Diphtheria _HIV_AIDS Income_composition_of_resources Schooling d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Oceania d_Europe iv_HepBPol3;
datalines;
55 0.5 35 55 20 65 0.2 0.55 10 0 0 0 1 0 0 0 2500
;
run;
proc print data=pred2;
run;
data predLife2;
set pred2 training;
run;
proc print data=predLife2 (obs=20);
run;

proc reg data=predLife2;
model Life_Expectancy = Adult_Mortality Alcohol percentage_expenditure Hepatitis_B
Total_expenditure Diphtheria _HIV_AIDS Income_composition_of_resources Schooling
d_status d_Asia d_MiddleEast d_SouthAmerica d_SubAfrica d_Oceania d_Europe iv_HepBPol3 /p cli alpha=0.05;
run;
quit;
dm 'odsresults; clear'; *Clearing the Results;


