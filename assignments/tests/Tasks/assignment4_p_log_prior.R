context("p_log_prior()")

test_that("p_log_prior()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_log_prior()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_log_prior"),
              info = "Error: p_log_prior() is missing")
  checkmate::expect_function(p_log_prior, args = c("alpha", "beta"), 
                             info = "Incorrect function arguments.")
  
  expect_equivalent(p_log_prior(alpha = 3, beta = 9), -6.2964349704, tol= 0.00001, info = "Error: Incorrect result for (alpha,beta) = c(3,9)")
  
  expect_equivalent(p_log_prior(alpha = 1, beta = 1), -5.6964349704, tol= 0.00001, info = "Error: Incorrect result for (alpha,beta) = c(1,1)")
  
})



