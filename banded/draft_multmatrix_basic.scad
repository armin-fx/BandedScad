// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Gibt die Matritzen zur Verwendung für multmatrix zurück.
// Diese können mit Matritzenmultiplikation verknüpft werden.
//
// es werden die Funktionen von OpenSCAD-Modulen zum Transformieren nachgebildet

use <banded/helper_native.scad>
use <banded/helper_recondition.scad>
use <banded/math_vector.scad>
use <banded/math_matrix.scad>
use <banded/draft_multmatrix_common.scad>

// gibt die Matrix zum verschieben von Objekten zurück
//  v = Vektor
//  d = Dimension der Vektoren, die mit der Matrix bearbeitet werden
//       - 3 = räumlich (3D) = Standart
//       - 2 = flächig  (2D)
function matrix_translate (v, d=3) =
	(d==3) ?
		[[1,0,0, get_first_num(v[0],0)]
		,[0,1,0, get_first_num(v[1],0)]
		,[0,0,1, get_first_num(v[2],0)]
		,[0,0,0, 1]
		]
	:(d==2) ?
		[[1,0, get_first_num(v[0],0)]
		,[0,1, get_first_num(v[1],0)]
		,[0,0, 1]
		]
	: undef
;

// gibt die Matrix zum rotieren von Objekten zurück
//  a    = Winkel (a)
//  v    = Vektor
//  backwards = 'false' - Standard, vorwärts rotieren
//              'true'  - rückwärts rotieren, macht Rotation rückgängig
//  d = Dimension der Vektoren, die mit der Matrix bearbeitet werden
//      - 3 = räumlich (3D) = Standart
//      - 2 = flächig  (2D)
function matrix_rotate (a, v, backwards=false, d=3) =
	! (backwards==true) ?
		// forward
		is_list(a) ?
			matrix_rotate_z(a.z, d=d) *
			matrix_rotate_y(a.y, d=d) *
			matrix_rotate_x(a.x, d=d)
		:is_num(a)  ?
			is_list(v) ?
				matrix_rotate_v(a, v, d=d)
			:	matrix_rotate_z(a,    d=d)
		:identity_matrix(d+1)
	:
		// backwards
		is_list(a) ?
			matrix_rotate_x (-a.x, d=d) *
			matrix_rotate_y (-a.y, d=d) *
			matrix_rotate_z (-a.z, d=d)
		:is_num(a)  ?
			is_list(v) ?
				matrix_rotate_v (-a, v, d=d)
			:	matrix_rotate_z (-a,    d=d)
		:identity_matrix(d+1)
;

// gibt die Matrix zum rotieren von Objekten um die X-Achse um <a> zurück
function matrix_rotate_x (a, d=3) =
	let (
		angle = is_num(a) ? a : 0,
		sina  = sin(angle),
		cosa  = cos(angle)
	)
	(d==3) ?
		[[ 1,    0,  0   , 0]
		,[ 0, cosa, -sina, 0]
		,[ 0, sina,  cosa, 0]
		,[ 0,    0,  0   , 1]
		]
	: undef
;
// gibt die Matrix zum rotieren von Objekten um die Y-Achse um <a> zurück
function matrix_rotate_y (a, d=3) =
	let (
		angle = is_num(a) ? a : 0,
		sina  = sin(angle),
		cosa  = cos(angle)
	)
	(d==3) ?
		[[ cosa, 0, sina, 0]
		,[ 0   , 1, 0   , 0]
		,[-sina, 0, cosa, 0]
		,[ 0   , 0, 0   , 1]
		]
	: undef
;
// gibt die Matrix zum rotieren von Objekten um die Z-Achse um <a> zurück
function matrix_rotate_z (a, d=3) =
	let (
		angle = is_num(a) ? a : 0,
		sina  = sin(angle),
		cosa  = cos(angle)
	)
	(d==3) ?
		[[cosa, -sina, 0, 0]
		,[sina,  cosa, 0, 0]
		,[0   ,  0   , 1, 0]
		,[0   ,  0   , 0, 1]
		]
	:(d==2) ?
		[[cosa, -sina, 0]
		,[sina,  cosa, 0]
		,[0   ,  0   , 1]
		]
	: undef
;
// gibt die Matrix zum rotieren von Objekten um einen Vektor <v> herum um <a> zurück
function matrix_rotate_v (a, v, d=3) =
	let (
		u=unit_vector(v),
		x=u.x, y=u.y, z=u.z,
		angle = is_num(a) ? a : 0,
		sina  = sin(angle),
		cosa  = cos(angle)
	)
	(d==3) ?
		[[ x*x*(1-cosa)+  cosa, x*y*(1-cosa)-z*sina, x*z*(1-cosa)+y*sina, 0 ]
		,[ y*x*(1-cosa)+z*sina, y*y*(1-cosa)+  cosa, y*z*(1-cosa)-x*sina, 0 ]
		,[ z*x*(1-cosa)-y*sina, z*y*(1-cosa)+x*sina, z*z*(1-cosa)+  cosa, 0 ]
		,[ 0, 0, 0, 1 ]
		]
	: undef
;

// gibt die Matrix zum spiegeln von Objekten zurück
//  v = Vektor, in dieser Richtung wird gespiegelt
//  d = Dimension der Vektoren, die mit der Matrix bearbeitet werden
//       - 3 = räumlich (3D) = Standart
//       - 2 = flächig  (2D)
function matrix_mirror (v, d=3) =
	 (d==2) ? matrix_mirror_2d (v)
	:(d==3) ? matrix_mirror_3d (v)
	:undef
;
function matrix_mirror_2d (v) =
	let (
		d=2,
		V = parameter_mirror_vector_2d(v),
		angle = atan2(V.y,V.x)
	)
	matrix_rotate_z(angle, d=d) *
	[[-1,0,0]
	,[ 0,1,0]
	,[ 0,0,1]
	] *
	matrix_rotate_backwards_z(angle, d=d)
;
function matrix_mirror_3d (v) =
	let (
		V = parameter_mirror_vector_3d(v),
		angle = atan2(V.y,V.x)
	)
	matrix_rotate_to_vector(V, angle) *
	[[1,0, 0,0]
	,[0,1, 0,0]
	,[0,0,-1,0]
	,[0,0, 0,1]
	] *
	matrix_rotate_backwards_to_vector(V, angle)
;

// gibt die Matrix zum an der jeweiligen Achse vergrößern zurück
//  v    = Vektor mit den Vergrößerungsfaktoren
function matrix_scale (v, d=3) =
	(!is_list(v) || len(v)==0) ? identity_matrix(d+1) :
	let (
		scale_factor  = [ for (i=[0:d-1]) (len(v)>i && v[i]!=0 && is_num(v[i])) ? v[i] : 1 ],
		scale_entries = concat( scale_factor, 1)
	)
	[ for (i=[0:d])
	[ for (j=[0:d])
		(i==j) ? scale_entries[i] : 0
	]]
;

function matrix_projection (v, d=3) =
	 (d==2) ? matrix_projection_2d (v)
	:(d==3) ? matrix_projection_3d (v)
	:undef
;
function matrix_projection_2d (v) =
	let (
		angle = is_num_2d(v) ? rotation_vector (v, [1,0]) :
				is_num(v)    ? v :
		        0,
		sina  = sin(angle),
		cosa  = cos(angle)
	)
	[[0, sina*sina + sina*cosa]
	,[0, cosa*sina + cosa*cosa]
	]
;
function matrix_projection_3d (v) =
	let (
		V = parameter_mirror_vector_3d(v, [0,0,1]),
		angle = atan2(V.y,V.x)
	)
	matrix_rotate_to_vector(V, angle) *
	[[1,0,0,0]
	,[0,1,0,0]
	,[0,0,0,0]
	,[0,0,0,1]
	] *
	matrix_rotate_backwards_to_vector(V, angle)
;

