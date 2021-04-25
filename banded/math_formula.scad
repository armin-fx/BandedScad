// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Formeln zum Berechnen von Kreisen, ...


// Radius eines Kreises berechnen
// benötigt je 2 Parameter:
//   chord    = Kreissehne
//   sagitta  = Segmenthöhe
//   angle    = Mittelpunktswinkel
function get_radius_from (chord, sagitta, angle) =
	let (
		c=chord, s=sagitta, a=angle
		,is_c = c!=undef && is_num(c)
		,is_s = s!=undef && is_num(s)
		,is_a = a!=undef && is_num(a)
	)
	 is_c&&is_s ? 1/2 * (s + (c*c/4)/s)
	:is_a&&is_s ? s/2 / sin(a/2)
	:is_a&&is_c ? c / (1 - cos(a/2))
	:"too low parameter"
;

// gibt [Mittelpunkt, Radius] eines Kreises zurück
// mit 3 Punkten in einer Liste
function get_circle_from_points (p1, p2, p3) =
	let(
		// get bisection point and bisection direction to midpoint of circle
		sub_a = p2-p1,
		sub_b = p3-p2,
		point_a = p1 + sub_a / 2,
		point_b = p2 + sub_b / 2,
		normal_a = [-sub_a.y, sub_a.x],
		normal_b = [-sub_b.y, sub_b.x],
		// get midpoint, crossing both lines
		term_divider = normal_b.y*normal_a.x - normal_a.y*normal_b.x,
		term_a       = normal_a.x*point_a.y  - point_a.x*normal_a.y,
		term_b       = normal_b.x*point_b.y  - point_b.x*normal_b.y,
		midpoint = [
			(normal_b.x*term_a - normal_a.x*term_b) / term_divider,
			(normal_b.y*term_a - normal_a.y*term_b) / term_divider
			],
		// get radius, difference between a point and midpoint of circle
		radius = norm ( p1-midpoint )
	)
	[midpoint, radius]
;
