// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Formeln zum Berechnen von Kreisen, ...

use <banded/draft_transform_common.scad>
use <banded/math_common.scad>
use <banded/math_matrix.scad>


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
// mit 3 Punkten auf der Außenlinie
function get_circle_from_points (p1, p2, p3) =
	 len(p1)==2 ?
		get_circle_from_points_2d (p1, p2, p3)
	:len(p1)==3 ?
		get_circle_from_points_3d (p1, p2, p3)
	:undef
;
function get_circle_from_points_2d (p1, p2, p3) =
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
function get_circle_from_points_3d (p1, p2, p3) =
	let(
		normal   = cross (p2-p1, p3-p1),
		p_flat   = rotate_to_vector_points ([p1,p2,p3], normal, backwards=true),
		c_flat   = get_circle_from_points_2d (p_flat[0], p_flat[1], p_flat[2]),
		midpoint = rotate_to_vector_points ([concat(c_flat[0], p_flat[0].z)], normal, backwards=false)[0]
	)
	[midpoint, c_flat[1]]
;

// gibt [Mittelpunkt, Radius] einer Kugel zurück
// mit 4 Punkten auf der Außenfläche
function get_sphere_from_points   (p1, p2, p3, p4) =
	get_sphere_from_points_system (p1, p2, p3, p4)
;
function get_sphere_from_points_geometric (p1, p2, p3, p4) =
	let(
		// circle with first 3 points
		normal  = cross (p2-p1, p3-p1),
		p_flat  = rotate_to_vector_points ([p1,p2,p3,p4], normal, backwards=true),
		c_flat  = get_circle_from_points_2d (p_flat[0], p_flat[1], p_flat[2]),
		// find both points on circle which is in line with last point
		z    = p_flat[0].z,
		r    = c_flat[1],
		m    = c_flat[0],
		p    = [p_flat[3].x, p_flat[3].y],
		px_a =
			p==m ? [p_flat[0].x, p_flat[0].y]
			:      r/norm(p-m) * (p-m) + m,
		px_b = 2*m - px_a,
		px   = rotate_to_vector_points ([concat(px_a, z), concat(px_b, z)], normal, backwards=false)
	)
	get_circle_from_points_3d (px[0], px[1], p4)
;
function get_sphere_from_points_system (p1, p2, p3, p4) =
	let(
		m = [
			concat (1, 2*p1, sqr(norm(p1)) ),
			concat (1, 2*p2, sqr(norm(p2)) ),
			concat (1, 2*p3, sqr(norm(p3)) ),
			concat (1, 2*p4, sqr(norm(p4)) ),
			],
		result = transpose( gauss_jordan_elimination (m, clean=true) )[0],
		midpoint = [for (i=[1:3]) result[i]],
		radius = sqrt( result[0] + sqr(norm(midpoint)) )
	)
	[midpoint, radius]
;

// gibt [Mittelpunkt, Radius] einer n-Kugel zurück
// mit n+1 Punkten auf der Außenkante
function get_hypersphere_from_points (p) =
	let(
		size=len(p),
		m = [for (i=[0:1:size-1])
			concat (1, 2*p[i], sqr(norm(p[i])) )
			],
		result = transpose( gauss_jordan_elimination (m, clean=true) )[0],
		midpoint = [for (i=[1:1:size-1]) result[i]],
		radius = sqrt( result[0] + sqr(norm(midpoint)) )
	)
	[midpoint, radius]
;
