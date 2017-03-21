dat <- read.csv("dm_travel_time_01.csv", header=TRUE)
dat$tollgate_id <- as.factor(dat$tollgate_id)
dat$month <- as.factor(dat$month)
dat$hour <- as.factor(dat$hour)
dat$minute <- as.factor(dat$minute)
dat$week <- as.factor(dat$week)
dat$dow <- as.factor(dat$dow)
summary(dat)


tmp_date <- unique(dat$date)
test_date <- sample(tmp_date, length(tmp_date) * 0.2)

dat$date == test_date & (dat$hour == 8 | dat$hour == 9 | dat$hour == 17 | dat$hour == 18)
dat.test <- dat[dat$date %in% test_date & (dat$hour == 8 | dat$hour == 9 | dat$hour == 17 | dat$hour == 18),]
dat.train <- dat[! rownames(dat) %in% rownames(dat.test),]
dim(dat.train)
dim(dat.test)

matrix(colnames(dat.train))
dat.train.w1 <- na.omit(dat.train[,c(1,2,3,6,7,8,9,10,11,12:17,18)])
dat.test.w1 <- na.omit(dat.test[(dat.test$hour==8 & dat.test$minute==0) 
                                | (dat.test$hour==17 & dat.test$minute==0)
                                ,c(1,2,3,6,7,8,9,10,11,12:17,18)])

mdl <- glm(target_window1~., data=dat.train.w1)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train.w1 <- predict(mdl2, dat.train.w1)
group.train.w1 <- dat.train.w1$route
tmp <- abs((pred.train.w1 - dat.train.w1$target_window1) / dat.train.w1$target_window1)
mape.train.w1 <- mean(tapply(tmp, group.train.w1, mean))
mape.train.w1

pred.test.w1 <- predict(mdl2, dat.test.w1)
group.test.w1 <- dat.test.w1$route
tmp <- abs((pred.test.w1 - dat.test.w1$target_window1) / dat.test.w1$target_window1)
mape.test.w1 <- mean(tapply(tmp, group.test.w1, mean))
mape.test.w1

dat.train.w2 <- na.omit(dat.train[,c(1,2,3,6,7,8,9,10,11,12:17,19)])
dat.test.w2 <- na.omit(dat.test[(dat.test$hour==8 & dat.test$minute==20) 
                                | (dat.test$hour==17 & dat.test$minute==20)
                                ,c(1,2,3,6,7,8,9,10,11,12:17,19)])

mdl <- glm(target_window2~., data=dat.train.w2)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train.w2 <- predict(mdl2, dat.train.w2)
group.train.w2 <- dat.train.w2$route
tmp <- abs((pred.train.w2 - dat.train.w2$target_window2) / dat.train.w2$target_window2)
mape.train.w2 <- mean(tapply(tmp, group.train.w2, mean))
mape.train.w2

pred.test.w2 <- predict(mdl2, dat.test.w2)
group.test.w2 <- dat.test.w2$route
tmp <- abs((pred.test.w2 - dat.test.w2$target_window2) / dat.test.w2$target_window2)
mape.test.w2 <- mean(tapply(tmp, group.test.w2, mean))
mape.test.w2

dat.train.w3 <- na.omit(dat.train[,c(1,2,3,6,7,8,9,10,11,12:17,20)])
dat.test.w3 <- na.omit(dat.test[(dat.test$hour==8 & dat.test$minute==40) 
                                | (dat.test$hour==17 & dat.test$minute==40)
                                ,c(1,2,3,6,7,8,9,10,11,12:17,20)])

mdl <- glm(target_window3~., data=dat.train.w3)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train.w3 <- predict(mdl2, dat.train.w3)
group.train.w3 <- dat.train.w3$route
tmp <- abs((pred.train.w3 - dat.train.w3$target_window3) / dat.train.w3$target_window3)
mape.train.w3 <- mean(tapply(tmp, group.train.w3, mean))
mape.train.w3

pred.test.w3 <- predict(mdl2, dat.test.w3)
group.test.w3 <- dat.test.w3$route
tmp <- abs((pred.test.w3 - dat.test.w3$target_window3) / dat.test.w3$target_window3)
mape.test.w3 <- mean(tapply(tmp, group.test.w3, mean))
mape.test.w3

dat.train.w4 <- na.omit(dat.train[,c(1,2,3,6,7,8,9,10,11,12:17,21)])
dat.test.w4 <- na.omit(dat.test[(dat.test$hour==9 & dat.test$minute==0) 
                                | (dat.test$hour==18 & dat.test$minute==0)
                                ,c(1,2,3,6,7,8,9,10,11,12:17,21)])

mdl <- glm(target_window4~., data=dat.train.w4)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train.w4 <- predict(mdl2, dat.train.w4)
group.train.w4 <- dat.train.w4$route
tmp <- abs((pred.train.w4 - dat.train.w4$target_window4) / dat.train.w4$target_window4)
mape.train.w4 <- mean(tapply(tmp, group.train.w4, mean))
mape.train.w4

pred.test.w4 <- predict(mdl2, dat.test.w4)
group.test.w4 <- dat.test.w4$route
tmp <- abs((pred.test.w4 - dat.test.w4$target_window4) / dat.test.w4$target_window4)
mape.test.w4 <- mean(tapply(tmp, group.test.w4, mean))
mape.test.w4

dat.train.w5 <- na.omit(dat.train[,c(1,2,3,6,7,8,9,10,11,12:17,22)])
dat.test.w5 <- na.omit(dat.test[(dat.test$hour==9 & dat.test$minute==20) 
                                | (dat.test$hour==18 & dat.test$minute==20)
                                ,c(1,2,3,6,7,8,9,10,11,12:17,22)])

mdl <- glm(target_window5~., data=dat.train.w5)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train.w5 <- predict(mdl2, dat.train.w5)
group.train.w5 <- dat.train.w5$route
tmp <- abs((pred.train.w5 - dat.train.w5$target_window5) / dat.train.w5$target_window5)
mape.train.w5 <- mean(tapply(tmp, group.train.w5, mean))
mape.train.w5

pred.test.w5 <- predict(mdl2, dat.test.w5)
group.test.w5 <- dat.test.w5$route
tmp <- abs((pred.test.w5 - dat.test.w5$target_window5) / dat.test.w5$target_window5)
mape.test.w5 <- mean(tapply(tmp, group.test.w5, mean))
mape.test.w5

dat.train.w6 <- na.omit(dat.train[,c(1,2,3,6,7,8,9,10,11,12:17,23)])
dat.test.w6 <- na.omit(dat.test[(dat.test$hour==9 & dat.test$minute==40) 
                                | (dat.test$hour==18 & dat.test$minute==40)
                                ,c(1,2,3,6,7,8,9,10,11,12:17,23)])

mdl <- glm(target_window6~., data=dat.train.w6)
summary(mdl)
mdl2 <- step(mdl)
summary(mdl2)

pred.train.w6 <- predict(mdl2, dat.train.w6)
group.train.w6 <- dat.train.w6$route
tmp <- abs((pred.train.w6 - dat.train.w6$target_window6) / dat.train.w6$target_window6)
mape.train.w6 <- mean(tapply(tmp, group.train.w6, mean))
mape.train.w6

pred.test.w6 <- predict(mdl2, dat.test.w6)
group.test.w6 <- dat.test.w6$route
tmp <- abs((pred.test.w6 - dat.test.w6$target_window6) / dat.test.w6$target_window6)
mape.test.w6 <- mean(tapply(tmp, group.test.w6, mean))
mape.test.w6

pred.test <- c(pred.test.w1,pred.test.w2,pred.test.w3,pred.test.w4,pred.test.w5,pred.test.w6)
group.test <- c(group.test.w1,group.test.w2,group.test.w3,group.test.w4,group.test.w5,group.test.w6)
target <- c(dat.test.w1$target_window1,dat.test.w2$target_window2,dat.test.w3$target_window3,dat.test.w4$target_window4,dat.test.w5$target_window5,dat.test.w6$target_window6)
tmp <- abs((pred.test - target) / target)
mean(tapply(tmp, group.test, mean))

# 0.2450548






library(randomForest)
start_time <- Sys.time() 
dat.train.w1 <- na.omit(dat.train[,c(1,2,3,7,8,9,10,11,12:17,18)])
dat.test.w1 <- na.omit(dat.test[(dat.test$hour==8 & dat.test$minute==0) 
                                | (dat.test$hour==17 & dat.test$minute==0)
                                ,c(1,2,3,7,8,9,10,11,12:17,18)])

mdl <- randomForest(target_window1~., data=dat.train.w1, ntree=20)
summary(mdl)

pred.train.w1 <- predict(mdl, dat.train.w1)
group.train.w1 <- dat.train.w1$route
tmp <- abs((pred.train.w1 - dat.train.w1$target_window1) / dat.train.w1$target_window1)
mape.train.w1 <- mean(tapply(tmp, group.train.w1, mean))
mape.train.w1

pred.test.w1 <- predict(mdl, dat.test.w1)
group.test.w1 <- dat.test.w1$route
tmp <- abs((pred.test.w1 - dat.test.w1$target_window1) / dat.test.w1$target_window1)
mape.test.w1 <- mean(tapply(tmp, group.test.w1, mean))
mape.test.w1

dat.train.w2 <- na.omit(dat.train[,c(1,2,3,7,8,9,10,11,12:17,19)])
dat.test.w2 <- na.omit(dat.test[(dat.test$hour==8 & dat.test$minute==20) 
                                | (dat.test$hour==17 & dat.test$minute==20)
                                ,c(1,2,3,7,8,9,10,11,12:17,19)])

mdl <- randomForest(target_window2~., data=dat.train.w2)
summary(mdl)

pred.train.w2 <- predict(mdl, dat.train.w2)
group.train.w2 <- dat.train.w2$route
tmp <- abs((pred.train.w2 - dat.train.w2$target_window2) / dat.train.w2$target_window2)
mape.train.w2 <- mean(tapply(tmp, group.train.w2, mean))
mape.train.w2

pred.test.w2 <- predict(mdl, dat.test.w2)
group.test.w2 <- dat.test.w2$route
tmp <- abs((pred.test.w2 - dat.test.w2$target_window2) / dat.test.w2$target_window2)
mape.test.w2 <- mean(tapply(tmp, group.test.w2, mean))
mape.test.w2

dat.train.w3 <- na.omit(dat.train[,c(1,2,3,7,8,9,10,11,12:17,20)])
dat.test.w3 <- na.omit(dat.test[(dat.test$hour==8 & dat.test$minute==40) 
                                | (dat.test$hour==17 & dat.test$minute==40)
                                ,c(1,2,3,7,8,9,10,11,12:17,20)])

mdl <- randomForest(target_window3~., data=dat.train.w3)
summary(mdl)

pred.train.w3 <- predict(mdl, dat.train.w3)
group.train.w3 <- dat.train.w3$route
tmp <- abs((pred.train.w3 - dat.train.w3$target_window3) / dat.train.w3$target_window3)
mape.train.w3 <- mean(tapply(tmp, group.train.w3, mean))
mape.train.w3

pred.test.w3 <- predict(mdl, dat.test.w3)
group.test.w3 <- dat.test.w3$route
tmp <- abs((pred.test.w3 - dat.test.w3$target_window3) / dat.test.w3$target_window3)
mape.test.w3 <- mean(tapply(tmp, group.test.w3, mean))
mape.test.w3

dat.train.w4 <- na.omit(dat.train[,c(1,2,3,7,8,9,10,11,12:17,21)])
dat.test.w4 <- na.omit(dat.test[(dat.test$hour==9 & dat.test$minute==0) 
                                | (dat.test$hour==18 & dat.test$minute==0)
                                ,c(1,2,3,7,8,9,10,11,12:17,21)])

mdl <- randomForest(target_window4~., data=dat.train.w4)
summary(mdl)

pred.train.w4 <- predict(mdl, dat.train.w4)
group.train.w4 <- dat.train.w4$route
tmp <- abs((pred.train.w4 - dat.train.w4$target_window4) / dat.train.w4$target_window4)
mape.train.w4 <- mean(tapply(tmp, group.train.w4, mean))
mape.train.w4

pred.test.w4 <- predict(mdl, dat.test.w4)
group.test.w4 <- dat.test.w4$route
tmp <- abs((pred.test.w4 - dat.test.w4$target_window4) / dat.test.w4$target_window4)
mape.test.w4 <- mean(tapply(tmp, group.test.w4, mean))
mape.test.w4

dat.train.w5 <- na.omit(dat.train[,c(1,2,3,7,8,9,10,11,12:17,22)])
dat.test.w5 <- na.omit(dat.test[(dat.test$hour==9 & dat.test$minute==20) 
                                | (dat.test$hour==18 & dat.test$minute==20)
                                ,c(1,2,3,7,8,9,10,11,12:17,22)])

mdl <- randomForest(target_window5~., data=dat.train.w5)
summary(mdl)

pred.train.w5 <- predict(mdl, dat.train.w5)
group.train.w5 <- dat.train.w5$route
tmp <- abs((pred.train.w5 - dat.train.w5$target_window5) / dat.train.w5$target_window5)
mape.train.w5 <- mean(tapply(tmp, group.train.w5, mean))
mape.train.w5

pred.test.w5 <- predict(mdl, dat.test.w5)
group.test.w5 <- dat.test.w5$route
tmp <- abs((pred.test.w5 - dat.test.w5$target_window5) / dat.test.w5$target_window5)
mape.test.w5 <- mean(tapply(tmp, group.test.w5, mean))
mape.test.w5

dat.train.w6 <- na.omit(dat.train[,c(1,2,3,7,8,9,10,11,12:17,23)])
dat.test.w6 <- na.omit(dat.test[(dat.test$hour==9 & dat.test$minute==40) 
                                | (dat.test$hour==18 & dat.test$minute==40)
                                ,c(1,2,3,7,8,9,10,11,12:17,23)])

mdl <- randomForest(target_window6~., data=dat.train.w6)
summary(mdl)

pred.train.w6 <- predict(mdl, dat.train.w6)
group.train.w6 <- dat.train.w6$route
tmp <- abs((pred.train.w6 - dat.train.w6$target_window6) / dat.train.w6$target_window6)
mape.train.w6 <- mean(tapply(tmp, group.train.w6, mean))
mape.train.w6

pred.test.w6 <- predict(mdl, dat.test.w6)
group.test.w6 <- dat.test.w6$route
tmp <- abs((pred.test.w6 - dat.test.w6$target_window6) / dat.test.w6$target_window6)
mape.test.w6 <- mean(tapply(tmp, group.test.w6, mean))
mape.test.w6

pred.test <- c(pred.test.w1,pred.test.w2,pred.test.w3,pred.test.w4,pred.test.w5,pred.test.w6)
group.test <- c(group.test.w1,group.test.w2,group.test.w3,group.test.w4,group.test.w5,group.test.w6)
target <- c(dat.test.w1$target_window1,dat.test.w2$target_window2,dat.test.w3$target_window3,dat.test.w4$target_window4,dat.test.w5$target_window5,dat.test.w6$target_window6)
tmp <- abs((pred.test - target) / target)
mean(tapply(tmp, group.test, mean))

cor(na.omit(dat.train[,12:23]))
