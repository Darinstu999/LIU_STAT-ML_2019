set.seed(1234567890)
Var <- runif(50, 0, 10)
trva <- data.frame(Var, Sin=sin(Var)) tr <- trva[1:25,] # Training
va <- trva[26:50,] # Validation
# plot(trva) # plot(tr)
# plot(va)
w_j <- runif(10, -1, 1) b_j <- runif(10, -1, 1) w_k <- runif(10, -1, 1) b_k <- runif(1, -1, 1)
l_rate <- 1/nrow(tr)^2 
n_ite = 5000
error <- rep(0, n_ite) error_va <- rep(0, n_ite)
for(i in 1:n_ite) {
  # error computation: Your code here
  cat("i: ", i, ", error: ", error[i]/2, ", error_va: ", error_va[i]/2, "\n") flush.console()

  #  732A99/732A68/ TDDE01 Machine Learning Division of Statistics and Machine Learning Department of Computer and Information Science
  for(n in 1:nrow(tr)) {
    # forward propagation: Your code here
    # backward propagation: Your code here }
  }
  # print final weights and errors
  w_j 
  b_j 
  w_k 
  b_k
  plot(error/2, ylim=c(0, 5)) points(error_va/2, col = "red")
  # plot prediction on training data
  pred <- matrix(nrow=nrow(tr), ncol=2)
  for(n in 1:nrow(tr)) {
    z_j <-
      y_k <-
      pred[n,] <- c(tr[n,]$Var, y_k) }
  plot(pred)
  points(tr, col = "red")
  # plot prediction on validation data pred <- matrix(nrow=nrow(tr), ncol=2) for(n in 1:nrow(va)) {
  z_j <-
    y_k <-
    pred[n,] <- c(va[n,]$Var, y_k) }
plot(pred)
points(va, col = "red")
