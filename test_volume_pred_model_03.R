dat <- read.csv("dm_volume_pred_train_01.csv", header=TRUE)
dat$tollgate_id <- as.factor(dat$tollgate_id)
dat$month <- as.factor(dat$month)
dat$hour <- as.factor(dat$hour)
dat$minute <- as.factor(dat$minute)
dat$week <- as.factor(dat$week)
dat$dow <- as.factor(dat$dow)
summary(dat)

set.seed(123)
tmp_date <- unique(dat$date)
train_date <- sample(tmp_date, length(tmp_date) * 0.8)
unique(dat$date[dat$date %in% train_date])
unique(dat$date[! dat$date %in% train_date])


dat.train <- dat[dat$date %in% train_date,]
dat.test <- dat[(! dat$date %in% train_date) & (dat$hour == 8 | dat$hour == 17) & dat$minute == 0,]

matrix(colnames(dat.test))
head(dat.test[dat.test$date == '2016/09/19' & dat.test$hour==8 & dat.test$tollgate_id==1 & dat.test$direction==0 ,c(1:13,176,177)], 100)

dim(dat.train)
dim(dat.test)
length(tmp_date) - length(train_date)


write.table(dat.test, "tmp.tsv", sep="\t", row.names=F)

5 * 6 * 6 * 2

dat.train2 <- na.omit(dat.train[,c(1,5,7,8,10,11,12,13,14:176,177)])
dat.test2 <- na.omit(dat.test[,c(1,5,7,8,10,11,12,13,14:176,177)])
dim(dat.train2)
dim(dat.test2)

mdl <- glm(target~., data=dat.train2)
summary(mdl)

pred.train <- predict(mdl, dat.train2)
group.train <- paste(dat.train2$tollgate_id,dat.train2$direction,sep="-")
tmp <- abs((pred.train - dat.train2$target) / dat.train2$target)
mape.train <- mean(tapply(tmp, group.train, mean))
mape.train

pred.test <- predict(mdl, dat.test2)
group.test <- paste(dat.test2$tollgate_id,dat.test2$direction,sep="-")
tmp <- abs((pred.test - dat.test2$target) / dat.test2$target)
mape.test <- mean(tapply(tmp, group.test, mean))
mape.test

plot(dat.train2$target, pred.train)
abline(0,1)

plot(dat.test2$target, pred.test)
abline(0,1)

library(randomForest)

colnames(dat)
summary(dat)
dat.train2 <- na.omit(dat.train[,c(1,5,8,10,11,12,13,14:176,177)])
dat.test2 <- na.omit(dat.test[,c(1,5,8,10,11,12,13,14:176,177)])

mdl <- randomForest(target~., data=dat.train2)
summary(mdl)

pred.train <- predict(mdl, dat.train2)
group.train <- paste(dat.train2$tollgate_id,dat.train2$direction,sep="-")
tmp <- abs((pred.train - dat.train2$target) / dat.train2$target)
mape.train <- mean(tapply(tmp, group.train, mean))
mape.train

pred.test <- predict(mdl, dat.test2)
group.test <- paste(dat.test2$tollgate_id,dat.test2$direction,sep="-")
tmp <- abs((pred.test - dat.test2$target) / dat.test2$target)
mape.test <- mean(tapply(tmp, group.test, mean))
mape.test
