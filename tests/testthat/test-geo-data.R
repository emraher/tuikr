test_that("geo_data returns metadata without parameters", {
  skip_on_cran()
  skip_if_offline()
  
  dt <- geo_data()
  
  expect_s3_class(dt, "tbl_df")
  expect_true("var_name" %in% names(dt))
  expect_true("var_num" %in% names(dt))
  expect_true(nrow(dt) > 0)
})

test_that("geo_data validates NUTS level", {
  expect_error(
    geo_data(variable_level = 5),
    "variable_level must be 2, 3, or 4"
  )
})
