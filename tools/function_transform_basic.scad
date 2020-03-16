// function_transform_basic.scad
//
// Enthält übertragene Funktionen von OpenSCAD-Modulen
// zum Transformieren von Punktlisten


// jeden Punkt in der Liste <list> um <v> verschieben
// funktioniert wie translate()
//  list = Punkt-Liste
//  v    = Vektor
function translate_list (list, v) =
	[for (e=list) e+v]
;

// jeden Punkt in der Liste <list> rotieren
// funktioniert wie rotate()
//  list = Punkt-Liste
//  a    = Winkel (a)
//  v    = Vektor
function rotate_list (list, a, v) =
	 is_list(a) ?
		rotate_z_list( rotate_y_list( rotate_x_list( list, a[0]), a[1]), a[2])
	:is_num(a)  ?
		is_list(v) ?
			rotate_vector_list(list, a, v)
		:	rotate_z_list     (list, a)
	:list
;

// jeden Punkt in der Liste <list> um die X-Achse um <a> drehen
function rotate_x_list (list, a) =
	!is_num(a) ? list :
	[for (e=list)
		[
		 e[0]
		,e[1]*cos(a) - e[2]*sin(a)
		,e[1]*sin(a) + e[2]*cos(a)
		]
	]
;
// jeden Punkt in der Liste <list> um die Y-Achse um <a> drehen
function rotate_y_list (list, a) =
	!is_num(a) ? list :
	[for (e=list)
		[
		  e[0]*cos(a) + e[2]*sin(a)
		, e[1]
		,-e[0]*sin(a) + e[2]*cos(a)
		]
	]
;
// jeden Punkt in der Liste <list> um die Z-Achse um <a> drehen
// auch für 2D-Listen
function rotate_z_list (list, a) =
	!is_num(a) ? list :
	[for (e=list)
		concat(
			 e[0]*cos(a) - e[1]*sin(a)
			,e[0]*sin(a) + e[1]*cos(a)
			,(e[2]!=undef) ? e[2] : []
		)
	]
;
// jeden Punkt in der Liste <list> um einen Vektor <v> herum um <a> drehen
function rotate_vector_list (list, a, v) =
	 !is_num (a) ? list
	:!is_list(v) ? list
	:
	let (u=unit_vector(v), cosa=cos(-a), sina=sin(-a), x=u[0],y=u[1],z=u[2])
	[ for (e=list)
		e * [
		 [ x*x*(1-cosa)+  cosa, x*y*(1-cosa)-z*sina, x*z*(1-cosa)+y*sina ],
		 [ y*x*(1-cosa)+z*sina, y*y*(1-cosa)+  cosa, y*z*(1-cosa)-x*sina ],
		 [ z*x*(1-cosa)-y*sina, z*y*(1-cosa)+x*sina, z*z*(1-cosa)+  cosa ]
		]
	]
;

