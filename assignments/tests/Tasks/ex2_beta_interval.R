context("beta_interval()")

test_that("beta_interval()", {  
  
  #-----------------------------------------------------------------------------------
  # test for beta_interval()
  #-----------------------------------------------------------------------------------
  expect_true(exists("beta_interval"),
              info = "Error: beta_interval() is missing")
  checkmate::expect_function(beta_interval, args = c("prior_alpha", "prior_beta", "data", "prob"), 
                             info = "Incorrect function arguments.")
  
  test <- c(0, 1, 1, 0, 1, 1)
  alpha <- 2
  beta <- 4
  expect_equivalent(beta_interval(prior_alpha = alpha, prior_beta = beta, data = test, prob = 0.9), 
                    c(0.2712499, 0.7287501), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 2, prior_beta = 4 and data = c(0, 1, 1, 0, 1, 1) and 90% interval.")
  
  test <- c(0, 1, 1, 0, 1, 1, 0, 1)
  alpha <- 3
  beta <- 5
  expect_equivalent(beta_interval(prior_alpha = alpha, prior_beta = beta, data = test, prob = 0.9), 
                    c(0.2999865,0.7000135), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 3, prior_beta = 5 and data = c(0, 1, 1, 0, 1, 1, 0, 1) and 90% interval.")

  test <- c(0, 1, 1, 0, 1, 1, 0, 1, 1, 1)
  alpha <- 3
  beta <- 5
  expect_equivalent(beta_interval(prior_alpha = alpha, prior_beta = beta, data = test, prob = 0.9), 
                    c(0.3640088, 0.7398856), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 3, prior_beta = 5 and data = c(0, 1, 1, 0, 1, 1, 0, 1, 1, 1) and 90% interval.")
    
})



