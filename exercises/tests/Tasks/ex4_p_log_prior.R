context("p_log_prior()")

test_that("p_log_prior()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_log_prior()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_log_prior"),
              info = "Error: p_log_prior() is missing")
  
  
  alpha <- 3
  beta <- 9
  expect_equal(p_log_prior(alpha,beta), -6.2964349704, tol= 0.00001, info = "Error: Incorrect result for (alpha,beta) = c(3,9)")
  
  alpha <- 1
  beta <- 1
  expect_equal(p_log_prior(alpha,beta), -5.6964349704, tol= 0.00001, info = "Error: Incorrect result for (alpha,beta) = c(1,1)")
  
})



