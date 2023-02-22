global base "E:\base_escuelas"
global input "${base}\input"
global result "${base}\result"
global do "${base}\Do"

macro dir
cd "${base}"

*Recurso: https://webapp.inei.gob.pe:8443/sisconcode/main.htm#

import excel "${input}\rptUbigeo.xls", sheet("ubicacionGeografica") cellrange(B2:F2196) firstrow clear

drop C D

drop if DISTRITO=="" | DISTRITO==" "

drop if DISTRITO=="DISTRITO"

*cantidad de distrito
tab DEPARTAMENTO
*split Region , generate(t) p(" ") limit(2) // Con limit se crea dos variables pero corta los nombres de las regiones

local Ubigeo "DEPARTAMENTO PROVINCIA DISTRITO"
foreach x of local Ubigeo {
  split `x' , generate(t_`x') p(" ")
rename t_`x'1 NU_`x'
egen U_`x' = concat(t*), punct(" ")
drop t* `x'
        }

egen Ubigeo = concat(NU*)
drop NU*
rename U_DEPARTAMENTO Región
rename U_PROVINCIA Provincia
rename U_DISTRITO Distrito

tab Región
tab Provincia

local Ubigeo "Región Provincia Distrito"
foreach x of local Ubigeo {
replace `x' = upper(`x')
replace `x' = subinstr(`x', "Á", "A",.)
replace `x' = subinstr(`x', "É", "E",.)
replace `x' = subinstr(`x', "Í", "I",.)
replace `x' = subinstr(`x', "Ó", "O",.)
replace `x' = subinstr(`x', "Ú", "U",.)
replace `x' = subinstr(`x', "  ", " ",.)
replace `x' = subinstr(`x', "á", "a",.)
replace `x' = subinstr(`x', "à", "a",.)
replace `x' = subinstr(`x', "é", "e",.)
replace `x' = subinstr(`x', "í", "i",.)
replace `x' = subinstr(`x', "ó", "o",.)
replace `x' = subinstr(`x', "ò", "o",.)
replace `x' = subinstr(`x', "ú", "u",.)
replace `x' = subinstr(`x', "ñ", "Ñ",.)
replace `x' = subinstr(`x', "ü", "Ü",.)
replace `x' = upper(`x')
replace `x' = trim(`x')
replace `x' = ltrim(`x') 
}

replace Provincia="CALLAO" if Provincia=="PROV. CONST. DEL CALLAO" & Región=="CALLAO"
replace Distrito="SAN FRANCISCO DE YESO" if Distrito=="SAN FRANCISCO DEL YESO"
replace Distrito="SAN PEDRO DE LARAOS" if Distrito=="LARAOS" & Provincia=="HUAROCHIRI" & Región=="LIMA"
replace Distrito="SANTA CRUZ DE TOLEDO" if Distrito=="SANTA CRUZ DE TOLED" & Provincia=="CONTUMAZA" & Región=="CAJAMARCA"
replace Distrito="HUALLA" if Distrito=="HUAYA" & Provincia=="VICTOR FAJARDO" & Región=="AYACUCHO"
replace Distrito="RAIMONDI" if Distrito=="RAYMONDI" & Provincia=="ATALAYA" & Región=="UCAYALI"

save "${result}\Ubigeo", replace

use "${result}\Ubigeo",clear
