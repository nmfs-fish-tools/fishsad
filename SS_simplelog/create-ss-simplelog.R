# Header -----------------------------------------------------------------------
# Manipulate Wt at age model to have the same age structured data s in the 
# ASAp model SIMPLELOGISTIC_ONLY_INDEX1 (1).DAT

# A note on units: it is unclear what the units are on the ASAP model itself 
# just from the program; however, the user manual states that if wt at age is 
# in kg, then catch should be in metric tons, and # of fish should be in 1000s.
# This corresponds with the units used within SS (according to the SS user 
#manual), so we will assume this to be true.

# NOTE: "TODO" included throughout script to indicate potential future changes.

# Load packages, set options ---------------------------------------------------
#devtools::install_github("r4ss/r4ss@development") # use this version
library(r4ss)
library(tidyverse)
library(lubridate)
source("SS_simplelog/SS_read_write_wtatage.R")
options(stringsAsFactors = FALSE)
# Create dirs to store output --------------------------------------------------
# SS model
SS_mod_dir <- file.path("SS_simplelog", "SS_simplelogistic")
SS_ex_mod_dir <- file.path("SS_simplelog", "Wtatage_and_Age_Selex")
dir.create(SS_mod_dir)

# Read in ----------------------------------------------------------------------
# need an SS data, ctl, and wtatage file to start from, as well as the ASAP file
# to reference
dat <- SS_readdat(file.path(SS_ex_mod_dir, "data.ss"), verbose = FALSE)
ASAP <- readLines("SIMPLELOGISTIC_ONLY_INDEX1 (1).DAT")
ASAP_rdat <- dget("SIMPLELOGISTIC_ONLY_INDEX1 (1).RDAT")

ctl <- SS_readctl(file.path(SS_ex_mod_dir, "control.ss"), use_datlist = TRUE,
                  datlist = dat, verbose = FALSE)
wtatage <- SS_readwtatage(file.path(SS_ex_mod_dir, "wtatage.ss"))
starter <- SS_readstarter(file.path(SS_ex_mod_dir, "starter.ss"), verbose = FALSE)
forecast <- SS_readforecast(file.path(SS_ex_mod_dir, "forecast.ss"), verbose = FALSE)
# Manipulate the data file -----------------------------------------------------
old_dat <- dat # save original 

dat$styr <- ASAP_rdat$parms$styr
dat$endyr <- ASAP_rdat$parms$endyr
# dat$nseas
# dat$months_per_seas
# dat$Nsubseasons

# convert the fraction of year spawn to the decimal spawn month as expected by SS
day_spawn <- as.integer(ASAP_rdat$options$frac.yr.spawn*365)
day_spawn <- as.Date(paste0(day_spawn,"-2019"), format = "%j-%Y")
tmp_month_spawn <- month(day_spawn)+(day(day_spawn)/days_in_month(day_spawn))
attributes(tmp_month_spawn)  <- NULL
dat$spawn_month <- tmp_month_spawn


dat$Nsexes <- 1
dat$Nages <- ASAP_rdat$parms$nages
# dat$Nareas
# dat$Nfleets
dat$fleetinfo$surveytiming <- c(-1, 1 ,1) # season long catch is -1.
dat$fleetinfo$units <- c(1,1,2)
# dat$fleetnames
# dat$surveytiming
dat$units_of_catch <- c(1,1,2)
# dat$areas
# dat$catch

#total catch according to ASAP model for fleet 1
tmp_catch <-  as.vector(ASAP_rdat$catch.obs)
#approximate SE based on CV
tmp_catch_se <- as.vector(sqrt(log((ASAP_rdat$control.parms$catch.tot.cv^2)+1)))
tmp_catch_df <- data.frame( year = dat$styr:dat$endyr, seas = 1, fleet = 1, 
                            catch = tmp_catch, catch_se = tmp_catch_se
                           )
dat$catch <- tmp_catch_df

# CPUE 
dat$CPUEinfo
# change indices. Approximate log scale SE from the CV in ASAP.
ind01_SE <- sqrt(log((ASAP_rdat$index.cv$ind01^2)+1))

new_CPUE_1 <- data.frame(year = dat$styr:dat$endyr, 
                         seas = ASAP_rdat$control.parms$index.month[1], 
                         index = 2, 
                         obs = ASAP_rdat$index.obs$ind01,
                         se_log = ind01_SE)
ind02_SE <- sqrt(log((ASAP_rdat$index.cv$ind02^2)+1))
new_CPUE_2 <- data.frame(year = dat$styr:dat$endyr, 
                         seas = ASAP_rdat$control.parms$index.month[2], 
                         index = 3, 
                         obs = ASAP_rdat$index.obs$ind02, 
                         se_log = ind02_SE)
new_CPUE <- rbind(new_CPUE_1, new_CPUE_2)

dat$CPUE <- new_CPUE

# next parts
# dat$N_discard_fleets
# dat$use_meanbodywt

# population length bins (need even if not using length comp)
# I think does not matter what these are if not using length comp data?
dat$lbin_method
dat$binwidth
dat$minimum_size
dat$maximum_size

# No length comp data included, so don't need. code to get rid of length comp,
# if necessary:
# dat$use_lencomp <- 0
# dat$len_info <- NULL
# dat$N_lbins <- NULL
# dat$lbin_vector <- NULL
# dat$lencomp <- NULL

# age comp data 
new_agebin_vector <- 1:dat$Nages
dat$N_agebins <- length(new_agebin_vector)
dat$agebin_vector <- new_agebin_vector

# Looks like no ageing error is included in ASAP? So set so there is no bias
# and very little uncertainty.
dat$N_ageerror_definitions <- 1
new_ageerror <- data.frame(matrix(c(rep(-1, times = (dat$Nages+1)), 
                                    rep(0.001, times = (dat$Nages+1))), 
                                  ncol = (dat$Nages+1), byrow = TRUE
                                  )
                           )
colnames(new_ageerror) <- paste0("age", 0:dat$Nages)
dat$ageerror <- new_ageerror

# TODO: check this, but leave for now.
#I think we assume the obs combine males and females so set to 0.?
dat$age_info$combine_M_F <- c(0,0,0)
# Bin method for age data: using population bin (1) ok? Or is actual length (3)
# better?
dat$Lbin_method <- 1

#get age comp
# TODO: add in the fishery age comp; however, only have proportions and total
# weight, not numbers of fish. HOw to input this as age comp data in SS?
new_fish_agecomp_prop <-  ASAP_rdat$catch.comp.mats$catch.fleet1.ob

# survey
newagecomp_dat_prop <- ASAP_rdat$index.comp.mats$ind01.ob    
samplesize <- ASAP_rdat$index.Neff.init[1, ]
new_agecomp <- apply(newagecomp_dat_prop, MARGIN = 2, function(x) x*samplesize)
# coerce to data frame
new_agecomp_dat <- data.frame(new_agecomp)
new_agecomp_n <- data.frame(Nsamp = samplesize)
colnames(new_agecomp_dat) <- paste0("f", 1:ncol(new_agecomp_dat))
new_agecomp_dat <- data.frame(lapply(new_agecomp_dat, as.integer))

new_agecomp_df <- data.frame(Yr = as.integer(rownames(newagecomp_dat_prop)), 
                             Seas = ASAP_rdat$control.parms$index.month[1], 
                             FltSvy = 2, Gender = 0, Part = 0, Ageerr = 1, 
                             Lbin_low = -1, Lbin_hi = -1) %>% 
                             bind_cols(new_agecomp_n) %>% 
                             bind_cols(new_agecomp_dat)
# git rid of rows with Nsamp = 0
new_agecomp_df <- filter(new_agecomp_df, Nsamp > 0)
# replace old agecomp data.
dat$agecomp <- new_agecomp_df

# All the following should be set to 0 already:
dat$use_MeanSize_at_Age_obs <- 0
dat$N_environ_variables <- 0
dat$N_sizefreq_methods <- 0
dat$do_tags <- 0
dat$morphcomp_data <- 0
dat$use_selectivity_priors <- 0

# other list components (do these need to be modified?)
dat$eof # end of file should be = T

# The rest of the list components are added for back compatibility.
# Set these to NULL for now just to make sure they aren't used.
# However, may need to add back in in the future.
start_comp <- which(names(dat) == "eof")+1
end_comp <- length(dat)
for(i in end_comp:start_comp) dat[[i]] <- NULL


#write data file ---------------------------------------------------------------

SS_writedat(dat, outfile = file.path(SS_mod_dir, "data.ss"), overwrite = TRUE)

# Manipulate ctl file ----------------------------------------------------------
# save original 
old_ctl <- ctl

#Auxilary info orginially read from the data file.
ctl$warnings
ctl$nseas <- dat$nseas
ctl$N_areas <- dat$Nareas
ctl$Nages <- dat$Nages
ctl$Ngenders <- dat$Ngenders
ctl$Nfleet <- dat$Nfleet # b/c 1 fishery. does not include surveys
ctl$Nsurveys <- 2
ctl$Do_AgeKey <- 0
# calculate this from data file (from https://github.com/r4ss/r4ss/blob/master/R/SS_readctl_3.30.R#L227)
ctl$N_CPUE_obs <- sapply(1:(ctl$Nfleet+ctl$Nsurveys),function(i){sum(dat$CPUE[,"index"]==i)})
ctl$fleetnames  <- dat$fleetnames
ctl$sourcefile
ctl$type
ctl$ReadVersion 
ctl$eof

# start of the ctl file
ctl$EmpiricalWAA <- 1
ctl$N_GP <- 1
ctl$N_platoon <- 1
#for back compatibility:
ctl$sd_ratio <- 1
ctl$submorphdist <- 1
# recruitiment distribution:
ctl$recr_dist_method <- 4 #simpler to use than 2
ctl$recr_global_area <- 1
ctl$recr_dist_read # leave as is 
ctl$recr_dist_inx <- 0
ctl$recr_dist_pattern$age <-  1 # b/c spawning happens ~ May 8th.
# blocks: leave as is, b/c not used
ctl$N_Block_Designs
ctl$blocks_per_pattern
ctl$Block_Design <- list(c(dat$styr, dat$styr))
# Autogen
ctl$time_vary_adjust_method <- 1
ctl$time_vary_auto_generation <- rep(1, times = 5)
# setup biology
if(length(unique(as.numeric(ASAP_rdat$M.age))) == 1) {
  ctl$natM_type <- 0
} else {
  stop("Natural mortality type is not 0, so this script will need to be modified.")
}
# note that growth is not modelled but taken from the wtatage.ss file, so should
# be able to leave as is.
ctl$GrowthModel
ctl$Growth_Age_for_L1
ctl$Growth_Age_for_L2 <- ctl$Nages - 1
ctl$Exp_Decay
ctl$N_natMparms
ctl$Growth_Placeholder
ctl$SD_add_to_LAA
ctl$CV_Growth_Pattern

# maturity at age used in ASAP
ctl$maturity_option <- 3  # to read
#In this model, maturity is the same across yrs, so just grab the first row.
tmp_Age_Maturity <- ASAP_rdat$maturity[1, ]
tmp_Age_Maturity <- c(0, tmp_Age_Maturity) # add yr 0
# make into a dataframe.
tmp_Age_Maturity <- data.frame(matrix(tmp_Age_Maturity, nrow = 1))
colnames(tmp_Age_Maturity) <- as.character(0:(ncol(tmp_Age_Maturity)-1))

ctl$Age_Maturity <- tmp_Age_Maturity
ctl$First_Mature_Age <- 1 
ctl$fecundity_option # don't bother changing, b/c is not used if wtatage.ss used.

ctl$hermaphroditism_option <- 0
ctl$parameter_offset_approach <- 1

# remove the recruitment dist parms, b/c don't need with method 4
ctl$MG_parms <- ctl$MG_parms[-grep("RecrDist", rownames(ctl$MG_parms)),]
# Get rid of Male params, because only one sex used for this model.
ctl$MG_parms <- ctl$MG_parms[-grep("Mal", rownames(ctl$MG_parms)),]
# change natural mortality value
tmp_M <- ctl$MG_parms[grep("NatM", rownames(ctl$MG_parms)),]
tmp_M["HI"] <- 0.4 #arbitrarily higher than the ASAP model.
tmp_M["INIT"] <- 0.3 # as in ASAP
tmp_M["PHASE"] <- -3 # must be negative
ctl$MG_parms[grep("NatM", rownames(ctl$MG_parms)),] <- tmp_M
ctl$MG_parms$PRIOR <- rep(0, times = length(ctl$MG_parms$PRIOR))

ctl$MGparm_seas_effects <- rep(0, length.out = length(ctl$MGparm_seas_effects))
# Stock recruitment function
ctl$SR_function <- 3 # BH, b/c that is what ASAP uses.
ctl$Use_steep_init_equi <- 0
ctl$Sigma_R_FofCurvature <- 0

#SR parms
ctl$SRparm[1,"INIT"] <- log(ASAP_rdat$initial.guesses$SR.inits$SR.scaler.init)
ctl$SRparm[1,"PHASE"] <- ASAP_rdat$control.parms$phases$phase.SR.scaler
ctl$SRparm[2, "INIT"] <- ASAP_rdat$initial.guesses$SR.inits$SR_steepness.init
ctl$SRparm[2, "PHASE"] <- ASAP_rdat$control.parms$phases$phase.steepness
# make sure no priors are used. Do any other elements need to be  changed?
ctl$SRparm$PR_type <- rep(0, length.out = length(ctl$SRparm$PR_type))
if(length(unique(ASAP_rdat$control.parms$recruit.cv))==1){
  ctl$SRparm[3,"INIT"] <- sqrt(log(unique(ASAP_rdat$control.parms$recruit.cv)^2+1))
  ctl$SRparm[3, "PHASE"] <- -3
} else {
  stop("The recruitment cv varies by year in ASAP so cannot simply replace the",
       "sigmaR param in SS.")
}

# recdevs. I think only main recdevs should be used.
ctl$do_recdev <- 1
ctl$MainRdevYrFirst <- dat$styr
ctl$MainRdevYrLast <- dat$endyr
ctl$recdev_phase <- ASAP_rdat$control.parms$phases$phase.recruit.devs
# don't used advanced SR, though.
ctl$recdev_adv <- 0 # I think no bias adjustment, to line up with ASAP/
ctl$recdev_early_start         <- NULL
ctl$recdev_early_phase         <- NULL
ctl$Fcast_recr_phase           <- NULL
ctl$lambda4Fcast_recr_like     <- NULL
ctl$last_early_yr_nobias_adj   <- NULL
ctl$first_yr_fullbias_adj      <- NULL
ctl$last_yr_fullbias_adj       <- NULL
ctl$first_recent_yr_nobias_adj <- NULL
ctl$max_bias_adj               <- NULL
ctl$period_of_cycles_in_recr   <- NULL
ctl$min_rec_dev                <- NULL
ctl$max_rec_dev                <- NULL
ctl$N_Read_recdevs             <- NULL
# Fiushing mortality
ctl$F_ballpark                 
ctl$F_ballpark_year <-  -2001 # make sure neg to disable.
ctl$F_Method <- 2 # I think this is what to use? Sounds like most similar to ASAP...
ASAP_rdat$initial.guesses$Fmult.year1.init
# Note that the F setup values are probably used differently than the ASAP values
# that they were specified as.
ctl$F_setup <- c(ASAP_rdat$initial.guesses$Fmult.year1.init, 
                 ASAP_rdat$control.parms$phases$phase.Fmult.year1, 0) 
ctl$maxF <- ASAP_rdat$options$Fmult.max.value
ctl$F_iter <- NULL # b/c only specify for method 3.

# Q, catchability -----------------------
#since the following are 0:
ASAP_rdat$control.parms$lambda.q.year1
ASAP_rdat$control.parms$lambda.q.devs
# There is no extra SE for the catchability above what is already include in the index.
# thus, I no need to include params for extra q. note that the cvs for q are 
# ignored when lambda.q.devs or lamda.q.year1 are 0:
ASAP_rdat$control.parms$q.year1.cv
ASAP_rdat$control.parms$q.devs.cv



ctl$Q_options$extra_se  <- c(0,0) # b/c some extra   
ctl$Q_setup <- NULL # This is only for back compatibility with 3.24.
# keep only the normal rows with no extra params (for now)
#ASAP looks like it may estimate Q for each survey and has devs for years?
tmp_row_names <-  c("LnQ_base_2_SURVEY1","LnQ_base_3_SURVEY2")
tmp_Q_parms <- ctl$Q_parms[c(1,3), ]
row.names(tmp_Q_parms) <- tmp_row_names
# calculate the inital value for Q extra CV params
# ASAP_rdat$control.parms$lambda.q.devs
# ASAP_rdat$control.parms$lambda.q.year1
# put these in as the initial parameter values
tmp_Q_parms$INIT <- log(ASAP_rdat$initial.guesses$q.year1.init)
tmp_Q_parms$LO <- c(-10, -10)
tmp_Q_parms$PHASE <- rep(ASAP_rdat$control.parms$phases$phase.q.year1, length.out = 2)
ctl$Q_parms <- tmp_Q_parms

# Size Selectivity ----------------------------
# leave as all 0's
ctl$size_selex_types
# Age Selectivity ------
# use logistic selectivity for all of them.
ctl$age_selex_types
ctl$age_selex_types$Pattern <- c(12, 12, 11) # use 11 for Survey 2 b/c for recruitment only
ctl$age_selex_types$Special <- c(0,0,0) # I think want Survey 1 to mirror fishery 1. 

# make new age sel parms b/c very different
tmp_age_sel <- ctl$age_selex_parms[1:6,]
row.names(tmp_age_sel) <- c("AgeSel_1P_1_FISHERY1","AgeSel_1P_2_FISHERY1",
                                      "AgeSel_2P_1_SURVEY1","AgeSel_2P_2_SURVEY1",
                                      "AgeSel_3P_1_SURVEY2","AgeSel_3P_2_SURVEY2")
# Add in the values from ASAP

tmp_age_sel$LO <- c(1, -10,1, -10, 0, 4) # third 2 are not that meaningful (only init matters)
tmp_age_sel$HI <- rep(10, times = 6)
tmp_age_sel$INIT <- c(3,1,3,1, 1, 1) # can get these value from ASAP, but kind of
# tricky to do so.... see ASAP_rdat$sel.input.mats$index.sel.ini and ASAP_rdat$sel.input.mats$fleet.sel.ini. Difficult to get b/c shows all value for all selectivity values that
# could be selected in the GUI
tmp_age_sel$PR_type <-  rep(0, times = 6) 
tmp_age_sel$PHASE <-  c(2, 2, 2, 2, -2, -2)# also from ASAP, but hard to read in.
#This should probably be another variable, but I'm not sure what? Definitely
# not prior type.
# tmp_age_sel$PR_type <- c(2,2,-1,-1) # from ASAP
tmp_age_sel$dev_minyr <- rep(0, times = 6)
tmp_age_sel$dev_maxyr <- rep(0, times = 6)
ctl$age_selex_parms <- tmp_age_sel

# DOn't use these. (should already be set not to use):
# ctl$DoAdjust
# ctl$Use_2D_AR1_selectivity
# ctl$TG_custom
# variance adjustments and lambda - need to maek sure this lines up with ASAP.
ctl$DoVar_adjust <- 0
ctl$Variance_adjustments <- NULL
ctl$maxlambdaphase
ctl$sd_offset
# TODO: change lambdas to null and N_lambdas to 0; but need to add a fix in 
#r4ss to read 0 lambda options (need to write a terminator line.)
ctl$lambdas
ctl$N_lambdas
# more SD reporting
ctl$more_stddev_reporting <- 0
ctl$stddev_reporting_specs <- NULL
ctl$stddev_reporting_selex <- NULL
ctl$stddev_reporting_N_at_A <- NULL

# write ctl file ---------------------------------------------------------------
SS_writectl(ctl, file.path(SS_mod_dir, "control.ss"), overwrite = TRUE, 
            verbose = FALSE)

# Manipulate wtatage file ------------------------------------------------------

#TODO: re-write using the ASAP_rdat object instead of th ASAP object?

old_wtatage <- wtatage

# ASAP Components
# maturity- to get fecundity, will multiply maturity * weight at age

tmp_ASAP_names <- c("Maturity", "Number of Weights at Age Matrices", 
                    "Weight Matrix - 1", "Weight Matrix - 2",
                    "Weights at Age Pointers","Selectivity Block Assignment")
# Get a named vector of start values
get_start <- function(name, ASAP) {
  start <- grep(paste0("# ", name), ASAP)
}
start_vec <- map_int(tmp_ASAP_names, get_start, ASAP = ASAP)
names(start_vec) <- tmp_ASAP_names

# Pointers Should be in the order: Fleet 1 Catch, Fleet 1 Discards, 
# Catch - All Fleets, Discards - All, SSB, and Jan 1 Biomass.

#Helper function to convert character vectors that are whitespace delimited into
# values

split_row <- function(row) {
  strsplit(row, "\\s+") %>%
    unlist() %>% 
    as.numeric() %>% 
    matrix(nrow = 1, ) %>% 
    data.frame()
}
# general ages to use for matrix columns and years to use for matrix rows.
age_names <- as.character(1:10)
yr_names <- as.character(dat$styr:dat$endyr)

# Get maturity
tmp_Mat <- ASAP[(start_vec["Maturity"]+1):(start_vec["Number of Weights at Age Matrices"]-1)]
tmp_Mat_df <- map_dfr(tmp_Mat, split_row)
# Get WtatAge  - could rewrite this to make it more flexible, but don't bother right now.
# Get WtatAge1
tmp_wtatage1 <- ASAP[(start_vec["Weight Matrix - 1"]+1):(start_vec["Weight Matrix - 2"]-1)]
tmp_wtatage1_df <- map_dfr(tmp_wtatage1, split_row)
# Get WtatAge2
tmp_wtatage2 <- ASAP[(start_vec["Weight Matrix - 2"]+1):(start_vec["Weights at Age Pointers"]-1)]
tmp_wtatage2_df <- map_dfr(tmp_wtatage2, split_row)
#assign the same row and col names to all matrices
colnames(tmp_Mat_df) <- colnames(tmp_wtatage1_df) <- colnames(tmp_wtatage2_df) <- age_names 
rownames(tmp_Mat_df) <- rownames(tmp_wtatage1_df) <- rownames(tmp_wtatage2_df) <- yr_names

tmp_wtatage_point <- ASAP[(start_vec["Weights at Age Pointers"]+1):
                          (start_vec["Selectivity Block Assignment"]-1)] %>% 
                       as.integer()
#Note: the names were taken from the GUI, b/c were not made explicit in the ASAP
# file itself.
names(tmp_wtatage_point) <- c("FLEET-1 Catch", "FLEET-1 Discards", 
                              "Catch-All Fleets", "Discards-All", "SSB", 
                              "JAN-1 Biomass"
                              )

# Now convert these into SS format.
# Issues:
# 1. No AGE 0 included in ASAP matrices.
# 2. Fecundity is wtatage*maturity in ASAP - but not sure which wtatage matrix is used.
# 3. Only fleet 1 assigned a wt at age (this is fine if we don't need wtatage for survey 1, but I'm not sure...)
# 4. SSB calculation in ASAP occurs after 35% of the yr has elapsed - SS needs ("midseason" SSB, so not sure how to make these line up.)
# 5. Jan-1 biomass wtatage- can we make this correspond with "Beginning of season" wtat age in SS?

# first, get all the data with the correct rows and columns

tmp_fec_df <- tmp_Mat_df*tmp_wtatage1_df #maybe?

# Function to add cols and get necessary cols.
make_wtatage_SS <- function(df, fleetvalue) {
  df$Yr <- row.names(df)
  wtatage_SS <- df %>% 
                  mutate(Seas = 1) %>% 
                  mutate(Sex = 1) %>% 
                  mutate(Bio_Pattern = 1) %>% 
                  mutate(BirthSeas = 1) %>% 
                  mutate(Fleet = fleetvalue) %>% 
                  mutate(`0` = `1`) %>%  # might wat to set this differently...
                  select(Yr, Seas, Sex, Bio_Pattern, BirthSeas, Fleet, `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`)
}

test <- make_wtatage_SS(df = tmp_fec_df, fleetvalue = -2)
ASAP_dfs <- list(
                 wt_flt_3  = tmp_wtatage1_df,
                 wt_flt_2  = tmp_wtatage2_df,
                 wt_flt_1  = tmp_wtatage1_df,
                 popwt_beg = tmp_wtatage2_df, 
                 popwt_mid = tmp_wtatage1_df,
                 fecundity = tmp_fec_df
                )
ASAP_dfs_flt_num <- c(3, 2, 1, 0, -1, -2)
          
tmp_wtatage_df <- map2_dfr(ASAP_dfs, ASAP_dfs_flt_num, make_wtatage_SS)%>% 
                    arrange(desc(Fleet)) %>% 
                    arrange(Yr)

#Add values for  2006, assuming they are the same as 05
tmp_wtatagefcast <- tmp_wtatage_df %>% 
                      filter(Yr == "2005") %>% 
                      mutate(Yr = as.character(dat$endyr+1))
tmp_wtatage_df <- bind_rows(tmp_wtatage_df, tmp_wtatagefcast)

# change the read in values
wtatage$maxage <- dat$Nages
wtatage$wtatage_df <- tmp_wtatage_df

# write wtatage file -----------------------------------------------------------
SS_writewtatage(wtatage, file.path(SS_mod_dir, "wtatage.ss"), overwrite = TRUE)
# for some reason, not writing the correct data frame, not the one in the object
# is this an issue with the function? check.


# assumptions and questions ----------------------------------------------------
# Note that there are some differences between the ASAP and SS model, some of 
# which may not be reconcilable. 

#in this ASAP model, the SSB calculation is 0.35 through the year (approx mid 
# May). How to make this "Midseason" in SS?

# Not sure how these correspond to what we need in SS - need pop wtatage (not
# sure how we would have that) in beginning and middle of seaseon, as well as fleet
# specific wt at age (for fishery and survey 1 b/c they use biomass). Not sure
# how the 2 wt at age values in ASAP correspond with what we want in SS?

# Manipulate and write starter -------------------------------------------------
old_starter <- starter
# change F_report options
starter$F_report_units <- 4
starter$F_age_range <- c(ASAP_rdat$options$Freport.agemin, 
                         ASAP_rdat$options$Freport.agemax
                         )
SS_writestarter(starter, dir = SS_mod_dir, verbose = FALSE, overwrite = TRUE)
# Manipulate and write forecast ------------------------------------------------
# TODO: to the extent possible, set these options the same as already set within
# ASAP
#make it the simplest version for now.
old_forecast <- forecast
# forecast$benchmarks <- 0
# because years are different from original modl
forecast$Bmark_years <-c(rep(dat$endyr, times = 6), rep(c(dat$styr, dat$endyr), times = 2))
# forecast$Forecast <- 0
# uses relative years, leave as is for now. (may be issues with Forecast = 0)
forecast$Fcast_years <- rep(0, times = length(forecast$Fcast_years))
forecast$Nforecastyrs <- 1

SS_writeforecast(forecast, SS_mod_dir, verbose = FALSE, overwrite = TRUE)



