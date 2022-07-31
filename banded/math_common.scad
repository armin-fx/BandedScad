// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche mathematische Funktionen

include <banded/constants.scad>
//
use <banded/math_number.scad>


// - Testen und beschränken:

// setzt einen Wert innerhalb eines Bereiches
// zwischen Minimum <min> und Maximum <max>
// <min> muss kleiner sein als <max>, sonst seltsames Verhalten
function constrain (value, min, max) = 
	 (value<min) ? min
	:(value>max) ? max
	: value
;
// ... zwischen beiden Werten <a> und <b>
function constrain_bidirectional (value, a, b) = 
	 (a<=b) ?
		 (value<a) ? a
		:(value>b) ? b
		: value
	:
		 (value<b) ? b
		:(value>a) ? a
		: value
;

// testet, ob eine Variable innerhalb eines Bereichs ist
function is_constrain (value, a, b) =
	a<b ?
		value>=a && value<=b
	:
		value>=b && value<=a
;
function is_constrain_left (value, a, b) =
	a<b ?
		value>=a && value<b
	:
		value>b && value<=a
;
function is_constrain_right (value, a, b) =
	a<b ?
		value>a && value<=b
	:
		value>=b && value<a
;
function is_constrain_inner (value, a, b) =
	a<b ?
		value>a && value<b
	:
		value>b && value<a
;

// testet zwei Werte oder zwei Listen mit Werten ob sie näherungsweise übereinstimmen
// deviation - maximale Abweichung der Werte
function is_nearly (a, b, deviation=deviation) =
	 is_num (a)&&is_num(b) ? min(a,b)+abs(deviation) >= max(a,b)
	:is_list(a) ? min( [ for (e=[0:len(a)-1]) is_nearly(a[e],b[e],deviation) ] )
	:a==b
;

// Quantisiert einen Wert innerhalb eines Rasters
// Voreinstellung = auf ganze Zahl runden
function quantize (value, raster=1, offset=0.5) =
	// raster * floor( (value/raster) + offset )
	value+offset - ((value+offset)%raster+raster)%raster
;

// Test: die Zahl ist eine ungerade Zahl? 
function is_odd  (n) = (n+1)%2==0;
// Test: die Zahl ist eine gerade Zahl? 
function is_even (n) =  n   %2==0;

/*
function positiv_if_odd  (n) = (is_odd (n)) ?  1 : -1;
function positiv_if_even (n) = (is_even(n)) ?  1 : -1;
function negativ_if_odd  (n) = (is_odd (n)) ? -1 :  1;
function negativ_if_even (n) = (is_even(n)) ? -1 :  1;
*/
function positiv_if_odd  (n) = (n+1)%2==0 ?  1 : -1;
function positiv_if_even (n) =  n   %2==0 ?  1 : -1;
function negativ_if_odd  (n) = (n+1)%2==0 ? -1 :  1;
function negativ_if_even (n) =  n   %2==0 ? -1 :  1;


// Verschiedene Funktionen:

// Zum Quadrat nehmen
function sqr (x) = x*x;

// Rechnet den modulo 'x%n'
// = Rest von 'x / n'
// Das Vorzeichen vom Rest ist das selbe wie vom Teiler 'n'.
function mod (x, n) =
	(x%n+n)%n
;

// bildet das 'exklusive oder'
function xor (bool, bool2) = bool==bool2 ? false : true;

// Gaußsche Normalverteilung
function normal_distribution(x, mean=0, sigma=1) =
	1/(sqrt(2*PI)*sigma) * exp(-sqr(x-mean/sigma)/2)
;


// - Trigonometrische Funktion:

// Sekans
function sec (angle) = 1 / cos(angle);
// Kosekans
function csc (angle) = 1 / sin(angle);
// Kotangens
function cot (angle) = tan(90 - angle); // = 1 / tan(angle);
// Arkuskotangens
function acot (x) = 90 - atan(x);
//
// Hyperbelsinus
function sinh (x) = (exp(x) - exp(-x)) / 2;
// Hyperbelkosinus
function cosh (x) = (exp(x) + exp(-x)) / 2;
// Hyperbelkotangens
function tanh (x) = 1 - (2 / (exp(2*x) + 1));
// Hyperbeltangens
function coth (x) = 1 + (2 / (exp(2*x) - 1));
//
// Umkehrfunktion Hyperbelsinus
function asinh (x) = ln(x + sqrt(x*x + 1));
// Umkehrfunktion Hyperbelkosinus
function acosh (x) =
	(x >= 1) ?
	  ln(x + sqrt(x*x - 1))
	: undef
;
// Umkehrfunktion Hyperbeltangens
function atanh (x) = ln((1 + x) / (1 - x)) / 2;
// Umkehrfunktion Hyperbelkotangens
function acoth (x) = ln((x + 1) / (x - 1)) / 2;
//
// Kardinalsinus
function si   (x) = (x==0) ? 1 : sin(x*degree_per_radian) / x;
// normierter Kardinalsinus
function sinc (x) = si(PI*x);
// Integralsinus (arbeitet nur bis x<32)
function Si (x) = Si_taylor_auto(x);
function Si_taylor_index(x, n) = let (term=2*n+1) positiv_if_even(n) * pow(x, term) / (factorial(term) * term);
function Si_taylor_auto (x, n=60, k=0, value=0, value_old) =
	(k>n || value==value_old) ? value :
	Si_taylor_auto (x, n, k+1,
		value + Si_taylor_index(x, k),
		value
	)
;
