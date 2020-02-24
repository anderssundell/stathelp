**** DOFIL FÖR ATT RANDOMISERA ENKÄTER ****

* Instruktioner
* Ange först antalet enkäter (surveys) och antalet versioner (versions).
* Kör sedan hela dofilen på en gång, inklusive delen quietly som innehåller
* koden för att göra randomiseringen.

clear
* Ange antal enkäter som ska delas ut - tex 50
global surveys = 50

* Ange antal olika versioner av enkäten.
* Antalet enkäter måste gå att dela jämnt med antalet versioner.
global versions = 2


quietly{
global surveyspergroup = $surveys/$versions

set obs $surveys
gen version = .

global obsnr = 1
forvalues vnr = 1/$versions {
	forvalues snr = 1/$surveyspergroup {
	replace version = `vnr' in $obsnr
	global obsnr = $obsnr+1
	}
}

gen randomnr = runiform()
sort randomnr
drop randomnr

egen surveyorder = fill(1 2 3)
move surveyorder version
}

list surveyorder version, clean

