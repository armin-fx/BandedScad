// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche mathematische Funktionen

include <banded/constants.scad>
//
use <banded/helper_native.scad>


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

// testet zwei Werte oder zwei Listen mit Werten ob sie näherungsweise übereinstimmen
// deviation - maximale Abweichung der Werte
function is_nearly (a, b, deviation=1e-14) =
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
function arsinh (x) = ln(x + sqrt(x*x + 1));
// Umkehrfunktion Hyperbelkosinus
function arcosh (x) =
	(x >= 1) ?
	  ln(x + sqrt(x*x - 1))
	: undef
;
// Umkehrfunktion Hyperbeltangens
function artanh (x) = ln((1 + x) / (1 - x)) / 2;
// Umkehrfunktion Hyperbelkotangens
function arcoth (x) = ln((x + 1) / (x - 1)) / 2;
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


// Funktionen mit ganze Zahlen:

// errechnet die Fakultät einer natürlichen Zahl
function factorial (n) =
	 (n  < 0) ? undef
	:factorial_intern(n)
;
function factorial_intern (n) =
	 (n <= 1) ? 1
	: n * factorial_intern(n - 1)
;

// errechnet die doppelte Fakultät einer natürlichen Zahl
function double_factorial (n) =
	 (n>=-1 && n<=1) ? 1
	:(n>1) ?
		double_factorial(n - 2) * n
	:(n%2!=0) ?
		double_factorial(n + 2) / (n + 2)
	:undef
;

// Multifakultät einer natürlichen Zahl n mit der k-fachen Fakultät
function multi_factorial (n, k) =
	 (k < 1)        ? undef
	:(n>-k && n<=1) ? 1
	:(n> 1 && n<=k) ? n
	:(n> k) ?
		multi_factorial(n - k, k) * n
	:(n%k!=0) ?
		multi_factorial(n + k, k) / (n + k)
	:undef
;

// errechnet den Binominalkoeffizienten n über k
function binomial_coefficient (n, k) =
	 (2*k <= n) ?
	 binomial_coefficient_intern(n-k, k  )
	:binomial_coefficient_intern(k  , n-k)
;
function binomial_coefficient_intern (n_minus_k, j) =
	 (j< 0) ? 0
	:(j==0) ? 1
	:binomial_coefficient_intern_calc(n_minus_k, j)
;
function binomial_coefficient_intern_calc (n_minus_k, j) =
	 (j==1) ? n_minus_k + 1
	:binomial_coefficient_intern_calc(n_minus_k, j-1) * (n_minus_k + j) / j
;

// Fibonacci-Folge errechnen, geht auch mit reelle Zahlen
function fibonacci (n) =
//	( pow(golden,n) - pow(-1/golden,n) ) / sqrt(5)
//	( pow(golden,n) - pow(1-golden ,n) ) / sqrt(5)
	( pow(golden,n) - cos(180*n)*pow(golden,-n) ) / sqrt(5)
;

// Kettenbruch
// a0 + b1 / (a1 + b2 / (a2 + (...))))
// Argumente:
//   a - Liste mit Teilnenner
//   b - Liste mit Teilzähler (1 Element kleiner als a)
//       ohne Angabe werden alle Werte von b[] auf 1 gesetzt, entspricht regulären Kettenbruch
function continued_fraction (a, b=undef) =
	continued_fraction_intern(a, b)
;
function continued_fraction_intern (a, b, pos=0) =
	(pos+1 >= len(a)) ? a[pos]
	:a[pos] + get_first_good(b[pos], 1) / continued_fraction_intern(a, b, pos+1)
;
/*
function continued_fraction_intern_ (b, a, pos=0) =
	 (pos==0) ? b[0] + continued_fraction_intern(b, a, pos+1)
	:(pos >= len(b)) ? 0
	:get_first_good(a[pos-1], 1) / (b[pos] +  continued_fraction_intern_(b, a, pos+1) )
;
*/


// Größter gemeinsamer Teiler
function ggt (a, b=0) =  // deutscher Name
	 (a==0) ? abs(b)
	:(b==0) ? abs(a)
	:ggt_intern(round(a),round(b))
;
function ggt_intern (a,b) =
	(b==0) ? a
	:ggt_intern(b, a%b)
;
function gcd (a, b=0) = ggt (a, b); // english name

// Kleinstes gemeinsames Vielfaches
function kgv (a, b=1) = a/ggt(a,b) * b; // deutscher Name
function lcm (a, b=1) = kgv (a, b);     // english name

