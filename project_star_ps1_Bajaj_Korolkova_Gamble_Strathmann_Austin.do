************* WWS508c PS1 *************
*  Spring 2018			              *
*  Author : Chris Austin              *
*  Email: chris.austin@princeton.edu  *
***************************************

/*
Credit: Somya Bajaj, Joelle Gamble, Anastasia Korolkova, Luke Strathmann, Chris Austin
Last modified by: Chris Austin
Last modified on: 2/19/18
*/

clear all

*Set directory, dta file, etc.
cd "C:\Users\TerryMoon\Dropbox\Teaching Princeton\wws508c 2018S\ps\ps1"
*cd "C:\Users\Chris\Documents\Princeton\WWS Spring 2018\WWS 508c\PS1\DTA"

use project_star_ps1.dta
set more off
set matsize 10000
capture log close
log using PS1.log, replace

*Download outreg2
ssc install outreg2

********************************************************************************
**                                   P1                                       **
********************************************************************************
//summary statistics and cross tabs//

tab srace
tab sesk
tab schtypek
tab cltypek

tab cltype tracek, column
tab cltype hdegk, column
tab cltypek ssex, column
tab cltypek srace, column

********************************************************************************
**                                   P2                                       **
********************************************************************************
//chi-square tests for checking independence//

tab cltypek ssex, chi2
tab cltypek srace, chi2
tab cltypek sesk, chi2

//t-tests yielding the same conclusions//

ttest cltypek, by(ssex) 

gen blackwhite = srace
replace blackwhite = . if blackwhite == 6
ttest cltypek, by(blackwhite) 

ttest cltypek, by(sesk) 

********************************************************************************
**                                   P3                                       11 
********************************************************************************
//conditional summary statistics to determine differences within test types//
sum treadssk if cltypek == 1
sum treadssk if cltypek == 2

sum tmathssk if cltypek == 1
sum tmathssk if cltypek == 2

//testing differences in means between classroom type and reading scores// 
ttesti 1739 440.5474 32.49738 2006 434.7323 30.9359, unequal

//testing differences in means between classroom type and math scores//
ttesti 1762 490.9313 49.51013 2032 483.1993 47.63593, unequal


********************************************************************************
**                                   P4                                       **
********************************************************************************
//conditional summary statistics to determine differences within test types//
sum treadssk if cltypek == 2
sum treadssk if cltypek == 3

sum tmathssk if cltypek == 2
sum tmathssk if cltypek == 3

//testing differences in means between classroom type and reading scores// 
ttesti 2006 434.7323  30.9359 2044 435.4295 31.50247, unequal

//testing differences in means between classroom type and math scores//
ttesti  2032 483.1993 47.63593 2077 482.7959 45.78352, unequal

********************************************************************************
**                                   P5                                       **
********************************************************************************
//conditional summary statistics to determine differences within combined test score//
tabstat tcombssk if srace==1, by(cltypek) stat(n, mean, sd)
tabstat tcombssk if srace==2, by(cltypek) stat(n, mean, sd)
tabstat tcombssk if sesk==1, by(cltypek) stat(n, mean, sd)
tabstat tcombssk if sesk==2, by(cltypek) stat(n, mean, sd)
tabstat tcombssk if schtypek==1, by(cltypek) stat(n, mean, sd)
tabstat tcombssk if schtypek==2, by(cltypek) stat(n, mean, sd)

**generating smallclass1 as dummy for small class or regular class**
gen smallclass1 = cltypek
label values smallclass1 cltypek
replace smallclass1 = . if smallclass1 == 3
ttest treadssk, by(smallclass1)
ttest tmathssk, by(smallclass1)

**generating smallclass2 as dummy for regular class or regular class+aid**
gen smallclass2 = cltypek
replace smallclass2 = . if smallclass2 == 1
ttest treadssk, by(smallclass2)
ttest tmathssk, by(smallclass2)

//Race//
**t-test of test scores for black students small vs. regular class
ttest tcombssk if blackwhite == 2, by(smallclass1)

**ttest of test scores for white students small vs. regular class
ttest tcombssk if blackwhite == 1, by(smallclass1)

**calculating the t-test by hand with differences in means and standard error given by previous t-tests
di (15.85-12.79)/(4.27+2.93)
/*t-stat=.425. Fail to reject the null hypothesis. Therefore we cannot conclude a 
statistically significant difference in how black students performed moving from 
small to regular classes compared to white students.*/

**ttest of test scores for black students regular vs. regular+aid class
ttest tcombssk if blackwhite == 2, by(smallclass2)

**ttest of test scores for white students regular vs. regular+aid class
ttest tcombssk if blackwhite == 1, by(smallclass2)

**calculating the ttest by hand with differences in means and standard error given by previous t-tests
di (.0363+1.02)/(3.91+2.72)
/*t-stat=.16 fail to reject the null hypothesis. Therefore we cannot conclude a 
statistically significant difference in how black students performed moving from 
regular to regular+aid classes compared to white students.*/

//Socioeconomic Status//
ttest tcombssk if sesk == 2, by(smallclass1)
ttest tcombssk if sesk == 1, by(smallclass1)

**calculating the ttest by hand with differences in means and standard error given by previous t-tests
di (14.26328-13.78526)/(3.340742+3.336679)
/*t-stat = .07158752. Therefore fail to reject null hypothesis. Therefore we 
cannot conclude a statistically significant difference in how low economic status 
students performed moving from small to regular class size compared to high 
economic status students.*/

ttest tcombssk if sesk == 2, by(smallclass2)
ttest tcombssk if sesk == 1, by(smallclass2)

**calculating the ttest by hand with differences in means and standard error given by previous t-tests
di (-1.982258+.7236112)/(3.15101+3.026489)
/*t-stat = -.20 therefore fail to reject null hypothesis. Therefore no statistical 
difference in how low economic status students performed moving from regular class 
size to regular+aid compared to high economic status students.*/

//Rural vs. Nonrural//
gen ruralnonrural = schtypek
replace ruralnonrural = 1 if (schtypek == 1) | (schtypek == 2) | (schtypek == 4) 
replace ruralnonrural = 2 if schtypek == 3

ttest tcombssk if ruralnonrural == 2, by(smallclass1)
ttest tcombssk if ruralnonrural == 1, by(smallclass1)

**calculating the ttest by hand with differences in means and standard error given by previous t-tests
di (13.74826-14.5062)/(3.518212+3.404465)

/*t-stat = -0.109 therefore fail to reject null hypothesis. Therefore we cannot 
conclude a statistically significant difference in how rural students performed 
moving from small to regular class size compared to nonrural students.*/

ttest tcombssk if ruralnonrural == 2, by(smallclass2)
ttest tcombssk if ruralnonrural == 1, by(smallclass2)

**calculating the ttest by hand with differences in means and standard error given by previous t-tests
di (-2.322453-.7015466)/(3.283434+3.141224)

/*t-stat = .47 therefore fail to reject null hypothesis. Therefore we cannot 
conclude a statistically significant difference in how rural students performed 
moving from regular to regular+aid class size compared to nonrural students.*/

********************************************************************************
**                                   P6                                       **
********************************************************************************
//Collapse mean test scores around each classroom//
preserve

collapse tcombssk treadssk tmathssk smallclass1 smallclass2, by(classid)

//comparing reading score differences between our previous t-test with the new, more conservative t-test clustered by classid. 
ttesti 1739 440.5474 32.49738 2006 434.7323 30.9359, unequal
ttest treadssk, by(smallclass1)

//comparing math score differences between our previous t-test with the new, more conservative t-test clustered by classid. 
ttesti 1762 490.9313 49.51013 2032 483.1993 47.63593, unequal
ttest tmathssk, by(smallclass1)

restore

********************************************************************************
**                                   P7                                       **
********************************************************************************
//Calculating test gaps by various demographic characteristics//
ttest tcombssk, by(smallclass1) unequal
ttest tcombssk, by(blackwhite) unequal
ttest tcombssk, by(ssex) unequal
ttest tcombssk, by(sesk) unequal
ttest tcombssk, by(ruralnonrural) unequal

