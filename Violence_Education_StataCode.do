/*===================================================================================
================= 	   		Tables, Figures and Estimations 	    =================
================= 	   Neighborhood Violence and Student Outcomes 	=================
================= 		   			Haugan				            =================
=================    Created by: Greg Haugan (Aug 1 - 2015)    		=================
================= Last modified by: Greg Haugan (Feb 21 - 2016)		=================
=====================================================================================
*/


global cd1 "/Users/haugangl/Desktop/"
cap mkdir "$cd1"

**********************************
**Colombia homicide trends graph**
**********************************
	**Creates the homicide trends graph (Graph 1)
import excel using "$cd1/Colombia_Homicide_Rates", firstrow
rename A year
rename year YEAR

twoway (connect Medellin YEAR, lcolor(gs1) clpattern(solid) lwidth(0.4)) (connect Bogota YEAR, lcolor(gs2) clpattern(dash) lwidth(0.4)) (connect Cali YEAR, lcolor(gs3) clpattern(dot) lwidth(0.4)) (connect Barranquilla YEAR, lcolor(gs5) clpattern(longdash_dot) lwidth(0.4)) (connect Colombia YEAR, lcolor(gs4) clpattern(dash_dot) lwidth(0.4)), name(Homicides_ByCity, replace) legend(order(1 "Medellin" 2 "Bogota" 3 "Cali" 4 "Barranquilla" 5 "Colombia") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) ytitle("Homicides per 100,000 inhabitants") xtitle("Year (Study Time Within Lines)") xline(2006 2013) title("Homicides per 100,000 inhabitants in Colombia, 2002-2013", size(*0.75)) ttick(2002(1)2013)

graph save Homicides_ByCity "$cd1/Homicides_ByCity.gph"


clear

**************************************************
* Table: Descriptive Statistics					 *
**************************************************

	use "$cd1/FINAL_DATASET_Newest_DescStats.dta"

	cap erase "Tables.txt"
	cap erase "Tables.xls"
		
	* 	1. Violence Indicators (Table 2 Panel A)
	*----------------
	preserve
	collapse Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL, by(COLE_CODIGO_COLEGIO YEAR)
	sort  YEAR COLE_CODIGO_COLEGIO
	by YEAR: egen year_mean = mean(Vio_500meters_TOTAL)
	gen year_high_exposure=0
	replace year_high_exposure=1 if  Vio_500meters_TOTAL>year_mean
	sort  COLE_CODIGO_COLEGIO YEAR
	by COLE_CODIGO_COLEGIO: egen years_highly_exposed = sum(year_high_exposure)
	gen years_existence=0
	by COLE_CODIGO_COLEGIO: replace years_existence = [_N]
	gen highly_exposed=0
	by COLE_CODIGO_COLEGIO: replace highly_exposed = 1 if years_highly_exposed/years_existence>=0.5


	
	foreach var of varlist Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL{
		ttest `var', by(highly_exposed)
		matrix `var' = [r(N_2) \ r(mu_2) \ r(sd_2) \ r(N_1) \ r(mu_1) \ r(sd_1) \ r(se)]'
			}
	
	matrix T1a=[Vio_500meters_TOTAL \ Vio_1000meters_TOTAL \ Vio_1500meters_TOTAL \ Vio_2000meters_TOTAL]
	

	xml_tab T1a using "Tables.xls", append sheet("Violence Variables") font("Times New Roman" 11) title("Table 1: Descriptive Statistics of Local Violence") rnames("Homicides within 500 meters" "Homicides within 1000 meters" "Homicides within 1500 meters" "Homicides within 2000 meters")

	restore

* 	2. School Traits (Table 2 Panel B)
	*------------------------
	preserve
	collapse Vio_500meters_TOTAL COMPLETA_jornada MANANA_jornada NOCHE_jornada SABATINA_jornada TARDE_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_NORMALISTA tipo_TECNICO, by(COLE_CODIGO_COLEGIO YEAR)
	
	sort  YEAR COLE_CODIGO_COLEGIO
	by YEAR: egen year_mean = mean(Vio_500meters_TOTAL)
	gen year_high_exposure=0
	replace year_high_exposure=1 if  Vio_500meters_TOTAL>year_mean
	sort  COLE_CODIGO_COLEGIO YEAR
	by COLE_CODIGO_COLEGIO: egen years_highly_exposed = sum(year_high_exposure)
	gen years_existence=0
	by COLE_CODIGO_COLEGIO: replace years_existence = [_N]
	gen highly_exposed=0
	by COLE_CODIGO_COLEGIO: replace highly_exposed = 1 if years_highly_exposed/years_existence>=0.5

	
	foreach var of varlist COMPLETA_jornada MANANA_jornada NOCHE_jornada SABATINA_jornada TARDE_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_NORMALISTA tipo_TECNICO{
		prtest `var', by(highly_exposed)
		matrix `var' = [r(N_2) \ r(P_2) \ r(N_1) \ r(P_1)]'
			}
	
	matrix T2a=[COMPLETA_jornada \ MANANA_jornada \ NOCHE_jornada \ SABATINA_jornada \ TARDE_jornada \ tipo_ACADEMICO \ tipo_ACADEMICO_Y_TECNICO \ tipo_NORMALISTA \ tipo_TECNICO]
	

	xml_tab T2a using "Tables.xls", append sheet("School Traits") font("Times New Roman" 11) title("Table 2: Descriptive Statistics of School Characteristics by Exposure to Violence") rnames("Full Day Schedule" "Morning Schedule" "Evening Schedule" "Weekend Schedule" "Afternoon Schedule" "Academic Curriculum" "Mixed Curriculum" "Normal School" "Technical Curriculum")

	restore

	**(Table 2 Panel C)
	preserve
	collapse Vio_500meters_TOTAL Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS TEMA_LENGUAJE TEMA_MATEMATICA TEMA_PUESTO, by(COLE_CODIGO_COLEGIO YEAR)
	
	sort  YEAR COLE_CODIGO_COLEGIO
	by YEAR: egen year_mean = mean(Vio_500meters_TOTAL)
	gen year_high_exposure=0
	replace year_high_exposure=1 if  Vio_500meters_TOTAL>year_mean
	sort  COLE_CODIGO_COLEGIO YEAR
	by COLE_CODIGO_COLEGIO: egen years_highly_exposed = sum(year_high_exposure)
	gen years_existence=0
	by COLE_CODIGO_COLEGIO: replace years_existence = [_N]
	gen highly_exposed=0
	by COLE_CODIGO_COLEGIO: replace highly_exposed = 1 if years_highly_exposed/years_existence>=0.5


	foreach var of varlist male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS{
		prtest `var', by(highly_exposed)
		matrix `var' = [r(N_2) \ r(P_2) \ r(N_1) \ r(P_1)]'
			}
	
	matrix T2a=[male \ minoria \ trabaja \ padre_dropout \ madre_dropout \ Strata1 \ Strata2 \ Strata3 \ Strata4 \ Strata5 \ SALARIOmenos1MMS \ SALARIOentre1y2MMS \ SALARIOentre2y5MMS \ SALARIOmas5MMS]
	

	xml_tab T2a using "Tables3.xls", append sheet("Other Traits") font("Times New Roman" 11) title("Table 2: Descriptive Statistics by Exposure to Violence") rnames("%Male" "%Ethnic Minority" "%Working" "%Father Dropout" "%Mother Dropout" "%Strata1" "%Strata2" "%Strata3" "%Strata4" "%Strata5" "%SALARIOmenos1MMS" "%SALARIOentre1y2MMS" "%SALARIOentre2y5MMS" "%SALARIOmas5MMS")

	**(Table 2 Panel D)
	foreach var of varlist Total_Students TEMA_LENGUAJE TEMA_MATEMATICA TEMA_PUESTO{
		ttest `var', by(highly_exposed)
		matrix `var' = [r(N_2) \ r(mu_2) \ r(sd_2) \ r(N_1) \ r(mu_1) \ r(sd_1) \ r(se)]'
			}
	
	matrix T1a=[Total_Students \ TEMA_LENGUAJE \ TEMA_MATEMATICA \ TEMA_PUESTO]
	

	xml_tab T1a using "Tables.xls", append sheet("More Variables") font("Times New Roman" 11) title("Table 1: Descriptive Statistics") rnames("Total Students" "ICFES Language Score" "ICFES Math Score" "ICFES Rank")


	restore

	cap erase "Tables.txt"


* 	3. Within School Year to Year Differences by Violence Exposure (Table 4)
	*---------------------------------------------------------
	cap erase "DID_Traits_Byvio.txt"
	cap erase "DID_Traits_Byvio_lag.txt"
	cap erase "DID_Traits_Byvio.xls"
	cap erase "DID_Traits_Byvio_lag.xls"
	
	egen Total_Strata1=sum(Strata1), by(COLE_CODIGO_COLEGIO YEAR)
	egen Total_Strata2=sum(Strata2), by(COLE_CODIGO_COLEGIO YEAR)
	egen Total_Strata3=sum(Strata3), by(COLE_CODIGO_COLEGIO YEAR)
	egen Total_Strata4=sum(Strata4), by(COLE_CODIGO_COLEGIO YEAR)
	egen Total_Strata5=sum(Strata5), by(COLE_CODIGO_COLEGIO YEAR)
	egen Total_Strata6=sum(Strata6), by(COLE_CODIGO_COLEGIO YEAR)
	
	preserve
	collapse Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL Total_Students Total_Strata* male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS TEMA_LENGUAJE TEMA_MATEMATICA TEMA_FILOSOFIA TEMA_FISICA TEMA_BIOLOGIA TEMA_CIENCIAS_SOCIALES TEMA_QUIMICA TEMA_PUESTO COMPLETA_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_TECNICO, by(COLE_CODIGO_COLEGIO YEAR)	
	
	xtset COLE_CODIGO_COLEGIO YEAR, yearly
	gen Vio_500meters_TOTAL_lag = l.Vio_500meters_TOTAL
	
	sort COLE_CODIGO_COLEGIO YEAR
	by COLE_CODIGO_COLEGIO: egen school_mean = mean(Vio_500meters_TOTAL)
	gen year_high_exposure=0
	replace year_high_exposure=1 if  Vio_500meters_TOTAL>school_mean
	gen Vio_500meters_TOTAL_lag = l.Vio_500meters_TOTAL
	gen year_high_exposure_lag = l.year_high_exposure
	
	**With Violence as dependent variable**
	
	cap erase "Vio_DepVar.txt"
	cap erase "Vio_DepVar.xls"
	
	foreach trait of varlist Total_Students Total_Strata* Strata* SALARIO* padre_dropout madre_dropout male 
	minoria trabaja{
	
		gen LAG_`trait'=l.`trait'
		gen LAG2_`trait'=l2.`trait'	
	
			}
	
	
	global exogenous1 LAG_SALARIOmenos1MMS LAG_SALARIOentre1y2MMS LAG_SALARIOentre2y5MMS LAG_SALARIOmas5MMS LAG_madre_dropout LAG_male LAG_minoria LAG_trabaja LAG_Total_Strata1 LAG_Total_Strata2 LAG_Total_Strata3 LAG_Total_Strata4 LAG_Total_Strata5 LAG_Total_Strata6
	
	xtreg avg_vio $exogenous1 l.TEMA_LENGUAJE l.TEMA_MATEMATICA i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
	outreg2 avg_vio using "$cd1/Vio_DepVar.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Lag, One Period) append slow(150) ctitle("Avg Violence")
	
	global exogenous2 LAG2_SALARIOmenos1MMS LAG2_SALARIOentre1y2MMS LAG2_SALARIOentre2y5MMS LAG2_SALARIOmas5MMS LAG2_madre_dropout LAG2_male LAG2_minoria LAG2_trabaja LAG2_Total_Strata1 LAG2_Total_Strata2 LAG2_Total_Strata3 LAG2_Total_Strata4 LAG2_Total_Strata5 LAG2_Total_Strata6
	
	xtreg avg_vio $exogenous2 l2.TEMA_LENGUAJE l2.TEMA_MATEMATICA i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
	outreg2 avg_vio using "$cd1/Vio_DepVar.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Lag, Two Periods) append slow(150) ctitle("Avg Violence")
	
	cap erase "Vio_DepVar.txt"

	
	restore
	
	
**************************************************
* Regressions					 *
**************************************************

	set matsize 2000
	
	local controls Total_Students male
	local controls2 Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
	
	local titTEMA_MATEMATICA "Math"
	local titTEMA_LENGUAJE "Language"
	local titTEMA_BIOLOGIA "Biology"
	local titTEMA_FISICA "Physics"
	local titTEMA_QUIMICA "Chemistry"
	local titTEMA_CIENCIAS_SOCIALES "Social Sciences"
	local titTEMA_FILOSOFIA "Philosophy"
	local titTEMA_PUESTO "Rank"
	
	cap erase "$cd1/school_nolag.txt"
	cap erase "$cd1/school_lag.txt"
	cap erase "$cd1/school_avg.txt"
	cap erase "$cd1/student_nolag.txt"
	cap erase "$cd1/student_lag.txt"

	cap erase "$cd1/school_nolag.xls"
	cap erase "$cd1/school_lag.xls"
	cap erase "$cd1/school_avg.xls"
	cap erase "$cd1/student_nolag.xls"
	cap erase "$cd1/student_lag.xls"

	
	*	Main regressions. School-level.	
	*-----------------
	sort YEAR COLE_CODIGO_COLEGIO
	order YEAR COLE_CODIGO_COLEGIO
	preserve
	collapse pre_vio Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS TEMA_LENGUAJE TEMA_MATEMATICA TEMA_FILOSOFIA TEMA_FISICA TEMA_BIOLOGIA TEMA_CIENCIAS_SOCIALES TEMA_QUIMICA TEMA_PUESTO COMPLETA_jornada MANANA_jornada NOCHE_jornada SABATINA_jornada TARDE_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_NORMALISTA tipo_TECNICO, by(COLE_CODIGO_COLEGIO YEAR)	
	
	xtset COLE_CODIGO_COLEGIO YEAR, yearly
	global vio "Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL"
		foreach v of global vio{
			gen `v'_lag = l.`v'
			gen `v'_lag2 = l2.`v'
			gen `v'_lead = f.`v'
			gen `v'_lead2 = f2.`v'	
				}
	
	
	global icfes "TEMA_MATEMATICA TEMA_LENGUAJE TEMA_BIOLOGIA TEMA_FISICA TEMA_QUIMICA TEMA_CIENCIAS_SOCIALES TEMA_FILOSOFIA TEMA_PUESTO"
	
	*Standardizing test scores
	foreach tema of global icfes{
	bys YEAR: egen sd_`tema'=sd(`tema')
	bys YEAR: egen mean_`tema'=mean(`tema')
	gen stnd_`tema'=(`tema'-mean_`tema')/sd_`tema'
		}
	
	gen avg_vio=(Vio_500meters_TOTAL+ Vio_500meters_TOTAL_lag)/2
	
	**With Lag (Table 5 Panel A)
		*No Controls
	foreach tema of global icfes{
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/school_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO, Lag, YES) append slow(150) ctitle(`tit`tema'')
		
		*With controls
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/school_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, NO, Lag, YES) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/school_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES, Lag, YES) append slow(150) ctitle(`tit`tema'')
						}	
		
	**Two-year violence average (Table 5 Panel B)
		*No Controls
	foreach tema of global icfes{
		xtreg stnd_`tema' avg_vio i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		
		*With controls
		xtreg stnd_`tema' avg_vio `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, NO,) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' avg_vio `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
						}	
	
	cap erase "$cd1/school_nolag.txt"
	cap erase "$cd1/school_lag.txt"
	cap erase "$cd1/school_avg.txt"
	
	

**************************************************
* Checking robustness of regression results		 *
**************************************************
	
	cap erase "$cd1/school_leads_avg.txt"
	cap erase "$cd1/school_greater_distances_avg.txt"
	
	cap erase "$cd1/school_leads_avg.xls"
	cap erase "$cd1/school_greater_distances_avg.xls"
	

**Checking robustness by including leads as explanatory variables
	
	**Two-year homicide average (Table 7)
		*No Controls
	gen avg_lead=(Vio_500meters_TOTAL_lead+Vio_500meters_TOTAL_lead2)/2 
	
	foreach tema of global icfes{
		xtreg stnd_`tema' avg_lead i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL_lead using "$cd1/school_leads_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		*With controls
		xtreg stnd_`tema' avg_lead `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_leads_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			}	

	cap erase "$cd1/school_leads_avg.txt"
				
**Checking robustness by including violence at larger distances (Table 6)

		foreach m of numlist 1000 1500 2000{
			gen avg_`m'=(Vio_`m'meters_TOTAL+Vio_`m'meters_TOTAL_lag)/2
				}
		
		foreach tema of global icfes{
		foreach m of numlist 1000 1500 2000{
			xtreg stnd_`tema' avg_`m' `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 avg_`m' using "$cd1/school_greater_distances_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
			xtreg stnd_`tema' avg_`m' `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 avg_`m' using "$cd1/school_greater_distances_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
						}
				}
	

cap erase "$cd1/school_greater_distances.txt"
cap erase "$cd1/school_greater_distances_avg.txt"



	
**************************************************
* Instrumental Variables Approach				 *
**************************************************
	
clear
use "$cd1/FINAL_DATASET_Newest_DescStats.dta"

**Creating Homicides by Comunas graphs (Graph 2)

	preserve
	sort DANE_sede
	order DANE_sede
	merge DANE_sede using "$cd1/comunas.dta"
	tab _merge
	keep if _merge==3
	sort YEAR COLE_CODIGO_COLEGIO
	order YEAR COLE_CODIGO_COLEGIO

	collapse Vio_500meters_TOTAL COMUNA, by(COLE_CODIGO_COLEGIO YEAR)
	xtset COLE_CODIGO_COLEGIO YEAR, yearly
		**Small number of odd observations with decimal comunas after merge.
	replace COMUNA=round(COMUNA, 1.0)
	
		**Generating geographic zones
	gen zone=1 if COMUNA==1 | COMUNA==2 | COMUNA==3 | COMUNA==4
	replace zone=2 if COMUNA==5 | COMUNA==6 | COMUNA==7
	replace zone=3 if COMUNA==8 | COMUNA==9 | COMUNA==10
	replace zone=4 if COMUNA==11 | COMUNA==12 | COMUNA==13
	replace zone=5 if COMUNA==14
	replace zone=6 if COMUNA==15 | COMUNA==16
	
	tab COMUNA if COMUNA>16
	count if zone==.
	*drop rural comunas
	drop if zone==.
	
	collapse Vio_500meters_TOTAL, by(zone YEAR)
	reshape wide Vio_500meters_TOTAL, i(YEAR) j(zone)
	twoway (connect Vio_500meters_TOTAL1 YEAR, lcolor(gs1) clpattern(solid) lwidth(0.4)) (connect Vio_500meters_TOTAL2 YEAR, lcolor(gs2) clpattern(dash) lwidth(0.4)) (connect Vio_500meters_TOTAL3 YEAR, lcolor(gs3) clpattern(dot) lwidth(0.4)) (connect Vio_500meters_TOTAL4 YEAR, lcolor(gs4) clpattern(dash_dot) lwidth(0.4)) (connect Vio_500meters_TOTAL5 YEAR, lcolor(gs5) clpattern(longdash_dot) lwidth(0.4)) (connect Vio_500meters_TOTAL6 YEAR, lcolor(gs6) clpattern(shortdash_dot) lwidth(0.4)), name(Homicides_ByZone, replace) legend(order(1 "Northeast (Comunas 1-4)" 2 "Northwest (Comunas 5-7)" 3 "Center (Comunas 8-10)" 4 "West (Comunas 11-13)" 5 "South (Comuna 14)" 6 "Southwest (Comunas 15-16)") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) xtitle("Year (2006-2013)") xtick(2006(1)2013) ytitle("Avg Homicides Within 500 Meters of Schools in Zone") title("Evolution of School Exposure to Homicides, by City Zone", size(*0.75)) ttick(2006(1)2013)
	
**Bartik Shock IV

**Results not presented in paper due to weak first stage.

	clear
	use "$cd1/FINAL_DATASET_Newest_DescStats.dta"
	
	sort YEAR COLE_CODIGO_COLEGIO
	order YEAR COLE_CODIGO_COLEGIO
	preserve
	collapse pre_vio Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS TEMA_LENGUAJE TEMA_MATEMATICA TEMA_FILOSOFIA TEMA_FISICA TEMA_BIOLOGIA TEMA_CIENCIAS_SOCIALES TEMA_QUIMICA TEMA_PUESTO COMPLETA_jornada MANANA_jornada NOCHE_jornada SABATINA_jornada TARDE_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_NORMALISTA tipo_TECNICO, by(COLE_CODIGO_COLEGIO YEAR)	
	xtset COLE_CODIGO_COLEGIO YEAR, yearly
	global vio "Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL"
		foreach v of global vio{
			gen `v'_lag = l.`v'	
				}
	
	*Standardizing test scores
	global icfes "TEMA_MATEMATICA TEMA_LENGUAJE TEMA_BIOLOGIA TEMA_FISICA TEMA_QUIMICA TEMA_CIENCIAS_SOCIALES TEMA_FILOSOFIA TEMA_PUESTO"
	foreach tema of global icfes{
	bys YEAR: egen sd_`tema'=sd(`tema')
	bys YEAR: egen mean_`tema'=mean(`tema')
	gen stnd_`tema'=(`tema'-mean_`tema')/sd_`tema'
		}
	
	gen avg_vio=(Vio_500meters_TOTAL+ Vio_500meters_TOTAL_lag)/2
	

	
	cap erase "$cd1/FirstStage.txt"
	cap erase "$cd1/InstrumentalVariables.txt"
	
	cap erase "$cd1/FirstStage.xls"
	cap erase "$cd1/InstrumentalVariables.xls"
				
	**yearly homicide totals for Medellin
	gen citywide_vio=472 if YEAR==2006
	replace citywide_vio=455 if YEAR==2007
	replace citywide_vio=609 if YEAR==2008
	replace citywide_vio=939 if YEAR==2009
	replace citywide_vio=879 if YEAR==2010
	replace citywide_vio=962 if YEAR==2011
	replace citywide_vio=767 if YEAR==2012
	replace citywide_vio=623 if YEAR==2013
	
	gen pre_citywide_vio=((700+499)/2)
	

	**Constructing the bartik instrument - our instrument for neighborhood homicides will use Medellin homicides outside the neighborhood
	sort COLE_CODIGO_COLEGIO YEAR
	gen bartik=citywide_vio - Vio_2000meters_TOTAL
	by COLE_CODIGO_COLEGIO: egen bartik_avg=mean(bartik)
			
	replace bartik= pre_vio*(bartik/bartik_avg)
	gen bartik_lag= l.bartik
	gen avg_bartik=(bartik+bartik_lag)/2
	
	local controls2 Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
	
	**Saving first stage
	reg avg_vio avg_bartik `controls2' i.YEAR i.COLE_CODIGO_COLEGIO, vce(cluster COLE_CODIGO_COLEGIO)
	outreg2 avg_bartik using "$cd1/FirstStage.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Controls, YES, Years, 2008-2013) append slow(150) ctitle(`tit`tema'')
		**Restricting years in first stage
	reg avg_vio avg_bartik `controls2' i.YEAR i.COLE_CODIGO_COLEGIO if YEAR<2011, vce(cluster COLE_CODIGO_COLEGIO)
	outreg2 avg_bartik using "$cd1/FirstStage.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Controls, YES, Years, 2008-2010) append slow(150) ctitle(`tit`tema'')

		
	**Second Stage
	foreach tema of global icfes{
	ivregress 2sls stnd_`tema' `controls2' i.YEAR i.COLE_CODIGO_COLEGIO (avg_vio = avg_bartik), vce(cluster COLE_CODIGO_COLEGIO)
	outreg2 Vio_500meters_TOTAL using "$cd1/InstrumentalVariables.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Controls, YES, Restricted Sample, NO) append slow(150) ctitle(`tit`tema'')
	ivregress 2sls stnd_`tema' `controls2' i.YEAR i.COLE_CODIGO_COLEGIO (avg_vio = avg_bartik) if YEAR<2011, vce(cluster COLE_CODIGO_COLEGIO)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/InstrumentalVariables.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Controls, YES, Restricted Sample, YES) append slow(150) ctitle(`tit`tema'')		
				}
				
restore



	cap erase "$cd1/FirstStage.txt"
	cap erase "$cd1/InstrumentalVariables.txt"	




**************************************************
*     Causal Pathways - Teacher Turnover   		 *
**************************************************

	
	clear
	use "$cd1/docentes_2008-2013.dta"
	**Can't post this data online due to confidentiality agreements
	
	set matsize 2000
	
	rename codigo_dane_ee DANE_sede
	rename anno_carga YEAR
	
	sort DANE_sede YEAR
	order DANE_sede YEAR
	merge DANE_sede YEAR using "$cd1/MergeIntoProfs.dta"
	**merging with school-level violence data
	
	tab _merge
	count if nivel_ensenanza==3 & _merge==1
		*Relatively small number of obs not merged successfully. Drop.
	keep if _merge==3
	drop _merge
	
	
	**Linear probability model, as proposed by Hanushek, Kain, and Rivkin (2004)
	
	gen year_birth=substr(fecha_nacimiento,-4,.)
	destring year_birth, replace
	gen age= YEAR-year_birth
	tab age
		*Dropping two strange obs. No way we can have an 11-year old teacher.
	drop if age==11 | age==14
	
	sort num_doc DANE_sede YEAR
	by num_doc DANE_sede: gen turnover=1 if _n==_N & YEAR!=2013	
	by num_doc DANE_sede: replace turnover=0 if _n!=_N & YEAR!=2013
	
	xtset DANE_sede
	
	cap erase "$cd1/TeacherTurnover_LPM.txt"
	cap erase "$cd1/TeacherTurnover_LPM.xls"
	cap erase "$cd1/TeacherTurnover_LPM_notHS.txt"
	cap erase "$cd1/TeacherTurnover_LPM_notHS.xls"
	
	gen avg_vio=(Vio_500meters_TOTAL+Vio_500meters_TOTAL_lag)/2
	
	*Linear Probability Model
		**First for only high school teachers
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & age<26, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age<26") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & 25<age & age<36, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 26-35") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & 35<age & age<51, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 36-50") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & 50<age & age<61, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 51-60") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & age>60, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "60<Age") append slow(150)
			*With two-year homicide average
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & age<26, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age<26") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & 25<age & age<36, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 26-35") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & 35<age & age<51, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 36-50") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & 50<age & age<61, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 51-60") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza==3 & age>60, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "60<Age") append slow(150)



		**Second excluding high school teachers
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & age<26, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age<26") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & 25<age & age<36, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 26-35") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & 35<age & age<51, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 36-50") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & 50<age & age<61, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 51-60") append slow(150)
	xtreg turnover Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & age>60, fe vce(cluster DANE_sede)
	outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "60<Age") append slow(150)
			*With two-year homicide average
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & age<26, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age<26") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & 25<age & age<36, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 26-35") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & 35<age & age<51, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 36-50") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & 50<age & age<61, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "Age 51-60") append slow(150)
	xtreg turnover avg_vio i.nivel_educativo_aprobado i.sobresueldo i.mujer Total_Students trabaja madre_dropout TEMA_LENGUAJE TEMA_MATEMATICA i.YEAR if nivel_ensenanza!=3 & age>60, fe vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_LPM_notHS.xls", se bdec(3) addtext(Year & School FE, YES, Teacher Controls, YES, School Controls, YES, Age Range, "60<Age") append slow(150)
	


	cap erase "$cd1/TeacherTurnover_LPM.txt"
	cap erase "$cd1/TeacherTurnover_LPM_notHS.txt"
	
	
	
	**Survival model (Table 10, Panel A)
	
	sort num_doc DANE_sede YEAR
	by num_doc DANE_sede: gen survtime=_n
	order num_doc DANE_sede YEAR turnover survtime age
	gen year_start=substr(fecha_vinculacion,-4,.)
	destring year_start, replace
	encode escalafon, gen(pay_scale)
	gen age_group=1 if age<30
	replace age_group=2 if age>=30 & age<=45
	replace age_group=3 if age>45 & age<=60
	replace age_group=4 if age>60	
	
	tab DANE_sede, gen(_S)
	tab YEAR, gen(_T)
	tab survtime, gen(_ST)
	
	cap erase "$cd1/TeacherTurnover_STM.txt"
	cap erase "$cd1/TeacherTurnover_STM.xls"
	
	cloglog turnover avg_vio i.nivel_educativo_aprobado i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _*, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM.xls", se bdec(3) addtext(Sample, "All Teachers") append slow(150)
	cloglog turnover avg_vio i.nivel_educativo_aprobado i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza==3, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM.xls", se bdec(3) addtext(Sample, "HS Teachers") append slow(150)
	cloglog turnover avg_vio i.nivel_educativo_aprobado i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza!=3 & nivel_ensenanza!=5, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM.xls", se bdec(3) addtext(Sample, "Not HS Teachers") append slow(150)
	cloglog turnover avg_vio i.nivel_educativo_aprobado i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if year_start>2007, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM.xls", se bdec(3) addtext(Sample, "All Teachers, Post 2007 Start Date") append slow(150)
	cloglog turnover avg_vio i.nivel_educativo_aprobado i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza==3 & year_start>2007, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM.xls", se bdec(3) addtext(Sample, "HS Teachers, Post 2007 Start Date") append slow(150)
	cloglog turnover avg_vio i.nivel_educativo_aprobado i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza!=3 & nivel_ensenanza!=5 & year_start>2007, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM.xls", se bdec(3) addtext(Sample, "Not HS Teachers, Post 2007 Start Date") append slow(150)

	cap erase "$cd1/TeacherTurnover_STM.txt"
	
	*Differential Effects for Qualifications (Table 10 Panel B)
	gen Secondary=1 if nivel_educativo_aprobado==0 | nivel_educativo_aprobado==1 | nivel_educativo_aprobado==2 | nivel_educativo_aprobado==3
	replace Secondary=0 if nivel_educativo_aprobado!=0 & nivel_educativo_aprobado!=1 & nivel_educativo_aprobado!=2 & nivel_educativo_aprobado!=3
	gen Secondary_Vio= Secondary* avg_vio
	
	gen PostGrad=1 if nivel_educativo_aprobado==8 | nivel_educativo_aprobado==9
	replace PostGrad=0 if nivel_educativo_aprobado!=8 & nivel_educativo_aprobado!=9
	gen PostGrad_Vio= PostGrad* avg_vio
	
	cap erase "$cd1/TeacherTurnover_STM_dif.txt"
	cap erase "$cd1/TeacherTurnover_STM_dif.xls"
	
	cloglog turnover avg_vio PostGrad_Vio Secondary_Vio Secondary PostGrad i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _*, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM_dif.xls", se bdec(3) addtext(Sample, "All Teachers") append slow(150)
	cloglog turnover avg_vio PostGrad_Vio Secondary_Vio Secondary PostGrad i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza==3, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM_dif.xls", se bdec(3) addtext(Sample, "HS Teachers") append slow(150)
	cloglog turnover avg_vio PostGrad_Vio Secondary_Vio Secondary PostGrad i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza!=3 & nivel_ensenanza!=5, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM_dif.xls", se bdec(3) addtext(Sample, "Not HS Teachers") append slow(150)
	cloglog turnover avg_vio PostGrad_Vio Secondary_Vio Secondary PostGrad i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if year_start>2007, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM_dif.xls", se bdec(3) addtext(Sample, "All Teachers, Post 2007 Start Date") append slow(150)
	cloglog turnover avg_vio PostGrad_Vio Secondary_Vio Secondary PostGrad i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza==3 & year_start>2007, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM_dif.xls", se bdec(3) addtext(Sample, "HS Teachers, Post 2007 Start Date") append slow(150)
	cloglog turnover avg_vio PostGrad_Vio Secondary_Vio Secondary PostGrad i.pay_scale i.sobresueldo i.mujer i.age_group Total_Students trabaja madre_dropout TEMA_MATEMATICA TEMA_LENGUAJE _* if nivel_ensenanza!=3 & nivel_ensenanza!=5 & year_start>2007, noconstant vce(cluster DANE_sede)
	outreg2 avg_vio using "$cd1/TeacherTurnover_STM_dif.xls", se bdec(3) addtext(Sample, "Not HS Teachers, Post 2007 Start Date") append slow(150)

	cap erase "$cd1/TeacherTurnover_STM_dif.txt"
	
	
	
	**Graphing hazard rates for post-2007 entry HS teachers (Graph 5)
	preserve
	collapse avg_vio, by (DANE_sede YEAR) 
	bys DANE_sede: egen mean_vio=mean(avg_vio)
	gen violent_period=1 if avg_vio> mean_vio
	replace violent_period=0 if avg_vio<= mean_vio
	sort DANE_sede YEAR
	order DANE_sede YEAR
	save "/Users/haugangl/Desktop/Vio_ToMerge.dta", replace
	
	restore
	sort DANE_sede YEAR
	order DANE_sede YEAR
	merge DANE_sede YEAR using "/Users/haugangl/Desktop/Vio_ToMerge.dta"
	
	cloglog turnover violent_period _ST* if nivel_ensenanza==3 & year_start>2007, noconstant vce(cluster DANE_sede)
	predict h, p
	ge h0 = h if year_start > 2007 & violent_period == 0
	ge h1 = h if year_start > 2007 & violent_period == 1
	lab var h0 "Less-Violent Period"
	lab var h1 "More-Violent Period"
	
	drop if YEAR==2013
	twoway (connect h0 survtime, sort msymbol(t) connect(J) ) (connect h1 survtime, sort msymbol(o) connect(J) ), xtick(1(1)5) ytitle("Hazard") xtitle("Years Teaching") title("Within School Above Average Violence and Teacher Turnover") 
	graph save Graph "/Users/haugangl/Desktop/TurnoverHazards.gph"


	**Effect on Proportion of Teachers with Certain Qualifications (Table 11)
	restore
	
	gen fouryear=1 if nivel_educativo_aprobado==6 | nivel_educativo_aprobado==7
	replace fouryear=0 if nivel_educativo_aprobado!=6 & nivel_educativo_aprobado!=7
	gen twoyear=1 if nivel_educativo_aprobado==4 | nivel_educativo_aprobado==5
	replace twoyear=0 if nivel_educativo_aprobado!=4 & nivel_educativo_aprobado!=5
	collapse Secondary PostGrad fouryear twoyear, by (DANE_sede YEAR)
	
	sort DANE_sede YEAR
	save "$cd1/TeacherQuals.dta", replace
	
	clear
	
	use "$cd1/FINAL_DATASET_Newest_DescStats.dta"
	drop Total_Students
	bys DANE_sede YEAR: gen Total_Students=_N
	collapse Vio_500meters_TOTAL Total_Students male minoria trabaja madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS, by(DANE_sede YEAR)
	
	sort DANE_sede YEAR
	order DANE_sede YEAR
	merge DANE_sede YEAR using "$cd1/TeacherQuals.dta"
	
	xtset DANE_sede YEAR, yearly
	
	global variables "Total_Students male minoria trabaja madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS"
	
	foreach v of global variables{
		gen lag_`v'=l.`v'
		}
	
	gen lag_Vio_500meters_TOTAL=l.Vio_500meters_TOTAL	
	gen lag2_Vio_500meters_TOTAL=l2.Vio_500meters_TOTAL
	gen avg_vio_lag=(l.Vio_500meters_TOTAL + l2.Vio_500meters_TOTAL)/2
	
	global quals "Secondary PostGrad fouryear twoyear"
	
	cap erase "$cd1/TeacherComposition.txt"
	cap erase "$cd1/TeacherComposition.xls"


	foreach qualification of global quals{
		xtreg `qualification' avg_vio_lag i.YEAR, fe vce(cluster DANE_sede)
		outreg2 avg_vio using "$cd1/TeacherComposition.xls", se bdec(3) addtext(Year & School FE, YES, School Controls, NO) append slow(150)
		xtreg `qualification' avg_vio_lag lag_Total_Students lag_male lag_minoria lag_trabaja lag_madre_dropout lag_Strata1 lag_Strata2 lag_Strata3 lag_Strata4 lag_Strata5 lag_Strata6 lag_SALARIOmenos1MMS lag_SALARIOentre1y2MMS lag_SALARIOentre2y5MMS lag_SALARIOmas5MMS lag_Vio_500meters_TOTAL i.YEAR, fe vce(cluster DANE_sede)
		outreg2 avg_vio using "$cd1/TeacherComposition.xls", se bdec(3) addtext(Year & School FE, YES, School Controls, YES) append slow(150)
			}
	
	cap erase "$cd1/TeacherComposition.txt"
	
	cap erase "$cd1/TeacherQuals.dta" 
