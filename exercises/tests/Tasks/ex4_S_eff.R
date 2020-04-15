
context("S_eff()")

test_that("S_eff()", {  
  
  #-----------------------------------------------------------------------------------
  # test for S_eff()
  #-----------------------------------------------------------------------------------
  expect_true(exists("S_eff"),
              info = "Error: S_eff() is missing")
  checkmate::expect_function(S_eff, args = c("alpha", "beta"), 
                             info = "Incorrect function arguments.")

  alpha <- c(1.896, -3.6,  0.374, 0.964, -3.123, -1.581)
  beta <- c(24.76, 20.04, 6.15, 18.65, 8.16, 17.4)
  expect_equivalent(S_eff(alpha, beta), 
                    c(1.354), 
                    tol= 0.01, 
                    info = "Error: Incorrect result for alpha = c(1.896, -3.6,  0.374, 0.964, -3.123, -1.581) and beta = c(24.76, 20.04, 6.15, 18.65, 8.16, 17.4).")
  
  alpha <- c(4.5, 1.8, -2.4, 0.7, 0.3, -3.1, 0.4, 1.7, -0.5, -0.1)
  beta <- c(25.2, 7, -5.6, 1.1, 14.7, -6.5, 14.2, 25.9, 13.4, 19.8)
  expect_equivalent(S_eff(alpha, beta), 
                    3.404, 
                    tol= 0.01, 
                    info = "Error: Incorrect result for alpha = c(4.5, 1.8, -2.4, 0.7, 0.3, -3.1, 0.4, 1.7, -0.5, -0.1) and beta = c(25.2, 7, -5.6, 1.1, 14.7, -6.5, 14.2, 25.9, 13.4, 19.8).")
  
  
  alpha <- c(1.4, 1.5, -2.3, -2.3, -0.5, 1.9, 1.6, -1.8, -2.7, -1.9)
  beta <- c(11.4, 8.2, 10.8, 7.4, 18.2, 27.8, 5.1, 1.9, -15.7, 25.1)
  expect_equivalent(S_eff(alpha, beta), 
                    2.448, 
                    tol= 0.01, 
                    info = "Error: Incorrect result for alpha = c(1.4, 1.5, -2.3, -2.3, -0.5, 1.9, 1.6, -1.8, -2.7, -1.9) and beta = c(11.4, 8.2, 10.8, 7.4, 18.2, 27.8, 5.1, 1.9, -15.7, 25.1).")
})




