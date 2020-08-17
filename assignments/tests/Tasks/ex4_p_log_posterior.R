context("p_log_posterior()")

test_that("p_log_posterior()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_log_posterior()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_log_posterior"),
              info = "Error: p_log_posterior() is missing")
  checkmate::expect_function(p_log_posterior, args = c("alpha", "beta", "x", "y", "n"), 
                             info = "Incorrect function arguments.")
  
  
  x <- c(-0.86, -0.30, -0.05, 0.73)
  y <- c(0, 1, 3, 5)
  n <- c(5, 5, 5, 5)

  alpha <- 3
  beta <- 9
  expect_equivalent(p_log_posterior(alpha, beta, x = x, y = y, n = n), -15.7879796964, tol= 0.00001, 
                    info = "Error: Incorrect result for (alpha,beta) = c(3,9)")
  
  alpha <- 1
  beta <- 1
  expect_equivalent(p_log_posterior(alpha, beta, x = x, y = y, n = n), -18.6911753549, tol= 0.00001, 
                    info = "Error: Incorrect result for (alpha,beta) = c(1,1)")
  
})



