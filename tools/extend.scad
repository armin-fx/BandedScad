// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// erweitert einige eingebaute Module um weitere Eigenschaften
//
// Aufbau:
//     <Modulname>_extend
//
// hinzugefügte Eigenschaften:
//  - Variablen mit weiteren Begrenzungen, wenn $fn nicht gesetzt ist ($fn=0). deaktiviert, wenn auf 0 gesetzt.
//      $fn_min  - Objekte werden in mindestens so viele Fragmente gebaut wie angegeben,
//      $fn_max  - Objekte werden in höchstens so viele Fragmente gebaut wie angegeben,
//      $fd      - maximale Abweichung des Modells in mm
//      $fn_safe - Anzahl der Fragmente, wenn alle Begrenzungen deaktiviert wurden. Standardwert = 12
// veränderte Eigenschaften:
//  - interne Variablen können deaktiviert werden mit entsprechende Schalter.
//    wird aktiviert mit true (Standart), deaktiviert mit false
//      $fa_enabled - für $fa = kleinster Winkel pro Fragmente
//      $fs_enabled - für $fs = kleinste Größe eines Fragments in mm

use <tools/function_math.scad>
use <tools/function_helper.scad>
use <tools/function_recondition.scad>
use <tools/function_curves.scad>

$fn_min=0;
$fn_max=0;
$fd=0;
$fn_safe=0;
$fa_enabled=true;
$fs_enabled=true;

// gibt die Anzahl der Segmente eines Kreises zurück
// originale Funktion von OpenScad
function get_fn_circle_closed (r, fn, fa, fs) = 
	(fn > 0) ?
		(fn >= 3) ? fn : 3
	:
		ceil(max (min (360/fa, r*2*PI/fs), 5))
;
function get_fn_circle (r, angle=360, piece=true, fn, fa, fs) = 
	max( ceil(get_fn_circle_closed(r, fn, fa, fs) * angle/360),
	     (piece==true || piece==0) ? 1 : 2)
;

// gibt die Anzahl der Segmente eines geschlossenen Kreises zurück
// erweiterte Funktion
function get_fn_circle_closed_x (r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled=true, fs_enabled=true) = 
	sf_is_activated(fn) ? get_fn_circle_closed(r, fn, fa, fs)
	:
		let (
			fa_value = 360/fa,
			fs_value = r*2*PI/fs,
			fd_value = (fd<r) ? 360/(2*asin(sqrt( 2*fd*(r-fd) )/r)) : 0
		)
		sf_minmax(fn_min, fn_max,
		ceil(max (5
			,	(  fa_enabled!=false && !fs_enabled!=false) ? fa_value
				:( fs_enabled!=false && !fa_enabled!=false) ? fs_value
				:(!fs_enabled!=false && !fa_enabled!=false) ? sf_value(fd, fd_value)
				:min (fa_value, fs_value)
			,	!(!fs_enabled!=false && !fa_enabled!=false) ? sf_value(fd, fd_value, 0) : 0
		)))
;
function get_fn_circle_x (r, angle=360, piece=true, fn, fa, fs, fn_min, fn_max, fd, fa_enabled=true, fs_enabled=true) = 
	max( ceil(get_fn_circle_closed_x(r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled) * angle/360),
	     (piece==true || piece==0) ? 1 : 2)
;

// aktuelle Fragmentanzahl gemäß den Angaben in $fxxx zurückgeben bei angegeben Radius, optional Winkel
function get_fn_circle_current   (r, angle=360, piece=true) = get_fn_circle   (r, angle, piece, $fn, $fa, $fs);
function get_fn_circle_current_x (r, angle=360, piece=true) = get_fn_circle_x (r, angle, piece, $fn, $fa, $fs, $fn_min, $fn_max, $fd, $fa_enabled, $fs_enabled);

// gibt die Begrenzung für $fn_min und $fn_max zurück
function sf_minmax(fn_min, fn_max, v) =
	  (sf_is_activated(fn_min) && sf_is_activated(fn_max)) ? constrain(v, fn_min, fn_max)
	: (sf_is_activated(fn_min)) ? max(fn_min, v)
	: (sf_is_activated(fn_max)) ? min(fn_max, v)
	: v
;

// gibt zurück, ob eine Variable $fxxx aktiviert ist
function sf_is_activated (fn_base) =
	  (fn_base == undef)       ? false
	: (fn_base <= 0)           ? false
	: (fn_base == 1e200*1e200) ? false // inf
	: true
;

// gibt den Wert v zurück, wenn $fxxx aktiviert ist, sonst wird ein Sicherheitswert zurückgegeben
function sf_value (base, v, safe=sf_safe()) = sf_is_activated(base) ? v : safe;
//
function sf_max   (base, v1, v2, safe=sf_safe()) = sf_is_activated(base) ? max(v1, v2) : safe;
function sf_min   (base, v1, v2, safe=sf_safe()) = sf_is_activated(base) ? min(v1, v2) : safe;
//
function sf_safe () = sf_is_activated($fn_safe) ? $fn_safe : 12;

// gibt den Winkel eines Kreisfragments zurück, bei welcher die Abweichung
// der Sehne zum Kreisbogen in Prozent erreicht ist
// dient zum Umrechnen von Prozent in die Angabe von $fa
function get_angle_from_percent (value) =
	let (fp=value/100)
	2*asin( 2*sqrt( fp*(1 - 2*fp) ) )
;

// Erzeugt einen Kreis
// Argumente wie function circle_curve()
// Kompatibel mit OpenSCAD Modul circle()
module circle_extend (r, angle, slices="x", piece=true, d)
{
	angles = parameter_angle (angle, [360,0]);
	polygon(circle_curve (r=r, angle=angle, slices=slices, piece=piece, d=d),
	        convexity=(piece==true && angles[0]>180) ? 4 : 2);
}

// Erzeugt einen Zylinder
// Kompatibel mit OpenSCAD Modul cylinder()
// Argumente des Kreisbodens wie circle_extend()
module cylinder_extend (h, r1, r2, center=false, r, d, d1, d2, angle, slices="x", piece=true)
{
	R        = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	R_sorted = R[0]>R[1] ? R : [R[1],R[0]]; // erster Radius muss größer oder gleich sein
	H        = get_first_good (h, 1);
	angles = parameter_angle (angle, [360,0]);
	//
	module mirror_at_z_choice (p, choice)
	{
		if (choice==true) mirror_at_z(p) children();
		else              children();
	}
	
	mirror_at_z_choice ([0,0,H/2], R[0]<R[1])
	linear_extrude(height=H, center=center
		,scale=R_sorted[1]/R_sorted[0]
		,convexity=(piece==true && angles[0]>180) ? 4 : 2)
	circle_extend (r=R_sorted[0], angle=angle, slices=slices, piece=piece);
}
/*
module cylinder_extend (h, r1, r2, center=false, r, d, d1, d2)
{
	R = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	cylinder(h=h, r1=R[0], r2=R[1], center=center, $fn=get_fn_circle_current_x(max(R[0],R[1]));
}*/

// Erzeugt eine Kugel
// Argumente wie OpenSCAD Modul sphere()
// TODO Argument angle
module sphere_extend (r, d)
{
	R = parameter_circle_r (r, d);
	sphere(r=R, $fn=get_fn_circle_current_x(R));
}

