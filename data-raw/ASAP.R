## code to prepare `ASAP` dataset

folder_name <- file.path("data-raw", "ASAP")

# code to prepare `asap_simple_` dataset ------------------------------------------------------

asap_simple_input <- ASAPplots::ReadASAP3DatFile(file.path(folder_name, "asap_simple.dat"))
usethis::use_data(asap_simple_input, internal = FALSE, overwrite = TRUE)

asap_simple_output <- dget(file.path(folder_name, "asap_simple.rdat"))
usethis::use_data(asap_simple_output, internal = FALSE, overwrite = TRUE)

