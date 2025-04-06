// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, zum Arbeiten mit Linien, Polygonzügen, Flächen
//

use <banded/helper_native.scad>
use <banded/list_algorithm.scad>
use <banded/list_edit_item.scad>
use <banded/math_common.scad>
use <banded/math_vector.scad>
use <banded/math_matrix.scad>


// - Test für Linien, Strecken und Flächen:

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
function is_point_on_segment (line, point, ends=0) =
	point==line[0] ? ends<=0 :
	point==line[1] ? ends>=0 :
	//
	is_nearly_collinear (line[1]-line[0], point-line[0]) &&
	(
		ends<0 ? is_constrain_left (point, line[0],line[1]) :
		ends>0 ? is_constrain_right(point, line[0],line[1]) :
		/* ==0*/ is_constrain      (point, line[0],line[1])
	)
;

// gibt zurück, ob ein Punkt genau in einer Ebene liegt
// aufgespannt mit 3 Punkten in einer Liste
function is_point_on_plane (points, point) =
	is_coplanar(points[0]-points[2], points[1]-points[2], point-points[2])
;

// gibt zurück, ob ein Punkt oberhalb einer Ebene liegt
// aufgespannt mit 3 Punkten in einer Liste
function is_point_upper_plane (points, test_point) =
	let(
		o=points[0],
		l=points[1]-o,
		r=points[2]-o,
		p=test_point -o,
		n=cross(l,r),
		
		/* version 1
		u=rotate_backwards_to_vector_points([p], n)[0],
		bool=u.z > deviation // prevent rounding error
		//*/
		
		//* version 2
		nz_=n.z/norm(n),
		nz =is_num(nz_) ? nz_ : 1,
		//b=-acos(nz),       // inclination angle
		c=-atan2(n.y,n.x), // azimuthal angle
		
		/* version 2-1
		q=rotate_z_points([p],c)[0],
		u=rotate_y_points([q],b)[0],
		bool=u.z > deviation // prevent rounding error
		//*/
		
		//* version 2-2
		sinb  = -sqrt(1-nz*nz),
		cosb  = nz,
		sinc  = sin(c),
		cosc  = cos(c),
		//
		z=(-p.x*cosc + p.y*sinc )*sinb + p.z*cosb,
		bool=z > deviation // prevent rounding error
		//*/
	)
	bool
;

// gibt zurück, ob sich zwei Strecken kreuzen
// mit 'point' kann ein schon berechneter Schnittpunkt beider Geraden eingesetzt werden
// mit no_parallel=true kann angegeben werden, ob die Linie nicht parallel seinen dürfen, Standart=false
// in 2D
function is_intersection_segments (line1, line2, point, no_parallel=false, ends=0) =
	is_collinear (line1[1]-line1[0], line2[1]-line2[0]) ?
		no_parallel==true ? false :
		let(
			a = line1[0].x==line1[1].x ? line1[0].x : get_gradient_2d (line1),
			b = line2[0].x==line2[1].x ? line2[0].x : get_gradient_2d (line2)
		)
		a!=b ? false
		:
		is_constrain (line2[0], line1[0],line1[1]) ||
		is_constrain (line2[1], line1[0],line1[1]) ||
		is_constrain (line1[0], line2[0],line2[1])
	:
	point==undef && ends==0 ?
		 cross( line1[0]-line2[0], line1[1]-line2[0]) *
		-cross( line1[0]-line2[1], line1[1]-line2[1]) >= 0
		&&
		 cross( line2[0]-line1[0], line2[1]-line1[0]) *
		-cross( line2[0]-line1[1], line2[1]-line1[1]) >= 0
	:
	let(
		p = point!=undef ? point :
			get_intersection_lines (line1, line2)
	)
	(p!=undef && p!=false && p!=true) &&
	(
		ends==0  ? is_constrain       (p, line1[0],line1[1]) && is_constrain       (p, line2[0],line2[1]) :
		ends< 0  ? is_constrain_left  (p, line1[0],line1[1]) && is_constrain_left  (p, line2[0],line2[1]) :
		/*ends>0*/ is_constrain_right (p, line1[0],line1[1]) && is_constrain_right (p, line2[0],line2[1])
	)
;

function is_intersection_polygon_segment (points, line, path, without) =
	let (
		size = path==undef ? len(points) : len(path),
		crossing =
			 without==undef
			?	path==undef
				? [for (i=[0:1:size-1])
					if( is_intersection_segments( [points[     i ],points[     (i+1)%size] ], line) ) i ]
				: [for (i=[0:1:size-1])
					if( is_intersection_segments( [points[path[i]],points[path[(i+1)%size]]], line) ) i ]
			:without[0]==undef
			?	path==undef
				? [for (i=[0:1:size-1])
					if( (i!=without) && ((i+1)%size!=without) )
					if( is_intersection_segments( [points[     i ],points[     (i+1)%size] ], line) ) i ]
				: [for (i=[0:1:size-1])
					if( (i!=without) && ((i+1)%size!=without) )
					if( is_intersection_segments( [points[path[i]],points[path[(i+1)%size]]], line) ) i ]
			:	path==undef
				? [for (i=[0:1:size-1])
					if( [ for (w=without) if ( (i!=w) && ((i+1)%size!=w) ) w ] == without )
					if( is_intersection_segments( [points[     i ],points[     (i+1)%size] ], line) ) i ]
				: [for (i=[0:1:size-1])
					if( [ for (w=without) if ( (i!=w) && ((i+1)%size!=w) ) w ] == without )
					if( is_intersection_segments( [points[path[i]],points[path[(i+1)%size]]], line) ) i ]
	)
	crossing != []
;

// in 2D
// - 'rotation'
//   - ==0 - left rotation or right rotation
//   -  >0 - only left rotation, mathematical rotation
//   -  <0 - only right rotation, clockwise rotation
function is_point_inside_triangle (points, point, border=true, rotation=0) =
	let (
		a0 = cross(points[0]-point,points[1]-point),
		a1 = cross(points[1]-point,points[2]-point),
		a2 = cross(points[2]-point,points[0]-point)
	//	,at = cross(points[1]-points[0], points[2]-points[0])
	)
	border==true
	?	(rotation>=0 && a0>=0 && a1>=0 && a2>=0) || (rotation<=0 && a0<=0 && a1<=0 && a2<=0)
	:	(rotation>=0 && a0>0  && a1>0  && a2>0 ) || (rotation<=0 && a0<0  && a1<0  && a2<0 )
;

// testet, ob ein Punkt innerhalb der Umrandung eines Polygonzuges in der Ebene ist
// die Umrandung darf sich nicht selbst überschneiden
function is_point_inside_polygon (points, p, path) =
	len(points[0])==2 ?
		// 2D:
		is_point_inside_polygon_2d (points, p, path)
	:	// 3D:
		is_point_inside_polygon_3d (points, p, path)
;
function is_point_inside_polygon_2d (points, p, path) =
	is_point_inside_polygon_2d_intern (points, p, path,
		p1   = (path==undef ? points[0]   : points[ path[0] ]) - p,
		size = (path==undef ? len(points) : len(path))
	)
;
function is_point_inside_polygon_2d_intern (points, p, path, p1, size=0, i=0, count=0) =
	i>=size ? (count/2)%2!=0 :
	//
	// Die Linie vom Punkt aus zum Rand hin auf Kreuzungen testen.
	// Durchläuft dabei eine horizontale Linie nach links
	// Alle Kreuzungen durchzählen.
	// Punktetreffer gesondert behandeln, hier lauern tückische Sonderfälle.
	//
	let(
	//	p1 = (path==undef ? points[  i       ] : points[ path[  i       ] ]) - p,
		p2 = (path==undef ? points[(i+1)%size] : points[ path[(i+1)%size] ]) - p
	)
	// Punkt genau auf dem Streckenabschnitt            -> raus, gefunden
	is_point_on_segment ([p1,p2], [0,0] ) ? true :
	//
	// - komplett rechts vom Punkt,                     -> weiter
	(p1.x>0 && p2.x>0) ? is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1, count) :
	// - durchkreuzt nicht die Linie,                   -> weiter
	p1.y*p2.y > 0      ? is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1, count) :
	//
	// - Punktetreffer gesondert behandeln:
	//   - Punkte werden automatisch zweimal gezählt, 1 je Seite
	p1.y==0 || p2.y==0 ?
		// - horizontale Durchgänge nicht zählen    	-> weiter
		p1.y==0 && p2.y==0 ? is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1, count) :
		//
		p1.y==0 ?
			p1.x>0 ?
				// - Punkt außerhalb            		-> weiter
				is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1, count) :
				// - trifft ersten Punkt        		-> zählen
				//   - Treffer zählen
				//   - Seitendurchgang berücksichtigen:
				//     - anderes Ende oberhalb:  1 abziehen
				//     - anderes Ende unterhalb: 1 zuzählen
				//     - beim Treffer am anderen Punkt wird genauso verfahren
				//     - zählt dadurch nur einen kompletten Durchgang durch den Rand
				is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1
					, count + 1 + ( p2.y==0 ? 0 : p2.y>0 ? -1:1)
				) :
		// p2.y==0 ?
			p2.x>0 ?
				// - Punkt außerhalb            		-> weiter
				is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1, count) :
				// - trifft zweiten Punkt       		-> zählen
				//   - Treffer zählen, Seitendurchgang berücksichtigen
				is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1
					, count + 1 + ( p1.y==0 ? 0 : p1.y>0 ? -1:1)
				) :
	//
	// - Liniendurchgang, doppelt zählen                -> zählen
	p1.x-p1.y*(p1.x-p2.x)/(p1.y-p2.y) < 0 ?
		is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1
			, count+2
		) :
	// - Ende                                           -> weiter
		is_point_inside_polygon_2d_intern (points, p, path, p2, size, i+1, count)
;
// Alle Punkte müssen sich in der gleichen Ebene befinden.
// Eventuell vorher nachprüfen
function is_point_inside_polygon_3d (points, p, path) =
	let (
		trace    = (path==undef) ? points : select (points, path),
		size     = len(trace),
		// TODO test 3 points they span 3 lines whether they are not collinear
		n        = normal_triangle (points=trace), // function use only first 3 points
		m_flat   = matrix_rotate_to_vector (n, backwards=true, short=true),
		points_flat = projection_points ( multmatrix_points (trace, m_flat), plane=true ),
		p_flat      = projection_point  ( multmatrix_point  (p    , m_flat), plane=true )
	)
	is_point_inside_polygon_2d (points_flat, p_flat)
;

// testet, ob ein Punkt innerhalb der Oberfläche eines Polyeders ist
// Bedingung dieser Funktion: der Polyeder muss eine konvexe Hülle sein
function is_point_inside_polyhedron_hulled (points, triangles, point, i=0) =
	len(triangles)==0 ? false :
	is_point_inside_polyhedron_hulled_intern (points, triangles, point, len(triangles)-1)
;
function is_point_inside_polyhedron_hulled_intern (points, triangles, point, i=-1) =
	i<0 ? true  :
	is_point_upper_plane ( select(points,triangles[i]), point) ? false :
	is_point_inside_polyhedron_hulled_intern (points, triangles, point, i-1)
;

// gibt 'true' zurück, wenn ein Dreieck im mathematischen Drehsinn angeordnet ist
// und 'false' im Uhrzeigersinn
// in 2D
function is_math_rotation_triangle (points) =
	cross (points[1]-points[0], points[2]-points[0]) > 0
;

// in 2D
function is_math_rotation_polygon (trace) =
	let (
		// the minimum position can guarantie that
		// - the triangle is at the outer line,
		//   not any "circle" that rotates otherwise in the inside
		// - the triangle has at this point always an angle < 180°
		//   or. the triangle is not in one line
		 minpos = min_position (trace)
		,size   = len(trace)
	)
	is_math_rotation_triangle ([ trace[(minpos-1+size)%size], trace[minpos], trace[(minpos+1)%size]])
;


// - Linien und Strecken und Flächen:

// Gibt die Steigung [c, m] einer Linie zurück
function get_gradient (line) =
	len(line)==2 ? get_gradient_2d (line) :
	len(line)==3 ? get_gradient_3d (line) :
	undef
;

// Gibt die Steigung [c, m] einer Linie in 2D zurück, (y = m*x + c )
//   m = Steigungsrate
//   c = Höhe der Linie beim Durchgang durch die Y Achse
// Senkrechte Linien gehen nicht.
function get_gradient_2d (line) =
	line[0].x==line[1].x ? // vertical line
		undef
	:
	let(
		m =   (line[1].y - line[0].y)
			/ (line[1].x - line[0].x),
		c = line[0].y - m * line[0].x
	)
	[c, m]
;
// Gibt die Steigung [c, m] einer Linie in 3D zurück, ([x,y] = m*z + c )
//   m = Steigungsrate der X-Achse und Y-Achse als Liste [m_x, m_y]
//   c = X-Y-Punkt auf der Linie bei Z=0
// Waagerechte Linien gehen nicht.
function get_gradient_3d (line) =
	line[0].z==line[1].z ? // line on XY-plane
		undef
	:
	line[0].x==line[1].x && line[0].y==line[1].y ? // line = Z-axis
		[[line[0].x,line[0].y], [0,0]]
	:
	line[0].x==line[1].x ? // line on YZ-plane
		let(
			n =	  (line[1].y - line[0].y)
				/ (line[1].z - line[0].z),
			c = line[0].x,
			d = line[0].y - n*line[0].z
		)
		[[c,d], [0,n]]
	:
	line[0].y==line[1].y ? // line on XZ-plane
		let(
			m =   (line[1].x - line[0].x)
				/ (line[1].z - line[0].z),
			c = line[0].x - m*line[0].z,
			d = line[0].y
		)
		[[c,d], [m,0]]
	:
		let(
			m =   (line[1].x - line[0].x)
				/ (line[1].z - line[0].z),
			n =   (line[1].y - line[0].y)
				/ (line[1].z - line[0].z),
			c = line[0].x - m*line[0].z,
			d = line[0].y - n*line[0].z
		)
		[[c,d], [m,n]]
;

// gibt den Kreuzungspunkt zurück, den zwei Geraden schneiden,
// definiert mit je 2 Punkten pro Gerade
// in 2D
// Rückgaben:
// - Geraden schneiden sich:    den Schnittpunkt beider Geraden
// - liegen genau übereinander: true
// - parallel zueinander      : false
function get_intersection_lines (line1, line2) =
	(	 line1[0].x==line1[1].x) ?
		(line2[0].x==line2[1].x) ? (line1[0].x==line2[0].x) ? true : false : // <- both parallel
		get_intersection_lines (line2, line1)
	:
	(line2[0].x==line2[1].x) ?
		// line2 steht senkrecht auf der x-Achse, der x-Wert liegt damit fest
		let(
			a = get_gradient_2d (line1),
			x = line2[0].x,
			y = a[1] * x + a[0]
		)
		[x, y]
	:
	let(
		a = get_gradient_2d (line1),
		b = get_gradient_2d (line2)
	)
	a[1]==b[1] ? a[0]==b[0] ? true : false : // <- both parallel
	let(
		x =	  (b[0] - a[0])
			/ (a[1] - b[1]),
		y = a[1] * x + a[0]
	)
	[x, y]
;

// gibt den Schnittpunkt einer Geraden durch einer Fläche zurück
// Die Fläche wird definiert mit 3 Punkten
// Die Linie wird definiert mit 2 Punkten
function get_intersection_line_plane (points, line) =
	let (
		n   = normal_triangle (points=points),
		l_a = translate_points        (line, -points[0]),
		l_b = rotate_to_vector_points (l_a, n, backwards=true),
		p_b = [ concat ( get_gradient_3d(l_b)[0], 0) ],
		p_a = rotate_to_vector_points (p_b, n, backwards=false),
		p   = translate_points        (p_a, points[0])
	)
	p[0]
;


// - Streckenzüge:

// gibt die Länge einer Strecke zurück
function length_line (line) =
	norm (line[1]-line[0])
;

// gibt die Länge einer Kurve zurück
function length_trace (points, path, closed=false) =
	let (
		is_path = path!=undef,
		size = is_path ? len(path) : len(points),
		pts  = is_path ? select(points, path) : points
	)
	size<2 ? 0 :
	summation(
		[for (i=[0:1:size-2]) norm (pts[i+1]-pts[i]) ]
	)
	+ (closed==true ? norm (pts[size-1]-pts[0]) : 0)
;

function midpoint_2 (p1, p2)     = (p1+p2   )  / 2;
function midpoint_3 (p1, p2, p3) = (p1+p2+p3)  / 3;
function midpoint_line (l)       = (l[0]+l[1]) / 2;

// Ermittelt die Position einer Geraden
// ab einem bestimmten Abstand vom ersten Punkt aus.
// Größere Längen werden extrapoliert
function position_line (line, length) =
	let (
		l = norm (line[1]-line[0]),
		t = length/l
	)
	  line[0] * (1-t)
	+ line[1] * t

;

// Ermittelt die Position eines Streckenzuges
// ab einem bestimmten Abstand vom ersten Punkt aus.
// Gibt 'undef' zurück, wenn der Abstand außerhalb des Streckenzuges ist.
// Wenn die Enden verbunden sind (closed=true), gibt es die Position
// zurück entsprechend der Umrundungen.
//
// Rückgabe in Punkt-Richtungs-Form [Punkt, Vektor]
// - Punkt:  Position des Streckenzuges an der gewünschten Länge
// - Vektor: Richtung des Streckenabschnitts an der Position, ungenormt
function position_trace (points, path, length, closed=false) =
	let (
		is_path = path!=undef,
		size = is_path ? len(path) : len(points)
	)
	size<2 ? undef :
	let (
		pts_ = is_path ? select(points, path) : points,
		pts  = closed!=true ? pts_ : [each pts_, pts_[0]],
		l    = length_trace (pts),
		Length = closed!=true ? length : mod (length, l)
	)
	Length>l || Length<0 ? undef :
	position_trace_intern (pts, Length, size + (closed!=true ? 0:1) )
;
function position_trace_intern (points, length, size, i=0) =
	i>=size ? undef :
	let (
		l = norm (points[i+1]-points[i])
	)
	length>l
		? position_trace_intern (points, length-l, size, i+1)
		: [ position_line ([points[i],points[i+1]], length)
		  , points[i+1]-points[i]
		  ]
;


// - Daten von Strecken umwandeln:

// Wandelt eine Spur von Punkten in eine Liste mit Streckenzügen um
function trace_to_lines (trace, closed=false) =
	let (
		size = len(trace)
	)
	closed!=true ?
		[ for (i=[0:1:size-2]) [trace[i],trace[i+1]] ]
	:	[ for (i=[0:1:size-1]) [trace[i],trace[(i+1)%size]] ]
		
;

// Verbindet Strecken in einer Liste miteinander zu einer Spur aus Punkten
function lines_to_trace (lines) =
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

// Linie in Zweipunkteform unwandeln in Punkt-Richtungs-Form [Punkt, Vektor]
function line_to_vector (line) =
	[line[0], line[1]-line[0]]
;

// Punkt-Richtungs-Form umwandeln in Zweipunkteform
function vector_to_line (vector) =
	[vector[0], vector[0]+vector[1]]
;


// - Daten von Linien und Strecken ermitteln:

// gibt den kürzesten Abstand eines Punktes zu einer Gerade zurück
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
		g    = get_gradient_2d (line_), // [c, m]
		p0   = [-g[0]/g[1], g[0]],
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

// gibt den Punkt auf einer Gerade liegend zurück,
// der den kürzesten Abstand zum Punkt p hat
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
		g    = get_gradient_2d (line), // [c, m]
		p0   = [-g[0]/g[1], g[0]],
		hypo = norm (p0),
		h    = hypo==0
			? 0
			: abs( p0.x * p0.y / hypo ),
		p = hypo==0
			? [0,0]
			: unit_vector([-g[1], 1]) * abs(h) * sign(g[0])
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
