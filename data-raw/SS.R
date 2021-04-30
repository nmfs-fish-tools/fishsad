## code to prepare `SS` datasets
folder_name <- file.path("data-raw", "SS")

# `ss_simple_` dataset  --------------------------------------------------------

ss_data <- r4ss::SS_readdat_3.30(
  file = file.path(
    folder_name,
    "ss_empirical_waa_data.ss"
  ),
  verbose = TRUE
)

ss_control <- r4ss::SS_readctl_3.30(
  file = file.path(folder_name, "ss_empirical_waa_control.ss"),
  verbose = TRUE,
  nseas = ss_data$nseas,
  N_areas = ss_data$Nareas,
  Nages = ss_data$Nages,
  Ngenders = ss_data$Nsexes,
  Nfleet = nrow(ss_data$fleetinfo[ss_data$fleetinfo$type == 1, ]),
  Nsurveys = nrow(ss_data$fleetinfo[ss_data$fleetinfo$type == 3, ]),
  Do_AgeKey = FALSE,
  N_tag_groups = NA,
  N_CPUE_obs = c(
    table(ss_data$catch$V3),
    table(ss_data$CPUE$index)
  ),
  use_datlist = FALSE,
  datlist = NULL
)

ss_wtatage <- r4ss::SS_readwtatage(
  file.path(
    folder_name,
    "ss_empirical_waa_wtatage.ss"
  ),
  verbose = TRUE
)

ss_starter <- r4ss::SS_readstarter(
  file.path(
    folder_name,
    "ss_empirical_waa_starter.ss"
  ),
  verbose = TRUE
)

ss_projection <- r4ss::SS_readforecast(
  file.path(
    folder_name,
    "ss_empirical_waa_forecast.ss"
  ),
  version = "3.30",
  verbose = TRUE
)

ss_empirical_waa_input  <- list(
  ss_starter = ss_starter,
  ss_wtatage = ss_wtatage,
  ss_control = ss_control,
  ss_data = ss_data,
  ss_projection = ss_projection
)

usethis::use_data(ss_empirical_waa_input, overwrite = TRUE)
