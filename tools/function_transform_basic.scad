// function_transform_basic.scad
//
// Enthält übertragene Funktionen von OpenSCAD-Modulen
// zum Transformieren von Punktlisten


// jeden Punkt in der Liste <list> um <v> verschieben
// funktioniert wie translate()
//  list = Punkt-Liste
//  v    = Vektor
function translate_list (list, v) =
	let ( vector = !is_undef(v) ? v : [0,0,0] )
	[for (e=list) e+vector]
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

// jeden Punkt in der Liste <list> entlang dem Vektor <v> spiegeln am Koordinatenursprung
// funktioniert wie mirror()
//  list = Punkt-Liste
//  v    = Vektor, in dieser Richtung wird gespiegelt
function mirror_list (list, v) =
	(!is_list(list) || !is_list(list[0])) ? undef
	:len(list[0])==3 ? mirror_list_3d (list, v)
	:len(list[0])==2 ? mirror_list_2d (list, v)
	:len(list[0])==1 ? -list
	:undef
	
;
function mirror_list_2d (list, v) =
	let (
		v_std = [1,0],
		V = (is_list(v) && len(v)>=2) ? v : v_std,
		angle = atan2(V[1],V[0]) 
	)
	rotate_z_list(
	[ for (e=rotate_backwards_z_list(list, angle)) [-e[0],e[1]] ]
	, angle)
;
function mirror_list_3d (list, v) =
	let (
		v_std = [1,0,0],
		V = is_list(v) ? len(v)==3 ? v : len(v)==2 ? [v[0],v[1],0] : v_std : v_std,
		a = atan2(V[1],V[0])
	)
	rotate_to_vector_list(
	[ for (e=rotate_backwards_to_vector_list(list, V,a)) [e[0],e[1],-e[2]] ]
	, V,a)
;

// jeden Punkt in der Liste <list> an der jeweiligen Achse vergrößern
// funktioniert wie scale()
//  list = Punkt-Liste
//  v    = Vektor mit den Vergrößerungsfaktoren
function scale_list (list, v) =
	(!is_list(v) || len(v)==0) ? list :
	let ( 
		last = len(list[0])-1,
		V    = [ for (i=[0:last]) (len(v)>i) ? (v[i]!=0 && is_num(v[i])) ? v[i] : 1 : 1 ]
	)
	[ for (e=list)
		[ for (i=[0:last])
			e[i] * V[i]
		]
	]
;

// jeden Punkt in der Liste <list> auf die xy-Ebene projizieren
//  list  = Punkt-Liste
//  cut   = nur den Umriss nehmen, der durch die xy-Ebene geht
//          TODO nicht implementiert
//  plane = true  = eine 2D-Liste machen - Standart
//          false = 3D-Liste behalten, alle Punkte auf xy-Ebene
function projection_list (list, cut=false, plane) =
	let (Plane=is_bool(plane) ? plane : true)
	//
	Plane==true ? [ for (e=list) [e[0],e[1]]   ]
	:             [ for (e=list) [e[0],e[1],0] ]
;

