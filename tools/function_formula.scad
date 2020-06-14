// function_formula.scad
//
// Enthält Formeln zum Berechnen von Kreisen, ...


// Radius eines Kreises berechnen
// benötigt je 2 Parameter:
//   chord    = Kreissehne
//   sagitta  = Segmenthöhe
//   angle    = Mittelpunktswinkel
function get_radius_from (chord, sagitta, angle) =
	let (c=chord, s=sagitta, a=angle)
	 is_num(c)&&is_num(s) ? 1/2 * (s + sqr(c/2)/s)
	:is_num(a)&&is_num(s) ? s/2 / sin(a/2)
	:is_num(a)&&is_num(c) ? s / (1 - cos(a/2))
	:"too low parameter"
;
