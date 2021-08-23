## code to prepare `ASAP` dataset

folder_name <- file.path("data-raw", "ASAP")

# code to prepare `asap_simple_` dataset ------------------------------------------------------

asap_simple_input <- ASAPplots::ReadASAP3DatFile(file.path(folder_name, "asap_simple.dat"))

asap_simple_output <- dget(file.path(folder_name, "asap_simple.rdat"))

asap_simple <- list(input = asap_simple_input,
                    output = asap_simple_output)

usethis::use_data(asap_simple, internal = FALSE, overwrite = TRUE)

