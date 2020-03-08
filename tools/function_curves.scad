// function_curves.scad
//
// Enthält einige zusätzliche Funktionen


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
	 (len(p)==undef) ? undef
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
	 (slices==undef) ?
		bezier_curve_intern(p, n, max(2, get_fn_circle_current  (max_norm(p)/4) ))
	:(slices=="x") ?
		bezier_curve_intern(p, n, max(2, get_fn_circle_current_x(max_norm(p)/4) ))
	:(slices< 2)     ?
		bezier_curve_intern(p, n, 2)
	:	bezier_curve_intern(p, n, slices)
;
function bezier_curve_intern (p, n, slices) =
	[for (i = [0 : slices-1]) bezier_point(i/(slices-1),p,n)]
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
	  p[0] *   (    (1-t)*(1-t))
	+ p[1] * 2*(t * (1-t))
	+ p[2] *   (t*t)
;

// ermittelt den Punkt einer Bezierkurve 3. Grades (kubisch) abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., p3] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p3 = Endpunkt der Kurve
function bezier_3 (t, p) =
	  p[0] *   (      (1-t)*(1-t)*(1-t))
	+ p[1] * 3*(t   * (1-t)*(1-t))
	+ p[2] * 3*(t*t * (1-t))
	+ p[3] *   (t*t*t)
;

// ermittelt den Punkt einer Bezierkurve 4. Grades abhängig von den Parametern
// Argumente:
//   t - ein Wert zwischen 0...1
//   p - [p0, ..., p4] -> Array mit Kontrollpunkte
//       p0 = Anfangspunkt der Kurve, p4 = Endpunkt der Kurve
function bezier_4 (t, p) =
	  p[0] *   (        (1-t)*(1-t)*(1-t)*(1-t))
	+ p[1] * 4*(t     * (1-t)*(1-t)*(1-t))
	+ p[2] * 6*(t*t   * (1-t)*(1-t))
	+ p[3] * 4*(t*t*t * (1-t))
	+ p[3] *   (t*t*t*t)
;


// ermittelt einen Punkt eines Kreises
// Argumente:
// r, (d) - Radius oder Durchmesser
// angle  - Winkel in Grad
function circle_point   (r, angle=0, d) = circle_point_r(parameter_circle_r(r,d), angle);
function circle_point_r (r, angle=0) =
	r * [cos(angle), sin(angle)]
;

// gibt ein Array mit den Punkten eines Kreisbogens zurück
// Argumente:
// r, (d) - Radius oder Durchmesser
// angle  - gezeichneter Winkel in Grad
// slices - Anzahl der Segmente, ohne Angabe wird wie bei circle() gerechnet
// piece  - true  = wie ein Tortenstück
//          false = Enden des Kreises verbinden
//          0     = zum weiterverarbeiten, Enden nicht verbinden, keine zusätzlichen Kanten
// outer  - 0...1 = 0 - Ecken auf der Kreislinie ... 1 - Tangenten auf der Kreislinie
function circle_curve   (r, angle=360, slices, piece=true, angle_begin=0, outer=0, d) = circle_curve_r(parameter_circle_r(r,d), angle, slices, piece, angle_begin, outer);
function circle_curve_r (r, angle=360, slices, piece=true, angle_begin=0, outer=0)    =
	 (slices==undef) ?
		circle_curve_p_intern(r, angle, get_fn_circle_current(r,angle,piece), piece, angle_begin, outer)
	:(slices=="x") ?
		circle_curve_p_intern(r, angle, get_fn_circle_current_x(r,angle,piece), piece, angle_begin, outer)
	:(slices< 2) ?
		(piece==true || pierce==0) ?
			circle_curve_p_intern(r, angle, 1     , piece, angle_begin, outer)
		:	circle_curve_p_intern(r, angle, 2     , piece, angle_begin, outer)
	:		circle_curve_p_intern(r, angle, slices, piece, angle_begin, outer)
;
function circle_curve_p_intern (r, angle, slices, piece, angle_begin, outer) =
	(piece==true && angle!=360) ? concat(
		circle_curve_intern(r, angle, slices, angle_begin, outer)
		,[[0,0]])
	:
		circle_curve_intern(r, angle, slices, angle_begin, outer)
;
function circle_curve_intern (r, angle, slices, angle_begin, outer) =
	[for (i = [0 : (angle==0) ? 0 : slices]) circle_point_r(r, angle_begin + angle*i/(slices) )]
;

// Polynomfunktion
// P(x) = a[0] + a[1]*x + a[2]*x^2 + ... a[n]*x^n
// Argumente:
// x - Variable
// a - Array mit den Koeffizienten
// n - Grad des Polynoms, es werden nur so viele Koeffizienten genommen wie angegeben
//     ohne Angabe wird der Grad entsprechend der Größe des Arrays der Koeffizienten genommen
function polynom (x, a, n=undef) =
	(n==undef) ? polynom_intern(x, a, len(a))
	:            polynom_intern(x, a, min(len(a),n) )
;
function polynom_intern (x, a, n, i=0, x_i=1, value=0) =
	(i >= n) ? value
	:polynom_intern(x, a, n, i+1, x_i*x, value + a[i]*x_i)
;

// gibt ein Array mit den Punkten eines Polynomintervalls zurück
// Argumente:
// x_interval - Intervallgrenze von x. [Anfang, Ende]
// slices     - Anzahl der Punkte im Intervall
function polynom_curve (x_interval, a, n=undef, slices) =
	 (slices==undef) ?
		polynom_curve_intern (x_interval, a, n, 5)
	:(slices< 2)     ?
		polynom_curve_intern (x_interval, a, n, 2)
	:	polynom_curve_intern (x_interval, a, n, slices)
;
function polynom_curve_intern (x_interval, a, n, slices) =
	[for (i = [0 : slices]) [bezier_1(i/slices, x_interval), polynom(bezier_1(i/slices, x_interval), a, n)]]
;

// gibt ein 2D-Quadrat als Punkteliste zurück
// Argumente wie von square() von OpenSCAD
function square_curve(size, center=false) =
	square_curve_intern(get_first_good_2d(size+[0,0],[size+0,size+0], [1,1]), center)
;
function square_curve_intern(size, center) =
	(center==false) ? [[0,0], [size[0],0], [size[0],size[1]], [0,size[1]]]
	:translate_list(  [[0,0], [size[0],0], [size[0],size[1]], [0,size[1]]], [-size[0]/2,-size[0]/2])
;

