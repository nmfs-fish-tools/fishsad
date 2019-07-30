#V3.30
#C data file created using the SS_writedat function in the R package r4ss
#C should work with SS version: 
#C file write time: 2019-07-30 12:28:42
#
1986 #_styr
2005 #_endyr
1 #_nseas
12 #_months_per_seas
2 #_Nsubseasons
5.2258064516129 #_spawn_month
1 #_Nsexes
10 #_Nages
1 #_Nareas
3 #_Nfleets
#_fleetinfo
#_type	surveytiming	area	units	need_catch_mult	fleetname
1	-1	1	1	0	FISHERY1	#_1
3	 1	1	1	0	SURVEY1 	#_2
3	 1	1	2	0	SURVEY2 	#_3
#_Catch data
#_year	season	fleet	catch	catch_se
 1986	1	1	  82.2	0.00999975	#_1         
 1987	1	1	 413.0	0.00999975	#_2         
 1988	1	1	 543.6	0.00999975	#_3         
 1989	1	1	 545.4	0.00999975	#_4         
 1990	1	1	 344.5	0.00999975	#_5         
 1991	1	1	 469.2	0.00999975	#_6         
 1992	1	1	1019.4	0.00999975	#_7         
 1993	1	1	 705.2	0.00999975	#_8         
 1994	1	1	 925.4	0.00999975	#_9         
 1995	1	1	 894.7	0.00999975	#_10        
 1996	1	1	 893.3	0.00999975	#_11        
 1997	1	1	 645.5	0.00999975	#_12        
 1998	1	1	 431.5	0.00999975	#_13        
 1999	1	1	  95.2	0.00999975	#_14        
 2000	1	1	 146.4	0.00999975	#_15        
 2001	1	1	 103.0	0.00999975	#_16        
 2002	1	1	  99.0	0.00999975	#_17        
 2003	1	1	  45.6	0.00999975	#_18        
 2004	1	1	 157.5	0.00999975	#_19        
 2005	1	1	 119.0	0.00999975	#_20        
-9999	0	0	   0.0	0.00000000	#_terminator
#_CPUE_and_surveyabundance_observations
#_Units:  0=numbers; 1=biomass; 2=F; >=30 for special types
#_Errtype:  -1=normal; 0=lognormal; >0=T
#_SD_Report: 0=no sdreport; 1=enable sdreport
#_Fleet	Units	Errtype	SD_Report
1	1	0	0	#_FISHERY1
2	1	0	0	#_SURVEY1 
3	0	0	0	#_SURVEY2 
#
#_CPUE_data
#_year	seas	index	obs	se_log
 1986	6	2	728.0	0.293560	#_1         
 1987	6	2	522.0	0.293560	#_2         
 1988	6	2	804.0	0.293560	#_3         
 1989	6	2	454.0	0.293560	#_4         
 1990	6	2	456.0	0.293560	#_5         
 1991	6	2	530.0	0.293560	#_6         
 1992	6	2	218.0	0.293560	#_7         
 1993	6	2	367.0	0.293560	#_8         
 1994	6	2	366.0	0.293560	#_9         
 1995	6	2	176.0	0.293560	#_10        
 1996	6	2	180.0	0.293560	#_11        
 1997	6	2	154.0	0.293560	#_12        
 1998	6	2	109.0	0.293560	#_13        
 1999	6	2	145.0	0.293560	#_14        
 2000	6	2	140.0	0.293560	#_15        
 2001	6	2	160.0	0.293560	#_16        
 2002	6	2	142.0	0.293560	#_17        
 2003	6	2	215.0	0.293560	#_18        
 2004	6	2	156.0	0.293560	#_19        
 2005	6	2	198.0	0.293560	#_20        
 1986	3	3	  5.0	0.593646	#_21        
 1987	3	3	 13.1	0.593646	#_22        
 1988	3	3	 14.3	0.593646	#_23        
 1989	3	3	 13.0	0.593646	#_24        
 1990	3	3	  3.3	0.593646	#_25        
 1991	3	3	 15.0	0.593646	#_26        
 1992	3	3	 10.8	0.593646	#_27        
 1993	3	3	 12.1	0.593646	#_28        
 1994	3	3	  8.6	0.593646	#_29        
 1995	3	3	  6.8	0.593646	#_30        
 1996	3	3	 13.0	0.593646	#_31        
 1997	3	3	  7.3	0.593646	#_32        
 1998	3	3	  7.4	0.593646	#_33        
 1999	3	3	 24.3	0.593646	#_34        
 2000	3	3	  4.4	0.593646	#_35        
 2001	3	3	  3.3	0.593646	#_36        
 2002	3	3	 12.3	0.593646	#_37        
 2003	3	3	 12.1	0.593646	#_38        
 2004	3	3	 16.8	0.593646	#_39        
 2005	3	3	 25.2	0.593646	#_40        
-9999	0	0	  0.0	0.000000	#_terminator
0 #_N_discard_fleets
#_discard_units (1=same_as_catchunits(bio/num); 2=fraction; 3=numbers)
#_discard_errtype:  >0 for DF of T-dist(read CV below); 0 for normal with CV; -1 for normal with se; -2 for lognormal
#
#_discard_fleet_info
#
#_discard_data
#
#_meanbodywt
0 #_use_meanbodywt
 #_DF_for_meanbodywt_T-distribution_like
#
#_population_length_bins
2 # length bin method: 1=use databins; 2=generate from binwidth,min,max below; 3=read vector
2 # binwidth for population size comp
10 # minimum size in the population (lower edge of first bin and size at age 0.00)
94 # maximum size in the population (lower edge of last bin)
0 #_use_lencomp
10 #_N_agebins
#
#_agebin_vector
1 2 3 4 5 6 7 8 9 10 #_agebin_vector
#
#_ageing_error
1 #_N_ageerror_definitions
#_age0	age1	age2	age3	age4	age5	age6	age7	age8	age9	age10
-1.000	-1.000	-1.000	-1.000	-1.000	-1.000	-1.000	-1.000	-1.000	-1.000	-1.000	#_1
 0.001	 0.001	 0.001	 0.001	 0.001	 0.001	 0.001	 0.001	 0.001	 0.001	 0.001	#_2
#
#_age_info
#_mintailcomp	addtocomp	combine_M_F	CompressBins	CompError	ParmSelect	minsamplesize
0	1e-07	0	0	0	0	1	#_FISHERY1
0	1e-07	0	0	0	0	1	#_SURVEY1 
0	1e-07	0	0	0	0	1	#_SURVEY2 
1 #_Lbin_method: 1=poplenbins; 2=datalenbins; 3=lengths
 #_combine males into females at or below this bin number
#_Yr	Seas	FltSvy	Gender	Part	Ageerr	Lbin_low	Lbin_hi	Nsamp	f1	f2	f3	f4	f5	f6	f7	f8	f9	f10
 1997	6	2	0	0	1	-1	-1	200	3	30	10	52	21	19	54	 2	 2	4	#_1         
 1998	6	2	0	0	1	-1	-1	200	3	21	72	13	39	13	11	21	 0	2	#_2         
 1999	6	2	0	0	1	-1	-1	200	4	22	44	76	 7	22	 7	 4	 9	1	#_3         
 2000	6	2	0	0	1	-1	-1	200	4	21	39	45	56	 5	15	 4	 2	5	#_4         
 2001	6	2	0	0	1	-1	-1	200	2	22	39	41	34	41	 3	 8	 2	4	#_5         
 2002	6	2	0	0	1	-1	-1	200	6	 9	41	42	33	26	30	 2	 5	4	#_6         
 2003	6	2	0	0	1	-1	-1	200	3	32	16	44	34	25	19	17	 1	5	#_7         
 2004	6	2	0	0	1	-1	-1	200	2	17	56	17	35	26	18	11	10	3	#_8         
 2005	6	2	0	0	1	-1	-1	200	3	15	31	62	14	27	19	11	 7	8	#_9         
-9999	0	0	0	0	0	 0	 0	  0	0	 0	 0	 0	 0	 0	 0	 0	 0	0	#_terminator
#
#_MeanSize_at_Age_obs
0 #_use_MeanSize_at_Age_obs
0 #_N_environ_variables
0 #_N_sizefreq_methods
0 #_do_tags
0 #_morphcomp_data
0 #_use_selectivity_priors
#
999
