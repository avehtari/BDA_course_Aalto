context("p_box()")

test_that("p_box()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_box()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_box"),
              info = "Error: p_box() is missing")
  checkmate::expect_function(p_box, args = c("boxes"), 
                             info = "Incorrect function arguments.")
  
  boxes <- matrix(c(2,2,1,5,5,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equivalent(p_box(boxes = boxes), c(0.29090909, 0.07272727, 0.63636364), tol= 0.00001, info = "Error: Incorrect result for matrix(c(2,2,1,5,5,1), ncol = 2)")
  
  boxes <- matrix(c(1,1,1,1,1,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equivalent(p_box(boxes = boxes), c(0.4, 0.1, 0.5), tol= 0.001, info = "Error: Incorrect result for matrix(c(1,1,1,1,1,1), ncol = 2)")
})



