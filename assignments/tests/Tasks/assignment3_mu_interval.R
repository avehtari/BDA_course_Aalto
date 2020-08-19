context("mu_interval()")

test_that("mu_interval()", {  
  
  #-----------------------------------------------------------------------------------
  # test for mu_interval()
  #-----------------------------------------------------------------------------------
  expect_true(exists("mu_interval"),
              info = "Error: mu_interval() is missing")
  checkmate::expect_function(mu_interval, args = c("data", "prob"), 
                             info = "Incorrect function arguments.")
  
  test1 <- c(13.3, 14.9, 14.8, 14.8)
  expect_equivalent(mu_interval(data = test1, prob = 0.95), c(13.2, 15.7), tol= 0.01, info = "Error: Incorrect result for c(13.3, 14.9, 14.8, 14.8) using a 95% interval.")
  expect_equivalent(mu_interval(data = 1:10, prob = 0.95), c(3.3, 7.7), tol= 0.01, info = "Error: Incorrect result for 1:10 using a 95% interval.")
  expect_equivalent(mu_interval(data = 1:10, prob = 0.8), c(4.2, 6.8), tol= 0.01, info = "Error: Incorrect result for 1:10 using a 80% interval.")
})



