
context("Exercise 1.4")

test_that("p_red()", {  

  #-----------------------------------------------------------------------------------
  # test for p_red()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_red"),
              info = "Error: p_red() is missing")
  
  boxes <- matrix(c(2,2,1,5,5,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equal(p_red(boxes), 0.3928571, tol= 0.00001, info = "Error: Incorrect result for matrix(c(2,2,1,5,5,1), ncol = 2)")
  
  boxes <- matrix(c(1,1,1,1,1,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equal(p_red(boxes), 0.5, tol= 0.001, info = "Error: Incorrect result for matrix(c(1,1,1,1,1,1), ncol = 2)")
})

test_that("p_box()", {  
  
  #-----------------------------------------------------------------------------------
  # test for p_red()
  #-----------------------------------------------------------------------------------
  expect_true(exists("p_box"),
              info = "Error: p_box() is missing")
  
  boxes <- matrix(c(2,2,1,5,5,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equal(p_box(boxes), c(0.29090909, 0.07272727, 0.63636364), tol= 0.00001, info = "Error: Incorrect result for matrix(c(2,2,1,5,5,1), ncol = 2)")
  
  boxes <- matrix(c(1,1,1,1,1,1), ncol = 2, 
                  dimnames = list(c("A", "B", "C"), c("red", "white")))
  expect_equal(p_box(boxes), c(0.4, 0.1, 0.5), tol= 0.001, info = "Error: Incorrect result for matrix(c(1,1,1,1,1,1), ncol = 2)")
})
