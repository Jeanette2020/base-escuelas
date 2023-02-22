global base "E:\base_escuelas"
global input "${base}\input"
global result "${base}\result"
global do "${base}\Do"

cd "${base}"

import excel "${input}\data_bi_alerta_escuela.xlsx", sheet("data") firstrow clear
rename d_dpto Región
rename d_prov Provincia
rename d_dist Distrito
rename codgeo Ubigeo

tab Reg
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

save "${result}\Alerta_escuela", replace
