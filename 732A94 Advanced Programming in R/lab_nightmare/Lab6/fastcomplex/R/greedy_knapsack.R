#' Greedy heuristic
#' 
#' Solve the knapsack problem by using a approximating approach. 
#' @param x data frame containing variables "v", values, and "w" which is weights of the items.
#' @param W Knapsack size 
#' 
#' @return A list containing the value and the picked elements
#' 
#' @export

greedy_knapsack<-function(x,W){
  stopifnot(class(x)=="data.frame" & dim(x)[2]==2 & names(x)[1]=="w" & names(x)[2]=="v")
  #x<-x[x$w<W,]
  x$V<-x$v/x$w
  x<-x[order(x$V,decreasing = TRUE),]
  i<-1
  while(sum(x[1:i,1])<=W){
    i<-i+1
    y<-i-1
  }
  
  highestvalue<-sum(x$v[1:y])
  elements<-rownames(x[1:y,])
  return(list(value=highestvalue,elements=as.numeric(elements)))
  
}



