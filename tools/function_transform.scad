// function_transform.scad
//
// Enthält zusätzliche Funktionen zum Transformieren von Punktlisten


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
function rotate_at_list (list, a, p, v) =
	translate_list( rotate_list( translate_list( list, -p), a, v), p)
;
// jeden Punkt in der Liste <list> rückwärts rotieren an der angegebenen Position p
// funktioniert wie rotate_at()
function rotate_backwards_at_list (list, a, p, v) =
	translate_list( rotate_backwards_list( translate_list( list, -p), a, v), p)
;

// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v drehen
// funktioniert wie rotate_to_vector()
function rotate_to_vector_list (list, v, a) =
	let(
	V     = (is_list(v) && len(v)==3) ? v : [0,0,1],
	angle = is_num(a) ? a : 0,
	b     = acos(V[2]/norm(V)), // inclination angle
	c     = atan2(V[1],V[0])    // azimuthal angle
	)
	rotate_list( rotate_z_list( list, angle), [0, b, c])
;
// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
function rotate_backwards_to_vector_list (list, v, a) =
	let(
	V     = (is_list(v) && len(v)==3) ? v : [0,0,1],
	angle = is_num(a) ? a : 0,
	b     = acos(V[2]/norm(V)), // inclination angle
	c     = atan2(V[1],V[0])    // azimuthal angle
	)
	rotate_backwards_z_list( rotate_backwards_list( list, [0, b, c]), angle)
;

// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v
// drehen an der angegebenen Position
function rotate_to_vector_at_list (list, v, p, a) =
	translate_list( rotate_to_vector_list( translate_list( list, -p), v, a), p)
;
// jeden Punkt in der Liste <list> von in Richtung Z-Achse in Richtung Vektor v
// rückwärts drehen an der angegebenen Position
function rotate_backwards_to_vector_at_list (list, v, p, a) =
	translate_list( rotate_backwards_to_vector_list( translate_list( list, -p), v, a), p)
;

// rotiert um die jeweilige Achse wie die Hauptfunktion
function rotate_backwards_x_list (list, a) = !is_num(a) ? list : rotate_backwards_list(list, [a,0,0]);
function rotate_backwards_y_list (list, a) = !is_num(a) ? list : rotate_backwards_list(list, [0,a,0]);
function rotate_backwards_z_list (list, a) = !is_num(a) ? list : rotate_backwards_list(list, a);
//
function rotate_at_x_list (list, a, p) = !is_num(a) ? list : rotate_at_list(list, [a,0,0], p);
function rotate_at_y_list (list, a, p) = !is_num(a) ? list : rotate_at_list(list, [0,a,0], p);
function rotate_at_z_list (list, a, p) = !is_num(a) ? list : rotate_at_list(list, a      , p);
//
function rotate_backwards_at_x_list (list, a, p) = !is_num(a) ? list : rotate_backwards_at_list(list, [a,0,0], p);
function rotate_backwards_at_y_list (list, a, p) = !is_num(a) ? list : rotate_backwards_at_list(list, [0,a,0], p);
function rotate_backwards_at_z_list (list, a, p) = !is_num(a) ? list : rotate_backwards_at_list(list, a,       p);
//
// verschiebt in der jeweiligen Achse wie die Hauptfunktion
function translate_x_list  (list, l) = !is_num(l) ? list : translate_list(list, [l,0,0]);
function translate_y_list  (list, l) = !is_num(l) ? list : translate_list(list, [0,l,0]);
function translate_z_list  (list, l) = !is_num(l) ? list : translate_list(list, [0,0,l]);
function translate_xy_list (list, t) =
	!(is_list(t) && len(t)>=2 && is_num(t[0]) && is_num(t[1])) ? list :
	translate_list(list, [t[0],t[1],0])
;

// jeden Punkt in der Liste <list> spiegeln entlang dem Vektor <v>
// Spiegel an Position p
function mirror_at_list (list, v, p) =
	let (
	V = !is_undef(v) ? v : [1,0,0]
	)
	!is_undef(p) ?
		translate_list(
		mirror_list(
		translate_list(list, -p), V), p)
	:
		mirror_list(list, V)
;

// spigelt an der jeweiligen Achse wie die Hauptfunktion
function mirror_x_list (list) = mirror_list (list, [1,0,0]);
function mirror_y_list (list) = mirror_list (list, [0,1,0]);
function mirror_z_list (list) = mirror_list (list, [0,0,1]);
//
function mirror_at_x_list (list, p) = mirror_at_list (list, [1,0,0], p);
function mirror_at_y_list (list, p) = mirror_at_list (list, [0,1,0], p);
function mirror_at_z_list (list, p) = mirror_at_list (list, [0,0,1], p);

// skaliert an der jeweiligen Achse wie die Hauptfunktion
function scale_x_list (list, f) = scale_list (list, [f,0,0]);
function scale_y_list (list, f) = scale_list (list, [0,f,0]);
function scale_z_list (list, f) = scale_list (list, [0,0,f]);
