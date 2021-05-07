# fishsad - Fisheries Stock Assessment Data
Repository for example data that can be used for cross-model comparison

## Installation instructions
 
Please install and load `fishsad` from Github using the `remotes` package as follows:

```r
install.packages("remotes")
remotes::install_github("nmfs-fish-tools/fishsad")
library(fishsad)
```

## Load example data
```r
asap_input <- fishsad::asap_simple_input
asap_output <- fishsad::asap_simple_output
ss_input <- fishsad::ss_empiricalwaa_input
```
The source links of the data are included in help pages.  
More documentation of the data can be obtained using `?fishsad::asap_simple_input`.

## Acknowledgements

Thanks `ChristineStawitz-NOAA` for the idea to prepackage the stock assessment test data!  
I set up the repo following the instructions [here](https://www.davekleinschmidt.com/r-packages/) with some minor changes (e.g., use `usethis::use_data_raw()` instead of `devtools::use_data_raw()`).


