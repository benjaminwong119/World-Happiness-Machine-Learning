# World-Happiness-Machine-Learning

## Introduction

Happiness is something that everyone seeks and the definition of happiness varies from one person to another. I wanted to analyze what factors contribute to what people call happiness. I analyzed data from the World Happiness Report, which uses global survey data to report how people evaluate their own lives in more than 150 countries worldwide. The data can be found in this Kaggle link: https://www.kaggle.com/datasets/unsdsn/world-happiness?datasetId=894&sortBy=voteCount&language=R&outputs=Visualization. In the data, there is the score of how happy that country was at a given year and several predictors. The predictors are GDP per capita, social support, healthy life expectancy, freedom to make life choices, generosity, and perceptions of corruption. The target audience is every individual person as finding happiness should be everyone's goal in life. In addition to this, leaders of countries such as government officials and businesses such as insurance companies will also benefit from this analysis as they can find what factors impact happiness.

## Dataset

I combined the world happiness data from 2015 to 2021 together into one big dataset so there is enough data to perform machine learning models on it. Combining the dataset included some difficulties due to using datasets throughout multiple years. The first step in the data cleaning process was to ensure all of the individual year datasets had the same column names. I then removed the additional columns that were present in some years but not others, such as upper whisker, lower whisker, and logged GDP per capita. Other columns such as country name, region, and ranking of the country were removed as those would not be helpful in the models. The only columns that were kept were the predictors on the dataset, which are the values that show how much the happiness score was affected by the predictors. The column dystopian residual was also removed as this is used to benchmark every country so that no country can perform worse than the dystopia. As it is used as a benchmark tool, I have decided to remove it as a predictor. After all of the extra columns were removed and the data combined into one large dataset, there were 1084 rows and 7 columns. I then removed any NaN values and found that it removed 1 row, therefore ending up with 1083 rows and 7 columns. The final step in the data cleaning process was to change Perceptions of corruption to a numeric value as the NaN value made R think it was a string. A screenshot of the data can be found in Figure 1. Since the data were all of the same scale, no additional steps were needed in the cleaning process. 

## Exploratory Data Analysis

After cleaning and combining the data, I then decided to do exploratory data analysis. I used a pairwise scatterplot to understand the pairwise relationship between variables which can be seen in Figure 2. Based on the scatterplot, happiness score is positively correlated with GDP per capita, social support, healthy life expectancy, and freedom to make life choices. There is also a positive correlation between GDP per capita, social support, and healthy life expectancy. I then did a correlation plot using the package corrplot to find the correlation values, shown in Figure 6. 

## Models Used

For the project, I wanted to answer two questions: which factors contribute to happiness, and which factors contribute to a higher than average happiness. For the first question, I used linear regression and a regression tree. For the second question, I used logistic regression and classification tree.


## Linear Regression

For the first question, the first model that I used is linear regression. I opted for multiple linear regression as happiness is not as simple as being explained by one predictor. As a regression model is being used, multicollinearity should be checked for due to the strong correlation. When I used the vif function in R, it showed that the VIF was between 1.15 and 2.8 for all of the predictors. Since the values don’t exceed 5, multicollinearity is not a concern. 
I built four multiple linear regression models and used cross-validation models. I also decided to set the threshold of p value to 0.001. For the first model, I wanted to start off with setting the predictors as all of them. Based on the results, all of the predictors were statistically significant, the adjusted R squared was 0.7531, and the cross validation MSE was 0.3114822. 
For the next model, I wanted to see if there were any interaction effects and if it would be an improvement to the model. I still used all of the predictors but included interaction between GDP per capita, Social support, and Healthy life expectancy. The model showed Healthy life expectancy, Freedom to make life choices, and Social support:Healthy life expectancy were statistically significant. The adjusted R square is 0.7623 and the cross validation MSE is 0.301665.
For the third model, I limited the interaction effect to only Social support and Healthy life expectancy to see if it would be a better model. The adjusted R square is 0.7593 and the cross validation MSE is 0.3036722. For the last model, I wanted to simplify the model and only used GDP per capita, Freedom to make life choices, and Healthy life expectancy as the predictors. The resulting adjusted R square is 0.733 and the cross validation MSE is 0.3332559.
When comparing the linear regression models, the second model is the best due to the higher adjusted R squared and lower MSE, as seen in Figure 7.

## Regression Tree:   

The other regression model that was used was the regression tree, shown in Figure 3. I  used cross validation to show the optimal size, which was 11. I then used bagging and random forest with mtry as 6 and 2 respectively. I used 6 for bagging since that is all of the predictors and 2 for random forest 6/3 = 2. With bagging, the MSE was 0.2662822 and for random forest, the MSE was 0.2581971. The random was better due to the lower MSE, and showed GDP per capita, Healthy life expectancy, Freedom to make life choices, and Perception of corruption were the most important, shown in the left side of Figure 4. The right side of Figure 4 shows how well the tree was split based on the Gini index. Random forest is the better model due to the lower MSE.

## Model comparison - Regression

When comparing the regression models, the random forest model performed better than the linear regression model due to the lower MSE, shown in Figure 8.

## Logistic Regression:

For the classification problem, I changed the happiness score to High and Low based on the average. I then used the same models for logistic regression as the first 3 models used for linear regression. For the first model where I used all of the predictors, the precision was 0.79, the recall was 0.96, and the cross-validation accuracy was 0.873106. For the second model, the precision was 0.8, the recall was 0.95, and the cross-validation accuracy was 0.8695836. In the third model, the precision was 0.8, the recall was 0.96, and the cross-validation accuracy was 0.8688962. 
When comparing the logistic regression models, all of the models performed somewhat the same, as seen on Figure 9. I chose the first model as the best model due to the simplicity of the model, therefore having the least bias. For the first model, GDP per capita, Social support, Healthy life expectancy, and Freedom to make life choices were statistically significant. In addition to this, Social support affected happiness the most led by GDP per capita, as shown in Figure 10.

## Classification Tree:

The other classification model that was used was the classification tree, shown in Figure 5. I used cross validation and found that 8 terminal nodes were the best. For the classification tree, the precision was 0.752, the recall was 0.921568, and the accuracy was 0.8202765. Based on the tree, GDP per capita, Health life expectancy, and freedom to make life choices were the most important predictors.


## Model comparison - classification

I chose the logistic regression model as the better model due to the higher accuracy, as shown in Figure 11.

## Conclusion

While defining happiness and attaining it is a challenge, I hope this research provided some guidance in doing so. Based on the models, the most important factors that affect happiness are GDP per capita, Freedom to make life choices, Health life expectancy, and Perceptions of corruption in that order. It seems like factors such as where you live affect happiness more than the other factors such as Social support and Generosity. When focus shifts to being happier than the average, the most important factors were Social support and GDP per capita. This shows that to be happier than the average, Social support plays more of a factor than directly affecting happiness. Even then, GDP per capita plays a significant part in both scenarios. 
While this goes against the old saying, “you can’t buy happiness”, the models and data shows otherwise. While you can’t directly buy happiness with money, it certainly affects it. 
