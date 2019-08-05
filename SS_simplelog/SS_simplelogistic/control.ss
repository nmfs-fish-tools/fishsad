#V3.30
#C file created using the SS_writectl function in the R package r4ss
#C file write time: 2019-08-05 15:25:56
#
1 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
4 # recr_dist_method for parameters
1 # Not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# Each settlement assignment:
#_GP	seas	area	age
1	1	1	1	#_recr_dist_pattern1
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
1 #_Nblock_Patterns
1 #_blocks_per_pattern
#_#_begin and end years of blocks
1986 1986
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR,3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = readeach time-varying parm line; 2 = read then autogen if parm min==-12345
#
#
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0 #_Age(post-settlement)_for_L1;linear growth below this
11 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
# Age Maturity or Age fecundity:
#_0	1	2	3	4	5	6	7	8	9	10	11	12
0	0.018	0.1192	0.5	0.8808	0.982	0.9975	0.9997	1	1	1	1	1	#_1
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	SD	PR_type	PHASE	env_var	use_dev	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 5e-02	 0.400000	 0.30000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_NatM_p_1_Fem_GP_1   
-1e+01	45.000000	21.65520000	0	10.0	6	 -2	0	0	0	0	0	0	0	#_L_at_Amin__Fem_GP_1 
 4e+01	90.000000	71.64920000	0	10.0	6	 -4	0	0	0	0	0	0	0	#_L_at_Amax__Fem_GP_1 
 5e-02	 0.250000	 0.14728200	0	 0.8	6	 -4	0	0	0	0	0	0	0	#_VonBert_K__Fem_GP_1 
 5e-02	 0.250000	 0.10000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_CV_young__Fem_GP_1  
 5e-02	 0.250000	 0.10000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_CV_old__Fem_GP_1    
-3e+00	 3.000000	 0.00000244	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_Wtlen_1_Fem         
-3e+00	 4.000000	 3.34694000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_Wtlen_2_Fem         
 5e+01	60.000000	55.00000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_Mat50%_Fem          
-3e+00	 3.000000	-0.25000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_Mat_slope_Fem       
-3e+00	 3.000000	 1.00000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_Eggs/kg_inter_Fem   
-3e+00	 3.000000	 0.00000000	0	 0.8	0	 -3	0	0	0	0	0	0	0	#_Eggs/kg_slope_wt_Fem
 1e-01	10.000000	 1.00000000	0	 1.0	0	 -1	0	0	0	0	0	0	0	#_CohortGrowDev       
 1e-06	 0.999999	 0.50000000	0	 0.5	0	-99	0	0	0	0	0	0	0	#_FracFemale_GP_1     
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker; 3=std_B-H; 4=SCAA;5=Hockey; 6=B-H_flattop; 7=survival_3Parm;8=Shepard_3Parm
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	SD	PR_type	PHASE	env_var	use_dev	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 3.0	31	9.903488	10.3	10.00	0	  1	0	0	0	0	0	0	0	#_SR_LN(R0)   
 0.2	 1	0.700000	 0.7	 0.05	0	  3	0	0	0	0	0	0	0	#_SR_BH_steep 
 0.0	 2	0.554513	 0.8	 0.80	0	 -3	0	0	0	0	0	0	0	#_SR_sigmaR   
-5.0	 5	0.000000	 0.0	 1.00	0	 -4	0	0	0	0	0	0	0	#_SR_R1_offset
 0.0	 0	0.000000	 0.0	 0.00	0	-99	0	0	0	0	0	0	0	#_SR_autocorr 
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1986 #_first year of main recr_devs; early devs can preceed this era
2005 #_last year of main recr_devs; forecast devs start in following year
3 #_recdev phase
0 #_(0/1) to read 13 advanced options
#Fishing Mortality info
0.3 # F ballpark
-2001 #_F ballpark year (neg value to disable)
2 #_F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
5 #_max F or harvest rate, depends on F_Method
#_overall start F value; overall phase; N detailed inputs to read
0.2 2 0 #_F_setup
#_fleet, yr, seas, Fvalue, se, phase
#
#_initial_F_parms
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float
    2	1	0	0	0	0	#_Q_options1
    3	1	0	0	0	0	#_Q_options2
-9999	0	0	0	0	0	#_terminator
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	SD	PR_type	PHASE	env_var	use_dev	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
-10	5	-9.21034	0	1	0	1	0	0	0	0	0	0	0	#_LnQ_base_2_SURVEY1
-10	5	-9.21034	0	1	0	1	0	0	0	0	0	0	0	#_LnQ_base_3_SURVEY2
#_no timevary Q parameters
#_size_selex_patterns
#_Pattern	Discard	Male	Special
0	0	0	0	#_FISHERY1
0	0	0	0	#_SURVEY1 
0	0	0	0	#_SURVEY2 
#
#_age_selex_types
#_Pattern	Discard	Male	Special
12	0	0	0	#_FISHERY1
12	0	0	0	#_SURVEY1 
11	0	0	0	#_SURVEY2 
#
#_SizeSelex
#_No size_selex_parm
#_AgeSelex
#_LO	HI	INIT	PRIOR	SD	PR_type	PHASE	env_var	use_dev	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
  1	10	3	-1000	3	0	 2	0	0	0	0	0	0	0	#_AgeSel_1P_1_FISHERY1
-10	10	1	    3	3	0	 2	0	0	0	0	4	0	0	#_AgeSel_1P_2_FISHERY1
  1	10	3	    0	3	0	 2	0	0	0	0	4	0	0	#_AgeSel_2P_1_SURVEY1 
-10	10	1	    0	3	0	 2	0	0	0	0	4	0	0	#_AgeSel_2P_2_SURVEY1 
  0	10	1	    0	3	0	-2	0	0	0	0	4	0	0	#_AgeSel_3P_1_SURVEY2 
  4	10	1	    0	3	0	-2	0	0	0	0	4	0	0	#_AgeSel_3P_2_SURVEY2 
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 #_TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_Factor Fleet Value
-9999 1 0 # terminator
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 3 changes to defaultLambdas (default value is 1.0)
#_like_comp	fleet/survey	phase	value	sizefreq_method
    1	2	2	1	1	#_Surv_SURVEY1_Phz2                    
    4	2	2	1	1	#_length_SURVEY1_sizefreq_method_1_Phz2
    4	2	3	1	1	#_length_SURVEY1_sizefreq_method_1_Phz3
-9999	0	0	0	0	#_terminator                           
0 #_ 0/1 read specs for more stddev reporting
#
999
