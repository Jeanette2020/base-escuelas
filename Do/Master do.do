*Guia de do 

global base "E:\base_escuelas"
global input "${base}\input"
global result "${base}\result"
global do "${base}\Do"

*Obtencion de: Ubigeo Region Provincia Distrito 

do "${do}\Ubigeo"
//base resultado: use "${result}\Ubigeo",clear
do "${do}\Cobertura"
//base resultado: use "${result}\Cobertura",clear
do "${do}\alerta_escuela"
//base resultado: use "${result}\Alerta_escuela",clear

*Base unificada
do "${do}\Match_bases"
//base resultado: use "${result}\base_escuela_vf",clear

*Base en formato excel
// base_escuela_vf.xlsx
