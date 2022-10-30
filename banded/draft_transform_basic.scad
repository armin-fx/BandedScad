// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält übertragene Funktionen von OpenSCAD-Modulen
// zum Transformieren von Punktlisten

use <banded/helper_recondition.scad>
use <banded/math_vector.scad>
use <banded/draft_transform_common.scad>
use <banded/draft_matrix_basic.scad>

// jeden Punkt in der Liste <list> um <v> verschieben
// funktioniert wie translate()
//  list = Punkt-Liste
//  v    = Vektor
function translate_points (list, v) =
	(v==undef || !is_list(v)) ? list :
	(v==[0,0] || v==[0,0,0])  ? list :
	[for (p=list) p+v]
;
function translate_point (p, v) =
	p+v
;

// jeden Punkt in der Liste <list> rotieren
// funktioniert wie rotate()
//  list = Punkt-Liste
//  a    = Winkel (a)
//  v    = Vektor
//  backwards = 'false' - Standard, vorwärts rotieren
//              'true'  - rückwärts rotieren, macht Rotation rückgängig
function rotate_points (list, a, v, backwards=false) =
	! (backwards==true) ?
		// forward
		is_list(a) ?
			multmatrix_points (list,
				matrix_rotate_z(a.z, d=3, short=true) *
				matrix_rotate_y(a.y, d=3, short=true) *
				matrix_rotate_x(a.x, d=3, short=true)
			)
		:is_num(a)  ?
			(v!=undef && is_list(v)) ?
				rotate_v_points(list, a, v)
			:	rotate_z_points(list, a)
		:list
	:
		// backwards
		is_list(a) ?
			multmatrix_points (list,
				matrix_rotate_x(-a.x, d=3, short=true) *
				matrix_rotate_y(-a.y, d=3, short=true) *
				matrix_rotate_z(-a.z, d=3, short=true)
			)
		:is_num(a)  ?
			(v!=undef && is_list(v)) ?
				rotate_v_points(list, -a, v)
			:	rotate_z_points(list, -a)
		:list
;
function rotate_point (p, a, v, backwards=false) =
	! (backwards==true) ?
		// forward
		is_list(a) ?
			multmatrix_point (p,
				matrix_rotate_z(a.z, d=3, short=true) *
				matrix_rotate_y(a.y, d=3, short=true) *
				matrix_rotate_x(a.x, d=3, short=true)
			)
		:is_num(a)  ?
			(v!=undef && is_list(v)) ?
				rotate_v_point(p, a, v)
			:	rotate_z_point(p, a)
		:list
	:
		// backwards
		is_list(a) ?
			multmatrix_point (p,
				matrix_rotate_x(-a.x, d=3, short=true) *
				matrix_rotate_y(-a.y, d=3, short=true) *
				matrix_rotate_z(-a.z, d=3, short=true)
			)
		:is_num(a)  ?
			(v!=undef && is_list(v)) ?
				rotate_v_point(p, -a, v)
			:	rotate_z_point(p, -a)
		:list
;

// jeden Punkt in der Liste <list> um die X-Achse um <a> Grad drehen
function rotate_x_points (list, a, backwards=false) =
	(a==undef || !is_num(a)) ? list :
	let (
		A = !(backwards==true) ? a : -a,
		sina  = sin(A),
		cosa  = cos(A)
	)
	[for (p=list)
		[
		 p.x
		,p.y*cosa - p.z*sina
		,p.y*sina + p.z*cosa
		]
	]
;
function rotate_x_point (p, a, backwards=false) =
	(a==undef || !is_num(a)) ? p :
	let (
		A = !(backwards==true) ? a : -a,
		sina  = sin(A),
		cosa  = cos(A)
	)
	[
	 p.x
	,p.y*cosa - p.z*sina
	,p.y*sina + p.z*cosa
	]
;
// jeden Punkt in der Liste <list> um die Y-Achse um <a> Grad drehen
function rotate_y_points (list, a, backwards=false) =
	(a==undef || !is_num(a)) ? list :
	let (
		A = !(backwards==true) ? a : -a,
		sina  = sin(A),
		cosa  = cos(A)
	)
	[for (p=list)
		[
		  p.x*cosa + p.z*sina
		, p.y
		,-p.x*sina + p.z*cosa
		]
	]
;
function rotate_y_point (p, a, backwards=false) =
	(a==undef || !is_num(a)) ? p :
	let (
		A = !(backwards==true) ? a : -a,
		sina  = sin(A),
		cosa  = cos(A)
	)
	[
	  p.x*cosa + p.z*sina
	, p.y
	,-p.x*sina + p.z*cosa
	]
;
// jeden Punkt in der Liste <list> um die Z-Achse um <a> Grad drehen
// auch für 2D-Listen
function rotate_z_points (list, a, backwards=false) =
	(a   ==undef || !is_num(a))   ? list :
	(list==undef || len(list)==0) ? list :
	let (
		A = !(backwards==true) ? a : -a,
		sina  = sin(A),
		cosa  = cos(A)
	)
	len(list[0])==2 ?
		[for (p=list)
			[
			 p.x*cosa - p.y*sina
			,p.x*sina + p.y*cosa
			]
		]
	:
		[for (p=list)
			[
			 p.x*cosa - p.y*sina
			,p.x*sina + p.y*cosa
			,p.z
			]
		]
;
function rotate_z_point (p, a, backwards=false) =
	(a==undef || !is_num(a)) ? p :
	(p==undef)               ? p :
	let (
		A = !(backwards==true) ? a : -a,
		sina  = sin(A),
		cosa  = cos(A)
	)
	len(p)==2 ?
		[
		 p.x*cosa - p.y*sina
		,p.x*sina + p.y*cosa
		]
	:
		[
		 p.x*cosa - p.y*sina
		,p.x*sina + p.y*cosa
		,p.z
		]
;
// jeden Punkt in der Liste <list> um einen Vektor <v> herum um <a> Grad drehen
function rotate_v_points (list, a, v, backwards=false) =
	 (v==undef || !is_list(v)) ? rotate_z_points (list, a, backwards)
	:(a==undef || !is_num (a)) ? list
	:
	let (
		matrix = matrix_rotate_v (a, v, backwards, d=3, short=true)
	)
	[ for (p=list)
		matrix * p
	]
;
function rotate_v_point (p, a, v, backwards=false) =
	 (v==undef || !is_list(v)) ? rotate_z_point (p, a, backwards)
	:(a==undef || !is_num (a)) ? p
	:
	let (
		matrix = matrix_rotate_v (a, v, backwards, d=3, short=true)
	)
	matrix * p
;

// jeden Punkt in der Liste <list> entlang dem Vektor <v> spiegeln am Koordinatenursprung
// funktioniert wie mirror()
//  list = Punkt-Liste
//  v    = Vektor, in dieser Richtung wird gespiegelt
function mirror_points (list, v) =
	(list==undef || list[0]==undef) ? undef
	:len(list[0])==3 ? multmatrix_points (list, matrix_mirror_3d (v, short=true))
	:len(list[0])==2 ? multmatrix_points (list, matrix_mirror_2d (v, short=true))
	:len(list[0])==1 ? -list
	:undef
	
;
function mirror_point (p, v) =
	(p==undef || p[0]==undef) ? undef
	:len(p)==3 ? multmatrix_point (p, matrix_mirror_3d (v, short=true))
	:len(p)==2 ? multmatrix_point (p, matrix_mirror_2d (v, short=true))
	:len(p)==1 ? -p
	:undef
	
;
/*
function mirror_2d_points (list, v) =
	let (
		V = parameter_mirror_vector_2d(v),
		angle = atan2(V.y,V.x),
		list_up     = rotate_z_points (list,        angle, backwards=true),
		list_mirror = [ for (p=list_up) [-p.x,p.y] ],
		list_result = rotate_z_points (list_mirror, angle)
	)
	list_result
;
function mirror_3d_points (list, v) =
	let (
		V = parameter_mirror_vector_3d(v),
		angle = atan2(V.y,V.x),
		list_up     = rotate_to_vector_points (list,        V,angle, backwards=true),
		list_mirror = [ for (p=list_up) [p.x,p.y,-p.z] ],
		list_result = rotate_to_vector_points (list_mirror, V,angle)
	)
	list_result
;
*/

// jeden Punkt in der Liste <list> an der jeweiligen Achse vergrößern
// funktioniert wie scale()
//  list = Punkt-Liste
//  v    = Vektor mit den Vergrößerungsfaktoren
function scale_points (list, v) =
	(list==undef || list[0]==undef) ? undef :
	let (
		d = len(list[0]),
		scale_factor = parameter_scale (v, d, false)
	)
	(scale_factor==false) ? list :
	[ for (p=list)
		[ for (i=[0:1:d-1])
			p[i] * scale_factor[i]
		]
	]
;
function scale_point (p, v) =
	(p==undef || p[0]==undef) ? undef :
	let (
		d = len(p),
		scale_factor = parameter_scale (v, d, false)
	)
	(scale_factor==false) ? p :
	[ for (i=[0:1:d-1])
		p[i] * scale_factor[i]
	]
;

// jeden Punkt in der Liste <list> an der jeweiligen Achse in die neue Größe einpassen
// funktioniert wie resize()
//  list    = Punkt-Liste
//  newsize = Vektor mit den neuen Maßen
function resize_points (list, newsize) =
	let (
		bounding_box = get_bounding_box_points(list) [0],
		scale_factor =
		[ for (i=[0:1:len(bounding_box)-1])
			(is_num(newsize[i]) && newsize[i]!=0 && bounding_box[i]>0) ?
				newsize[i] / bounding_box[i]
				: 1
		]
	)
	scale_points (list, scale_factor)
;

// gibt die Größe der umschließenden Box der Punkt-Liste zurück
// Rückgabe:  [ [size], [min_pos], [max_pos] ]
//   - size    = Größe der umschließenden Box
//   - min_pos = Punkt am Beginn der Box
//   - max_pos = Punkt am Ende der Box
function get_bounding_box_points (list) =
	(list==undef || len(list)==0) ? [[0,0,0],[0,0,0]] :
	let (
		min_pos = [ for (i=[ 0:1:len(list[0])-1 ]) min ([for(e=list) e[i]]) ],
		max_pos = [ for (i=[ 0:1:len(list[0])-1 ]) max ([for(e=list) e[i]]) ]
	)
	[ max_pos - min_pos, min_pos, max_pos ]
;

// jeden Punkt in der Liste <list> mit der Matrix <m> multiplizieren
// funktioniert wie multmatrix()
//  list = Punkt-Liste
//  m    = 4x3 oder 4x4 Matrix
function multmatrix_points (list, m) =
	(list==undef || list[0]==undef) ? undef :
	m==undef ? list :
	let(
		n = len(m[0])
	)
	 (len(list[0]) == 3) ? multmatrix_3d_points (list, repair_matrix(m, n<3 ? 3 : n) )
	:(len(list[0]) == 2) ? multmatrix_2d_points (list, repair_matrix(m, n<2 ? 2 : n) )
	:
		let( M = repair_matrix(m) )
		[ for (p=list) multmatrix_point (p, M) ]
;

function multmatrix_2d_points (list, m) =
	let (
		n = len(m[0])
	)
	n==2 ?
		[ for (p=list)
			m * p
		]
	:n==3 ?
		[ for (p=list)
			let ( q = m * [p.x,p.y, 1] )
			[q.x,q.y]
		]
	:[ for (p=list) multmatrix_point (p, m) ]
;
function multmatrix_3d_points (list, m) =
	let (
		n = len(m[0])
	)
	n==3 ?
		[ for (p=list)
			m * p
		]
	:n==4 ?
		[ for (p=list)
			let ( q = m * [p.x,p.y,p.z, 1] )
			[q.x,q.y,q.z]
		]
	:n==2 ?
		[ for (p=list)
			let ( a = m * [p.x,p.y] )
			[a.x,a.y, p.z]
		]
	:[ for (p=list) multmatrix_point (p, m) ]
;

function multmatrix_point (p, m) =
	let(
		n_p = len(p),
		n_m = len(m)
	)
	n_p==n_m ?
		m * p
	:n_p<n_m ?
		let( q = m * [for (i=[0:1:n_m-1]) i<n_p ? p[i] : 1] )
		[for (i=[0:1:n_p-1]) q[i]]
	://n_p>n_m ?
		let ( a = m * [for (i=[0:1:n_m-1]) p[i]] )
		[for (i=[0:1:n_p-1]) i<n_m ? a[i] : p[i]]
;
function multmatrix_2d_point (p, m) =
	let (
		n = len(m[0])
	)
	n==2 ?
		m * p
	:n==3 ?
		let ( v = m * [p.x,p.y, 1] )
		[v.x,v.y]
	:multmatrix_point (p, m)
;
function multmatrix_3d_point (p, m) =
	let (
		n = len(m[0])
	)
	n==3 ?
		m * p
	:n==4 ?
		let ( q = m * [p.x,p.y,p.z, 1] )
		[q.x,q.y,q.z]
	:n==2 ?
		let ( a = m * [p.x,p.y] )
		[a.x,a.y, p.z]
		//
		//concat (m * [p.x,p.y], p.z)
	:multmatrix_point (p, m)
;

// jeden Punkt in der Liste <list> auf die xy-Ebene projizieren
//  list  = Punkt-Liste
//  cut   = nur den Umriss nehmen, der durch die xy-Ebene geht
//          TODO nicht implementierbar ohne Zusammengehörigkeit der Punkte
//  plane = true  = eine 2D-Liste machen - Standart
//          false = 3D-Liste behalten, alle Punkte auf xy-Ebene
function projection_points (list, plane) =
	plane==false ? [ for (p=list) [p.x,p.y,0] ]
	:              [ for (p=list) [p.x,p.y]   ]
;
function projection_point (p, plane) =
	plane==false ? [p.x,p.y,0]
	:              [p.x,p.y]
;

