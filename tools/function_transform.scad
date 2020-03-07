// function_transform.scad
//
// Enthält Funktionen zum Bearbeiten von Punktlisten


// jeden Punkt in der Liste <list> um <vector> verschieben
// funktioniert wie translate()
function translate_list (list, vector) =
	[for (e=list) e+v]
;

/*
function rotate_list (list, a, v) =
	[for (e=list) e+v]
;
*/

