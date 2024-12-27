library(MultivariateRandomForest)

summary_stats_bf = as.matrix(read.table('summary_stats_bf.txt', header = F, sep=','))
summary_stats_ez = as.matrix(read.table('summary_stats_ez.txt', header = F, sep=','))

trainX = summary_stats_bf[1:250,]
trainY = summary_stats_ez[1:250,]
testX = summary_stats_bf[251:500,]
trueY = summary_stats_ez[251:500,]
n_tree=5   
m_feature=2
min_leaf=5
Prediction=build_forest_predict(trainX=trainX, trainY=trainY, n_tree = n_tree,  m_feature=m_feature, min_leaf=min_leaf, testX=testX)

plot(trueY[,1], Prediction[,1])
plot(trueY[,2], Prediction[,2])
plot(trueY[,3], Prediction[,3])

write.table(Prediction, 'predicted_summary_stats_ez.txt', sep=' ')
