## code to prepare `SS` datasets
folder_name <- file.path("data-raw", "SS")

# `ss_empirical_waa_` dataset  --------------------------------------------------------

ss_empirical_waa_input <- fishsad::ss_input(
  file_path = folder_name,
  data_file = "ss_empirical_waa_data.ss",
  control_file = "ss_empirical_waa_control.ss",
  starter_file = "ss_empirical_waa_starter.ss",
  forecast_file = "ss_empirical_waa_forecast.ss",
  watage_file = "ss_empirical_waa_wtatage.ss",
  version = "3.30"
)

usethis::use_data(ss_empirical_waa_input, overwrite = TRUE)
