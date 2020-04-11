context("beta_point_est()")

test_that("beta_point_est()", {  
  
  #-----------------------------------------------------------------------------------
  # test for beta_point_est()
  #-----------------------------------------------------------------------------------
  expect_true(exists("beta_point_est"),
              info = "Error: beta_point_est() is missing")
  checkmate::expect_function(beta_point_est, args = c("prior_alpha", "prior_beta", "data"), 
                             info = "Incorrect function arguments.")
  
  test <- c(0, 1, 1, 0, 1, 1)
  alpha <- 2
  beta <- 4
  expect_equivalent(beta_point_est(prior_alpha = alpha, prior_beta = beta, data = test), 
                    c(0.5), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 2, prior_beta = 4 and data = c(0, 1, 1, 0, 1, 1)")
  
  test <- c(0, 1, 1, 0, 1, 1, 0, 1)
  alpha <- 3
  beta <- 5
  expect_equivalent(beta_point_est(prior_alpha = alpha, prior_beta = beta, data = test), 
                    c(0.5), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 3, prior_beta = 5 and data = c(0, 1, 1, 0, 1, 1, 0, 1)")

  test <- c(0, 1, 1, 0, 1, 1, 0, 1, 1, 1)
  alpha <- 3
  beta <- 5
  expect_equivalent(beta_point_est(prior_alpha = alpha, prior_beta = beta, data = test), 
                    c(0.5555556), tol= 0.001, 
                    info = "Error: Incorrect result for prior_alpha = 3, prior_beta = 5 and data = c(0, 1, 1, 0, 1, 1, 0, 1, 1, 1)")
    
})



