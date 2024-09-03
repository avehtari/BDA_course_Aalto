
context("p_red()")

test_that("p_red()", {  

  #-----------------------------------------------------------------------------------
  # test for p_red()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_red"),
              info = "Error: p_red() is missing")
  checkmate::expect_function(p_red, args = c("boxes"), 
                             info = "Incorrect function arguments.")
  
  boxes <- matrix(c(2,2,1,5,5,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equivalent(p_red(boxes = boxes), 0.3928571, tol= 0.00001, 
                    info = "Error: Incorrect result for matrix(c(2,2,1,5,5,1), ncol = 2)")
  
  boxes <- matrix(c(1,1,1,1,1,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equivalent(p_red(boxes = boxes), 0.5, tol= 0.001, 
                    info = "Error: Incorrect result for matrix(c(1,1,1,1,1,1), ncol = 2)")
})
