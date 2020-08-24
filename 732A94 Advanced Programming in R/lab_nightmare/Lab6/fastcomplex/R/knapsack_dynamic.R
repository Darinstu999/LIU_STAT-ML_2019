#' Knapsack dynamic
#' 
#' Solve the knapsack problem by dynamic programming. This algorithm solves the knapsack problem by iterating over all possible values of w.
#' 
#' @param x data frame containing variables "v", values, and "w" which is weights of the items.
#' @param W Knapsack size 
#' 
#' @return A list containing the value and the elements
#' 
#' @export
  

knapsack_dynamic<-function(x,W){
  stopifnot(class(x)=="data.frame" & dim(x)[2]==2 & names(x)[1]=="w" & names(x)[2]=="v")
  x<-x[x$w<W,]
   v<-x[,2]
  w<-x[,1]
  n<-nrow(x)
 m<-matrix(NA,n+1,W+1)
 
  for(j in 1:(W+1)){
    m[1,j]<-0
  }
  for (i in 1:n){
    for (j in 1:(W+1)){
      if(w[i]>j){
        m[i+1,j]<-m[i-1+1,j]
      }else{
        m[i+1,j]<-max(m[i-1+1,j],m[i-1+1,j-w[i]]+v[i])
      }
      }
  }
  
highestvalue<-m[nrow(m),ncol(m)]
elements<-vector()
 while(i > 1 ){
   if( m[i-1,j] < m[i,j] ){
     elements <- c(elements, i-1)
     i <- i - 1
     j <- j - w[i]
   }else{
     i <- i - 1
   }
 }
 elements <- elements[order(elements, decreasing = FALSE)]
 return(list(value=highestvalue,elements=elements))
}


