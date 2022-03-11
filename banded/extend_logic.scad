// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// stellt Funktionen bereit,
// steuern die Auflösungsgenauigkeit der kurvigen Objekte

use <banded/math_common.scad>

// gibt die Anzahl der Segmente eines Kreises zurück
// originale Funktion von OpenSCAD
function get_fn_circle_closed (r, fn, fa, fs) = 
	(fn > 0) ?
		(fn >= 3) ? fn : 3
	:
		ceil(max (min (360/fa, r*2*PI/fs), 5))
;
// gibt die Anzahl der Segmente des Teilstücks eines Kreises zurück,
function get_fn_circle (r, angle=360, piece=true, fn, fa, fs) =
	get_fn_circle_pie (r, angle, piece, get_fn_circle_closed(r, fn, fa, fs))
;
// gibt die Anzahl der Segmente des Teilstücks eines Kreises zurück,
// bei Angabe der Segmente eines vollen Kreises.
// Angelehnt an das Verhalten von rotate_extrude()
function get_fn_circle_pie (r, angle=360, piece=true, fn) =
	max( floor(fn * angle/360),
	     (piece==true || piece==0) ? 1 : 2
	)
;

// gibt die Anzahl der Segmente eines geschlossenen Kreises zurück
// erweiterte Funktion
// Code (x!=false)  ->  Rückgabe: true = true, false = false, Standartwert bei undefiniert = true
function get_fn_circle_closed_x (r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled) =
	r==undef ? 3 :
	is_sf_activated(fn) ? get_fn_circle_closed(r, fn, fa, fs)
	:
		let (
			fa_value = 360/fa,
			fs_value = r*2*PI/fs,
			fd_value = (fd!=undef)&&(fd<r) ? 360/(2*asin(sqrt( 2*fd*(r-fd) )/r)) : 0
		)
		sf_constrain_minmax(fn_min, fn_max,
		ceil(max (5
			,	(  (fa_enabled!=false) && !(fs_enabled!=false)) ? fa_value
				:( (fs_enabled!=false) && !(fa_enabled!=false)) ? fs_value
				:(!(fs_enabled!=false) && !(fa_enabled!=false)) ? if_sf_value(fd, fd_value)
				:min (fa_value, fs_value)
			,	(  (fs_enabled!=false) ||  (fa_enabled!=false)) ? if_sf_value(fd, fd_value, 0) : 0
		)))
;
function get_fn_circle_x (r, angle=360, piece=true, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled) = 
	get_fn_circle_pie (r, angle, piece, get_fn_circle_closed_x(r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled))
;

// aktuelle Fragmentanzahl gemäß den Angaben in $fxxx zurückgeben bei angegeben Radius, optional Winkel
function get_fn_circle_current   (r, angle=360, piece=true) = get_fn_circle   (r, angle, piece, $fn, $fa, $fs);
function get_fn_circle_current_x (r, angle=360, piece=true) = get_fn_circle_x (r, angle, piece, $fn, $fa, $fs,
	is_undef($fn_min)     ? undef : $fn_min,
	is_undef($fn_max)     ? undef : $fn_max,
	is_undef($fd)         ? undef : $fd,
	is_undef($fa_enabled) ? undef : $fa_enabled,
	is_undef($fs_enabled) ? undef : $fs_enabled
);

// Gibt die Begrenzung einer Fragmentanzahl n zwischen $fn_min und $fn_max zurück.
// Abhängig davon, ob diese Begrenzungen aktiviert sind.
function sf_constrain_minmax (fn_min, fn_max, n) =
	  (is_sf_activated(fn_min) && is_sf_activated(fn_max)) ? constrain(n, fn_min, fn_max)
	: (is_sf_activated(fn_min)) ? max(fn_min, n)
	: (is_sf_activated(fn_max)) ? min(fn_max, n)
	: n
;

// gibt zurück, ob eine Variable $fxxx aktiviert ist
function is_sf_activated (fn_base) =
	  (fn_base == undef)       ? false
	: (fn_base <= 0)           ? false
	: (fn_base == 1e200*1e200) ? false // inf
	: (fn_base ==-1e200*1e200) ? false // -inf
	: (fn_base != fn_base)     ? false // nan
	: true
;
// gibt den Status einer Variable $fxxx_enabled zurück
//   true  = $fxxx aktiviert, Standartwert, wenn undef
//   false = $fxxx deaktiviert
function is_sf_enabled (fn_base_enabled) =
	(fn_base_enabled!=false)
	//
	//  (is_bool(fn_base_enabled)) ? fn_base_enabled
	//: true
;

// gibt die Fragmentanzahl 'n' zurück, wenn $fxxx (angegeben in 'base') aktiviert ist,
// sonst wird ein Sicherheitswert zurückgegeben
function if_sf_value (base, n, safe=sf_safe()) = is_sf_activated(base) ? n : safe;
//
function sf_safe () =
	is_sf_activated( is_undef($fn_safe) ? undef : $fn_safe)
	? $fn_safe : 12;

// gibt den Winkel eines Kreisfragments zurück, bei welcher die Abweichung
// der Sehne zum Kreisbogen in Prozent erreicht ist
// dient zum Umrechnen von Prozent in die Angabe von $fa
function get_angle_from_percent (value) =
	let (fp=value/100)
	2*asin( 2*sqrt( fp*(1 - 2*fp) ) )
;
