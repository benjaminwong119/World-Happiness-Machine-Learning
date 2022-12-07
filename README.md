# World-Happiness-Machine-Learning

##Introduction

Happiness is something that everyone seeks and the definition of happiness varies from one person to another. Our group wanted to analyze what factors contribute to what people call happiness. We analyzed data from the World Happiness Report, which uses global survey data to report how people evaluate their own lives in more than 150 countries worldwide. Our data can be found in this Kaggle link: https://www.kaggle.com/datasets/unsdsn/world-happiness?datasetId=894&sortBy=voteCount&language=R&outputs=Visualization. In the data, we have the score of how happy that country was at a given year and several predictors. The predictors are GDP per capita, social support, healthy life expectancy, freedom to make life choices, generosity, and perceptions of corruption. Our target audience is every individual person as finding happiness should be everyone's goal in life. In addition to this, leaders of countries such as government officials and businesses such as insurance companies will also benefit from this analysis as they can find what factors impact happiness.

##Dataset

We combined the world happiness data from 2015 to 2021 together into one big dataset so we have enough data to perform machine learning models on it. Combining the dataset included some difficulties due to using datasets throughout multiple years. Our first step in the data cleaning process was to ensure all of the individual year datasets had the same column names. We then removed the additional columns that were present in some years but not others, such as upper whisker, lower whisker, and logged GDP per capita. We also removed the country name, region, and ranking of the country as those would not be helpful in our models. The only columns we kept were the predictors on our dataset, which are the values that show how much the happiness score was affected by the predictors. We then removed the column labeled as dystopian residual. This is used to benchmark every country so that no country can perform worse than the dystopia. As it is used as a benchmark tool, we have decided to remove it as a predictor. After we removed all of the columns and combined the data into one large dataset, we found that there were 1084 rows and 7 columns. We removed any NaN values and found that it removed 1 row, therefore ending up with 1083 rows and 7 columns. Our final step in the data cleaning process was to change Perceptions of corruption to a numeric value as the NaN value made R think it was a string. A screenshot of the data can be found in Figure 1. Since the data were all of the same scale, we did not take any further steps in cleaning it.

##Exploratory Data Analysis

After cleaning and combining the data, we decided to do exploratory data analysis. We used a pairwise scatterplot to understand the pairwise relationship between variables which can be seen in Figure 2. We found that the happiness score was positively correlated with GDP per capita, social support, healthy life expectancy, and freedom to make life choices. We also saw that GDP per capita, social support, and healthy life expectancy had a positive correlation between each other. We then did a correlation plot using the package corrplot to find the correlation values, shown in Figure 6. 

##Models Used

For the project, we wanted to answer two questions: which factors contribute to happiness, and which factors contribute to a higher than average happiness. For the first question, we used linear regression and a regression tree. For the second question, we used logistic regression and classification tree.


##Linear Regression

	For our first question, our first model that we used is linear regression. We immediately used multiple linear regression as we knew that happiness is not as simple as being explained by one predictor. As we are doing a regression model, we were worried about multicollinearity due to the strong correlation. When we used the vif function in R, it showed that the VIF was between 1.15 and 2.8 for all of the predictors. Since the values don’t exceed 5, we did not have to worry about multicollinearity. 
We built four multiple linear regression models and used cross-validation models. We also decided to have set the threshold of p value to 0.001. For our first model, we wanted to start off with setting our predictors as all of them. We found that all predictors were statistically significant, the adjusted R squared was 0.7531, and the cross validation MSE was 0.3114822. 
For our next model, we wanted to see if there were any interaction effects and if it would be an improvement to our model. We still used all of the predictors but included interaction between GDP per capita, Social support, and Healthy life expectancy. The model showed Healthy life expectancy, Freedom to make life choices, and Social support:Healthy life expectancy were statistically significant. The adjusted R square is 0.7623 and the cross validation MSE is 0.301665.
For the third model, we limited the interaction effect to only Social support and Healthy life expectancy to see if it would be a better model. The adjusted R square is 0.7593 and the cross validation MSE is 0.3036722. For the last model, we wanted to simplify the model and only used GDP per capita, Freedom to make life choices, and Healthy life expectancy as our predictors. The resulting adjusted R square is 0.733 and the cross validation MSE is 0.3332559.
When we compared our linear regression models, we chose our second model as the best due to the higher adjusted R squared and lower MSE, as seen in Figure 7.

##Regression Tree:   

Our other regression model that we used was the regression tree, shown in Figure 3. We used cross validation to show the optimal size, which was 11. We then used bagging and random forest with mtry as 6 and 2 respectively. We used 6 for bagging since that is all of the predictors and 2 for random forest 6/3 = 2. With bagging, we found that the MSE was 0.2662822 and for random forest, the MSE was 0.2581971. The random was better due to the lower MSE, and showed GDP per capita, Healthy life expectancy, Freedom to make life choices, and Perception of corruption were the most important, shown in the left side of Figure 4. The right side of Figure 4 shows how well the tree was split based on the Gini index. We chose random forest as the better model due to the lower MSE.

##Model comparison - Regression

When we compared the regression models, we found that the random forest model performed better than the linear regression model due to the lower MSE, shown in Figure 8.

##Logistic Regression:

For our classification problem, we changed the happiness score to High and Low based on average. We then used the same models for logistic regression as the first 3 models used for linear regression. For our first model where we used all of the predictors, the precision was 0.79, the recall was 0.96, and the cross-validation accuracy was 0.873106. For the second model, we found that the precision was 0.8, the recall was 0.95, and the cross-validation accuracy was 0.8695836. In the third model, the precision was 0.8, the recall was 0.96, and the cross-validation accuracy was 0.8688962. 
When we compared our logistic regression models, we saw that all of the models performed somewhat the same, as seen on Figure 9. We decided on the first model being the best model due to the simplicity of the model, therefore having the least bias. For the first model, we found that GDP per capita, Social support, Healthy life expectancy, and Freedom to make life choices were statistically significant. We also found that out of these variables, Social support affected happiness the most led by GDP per capita, as shown in Figure 10.

##Classification Tree:

Our other classification model that we used was the classification tree, shown in Figure 5. We used cross validation and found that 8 terminal nodes was the best. For the classification tree, the precision was 0.752, the recall was 0.921568, and the accuracy was 0.8202765. Based on the tree, GDP per capita, Health life expectancy, and freedom to make life choices were the most important predictors.


##Model comparison - classification

We chose the logistic regression model as the better model due to the higher accuracy, as shown in Figure 11.

##Conclusion

While defining happiness and attaining it is a challenge, we hope this research provided some guidance in doing so. We found that the most important factors that affect happiness are GDP per capita, Freedom to make life choices, Health life expectancy, and Perceptions of corruption in that order. It seems like factors such as where you live affect happiness more than the other factors such as Social support and Generosity. When we shift the focus to being happier than the average, we found the most important factors were Social support and GDP per capita. This shows that to be happier than the average, Social support plays more of a factor than directly affecting happiness. Even then, GDP per capita plays a significant part in both scenarios. 
While this goes against the old saying, “you can’t buy happiness”, our model and data shows otherwise. While you can’t directly buy happiness with money, it certainly affects it. 
