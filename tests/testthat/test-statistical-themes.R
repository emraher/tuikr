test_that("statistical_themes returns a tibble", {
  skip_on_cran()
  skip_if_offline()
  
  themes <- statistical_themes()
  
  expect_s3_class(themes, "tbl_df")
  expect_named(themes, c("theme_name", "theme_id"))
  expect_true(nrow(themes) > 0)
  expect_type(themes$theme_id, "character")
})
