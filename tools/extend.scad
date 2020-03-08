// extend.scad
//
// erweitert einige eingebaute Module um weitere Eigenschaften
//
// Aufbau:
//     <Modulname>_extend
//
// hinzugefügte Eigenschaften:
//  - Variablen mit weiteren Begrenzungen, wenn $fn nicht gesetzt ist ($fn=0). deaktiviert, wenn auf 0 gesetzt.
//     $fn_min - Objekte werden in mindestens soviele Fragmente gebaut wie angegeben,
//     $fn_max - Objekte werden in höchstens soviele Fragmente gebaut wie angegeben,
//     $fx     - maximale Abweichung des Modells in mm
//     $fp     - maximale Abweichung des Modells in Prozent
//     $fn_safe - Anzahl der Fragmente, wenn alle Begrenzungen deaktiviert wurden. Standardwert = 12
// veränderte Eigenschaften:
//  - Variablen können deaktiviert werden mit 0, wenn andere Begrenzungen gesetzt werden.
//     $fa     - kleinster Winkel pro Fragmente
//     $fs     - kleinste Größe eines Fragments in mm


$fn_min=0+0;
$fn_max=0+0;
$fx=0+0; // TODO noch nicht implementiert
$fp=0+0; // TODO noch nicht implementiert
$fn_safe=0+12;

// gibt die Anzahl der Segmente eines Kreises zurück
// originale Funktion von OpenScad
function get_fn_circle_closed (r, fn, fa, fs) = 
	(fn > 0) ?
		(fn >= 3) ? fn : 3
	:
		ceil(max (min (360/fa, r*2*PI/fs), 5))
;
function get_fn_circle (r, angle=360, piece=true, fn, fa, fs) = 
	max(ceil(get_fn_circle_closed(r, fn, fa, fs) * angle/360),
	    (piece==true || piece==0) ? 1 : 2)
;

// gibt die Anzahl der Segmente eines Kreises zurück
// erweiterte Funktion
function get_fn_circle_closed_x (r, fn, fa, fs, fn_min, fn_max, fx, fp) = 
	sf_is_activated(fn) ? get_fn_circle_closed(r, fn, fa, fs)
	:
		sf_minmax(fn_min, fn_max,
		ceil(max (5,
		min (sf_value(fa, 360/fa),
		     sf_value(fs, r*2*PI/fs))
		)))
;
function get_fn_circle_x (r, angle=360, piece=true, fn, fa, fs, fn_min, fn_max, fx, fp) = 
	max(ceil(get_fn_circle_closed_x(r, fn, fa, fs, fn_min, fn_max, fx, fp) * angle/360),
	    (piece==true || piece==0) ? 1 : 2)
;

function get_fn_circle_current   (r, angle=360, piece=true) = get_fn_circle   (r, angle, piece, $fn, $fa, $fs);
function get_fn_circle_current_x (r, angle=360, piece=true) = get_fn_circle_x (r, angle, piece, $fn, $fa, $fs, $fn_min, $fn_max, $fx, $fp);

// gibt die Begrenzung für $fn_min und $fn_max zurück
function sf_minmax(fn_min, fn_max, v) =
	  (sf_is_activated(fn_min) && sf_is_activated(fn_max)) ? min(fn_max, max(fn_min, v))
	: (sf_is_activated(fn_min)) ? max(fn_min, v)
	: (sf_is_activated(fn_max)) ? min(fn_max, v)
	: v
;

function sf_safe () = sf_is_activated($fn_safe) ? $fn_safe : 12;

// gibt zurück, ob eine Variable $fxxx aktiviert ist
function sf_is_activated (fn_base) =
	  (fn_base == undef) ? false
	: (fn_base <= 0)     ? false
	: true
;

function sf_value (base, v, safe=sf_safe()) = sf_is_activated(base) ? v : safe;

function sf_max   (base, v1, v2, safe=sf_safe()) = sf_is_activated(base) ? max(v1, v2) : safe;
function sf_min   (base, v1, v2, safe=sf_safe()) = sf_is_activated(base) ? min(v1, v2) : safe;


// Erzeugt einen Kreis
// Argumente wie function circle_curve()
module circle_extend (r, d, angle=360, slices="x", piece=true, angle_begin=0)
{
	polygon(circle_curve (r=r, angle=angle, slices=slices, piece=piece, angle_begin=angle_begin, d=d),
	        convexity=(piece==true && angle>180) ? 4 : 2);
}

module cylinder_extend (h, r1, r1, center=false, r, d, d1, d2, angle=360, piece=true)
{}

module sphere_extend (r, d, angle=360, piece=true)
{}

