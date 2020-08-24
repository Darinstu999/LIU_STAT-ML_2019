library(markmyassignment)
lab_path <-
  "https://raw.githubusercontent.com/STIMALiU/AdvRCourse/master/Labs/Tests/lab2.yml"
set_assignment(lab_path)

name <- "Zhixuan Duan"
liuid <- "zhidu838"

1.1
1.1.1

sheldon_game <- function(player1,player2){
  r <- "rock"
  p <- "paper"
  s1 <- "scissor"
  l <- "lizard"
  s2 <- "spock"
  choicelist <- c(r,p,s1,l,s2)
  
  if (player1 %in% choicelist == FALSE || player2 %in% choicelist == FALSE) {
    stop()
  }
  
  p1 <- player1
  p2 <- player2
  
  if (p1 ==  p2) {
    return("Draw!")
  }
  
  else if (p1 == s1 & p2 == p) {
    return("Player 1 wins!")
  }else if (p1 == p & p2 == r) {
    return("Player 1 wins!")
  }else if (p1 == r & p2 == l) {
    return("Player 1 wins!")
  }else if (p1 == l & p2 == s2) {
    return("Player 1 wins!")
  }else if (p1 == s2 & p2 == s1) {
    return("Player 1 wins!")
  }
  
  else if (p1 == s1 & p2 == l) {
    return("Player 1 wins!")
  }else if (p1 == l & p2 == p) {
    return("Player 1 wins!")
  }else if (p1 == p & p2 == s2) {
    return("Player 1 wins!")
  }else if (p1 == s2 & p2 == r) {
    return("Player 1 wins!")
  }else if (p1 == r & p2 == s1) {
    return("Player 1 wins!")
  }
  
  else if (p1 == p & p2 == s1) {
    return("Player 2 wins!")
  }else if (p1 == r & p2 == p) {
    return("Player 2 wins!")
  }else if (p1 == l & p2 == r) {
    return("Player 2 wins!")
  }else if (p1 == s2 & p2 == l) {
    return("Player 2 wins!")
  }else if (p1 == s1 & p2 == s2) {
    return("Player 2 wins!")
  }
  
  else if (p1 == l & p2 == s1) {
    return("Player 2 wins!")
  }else if (p1 == p & p2 == l) {
    return("Player 2 wins!")
  }else if (p1 == s2 & p2 == p) {
    return("Player 2 wins!")
  }else if (p1 == r & p2 == s2) {
    return("Player 2 wins!")
  }else if (p1 == s1 & p2 == r) {
    return("Player 2 wins!")
  }
}

sheldon_game("lizard", "spock")

1.2
1.2.1

my_moving_median <- function(x,n,...){
  # 判断
  if (is.vector(x) == FALSE || is.numeric(n) == FALSE || length(n) != 1) {
   stop()
  }
  #计算
  yt <- c(NA)
  for (i in 1:(length(x) - n)) {
      datatep <- x[i:(i+n)]
      yt[i] <- median(datatep,...)
    }
  return(yt)
}

my_moving_median(x = 1:10, n=2)

1.2.2
# got help from ZuxiangLi, talked about how to insert data into matrix.

for_mult_table <- function(from,to){
  if (is.vector(from) == FALSE || is.numeric(to) == FALSE || length(to) != 1) {
    stop()
  }
  
  a <- c(from:to)
  l <- length(a)
  b <- matrix(data = NA, nrow = l, ncol = l)
  
  rownames(b) <- a
  colnames(b) <- a

  for (i in 1:l) {
    b[i,] <- a[i] * a
  }
  return(b)
}

for_mult_table(from = 1, to = 4)


1.3
1.3.1

find_cumsum <- function(x, find_sum){

  sum <- 0
  i <- 1
  
  while (sum < find_sum && is.numeric(x[[i]]) == TRUE && 
         is.integer(x[[i]]) == TRUE) {
    sum <- sum + x[[i]]
    i <- i + 1
    if(i == length(x)+1)
      break
  }
  return(sum)
}

find_cumsum(x=1:100, find_sum=500)
find_cumsum(x=1:10, find_sum=1000)

1.3.2

while_mult_table <- function(from, to){
  if (is.vector(from) == FALSE || is.numeric(to) == FALSE || length(to) != 1) {
    stop()
  }
  
  a <- c(from:to)
  l <- length(a)
  b <- matrix(data = NA, nrow = l, ncol = l)
  
  rownames(b) <- a
  colnames(b) <- a
  
  i <- 1
  
  while (i <= l) {
    b[i,] <- a[i] * a
    i <- i + 1
  }
  return(b)
}

while_mult_table(from = 3, to = 5)


1.4
1.4.1

repeat_find_cumsum <- function(x, find_sum){
  
  sum <- 0
  i <- 1
  
  if (is.vector(x[[i]]) == FALSE || is.integer(x[[i]]) == FALSE ) {
    stop()
  }

  repeat{
    sum <- sum + x[[i]]
    i <- i + 1
    if (sum > find_sum | i > length(x)) {
      break
    }
  }
  return(sum)
}

repeat_find_cumsum(x=1:100, find_sum=500)
repeat_find_cumsum(x=1:10, find_sum=1000)

1.4.2

repeat_my_moving_median <- function(x,n,...){
  # 判断
  if (is.vector(x) == FALSE || is.numeric(n) == FALSE || length(n) != 1) {
    stop()
  }
  #计算
  yt <- c(NA)
  i <- 1
  
  repeat{
    datatep <- x[i:(i+n)]
    yt[i] <- median(datatep,...)
    i <- i + 1
    if (i > (length(x) - n)) {
     break 
    }
  }
  return(yt)
}

repeat_my_moving_median(x = 1:10, n=2)
repeat_my_moving_median(x = 5:15, n=4)
repeat_my_moving_median(x = c(5,1,2,NA,2,5,6,8,9,9), n=2)

1.5
1.5.1

in_environment <- function(env){
  return(ls(env))
}

1.5.2

1.6
1.6.1

data(iris)
cov <- function(X){
  # 判断
  if (is.data.frame(X) == FALSE) {
    stop()
  }
  
  #计算
    unlist(lapply(X, FUN = function(x){sd(x)/mean(x)}))
}

cov(X = iris[1:4])
cov(X = iris[3:4])

1.7
1.7.1

moment <- function(i){
  if (is.numeric(i) == FALSE) {
    stop()
  }
  
  b <- function(x){
    a <- mean((x - mean(x))^i)
    return(a)
  }
}


m1 <- moment(i=1)
m2 <- moment(i=2)

m1(1:100)
m2(1:100)

