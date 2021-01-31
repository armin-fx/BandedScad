// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Funktionen zum Rechnen mit Komplexe Zahlen
//
// Aufbau als Liste:
// - kartesischen Koordinaten z = a + bi
//
//   [Realteil a, Imaginärteil b]
//
//                              (i*phi)
// - Polarkoordinaten z = r * e^         = r * ( cos(phi) + i*sin(phi) )
//   Um die Polarform von der Kartesischen Form unterscheiden zu können,
//   wird noch ein unbestimmter Wert ohne Bedeutung an die Liste angehangen.
//
//   [Radius r, Winkel phi in Grad, 0]
//
// Wird eine Reelle Zahl übergeben, wird daraus eine Komplexe Zahl erzeugt
//

// Get complex number
//
function get_cartesian (c) =
	is_num(c) ? [c, 0] // get_cartesian_from_number (c)
	:
	c[2]==undef ? c
	: // get_cartesian_from_polar (c)
		c[0] * [cos(c[1]), sin(c[1])]
;
//
function get_polar (c) =
	is_num(c) ? [c, 0, 0] // get_polar_from_number (c)
	:
	c[2]==undef ? // get_polar_from_cartesian (c)
		[norm(c), atan2(c[1],c[0]), 0]
	:	c
;
function get_cartesian_from_polar  (c) = c[0] * [cos(c[1]), sin(c[1])];
function get_cartesian_from_number (n) = [n, 0];
function get_polar_from_cartesian  (c) = [norm(c), atan2(c[1],c[0]), 0];
function get_polar_from_number     (n) = [n, 0, 0];

function get_real (c) =
	is_num(c) ? c // get_real_from_number    (c)
	:
	c[2]==undef ? // get_real_from_cartesian (c)
		c[0]
	:             // get_real_from_polar     (c)
		c[0] * cos(c[1])
;
function get_imaginary (c) =
	is_num(c) ? 0 // get_imaginary_from_number    (c)
	:
	c[2]==undef ? // get_imaginary_from_cartesian (c)
		c[1]
	:             // get_imaginary_from_polar     (c)
		c[0] * sin(c[1])
;
function get_real_from_cartesian      (c) = c[0];
function get_real_from_polar          (c) = c[0] * cos(c[1]);
function get_real_from_number         (n) = n;
function get_imaginary_from_cartesian (c) = c[1];
function get_imaginary_from_polar     (c) = c[0] * sin(c[1]);
function get_imaginary_from_number    (n) = 0;

// Complex conjugate
function c_conjugate (c) =
	is_num(c) ? [c, 0]
	:
	c[2]==undef ? // c_conjugate_cartesian (c)
		[c[0], -c[1]]
	:             // c_conjugate_polar     (c)
		[c[0], -c[1], 0]
;
function c_conjugate_cartesian (c) = [c[0], -c[1]];
function c_conjugate_polar     (c) = [c[0], -c[1], 0];

// Absolute value
function c_abs (c) =
	is_num(c) ? abs(c)
	:
	c[2]==undef ? // c_abs_cartesian (c)
		norm(c)
	:             // c_abs_polar     (c)
		c[0]
;
function c_abs_cartesian (c) = norm(c);
function c_abs_polar     (c) = c[0];

// Addition, Subtraction
function c_add (c, d) =
	// get_cartesian(c) + get_cartesian(d);
	 is_num(c)   ? [c, 0]
	:c[2]==undef ? c
	:              c[0] * [cos(c[1]), sin(c[1])]
	+
	 is_num(c)   ? [d, 0]
	:d[2]==undef ? d
	:              d[0] * [cos(d[1]), sin(d[1])]
;
function c_sub (c, d) =
	// get_cartesian(c) - get_cartesian(d);
	 is_num(c)   ? [c, 0]
	:c[2]==undef ? c
	:              c[0] * [cos(c[1]), sin(c[1])]
	-
	 is_num(c)   ? [d, 0]
	:d[2]==undef ? d
	:              d[0] * [cos(d[1]), sin(d[1])]
;
function c_add_cartesian (c, d) =
	c + d
;
function c_sub_cartesian (c, d) =
	c - d
;
function c_add_cartesian_number (c, n) =
	[c[0]+n, c[1]]
;
function c_sub_cartesian_number (c, n) =
	[c[0]-n, c[1]]
;
function c_add_number_cartesian (n, d) =
	[n+d[0], d[1]]
;
function c_sub_number_cartesian (n, d) =
	[n-d[0], -d[1]]
;
function c_add_polar (c, d) =
	let(
		e =	  c[0] * [cos(c[1]), sin(c[1])]
			+ d[0] * [cos(d[1]), sin(d[1])]
	)
	[norm(e), atan2(e[1],e[0]), 0]
;
function c_add_polar_2 (c, d) =
	let(
		,angle    = ( ( d[1]-c[1] )%360+360 + 180 )%360 - 180
		,d0_cos_ab = d[0] * cos(angle)
		,t        = sqrt( c[0]*c[0] + d[0]*d[0] + 2*c[0]*d0_cos_ab )
		,gamma    = sign(angle) * acos( (c[0]+d0_cos_ab) / t) + c[1]
	)
	[t, gamma, 0]
;
function c_sub_polar (c, d) =
	let(
		e =	  c[0] * [cos(c[1]), sin(c[1])]
			- d[0] * [cos(d[1]), sin(d[1])]
	)
	[norm(e), atan2(e[1],e[0]), 0]
;
function c_sub_polar_2 (c, d) =
	let(
		,angle     = ( ( d[1]-c[1] + 180 )%360+360 + 180 )%360 - 180
		,d0_cos_ab = d[0] * cos(angle)
		,t         = sqrt( c[0]*c[0] + d[0]*d[0] + 2*c[0]*d0_cos_ab )
		,gamma     = sign(angle) * acos( (c[0]+d0_cos_ab) / t) + c[1]
	)
	[t, gamma, 0]
;
function c_add_polar_to_cartesian (c, d) =
		  c[0] * [cos(c[1]), sin(c[1])]
		+ d[0] * [cos(d[1]), sin(d[1])]
;
function c_sub_polar_to_cartesian (c, d) =
		  c[0] * [cos(c[1]), sin(c[1])]
		- d[0] * [cos(d[1]), sin(d[1])]
;

// Multiplication
function c_mul (c, d) =
	is_num(c) ?
		is_num(d) ? [c*d, 0] :
		d[2]==undef ? // c_mul_cartesian_number (d, c)
			d * c
		:             // c_mul_polar_number     (d, c)
			[ d[0]*c, d[1], 0 ]
	:is_num(d) ?
		c[2]==undef ? // c_mul_cartesian_number (c, d)
			c * d
		:             // c_mul_polar_number     (c, d)
			[ c[0]*d, c[1], 0 ]
	:
	c[2]==undef ?
		d[2]==undef ? // c_mul_cartesian (c, d)
			[ c[0]*d[0]-c[1]*d[1]
			, c[0]*d[1]+c[1]*d[0] ]
		:             // c_mul_polar (get_polar_from_cartesian(c), d)
			[ norm(c)*d[0], atan2(c[1],c[0])+d[1], 0 ]
	:
		d[2]!=undef ? // c_mul_polar (c, d)
			[ c[0]*d[0], c[1]+d[1], 0 ]
		:             // c_mul_polar (c, get_polar_from_cartesian(d))
			[ c[0]*norm(d), c[1]+atan2(d[1],d[0]), 0 ]
;
function c_mul_cartesian (c, d) =
	[ c[0]*d[0]-c[1]*d[1]
	, c[0]*d[1]+c[1]*d[0] ]
;
function c_mul_cartesian_number (c, n) =
	c * n
;
function c_mul_polar (c, d) =
	[ c[0]*d[0], c[1]+d[1], 0 ]
;
function c_mul_polar_number (c, n) =
	[ c[0]*n, c[1], 0 ]
;
function c_mul_polar_to_cartesian (c, d) =
	let( a = c[1]+d[1] )
	c[0]*d[0] * [cos(a), sin(a)]
;

// Division
function c_div (c, d) =
	is_num(c) ?
		is_num(d) ? [c/d, 0] :
		d[2]==undef ? // c_div_number_cartesian (c, d)
			[ c*d[0], -c*d[1] ] / (d[0]*d[0] + d[1]*d[1])
		:             // c_div_number_polar     (c, d)
			[ c/d[0], -d[1], 0 ]
	:is_num(d) ?
		c[2]==undef ? // c_div_cartesian_number (c, d)
			[ c[0]*d, c[1]*d[0] ] / (d*d)
		:             // c_div_polar_number     (c, d)
			[ c[0]/d, c[1], 0 ]
	:
	c[2]==undef ?
		d[2]==undef ? // c_div_cartesian (c, d)
			[ c[0]*d[0]+c[1]*d[1]
			, c[1]*d[0]-c[0]*d[1]
			] / ( d[0]*d[0] + d[1]*d[1] )
		:             // c_div_polar (get_polar_from_cartesian(c), d)
			[ norm(c)/d[0], atan2(c[1],c[0])-d[1], 0 ]
	:
		d[2]!=undef ? // c_div_polar (c, d)
			[ c[0]/d[0], c[1]-d[1], 0 ]
		:             // c_div_polar (c, get_polar_from_cartesian(d))
			[ c[0]/norm(d), c[1]-atan2(d[1],d[0]), 0 ]
;
function c_div_cartesian (c, d) =
	[ c[0]*d[0]+c[1]*d[1]
	, c[1]*d[0]-c[0]*d[1]
	] / ( d[0]*d[0] + d[1]*d[1] )
;
function c_div_cartesian_number (c, n) =
	[ c[0]*n, c[1]*d[0] ] / (n*n)
;
function c_div_number_cartesian (n, d) =
	[ n*d[0], -n*d[1] ]
	/ ( d[0]*d[0] + d[1]*d[1] )
;
function c_div_polar (c, d) =
	[ c[0]/d[0], c[1]-d[1], 0 ]
;
function c_div_polar_number (c, n) =
	[ c[0]/n, c[1], 0 ]
;
function c_div_number_polar (n, d) =
	[ n/d[0], -d[1], 0 ]
;
function c_div_polar_to_cartesian (c, d) =
	let( a = c[1]-d[1] )
	c[0]/d[0] * [cos(a), sin(a)]
;

// square root
// return a list with 2 complex number
function c_sqrt (c) =
	is_num(c) ?
		let( s = [sqrt(c), 0] )
		[s, -s]
	:
	c[2]==undef ? // c_sqrt_cartesian (c)
		let(
		s =
			[              sqrt( ( c[0] + norm(c)) / 2 )
			, sign(c[1]) * sqrt( (-c[0] + norm(c)) / 2 ) ]
		)
		[s, -s]
	:   // c_sqrt_polar (c)
		let( s = [ sqrt(c[0]), c[1]/2, 0 ] )
		[s, -s]
;
function c_sqrt_cartesian (c) =
	let(
	s =
		[              sqrt( ( c[0] + norm(c)) / 2 )
		, sign(c[1]) * sqrt( (-c[0] + norm(c)) / 2 ) ]
	)
	[s, -s]
;
function c_sqrt_polar (c) =
	let( s = [ sqrt(c[0]), c[1]/2, 0 ] )
	[s, -s]
;

// square complex number
function c_sqr (c) =
	is_num(c) ? [c*c, 0]
	:
	c[2]==undef ? // c_sqr_cartesian (c)
		[ c[0]*c[0]-c[1]*c[1]
		, c[0]*c[1]*2 ]
	:              // c_sqr_polar (c)
		[ c[0]*c[0], c[1]*2, 0 ]
;
function c_sqr_cartesian (c) =
	[ c[0]*c[0]-c[1]*c[1]
	, c[0]*c[1]*2 ]
;
function c_sqr_polar (c) =
	[ c[0]*c[0], c[1]*2, 0 ]
;

