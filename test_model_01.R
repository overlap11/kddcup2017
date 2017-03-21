table3 <- read.csv("../data/train/links (table 3).csv", header = T)
table4 <- read.csv("../data/train/routes (table 4).csv", header=T)
table5 <- read.csv("../data/train/trajectories(table 5)_training.csv", header=T)
table6 <- read.csv("../data/train/weather (table 7)_training_update.csv", header=T)

head(table5)
head(table6)

dat <- read.csv("dm_traj_train.csv", header=TRUE)
dat$tollgate_id <- as.factor(dat$tollgate_id)
dat$month <- as.factor(dat$month)
dat$week <- as.factor(dat$week)
dat$dow <- as.factor(dat$dow)
summary(dat)

dat2 <- na.omit(dat)
head(dat2)
matrix(colnames(dat2))

y <- dat2$avg_travel_time
X <- dat2[,c(1,2,7,8,10,12:ncol(dat2))]
summary(X)

dat3 <- data.frame(y, X)
head(dat3)

mdl <- glm(y~., data=dat3)
mdl2 <- step(mdl)
summary(mdl2)


set.seed(123)
smpl <- sample(1:nrow(dat3), nrow(dat3)*0.8)
dat.train <- dat3[smpl,]
dat.test <- dat3[-smpl,]

mdl <- glm(y~., data=dat.train)
mdl2 <- step(mdl)
summary(mdl2)

pred.train <- predict(mdl2, dat.train)
group.train <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[smpl]
tmp <- abs((pred.train - dat.train$y) / dat.train$y)
mape.train <- mean(tapply(tmp, group.train, mean))
#mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train

pred.test <- predict(mdl2, dat.test)
group.test <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[-smpl]
tmp <- abs((pred.test - dat.test$y) / dat.test$y)
mape.test <- mean(tapply(tmp, group.test, mean))
#mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test


plot(dat.train$y, pred.train, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

plot(dat.test$y, pred.test, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)


mdl <- glm(y~.*., data=dat.train)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train <- predict(mdl2, dat.train)
group.train <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[smpl]
tmp <- abs((pred.train - dat.train$y) / dat.train$y)
mape.train <- mean(tapply(tmp, group.train, mean))
#mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train

pred.test <- predict(mdl2, dat.test)
group.test <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[-smpl]
tmp <- abs((pred.test - dat.test$y) / dat.test$y)
mape.test <- mean(tapply(tmp, group.test, mean))
#mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test

plot(dat.train$y, pred.train, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

plot(dat.test$y, pred.test, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)


install.packages("randomForest")
library(randomForest)
mdl <- randomForest(y~.*., data=dat.train)

pred.train <- predict(mdl, dat.train)
group.train <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[smpl]
tmp <- abs((pred.train - dat.train$y) / dat.train$y)
mape.train <- mean(tapply(tmp, group.train, mean))
#mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train

pred.test <- predict(mdl, dat.test)
group.test <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[-smpl]
tmp <- abs((pred.test - dat.test$y) / dat.test$y)
mape.test <- mean(tapply(tmp, group.test, mean))
#mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test

plot(dat.train$y, pred.train, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

plot(dat.test$y, pred.test, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

#install.packages("xgboost")
library(xgboost)
help(xgboost)

#install.packages("dummy")
library(dummy)
#install.packages("dummies")
library(dummies)

dim(dummy.data.frame(dat.train[,-1]))
dim(dummy.data.frame(dat.test[,-1]))

dtrain <- xgb.DMatrix(as.matrix(dummy.data.frame(dat.train[,-1])), label=dat.train[,1])
dtest <- xgb.DMatrix(as.matrix(dummy.data.frame(dat.test[,-1])), label=dat.test[,1])
watchlist <- list(eval=dtest, train=dtrain)

param <- list(eta=0.01, max_depth=6)
mdl <- xgb.train(data=dtrain, nrounds=5000, watchlist = watchlist, early_stopping_rounds = 10)
mdl$best_score
plot(mdl$evaluation_log$eval_rmse, xlim=c(0,1400), ylim=c(0,110))
par(new=T)
plot(mdl$evaluation_log$train_rmse, xlim=c(0,1400), ylim=c(0,110))

pred.train <- predict(mdl, dtrain)
group.train <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[smpl]
tmp <- abs((pred.train - dat.train$y) / dat.train$y)
mape.train <- mean(tapply(tmp, group.train, mean))
#mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train

pred.test <- predict(mdl, dtest)
group.test <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[-smpl]
tmp <- abs((pred.test - dat.test$y) / dat.test$y)
mape.test <- mean(tapply(tmp, group.test, mean))
#mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test

plot(dat.train$y, pred.train, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

plot(dat.test$y, pred.test, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)


mdl <- randomForest(log(y)~.*., data=dat.train)

pred.train <- exp(predict(mdl, dat.train))
group.train <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[smpl]
tmp <- abs((pred.train - dat.train$y) / dat.train$y)
mape.train <- mean(tapply(tmp, group.train, mean))
#mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train

pred.test <- exp(predict(mdl, dat.test))
group.test <- paste(dat2$intersection_id, dat2$tollgate_id, sep="-")[-smpl]
tmp <- abs((pred.test - dat.test$y) / dat.test$y)
mape.test <- mean(tapply(tmp, group.test, mean))
#mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test

plot(dat.train$y, pred.train, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

plot(dat.test$y, pred.test, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)
