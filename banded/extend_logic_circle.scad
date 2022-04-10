// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// stellt Funktionen bereit,
// steuern die Auflösungsgenauigkeit des Kreises

use <banded/extend_logic_helper.scad>


// gibt die Anzahl der Segmente eines Kreises zurück
// originale Funktion von OpenSCAD
function get_slices_circle_closed (r, fn, fa, fs) = 
	(fn > 0) ?
		(fn >= 3) ? fn : 3
	:
		ceil(max (min (360/fa, r*2*PI/fs), 5))
;
// gibt die Anzahl der Segmente des Teilstücks eines Kreises zurück,
function get_slices_circle (r, angle=360, piece=true, fn, fa, fs) =
	get_slices_circle_pie (r, angle, piece, get_slices_circle_closed(r, fn, fa, fs))
;
// gibt die Anzahl der Segmente des Teilstücks eines Kreises zurück,
// bei Angabe der Segmente eines vollen Kreises.
// Angelehnt an das Verhalten von rotate_extrude()
function get_slices_circle_pie (r, angle=360, piece=true, fn) =
	max( floor(fn * angle/360),
	     (piece==true || piece==0) ? 1 : 2
	)
;

// gibt die Anzahl der Segmente eines geschlossenen Kreises zurück
// erweiterte Funktion
// Code (x!=false)  ->  Rückgabe: true = true, false = false, Standartwert bei undefiniert = true
function get_slices_circle_closed_x (r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled) =
	r==undef ? 3 :
	is_sf_activated(fn) ? get_slices_circle_closed(r, fn, fa, fs)
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
function get_slices_circle_x (r, angle=360, piece=true, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled) = 
	get_slices_circle_pie (r, angle, piece, get_slices_circle_closed_x(r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled))
;

// aktuelle Fragmentanzahl gemäß den Angaben in $fxxx zurückgeben bei angegeben Radius, optional Winkel
function get_slices_circle_current   (r, angle=360, piece=true) = get_slices_circle   (r, angle, piece, $fn, $fa, $fs);
function get_slices_circle_current_x (r, angle=360, piece=true) = get_slices_circle_x (r, angle, piece, $fn, $fa, $fs,
	is_undef($fn_min)     ? undef : $fn_min,
	is_undef($fn_max)     ? undef : $fn_max,
	is_undef($fd)         ? undef : $fd,
	is_undef($fa_enabled) ? undef : $fa_enabled,
	is_undef($fs_enabled) ? undef : $fs_enabled
);
