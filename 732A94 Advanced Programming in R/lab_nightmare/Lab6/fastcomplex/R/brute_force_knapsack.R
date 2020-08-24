#' Brute force search
#' 
#' Solve the knapsack problem by using brute force search algorithm. This algorithm solves the knapsack problem by going through all possible combinations and return the highest value.
#' 
#' @param x data frame containing variables "v", values, and "w" which is weights of the items.
#' @param W Knapsack size 
#' @param par by.default(FALSE)
#' 
#' @return A list containing the value and the picked elements
#' 
#' @import doParallel foreach
#' 
#' @export
#' 
brute_force_knapsack<-function(x,W,par=FALSE){
  doParallel::registerDoParallel(cores=2)
  
  stopifnot(class(x)=="data.frame" & dim(x)[2]==2 & names(x)[1]=="w" & names(x)[2]=="v")
  #x<-x[x$w<W,]
  mylist<-list()
  weights<-vector()
  values<-vector()
  
  if(par == TRUE){
    mylist <- foreach(i = 1:2^nrow(x))%dopar%{
      mylist[[i]] <- as.numeric(intToBits(i)[1:nrow(x)])
    }
    
    pickones <- foreach(i = 1:2^nrow(x))%dopar%{
      pickones<-x[mylist[[i]] == 1,] 
    }
    
    weights <- foreach(i = 1:2^nrow(x))%dopar%{
      weights[i]<-sum(pickones[[i]][,1]) 
    }
    
    values <- foreach(i = 1:2^nrow(x))%dopar%{
      values[i]<-sum(pickones[[i]][,2]) 
    }
  }else{
    mylist<-list()
    weights<-vector()
    values<-vector()
    for(i in 1:2^nrow(x)){
      mylist[[i]] <- as.numeric(intToBits(i)[1:nrow(x)])
      pickones<-x[mylist[[i]] == 1,] 
      weights[i]<-sum(pickones[,1]) 
      values[i]<-sum(pickones[,2]) 
    }
    passedrows <- which(weights<W)
    passedW <- weights[passedrows]
    passedV <- values[passedrows] 
    highestvalue <- which.max(passedV)
    
    elements <- (1:nrow(x))[mylist[[passedrows[highestvalue]]]==1] 
    elements <- elements[order(elements, decreasing = FALSE)] 
    return(list(value=values[passedrows[highestvalue]], elements=elements)) 
  }
  
  passedrows <- which(weights<W) 
  passedW <- weights[passedrows] 
  passedV <- values[passedrows]  
  highestvalue <- which.max(passedV) 
  
  elements <- (1:nrow(x))[mylist[[passedrows[highestvalue]]]==1] 
  elements <- elements[order(elements, decreasing = FALSE)]
  return(list(value=values[passedrows[highestvalue]], elements=elements))
}
