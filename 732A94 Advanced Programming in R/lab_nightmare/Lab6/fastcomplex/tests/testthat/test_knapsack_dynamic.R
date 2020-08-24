context("knapsack_dynamic")

suppressWarnings(RNGversion("3.5.9"))
set.seed(42)
n <- 2000
knapsack_objects <- data.frame(
  w=sample(1:4000, size = n, replace = TRUE),
  v=runif(n = n, 0, 10000)
)

test_that("Correct object is returned", {
  expect_silent(bfk <- knapsack_dynamic(x = knapsack_objects[1:8,], W = 3500))
  expect_named(bfk, c("value", "elements"))
})

test_that("functions rejects errounous input.", {
  expect_error(knapsack_dynamic("hej", 3500))
  expect_error(knapsack_dynamic(x = knapsack_objects[1:8,], W = -3500))
})

test_that("functions return correct specific results.", {
 
#expect_equal(knapsack_dynamic(x = knapsack_objects[1:8,], W = 3500)[2], list(elements=c(3,6)))
  
  bfk <- knapsack_dynamic(x = knapsack_objects[1:8,], W = 5000)
  expect_equal(round(bfk$value), 23769)
  expect_true(all(round(bfk$elements) %in% c(1, 3)))
  
  
  st <- system.time(bfk <- knapsack_dynamic(x = knapsack_objects[1:16,], W = 2000))
  expect_true(as.numeric(st)[2] >= 0.00)
})


