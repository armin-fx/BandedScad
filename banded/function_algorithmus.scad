// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later

use <banded/list_algorithmus.scad>

debug=false;

function summation_fn (label, n, k=0) =
	(n==undef) ?
	 summation_auto_fn (label, k, debug=debug)
	:summation_fn_intern_big(label, n, k)
;
function summation_fn_intern (label, n, k, value=0) =
	 (k>n) ? value
	:summation_fn_intern(label, n, k+1,
		value + select_function(label, k))
;
function summation_fn_intern_big (label, n, k, slice=100000) =
	(n > slice) ?
	 summation_list([ for (i=[k:slice:n]) summation_fn_intern(label, min(i+slice,n), max(i,k)) ])
	:summation_fn_intern(label, n, k)
;
function summation_auto_fn (label, k=0) =
	summation_auto_fn_intern(label, k+1, select_function(label, k), debug=debug)
;
function summation_auto_fn_intern (label, k, value, value_old) =
	(value==value_old) ?
		(debug) ? [value,k] : value
	:	summation_auto_fn_intern (label, k+1,
			value + select_function(label, k),
			value,
			debug=debug)
;

function product_fn (label, n, k=0) = product_fn_intern_big (label, n, k);
function product_fn_intern (label, n, k, value=1) =
	 (k>n) ? value
	:product_fn_intern(label, n, k+1,
		value * select_function(label, k))
;
function product_fn_intern_big (label, n, k, slice=100000) =
	(n > slice) ?
	 product_list([ for (i=[k:slice:n]) product_fn_intern(label, min(i+slice,n), max(i,k)) ])
	:product_fn_intern(label, n, k)
;

function taylor        (label, x, n=0, k=0) = taylor_intern(label, x, n, k);
function taylor_intern (label, x, n,   k,  value=0) =
	(k>n) ? value
	:taylor_intern(label, x, n, k+1,
		value + select_function(label, x, k))
;
function taylor_auto (label, x, n=undef, k=0) =
	(n==undef) ?
	 taylor_auto_intern (label, x, 100000, k+1, select_function(label, x, k), debug=debug)
	:taylor_auto_intern (label, x, n,      k+1, select_function(label, x, k), debug=debug)
;
function taylor_auto_intern (label, x, n, k, value, value_old) =
	(k>n || value==value_old) ?
		((debug) ? [value,k] : value)
	:	taylor_auto_intern (label, x, n, k+1,
			value + select_function(label, x, k),
			value,
			debug=debug)
;

delta_std = 0.001;

function integrate (label, begin, end, constant=0, delta=delta_std) =
	integrate_simpson (label, begin, end, delta, constant)
;
function integrate_midpoint (label, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_midpoint_intern (label, begin, end, (end-begin)/ceil((end-begin)/delta)) + constant
;
function integrate_midpoint_intern (label, begin, end, delta, value=0) =
	(begin>=end) ? value
	: integrate_midpoint_intern (label, begin+delta, end, delta,
		value + select_function(label, begin+delta/2) * delta
		)
;
function integrate_simpson (label, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_simpson_intern (label, begin, end, ceil((end-begin)/2/delta)) + constant
;
function integrate_simpson_intern (label, begin, end, count, position=0, value=0) =
	(position>=count) ? value
	: integrate_simpson_intern (label, begin, end, count, position+1,
		value + area_simpson(label,
			begin+(end-begin)*(position  )/count,
			begin+(end-begin)*(position+1)/count)
		)
;
function integrate_simpson_2 (label, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_simpson_2_intern (label, begin, end, ceil((end-begin)/4/delta)) + constant
;
function integrate_simpson_2_intern (label, begin, end, count, position=0, value=0) =
	(position>=count) ? value
	: integrate_simpson_2_intern (label, begin, end, count, position+1,
		value + area_simpson_2(label,
			begin+(end-begin)*(position  )/count,
			begin+(end-begin)*(position+1)/count)
		)
;
function area_simpson (label, begin, end) =
	( select_function(label, begin)
	+ select_function(label, (begin+end)/2) * 4
	+ select_function(label, end)
	) * (end-begin) / 6
;
function area_simpson_2 (label, begin, end) =
	( 16 * (area_simpson(label,begin,(begin+end)/2) + area_simpson(label,(begin+end)/2,end))
	      - area_simpson(label,begin,end)
	) / 15
;

function derivation (label, value, delta=delta_std) =
	derivation_symmetric_2(label, value, delta)
;
function derivation_symmetric (label, value, delta=delta_std) =
	(select_function(label, value+delta) - select_function(label, value-delta)) / (2*delta)
;
function derivation_symmetric_2 (label, value, delta=dx) =
	//( 4*derivation_symmetric(label,x,delta) - derivation_symmetric(label,x,delta*2) ) / 3
	(   (select_function(label, value+  delta) - select_function(label, value-  delta)) * 2
	  - (select_function(label, value+2*delta) - select_function(label, value-2*delta)) / 4
	) / (3*delta)
;



// funktion(argument) muss value zurückgeben
function find_first_fn (label, value, begin, end, step=1) =
	(sign(step)*begin>=sign(step)*end) ? undef
	:(select_function(label, begin) == value) ?
		 begin
		:find_first_fn(label, value, begin+step, end)
;

