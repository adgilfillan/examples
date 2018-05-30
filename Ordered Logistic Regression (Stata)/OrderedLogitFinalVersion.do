/******************************************************************************* 

Alec Gilfillan - Afrobarometer Round 6 data downloaded 5/7/2018 - Final Analysis 

*******************************************************************************/

clear all
set more off
cd "/Users/adgilfillan/Desktop/Afrobar/"
log using afrobar, text replace

use "/Users/adgilfillan/Desktop/Afrobar/merged_r6.dta"

/* Set Survey Weights - Using Multi-Country Weighting */
svyset [pweight=Combinwt]


/* Generate New Variables */

*Total number of languages in each country	
gen lang_tot = .
label variable lang_tot "Total Number of Languages"

levelsof COUNTRY, local(levels)
foreach l of local levels {
	tab Q2 if COUNTRY == `l'
	replace lang_tot = r(r) if COUNTRY == `l'
	}		
	
* Change to simple better/worse/same model
gen Q5mod = .
	replace Q5mod = 1 if Q5 == 1 | Q5 == 2
	replace Q5mod = 2 if Q5 == 3
	replace Q5mod = 3 if Q5 == 4 | Q5 == 5

* Create male dummy
gen male = .
	replace male = 1 if THISINT == 1
	replace male = 0 if THISINT == 2

* Create urban dummy
gen urban = .
	replace urban = 1 if URBRUR == 1
	replace urban = 0 if URBRUR == 2


/* Recode */

*Drop "Missing" and "Don't Know" from Q5
replace Q5 = . if Q5 < 1
replace Q5 = . if Q5 > 5

/* Descriptive Stats */

* Question 5	
tab Q5

* Total No. of Languages in Country
tab COUNTRY, sum(lang_tot) nostan nofreq

su lang_tot
su COUNTRY
su Q5
	
	
/* Ordered Logit Model #1 */
svy: ologit Q5 lang_tot Q1 COUNTRY
	margins, at(lang_tot=(0(5)55))
	marginsplot, ///
		noci ///
		legend(cols(5) pos(12) order(1 "Much Worse" 2 "Worse" 3 "Same" ///
		4 "Better" 5 "Much Better")) ///
		title("") ///
		scheme(burd)
	graph export 1.png, replace


/* Ordered Logit Model #2 */
svy: ologit Q5mod lang_tot Q1 COUNTRY
	margins, at(lang_tot=(0(5)55))
	marginsplot, ///
		noci ///
		legend(cols(3) pos(12) order(1 "Worse" 2 "Same" 3 "Better")) ///
		title("") ///
		scheme(burd)
	graph export 2.png, replace
	

/* Ordered Logit Model #3 */		
svy: ologit Q5mod c.lang_tot##c.lang_tot Q1 COUNTRY male urban
	margins, at(lang_tot=(0(5)55))
	marginsplot, ///
		noci ///
		legend(cols(3) pos(12) order(1 "Worse" 2 "Same" 3 "Better")) ///
		title("") ///
		scheme(burd)
	graph export 3.png, replace
		

	
log close
	

