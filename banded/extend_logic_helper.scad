// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// stellt Hilfsfunktionen bereit,
// steuern die Auflösungsgenauigkeit der kurvigen Objekte

use <banded/math_common.scad>


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
