
context("utility()")

test_that("utility()", {  
  
  #-----------------------------------------------------------------------------------
  # test for utility()
  #-----------------------------------------------------------------------------------
  expect_true(exists("utility"),
              info = "Error: utility() is missing")
  checkmate::expect_function(utility, args = c("draws"), 
                             info = "Incorrect function arguments.")
  
  expect_equivalent(utility(draws = c(123.80, 85.23, 70.16, 80.57, 84.91)),
                    -26, tol= 0.001, 
                    info = "Error: Incorrect result for draws = c(123.80, 101.23, 70.16, 80.57, 84.91).")
  set.seed(4711)
  draws <- rnorm(1000, 93, 18)
  expect_equivalent(utility(draws = draws),
                    28.2, tol= 0.01, 
                    info = "Error: Incorrect result for set.seed(4711) and draws = rnorm(1000, 93, 18).")
  set.seed(4711)
  draws <- rnorm(1000, 100, 10)
  expect_equivalent(utility(draws = draws),
                    80.1, tol= 0.01, 
                    info = "Error: Incorrect result for set.seed(4711) and draws = rnorm(1000, 100, 10).")
})




