set.seed(2024)

### robust
ppi=.1
df=5 #change to 1,3 or 5
Me=(1-ppi)*qnorm(p=.5)+ppi*qt(p=.5,df=df)
Q1 = (1-ppi)*qnorm(p=.25)+ppi*qt(p=.25,df=df)
Q3 = (1-ppi)*qnorm(p=.75)+ppi*qt(p=.75,df=df)
extval=Q3 + 1.5*(Q3-Q1)
farval=Q3 + 3*(Q3-Q1)

round(extval,3)
round(farval,3)
round(100*2*((1-ppi)*(1-pnorm(q=extval))+ppi*(1-pt(q=extval,df=df))),3)
round(100*2*((1-ppi)*(1-pnorm(q=farval))+ppi*(1-pt(q=farval,df=df))),3)

nn=10000000
ind=rbinom(n = nn, size=1, prob=ppi)
xx=(1-ind)*rnorm(n=nn)+ind*rt(n=nn,df=df)
qq=quantile(xx,probs=c(.25,.5,.75))
est_extval=qq[3]+1.5*(qq[3]-qq[1])
est_farval=qq[3]+3*(qq[3]-qq[1])

sum(abs(xx)>est_extval)/nn
sum(abs(xx)>est_farval)/nn


#### standard
Me=qnorm(p=.5)
Q1 = qnorm(p=.25)
Q3 = qnorm(p=.75)
extval=Q3 + 1.5*(Q3-Q1)
farval=Q3 + 3*(Q3-Q1)

round(extval,3)
round(farval,3)
round(100*2*(1-pnorm(q=extval)),3)
round(100*2*(1-pnorm(q=farval)),5)

nn=10000000
xx=rnorm(n=nn)
qq=quantile(xx,probs=c(.25,.5,.75))
est_extval=qq[3]+1.5*(qq[3]-qq[1])
est_farval=qq[3]+3*(qq[3]-qq[1])

sum(abs(xx)>est_extval)/nn
sum(abs(xx)>est_farval)/nn