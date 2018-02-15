/*
This is the working file for 508c Problem Set 1

Last modified by: Chris Austin
Last modified on: 2/13/17

*/

clear all

*I. Setup

*Set director, dta file, etc.
cd "C:\Users\Chris\Documents\Princeton\WWS Spring 2018\WWS 508c\PS1/DTA"
use project_star_ps1.dta
set more off
set matsize 10000
capture log close
log using PS1.log, replace

*Download outreg2
ssc install outreg2
