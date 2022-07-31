// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// stellt Funktionen bereit,
// steuern die Auflösungsgenauigkeit für linear_extrude()

//use <banded/extend_logic_helper.scad>
//
use <banded/math_common.scad>
use <banded/math_vector.scad>
use <banded/helper_native.scad>
use <banded/draft_transform_basic.scad>


// copied from OpenSCAD source file 'calc.cc'
//
// arguments:
//   points - point list of the 2D shape
//   height - height of extruded object as numeric value
//   twist  - twist of extrusion in degrees
//   scale  - scale of top 2D shape as 2D list, default is no scale = [1,1]
function get_slices_extrude (points, height=100, twist=0, slices=0, scale=[1,1], fn, fs, fa) =
	(slices!=undef && slices>0) ? slices :
	let(
		Scale = parameter_scale (scale, 2)
	)
	//
	(twist!=undef && twist!=0) ?
		let (
			P = concat( points, [[0,0]] ),
			max_r1_sqr = max_norm_sqr( P )
		)
		// Calculate Helical curve length for Twist with no Scaling
		// **** Don't know how to handle twist with non-uniform scaling, ****
		// **** so just use this straight helix calculation anyways.     ****
		((Scale.x==1 && Scale.y==1) || Scale.x!=Scale.y) ?
			get_slices_helix (max_r1_sqr, height, twist, fn, fs, fa)
		:	// uniform scaling with twist, use conical helix calculation
			get_slices_conical_helix (max_r1_sqr, height, twist, Scale.x, fn, fs, fa)
	: (Scale.x!=Scale.y) ?
		// Non uniform scaling, w/o twist
		let (
			// delta from before/after scaling
			P = concat( points, [[0,0]] ),
			d1 = diff_axis_list (P),
			d2 = scale_points ([d1], Scale) [0],
			max_delta_sqr = norm_sqr (d1 - d2)
		)
		get_slices_diagonal (max_delta_sqr, height, fn, fs)
	:
		// uniform or [1,1] scaling w/o twist needs only one slice
		1
;

// copied from OpenSCAD source file 'calc.cc'
//
function get_slices_helix (r_sqr, height, twist, fn, fs, fa) =
	let (
		abs_twist = abs (twist),
		// 180 twist per slice is worst case, guaranteed non-manifold.
		// Make sure we have at least 3 slices per 360 twist
		min_slices = max (ceil (abs_twist / 120.0), 1)
	)
	sqrt(r_sqr)<epsilon ? min_slices
	: (fn > 0) ? max( min_slices, ceil (abs_twist / 360.0 * fn) ) 
	: let (
		fa_slices = ceil (abs_twist / fa),
		fs_slices = ceil (helix_arc_length(r_sqr, height, abs_twist) / fs)
	)
	max( min(fa_slices, fs_slices), min_slices )
;

// copied from OpenSCAD source file 'calc.cc'
//
function get_slices_conical_helix (r_sqr, height, twist, scale, fn, fs, fa) =
	let(
		abs_twist  = abs(twist),
		r          = sqrt(r_sqr),
		min_slices = max( ceil(abs_twist / 120.0), 1)
	)
	(r < epsilon) ? min_slices
	: (fn > 0) ? max( min_slices, ceil (abs_twist * fn / 360) )
	:
	// Spiral length equation assumes starting from theta=0
	// Our twist+scale only covers a section of this length (unless scale=0).
	// Find the start and end angles that our twist+scale correspond to.
	// Use similar triangles to visualize cross-section of single vertex,
	// with scale extended to 0 (origin).
	//
	// (scale < 1)         (scale > 1)
	//                      ______t_  1.5x (Z=h)
	//  0x                 |    | /
	// |\                  |____|/
	// | \                 |    / 1x  (Z=0)
	// |  \                |   /
	// |___\ 0.66x (Z=h)   |  /            t is angle of our arc section (twist, in rads)
	// |   |\              | /             E is angle_end (total triangle base length)
	// |___|_\  1x (Z=0)   |/ 0x           S is angle_start
	//       t
	//
	// E = t*1/(1-0.66)=3t  E = t*1.5/(1.5-1)  = 3t
	// B = E - t            B = E - t
	//
	let (
		rads = abs_twist * radian_per_degree,
		angle_end =
			(scale > 1) ? rads * scale / (scale - 1) :
			(scale < 1) ? rads / (1 - scale) :
			assert ("Don't calculate conical slices on non-scaled extrude!")
			undef,
		angle_start = angle_end - rads,
		a = r / angle_end, // spiral scale coefficient
		spiral_length = archimedes_length(a, angle_end) - archimedes_length(a, angle_start),
		// Treat (flat spiral_length,extrusion height) as (base,height) of a right triangle to get diagonal length.
		total_length = norm ([spiral_length, height]),
		//
		fs_slices = ceil (total_length / fs),
		fa_slices = ceil (twist / fa)
	)
	max( min(fa_slices, fs_slices), min_slices)
;

// copied from OpenSCAD source file 'calc.cc'
//
// For linear_extrude with non-uniform scale (and no twist)
// Either use $fn directly as slices,
// or divide the longest diagonal vertex extrude path by $fs
//
// dr_sqr - the largest 2D delta (before/after scaling) for all vertices, squared.
// note: $fa is not considered since no twist
//       scale is not passed in since it was already used to calculate the largest delta.
function get_slices_diagonal (delta_sqr, height, fn, fs) =
	let (
		min_slices = 1
	)
	(sqrt(delta_sqr) < epsilon) ? min_slices :
	(fn > 0) ? max (min_slices, fn) :
	let (
		fs_slices = ceil( sqrt(delta_sqr + height * height) / fs)
	)
	max (fs_slices, min_slices)
;

// copied from OpenSCAD source file 'calc.cc'
//
// https://mathworld.wolfram.com/Helix.html
// For a helix defined as:         F(t) = [r*cost(t), r*sin(t), c*t]  for t in [0,T)
// The helical arc length is          L = T * sqrt(r^2 + c^2)
// Where its pitch is             pitch = 2*PI*c
// Pitch is also height per turn: pitch = height / (twist/360)
// Solving for c gives                c = height / (twist*PI/180)
// Where (twist*PI/180) is just twist in radians, aka "T"
function helix_arc_length (r_sqr, height, twist) =
	let (
		T = twist * radian_per_degree,
		c = height / T
	)
	T * sqrt(r_sqr + c*c)
;

// copied from OpenSCAD source file 'calc.cc'
//
// For linear_extrude with twist and uniform scale (scale_x == scale_y),
// to calculate the limit imposed by special variable $fs, we find the
// total length along the path that a vertex would follow.
// The XY-projection of this path is a section of the Archimedes Spiral.
// https://mathworld.wolfram.com/ArchimedesSpiral.html
// Using the formula for its arc length, then pythagorean theorem with height
// should tell us the total distance a vertex covers.
function archimedes_length (a, theta) =
	0.5 * a * (theta * sqrt(1 + theta * theta) + asinh(theta))
;
