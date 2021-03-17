// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält zusätzliche Funktionen zum Transformieren von Punktlisten

use <banded/draft_transform_basic.scad>
use <banded/draft_multmatrix_common.scad>
use <banded/draft_multmatrix_basic.scad>

// jeden Punkt in der Liste <list> rückwärts rotieren
// funktioniert wie rotate_backwards()
function rotate_backwards_points (list, a, v) =
	rotate_points (list, a, v, backwards=true)
;

// jeden Punkt in der Liste <list> rotieren an der angegebenen Position p
// funktioniert wie rotate_at()
function rotate_at_points (list, a, p, v, backwards=false) =
	! (backwards==true) ?
		// forward
		translate_points( v=p,      list=
		rotate_points    (a=a, v=v, list=
		translate_points( v=-p,     list=
		list )))
	:	// backwards
		rotate_backwards_at_points (list, a, p, v)
;
// jeden Punkt in der Liste <list> rückwärts rotieren an der angegebenen Position p
// funktioniert wie rotate_at()
function rotate_backwards_at_points (list, a, p, v) =
	translate_points       ( v=p,      list=
	rotate_backwards_points( a=a, v=v, list=
	translate_points       ( v=-p,     list=
	list )))
;

// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v drehen
// funktioniert wie rotate_to_vector()
function rotate_to_vector_points (list, v, a, backwards=false) =
	multmatrix_points (list,
		matrix_rotate_to_vector (v, a, backwards)
	)
;
// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
function rotate_backwards_to_vector_points (list, v, a) =
	rotate_to_vector_points (list, v, a, backwards=true)
;

// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v
// drehen an der angegebenen Position
function rotate_to_vector_at_points (list, v, p, a, backwards=false) =
	multmatrix_points (list,
		matrix_rotate_to_vector_at (v, p, a, backwards)
	)
;
// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v
// rückwärts drehen an der angegebenen Position
function rotate_backwards_to_vector_at_points (list, v, p, a) =
	rotate_to_vector_at_points (list, v, p, a, backwards=true)
;

// rotiert um die jeweilige Achse wie die Hauptfunktion
function rotate_backwards_x_points (list, a) = !is_num(a) ? list : rotate_x_points(list, -a);
function rotate_backwards_y_points (list, a) = !is_num(a) ? list : rotate_y_points(list, -a);
function rotate_backwards_z_points (list, a) = !is_num(a) ? list : rotate_z_points(list, -a);
//
function rotate_at_x_points (list, a, p, backwards=false) = !is_num(a) ? list : rotate_at_points(list, [a,0,0], p, backwards=backwards);
function rotate_at_y_points (list, a, p, backwards=false) = !is_num(a) ? list : rotate_at_points(list, [0,a,0], p, backwards=backwards);
function rotate_at_z_points (list, a, p, backwards=false) = !is_num(a) ? list : rotate_at_points(list, a      , p, backwards=backwards);
//
function rotate_backwards_at_x_points (list, a, p) = !is_num(a) ? list : rotate_backwards_at_points(list, [a,0,0], p);
function rotate_backwards_at_y_points (list, a, p) = !is_num(a) ? list : rotate_backwards_at_points(list, [0,a,0], p);
function rotate_backwards_at_z_points (list, a, p) = !is_num(a) ? list : rotate_backwards_at_points(list, a,       p);

// verschiebt in der jeweiligen Achse wie die Hauptfunktion
function translate_x_points  (list, l) = !is_num(l) ? list : translate_points(list, [l,0,0]);
function translate_y_points  (list, l) = !is_num(l) ? list : translate_points(list, [0,l,0]);
function translate_z_points  (list, l) = !is_num(l) ? list : translate_points(list, [0,0,l]);
function translate_xy_points (list, t) =
	(is_list(t) && len(t)>=2 && is_num(t.x) && is_num(t.y)) ?
		translate_points(list, [t.x,t.y,0])
	:(is_num(t)) ?
		translate_points(list, [t,t,0])
	:
		list
;

// jeden Punkt in der Liste <list> spiegeln entlang dem Vektor <v>
// Spiegel an Position p
function mirror_at_points (list, v, p) =
	(!is_list(list) || !is_list(list[0])) ? undef :
	p!=undef ?
		let (d=len(list[0]))
		multmatrix_points (list,
			matrix_translate( p, d=d) *
			matrix_mirror   ( v, d=d) *
			matrix_translate(-p, d=d)
		)
	:
		mirror_points(list, v)
;

// spiegelt an der jeweiligen Achse wie die Hauptfunktion
function mirror_x_points (list) = mirror_points (list, [1,0,0]);
function mirror_y_points (list) = mirror_points (list, [0,1,0]);
function mirror_z_points (list) = mirror_points (list, [0,0,1]);
// spiegelt an der jeweiligen Achse bei gewählter Position
// p = Position als Vektor
//     oder als Abstand auf der jeweiligen Achse vom Koordinatenursprung
function mirror_at_x_points (list, p) = mirror_at_points (list, [1,0,0], !is_num(p) ? p : [p,0,0]);
function mirror_at_y_points (list, p) = mirror_at_points (list, [0,1,0], !is_num(p) ? p : [0,p,0]);
function mirror_at_z_points (list, p) = mirror_at_points (list, [0,0,1], !is_num(p) ? p : [0,0,p]);

// skaliert an der jeweiligen Achse wie die Hauptfunktion
// f = Skalierfaktor
function scale_x_points (list, f) = scale_points (list, [f,0,0]);
function scale_y_points (list, f) = scale_points (list, [0,f,0]);
function scale_z_points (list, f) = scale_points (list, [0,0,f]);
//
// verändert die Größe an der jeweiligen Achse wie die Hauptfunktion
// l = neue Größe der jeweiligen Achse
function resize_x_points (list, l) = resize_points (list, [l,0,0]);
function resize_y_points (list, l) = resize_points (list, [0,l,0]);
function resize_z_points (list, l) = resize_points (list, [0,0,l]);

// skew an object in a point list, see matrix_skew()
function skew_points (list, v, t, m, a) =
	(!is_list(list) || !is_list(list[0])) ? undef :
	multmatrix_points (list,
		matrix_skew (v, t, m, a, d=len(list[0]))
	)
;

// skew an object in a point list at position 'p', see matrix_skew_at()
function skew_at_points (list, v, t, m, a, p) =
	(!is_list(list) || !is_list(list[0])) ? undef :
	multmatrix_points (list,
		matrix_skew_at (v, t, m, a, p, d=len(list[0]))
	)
;

