
/*
use "${result}\Ubigeo",clear
use "${result}\Cobertura",clear
use "${result}\Alerta_escuela",clear
*/

use "${result}\Alerta_escuela",clear

*Coincidencia ubigeo pais y dre/ugel
merge m:1 Región Provincia Distrito Ubigeo using "${result}\Ubigeo"

sort Región _merge Provincia Distrito

br if _merge<3 //revision de las no coincidencia
rename _merge _merge1
*Coincidencia dre/ugel Conectividad
merge m:1 Región Provincia Distrito Ubigeo using "${result}\Cobertura"

sort Región _merge Provincia Distrito
br if _merge<3 //revision de las no coincidencia

save "${result}\base_escuela_vf", replace

export excel using "${result}\base_escuela_vf.xlsx",  sheet("base escuela")sheetreplace firstrow(varlabels)
