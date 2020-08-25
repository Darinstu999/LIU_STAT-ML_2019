library(partykit)

fit<-function(y, x = NULL, start = NULL, weights = NULL, offset = NULL, ...){
  xy=cbind(x[,-1],y)
  x=x[,-1]
  data=as.data.frame(xy)
  ret=lm(y~.^2, data=data)
  return(ret)
}

data=read.csv2("Women.csv")


m=mob(Blood.systolic~height+weight | height+weight, data=data, fit=fit, control= mob_control(minsize = 5000))
plot(m)


height=seq(min(data$height), max(data$height), by=(max(data$height)-min(data$height))/99)
weight=seq(min(data$weight), max(data$weight), by=(max(data$weight)-min(data$weight))/99)
H=rep(height, 100)
W=rep(weight, each=100)

data1=data.frame(height=H, weight=W)
P=predict(m, newdata=data1, type = "response" )

ggplot(data1, aes(x=height, y=weight, fill=P))+geom_raster()
