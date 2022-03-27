// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält mathematische Funktionen mit natürlichen Zahlen

include <banded/constants.scad>


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
	:a[pos] + (b[pos]!=undef ? b[pos] : 1) / continued_fraction_intern(a, b, pos+1)
;
/*
function continued_fraction_intern_ (b, a, pos=0) =
	 (pos==0) ? b[0] + continued_fraction_intern(b, a, pos+1)
	:(pos >= len(b)) ? 0
	:(a[pos-1]!=undef ? a[pos-1] : 1) / (b[pos] +  continued_fraction_intern_(b, a, pos+1) )
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
