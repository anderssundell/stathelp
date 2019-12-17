

* ssc install spmap

cd "/Users/xsunde/Dropbox/Jupyter/stathelp/data/"
insheet using "population2018.csv", clear names delimiter(";")

merge 1:1 municipality_code using "spmapid.dta", nogenerate

spmap pop2018 using "swecoord_normal.dta", id(spmapid_swemap_normal)
spmap pop2018 using "swecoord_cutouts.dta", id(spmapid_swemap_cutouts)

spmap pop2018 using "swecoord.dta", id(id_swe_normalmap) fcolor(Blues) clbreaks(0 50000 2000000) clmethod(custom)
