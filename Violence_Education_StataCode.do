/*===================================================================================
================= 	   		Tables, Figures and Estimations 	    =================
================= 	   Neighborhood Violence and Student Outcomes 	=================
================= 		   			Haugan				            =================
=================    Created by: Greg Haugan (Aug 1 - 2015)    		=================
================= Last modified by: Greg Haugan (Oct 16 - 2015)		=================
=====================================================================================
*/


global cd1 "/Users/haugangl/Desktop/"
cap mkdir "$cd1"

**Colombia homicide trends graph
import excel using "$cd1/Colombia_Homicide_Rates", firstrow
rename A year
rename year YEAR
twoway (connect Medellin YEAR, lcolor(gs1) clpattern(solid) lwidth(0.4)) (connect Bogota YEAR, lcolor(gs2) clpattern(dash) lwidth(0.4)) (connect Cali YEAR, lcolor(gs3) clpattern(dot) lwidth(0.4)) (connect Barranquilla YEAR, lcolor(gs5) clpattern(longdash_dot) lwidth(0.4)) (connect Colombia YEAR, lcolor(gs4) clpattern(dash_dot) lwidth(0.4)), name(Homicides_ByCity, replace) legend(order(1 "Medellin" 2 "Bogota" 3 "Cali" 4 "Barranquilla" 5 "Colombia") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) ytitle("Homicides per 100,000 inhabitants") xtitle("Year (Study Time Within Lines)") xline(2006 2013) title("Homicides per 100,000 inhabitants in Colombia, 2002-2013", size(*0.75)) ttick(2002(1)2013)
graph save Homicides_ByCity "$cd1/Homicides_ByCity.gph"


clear
use "/Users/haugangl/Desktop/FINAL_DATASET_Newest_DescStats.dta"

**************************************************
* Table: Descriptive Statistics					 *
**************************************************
	cap erase "Tables.txt"
	cap erase "Tables.xls"
		
	* 	1. Violence Indicators
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

* 	2. School Traits
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


	foreach var of varlist Total_Students TEMA_LENGUAJE TEMA_MATEMATICA TEMA_PUESTO{
		ttest `var', by(highly_exposed)
		matrix `var' = [r(N_2) \ r(mu_2) \ r(sd_2) \ r(N_1) \ r(mu_1) \ r(sd_1) \ r(se)]'
			}
	
	matrix T1a=[Total_Students \ TEMA_LENGUAJE \ TEMA_MATEMATICA \ TEMA_PUESTO]
	

	xml_tab T1a using "Tables.xls", append sheet("More Variables") font("Times New Roman" 11) title("Table 1: Descriptive Statistics") rnames("Total Students" "ICFES Language Score" "ICFES Math Score" "ICFES Rank")


	
	
	restore

	cap erase "Tables.txt"

* 	3. Within School Year to Year Differences by Violence Exposure
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
	
	foreach trait of varlist Total_Students Total_Strata* Strata* SALARIO* SALARIOmas5MMS padre_dropout madre_dropout male minoria trabaja{
		xtreg `trait' year_high_exposure i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/DID_Traits_Byvio.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO, Lag, NO) append slow(150) ctitle(`tit`tema'')
			}
	
	foreach trait of varlist Total_Students Total_Strata* Strata* SALARIO* padre_dropout madre_dropout male minoria trabaja{
		xtreg `trait' year_high_exposure year_high_exposure_lag i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/DID_Traits_Byvio_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO, Lag, YES) append slow(150) ctitle(`tit`tema'')
			}
	
	
	
	cap erase "DID_Traits_Byvio.txt"
	cap erase "DID_Traits_Byvio_lag.txt"
	
	
	**With Violence as dependent variable**
	
	cap erase "Vio_DepVar.txt"
	cap erase "Vio_DepVar.xls"
	
	foreach trait of varlist Total_Students Total_Strata* Strata* SALARIO* padre_dropout madre_dropout male minoria trabaja{
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

	
	*	1. School Level	
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
	
	**No Lag
		*No Controls
	foreach tema of global icfes{
		xtreg stnd_`tema' Vio_500meters_TOTAL i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_nolag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO, Lag, NO) append slow(150) ctitle(`tit`tema'')
		
		*With controls
		xtreg stnd_`tema' Vio_500meters_TOTAL `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_nolag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, NO, Lag, NO) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' Vio_500meters_TOTAL `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_nolag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES, Lag, NO) append slow(150) ctitle(`tit`tema'')
						}	
	**With Lag
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
		
	**Two-year violence average
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
	
	
	*	2. Student Level	
	*-----------------
	
	keep Vio* COLE_CODIGO_COLEGIO YEAR
	sort COLE_CODIGO_COLEGIO YEAR Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL
	order COLE_CODIGO_COLEGIO YEAR Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL
	save "/Users/haugangl/Desktop/Vio_ToMerge.dta", replace
	restore
	
	sort COLE_CODIGO_COLEGIO YEAR Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL
	order COLE_CODIGO_COLEGIO YEAR Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL
	merge COLE_CODIGO_COLEGIO YEAR Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL using "/Users/haugangl/Desktop/Vio_ToMerge.dta"
	
	
	local controls Total_Students male COMPLETA_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO
	local controls2 Total_Students male COMPLETA_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
	**No Lag
		*No Controls
	foreach tema of global icfes{
		xtreg `tema' Vio_500meters_TOTAL i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/student_nolag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO, Lag, NO) append slow(150) ctitle(`tit`tema'')
		
		*With controls
		xtreg `tema' Vio_500meters_TOTAL `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/student_nolag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, NO, Lag, NO) append slow(150) ctitle(`tit`tema'')
		xtreg `tema' Vio_500meters_TOTAL `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/student_nolag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES, Lag, NO) append slow(150) ctitle(`tit`tema'')
						}	
	**With Lag
		*No Controls
	foreach tema of global icfes{
		xtreg `tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/student_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO, Lag, YES) append slow(150) ctitle(`tit`tema'')
		
		*With controls
		xtreg `tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/student_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, NO, Lag, YES) append slow(150) ctitle(`tit`tema'')
		xtreg `tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/student_lag.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES, Lag, YES) append slow(150) ctitle(`tit`tema'')
						}	
		

	cap erase "$cd1/student_nolag.txt"
	cap erase "$cd1/student_lag.txt"

**************************************************
* Checking robustness of regression results		 *
**************************************************
	clear
	use "/Users/haugangl/Desktop/FINAL_DATASET_Newest_DescStats.dta"
	
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
	
	*Standardizing test scores
	foreach tema of global icfes{
	bys YEAR: egen sd_`tema'=sd(`tema')
	bys YEAR: egen mean_`tema'=mean(`tema')
	gen stnd_`tema'=(`tema'-mean_`tema')/sd_`tema'
		}
	
	gen avg_vio=(Vio_500meters_TOTAL+ Vio_500meters_TOTAL_lag)/2
	
	
	global icfes "TEMA_MATEMATICA TEMA_LENGUAJE TEMA_BIOLOGIA TEMA_FISICA TEMA_QUIMICA TEMA_CIENCIAS_SOCIALES TEMA_FILOSOFIA TEMA_PUESTO"
	


	local controls2 Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
	
	local titTEMA_MATEMATICA "Math"
	local titTEMA_LENGUAJE "Language"
	local titTEMA_BIOLOGIA "Biology"
	local titTEMA_FISICA "Physics"
	local titTEMA_QUIMICA "Chemistry"
	local titTEMA_CIENCIAS_SOCIALES "Social Sciences"
	local titTEMA_FILOSOFIA "Philosophy"
	local titTEMA_PUESTO "Rank"
	
	cap erase "$cd1/school_leads.txt"
	cap erase "$cd1/school_leadsWEYV.txt"
	cap erase "$cd1/school_leads_avg.txt"
	cap erase "$cd1/school_greater_distances.txt"
	cap erase "$cd1/school_greater_distances_avg.txt"
	cap erase "$cd1/school_greater_distances_with500.txt"
	foreach i of numlist 1 2 3 4 6{
	cap erase "$cd1/RestrictedSample_Zone`i'.txt"
	}
	cap erase "$cd1/RestrictedSample_LargerZones.txt"
	
	cap erase "$cd1/school_leads.xls"
	cap erase "$cd1/school_leadsWEYV.xls"
	cap erase "$cd1/school_leads_avg.xls"
	cap erase "$cd1/school_greater_distances.xls"
	cap erase "$cd1/school_greater_distances_avg.xls"
	cap erase "$cd1/school_greater_distances_with500.xls"
	foreach i of numlist 1 2 3 4 6{
	cap erase "$cd1/RestrictedSample_Zone`i'.xls"
	cap erase "$cd1/RestrictedSample_Zone`i'_avg.xls"
	}
	cap erase "$cd1/RestrictedSample_LargerZones.xls"
	cap erase "$cd1/RestrictedSample_LargerZones_avg.xls"


**Checking robustness by including leads as explanatory variables
	**Without Including Exam Year Violence
		*No Controls
	foreach tema of global icfes{
		xtreg stnd_`tema' Vio_500meters_TOTAL_lead i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL_lead using "$cd1/school_leads.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' Vio_500meters_TOTAL_lead Vio_500meters_TOTAL_lead2 i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL_lead Vio_500meters_TOTAL_lead2 using "$cd1/school_leads.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		*With controls
		xtreg stnd_`tema' Vio_500meters_TOTAL_lead Vio_500meters_TOTAL_lead2 `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_leads.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
						}
	**Including Exam Year Violence
		*No Controls
	foreach tema of global icfes{
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lead i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lead using "$cd1/school_leadsWEYV.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lead Vio_500meters_TOTAL_lead2 i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lead Vio_500meters_TOTAL_lead2 using "$cd1/school_leadsWEYV.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		*With controls
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lead Vio_500meters_TOTAL_lead2 `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_leadsWEYV.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
						}
	
	**Two-year homicide average
		*No Controls
	gen avg_lead=(Vio_500meters_TOTAL_lead+Vio_500meters_TOTAL_lead2)/2 
	
	foreach tema of global icfes{
		xtreg stnd_`tema' avg_lead i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL_lead using "$cd1/school_leads_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
		*With controls
		xtreg stnd_`tema' avg_lead `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL using "$cd1/school_leads_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			}	
	
	cap erase "$cd1/school_leads.txt"
	cap erase "$cd1/school_leadsWEYV.txt"
	cap erase "$cd1/school_leads_avg.txt"
				
**Checking robustness by including violence at larger distances
	foreach tema of global icfes{
		foreach m of numlist 1000 1500 2000{
			*No Controls
			xtreg stnd_`tema' Vio_`m'meters_TOTAL Vio_`m'meters_TOTAL_lag i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_`m'meters_TOTAL Vio_`m'meters_TOTAL_lag using "$cd1/school_greater_distances.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
			*Controls
			xtreg stnd_`tema' Vio_`m'meters_TOTAL Vio_`m'meters_TOTAL_lag `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_`m'meters_TOTAL Vio_`m'meters_TOTAL_lag using "$cd1/school_greater_distances.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
						}
				}
	
	*With two-year average
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
	
	
	*Again, including Violence within 500 meters
	foreach tema of global icfes{
		foreach m of numlist 1000 1500 2000{
			xtreg stnd_`tema' Vio_`m'meters_TOTAL Vio_`m'meters_TOTAL_lag Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_`m'meters_TOTAL Vio_`m'meters_TOTAL_lag using "$cd1/school_greater_distances_with500.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
						}
				}

cap erase "$cd1/school_greater_distances.txt"
cap erase "$cd1/school_greater_distances_avg.txt"
cap erase "$cd1/school_greater_distances_with500.txt"

restore




**Checking robustness with regressions on restricted samples
clear
use "/Users/haugangl/Desktop/FINAL_DATASET_Newest_DescStats.dta"

preserve
order DANE_sede
sort DANE_sede
merge DANE_sede using "comunas.dta"
tab _merge
keep if _merge==3
sort YEAR COLE_CODIGO_COLEGIO
order YEAR COLE_CODIGO_COLEGIO

collapse COMUNA Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS TEMA_LENGUAJE TEMA_MATEMATICA TEMA_FILOSOFIA TEMA_FISICA TEMA_BIOLOGIA TEMA_CIENCIAS_SOCIALES TEMA_QUIMICA TEMA_PUESTO COMPLETA_jornada MANANA_jornada NOCHE_jornada SABATINA_jornada TARDE_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_NORMALISTA tipo_TECNICO, by(COLE_CODIGO_COLEGIO YEAR)
xtset COLE_CODIGO_COLEGIO YEAR, yearly
replace COMUNA=round(COMUNA, 1.0)
gen zone=1 if COMUNA==1 | COMUNA==2 | COMUNA==3 | COMUNA==4
replace zone=2 if COMUNA==5 | COMUNA==6 | COMUNA==7
replace zone=3 if COMUNA==8 | COMUNA==9 | COMUNA==10
replace zone=4 if COMUNA==11 | COMUNA==12 | COMUNA==13
replace zone=5 if COMUNA==14
replace zone=6 if COMUNA==15 | COMUNA==16

global vio "Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL"
foreach v of global vio{
gen `v'_lag = l.`v'
gen `v'_lag2 = l2.`v'
gen `v'_lead = f.`v'
gen `v'_lead2 = f2.`v'
}


*Standardizing test scores
	foreach tema of global icfes{
	bys YEAR: egen sd_`tema'=sd(`tema')
	bys YEAR: egen mean_`tema'=mean(`tema')
	gen stnd_`tema'=(`tema'-mean_`tema')/sd_`tema'
		}
	
	gen avg_vio=(Vio_500meters_TOTAL+ Vio_500meters_TOTAL_lag)/2


set matsize 2000
local controls2 Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
global icfes "TEMA_MATEMATICA TEMA_LENGUAJE TEMA_BIOLOGIA TEMA_FISICA TEMA_QUIMICA TEMA_CIENCIAS_SOCIALES TEMA_FILOSOFIA TEMA_PUESTO"



foreach i of numlist 1 2 3 4 6{
	foreach tema of global icfes{
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR if zone==`i', fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/RestrictedSample_Zone`i'.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Controls, YES) append slow(150) ctitle(`tit`tema'')
				}
			}
	
foreach i of numlist 1 2 3 4 6{
	foreach tema of global icfes{
		xtreg stnd_`tema' avg_vio `controls2' i.YEAR if zone==`i', fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/RestrictedSample_Zone`i'_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, Controls, YES) append slow(150) ctitle(`tit`tema'')
				}
			}

	foreach tema of global icfes{
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR if zone==1 | zone==2, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/RestrictedSample_LargerZones.xls", se bdec(3) addtext(Year & School FE, YES, Controls, YES, Zone, NORTH) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR if zone==3 | zone==4, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/RestrictedSample_LargerZones.xls", se bdec(3) addtext(Year & School FE, YES, Controls, YES, Zone, CENTER/WEST) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag `controls2' i.YEAR if zone==5 | zone==6, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/RestrictedSample_LargerZones.xls", se bdec(3) addtext(Year & School FE, YES, Controls, YES, Zone, SOUTH/SW) append slow(150) ctitle(`tit`tema'')	
				}

	foreach tema of global icfes{
		xtreg stnd_`tema' avg_vio `controls2' i.YEAR if zone==1 | zone==2, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/RestrictedSample_LargerZones_avg.xls", se bdec(3) addtext(Year & School FE, YES, Controls, YES, Zone, NORTH) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' avg_vio `controls2' i.YEAR if zone==3 | zone==4, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/RestrictedSample_LargerZones_avg.xls", se bdec(3) addtext(Year & School FE, YES, Controls, YES, Zone, CENTER/WEST) append slow(150) ctitle(`tit`tema'')
		xtreg stnd_`tema' avg_vio `controls2' i.YEAR if zone==5 | zone==6, fe vce(cluster COLE_CODIGO_COLEGIO)
		outreg2 avg_vio using "$cd1/RestrictedSample_LargerZones_avg.xls", se bdec(3) addtext(Year & School FE, YES, Controls, YES, Zone, SOUTH/SW) append slow(150) ctitle(`tit`tema'')	
				}

	foreach i of numlist 1 2 3 4 6{
	cap erase "$cd1/RestrictedSample_Zone`i'.txt"
	cap erase "$cd1/RestrictedSample_Zone`i'_avg.txt"	
	}
	cap erase "$cd1/RestrictedSample_LargerZones.txt"
	cap erase "$cd1/RestrictedSample_LargerZones_avg.txt"

	
**************************************************
* Instrumental Variables Approach				 *
**************************************************
clear
use "/Users/haugangl/Desktop/FINAL_DATASET_Newest_DescStats.dta"

**Creating Homicides by Comunas graphs
	
	preserve
	order DANE_sede
	sort DANE_sede
	merge DANE_sede using "comunas.dta"
	tab _merge
	keep if _merge==3
	sort YEAR COLE_CODIGO_COLEGIO
	order YEAR COLE_CODIGO_COLEGIO

	collapse Vio_500meters_TOTAL COMUNA, by(COLE_CODIGO_COLEGIO YEAR)
	xtset COLE_CODIGO_COLEGIO YEAR, yearly
	tab COMUNA
	**A small number of odd observations
	replace COMUNA=round(COMUNA, 1.0)
	collapse Vio_500meters_TOTAL, by(COMUNA YEAR)
	tab COMUNA
	
	reshape wide Vio_500meters_TOTAL, i(YEAR) j(COMUNA)
	twoway (connect Vio_500meters_TOTAL1 YEAR, lcolor(gs1) lwidth(0.4)) (connect Vio_500meters_TOTAL2 YEAR, lcolor(gs2) clpattern(dash) lwidth(0.4)) (connect Vio_500meters_TOTAL3 YEAR, lcolor(gs3) clpattern(dot) lwidth(0.4)) (connect Vio_500meters_TOTAL4 YEAR, lcolor(gs4) clpattern(longdash_dot) lwidth(0.4)), name(Homicides_NortheastZone, replace) legend(order(1 "Comuna1 - Popular" 2 "Comuna2 - Santa Cruz" 3 "Comuna3 - Manrique" 4 "Comuna4 - Aranjuez") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) xtitle("Homicides Within 500 Meters of Schools, by Comunas") title("Northeast Zone, 2006-2013", size(*0.75)) ttick(2006(1)2013)
	twoway (connect Vio_500meters_TOTAL5 YEAR, lcolor(gs5) lwidth(0.4)) (connect Vio_500meters_TOTAL6 YEAR, lcolor(gs6) clpattern(dash) lwidth(0.4)) (connect Vio_500meters_TOTAL7 YEAR, lcolor(gs7) clpattern(dot) lwidth(0.4)), name(Homicides_NorthwestZone, replace) legend(order(1 "Comuna5 - Castilla" 2 "Comuna6 - 12 Octubre" 3 "Comuna7 - Robledo") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) xtitle("Homicides Within 500 Meters of Schools, by Comunas") title("Northwest Zone, 2006-2013", size(*0.75)) ttick(2006(1)2013)
	twoway (connect Vio_500meters_TOTAL8 YEAR, lcolor(gs8) lwidth(0.4)) (connect Vio_500meters_TOTAL9 YEAR, lcolor(gs9) clpattern(dash) lwidth(0.4)) (connect Vio_500meters_TOTAL10 YEAR, lcolor(gs10) clpattern(dot) lwidth(0.4)) (connect Vio_500meters_TOTAL14 YEAR, lcolor(gs14) clpattern(longdash_dot) lwidth(0.4)), name(Homicides_CentralZone, replace) legend(order(1 "Comuna8 - Villa Hermosa" 2 "Comuna9 - Buenos Aires" 3 "Comuna10 - Candelaria" 4 "Comuna14 - Poblado") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) xtitle("Homicides Within 500 Meters of Schools, by Comunas") title("Central and Southeast Zones, 2006-2013", size(*0.75)) ttick(2006(1)2013)
	twoway (connect Vio_500meters_TOTAL11 YEAR, lcolor(gs11) lwidth(0.4)) (connect Vio_500meters_TOTAL12 YEAR, lcolor(gs12) clpattern(dash) lwidth(0.4)) (connect Vio_500meters_TOTAL13 YEAR, lcolor(gs13) clpattern(dot) lwidth(0.4)) (connect Vio_500meters_TOTAL15 YEAR, lcolor(gs15) clpattern(longdash_dot) lwidth(0.4)) (connect Vio_500meters_TOTAL16 YEAR, lcolor(gs16) clpattern(longdash_dot) lwidth(0.4)), name(Homicides_WesternZone, replace) legend(order(1 "Comuna11 - Laureles" 2 "Comuna12 - America" 3 "Comuna13 - San Javier" 4 "Comuna15 - Guayabal" 5 "Comuna16 - Belen") c(1) r(3) size(*0.8)) graphregion(color(white)) bgcolor(white) xlabel(none) ylabel(,labsize(small)) xtitle("Homicides Within 500 Meters of Schools, by Comunas") title("West and Southwest Zones, 2006-2013", size(*0.75)) ttick(2006(1)2013)
	
	restore
	
	**Repeat to graph by zone
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
	clear
	use "/Users/haugangl/Desktop/FINAL_DATASET_Newest_DescStats.dta"
	
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
*          Heterogeneous Effects        		 *
**************************************************

clear
use "/Users/haugangl/Desktop/FINAL_DATASET_Newest_DescStats.dta"
global cd1 "/Users/haugangl/Desktop"
cap mkdir "$cd1"
set matsize 2000
preserve


foreach tema of global icfes{
	bys YEAR: egen sd_`tema'=sd(`tema')
	bys YEAR: egen mean_`tema'=mean(`tema')
	gen stnd_`tema'=(`tema'-mean_`tema')/sd_`tema'
		}
	


**Merging violence lags into student-level data
sort COLE_CODIGO_COLEGIO YEAR
order COLE_CODIGO_COLEGIO YEAR
merge COLE_CODIGO_COLEGIO YEAR using "/Users/haugangl/Desktop/lags.dta"
tab _merge
drop _merge

gen avg_vio=(Vio_500meters_TOTAL+ Vio_500meters_TOTAL_lag)/2


**Generating variables for heterogeneous effects
gen Noche_Dif= NOCHE_jornada*Vio_500meters_TOTAL
gen Noche_Dif_avg=NOCHE_jornada*avg_vio

gen male_dif= male* Vio_500meters_TOTAL
gen male_dif_avg=male*avg_vio

gen minoria_dif= minoria* Vio_500meters_TOTAL
gen minoria_dif_avg=minoria*avg_vio

gen both_dropout=1 if padre_dropout==1 & madre_dropout==1
replace both_dropout=0 if madre_dropout==0 | padre_dropout==0
gen one_dropout=1 if padre_dropout==1 | madre_dropout==1
replace one_dropout=0 if padre_dropout==1 & madre_dropout==1
replace one_dropout=0 if padre_dropout==0 & madre_dropout==0

gen madre_dropout_dif= madre_dropout*Vio_500meters_TOTAL
gen madre_dropout_dif_avg= madre_dropout*avg_vio
gen both_dropout_dif= both_dropout* Vio_500meters_TOTAL
gen one_dropout_dif= one_dropout* Vio_500meters_TOTAL

gen Strata1_2=1 if Strata1==1 | Strata2==1
replace Strata1_2=0 if Strata1==0 & Strata2==0
gen Strata4_6=1 if Strata4==1 | Strata5==1 | Strata6==1
replace Strata4_6=0 if Strata4==0 & Strata5==0  & Strata6==0
gen Strata1_2dif= Strata1_2*Vio_500meters_TOTAL
gen Strata1_2dif_avg= Strata1_2*avg_vio
gen Strata4_6dif= Strata4_6*Vio_500meters_TOTAL
gen Strata4_6dif_avg= Strata4_6*avg_vio


gen Noche_Dif_lag= NOCHE_jornada*Vio_500meters_TOTAL_lag
gen male_dif_lag= male* Vio_500meters_TOTAL_lag
gen minoria_dif_lag= minoria* Vio_500meters_TOTAL_lag
gen madre_dropout_dif_lag= madre_dropout*Vio_500meters_TOTAL_lag
gen both_dropout_dif_lag= both_dropout* Vio_500meters_TOTAL_lag
gen one_dropout_dif_lag= one_dropout* Vio_500meters_TOTAL_lag
gen Strata1_2dif_lag= Strata1_2*Vio_500meters_TOTAL_lag
gen Strata4_6dif_lag= Strata4_6*Vio_500meters_TOTAL_lag


**Regressions
	cap erase "$cd1/DifEffects_Male.txt"
	cap erase "$cd1/DifEffects_Minority.txt"
	cap erase "$cd1/DifEffects_Dropout_Mom.txt"
	cap erase "$cd1/DifEffects_Both.txt"
	cap erase "$cd1/DifEffects_Strata.txt"
	cap erase "$cd1/DifEffects_Night.txt"
	
	cap erase "$cd1/DifEffects_Male.xls"
	cap erase "$cd1/DifEffects_Minority.xls"
	cap erase "$cd1/DifEffects_Dropout_Mom.xls"
	cap erase "$cd1/DifEffects_Dropout_Both.xls"
	cap erase "$cd1/DifEffects_Strata.xls"
	cap erase "$cd1/DifEffects_Night.xls"
	
	
	
global icfes "TEMA_MATEMATICA TEMA_LENGUAJE TEMA_BIOLOGIA TEMA_FISICA TEMA_QUIMICA TEMA_CIENCIAS_SOCIALES TEMA_FILOSOFIA TEMA_PUESTO"
xtset COLE_CODIGO_COLEGIO
	
	*Male differential effect
	local controls Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
		foreach tema of global icfes{
			xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag male_dif male_dif_lag `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/DifEffects_Male.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			xtreg stnd_`tema' avg_vio male_dif_avg `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 avg_vio male_dif_avg using "$cd1/DifEffects_Male.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')		
					}
	
	
	*Minority students differential effect
		foreach tema of global icfes{
			xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag minoria_dif minoria_dif_lag `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/DifEffects_Minority.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			xtreg stnd_`tema' avg_vio minoria_dif minoria_dif_avg `controls' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 avg_vio minoria_dif minoria_dif_avg using "$cd1/DifEffects_Minority.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')		
					}	
	

	*Parent dropout differential effect
		*First for mother dropout status
	local controls2 Total_Students male minoria trabaja madre_dropout padre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
		foreach tema of global icfes{
			xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag madre_dropout_dif madre_dropout_dif_lag `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/DifEffects_Dropout_Mom.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			xtreg stnd_`tema' avg_vio madre_dropout_dif_avg `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 avg_vio madre_dropout_dif_avg using "$cd1/DifEffects_Dropout_Mom.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')	
					}
					
		*Second for both parents' dropout status			
	local controls2 Total_Students male minoria trabaja both_dropout one_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
		foreach tema of global icfes{
			xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag both_dropout_dif both_dropout_dif_lag one_dropout_dif one_dropout_dif_lag `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/DifEffects_Dropout_Both.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
					}
	
	
	*Strata differential effect
	drop if ESTU_ESTRATO==8
	local controls3 Total_Students male minoria trabaja padre_dropout madre_dropout Strata1_2 Strata4_6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
		foreach tema of global icfes{
			xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag Strata1_2dif Strata1_2dif_lag Strata4_6dif Strata4_6dif_lag `controls3' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/DifEffects_Strata.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			xtreg stnd_`tema' avg_vio Strata1_2dif_avg Strata4_6dif_avg `controls3' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
			outreg2 avg_vio Strata1_2dif_avg Strata4_6dif_avg using "$cd1/DifEffects_Strata.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')		
					}
	
	
	*Night classes differential effect
	sort DANE_sede
	order DANE_sede
	merge DANE_sede using  "/Users/haugangl/Desktop/comunas.dta"
	local controls4 NOCHE_jornada Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS
	xtset DANE_sede
		foreach tema of global icfes{
			xtreg stnd_`tema' Vio_500meters_TOTAL Vio_500meters_TOTAL_lag Noche_Dif Noche_Dif_lag `controls4' i.YEAR, fe vce(cluster DANE_sede)
			outreg2 Vio_500meters_TOTAL Vio_500meters_TOTAL_lag using "$cd1/DifEffects_Night.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
			xtreg stnd_`tema' avg_vio Noche_Dif_avg `controls4' i.YEAR, fe vce(cluster DANE_sede)
			outreg2 avg_vio Noche_Dif_avg using "$cd1/DifEffects_Night.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')	
					}


	cap erase "$cd1/DifEffects_Male.txt"
	cap erase "$cd1/DifEffects_Minority.txt"
	cap erase "$cd1/DifEffects_Dropout_Mom.txt"
	cap erase "$cd1/DifEffects_Dropout_Both.txt"
	cap erase "$cd1/DifEffects_Strata.txt"
	cap erase "$cd1/DifEffects_Night.txt"
	
	
	
**************************************************
*     Effect of Violence on ICFES Distribution   *
**************************************************

clear
use "/Users/haugangl/Desktop/Tesis/DATA/FINAL_DATASET_Newest_DescStats.dta"
global icfes "TEMA_MATEMATICA TEMA_LENGUAJE TEMA_BIOLOGIA TEMA_FISICA TEMA_QUIMICA TEMA_CIENCIAS_SOCIALES TEMA_FILOSOFIA TEMA_PUESTO"

foreach tema of global icfes{
bys COLE_CODIGO_COLEGIO YEAR: egen skew_`tema'=skew(`tema')
bys COLE_CODIGO_COLEGIO YEAR: egen kurt_`tema'=kurt(`tema')
	}

sort YEAR COLE_CODIGO_COLEGIO
order YEAR COLE_CODIGO_COLEGIO
preserve
collapse pre_vio Vio_500meters_TOTAL Vio_1000meters_TOTAL Vio_1500meters_TOTAL Vio_2000meters_TOTAL Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS TEMA_LENGUAJE TEMA_MATEMATICA TEMA_FILOSOFIA TEMA_FISICA TEMA_BIOLOGIA TEMA_CIENCIAS_SOCIALES TEMA_QUIMICA TEMA_PUESTO skew_TEMA_MATEMATICA kurt_TEMA_MATEMATICA skew_TEMA_LENGUAJE kurt_TEMA_LENGUAJE skew_TEMA_BIOLOGIA kurt_TEMA_BIOLOGIA skew_TEMA_FISICA kurt_TEMA_FISICA skew_TEMA_QUIMICA kurt_TEMA_QUIMICA skew_TEMA_CIENCIAS_SOCIALES kurt_TEMA_CIENCIAS_SOCIALES skew_TEMA_FILOSOFIA kurt_TEMA_FILOSOFIA skew_TEMA_PUESTO kurt_TEMA_PUESTO COMPLETA_jornada MANANA_jornada NOCHE_jornada SABATINA_jornada TARDE_jornada tipo_ACADEMICO tipo_ACADEMICO_Y_TECNICO tipo_NORMALISTA tipo_TECNICO, by(COLE_CODIGO_COLEGIO YEAR)
xtset COLE_CODIGO_COLEGIO YEAR, yearly

gen Vio_500meters_TOTAL_lag = l.Vio_500meters_TOTAL

foreach tema of global icfes{
bys YEAR: egen sd_`tema'=sd(`tema')
bys YEAR: egen mean_`tema'=mean(`tema')
gen stnd_`tema'=(`tema'-mean_`tema')/sd_`tema'
	}

gen avg_vio=(Vio_500meters_TOTAL+ Vio_500meters_TOTAL_lag)/2

local controls2 Total_Students male minoria trabaja padre_dropout madre_dropout Strata1 Strata2 Strata3 Strata4 Strata5 Strata6 SALARIOmenos1MMS SALARIOentre1y2MMS SALARIOentre2y5MMS SALARIOmas5MMS

global skew_icfes "skew_TEMA_MATEMATICA skew_TEMA_LENGUAJE skew_TEMA_BIOLOGIA skew_TEMA_FISICA skew_TEMA_QUIMICA skew_TEMA_CIENCIAS_SOCIALES skew_TEMA_FILOSOFIA skew_TEMA_PUESTO"
foreach tema of global skew_icfes{
xtreg `tema' avg_vio i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
outreg2 avg_vio using "$cd1/school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
xtreg `tema' avg_vio `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
outreg2 avg_vio using "$cd1/school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
}

global kurt_icfes "kurt_TEMA_MATEMATICA kurt_TEMA_LENGUAJE kurt_TEMA_BIOLOGIA kurt_TEMA_FISICA kurt_TEMA_QUIMICA kurt_TEMA_CIENCIAS_SOCIALES kurt_TEMA_FILOSOFIA kurt_TEMA_PUESTO"
foreach tema of global kurt_icfes{
xtreg `tema' avg_vio i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
outreg2 avg_vio using "$cd1/kurt_school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, NO, Socioeconomic Controls, NO) append slow(150) ctitle(`tit`tema'')
xtreg `tema' avg_vio `controls2' i.YEAR, fe vce(cluster COLE_CODIGO_COLEGIO)
outreg2 avg_vio using "$cd1/kurt_school_avg.xls", se bdec(3) addtext(Year FE, YES, School FE, YES, School Controls, YES, Socioeconomic Controls, YES) append slow(150) ctitle(`tit`tema'')
}





**************************************************
*     Causal Pathways - Teacher Turnover   		 *
**************************************************



	clear
	use "/Users/haugangl/Desktop/docentes_2008-2013.dta"
	global cd1 "/Users/haugangl/Desktop"
	cap mkdir "$cd1"
	set matsize 2000
	
	rename codigo_dane_ee DANE_sede
	rename anno_carga YEAR
	
	sort DANE_sede YEAR
	order DANE_sede YEAR
	merge DANE_sede YEAR using "$cd1/MergeIntoProfs.dta"
	
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
		*dropping two strange obs
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
	
	
	
	**Survival model
	
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
	
	*Differential Effects for Qualifications
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
	
	
	
	**Graphing hazard rates for post-2007 entry HS teachers
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


	**Effect on Proportion of Teachers with Certain Qualifications
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
