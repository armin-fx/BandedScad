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

// Gibt die Steigung [m, c] einer Linie in 2D zurück, (y = m*x + c )
//   m = Steigungsrate
//   c = Höhe der Linie beim Durchgang durch die Y Achse
// Senkrechte Linien gehen nicht.
function get_gradient (line) =
	let(
		m =	  (line[1].y - line[0].y)
			/ (line[1].x - line[0].x),
		c = line[0].y - m * line[0].x
	)
	[m, c]
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
	summation_list(
		[for (i=[0:1:size-2]) norm (pts[i+1]-pts[i]) ]
	)
	+ (closed==true ? norm (pts[size-1]-pts[0]) : 0)
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

