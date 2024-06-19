// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Formeln zum Berechnen von Kreisen, ...
//
// Zum benutzen und zum nachschlagen.

use <banded/draft_transform_common.scad>
use <banded/math_common.scad>
use <banded/math_vector.scad>
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
			concat (1, 2*p1, norm_sqr(p1) ),
			concat (1, 2*p2, norm_sqr(p2) ),
			concat (1, 2*p3, norm_sqr(p3) ),
			concat (1, 2*p4, norm_sqr(p4) ),
			],
		result = transpose( gauss_jordan_elimination (m, clean=true) )[0],
		midpoint = [for (i=[1:3]) result[i]],
		radius = sqrt( result[0] + norm_sqr(midpoint) )
	)
	[midpoint, radius]
;

// gibt [Mittelpunkt, Radius] einer n-Kugel zurück
// mit n+1 Punkten auf der Außenkante
function get_hypersphere_from_points (p) =
	let(
		size=len(p),
		m = [for (i=[0:1:size-1])
			concat (1, 2*p[i], norm_sqr(p[i]) )
			],
		result = transpose( gauss_jordan_elimination (m, clean=true) )[0],
		midpoint = [for (i=[1:1:size-1]) result[i]],
		radius = sqrt( result[0] + norm_sqr(midpoint) )
	)
	[midpoint, radius]
;

// Parameter einer Parabel berechnen
// von 3 Punkten auf der Parabel (2D)
//     y = Ax² + Bx + C
// Rückgabe: [C,B,A]
// 'p1, p2, p3' - beliebige Punkte auf der Parabel
function get_parabola_from_points (p1, p2, p3) =
	let (
		k = (p1.x-p3.x) / (p2.x-p3.x),
		A =
			(p1.y - p3.y - k*(p2.y-p3.y))
			/ (p1.x*p1.x - p3.x*p3.x - k*(p2.x*p2.x - p3.x*p3.x) ),
		B =
			(p1.y - p3.y - A*(p1.x*p1.x - p3.x*p3.x) )
			/ (p1.x - p3.x),
		C = p1.y - A*p1.x*p1.x - B*p1.x
	)
	[C,B,A]
;

// Parameter einer Parabel berechnen
// von 3 Punkten auf der Parabel (2D)
// Parabel vom Typ:
//     y = Ax² + Bx + C
// Rückgabe: [C,B,A]
// 'p1, p2' - die äußeren Punkte auf der Parabel
// 'ym'     - die Höhe des mittleren Punktes zwischen p1 und p2
function get_parabola_from_midpoint (p1, p2, ym) =
	let (
		A = 2 * (p1.y+p2.y-2*ym) / ((p1.x-p2.x)*(p1.x-p2.x)),
	//	B = 2 * ( (p1.y-ym) - A*(sqr(p1.x) - sqr(p1.x+p2.x)/4) ) / (p1.x-p2.x),
		B = ( 2*(p1.y-ym) - A*(3*p1.x*p1.x - p2.x*p2.x - 2*p1.x*p2.x)/2 ) / (p1.x-p2.x),
		C = p1.y - A*p1.x*p1.x - B*p1.x
	)
	[C,B,A]
;

// gibt die Nullstellen einer Parabel zurück
// Parabel vom Typ:
//     y = Ax² + Bx + C
// - 'P' - Parabelparameter [C,B,A]
// - 'chosen'
//   -  0 - all existing zero points as list, default
//   - -1 - left zero point as number
//   -  1 - right zero point as number
function get_parabola_zero (P, chosen=0) =
	let (
		A = P[2],
		B = P[1],
		C = P[0],
		//
		D = B*B - 4*A*C
	)
	chosen==0 ?
		A==0 ?
			B!=0 ? [ -C/B ]
			:      [] :
		D<0  ? [] :
		D==0 ? [(-B) / (2*A)]
		:
		let(
			x1 = (-B - sqrt(D)) / (2*A),
			x2 = (-B + sqrt(D)) / (2*A)
		)
		A>0 ? [x1, x2]
		    : [x2, x1]
	:
		A==0 ?
			B!=0 ? -C/B
			:      undef :
		D<0  ? undef :
		D==0 ? (-B) / (2*A)
		:
		chosen*A<0 ? (-B - sqrt(D)) / (2*A)
		           : (-B + sqrt(D)) / (2*A)
;

function get_parabola_zero_from_points (p1, p2, p3, chosen=0) =
	let (
		P = get_parabola_from_points (p1, p2, p3),
		z = get_parabola_zero (P, chosen)
	)
	z
;
function get_parabola_zero_from_midpoint (p1, p2, ym, chosen=0) =
	let (
		P = get_parabola_from_midpoint (p1, p2, ym),
		z = get_parabola_zero (P, chosen)
	)
	z
;


// - Surface area calculation:

// calculate the area of a cube
function area_cube (size) =
	2 * (size.x*size.z + size.x*size.y + size.y*size.z)
;

// calculate the area of a cylinder (or a cone)
function area_cylinder (h, r1, r2, r, d, d1, d2) =
	let(
		 R = parameter_cylinder_r (r, r1, r2, d, d1, d2)
		,H = get_first_num (h, 1)
		,a_bottom = PI * R[0]*R[0]
		,a_top    = PI * R[1]*R[1]
		,M        = sqrt( sqr(R[0] - R[1]) + H*H )
		,a_side   = PI * M * (R[0] + R[1])
	)
	a_bottom + a_top + a_side
;

// calculate the surface area of a sphere
function area_sphere (r, d) =
	let( R = parameter_circle_r (r, d) )
	4*PI * R*R
;

// calculate the area of a quadratic pyramid
// with given height 'h' and the side length 'l', 'l2'
function area_pyramid_quadratic (h, l, l2=0) =
	l*l + l2*l2  +  (l + l2) * sqrt( 4*h*h + sqr( l - l2 ) )
;


// - Volume calculation:

// calculate the volume of a cube
function volume_cube (size) =
	size.x * size.y * size.z
;

// calculate the volume of a cylinder (or a cone)
function volume_cylinder (h, r1, r2, r, d, d1, d2) =
	let(
		 R = parameter_cylinder_r (r, r1, r2, d, d1, d2)
		,H = get_first_num (h, 1)
	)
	H/3 * PI * sqrt( R[0]*R[0] + R[0]*R[1] + R[1]*R[1] )
;

// calculate the volume of a sphere
function volume_sphere (r, d) =
	let( R = parameter_circle_r (r, d) )
	4/3*PI * R*R*R
;

// calculate the volume of a pyramid
// with given height 'h' and both areas 'a', 'a2'
function volume_pyramid (h, a, a2=0) =
	h/3 * (a + sqrt(a*a2) + a2)
;
