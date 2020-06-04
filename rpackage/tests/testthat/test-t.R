
context("tnew")

test_that(desc="dtnew()",{
  expect_equivalent(dtnew(0, 2), dt(0,2))
  expect_equivalent(dtnew(1, 3), dt(1,3))
})

test_that(desc="rtnew()",{
  set.seed(4711)
  t1 <- rt(10, 2)
  set.seed(4711)
  expect_equivalent(rtnew(10, 2), t1)

  set.seed(4711)
  t1 <- rt(2, 5)
  set.seed(4711)
  expect_equivalent(rtnew(2, 5), t1)
})


test_that(desc="ptnew()",{
  expect_equivalent(ptnew(q = 0.2, df = 2), pt(q = 0.2, df = 2))
  expect_equivalent(ptnew(q = 0.5, df = 3), pt(q = 0.5, df = 3))
})


test_that(desc="qtnew()",{
  expect_equivalent(qtnew(p = 0.2, df = 2), qt(p = 0.2, df = 2))
  expect_equivalent(qtnew(p = 0.5, df = 3), qt(p = 0.5, df = 3))
})
