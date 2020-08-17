context("p_identical_twin()")

test_that("p_identical_twin()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_identical_twin()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_identical_twin"),
              info = "Error: p_identical_twin() is missing")
  checkmate::expect_function(p_identical_twin, args = c("fraternal_prob", "identical_prob"), 
                             info = "Incorrect function arguments.")
  
  expect_equivalent(p_identical_twin(fraternal_prob = (1/125), identical_prob = (1/300)), 0.4545455, tol= 0.00001, 
                    info = "Error: Incorrect result for fraternal_prob = 1/125 and identical_prob = 1/300")
  
  expect_equivalent(p_identical_twin(fraternal_prob = 1/100, identical_prob = 1/500), 0.2857143, tol= 0.00001, 
                    info = "Error: Incorrect result for fraternal_prob = 1/100 and identical_prob = 1/500")

  expect_equivalent(p_identical_twin(fraternal_prob = 1/10, identical_prob = 1/20), 0.5, tol= 0.00001, 
                    info = "Error: Incorrect result for fraternal_prob = 1/10 and identical_prob = 1/20")  
  
})
