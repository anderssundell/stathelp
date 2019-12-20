
cd "/Users/xsunde/Dropbox/Jupyter/stathelp/data/GIS/"
shp2dta using "projections/mercator_world.shp", database(na_ids) coordinates(coord_mercator_world)

shp2dta using "projections/mercator_europe.shp", database(na_ids_europe) coordinates(coord_mercator_europe)

shp2dta using "projections/lambert_europe.shp", database(na_ids_leurope) coordinates(coord_lambert_europe)

shp2dta using "projections/mercator_na.shp", database(na_ids_na) coordinates(coord_mercator_na)

shp2dta using "projections/lambert_na.shp", database(na_ids_lna) coordinates(coord_lambert_na)

shp2dta using "projections/mercator_sa.shp", database(na_ids_sa) coordinates(coord_mercator_sa)

shp2dta using "projections/mercator_asia.shp", database(na_ids_asia) coordinates(coord_mercator_asia)

shp2dta using "projections/mercator_afr.shp", database(na_ids_afr) coordinates(coord_mercator_afr)


* TEST THE MAPS
use "../qog_bas_cs_jan18.dta", clear

merge 1:m ccode using "na_ids.dta", nogenerate
ren na_id na_id_world

merge 1:1 SOVEREIGNT ADMIN using "na_ids_europe.dta", nogenerate
drop ID
ren _ID na_id_europe

merge 1:1 SOVEREIGNT ADMIN using "na_ids_leurope.dta", nogenerate
drop ID
ren _ID na_id_leurope

merge 1:1 SOVEREIGNT ADMIN using "na_ids_na.dta", nogenerate
drop ID
ren _ID na_id_na

merge 1:1 SOVEREIGNT ADMIN using "na_ids_lna.dta", nogenerate
drop ID
ren _ID na_id_lna

merge 1:1 SOVEREIGNT ADMIN using "na_ids_sa.dta", nogenerate
drop ID
ren _ID na_id_sa

merge 1:1 SOVEREIGNT ADMIN using "na_ids_asia.dta", nogenerate
drop ID
ren _ID na_id_asia


spmap ti_cpi using "coord_mercator_world.dta", id(na_id_world) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "testmap_world.pdf", replace

spmap ti_cpi using "coord_mercator_europe.dta", id(na_id_world) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "testmap_europe.pdf", replace

spmap ti_cpi using "coord_lambert_europe.dta", id(na_id_world) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "testmap_leurope.pdf", replace

spmap ti_cpi using "coord_mercator_na.dta", id(na_id_na) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "mercator_na.pdf", replace

spmap ti_cpi using "coord_lambert_na.dta", id(na_id_lna) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "lambert_na.pdf", replace

spmap ti_cpi using "coord_mercator_sa.dta", id(na_id_sa) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "testmap_sa.pdf", replace

spmap ti_cpi using "coord_mercator_asia.dta", id(na_id_asia) fcolor(RdYlGn) osize(vvthin vvthin vvthin vvthin) ndsize(vvthin)
graph export "mercator_asia.pdf", replace



* ASSIGN COMMON ID TO ALL MAPS

use "../qog_bas_cs_jan18.dta", clear

merge 1:m ccode using "idfile.dta", nogenerate
ren na_id na_id_world

keep ccode cname SOVEREIGNT ADMIN na_id_world
save "idfile.dta", replace

use "idfile.dta", clear
merge 1:1 SOVEREIGNT ADMIN using "na_ids_europe.dta", nogenerate
drop ID
ren _ID na_id_europe

merge 1:1 SOVEREIGNT ADMIN using "na_ids_leurope.dta", nogenerate
drop ID
ren _ID na_id_leurope

merge 1:1 SOVEREIGNT ADMIN using "na_ids_na.dta", nogenerate
drop ID
ren _ID na_id_na

merge 1:1 SOVEREIGNT ADMIN using "na_ids_lna.dta", nogenerate
drop ID
ren _ID na_id_lna

merge 1:1 SOVEREIGNT ADMIN using "na_ids_sa.dta", nogenerate
drop ID
ren _ID na_id_sa

merge 1:1 SOVEREIGNT ADMIN using "na_ids_asia.dta", nogenerate
drop ID
ren _ID na_id_asia

merge 1:1 SOVEREIGNT ADMIN using "na_ids_afr.dta", nogenerate
drop ID
ren _ID na_id_afr

save "idfile.dta", replace



* NOW CHANGE THE COORDINATE FILES
use "idfile.dta", clear
drop if na_id_afr==.
save "idfile_afr.dta", replace

use "coord_mercator_afr.dta", clear
gen na_id_afr = _ID
merge m:1 na_id_afr using "idfile_afr.dta", keep(match master) nogenerate keepusing(na_id_world)
replace _ID = na_id_world
drop na_id_afr na_id_world
sort _ID
save "coord_mercator_afr.dta", replace
