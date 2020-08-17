context("posterior_odds_ratio_point_est()")

test_that("posterior_odds_ratio_point_est()", {  
  
  #-----------------------------------------------------------------------------------
  # test for posterior_odds_ratio_point_est()
  #-----------------------------------------------------------------------------------
  expect_true(exists("posterior_odds_ratio_point_est"),
              info = "Error: posterior_odds_ratio_point_est() is missing")
  checkmate::expect_function(posterior_odds_ratio_point_est, args = c("p0", "p1"), 
                             info = "Incorrect function arguments.")  
  
  set.seed(4711)
  p0 <- rbeta(100000, 5, 95)
  p1 <- rbeta(100000, 10, 90)
  expect_equivalent(posterior_odds_ratio_point_est(p0, p1), 2.676146, tol= 0.01, 
                    info = "Error: Incorrect result for p0 = rbeta(100000, 5, 95), p1 = rbeta(100000, 10, 90).")
  expect_equivalent(posterior_odds_ratio_point_est(p1, p0), 0.5307909, tol= 0.01, 
                    info = "Error: Incorrect result for p1 = rbeta(100000, 5, 95), p0 = rbeta(100000, 10, 90).")
  
  set.seed(4711)
  p0 <- rbeta(100000, 5, 5)
  p1 <- rbeta(100000, 6, 5)
  expect_equivalent(posterior_odds_ratio_point_est(p0, p1), 1.876519, tol= 0.01, info = "Error: Incorrect result for p0 = rbeta(100000, 5, 5), p1 = rbeta(100000, 5, 6).")
  expect_equivalent(posterior_odds_ratio_point_est(p1, p0), 1.24902, tol= 0.01, info = "Error: Incorrect result for p0 = rbeta(100000, 5, 6), p1 = rbeta(100000, 5, 5).")
  
})


