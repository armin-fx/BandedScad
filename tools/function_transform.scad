// function_transform.scad
//
// Enthält Funktionen zum Bearbeiten von Punktlisten


// jeden Punkt in der Liste <list> um <vector> verschieben
// funktioniert wie translate()
function translate_list (list, vector) =
	[for (e=list) e+vector]
;

// jeden Punkt in der Liste <list> um die Z-Achse um <angle> drehen
function rotate_z_list (list, angle=0) =
	[for (e=list)
		concat(
			[e[0],e[1]] *
				[[cos(angle), -sin(angle)]
				,[sin(angle),  cos(angle)]]
			,(e[2]!=undef) ? e[2] : []
		)
	]
;

/*
function rotate_list (list, a, v) =
	[for (e=list) e+v]
;
*/

