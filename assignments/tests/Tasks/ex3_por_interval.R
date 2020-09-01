context("posterior_odds_ratio_interval()")


test_that("posterior_odds_ratio_interval()", {  
  
  #-----------------------------------------------------------------------------------
  # test for posterior_odds_ratio_interval()
  #-----------------------------------------------------------------------------------
  expect_true(exists("posterior_odds_ratio_interval"),
              info = "Error: posterior_odds_ratio_interval() is missing")
  checkmate::expect_function(posterior_odds_ratio_interval, args = c("p0", "p1", "prob"), 
                             info = "Incorrect function arguments.")  
  
  set.seed(4711)
  p0 <- rbeta(100000, 5, 95)
  p1 <- rbeta(100000, 10, 90)
  expect_equivalent(posterior_odds_ratio_interval(p0, p1, 0.9), c(0.875367, 6.059110), tol= 0.1, 
                    info = "Error: Incorrect result for p0 = rbeta(100000, 5, 95), p1 = rbeta(100000, 10, 90) and 90%.")
  expect_equivalent(posterior_odds_ratio_interval(p1, p0, 0.9), c(0.1650407, 1.1423780), tol= 0.01, 
                    info = "Error: Incorrect result for p1 = rbeta(100000, 5, 95), p0 = rbeta(100000, 10, 90) and 90%.")
  expect_equivalent(posterior_odds_ratio_interval(p1, p0, 0.8), c(0.2086461, 0.9392956), tol= 0.01, 
                    info = "Error: Incorrect result for p1 = rbeta(100000, 5, 95), p0 = rbeta(100000, 10, 90) and 80%.")
  
  set.seed(4711)
  p0 <- rbeta(100000, 5, 5)
  p1 <- rbeta(100000, 6, 5)
  expect_equivalent(posterior_odds_ratio_interval(p0, p1, 0.9), c(0.2714472, 5.5970131), tol= 0.01, 
                    info = "Error: Incorrect result for p0 = rbeta(100000, 5, 5), p1 = rbeta(100000, 5, 6) and 90%.")
  expect_equivalent(posterior_odds_ratio_interval(p1, p0, 0.9), c(0.1786667, 3.6839583), tol= 0.01, 
                    info = "Error: Incorrect result for p0 = rbeta(100000, 5, 6), p1 = rbeta(100000, 5, 5) and 90%.")
  expect_equivalent(posterior_odds_ratio_interval(p1, p0, 0.8), c(0.252972, 2.633517), tol= 0.01, 
                    info = "Error: Incorrect result for p0 = rbeta(100000, 5, 6), p1 = rbeta(100000, 5, 5) and 80%.")  
})



