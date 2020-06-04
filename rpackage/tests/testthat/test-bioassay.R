
context("bioassay")

test_that(desc="bioassaylp()",{
  data("bioassay")
  expect_equivalent(round(bioassaylp(alpha = 3,
                               beta = 9,
                               x = bioassay$x,
                               y = bioassay$y,
                               n = bioassay$n), 5),
                    -9.49154)
})
