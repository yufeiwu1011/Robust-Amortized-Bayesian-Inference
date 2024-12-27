library(RWiener)
library(dplyr)
library(coda)
library(runjags)
library(rjags)
load.module("wiener")

data = read.table('data_bf.txt', sep = ',')

data$V1 = exp(data$V1)

model_String ='
model {

  #likelihood function
  for (t in 1:nTrials) { 
  y[t] ~ dwiener(alpha, tau, beta, delta)
  }
  
  #priors
  
  alpha ~ dnorm(0, 1e-3)
  beta = 0.5
  tau ~ dnorm(0, 1e-3)T(0.01,3)
  delta ~ dnorm(0,1e-3)
  
}


'

writeLines(model_String, con = 'JAGS model.txt')


#Create list of parameters to be monitored
parameters <- c("alpha", "tau", "delta")


nUseSteps = 8000 #Specify number of steps to run
nChains = 4 #Specify number of chains to run (one per processor)

initfunction <- function(chain){
  return(list(
    alpha = 1,
    tau = 0.01))
}

posterior_mean = matrix(NA, nrow=1,ncol=3)
posterior_sd = matrix(NA, nrow=1,ncol=3)
convergence = c()

#batch processing 
for (i in 1:length(unique(data$V5))){
  
  data_current <- data[data$V5 == i,]
  data_current$V1[data_current$V2 == 1] = -data_current$V1[data_current$V2 == 1] 
  elapsedTime = c()
  
  data_model=list(
    nTrials = length(data_current$V1),
    y = data_current$V1)
  
  
  
  #Run the model in runjags
  startTime = proc.time()
  
  
  jagsModel <-run.jags(method = "parallel",
                       model = 'JAGS model.txt',
                       monitor = parameters,
                       data = data_model,
                       inits = initfunction,
                       n.chains = 4,
                       adapt = 1000, #how long the samplers "tune"
                       burnin = 1000, #how long of a burn in
                       sample = 1000,
                       modules = c("wiener", "lecuyer"),
                       summarise = F,
                       plots = F)
  
  stopTime = proc.time()
  elapsedTime[i] = ((stopTime - startTime)/60)['elapsed']
  #Tells how long it took to run analysis
  
  #Convert the runjags object to a coda format
  codaSamples <- as.mcmc.list(jagsModel)
  
  #Turn three MCMC samples into a single matrix with all data
  mcmcMat <- as.matrix(codaSamples, chains = F)
  
  #get the posterior mean
  posterior_mean_new =  colMeans(mcmcMat)
  posterior_mean = rbind(posterior_mean,posterior_mean_new)
  
  convergence[i] = ifelse(all((as.numeric(gelman.diag(jagsModel$mcmc)$psrf[,"Point est."]))<1.1),1,0)
  posterior_sd_new =  apply(mcmcMat, 2, sd)
  posterior_sd = rbind(posterior_sd,posterior_sd_new)
  
  print(i)
  
  write.table(posterior_mean, file = "posterior_mean_JAGS.txt", sep = ",")
  write.table(posterior_sd, file = "posterior_sd_JAGS.txt", sep = ",")
  
}


posterior_mean_real = posterior_mean[-1,]
posterior_sd_real = posterior_sd[-1,]
posterior_mean_real = cbind(posterior_mean_real,convergence)
posterior_sd_real = cbind(posterior_sd_real,convergence)

write.table(posterior_mean_real, file = "posterior_mean_JAGS.txt", sep = ",", row.names = F)
write.table(posterior_sd_real, file = "posterior_sd_JAGS.txt", sep = ",", row.names = F)
