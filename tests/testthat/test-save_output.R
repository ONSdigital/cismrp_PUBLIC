testthat::test_that(
  desc = "function saves object to correct bucket",
  code = {
    skip_on_ci()
    gcptools::authenticate_gcp()
    test_data <- list(
      data_1 = list(
        object = data.frame(red = c(1, 2, 3)),
        file_id = "test_file_b",
        file_type = "csv"
      ),
      data_2 = list(
        object = data.frame(blue = c(5, 6, 7)),
        file_id = "test_file_a",
        file_type = "csv"
      ),
      config = cismrp::dummy_config
    )

    test_data$config$run_settings$test_configs_short <- TRUE

    save_all_outputs(
      objects = list(
        test_data$data_1$object,
        test_data$data_2$object
      ),
      file_ids = list(
        test_data$data_1$file_id,
        test_data$data_2$file_id
      ),
      file_types = list(
        test_data$data_1$file_type,
        test_data$data_2$file_type
      ),
      config = test_data$config
    )

    saved_files <- googleCloudStorageR::gcs_list_objects(
      bucket = gcptools::gcp_paths$wip_bucket,
      prefix = "test_configs_short_20221205_mrp/test_file"
    )$name

    testthat::expect_true(length(saved_files) == 2)

    purrr::map(
      .x = saved_files,
      .f = googleCloudStorageR::gcs_delete_object,
      bucket = gcptools::gcp_paths$wip_bucket
    )
  }
)
