install.packages("devtools")
devtools::install_github("MansMeg/markmyassignment")

library(markmyassignment)
lab_path <-
  "https://raw.githubusercontent.com/STIMALiU/AdvRCourse/master/Labs/Tests/lab1.yml"
set_assignment(lab_path)

name <- "Zhixuan Duan"
liuid <- "zhidu838"

1.1 Vectors
1.1.1

my_num_vector <- function(){
  return(c(log10(11), cos(pi/5), exp(pi/3), (1173%%7)/19))
}

my_num_vector()

1.1.2

#where is wrong with this function?
filter_my_vector1 <- function(x,leq){
  for (i in x) {
    if(i >= leq){
      return("NA")}
    else{
      return(i)}
  }
}

filter_my_vector <- function(x, leq){
  ifelse(x < leq, x, NA)
}

filter_my_vector(x = c(2, 9, 2, 4, 102), leq = 4)

1.1.3

dot_prod <- function(a, b){
  return(c(a %*% b))
}

dot_prod(a = c(3,1,12,2,4), b = c(1,2,3,4,5))
dot_prod(a = c(-1,3), b = c(-3,-1))

1.1.4

approx_e <- function(N){
  a <- 1
  ni <- 1
  for (i in 1:N) {
    a <- a + 1 / ni
    ni <- ni * (i + 1)
  }
  return(a)
}

approx_e(N = 2)
approx_e(N = 4)
exp(1)
#how to use function factorial() in this loop?
#a <- sum(1/factorial(N))
#return(a)

1.2 Matrix
1.2.1

my_magic_matrix <- function(){
  return(matrix(c(4,3,8,9,5,1,2,7,6),3,3))
}

my_magic_matrix()
# creat a magic matrix
#my_magic_matrix1 <- function(){
  a+b+c = 10
  d+e+f = 10
  g+h+i = 10
  M <- matrix(c(a,b,c,d,e,f,g,h,i),3,3)
  return(M)
}

1.2.2

mat <- my_magic_matrix()
calculate_elements <- function(A){
  B <- nrow(A) * ncol(A)
  return(B)
}

calculate_elements(A = mat)
new_mat <- cbind(mat,mat)
calculate_elements(A = new_mat)

1.2.3

row_to_zero <- function(A,i){
  A[i,] <- 0
  return(A)
}

row_to_zero(A = mat, i = 3)
row_to_zero(A = mat, i = 1)

1.2.4

mat <- my_magic_matrix()
add_elements_to_matrix <- function(A,x,i,j){
  A[i,j] <- A[i,j] + x
  return(A)
}

add_elements_to_matrix(A = mat, x = 10, i = 2, j = 3)
add_elements_to_matrix(A = mat, x = -2, i = 1:3, j = 2:3)
# what does the code documentation do with this example?

1.3 Lists
1.3.1


my_num_vector()
my_magic_matrix()

my_magic_list <- function(){
  list1 <- list("my own list",my_num_vector(),my_magic_matrix())
  names(list1) <- c("info","","")
  return(list1)
}

my_magic_list()

# an alterative
#list2 <- list(info = 'my own list',
#             my_num_vector(),
#             my_magic_matrix())

1.3.2

a_list <- my_magic_list()

change_info <- function(x, text){
  x$info <- text
  return(x)
}

change_info(a_list,"Some new info")

# this one is too rigid, is there a flexible way to code? 
# How to extract names from list?

1.3.3

a_list <- my_magic_list()

add_note <- function(x, note){
  x$note <- note
  return(x)
}

add_note(a_list, "This is a magic list!")

1.3.4

a_list <- my_magic_list()
sum_numeric_parts <- function(x){
  sum(as.numeric(unlist(x)),na.rm = TRUE)
}

sum_numeric_parts(a_list)
sum_numeric_parts(x = a_list[2])

1.4 data.frame
1.4.1

my_data.frame <- function(){
  a <- data.frame(id = c(1,2,3),
             name = c('John','Lisa','Azra'),
             income = c(7.30,0.00,15.21),
             rich = c(FALSE,FALSE,TRUE))
  return(a)
}
my_data.frame()

1.4.2 ???

data(iris)
sort_head <- function(df,var.name,n){

  #df1 <- df[order(var.name, decreasing = T),]
  df1 <- df[order(df[var.name],decreasing = TRUE),]
  df2 <- df1[1:n,]
  return(df2)

}
sort_head(iris,"Petal.Length",5)

1.4.3

# Got help from Hector Rodriguez
# Talked about how to improve the loop and fix the for() line.

# Got help from Zuxiang Li
# Talked about how to specific the variable in if/else loop...
# ...and how to use loop to increase code's effectiveness

data(faithful)

add_median_variable <- function(df,j){
  medtep <- median(df[,j])
  compared_to_median <- NA
  a <- cbind(df,compared_to_median)
  for(i in 1:nrow(a)){
    if(a[i,j]<medtep){
      a$compared_to_median[i]<-"Smaller"
    }else if(a[i,j]>medtep){
      a$compared_to_median[i]<-"Greater"
    }else{
      a$compared_to_median[i]<-"Median"
    }
  }
  return(a)
}

head(add_median_variable(df = faithful, 1))
tail(add_median_variable(df = faithful, 2))


1.4.4
# Got help from Ying Liu
# Talked about how to use loop to increase code's effectiveness

data(faithful)
analyze_columns <- function(df,j){
  j1mean <- mean(df[,j[1]])
  j1median <- median(df[,j[1]])
  j1sd <- sd(df[,j[1]])
  j1 <- c(j1mean, j1median, j1sd)
  
  j2mean <- mean(df[,j[2]])
  j2median <- median(df[,j[2]])
  j2sd <- sd(df[,j[2]])
  j2 <- c(j2mean,j2median,j2sd)
  
  mattep <- cbind(df[,j[1]],df[,j[2]])
  cormat <- cor(mattep)
  list1 <- list(j1,j2,cormat)
  names(list1) <- c(colnames(df[,j]),"correlation_matrix")
  return(list1)
}

analyze_columns(df = faithful, c(1,2))
analyze_columns(df = iris, c(4,1))
