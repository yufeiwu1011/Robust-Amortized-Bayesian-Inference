library('rtdists')
library('tidyverse')
library('dplyr')
rr98 = rr98
bins = c(-0.5, 10.5, 13.5, 16.5, 19.5, 32.5)
rr98$strength_bin = cut(rr98$strength, breaks = bins, include.lowest = TRUE)
levels(rr98$strength_bin) <- as.character(0:4)
rr98$y[rr98$response=='dark'] = 0
rr98$y[rr98$response=='light'] = 1
rr98$y_dummy = ifelse(rr98$y == 1, 0, 1)

summary(rr98$id[rr98['outlier']==TRUE])
summary(rr98$instruction[rr98['outlier']==TRUE])
hist(rr98$rt[rr98['outlier']==TRUE], breaks =100)

summary(rr98$rt[rr98['outlier']==TRUE & rr98$instruction =='speed'])
summary(rr98$rt[rr98['outlier']==TRUE & rr98$instruction =='accuracy'])

quantile(rr98$rt[rr98['outlier']==TRUE & rr98$instruction =='speed'], 0.025)
quantile(rr98$rt[rr98['outlier']==TRUE & rr98$instruction =='speed'], 0.975)

rr98 = rr98[,c('id','instruction','strength_bin','response','rt','y','y_dummy')]

#write.table(rr98, 'C:/Users/u0145642/OneDrive - KU Leuven/Desktop/PhD/Project 2 BayesFlow/manuscript/rr98/rr98.txt')
