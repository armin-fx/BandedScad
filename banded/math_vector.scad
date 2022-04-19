// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, zum Arbeiten mit Vektoren
//
//
// Hilfsfunktionen enthalten in OpenSCAD:
//
// norm()   - Betrag eines Vektors = die Länge des Vektors
// a[]+b[]  - Vektorielle Addition / Subtraktion
// a[]*b[]  - Skalarprodukt
// cross()  - Kreuzprodukt (Vektorielles Produkt)
//

use <banded/helper_native.scad>
use <banded/math_common.scad>
use <banded/math_matrix.scad>

include <banded/constants_user.scad>


// - Operationen mit Vektoren:

// Vektor normieren auf die Länge 1
function unit_vector (v) = v / norm(v);

// eingeschlossenen Winkel zweier Vektoren ermitteln
function angle_vector (v1, v2) =
	acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
// Winkel zweier Vektoren in der Ebene ermitteln entsprechend seiner Rotation
// gerechnet wird mit Linksrotation = gegen den Uhrzeigersinn
// wie in der Mathematik üblich
// Im 3D-Raum wird wie bei angle_vector() der eingeschlossene Winkel
// zurückgegeben. Die Rotationsachse kann über das Kreuzprodukt ermittelt werden.
function rotation_vector (v1, v2) = angle_left_vector (v1, v2);
function angle_left_vector (v1, v2) =
	(len(v1)!=2) || (cross(v1,v2) >= 0) ?
		      acos( (v1 * v2) / (norm(v1) * norm(v2)) )
	:	360 - acos( (v1 * v2) / (norm(v1) * norm(v2)) )
;
function angle_right_vector (v1, v2) = 360 - angle_left_vector(v1, v2);

// Return the angle around vector 'v' from points 'p1' to 'p2' in
// mathematical direction = counter clockwise.
// This is the angle you see if you show into the vector 'v' from the upper side,
// from point 'p1' to 'p2'.
// v  = vector, line defined from origin to this point
// p1 = first point, rotate begin
// p2 = second point, rotate end
function rotation_around_vector (v, p1, p2) =
	let(
		// u=rotate_backwards_to_vector_points([p1,p2], v),
		// q=projection_points(u),
		// a=rotation_vector (q[0], q[1])
		//
		nz_=v.z/norm(v),
		nz =is_num(nz_) ? nz_ : 1,
		//b=-acos(nz),       // inclination angle
		c=-atan2(v.y,v.x), // azimuthal angle
		//
		sinb  = -sqrt(1-nz*nz),
		cosb  = nz,
		sinc  = sin(c),
		cosc  = cos(c),
		//
		q1=[ (p1.x*cosc - p1.y*sinc)*cosb + p1.z*sinb
		    , p1.x*sinc + p1.y*cosc ],
		q2=[ (p2.x*cosc - p2.y*sinc)*cosb + p2.z*sinb
		    , p2.x*sinc + p2.y*cosc ],
		//
		a=angle_left_vector (q1, q2)
	)
	a
;

// Get angle around line from points 'p1' to 'p2'
// line = 2 point list, line defined from first point to second point
// p1   = first point, rotate begin
// p2   = second point, rotate end
function rotation_around_line (line, p1, p2) =
	rotation_around_vector (
		line[1]-line[0],
		p1     -line[0],
		p2     -line[0])
;

// rechnet das Kreuzprodukt von n-dimensionale Vektoren aus
// mit n-1 Vektoren in einer Liste 'list'
// Besonderheit:
// Verwendet in jeder Dimension das Rechtshandsystem.
// Werden die nachfolgenden n-1 Einheitsvektoren übergeben,
// wird der fehlende letzte Einheitsvektor geliefert.
function cross_universal (list) =
	list==undef ? undef
	: len(list[0])==2 ? [-list[0].y,list[0].x]
	: len(list[0])==3 ? cross(list[0], list[1])
	: len(list[0]) >3 ?
		determinant( concat(
			 [ for (i=[0:1:len(list[0])-2]) list[i] ]
			,[ identity_matrix( len(list[0]) ) ]
		) )
	: undef
;

// rechnet das Spatprodukt aus
function triple_product (a, b, c) = a * cross(b, c) ;

// Wählt aus 3 Vektoren die Reihe nach eine Achse aus
function pick_vector (vx, vy, vz) = [vx.x, vy.y, vz.z] ;

// - Test für Vektoren und Linien :

// Testet, ob zwei Vektoren in die gleiche Richtung oder genau entgegengesetzt zeigen.
function is_collinear (v1, v2) =
	let(
		 u1 = v1 / norm(v1) // = unit_vector (v1)
		,u2 = v2 / norm(v2) // = unit_vector (v2)
	)
	u1==u2 || u1==-u2
;
// Testet, ob zwei Vektoren näherungsweise in die gleiche Richtung oder genau entgegengesetzt zeigen.
//   deviation = Abweichung der Vektoren (als Verhältnis - Abweichung pro längster Vektor)
//               Standart = Rundungsfehler ausgleichen
function is_nearly_collinear (v1, v2, deviation=deviation) =
	let(
		 u1 = v1 / norm(v1)
		,u2 = v2 / norm(v2)
	)
	norm(u1-u2)<=deviation || norm(u1+u2)<=deviation
;

// Testet im 3D Raum ob 3 aufgespannte Vektoren in der Ebene liegen
function is_coplanar (v1, v2, v3) =
	( v1 * cross(v2, v3) ) == 0
;
// Testet im 3D Raum ob 3 aufgespannte Vektoren näherungsweise in der Ebene liegen
function is_nearly_coplanar (v1, v2, v3, deviation=deviation) =
	abs ( v1 * cross(v2, v3) ) <= deviation
;

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

// - Euklidische Norm:

// Euklidische Norm umkehren
// n = "Diagonale"
// v = "Kathete" oder Liste von "Katheten"
function reverse_norm (n, v) =
	 is_num(v)   ? sqrt( n*n - v*v )
	:!(len(v)>0) ? n
	:              sqrt( n*n + reverse_norm_intern(v))
;
function reverse_norm_intern (v, index=0) =
	index==len(v)-1 ?
		0 - v[index]*v[index]
	:	0 - v[index]*v[index] + reverse_norm_intern(v, index+1)
;

// gibt die quadrierte Euklidische Norm zurück
function norm_sqr (v) =
	let( n = norm(v) )
	n*n
;

// gibt die maximal mögliche Raumdiagonale zurück
function max_norm (list) = norm(diff_axis_list(list));

// gibt die quadrierte maximal mögliche Raumdiagonale zurück
function max_norm_sqr (list) =
	let( l = norm(diff_axis_list(list)) )
	l*l
;

