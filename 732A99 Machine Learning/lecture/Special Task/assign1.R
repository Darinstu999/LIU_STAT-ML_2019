library(glmnet)

randomLasso<-function(x, y, q1=round(p/2),q2=round(p/2),B=500, pShow=10){

  n=nrow(x)
  p=ncol(x)
  
  #extracting optimal lambda
  #result=cv.glmnet(x, y, alpha=1, family="binomial")
  #lambda=result$lambda.min
  
  #STEP 1
  
  Coefs=matrix(0, nrow=B, ncol=p)

  set.seed(12345)
  for(i in 1:B){
    ind=sample(n,n, replace=T)
    ind2=sample(p, q1)
    xi=x[ind,ind2]
    yi=y[ind]
    resI=cv.glmnet(xi,yi, family="binomial", nfolds=4)
    Coefs[i, ind2]=as.numeric(coef(resI, s="lambda.min")[-1])
  }
  
  Importance=abs(colMeans(Coefs))
  
  #PLOT
  Names=colnames(x)
  ord=order(Importance, decreasing=T)
  Imp=(Importance[ord])[1:pShow]
  Nm=(Names[ord])[1:pShow]
  
  barplot(Imp,names.arg = Nm )
  
  
  #STEP 2
  
  Coefs2=matrix(0, nrow=B, ncol=p+1)
  
  set.seed(12345)
  for (i in 1:B){
    ind=sample(n,n, replace=T)
    ind2=sample(p, q2, prob=Importance/sum(Importance))
    xi=x[ind,ind2]
    yi=y[ind]
    
    resI=cv.glmnet(xi,yi, family="binomial", nfolds=4)
    Coefs2[i, c(1,ind2+1)]=as.numeric(coef(resI, s="lambda.min"))
   # print(table(predict(resI, s="lambda.min", type="class", newx=x[,ind2]), y))
    
  }
  
  CMeans=colMeans(Coefs2)
  Odds=cbind(1,x)%*%matrix(CMeans, ncol=1)
  Prob=1/(1+exp(-Odds))
  
  Spam=Prob>0.5
  print(table(y,Spam))
  
  return(Spam)
  
  
}

data=read.csv2("spambase.csv")
x=as.matrix(data[,-49])
y=as.factor(data[,49])

res=randomLasso(x,y, B=100)
