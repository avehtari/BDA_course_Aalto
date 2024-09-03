context("beta_low()")

test_that("beta_low()", {  
  
  #-----------------------------------------------------------------------------------
  # test for beta_low()
  #-----------------------------------------------------------------------------------
  expect_true(exists("beta_low"),
              info = "Error: beta_low() is missing")
  checkmate::expect_function(beta_low, args = c("prior_alpha", "prior_beta", "data", "pi_0"), 
                             info = "Incorrect function arguments.")
  
  test <- c(0, 1, 1, 0, 1, 1)
  alpha <- 2
  beta <- 4
  expect_equivalent(beta_low(prior_alpha = alpha, prior_beta = beta, data = test, pi_0 = 0.5), 
                    c(0.5), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 2, prior_beta = 4 and data = c(0, 1, 1, 0, 1, 1)")
  
  test <- c(0, 1, 1, 0, 1, 1, 0, 1)
  alpha <- 3
  beta <- 5
  expect_equivalent(beta_low(prior_alpha = alpha, prior_beta = beta, data = test, pi_0 = 0.5), 
                    c(0.5), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 3, prior_beta = 5 and data = c(0, 1, 1, 0, 1, 1, 0, 1)")

  test <- c(0, 1, 1, 0, 1, 1, 0, 1, 1, 1)
  alpha <- 3
  beta <- 5
  expect_equivalent(beta_low(prior_alpha = alpha, prior_beta = beta, data = test, pi_0 = 0.2), 
                    0.0004932497, tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 3, prior_beta = 5 and data = c(0, 1, 1, 0, 1, 1, 0, 1, 1, 1)")
  
})



