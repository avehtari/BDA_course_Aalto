context("mu_pred_point_est()")

test_that("mu_pred_point_est()", {  
  
  #-----------------------------------------------------------------------------------
  # test for mu_pred_point_est()
  #-----------------------------------------------------------------------------------
  expect_true(exists("mu_pred_point_est"),
              info = "Error: mu_pred_point_est() is missing")
  checkmate::expect_function(mu_pred_point_est, args = c("data"), 
                             info = "Incorrect function arguments.")
  
  test1 <- c(13.3, 14.9, 14.8, 14.8)
  expect_equivalent(mu_pred_point_est(data = test1), 14.5, tol= 0.01, 
                    info = "Error: Incorrect result for vector c(13.3, 14.9, 14.8, 14.8)")
  expect_equivalent(mu_pred_point_est(data = 1:10), 5.5, tol= 0.01, 
                    info = "Error: Incorrect result for vector 1:10")
  
  
})


