library(dplyr)
dat <- read.csv("../../data/train/trajectories(table 5)_training.csv", header = TRUE)

head(dat)

dat %>% select(intersection_id, tollgate_id, starting_time, travel_time)

dat$starting_time

a <- Sys.time()
b <- as.POSIXlt(a)

floor(unclass(b)$min / 20) * 20

tmp <- unclass(as.POSIXlt(dat$starting_time))
floor(tmp$min / 20) * 20
head(dat$starting_time)
tmp$year
tmp$mon
tmp$mday
tmp$hour
rep(0, length(tmp$min))

ISOdatetime(2017,12,10,1,20,0)
ISOdatetime(tmp$year,tmp$mon,tmp$mday,tmp$hour,floor(tmp$min / 20) * 20,0)

a <- dat$starting_time
b <- strptime(a, format="%Y-%m-%d %H:%M:%S")
paste(format(b, '%Y-%m-%d %H:'),
      as.character(floor(as.integer(format(b, '%M')) / 20) * 20)
      ,':00', sep="")

time_window_start <- ISOdatetime(format(b,"%Y"), format(b,"%m"), format(b,"%d"),format(b, "%H"),floor(as.integer(format(b, '%M')) / 20) * 20,0)
time_window_end <- time_window_start + 20 * 60

time_window <- paste("[", format(time_window_start, "%Y-%m-%d %H:%M:%S"), ",", format(time_window_end, "%Y-%m-%d %H:%M:%S"), ")", sep="")

colnames(dat)
dat2 <- data.frame(dat[,c(1,2)], time_window, travel_time=dat$travel_time)

dat3 <- dat2 %>%
  group_by(intersection_id, tollgate_id, time_window) %>% 
  summarise(mean(travel_time))


dat <- read.csv("../../data/train/trajectories(table 5)_training.csv", header = TRUE)
dat$tollgate_id <- as.factor(dat$tollgate_id)
dat$vehicle_id <- as.factor(dat$vehicle_id)
summary(dat)

tmp <- strptime(dat$starting_time, format="%Y-%m-%d %H:%M:%S")
time_window_start <- ISOdatetime(format(tmp,"%Y"), format(tmp,"%m"), format(tmp,"%d"),format(tmp, "%H"),floor(as.integer(format(tmp, '%M')) / 20) * 20,0)
time_window_end <- time_window_start + 20 * 60
time_window <- paste("[", format(time_window_start, "%Y-%m-%d %H:%M:%S"), ",", format(time_window_end, "%Y-%m-%d %H:%M:%S"), ")", sep="")

dat2 <- data.frame(intersection_id=dat$intersection_id, tollgate_id=dat$tollgate_id, time_window_start, time_window_end, time_window, travel_time=dat$travel_time)
dat3 <- dat2 %>%
  group_by(intersection_id, tollgate_id, time_window_start, time_window_end, time_window) %>% 
  summarise(mean(travel_time))
head(dat3)

window_date <- as.Date(dat3$time_window_start)
window_hour <- as.integer(format(dat3$time_window_start, "%H"))
window_minute <- as.integer(format(dat3$time_window_start, "%M"))

dat4 <- data.frame(dat3, window_date, window_hour, window_minute)
head(dat4)
dat5 <- dat4 %>%
  filter(window_hour >= 8 & window_hour < 10)
y <- dat5$mean.travel_time.
summary(dat5)

x <- dat5[,c(1,2,8,9)]
x$window_hour <- as.factor(x$window_hour)
x$window_minute <- as.factor(x$window_minute)
summary(x)

dat6 <- data.frame(y,x)

set.seed(123)
smpl <- sample(1:nrow(dat6), nrow(dat6)*0.8)
dat.train <- dat6[smpl,]
dat.test <- dat6[-smpl,]
mdl <- glm(y~., data=dat.train)

pred.train <- predict(mdl, dat.train)
mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train
pred.test <- predict(mdl, dat.test)
mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test

plot(dat.train$y, pred.train, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)

plot(dat.test$y, pred.test, xlim=c(0,1000), ylim=c(0,750))
abline(0,1)


library(MASS)
hist(y)
truehist(y)
truehist(log(y))

mean(y)
sqrt(var(y))

plot(density(y))


mdl <- glm(y~., data=dat.train, family="gaussian"(link="log"))
summary(mdl)

pred.train <- predict(mdl, dat.train, type = "response")
mape.train <- sum(abs((pred.train - dat.train$y) / dat.train$y)) / length(pred.train)
mape.train
pred.test <- predict(mdl, dat.test, type="response")
mape.test <- sum(abs((pred.test - dat.test$y) / dat.test$y)) / length(pred.test)
mape.test
