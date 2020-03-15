// function_transform.scad
//
// Enthält Funktionen zum Bearbeiten von Punktlisten


// jeden Punkt in der Liste <list> um <vector> verschieben
// funktioniert wie translate()
function translate_list (list, vector) =
	[for (e=list) e+vector]
;

// jeden Punkt in der Liste <list> rotieren
// funktioniert wie rotate()
function rotate_list (list, a, v) =
	 is_list(a) ?
		rotate_z_list( rotate_y_list( rotate_x_list( list, a[0]), a[1]), a[2])
	:is_num(a)  ?
		is_list(v) ?
			rotate_vector_list(list, a, v)
		:	rotate_z_list     (list, a)
	:list
;

// jeden Punkt in der Liste <list> um die X-Achse um <angle> drehen
function rotate_x_list (list, angle) =
	!is_num(angle) ? list :
	[for (e=list)
		[
		 e[0]
		,e[1]*cos(angle) - e[2]*sin(angle)
		,e[1]*sin(angle) + e[2]*cos(angle)
		]
	]
;
// jeden Punkt in der Liste <list> um die Y-Achse um <angle> drehen
function rotate_y_list (list, angle) =
	!is_num(angle) ? list :
	[for (e=list)
		[
		  e[0]*cos(angle) + e[2]*sin(angle)
		, e[1]
		,-e[0]*sin(angle) + e[2]*cos(angle)
		]
	]
;
// jeden Punkt in der Liste <list> um die Z-Achse um <angle> drehen
// auch für 2D-Listen
function rotate_z_list (list, angle) =
	!is_num(angle) ? list :
	[for (e=list)
		concat(
			 e[0]*cos(angle) - e[1]*sin(angle)
			,e[0]*sin(angle) + e[1]*cos(angle)
			,(e[2]!=undef) ? e[2] : []
		)
	]
;
// jeden Punkt in der Liste <list> um einen Vektor <vector> herum um <angle> drehen
function rotate_vector_list (list, angle, vector) =
	 !is_num (angle)  ? list
	:!is_list(vector) ? list
	:
	let (u=unit_vector(vector), cosa=cos(-angle), sina=sin(-angle), x=u[0],y=u[1],z=u[2])
	[ for (e=list)
		e * [
		 [ x*x*(1-cosa)+  cosa, x*y*(1-cosa)-z*sina, x*z*(1-cosa)+y*sina ],
		 [ y*x*(1-cosa)+z*sina, y*y*(1-cosa)+  cosa, y*z*(1-cosa)-x*sina ],
		 [ z*x*(1-cosa)-y*sina, z*y*(1-cosa)+x*sina, z*z*(1-cosa)+  cosa ]
		]
	]
;

// jeden Punkt in der Liste <list> rückwärts rotieren
// funktioniert wie rotate_backwards()
function rotate_backwards_list (list, a, v) =
	 is_list(a) ?
		rotate_x_list( rotate_y_list( rotate_z_list( list, -a[2]), -a[1]), -a[0])
	:is_num(a)  ?
		is_list(v) ?
			rotate_vector_list(list, -a, v)
		:	rotate_z_list     (list, -a)
	:list
;

// jeden Punkt in der Liste <list> rotieren an der angegebenen Position p
// funktioniert wie rotate_at()
function rotate_at_list (list, a, p=[0,0,0], v) =
	translate_list( rotate_list( translate_list( list, -p), a, v), p)
;
// jeden Punkt in der Liste <list> rückwärts rotieren an der angegebenen Position p
// funktioniert wie rotate_at()
function rotate_backwards_at_list (list, a, p=[0,0,0], v) =
	translate_list( rotate_backwards_list( translate_list( list, -p), a, v), p)
;

// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v drehen
// funktioniert wie rotate_to_vector()
function rotate_to_vector_list (list, v=[0,0,1], angle=0) =
	let(
	b = acos(v[2]/norm(v)), // inclination angle
	c = atan2(v[1],v[0])    // azimuthal angle
	)
	rotate_list( rotate_z_list( list, angle), [0, b, c])
;
// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
function rotate_backwards_to_vector_list (list, v=[0,0,1], angle=0) =
	let(
	b = acos(v[2]/norm(v)), // inclination angle
	c = atan2(v[1],v[0])    // azimuthal angle
	)
	
	rotate_backwards_z_list( rotate_backwards_list( list, [0, b, c]), angle)
;

// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v
// drehen an der angegebenen Position
function rotate_to_vector_at_list (list, v=[0,0,1], p=[0,0,0], angle=0) =
	translate_list( rotate_to_vector_list( translate_list( list, -p), v, angle), p)
;
// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v
// rückwärts drehen an der angegebenen Position
function rotate_backwards_to_vector_at_list (list, v=[0,0,1], p=[0,0,0], angle=0) =
	translate_list( rotate_backwards_to_vector_list( translate_list( list, -p), v, angle), p)
;


// rotiert um die jeweilige Achse wie die Hauptfunktion
function rotate_backwards_x_list (list, x) = rotate_backwards_list(list, [x,0,0]);
function rotate_backwards_y_list (list, y) = rotate_backwards_list(list, [0,y,0]);
function rotate_backwards_z_list (list, z) = rotate_backwards_list(list, [0,0,z]);
//
function rotate_at_x_list (list, x, p=[0,0,0]) = rotate_at_list(list, [x,0,0], p);
function rotate_at_y_list (list, y, p=[0,0,0]) = rotate_at_list(list, [0,y,0], p);
function rotate_at_z_list (list, z, p=[0,0,0]) = rotate_at_list(list, [0,0,z], p);
//
function rotate_backwards_at_x_list (list, x, p=[0,0,0]) = rotate_backwards_at_list(list, [x,0,0], p);
function rotate_backwards_at_y_list (list, y, p=[0,0,0]) = rotate_backwards_at_list(list, [0,y,0], p);
function rotate_backwards_at_z_list (list, z, p=[0,0,0]) = rotate_backwards_at_list(list, [0,0,z], p);
//
// verschiebt in der jeweiligen Achse wie die Hauptfunktion
function translate_x_list (list, x) = translate_list(list, [x,0,0]);
function translate_y_list (list, y) = translate_list(list, [0,y,0]);
function translate_z_list (list, z) = translate_list(list, [0,0,z]);
function translate_xy_list (list, t) = translate_list(list, [t[0],t[1],0]);

