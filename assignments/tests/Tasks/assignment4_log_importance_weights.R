
context("log_importance_weights()")

test_that("log_importance_weights()", {  
  
  #-----------------------------------------------------------------------------------
  # test for log_importance_weights()
  #-----------------------------------------------------------------------------------
  expect_true(exists("log_importance_weights"),
              info = "Error: log_importance_weights() is missing")
  checkmate::expect_function(log_importance_weights, args = c("alpha", "beta"), 
                             info = "Incorrect function arguments.")
  
  alpha <- c(1.896, -3.6,  0.374, 0.964, -3.123, -1.581)
  beta <- c(24.76, 20.04, 6.15, 18.65, 8.16, 17.4)
  expect_equivalent(log_importance_weights(alpha, beta), 
                    c(-8.954344, -23.468325, -6.015096, -8.130099, -16.613100, -14.573095), 
                    tol= 0.1, 
                    info = "Error: Incorrect result for alpha = c(1.896, -3.6,  0.374, 0.964, -3.123, -1.581) and beta = c(24.76, 20.04, 6.15, 18.65, 8.16, 17.4).")
  
  alpha <- c(4.5, 1.8, -2.4, 0.7, 0.3, -3.1, 0.4, 1.7, -0.5, -0.1)
  beta <- c(25.2, 7, -5.6, 1.1, 14.7, -6.5, 14.2, 25.9, 13.4, 19.8)
  expect_equivalent(log_importance_weights(alpha, beta), 
                    c(-9.96, -7.10, -54.58, -11.40, -7.99, -63.23, -7.64, -9.45, -9.44, -10.77), 
                    tol= 0.1, 
                    info = "Error: Incorrect result for alpha = c(4.5, 1.8, -2.4, 0.7, 0.3, -3.1, 0.4, 1.7, -0.5, -0.1) and beta = c(25.2, 7, -5.6, 1.1, 14.7, -6.5, 14.2, 25.9, 13.4, 19.8).")
  
  
  alpha <- c(1.4, 1.5, -2.3, -2.3, -0.5, 1.9, 1.6, -1.8, -2.7, -1.9)
  beta <- c(11.4, 8.2, 10.8, 7.4, 18.2, 27.8, 5.1, 1.9, -15.7, 25.1)
  expect_equivalent(log_importance_weights(alpha, beta), 
                    c(-6.11, -6.23, -14.38, -13.14, -11.30, -9.82, -7.75, -13.96, -139.92, -19.10), 
                    tol= 0.1, 
                    info = "Error: Incorrect result for alpha = c(1.4, 1.5, -2.3, -2.3, -0.5, 1.9, 1.6, -1.8, -2.7, -1.9) and beta = c(11.4, 8.2, 10.8, 7.4, 18.2, 27.8, 5.1, 1.9, -15.7, 25.1).")
})


