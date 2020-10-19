use "https://www.qogdata.pol.gu.se/dataarchive/qog_bas_ts_jan18.dta", clear

keep if cname=="Sweden" | cname=="United States"
keep if wdi_elerenew<. & wdi_wip<.


egen mean_energy = mean(wdi_elerenew), by(cname)
egen mean_women = mean(wdi_wip), by(cname)

gen demean_energy = wdi_elerenew-mean_energy
gen demean_women = wdi_wip-mean_women

twoway (line demean_energy year) if cname=="Sweden"


reg wdi_elerenew wdi_wip if cname=="Sweden"
reg demean_energy demean_women if cname=="Sweden"

xtreg wdi_elerenew wdi_wip, fe
reg demean_energy demean_women

twoway (scatter demean_energy demean_women) (lfit demean_energy demean_women)

reg demean_energy demean_women if cname=="Sweden"

reg wdi_elerenew wdi_wip i.ccode
reg demean_energy demean_women
xtreg wdi_elerenew wdi_wip, fe


reg wdi_elerenew wdi_wip i.ccode


predict energyres, r

reg wdi_wip i.ccode
predict womenres, r

reg energyres womenres




reg wdi_elerenew wdi_wip i.ccode
predict fehat

reg demean_energy demean_women i.ccode
predict demean_fe_hat

twoway (scatter demean_energy demean_women) (scatter demean_fe_hat demean_women)
