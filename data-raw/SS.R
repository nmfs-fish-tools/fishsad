## code to prepare `SS` datasets
folder_name <- file.path("data-raw", "SS")

# `ss_empirical_waa_` dataset  --------------------------------------------------------

ss_empiricalwaa_input <- fishsad::read_ss_input(
  file_path = folder_name,
  data_file = "ss_empiricalwaa_data.ss",
  control_file = "ss_empiricalwaa_control.ss",
  starter_file = "ss_empiricalwaa_starter.ss",
  forecast_file = "ss_empiricalwaa_forecast.ss",
  watage_file = "ss_empiricalwaa_wtatage.ss",
  version = "3.30"
)

usethis::use_data(ss_empiricalwaa_input, overwrite = TRUE)
