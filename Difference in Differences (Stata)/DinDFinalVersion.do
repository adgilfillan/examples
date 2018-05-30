/*Alec Gilfillan - Problem Set 5*/
clear

cd "/Users/adgilfillan/Desktop/PS5/"
log using problem_set5, replace

use "/Users/adgilfillan/Desktop/PS5/DinD_ex.dta"

*Mean in NJ before law
su fte if nj==1 & after==0
return list
local njpre = r(mean)
display `njpre'

*Mean in NJ after law
su fte if nj==1 & after==1
return list
local njpost = r(mean)
display `njpost'

*Mean in PA before law
su fte if nj==0 & after==0
return list
local papre = r(mean)
display `papre'

*Mean in PA after law
su fte if nj==0 & after==1
return list
local papost = r(mean)
display `papost'

/*Difference in Difference Estimate*/
display (`njpost' - `papost') - (`njpre' - `papre')


/* Question 2*/
reg dfte nj
reg dfte nj, r

/* Checking for Heteroskedasticity */
su dfte if nj==1
su dfte if nj==0

/* Question 3 */
reg fte nj after njafter
reg fte nj after njafter, r


/* Question 4 */
reg fte nj after njafter, cl(sheet)

/* Using this function as a check */
diff fte, t(nj) p(after) cl(sheet)

/* Question 5*/
xtreg fte nj after njafter, fe i(sheet)

/* Question 8 */
clear
use "/Users/adgilfillan/Desktop/PS5/safesave_slim_data.dta"

/* Plot Avg. Loan Balance Comparison vs Treateant */
egen meancomp = mean(loanbal) if TIKA==0, by(trend)
egen meantreat = mean(loanbal) if TIKA==1, by(trend)
label variable meancomp "Geneva" 
label variable meantreat "Tikapara and Kalyanpur"
tw connected meancomp meantreat trend, sort xline(13) title("Average Loan Balance")

/* Create Post Variable */
gen byte post = 1 if trend >= 13
replace post = 0 if post != 1

/* Create Loan Balance for Comparison and Treatment */
gen loanbalcomp = loanbal if TIKA == 0
gen loanbaltreat = loanbal if TIKA == 1

/* Create Average Monthly Balance for Comparison and Treatment */
gen meancomppre = meancomp if post == 0 
gen meantreatpre = meantreat if post == 0

/* Plan Vanilla Regression of Avg. Monthly Balance pre-treatment for both groups */
reg meancomppre trend
reg meantreatpre trend

/* Comparison Group pre and post */
egen meanbal = mean(loanbal), by (trend)
gen meancomppost = meancomp if post == 1

reg meancomppre trend
reg meancomppost trend

reg meancomppre trend tinpr nage
reg meancomppost trend tinpr nage


/* Difference in Difference Estimation */
gen TIKApost = TIKA*post
gen TIKAposttrend = TIKA*post*trend
gen TIKAtrend = TIKA*trend
gen posttrend = post*trend

reg meanbal TIKA post TIKApost

reg meanbal TIKA post trend TIKApost TIKAposttrend TIKAtrend posttrend tinpr nage i.monthyear, cl(nacc)









