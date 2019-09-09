context("mu_interval()")

test_that("mu_interval()", {  
  
  #-----------------------------------------------------------------------------------
  # test for mu_interval()
  #-----------------------------------------------------------------------------------
  expect_true(exists("mu_interval"),
              info = "Error: mu_interval() is missing")
  
  test1 <- c(13.3, 14.9, 14.8, 14.8)
  expect_equal(unname(mu_interval(test1, 0.9)), c(13.2, 15.7), tol= 0.01, info = "Error: Incorrect result for c(13.3, 14.9, 14.8, 14.8) using a 90% interval.")
  expect_equal(unname(mu_interval(1:10, 0.9)), c(3.3, 7.7), tol= 0.01, info = "Error: Incorrect result for 1:10 using a 90% interval.")
  expect_equal(unname(mu_interval(1:10, 0.8)), c(4.2, 6.8), tol= 0.01, info = "Error: Incorrect result for 1:10 using a 80% interval.")
})



