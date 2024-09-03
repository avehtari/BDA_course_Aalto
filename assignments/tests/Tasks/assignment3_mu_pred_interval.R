context("mu_pred_interval()")

test_that("mu_pred_interval()", {  
  
  #-----------------------------------------------------------------------------------
  # test for mu_pred_interval()
  #-----------------------------------------------------------------------------------
  expect_true(exists("mu_pred_interval"),
              info = "Error: mu_pred_interval() is missing")
  checkmate::expect_function(mu_pred_interval, args = c("data", "prob"), 
                             info = "Incorrect function arguments.")
  
  test1 <- c(13.3, 14.9, 14.8, 14.8)
  expect_equivalent(mu_pred_interval(test1, 0.95), c(11.7, 17.2), tol= 0.01, 
                    info = "Error: Incorrect result for  c(13.3, 14.9, 14.8, 14.8), (95%)")
  expect_equivalent(mu_pred_interval(1:10, 0.95), c(-1.7, 12.7), tol= 0.01, 
                    info = "Error: Incorrect result for 1:10, (95%)")
  expect_equivalent(mu_pred_interval(1:10, 0.8), c(1.1, 9.9), tol= 0.01, 
                    info = "Error: Incorrect result for 1:10, (80%)")
})


