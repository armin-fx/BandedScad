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
		V =
			!is_list(v) ? v_std
			:len(v)==3 ? v
			:len(v)==2 ? [v[0],v[1],0]
			:v_std,
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
		scale_factor = [ for (i=[0:last]) (len(v)>i && v[i]!=0 && is_num(v[i])) ? v[i] : 1 ]
	)
	[ for (e=list)
		[ for (i=[0:last])
			e[i] * scale_factor[i]
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
	get_bounding_box_list_intern(list, list[0], list[0], 1, len(list))
;
function get_bounding_box_list_intern (list, min_pos, max_pos, i=0, n=0) =
	(i>=n) ? [ max_pos - min_pos, min_pos, max_pos ] :
	get_bounding_box_list_intern (list
		,min_pos = [ for (j=[0:len(list[i])-1]) min (list[i][j], min_pos[j]) ]
		,max_pos = [ for (j=[0:len(list[i])-1]) max (list[i][j], max_pos[j]) ]
		,i=i+1, n=n
	)
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

