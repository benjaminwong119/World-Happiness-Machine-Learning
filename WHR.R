rm(list = ls())
library(car)
library(tree)
library(randomForest)
library(corrplot)
set.seed(1)

#uploading data
wh_2015<-read.csv('2015.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))
wh_2016<-read.csv('2016.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))
wh_2017<-read.csv('2017.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))
wh_2018<-read.csv('2018.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))
wh_2019<-read.csv('2019.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))
wh_2020<-read.csv('2020.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))
wh_2021<-read.csv('2021.csv',header=T, , stringsAsFactors=FALSE,na.strings=c(NA,"NA","N/A"))

#removing extra columns
wh_2015=subset(wh_2015,select=-c(2:3,5,12))
wh_2016=subset(wh_2016,select=-c(2:3,5:6,13))
wh_2017=subset(wh_2017,select=-c(2,4:5,12))
wh_2018=subset(wh_2018,select=-c(1))
wh_2019=subset(wh_2019,select=-c(1))
wh_2020=subset(wh_2020,select=-c(2,4:13,20))
wh_2021=subset(wh_2021,select=-c(2,4:13,20))


#renaming columns so its all the same
names(wh_2015) <- c('Country.or.region'
                  , 'Score'
                  , 'GDP.per.capita'
                  , 'Social.support'
                  , 'Healthy.life.expectancy'
                  , 'Freedom.to.make.life.choices'
                  , 'Perceptions.of.corruption'
                  , 'Generosity')
wh_2015 = wh_2015[,c(1:6,8,7)]
names(wh_2016) <- c('Country.or.region'
                    , 'Score'
                    , 'GDP.per.capita'
                    , 'Social.support'
                    , 'Healthy.life.expectancy'
                    , 'Freedom.to.make.life.choices'
                    , 'Perceptions.of.corruption'
                    , 'Generosity')
wh_2016 = wh_2016[,c(1:6,8,7)]
names(wh_2017) <- c('Country.or.region'
                    , 'Score'
                    , 'GDP.per.capita'
                    , 'Social.support'
                    , 'Healthy.life.expectancy'
                    , 'Freedom.to.make.life.choices'
                    , 'Generosity'
                    , 'Perceptions.of.corruption')
names(wh_2018) <- c('Country.or.region'
                    , 'Score'
                    , 'GDP.per.capita'
                    , 'Social.support'
                    , 'Healthy.life.expectancy'
                    , 'Freedom.to.make.life.choices'
                    , 'Generosity'
                    , 'Perceptions.of.corruption')
names(wh_2019) <- c('Country.or.region'
                    , 'Score'
                    , 'GDP.per.capita'
                    , 'Social.support'
                    , 'Healthy.life.expectancy'
                    , 'Freedom.to.make.life.choices'
                    , 'Generosity'
                    , 'Perceptions.of.corruption')
names(wh_2020) <- c('Country.or.region'
                    , 'Score'
                    , 'GDP.per.capita'
                    , 'Social.support'
                    , 'Healthy.life.expectancy'
                    , 'Freedom.to.make.life.choices'
                    , 'Generosity'
                    , 'Perceptions.of.corruption')
names(wh_2021) <- c('Country.or.region'
                    , 'Score'
                    , 'GDP.per.capita'
                    , 'Social.support'
                    , 'Healthy.life.expectancy'
                    , 'Freedom.to.make.life.choices'
                    , 'Generosity'
                    , 'Perceptions.of.corruption')
#combining renamed datasets
happy=rbind(wh_2015,wh_2016,wh_2017,wh_2018,wh_2019,wh_2020,wh_2021)


happy=subset(happy,select=-c(1))#removed name column

dim(happy)
happy = na.omit(happy)#removed one row
dim(happy)

happy$Perceptions.of.corruption=as.numeric(as.character(happy$Perceptions.of.corruption))#change to numeric


summary(happy)
plot(happy)#happiness score is highly correlated with GDP per capita, social support, and healthy life expectancy based on pairwise plot

library(corrplot)
cor.happy = cor(happy)
corrplot(cor.happy, method = "number")

#Linear Regression
attach(happy)

M1 = lm(Score~., data = happy)
summary(M1) #Adjusted R-squared:  0.7531
vif(lm(Score ~., data=happy))
M2 = lm(Score~GDP.per.capita*Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption ,data = happy)
summary(M2) #Adjusted R-squared:  0.7623 
M3 = lm(Score~GDP.per.capita+Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption ,data = happy)
summary(M3) #Adjusted R-squared:  0.7593
M4 = lm(Score~GDP.per.capita+ Freedom.to.make.life.choices + Healthy.life.expectancy,data = happy)
summary(M4) #Adjusted R-squared:  0.733


#cross-validation
k=10
M1CVMSE=rep(0,k)
M2CVMSE=rep(0,k)
M3CVMSE=rep(0,k)
M4CVMSE=rep(0,k)

folds=sample(1:k,nrow(happy),replace=TRUE) 

for(j in 1:k)
{
  M1CV=lm(Score ~., data=happy[folds!=j,])
  M1CVMSE [j]=mean((Score-predict(M1CV,happy))[folds==j]^2)
}
for(j in 1:k)
{
  M2CV=lm(Score~GDP.per.capita*Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption ,data = happy[folds!=j,])
  M2CVMSE [j]=mean((Score-predict(M2CV,happy))[folds==j]^2)
}
for(j in 1:k)
{
  M3CV=lm(Score~GDP.per.capita+Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption ,data = happy[folds!=j,])
  M3CVMSE [j]=mean((Score-predict(M3CV,happy))[folds==j]^2)
}
for(j in 1:k)
{
  M4CV=lm(Score~GDP.per.capita+ Freedom.to.make.life.choices + Healthy.life.expectancy,data = happy[folds!=j,])
  M4CVMSE [j]=mean((Score-predict(M4CV,happy))[folds==j]^2)
}
MeanM1MSE=mean(M1CVMSE)#0.3114822
MeanM2MSE=mean(M2CVMSE)#0.301665 - lowest MSE
MeanM3MSE=mean(M3CVMSE)#0.3036722
MeanM4MSE=mean(M4CVMSE) #0.3332559


#hold out

train=sample(nrow(happy),nrow(happy)*0.8) 
happy.train=happy[train, ] #training data set
happy.test=happy[-train, ] #test data set
Score.test=Score[-train] #the response in the test set
M1train=lm(Score ~.,data=happy.train)
M2train=lm(Score~GDP.per.capita*Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption ,data=happy.train)
M3train = lm(Score~GDP.per.capita+Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption,data=happy.train)
M4train = lm(Score~GDP.per.capita+ Freedom.to.make.life.choices + Healthy.life.expectancy,data=happy.train)


Score.predictM1=predict(M1train,happy.test)
M1MSE=mean((Score.test-Score.predictM1)^2) #0.3478422
Score.predictM2=predict(M2train,happy.test)
M2MSE=mean((Score.test-Score.predictM2)^2)#0.3310864 - lowest MSE
Score.predictM3=predict(M3train,happy.test)
M3MSE=mean((Score.test-Score.predictM3)^2)#0.340156
Score.predictM4=predict(M4train,happy.test)
M4MSE=mean((Score.test-Score.predictM4)^2)#0.3744322


AIC(M1train)#1424.078
BIC(M1train)#1462.189
summary(M1train)#0.7527 

AIC(M2train)#1399.267 - 2nd model is the best model for linear regression
BIC(M2train)#1456.434
summary(M2train)#0.7608

AIC(M3train)#1402.682
BIC(M3train)#1445.557
summary(M3train)#0.759

AIC(M4train)#1487.716
BIC(M4train)#1511.536
summary(M4train)#0.7329

plot(predict(M2), residuals(M2))
plot(predict(M2), rstudent(M2))


#regression tree
rm(list=setdiff(ls(), "happy"))

tree.train = sample(1:nrow(happy), nrow(happy)/2)
tree.happy=tree(Score~.,happy,subset=tree.train)

#cross validation
cv.happy=cv.tree(tree.happy,K=10)
cv.happy #shows lowest RSS ($dev) is size 11

prune.happy=prune.tree(tree.happy,best=11)#prune tree to optimal size

plot(prune.happy)
text(prune.happy,pretty=0)

tree.test=happy[-tree.train,"Score"]
tree.pred=predict(prune.happy,newdata=happy[-tree.train,])
mean((tree.pred-tree.test)^2)#MSE: 0.3933115

#bagging
bag.happy=randomForest(Score~.,data=happy,subset=tree.train,mtry=6,importance=TRUE)
bag.happy #Mean of squared residuals: 0.2575878

yhat.bag = predict(bag.happy,newdata=happy[-tree.train,])
mean((yhat.bag-tree.test)^2) #MSE on testing dataset: 0.2662822

#random forest
rf.happy=randomForest(Score~.,data=happy,subset=tree.train,mtry=2,importance=TRUE)
yhat.rf = predict(rf.happy,newdata=happy[-tree.train,])
mean((yhat.rf-tree.test)^2) #MSE: 0.2581971

importance(rf.happy)#importance of each variable
varImpPlot(rf.happy)




#logistic regression
rm(list=setdiff(ls(), "happy"))
detach(happy)
happy1 <- data.frame(happy)
happy1$Score <- factor(happy1$Score> mean(happy1$Score), levels=c(TRUE,FALSE),labels=c("High", "Low"))
rm(list=setdiff(ls(), "happy1"))
attach(happy1)

happy1.train=sample(nrow(happy1),nrow(happy1)*0.8) 
happy1.test=happy1[-happy1.train, ] 
Score1.truevalue=Score[-happy1.train] #the response in the test set

glm.fit=glm(Score~., data=happy1, subset=happy1.train,family ="binomial")
summary(glm.fit)

glm.probs=predict(glm.fit,happy1.test, type="response") 
glm.pred=rep("High",217) 
glm.pred[glm.probs>.5]="Low"
table(glm.pred,Score1.truevalue) #confusion matrix, precision: 0.79838, recall: 0.961165
mean(glm.pred==Score1.truevalue) #accuracy: 0.8663594

coef(glm.fit)
exp(coef(glm.fit))#calculate odds ratio of the coefficients

glm.fit1=glm(Score~GDP.per.capita*Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption, data=happy1, subset=happy1.train,family ="binomial")
summary(glm.fit1)

glm.probs1=predict(glm.fit1,happy1.test, type="response") 
glm.pred1=rep("High",217) 
glm.pred1[glm.probs1>.5]="Low"
table(glm.pred1,Score1.truevalue) #confusion matrix, precision: 0.8099, recall: 0.951456
mean(glm.pred1==Score1.truevalue) #accuracy: 0.8709677


glm.fit2=glm(Score~GDP.per.capita+Social.support*Healthy.life.expectancy +Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption, data=happy1, subset=happy1.train,family ="binomial")
summary(glm.fit2)

glm.probs2=predict(glm.fit2,happy1.test, type="response") 
glm.pred2=rep("High",217) 
glm.pred2[glm.probs2>.5]="Low"
table(glm.pred2,Score1.truevalue) #confusion matrix, precision: 0.811475, recall: 0.961165
mean(glm.pred2==Score1.truevalue) #accuracy:  0.875576

#cross validation:
k=10
folds=sample(1:k,nrow(happy1),replace=TRUE) 
accuracy1=rep(0,k)
accuracy2=rep(0,k) 
accuracy3=rep(0,k) 

for(i in 1:k) 
{ 
  cvglm.fit1=glm(Score~.,family="binomial",data=happy1[folds!=i,]) 
  cvhappy1.test=happy1[folds==i, ] 
  cvglm.probs1 =predict(cvglm.fit1,cvhappy1.test, type="response") 
  cvglm.pred1=rep("High",nrow(cvhappy1.test)) 
  cvglm.pred1[cvglm.probs1>.5]="Low" 
  
  cvtest1.truevalue=happy1$Score[folds==i] 
  accuracy1[i]=mean(cvglm.pred1==cvtest1.truevalue) 
}
for(i in 1:k) 
{ 
  cvglm.fit2=glm(Score~GDP.per.capita*Social.support*Healthy.life.expectancy + Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption, family="binomial",data=happy1[folds!=i,]) 
  cvhappy2.test=happy1[folds==i, ] 
  cvglm.probs2 =predict(cvglm.fit2,cvhappy2.test, type="response") 
  cvglm.pred2=rep("High",nrow(cvhappy2.test)) 
  cvglm.pred2[cvglm.probs2>.5]="Low" 
  
  cvtest2.truevalue=happy1$Score[folds==i] 
  accuracy2[i]=mean(cvglm.pred2==cvtest2.truevalue) 
}
for(i in 1:k) 
{ 
  cvglm.fit3=glm(Score~GDP.per.capita+Social.support*Healthy.life.expectancy +Freedom.to.make.life.choices + Generosity + Perceptions.of.corruption,family="binomial",data=happy1[folds!=i,]) 
  cvhappy3.test=happy1[folds==i, ] 
  cvglm.probs3 =predict(cvglm.fit3,cvhappy3.test, type="response") 
  cvglm.pred3=rep("High",nrow(cvhappy3.test)) 
  cvglm.pred3[cvglm.probs3>.5]="Low" 
  
  cvtest3.truevalue=happy1$Score[folds==i] 
  accuracy3[i]=mean(cvglm.pred3==cvtest3.truevalue) 
}
mean(accuracy1) # 0.873106
mean(accuracy2) # 0.8695836
mean(accuracy3) # 0.8688962

#classification tree
rm(list=setdiff(ls(), "happy1"))

tree1.train=sample(nrow(happy1),nrow(happy1)*0.8)
tree1.model=tree(Score~.,happy1,subset =tree1.train)
ct.happy1.test=happy1[-tree1.train,]
ct.Score.test=happy1$Score[-tree1.train]

#cross validation
cv.ct.model=cv.tree(tree1.model,K=10,FUN=prune.misclass)
cv.ct.model #8 is best

prune.model=prune.tree(tree1.model,best=8) #best = # of terminal nodes (optimal size with lowest $dev)
plot(prune.model)
text(prune.model,pretty=0)

prunetree.pred=predict(prune.model,ct.happy1.test,type="class")
table(prunetree.pred,ct.Score.test) #precision: 0.752, recall: 0.921568
mean(prunetree.pred==ct.Score.test) #accuracy: 0.8202765

