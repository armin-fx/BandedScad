// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Gibt die Matritzen zur Verwendung für multmatrix zurück.
// Diese können mit Matritzenmultiplikation verknüpft werden.
//
// es werden weitere Funktionen zum Transformieren definiert

use <banded/helper_recondition.scad>
use <banded/math_matrix.scad>
use <banded/math_vector.scad>
use <banded/draft_multmatrix_basic.scad>
use <banded/draft_transform_basic.scad>

// gibt die Matrix zurück zum rückwärts rotieren von Objekten
function matrix_rotate_backwards (a, v, d=3) =
	matrix_rotate (a, v, backwards=true, d=d)
;

// gibt die Matrix zurück zum rotieren an der angegebenen Position p
function matrix_rotate_at (a, p, v, d=3, backwards=false) =
	! (backwards==true) ?
		// forward
		matrix_transform_at ( p=p, d=d, m=
		matrix_rotate ( a, v, d=d) )
	:	// backwards
		matrix_rotate_backwards_at (a, p, v, d=d)
;
// gibt die Matrix zurück zum rückwärts rotieren an der angegebenen Position p
function matrix_rotate_backwards_at (a, p, v, d=3) = 
	matrix_transform_at ( p=p, d=d, m=
	matrix_rotate_backwards ( a, v, d=d)
	)
;

// gibt die Matrix zurück zum von in Richtung Z-Achse in Richtung Vektor v drehen
function matrix_rotate_to_vector (v, a, backwards=false) =
	is_list(a) ?
		matrix_rotate_to_vector_vo (v, a, backwards)
	:	matrix_rotate_to_vector_yz (v, a, backwards)
;
function matrix_rotate_to_vector_vo (v, o, backwards=false) =
	let(
	d     = 3,
	V     = (is_list(v) && len(v)==3) ? v : [0,0,1],
	orientation = (is_list(o) && len(o)==3) ? o : [1,0,0],
	//
	base_vector = [1,0],
	up_to_z     = multmatrix_list ( [orientation], matrix_rotate_to_vector_yz(V, backwards=true) ),
	plane       = projection_list (up_to_z),
	angle_base  = rotation_vector (base_vector, plane[0])
	)
	matrix_rotate_to_vector_yz (V, angle_base, backwards)
;
function matrix_rotate_to_vector_yz (v, a, backwards=false) =
	let(
	d     = 3,
	V     = (is_list(v) && len(v)==3) ? v : [0,0,1],
	angle = is_num(a) ? a : 0,
	//
	b     = acos(V.z/norm(V)), // inclination angle
	c     = atan2(V.y,V.x)     // azimuthal angle
	)
	! (backwards==true) ?
		// forward
		angle==0 ?
			matrix_rotate  ([0, b, c], d=d)
		:
			matrix_rotate  ([0, b, c], d=d) *
			matrix_rotate_z(angle,     d=d)
	:	// backwards
		angle==0 ?
			matrix_rotate_backwards  ([0, b, c], d=d)
		:
			matrix_rotate_backwards_z(angle,     d=d) *
			matrix_rotate_backwards  ([0, b, c], d=d)
;
// gibt die Matrix zurück zum von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
function matrix_rotate_backwards_to_vector (v, a) =
	matrix_rotate_to_vector (v, a, backwards=true)
;

// gibt die Matrix zurück zum drehen von in Richtung Z-Achse in Richtung Vektor v
// an der angegebenen Position
function matrix_rotate_to_vector_at (v, p, a, backwards=false) =
	let( d = 3 )
	! (backwards==true) ?
		// forward
		parameter_numlist(d,p,[0,0,0],true) != [0,0,0] ?
			matrix_transform_at ( p=p, d=d, m=
			matrix_rotate_to_vector( v, a) )
		:
			matrix_rotate_to_vector( v, a)
	:	// backwards
		matrix_rotate_backwards_to_vector_at (v, p, a)
;
// gibt die Matrix zurück zum rückwärts drehen von in Richtung Z-Achse in Richtung Vektor v
// an der angegebenen Position
function matrix_rotate_backwards_to_vector_at (v, p, a) =
	let( d = 3 )
	parameter_numlist(d,p,[0,0,0],true) != [0,0,0] ?
		matrix_transform_at ( p=p, d=d, m=
		matrix_rotate_backwards_to_vector( v, a) )
	:
		matrix_rotate_backwards_to_vector( v, a)
;

// gibt die Matrix zurück zum rotieren um die jeweilige Achse wie die Hauptfunktion
function matrix_rotate_backwards_x (a) = let(d=3) !is_num(a) ? identity_matrix(d+1) : matrix_rotate_backwards([a,0,0], d=d);
function matrix_rotate_backwards_y (a) = let(d=3) !is_num(a) ? identity_matrix(d+1) : matrix_rotate_backwards([0,a,0], d=d);
function matrix_rotate_backwards_z (a, d=3) =     !is_num(a) ? identity_matrix(d+1) : matrix_rotate_backwards(a,       d=d);
//
function matrix_rotate_at_x (a, p) = let(d=3) !is_num(a) ? identity_matrix(d+1) : matrix_rotate_at([a,0,0], p, d=d);
function matrix_rotate_at_y (a, p) = let(d=3) !is_num(a) ? identity_matrix(d+1) : matrix_rotate_at([0,a,0], p, d=d);
function matrix_rotate_at_z (a, p, d=3) =     !is_num(a) ? identity_matrix(d+1) : matrix_rotate_at(a      , p, d=d);
//
function matrix_rotate_backwards_at_x (a, p) = let(d=3) !is_num(a) ? identity_matrix(d+1) : matrix_rotate_backwards_at([a,0,0], p, d=d);
function matrix_rotate_backwards_at_y (a, p) = let(d=3) !is_num(a) ? identity_matrix(d+1) : matrix_rotate_backwards_at([0,a,0], p, d=d);
function matrix_rotate_backwards_at_z (a, p, d=3) =     !is_num(a) ? identity_matrix(d+1) : matrix_rotate_backwards_at(a,       p, d=d);
//
// gibt die Matrix zurück zum verschieben in der jeweiligen Achse wie die Hauptfunktion
function matrix_translate_x  (l, d=3) =     !is_num(l) ? identity_matrix(d+1) : matrix_translate([l,0,0], d=d);
function matrix_translate_y  (l, d=3) =     !is_num(l) ? identity_matrix(d+1) : matrix_translate([0,l,0], d=d);
function matrix_translate_z  (l) = let(d=3) !is_num(l) ? identity_matrix(d+1) : matrix_translate([0,0,l], d=d);
function matrix_translate_xy (t, d=3) =
	!(is_list(t) && len(t)>=2 && is_num(t.x) && is_num(t.y)) ? identity_matrix(d+1) :
	matrix_translate([t.x,t.y,0], d=d)
;

// gibt die Matrix zurück zum spiegeln entlang dem Vektor <v>
// Spiegel an Position p
function matrix_mirror_at (v, p, d=3) =
	matrix_transform_at ( p=p, d=d, m=
	matrix_mirror ( v, d=d)
	)
;

// gibt die Matrix zurück zum spiegeln an der jeweiligen Achse wie die Hauptfunktion
function matrix_mirror_x (d=3) =       matrix_mirror (list, [1,0,0], d=d);
function matrix_mirror_y (d=3) =       matrix_mirror (list, [0,1,0], d=d);
function matrix_mirror_z () = let(d=3) matrix_mirror (list, [0,0,1], d=d);
// gibt die Matrix zurück zum spiegeln an der jeweiligen Achse bei gewählter Position
// p = Position als Vektor
//     oder als Abstand auf der jeweiligen Achse vom Koordinatenursprung
function matrix_mirror_at_x (p, d=3) =     matrix_mirror_at ([1,0,0], !is_num(p) ? p : [p,0,0], d=d);
function matrix_mirror_at_y (p, d=3) =     matrix_mirror_at ([0,1,0], !is_num(p) ? p : [0,p,0], d=d);
function matrix_mirror_at_z (p) = let(d=3) matrix_mirror_at ([0,0,1], !is_num(p) ? p : [0,0,p], d=d);

// gibt die Matrix zurück zum skalieren an der jeweiligen Achse wie die Hauptfunktion
// f = Skalierfaktor
function matrix_scale_x (f, d=3) =     matrix_scale ([f,0,0], d=d);
function matrix_scale_y (f, d=3) =     matrix_scale ([0,f,0], d=d);
function matrix_scale_z (f) = let(d=3) matrix_scale ([0,0,f], d=d);
//

// Generate a matrix to skew an object
// v = vector, shear parallel to this axis
//     3D: - as vector
//         - standard = Z axis
//     2D: - as vector
//         - or as angle in degree
//         - same operation like rotate_to_vector()
//         - standard = Y axis
// t = target vector, shear direction to this vector
//     3D: - as vector
//         - as angle in degree
//         - standard = X axis
//     2D: not needed, undefined
// m = skew factor, standard = 0
// a = angle in degree inside (-90 ... 90)
//     alternative to 'm'
// standard 3D = shear X along Z
// standard 2D = shear X along Y
function matrix_skew (v, t, m, a, d=3) =
	let(
	M =	  is_num(m) ? m
		: is_num(a) ? tan(a)
		: 0,
	V =	d==2 ? // 2D => angle
			(is_list(v) && len(v)>=2) ? atan2(v[1],v[0])
			: is_num(v) ? v
			: 0
		: d==3 ? // 3D => vector
			(is_list(v) && len(v)==3) ? v
			: [0,0,1]
		: undef,
	T =	d==3 ?
			(is_list(t) && len(t)==3) ? t
			:is_num (t) ? t
			: [1,0,0]
		: undef
	)
	d==3 ?
		matrix_rotate_to_vector (V, T) *
		[[1,0,M,0],
		,[0,1,0,0]
		,[0,0,1,0]
		,[0,0,0,1]]
		* matrix_rotate_backwards_to_vector (V, T)
	: d==2 ?
		[[1,M*cos(V),0]
		,[M*sin(V),1,0]
		,[0,0,1]]
	: undef
;

// Generate a matrix to skew an object at position 'p'
function matrix_skew_at (v, t, m, a, p, d=3) =
	matrix_transform_at ( p=p, d=d, m=
	matrix_skew ( v,t,m,a, d=d)
	)
;

// Manipulate a matrix to transform at origin position 'p'
function matrix_transform_at (m, p, d=3) =
	!is_list(p) ? m :
		matrix_translate( p, d=d)
		* m *
		matrix_translate(-p, d=d)
;
