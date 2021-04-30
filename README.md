# fsad - Fisheries Stock Assessment Data
Repository for example data that can be used for cross-model comparison

## Installation instructions
 
Please install and load `fsad` from Github using the `remotes` package as follows:

```r
install.packages("remotes")
remotes::install_github("Bai-Li-NOAA/fsad")
library(fsad)
```

## Load example data
```r
asap_input <- fsad::asap_simple_input
asap_output <- fsad::asap_simple_output
ss_input <- fsad::ss_empirical_waa_input
```
The source links of the data are included in help pages.  
More documentation of the data can be obtained using `?fsad::asap_simple_input`.

## Acknowledgements

Thanks `ChristineStawitz-NOAA` for the idea to prepackage the stock assessment test data!  
I set up the repo following the instructions [here](https://www.davekleinschmidt.com/r-packages/) with some minor changes (e.g., use `usethis::use_data_raw()` instead of `devtools::use_data_raw()`).


