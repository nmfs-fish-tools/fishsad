#' Read SS input files
#'
#' Read in data, control, starter, forecast, weight-at-age data files into a data list in R.
#'
#' @param file_path Path to input files
#' @param data_file Name of data file
#' @param control_file Name of control file
#' @param starter_file Name of starter file
#' @param forecast_file Name of forecast file
#' @param watage_file Name of weight-at-age data file
#' @param version SS version number
#' @return Returns a list with input data.
#' @example
#' \dontrun{
#' ss_input(
#' file_path,
#' data_file = "data.ss",
#' control_file = "control.ss",
#' starter_file = "starter.ss",
#' forecast_file = "forecast.ss",
#' watage_file = "watage.ss",
#' version = "3.30"
#' )
#' }
#' @export

ss_input <- function(file_path,
                     data_file,
                     control_file,
                     starter_file,
                     forecast_file,
                     watage_file,
                     version = "3.30"){

  ss_data <- r4ss::SS_readdat(
    file = file.path(file_path, data_file),
    version = version,
    verbose = TRUE,
    echoall = FALSE,
    section = NULL
  )

  ss_control <- r4ss::SS_readctl(
    file = file.path(file_path, control_file),
    version = version,
    verbose = TRUE,
    echoall = lifecycle::deprecated(),
    use_datlist = TRUE,
    datlist = file.path(file_path, data_file),
    ## Parameters that are not defined in control file
    nseas = NULL,
    N_areas = NULL,
    Nages = NULL,
    Ngenders = lifecycle::deprecated(),
    Nsexes = NULL,
    Npopbins = NA,
    Nfleets = NULL,
    Nfleet = NULL,
    Do_AgeKey = NULL,
    Nsurveys = NULL,
    N_tag_groups = NULL,
    N_CPUE_obs = NULL,
    catch_mult_fleets = NULL,
    N_rows_equil_catch = NULL,
    N_dirichlet_parms = NULL,
    ptype = FALSE
  )

  ss_starter <- r4ss::SS_readstarter(
    file = file.path(file_path, starter_file),
    verbose = TRUE
  )

  ss_forecast <- r4ss::SS_readforecast(
    file = file.path(file_path, forecast_file),
    version = version,
    readAll = FALSE,
    verbose = TRUE,
    Nfleets = NULL,
    Nareas = NULL,
    nseas = NULL
  )

  if (!is.null(watage_file)) {
    ss_wtatage <- r4ss::SS_readwtatage(
      file = file.path(file_path, watage_file),
      verbose = TRUE
    )
  } else {
    ss_wtatage <- NULL
  }

  ss_input <- list(
    ss_data = ss_data,
    ss_control = ss_control,
    ss_starter = ss_starter,
    ss_forecast = ss_forecast,
    ss_wtatage = ss_wtatage
  )

  return(ss_input)
}
