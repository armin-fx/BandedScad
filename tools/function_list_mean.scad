// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later

use <tools/function_list_algorithmus.scad>
use <tools/function_list_math.scad>
use <tools/function_math.scad>

// Ermittelt das Arithmetische Mittel (Durchschnitt) einer Liste
function mean_arithmetic (list, weight, normalize=true) =
	!is_list(weight) ?
		summation_list(list)                       / len(list)
	:normalize ?
		summation_list(multiply_each(list,weight)) / summation_list(weight)
	:	summation_list(multiply_each(list,weight))
;

// ermittelt das Geometrische Mittel einer Liste
function mean_geometric (list, weight, normalize=true) =
	!is_list(weight) ?
		pow( product_list(list)                 , 1/len(list) )
	:normalize ?
	//	pow( product_list(pow_each(list,weight)), 1/summation_list(weight) )
		product_list(pow_each(list,unit_summation(weight)))
	:	product_list(pow_each(list,weight))
;

// ermittelt das Harmonische Mittel einer Liste
function mean_harmonic (list, weight, normalize=true) =
	!is_list(weight) ?
		len(list)              / summation_list( reciprocal_each(list) )
	:normalize ?
		summation_list(weight) / summation_list( divide_each(weight,list) )
	:	1                      / summation_list( divide_each(weight,list) )
;

// ermittelt das Quadratische Mittel (RMS) einer Liste
function root_mean_square (list, weight, normalize=true) =
	!is_list(weight) ?
		sqrt( summation_list(                       sqr_each(list) )   / len(list) )
	:normalize ?
		sqrt( summation_list( multiply_each(weight, sqr_each(list) ) ) / summation_list(weight) )
	:	sqrt( summation_list( multiply_each(weight, sqr_each(list) ) ) )
;

// ermittelt das Kubische Mittel einer Liste
function mean_cubic (list, weight, normalize=true) =
	!is_list(weight) ?
		pow( summation_list(                       [for (a=list) a*a*a] )   / len(list)             , 1/3 )
	:normalize ?
		pow( summation_list( multiply_each(weight, [for (a=list) a*a*a] ) ) / summation_list(weight), 1/3 )
	:	pow( summation_list( multiply_each(weight, [for (a=list) a*a*a] ) )                         , 1/3 )
;

// Verallgemeinerter Mittelwert oder Hölder-Mittel einer Liste
function mean_generalized (p, list, weight, normalize=true) =
	p==0 ? mean_geometric(list, weight, normalize) :
	!is_list(weight) ?
		pow( summation_list( pow_each(list,p) )  / len(list)          , 1/p )
	:normalize ?
		pow( summation_list( multiply_each(unit_summation(weight), pow_each(list,p)) ), 1/p )
	:	pow( summation_list( multiply_each(weight                , pow_each(list,p)) ), 1/p )
;

// Ermittelt den Median Wert aus einer Liste
function median (list) =
	(!is_list(list)) || (len(list)<1) ? undef :
	let (
		s = sort_list(list),
		l = len(list)
	)
	is_odd(l) ? s[(l-1)/2]
	:           (s[l/2-1] + s[l/2]) / 2
;

function mid_range (list) =
	(min(list) + max(list)) / 2
;
