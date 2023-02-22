global base "E:\base_escuelas"
global input "${base}\input"
global result "${base}\result"
global do "${base}\Do"

cd "${base}"
*recurso: https://www.datosabiertos.gob.pe/search/field_tags/osiptel-921/type/dataset?query=osiptel&sort_by=changed&sort_order=DESC&page=0%2C1

import excel "${input}\COBERTURA DE SERVICIO MOVIL POR EMPRESA OPERADORA.xlsx", sheet("Cobertura Movil") firstrow clear
*import excel "${input}\CANTIDAD DE ESTACIONES BASE POR TECNOLOGIA.xlsx", sheet("Estaciones Base") firstrow clear

gen NU=substr(Ubigeo, 1, 6)

rename G V_2G
rename K V_3G
rename L V_4G
rename M V_5G

tab V_2G
tab V_3G
tab V_4G
tab V_5G // solo existen datos en lima y callao

replace V_2G=1 if V_2G==1
replace V_3G=2 if V_3G==1
replace V_4G=3 if V_4G==1
replace V_5G=4 if V_5G==1

egen Ind_velocidad=rowtotal(V_2G V_3G V_4G V_5G)

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

collapse (sum) Ind_velocidad , by(NU Región Provincia Distrito)
rename NU Ubigeo

save "${result}\Cobertura", replace
