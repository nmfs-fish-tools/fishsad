all_r_files <- list.files(path=file.path("data-raw"), pattern = ".R")
run_r_files <- all_r_files[!(all_r_files %in% "update_data.R")]

for (i in 1:length(run_r_files)){
  source(file.path("data-raw", run_r_files[i]))
}
