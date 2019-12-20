* TEST THE MAPS
cd "/Users/xsunde/Dropbox/Jupyter/stathelp/data/GIS/"
use "qog_bas_cs_jan18.dta", clear

merge 1:m ccode using "idfile.dta", nogenerate

spmap wdi_lifexp using "coord_mercator_world.dta", id(na_id_world) fcolor(RdYlGn)
graph export "../../images/map1_world.png", replace

spmap wdi_lifexp using "coord_mercator_world.dta", id(na_id_world) fcolor(RdYlGn) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) clmethod(custom) clbreaks(50 60 70 80 90) ///
title("Life expectancy at birth")
graph export "../../images/map2_world.png", replace


spmap ti_cpi using "coord_lambert_europe.dta", id(na_id_world) fcolor(RdYlGn) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gray) ///
title("Corruption Perceptions Index")
graph export "../../images/map3_world.png", replace

spmap p_polity2 using "coord_mercator_afr.dta", id(na_id_world) fcolor(PuBuGn) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gray) ///
title("Polity index")
graph export "../../images/map4_world.png", replace

spmap p_polity2 using "coord_mercator_world.dta" if ht_region==3 | ht_region==4, id(na_id_world) fcolor(PuBuGn) ///
osize(vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gray) ///
title("Polity index")
graph export "../../images/map5_world.png", replace



use "qog_bas_ts_jan19.dta", clear
merge m:m ccode using "idfile.dta", nogenerate
  
spmap p_polity2 using "coord_mercator_world.dta" if year==1969, id(na_id_world) fcolor(RdYlGn) clmethod(custom) clbreaks(-10 -7 -2 2 7 10) ///
osize(vvthin vvthin vvthin vvthin vvthin) ndsize(vvthin) ndfcolor(gray) ///
title("Polity index")
