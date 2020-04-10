// function_transform_basic.scad
//
// Enthält übertragene Funktionen von OpenSCAD-Modulen
// zum Transformieren von Punktlisten


// jeden Punkt in der Liste <list> um <v> verschieben
// funktioniert wie translate()
//  list = Punkt-Liste
//  v    = Vektor
function translate_list (list, v) =
	let ( vector = is_list(v) ? v : [0,0,0] )
	[for (p=list) p+vector]
;

// jeden Punkt in der Liste <list> rotieren
// funktioniert wie rotate()
//  list = Punkt-Liste
//  a    = Winkel (a)
//  v    = Vektor
function rotate_list (list, a, v) =
	 is_list(a) ?
		multmatrix_list (list,
			matrix_rotate_z(a[2], d=3) *
			matrix_rotate_y(a[1], d=3) *
			matrix_rotate_x(a[0], d=3)
		)
	:is_num(a)  ?
		is_list(v) ?
			rotate_v_list(list, a, v)
		:	rotate_z_list(list, a)
	:list
;

// jeden Punkt in der Liste <list> um die X-Achse um <a> drehen
function rotate_x_list (list, a) =
	!is_num(a) ? list :
	let (
		sina  = sin(a),
		cosa  = cos(a)
	)
	[for (p=list)
		[
		 p[0]
		,p[1]*cosa - p[2]*sina
		,p[1]*sina + p[2]*cosa
		]
	]
;
// jeden Punkt in der Liste <list> um die Y-Achse um <a> drehen
function rotate_y_list (list, a) =
	!is_num(a) ? list :
	let (
		sina  = sin(a),
		cosa  = cos(a)
	)
	[for (p=list)
		[
		  p[0]*cosa + p[2]*sina
		, p[1]
		,-p[0]*sina + p[2]*cosa
		]
	]
;
// jeden Punkt in der Liste <list> um die Z-Achse um <a> drehen
// auch für 2D-Listen
function rotate_z_list (list, a) =
	!is_num(a) ? list :
	let (
		sina  = sin(a),
		cosa  = cos(a)
	)
	[for (p=list)
		(p[2]==undef) ?
		[
			 p[0]*cosa - p[1]*sina
			,p[0]*sina + p[1]*cosa
		] : [
			 p[0]*cosa - p[1]*sina
			,p[0]*sina + p[1]*cosa
			,p[2]
		]
	]
;// jeden Punkt in der Liste <list> um einen Vektor <v> herum um <a> drehen
function rotate_v_list (list, a, v) =
	 !is_num (a) ? list
	:!is_list(v) ? list
	:
	let (
		u=unit_vector(v),
		x=u[0], y=u[1], z=u[2],
		sina=sin(-a),
		cosa=cos(-a),
		matrix=
		[
			[ x*x*(1-cosa)+  cosa, x*y*(1-cosa)-z*sina, x*z*(1-cosa)+y*sina ],
			[ y*x*(1-cosa)+z*sina, y*y*(1-cosa)+  cosa, y*z*(1-cosa)-x*sina ],
			[ z*x*(1-cosa)-y*sina, z*y*(1-cosa)+x*sina, z*z*(1-cosa)+  cosa ]
		]
	)
	[ for (p=list)
		p * matrix
	]
;

// jeden Punkt in der Liste <list> entlang dem Vektor <v> spiegeln am Koordinatenursprung
// funktioniert wie mirror()
//  list = Punkt-Liste
//  v    = Vektor, in dieser Richtung wird gespiegelt
function mirror_list (list, v) =
	(!is_list(list) || !is_list(list[0])) ? undef
	:len(list[0])==3 ? multmatrix_list (list, matrix_mirror_3d (v))
	:len(list[0])==2 ? multmatrix_list (list, matrix_mirror_2d (v))
	:len(list[0])==1 ? -list
	:undef
	
;
function mirror_2d_list (list, v) =
	let (
		V = parameter_mirror_vector_2d(v),
		angle = atan2(V[1],V[0])
	)
	rotate_z_list(
	[ for (p=rotate_backwards_z_list(list, angle)) [-p[0],p[1]] ]
	, angle)
;
function mirror_3d_list (list, v) =
	let (
		V = parameter_mirror_vector_3d(v),
		angle = atan2(V[1],V[0])
	)
	rotate_to_vector_list(
	[ for (p=rotate_backwards_to_vector_list(list, V,angle)) [p[0],p[1],-p[2]] ]
	, V,angle)
;

// jeden Punkt in der Liste <list> an der jeweiligen Achse vergrößern
// funktioniert wie scale()
//  list = Punkt-Liste
//  v    = Vektor mit den Vergrößerungsfaktoren
function scale_list (list, v) =
	(!is_list(list) || !is_list(list[0])) ? undef :
	(!is_list(v) || len(v)==0) ? list :
	let (
		last = len(list[0])-1,
		scale_factor = [ for (i=[0:last]) (len(v)>i && v[i]!=0 && is_num(v[i])) ? v[i] : 1 ]
	)
	[ for (p=list)
		[ for (i=[0:last])
			p[i] * scale_factor[i]
		]
	]
;

// jeden Punkt in der Liste <list> an der jeweiligen Achse in die neue Größe einpassen
// funktioniert wie resize()
//  list    = Punkt-Liste
//  newsize = Vektor mit den neuen Maßen
function resize_list (list, newsize) =
	let (
		bounding_box = get_bounding_box_list(list) [0],
		scale_factor =
		[ for (i=[0:len(bounding_box)-1])
			(is_num(newsize[i]) && newsize[i]!=0 && bounding_box[i]>0) ?
				newsize[i] / bounding_box[i]
				: 1
		]
	)
	scale_list (list, scale_factor)
;

// gibt die Größe der umschließenden Box der Punkt-Liste zurück
// Rückgabe:  [ [size], [min_pos], [max_pos] ]
//   - size    = Größe der umschließenden Box
//   - min_pos = Punkt am Beginn der Box
//   - max_pos = Punkt am Ende der Box
function get_bounding_box_list (list) =
	(!is_list(list) || len(list)==0) ? [[0,0,0],[0,0,0]] :
	let (
		min_pos = [ for (i=[ 0:len(list[0])-1 ]) min ([for(e=list) e[i]]) ],
		max_pos = [ for (i=[ 0:len(list[0])-1 ]) max ([for(e=list) e[i]]) ]
	)
	[ max_pos - min_pos, min_pos, max_pos ]
;


// jeden Punkt in der Liste <list> auf die xy-Ebene projizieren
//  list  = Punkt-Liste
//  cut   = nur den Umriss nehmen, der durch die xy-Ebene geht
//          TODO nicht implementiert
//  plane = true  = eine 2D-Liste machen - Standart
//          false = 3D-Liste behalten, alle Punkte auf xy-Ebene
function projection_list (list, plane) =
	let (Plane=is_bool(plane) ? plane : true)
	//
	Plane==true ? [ for (p=list) [p[0],p[1]]   ]
	:             [ for (p=list) [p[0],p[1],0] ]
;

// jeden Punkt in der Liste <list> mit der Matrix <m> multiplizieren
// funktioniert wie multmatrix()
//  list = Punkt-Liste
//  m    = 4x3 oder 4x4 Matrix
function multmatrix_list (list, m) =
	(!is_list(list) || !is_list(list[0])) ? undef :
	(!is_list(m)) ? list :
	 (len(list[0]) == 3) ? multmatrix_3d_list (list, m)
	:(len(list[0]) == 2) ? multmatrix_2d_list (list, m)
	:undef
;

function multmatrix_2d_list (list, m) =
	let (M = repair_matrix_2d(m))
	[ for (p=list)
		let (
			a = [ p[0],p[1], 1 ],
			c = M * a,
			p_new = [ c[0],c[1] ]
		)
		p_new
	]
;
function multmatrix_3d_list (list, m) =
	let (M = repair_matrix_3d(m))
	[ for (p=list)
		let (
			//a = [ p[0],p[1],p[2], 1 ],
			a = concat (p, 1),
			c = M * a,
			p_new = [ c[0],c[1],c[2] ]
		)
		p_new
	]
;

