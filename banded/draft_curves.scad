// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen, die Kurven beschreiben

use <banded/extend_logic.scad>
use <banded/helper.scad>
use <banded/math_common.scad>
use <banded/math_number.scad>
use <banded/math_polygon.scad>
use <banded/draft_transform_basic.scad>

// - Kurven:

// ermittelt den Punkt einer Bezierkurve n. Grades abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., pn] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, pn = Endpunkt der Kurve
//       Das Array darf nicht weniger als n+1 Elemente enthalten
//   n - Angabe des Grades der Bezierkurve
//       es werden nur die Punkte bis p[n] genommen
//       ohne Angabe von n wird der Grad anhand der Größe des Arrays genommen
//
function bezier_point (t, p, n) =
	 (!is_list(p)) ? undef
	:(n==undef) ?
		(len(p)<1) ? undef
		:bezier_point_intern (t, p, len(p)-1, len(p)-1)
	:
		 (n <0)       ? undef
		:(len(p)<n+1) ? undef
		:bezier_point_intern (t, p, n, n)
;
function bezier_point_intern (t, p, n, j) =
	 (j <0) ? undef
	:(j==0) ? p[0] * (pow((1-t), n))
	:         p[j] * (pow((1-t), n-j) * pow(t, j) * binomial_coefficient(n, j))
	          + bezier_point_intern(t, p, n, j-1) 
;

// gibt ein Array mit den Punkten einer Bezierkurve aus
// Argumente:
//   p - [p0, ..., pn] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, pn = Endpunkt der Kurve
//       Das Array darf nicht weniger als n+1 Elemente enthalten
//   n - Angabe des Grades der Bezierkurve
//       es werden nur die Punkte bis p[n] genommen
//       ohne Angabe von n wird der Grad anhand der Größe des Arrays genommen
//   slices - Bezierkurve wird in diese Anzahl an Punkten aufgeteilt, mindestens 2 Punkte
//       ohne Angabe werden die Anzahl der Punkte von $fn, $fa, $fs ermittelt (grob implementiert)
//
function bezier_curve (p, n, slices) =
	let (
	Slices =
		slices==undef ? max(2, get_slices_circle_current  (max_norm(p)/4) ) :
		slices=="x"   ? max(2, get_slices_circle_current_x(max_norm(p)/4) ) :
		slices< 2     ? 2 :
		slices
	)
	[for (i = [0 : Slices-1]) bezier_point(i/(Slices-1),p,n)]
;

// ermittelt den Punkt einer Bezierkurve 1. Grades (linear) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, p1] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p1 = Endpunkt der Kurve
function bezier_1 (t, p) =
	  p[0] * (1-t)
	+ p[1] * t
;

// ermittelt den Punkt einer Bezierkurve 2. Grades (quadratisch) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, p1, p2] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p2 = Endpunkt der Kurve
function bezier_2 (t, p) =
	let (T = 1-t)
	  p[0] *   (    T*T)
	+ p[1] * 2*(t * T)
	+ p[2] *   (t*t)
;

// ermittelt den Punkt einer Bezierkurve 3. Grades (kubisch) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., p3] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p3 = Endpunkt der Kurve
function bezier_3 (t, p) =
	let (T = 1-t)
	  p[0] *   (      T*T*T)
	+ p[1] * 3*(t   * T*T)
	+ p[2] * 3*(t*t * T)
	+ p[3] *   (t*t*t)
;

// ermittelt den Punkt einer Bezierkurve 4. Grades abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., p4] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p4 = Endpunkt der Kurve
function bezier_4 (t, p) =
	let (T = 1-t)
	  p[0] *   (        T*T*T*T)
	+ p[1] * 4*(t     * T*T*T)
	+ p[2] * 6*(t*t   * T*T)
	+ p[3] * 4*(t*t*t * T)
	+ p[4] *   (t*t*t*t)
;


// ermittelt einen Punkt eines Kreises
// Argumente:
//   r, (d) - Radius oder Durchmesser
//   angle  - Winkel in Grad
function circle_point   (r, angle=0, d) = circle_point_r(parameter_circle_r(r,d), angle);
function circle_point_r (r, angle=0) =
	r * [cos(angle), sin(angle)]
;

// gibt ein Array mit den Punkten eines Kreisbogens zurück
// Argumente:
//   r, (d) - Radius oder Durchmesser
//   angle  - gezeichneter Winkel in Grad, Standart=360
//            als Zahl  = Winkel von 0 bis 'angle' = Öffnungswinkel
//            als Liste = [Öffnungswinkel, Anfangswinkel]
//   slices - Anzahl der Segmente, ohne Angabe wird wie bei circle() gerechnet
//            mit Angabe "x" werden die erweiterten Variablen zum steuern der
//            Auflösunsgenauigket mit herangezogen
//   piece  - true  = wie ein Tortenstück
//          - false = Enden des Kreises verbinden
//                    Wenn die Segmentanzahl zu klein ist, wird eine zusätzliche Kante eingebaut
//          - 0     = nur die Kurve, zum weiterverarbeiten
//                    keine zusätzlichen Kanten, wenn die Segmentanzahl zu klein ist
//   outer  - 0...1 = 0 - Ecken auf der Kreislinie (Standart)
//                    1 - Tangenten auf der Kreislinie
function circle_curve (r, angle=360, slices, piece=0, outer, align, d) =
	let(
		 R     = parameter_circle_r (r,d)
		,Align = parameter_align (align, [0,0])
		,angles      = parameter_angle (angle, [360,0])
		,Angle_begin = angles[1]
		,Angle       = angles[0]
		,Slices =
			slices==undef ? get_slices_circle_current  (R,Angle,piece) :
			slices=="x"   ? get_slices_circle_current_x(R,Angle,piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,Outer   = outer!=undef ? outer : 0
		,r_outer =
			(Angle==0) ? R
			:            R * get_circle_factor(Slices*360/Angle, Outer)
		,circle_list =
			circle_curve_intern(r_outer, Angle, Angle_begin, Slices, Align)
	)
	(piece==true && Angle!=360) ?
		concat( circle_list, [[0,0]])
	:	circle_list
;
function circle_curve_intern (r=1, angle=360, angle_begin=0, slices=5, align=[0,0]) =
	let (
		 angle_pie = angle/slices
		,end =
			 angle==0   ? 0
			:angle==360 ? max (slices-1, 0)
			:            slices
		,translate_align = align*r
	)
	[for (i = [0:1:end])
		circle_point_r(r, angle_begin + i*angle_pie )
		+ translate_align
	]
;
function get_circle_factor (slices, outer=0) = outer/cos(180/slices) + 1-outer;

// ermittelt den Punkt einer Superellipse
// t  - Position des Punkts von 0...360
// r  - Radius
// a  - steuert die Breitenverhältnisse der jeweiligen Achsen
//        als Zahl  = jede Achse enthält den gleichen Faktor
//        als Liste = jede Achse enthält ihren eigenen Faktor [X,Y]
//        Standart  = [1,1]
// n  - Grad der Kurve, steuert die Kurvenform
//        als Zahl  = jede Achse enthält den gleichen Parameter
//        als Liste = jede Achse enthält ihren eigenen Parameter [X,Y]
// s  - Parameter "Superness", steuert die Kurvenform, optional
//      Wurde n angegeben, wird s ignoriert
//        als Zahl  = jede Achse enthält den gleichen Parameter
//        als Liste = jede Achse enthält ihren eigenen Parameter [X,Y]
function superellipse_point (t, r, a, n, s) =
	let (
		 T = is_num(t) ? t : 0
		,R = is_num(r) ? r : 1,
		,A = parameter_numlist(2, a, [1,1])
		,N = parameter_numlist(2, n, [2,2])
		,S = parameter_numlist(2, s, undef)
	)
	(S==undef) ? superellipse_point_n (T, R, A, N)
	:            superellipse_point_s (T, R, A, S)
;
function superellipse_point_n (t=0, r=1, a=[1,1], n=[2,2]) =
	let(
		e = 2/n
	)
	superellipse_point_intern (t, r*a, e)
;
function superellipse_point_s (t=0, r=1, a=[1,1], s=[1/sqrt(2),1/sqrt(2)]) =
	let(
		e = (-2/ln(2)) * [ln(s[0]),ln(s[1])]
	)
	superellipse_point_intern (t, r*a, e)
;
// e - calculated exponent
function superellipse_point_intern (t, a, e) =
	let (
		sint = sin(t),
		cost = cos(t)
	)
	[ a[0] * pow( abs(cost), e[0]) * sign(cost),
	  a[1] * pow( abs(sint), e[1]) * sign(sint)
	]
;

// Argumente:
// interval - Intervallgrenze von t. [Anfang, Ende]
// slices   - Anzahl der Punkte im Intervall
// piece    - true  = wie ein Tortenstück
//            false = Enden des Kreises verbinden
//            0     = zum weiterverarbeiten, Enden nicht verbinden, keine zusätzlichen Kanten
function superellipse_curve (interval, r, a, n, s, slices, piece=0) =
	let (
		 I = is_list(interval) ? interval :
		     [0,360]
		,R = is_num(r) ? r : 1
		,A = parameter_numlist(2, a, [1,1])
		,N = parameter_numlist(2, n, [2,2])
		,S = parameter_numlist(2, s, undef)
		,Slices =
			slices==undef ? get_slices_circle_current  (R*max(A),I[1]-I[0],piece) :
			slices=="x"   ? get_slices_circle_current_x(R*max(A),I[1]-I[0],piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,e =
			S==undef ? 2/N
			:          (-2/ln(2)) * [ln(S[0]),ln(S[1])]
		,curve_list = superellipse_curve_intern (I, A*R, e, Slices)
	)
	(piece==true && (I[1]-I[0])!=360) ?
		concat( curve_list, [[0,0]])
	:	curve_list
;
function superellipse_curve_intern (interval, a, e, slices) =
	[ for (i = [0 : slices])
		let (t = bezier_1(i/slices, interval))
		superellipse_point_intern (t, a, e)
	]
;

// ermittelt einen Punkt der Superformel
// t  - Position (Winkel) des Punkts von 0...360
// a  - steuert die Ausdehnung der jeweiligen Achsen
//        als Zahl  = jede Achse enthält den gleichen Faktor
//        als Liste = jede Achse enthält ihren eigenen Faktor [X,Y]
//        Standart  = [1,1]
// m  - Symmetrie
//        als Zahl  = jede Achse enthält den gleichen Faktor
//        als Liste = jede Achse enthält ihren eigenen Faktor [X,Y]
// n  - Kurve, steuert die Kurvenform
//      Liste mit 3 Parametern [n1, n2, n3]
function superformula_point (t, a, m, n) =
	let (
		 T = is_num(t) ? t : 0
		,A = parameter_numlist(2, a, [1,1]  , fill=true)
		,M = parameter_numlist(2, m, [1,1]  , fill=true)
		,N = parameter_numlist(3, n, [1,1,1], fill=true)
	)
	superformula_point_intern (T, A, M, N)
;
function superformula_point_intern (t, a, m, n) =
	let (
		 t4 = t/4
		,r  =
			pow(
				pow( abs(cos( m[0]*t4 ) / a[0]), n[1]) +
				pow( abs(sin( m[1]*t4 ) / a[1]), n[2])
				, -1/n[0])
	)
	circle_point_r (r, t)
;
//
function superformula_curve (interval, a, m, n, slices, piece=true) =
	let (
		 I = is_list(interval) ? interval :
		     [0,360]
		,A = parameter_numlist(2, a, [1,1]  , fill=true)
		,M = parameter_numlist(2, m, [1,1]  , fill=true)
		,N = parameter_numlist(3, n, [1,1,1], fill=true)
		,Slices = // TODO An die Funktion anpassen
			slices==undef ? get_slices_circle_current  (max(A),I[1]-I[0],piece) :
			slices=="x"   ? get_slices_circle_current_x(max(A),I[1]-I[0],piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,curve_list = superformula_curve_intern (I, A, M, N, Slices)
	)
	(piece==true && (I[1]-I[0])!=360) ?
		concat( curve_list, [[0,0]])
	:	curve_list
;
function superformula_curve_intern (interval, a, m, n, slices) =
	[ for (i = [0 : slices])
		let (t = bezier_1(i/slices, interval))
		superformula_point_intern (t, a, m, n)
	]
;

// Polynomfunktion
// P(x) = a[0] + a[1]*x + a[2]*x^2 + ... + a[n]*x^n
// Argumente:
// x - Variable
// a - Array mit den Koeffizienten
// n - Grad des Polynoms, es werden nur so viele Koeffizienten genommen wie angegeben
//     ohne Angabe wird der Grad entsprechend der Größe des Arrays der Koeffizienten genommen
function polynomial (x, a, n) =
	let (
		N = n==undef ? len(a) : min(len(a),n)
	)
	polynomial_intern(x, a, N)
;
function polynomial_intern (x, a, n, i=0, x_i=1, value=0) =
	(i >= n) ? value
	:polynomial_intern(x, a, n, i+1, x_i*x, value + a[i]*x_i)
;

// gibt ein Array mit den Punkten eines Polynomintervalls zurück
// Argumente:
//   interval - Intervallgrenze von x. [Anfang, Ende]
//   slices   - Anzahl der Punkte im Intervall
function polynomial_curve (interval, a, n, slices) =
	let (
		Slices =
			slices==undef ? 5 :
			slices<2      ? 2 :
			slices
	)
	[for (i = [0 : Slices])
		let (x = bezier_1(i/Slices, interval))
		[x, polynomial(x, a, n)]
	]
;

// gibt ein 2D-Quadrat als Punkteliste zurück
// Argumente wie von square() von OpenSCAD
// Drehrichtung ist gegen den Uhrzeigersinn
function square_curve (size, center, align) =
	let (
		Size  = parameter_size_2d(size),
		Align = parameter_align  (align, [1,1], center),
		a     = [for (i=[0:1:len(Size)-1]) Align[i]*Size[i]/2 ],
		x=Size[0],
		y=Size[1],
		square_list=[[0,0], [x,0], [x,y], [0,y]]
	)
	[for (i=[0:1:len(square_list)-1]) square_list[i] - Size/2 + a ]
;

// gibt eine Helix als Punkteliste zurück
// Argumente:
//   r         - Radius als Zahl oder [r1, r2]
//               r1 = unterer Radius, r2 = oberer Radius
//   rotations - Anzahl der Umdrehungen
//   angle     - Anzahl der Umdrehungen als Winkel in Grad
//               ersetzt rotations, wenn angegeben
//   pitch     - Höhenunterschied je Umdrehung
//   height    - Höhe der Helix
//   opposite  - wenn 'true' wird die engegengesetzte Drehrichtung genommen
//   slices    - Anzahl der Segmente je Umdrehung
// benötigte Argumente:
//   radius
//   je 2 Argumente: pitch, rotations oder height
function helix_curve (r, rotations, pitch, height, opposite, slices, angle) =
	let(
		 is_angle  = angle!=undef && is_num(angle)
		//
		,R         = parameter_cylinder_r_basic (r, r[0], r[1])
		,rp        = parameter_helix_to_rp (
			is_angle ? angle/360 : rotations,
			pitch,
			height
		)
		,Rotations = abs(rp[0])
		,Pitch     = rp[1]
		,Height    = Rotations * Pitch
		,Opposite  = xor( (is_bool(opposite) ? opposite : false), rp[0]<0 )
		,Slices =
			slices==undef ? get_slices_circle_current  (max(R), 360*Rotations) :
			slices=="x"   ? get_slices_circle_current_x(max(R), 360*Rotations) :
			max(2, ceil(slices * Rotations))
		,angle_direction = 360 * Rotations * (Opposite==true ? -1 : 1)
	)
	[ for (i=[0:Slices])
		let (
			 t     = i / Slices
			,r_    = bezier_1 (t, R)
			,Angle = t * angle_direction
		)
		[r_ * cos(Angle), r_ * sin(Angle), t * Height]
	]
;

// - Fraktale:

// Koch Kurve
function koch_curve (trace, iteration=1, closed=false) =
	trace_lines (
		koch_lines (
			 points_to_lines (closed!=true ? trace : concat (trace, [trace[0]]) )
			,iteration
		)
	)
;

function koch_lines (lines, iteration=1) =
	iteration<=0 ? lines :
	[for (line=lines)
		let(
			 koch_point_0 = line[0]
			,koch_point_1 = line[0]*2/3 + line[1]*1/3
			,koch_point_2 = line[0]/2+line[1]/2 + normal_vector(line[1]-line[0])/3
			,koch_point_3 = line[0]*1/3 + line[1]*2/3
			,koch_point_4 = line[1]
		)
		each [
			each koch_lines ([ [koch_point_0, koch_point_1] ], iteration-1),
			each koch_lines ([ [koch_point_1, koch_point_2] ], iteration-1),
			each koch_lines ([ [koch_point_2, koch_point_3] ], iteration-1),
			each koch_lines ([ [koch_point_3, koch_point_4] ], iteration-1),
		]
	]
;

// Hilbert Kurve
function hilbert_curve (r=1, iteration=1) =
	[ for (e=hilbert_points(r/2, iteration)) e[0] ]
;

points_hilbert = [
[-1,-1],
[-1, 1],
[ 1, 1],
[ 1,-1]
];

function hilbert_points (r=1, iteration=1, data=[[[0,0], 0]]) =
	iteration<=0 ? data :
	hilbert_points (r/2, iteration-1, 
		[ for (e=data)
			each
			e[1]>=0 ?
			[
				[ e[0] + r*points_hilbert[(e[1]+4)%4], (e[1]-3)%4 ],
				[ e[0] + r*points_hilbert[(e[1]+5)%4], (e[1]  )%4 ],
				[ e[0] + r*points_hilbert[(e[1]+6)%4], (e[1]  )%4 ],
				[ e[0] + r*points_hilbert[(e[1]+7)%4], (e[1]-5)%4 ]
			] : [
				[ e[0] + r*points_hilbert[(e[1]+7)%4], (e[1]+3)%4 ],
				[ e[0] + r*points_hilbert[(e[1]+6)%4], (e[1]  )%4 ],
				[ e[0] + r*points_hilbert[(e[1]+5)%4], (e[1]  )%4 ],
				[ e[0] + r*points_hilbert[(e[1]+4)%4], (e[1]+5)%4 ]
			]
		]
	)
;

// Drachenkurve
function dragon_curve (trace=[[0,0],[1,0]], iteration=1) =
	iteration<=0 ? trace :
	let (s = sqrt(1/4))
	dragon_curve (
		concat( [ trace[0] ],
		[ for (i=[0:1:len(trace)-2])
			if (i%2==0)
				each [
					(trace[i]+trace[i+1])/2 + s*normal_vector(trace[i+1]-trace[i])
					,trace[i+1]
				]
			else
				each [
					(trace[i]+trace[i+1])/2 - s*normal_vector(trace[i+1]-trace[i])
					,trace[i+1]
				]
		] )
		, iteration-1
	)
;

