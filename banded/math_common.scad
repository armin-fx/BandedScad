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
function constrain_range (value, a, b) = 
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
	:is_list(a) ? [ for (i=[0:1:len(a)-1]) if (! is_nearly(a[i],b[i],deviation)) 0] == []
	:a==b
;

// Quantisiert einen Wert innerhalb eines Rasters
// Voreinstellung = auf ganze Zahl runden
function quantize (value, raster=1, offset=0.5) =
	// raster * floor( (value/raster) + offset )
	value+offset - ((value+offset)%raster+raster)%raster
;

// Linear interpolation
function lerp (a, b, t, range) =
	range==undef ?
	  a * (1-t)
	+ b * t
	:
	let(
		R =
			is_num(range) ? [0, range] :
			range,
		T = (t-R[0]) / (R[1]-R[0])
	)
	  a * (1-T)
	+ b * T
;

// Inverse linear interpolation
function inv_lerp (a, b, v, range) =
	let(
		R =
			range==undef  ? [0,1] :
			is_num(range) ? [0, range] :
			range,
		T = (v - a) / (b - a)
	)
	R[0] + (R[1]-R[0])*T
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

//
function sign_plus (x) = x<0 ? -1 : 1;

// bildet das 'exklusive oder'
function xor   (bool, bool2) = bool != bool2;
//
function xor_3 (bool, bool2, bool3, bool4) =
	bool3==undef
	?	bool3 != (bool!=bool2)
	:	bool!=bool2
;
function xor_4 (bool, bool2, bool3, bool4) =
	bool4==undef ?
		bool3==undef ?
			bool3 != (bool!=bool2)
		:	bool!=bool2
	:		(bool3!=bool4) != (bool!=bool2)
;

// Gaußsche Normalverteilung
function normal_distribution(x, mean=0, sigma=1) =
	1/(sqrt(2*PI)*sigma) * exp(-sqr(x-mean/sigma)/2)
;


// - Trigonometrische Funktion:

// Kotangens
  function cot (angle) = tan(90 - angle);
//function cot (angle) = 1 / tan(angle);
// Sekans
function sec (angle) = 1 / cos(angle);
// Kosekans
function csc (angle) = 1 / sin(angle);
// Externer Sekans
function exsec (angle) = (1 / cos(angle)) - 1;
// Externer Kosekans
function excsc (angle) = (1 / sin(angle)) - 1;
// Sinus versus
function versin   (angle) = 1 - cos(angle);
// Cosinus versus
function coversin (angle) = 1 - sin(angle);
// versed cosine
function vercos   (angle) = 1 + cos(angle);
// coversed cosine
function covercos (angle) = 1 + sin(angle);
// Sehne
function chord (angle) = 2 * sin(angle / 2);
//
// Arkuskotangens
function acot (x) = 90 - atan(x);
// Arkussekans
function asec (x) = acos(1 / x);
// Arkuskosekans
function acsc (x) = asin(1 / x);
// Arkus extern sekans
function aexsec (x) = acos(1 / (x + 1));
// Arkus extern kosekans
function aexcsc (x) = asin(1 / (x + 1));
// Arkus sinus versus
function aversin   (x) = acos(1 - x);
// Arkus cosinus versus
function acoversin (x) = asin(1 - x);
// Arkus versed cosine
function avercos   (x) = acos(x - 1);
// Arkus coversed cosine
function acovercos (x) = asin(x - 1);
// Winkel aus Sehne
function achord (x) = 2 * asin(x / 2);

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

// Trigonometrische Funktion im Bogenmaß
function sin_r (x) = sin (x*degree_per_radian);
function cos_r (x) = cos (x*degree_per_radian);
function tan_r (x) = tan (x*degree_per_radian);
function cot_r (x) = tan (90 - x*degree_per_radian);
function sec_r   (x) =  1 / cos(x*degree_per_radian);
function csc_r   (x) =  1 / sin(x*degree_per_radian);
function exsec_r (x) = (1 / cos(x*degree_per_radian)) - 1;
function excsc_r (x) = (1 / sin(x*degree_per_radian)) - 1;
function versin_r   (x) = 1 - cos(x*degree_per_radian);
function coversin_r (x) = 1 - sin(x*degree_per_radian);
function vercos_r   (x) = 1 + cos(x*degree_per_radian);
function covercos_r (x) = 1 + sin(x*degree_per_radian);
function chord_r (x) = 2 * sin(x*degree_per_radian / 2);

// Trigonometrische Umkehrfunktion im Bogenmaß
function asin_r (x) = asin(x) * radian_per_degree;
function acos_r (x) = acos(x) * radian_per_degree;
function atan_r (x) = atan(x) * radian_per_degree;
function atan2_r (y,x) = atan2(y,x) * radian_per_degree;
function acot_r (x) = (90 - atan(x)) * radian_per_degree;
function asec_r   (x) = acos(1 / x) * radian_per_degree;
function acsc_r   (x) = asin(1 / x) * radian_per_degree;
function aexsec_r (x) = acos(1 / (x + 1)) * radian_per_degree;
function aexcsc_r (x) = asin(1 / (x + 1)) * radian_per_degree;
function aversin_r   (x) = acos(1 - x) * radian_per_degree;
function acoversin_r (x) = asin(1 - x) * radian_per_degree;
function avercos_r   (x) = acos(x - 1) * radian_per_degree;
function acovercos_r (x) = asin(x - 1) * radian_per_degree;
function achord_r (x) = 2 * asin(x / 2) * radian_per_degree;

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
