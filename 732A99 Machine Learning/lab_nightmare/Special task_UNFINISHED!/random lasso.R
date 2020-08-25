library(readxl)
library(glmnet)
library(ggplot2)

data <-read_excel("/Users/darin/Desktop/spambase.xlsx")

####create the importance func####
coeff <- function(indep, dep) {
  # lasso method, set alpha to 1
  lasso_model <- glmnet(indep, dep, alpha = 1, family = "gaussian")
  # set nfolds to 4
  cv_lasso <- cv.glmnet(indep, dep, alpha = 1, nfolds = 4)
  # use lambda.min as s
  # get the coeffiecents as importance
  beta_hat1 <- predict.glmnet(lasso_model, 
                              type = "coefficients",
                              s = cv_lasso$lambda.min)
  # remove intercept's coeff and return final result
  beta_hat <- beta_hat1[-1]
  return(beta_hat)
}

indep <- as.matrix(data[,1:(ncol(data)-1)])
dep <- as.matrix(data[,ncol(data)])
bs_times <- 100
rd_lasso(x,y,100)
#coeff(x,y)

####random_lasso function####
#rd_lasso <- function(indep, dep, bs_times){

  feature_names <- colnames(indep)
  number_feature <- ncol(indep)
  number_sample <- nrow(indep)

  random_features <- list()
  random_indep <- list()
  random_dep <- list()

  results <- matrix(0, nrow = bs_times, ncol = number_feature)
  colnames(results) <- feature_names
  rownames(results) <- 1:bs_times
  
  # step 1
  for (i in 1:bs_times) {
    set.seed(12345)
    random_features[[i]] <- sample(feature_names, 
                                   round(number_feature/2), 
                                   replace = FALSE)

    random_indep[[i]] <- as.matrix(indep[,random_features[[i]]])
    random_dep[[i]] <- as.matrix(dep)
    
    results[i,random_features[[i]]] <- coeff(random_indep[[i]], random_dep[[i]])
  }
  
  imp_feature <- abs(colMeans(results)) + 1/1000
  a <- imp_feature
  b <- sort(a,decreasing = T)[1:10]
  c <- as.data.frame(b)
  c$name <- names(b)

  ggplot(c, aes(x = c$name, y = c$b)) +
    geom_bar(stat = 'identity') +
    theme_bw() +
    labs(title = 'The most important 10 features',
         x = 'Feature-name',
         y = 'Importance')

  # 
  # step 2
  for (j in 1:bs_times) {
    set.seed(12345)
    random_features[[j]] <- sample(feature_names, 
                                   round(number_feature/2), 
                                   replace = FALSE, 
                                   prob = imp_feature)
    
    random_indep[[j]] <- as.matrix(indep[,random_features[[j]]])
    random_dep[[j]] <- as.matrix(dep)
    
    results[j,random_features[[j]]] <- coeff(random_indep[[j]], random_dep[[j]])
  }
  
  beta_feature <- colMeans(results)
  beta_feature <- as.data.frame(beta_feature)
  b <- beta_feature[which(beta_feature$beta_feature!=0),]
  c <- list(a,b)
  return(c)
}

