context("p_log_posterior()")

test_that("p_log_posterior()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_log_posterior()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_log_posterior"),
              info = "Error: p_log_posterior() is missing")
  
  
  alpha <- 3
  beta <- 9
  expect_equal(p_log_posterior(alpha,beta), -15.7879796964, tol= 0.00001, info = "Error: Incorrect result for (alpha,beta) = c(3,9)")
  
  alpha <- 1
  beta <- 1
  expect_equal(p_log_posterior(alpha,beta), -18.6911753549, tol= 0.00001, info = "Error: Incorrect result for (alpha,beta) = c(1,1)")
  
})



