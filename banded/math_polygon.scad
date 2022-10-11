// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, zum Arbeiten mit Linien, Polygonzügen, Flächen
//

use <banded/helper_native.scad>
use <banded/list_algorithmus.scad>
use <banded/list_edit_item.scad>
use <banded/math_common.scad>
use <banded/math_vector.scad>
use <banded/math_matrix.scad>


// - Test für Linien und Strecken:

// gibt zurück, ob ein Punkt genau auf einer Linie ist,
// definiert durch 2 Punkte
// 2D oder 3D
function is_point_on_line (line, point) =
	point==line[0] ? true
	:
	is_nearly_collinear (line[1]-line[0], point-line[0])
;

// gibt zurück, ob ein Punkt genau auf einer Strecke ist,
// inclusive auf den Punkten
// 2D oder 3D
function is_point_on_segment (line, point) =
	point==line[0] || point==line[1] ? true
	:
	is_nearly_collinear (line[1]-line[0], point-line[0]) &&
	is_constrain(point, line[0], line[1])
;

// gibt zurück, ob ein Punkt genau in einer Ebene liegt
// aufgespannt mit 3 Punkten in einer Liste
function is_point_on_plane (points_3, point) =
	is_coplanar(points_3[0]-points_3[2],points_3[1]-points_3[2],point-points_3[2])
;

// gibt zurück, ob sich zwei Strecken kreuzen
// mit 'point' kann ein schon berechneter Schnittpunkt beider Geraden eingesetzt werden
// mit only=true kann angegeben werden, ob die Linie nicht parallel seinen dürfen
function is_intersecting (line1, line2, point, only) =
	is_collinear (line1[1]-line1[0], line2[1]-line2[0]) ?
		only==true ? false :
		let(
			a = get_gradient (line1),
			b = get_gradient (line2)
		)
		a!=b ? false
		:
		is_constrain (line2[0], line1[0], line1[1]) ||
		is_constrain (line2[1], line1[0], line1[1])
	:
	let(
		p = point!=undef ? point :
			get_intersecting_point (line1, line2)
	)
	p!=undef &&
	is_constrain_left (p, line1[0], line1[1]) &&
	is_constrain_left (p, line2[0], line2[1])
;


// - Linien und Strecken:


// Gibt die Steigung [m, c] einer Linie zurück
function get_gradient (line) =
	len(line)==2 ? get_gradient_2 (line) :
	len(line)==3 ? get_gradient_3 (line) :
	undef
;

// Gibt die Steigung [m, c] einer Linie in 2D zurück, (y = m*x + c )
//   m = Steigungsrate
//   c = Höhe der Linie beim Durchgang durch die Y Achse
// Senkrechte Linien gehen nicht.
function get_gradient_2 (line) =
	line[0].x==line[1].x ? // vertical line
		undef
	:
	let(
		m =   (line[1].y - line[0].y)
			/ (line[1].x - line[0].x),
		c = line[0].y - m * line[0].x
	)
	[m, c]
;
// Gibt die Steigung [m, c] einer Linie in 3D zurück, ([x,y] = m*z + c )
//   m = Steigungsrate der X-Achse und Y-Achse als Liste [m_x, m_y]
//   c = X-Y-Punkt auf der Linie bei Z=0
// Waagerechte Linien gehen nicht.
function get_gradient_3 (line) =
	line[0].z==line[1].z ? // line on XY-plane
		undef
	:
	line[0].x==line[1].x && line[0].y==line[1].y ? // line = Z-axis
		[[0,0], [line[0].x,line[0].y]]
	:
	line[0].x==line[1].x ? // line on YZ-plane
		let(
			n =	  (line[1].y - line[0].y)
				/ (line[1].z - line[0].z),
			c = line[0].x,
			d = line[0].y - n*line[0].z
		)
		[[0,n], [c,d]]
	:
	line[0].y==line[1].y ? // line on XZ-plane
		let(
			m =   (line[1].x - line[0].x)
				/ (line[1].z - line[0].z),
			c = line[0].x - m*line[0].z,
			d = line[0].y
		)
		[[m,0], [c,d]]
	:
		let(
			m =   (line[1].x - line[0].x)
				/ (line[1].z - line[0].z),
			n =   (line[1].y - line[0].y)
				/ (line[1].z - line[0].z),
			c = line[0].x - m*line[0].z,
			d = line[0].y - n*line[0].z
		)
		[[m,n], [c,d]]
;

// gibt den Kreuzungspunkt zurück, den zwei Geraden schneiden,
// definiert mit je 2 Punkten pro Gerade
// in 2D
function get_intersecting_point (line1, line2) =
	(line1[0].x==line1[1].x) ?
	(line2[0].x==line2[1].x) ? undef :
	get_intersecting_point (line2, line1)
	:
	(line2[0].x==line2[1].x) ?
		// line2 steht senkrecht auf der x-Achse, der x-Wert liegt damit fest
		let(
			a = get_gradient (line1),
			x = line2[0].x,
			y = a[0] * x + a[1]
		)
		[x, y]
	:
	let(
		a = get_gradient (line1),
		b = get_gradient (line2),
		x =	  (b[1] - a[1])
			/ (a[0] - b[0]),
		y = a[0] * x + a[1]
	)
	[x, y]
;


// - Streckenzüge:

// gibt die Länge einer Kurve zurück
function length_trace (points, path, closed=false) =
	let (
		is_path = path!=undef,
		size = is_path ? len(path) : len(points),
		pts  = is_path ? refer_list(points, path) : points
	)
	size<2 ? 0 :
	summation(
		[for (i=[0:1:size-2]) norm (pts[i+1]-pts[i]) ]
	)
	+ (closed==true ? norm (pts[size-1]-pts[0]) : 0)
;

// gibt die Länge einer Strecke zurück
function length_line (line) =
	norm (line[1]-line[0])
;

// Ermittelt die Normale eines Dreiecks
// definiert über 3 Punkte im 3D Raum
function get_normal_face (p1, p2, p3) =
	cross (p2-p1, p3-p1)
;


// - Daten von Strecken umwandeln:

// Wandelt eine Spur von Punkten in eine Liste mit Streckenzügen um
function points_to_lines (trace, closed=false) =
	let (
		size = len(trace)
	)
	closed!=true ?
		[ for (i=[0:1:size-2]) [trace[i],trace[i+1]] ]
	:	[ for (i=[0:1:size-1]) [trace[i],trace[(i+1)%size]] ]
		
;

// Verbindet Strecken in einer Liste miteinander zu einer Spur aus Punkten
function trace_lines (lines) =
	let (
		size = len(lines)
	)
	concat(
		lines[0],
		[ for (i=[1:1:size-1])
			if (lines[i-1][1]==lines[i][0])
				lines[i][1]
			else
				each lines[i]
		]
	)
;


// - Daten von Linien und Strecken ermitteln:

function distance_line (line, p) =
	 len(line[0])==3 ? distance_line_3d (line, p)
	:len(line[0])==2 ? distance_line_2d (line, p)
	:undef
;
function distance_line_2d (line, p) =
	p!=undef ? distance_line_2d (translate_points (line, -p), undef) :
	let (
		line_ = ! (line[0].x==line[1].x || line[0].y==line[1].y)
			?	line
			:	let(
					e = sqrt(2)/2,
					m = // matrix_rotate_z (45, short=true, d=2)
					[[e,-e],
					 [e, e]]
				)
				[ m * line[0], m * line[1] ],
		g    = get_gradient (line_), // [m, c]
		p0   = [-g[1]/g[0], g[1]],
		hypo = norm (p0),
		h    = hypo==0
			? 0
			: abs( p0.x * p0.y / hypo )
	)
	h
;
function distance_line_3d (line, p) =
	p!=undef ? distance_line_3d (translate_points (line, -p), undef) :
	let (
		m = matrix_rotate_to_vector (line[1]-line[0], backwards=true, short=true),
		p = m * line[0],
		d = norm ([p.x, p.y])
	)
	d
;

function nearest_point_line (line, p) =
	 len(line[0])==3 ? nearest_point_line_3d (line, p)
	:len(line[0])==2 ? nearest_point_line_2d (line, p)
	:undef
;
function nearest_point_line_2d (line, p) =
	p!=undef ?
		nearest_point_line_2d (translate_points (line, -p), undef)
		+ p :
	(line[0].x==line[1].x || line[0].y==line[1].y) ?
		// echo("rot 45°")
		let(
			e = sqrt(2)/2,
			m = // matrix_rotate_z (45, short=true, d=2)
			[[e,-e],
			 [e, e]]
		)
		nearest_point_line_2d ([ m * line[0], m * line[1] ]) * m
	:
	let (
		g    = get_gradient (line), // [m, c]
		p0   = [-g[1]/g[0], g[1]],
		hypo = norm (p0),
		h    = hypo==0
			? 0
			: abs( p0.x * p0.y / hypo ),
		p = hypo==0
			? [0,0]
			: unit_vector([-g[0], 1]) * abs(h) * sign(g[1])
	)
	p
;
function nearest_point_line_3d (line, p) =
	p!=undef ?
		nearest_point_line_3d (translate_points (line, -p), undef)
		+ p :
	let (
		m = matrix_rotate_to_vector (line[1]-line[0], backwards=true, short=true),
		q = m * line[0],
		r = [q.x, q.y, 0],
		s = r * m
	)
	s
;

function distance_segment (line, p) =
	p!=undef ? distance_segment (translate_points (line, -p), undef) :
	let (
		q = nearest_point_line (line)
	)
	is_point_on_segment (line, q)
		? norm(q)
		: min (norm(line[0]), norm(line[1]))
;

function nearest_point_segment (line, p) =
	p!=undef ?
		nearest_point_segment (translate_points (line, -p), undef)
		+ p :
	let (
		q = nearest_point_line (line)
	)
	is_point_on_segment (line, q) ? q :
	(norm(line[0])<norm(line[1])) ? line[0] : line[1]
;

function distance_trace (trace, p, closed=false) =
	p!=undef ? distance_trace (translate_points (trace, -p), undef, closed) :
	len(trace)==1 ? norm(trace[0]) :
	let (
		d = min (
			[ for (i=[0:1:len(trace)-2])
				distance_segment ([trace[i], trace[i+1]])
			]
			),
		D = closed==false ? d : min (d, distance_segment ([trace[0], trace[len(trace)-1]]) )
	)
	D
;

function nearest_point_trace (trace, p, closed=false) =
	p!=undef ?
		nearest_point_trace (translate_points (trace, -p), undef, closed)
		+ p :
	let (
		size = len(trace)
	)
	size==1 ? trace[0] :
	let (
		l =
			closed!=true ?
			[ for (i=[0:1:size-2])
				distance_segment ([trace[i], trace[i+1]])
			]
			:
			[ for (i=[0:1:size-1])
				distance_segment ([trace[i], trace[(i+1)%size]])
			],
		i = min_position (l),
		q = nearest_point_segment ([trace[i], trace[(i+1)%size]])
	)
	q
;
