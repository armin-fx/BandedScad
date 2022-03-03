// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later

use <banded/list_algorithmus.scad>

function summation_fn (fn, n, k=0) =
	(n==undef) ?
	 summation_auto_fn (fn, k)
	:summation_fn_intern_big(fn, n, k)
;
function summation_fn_intern (fn, n, k, value=0) =
	(k>n) ? value :
	summation_fn_intern(fn, n, k+1,
		value==0 ? fn(k) : value + fn(k)
	)
;
function summation_fn_intern_big (fn, n, k, slice=100000) =
	(n > slice) ?
	 summation_list([ for (i=[k:slice:n]) summation_fn_intern(fn, min(i+slice,n), max(i,k)) ])
	:summation_fn_intern(fn, n, k)
;

function summation_auto_fn (fn, k=0) =
	summation_auto_fn_intern (fn, k+1, fn(k) )
;
function summation_auto_fn_intern (fn, k, value, value_old) =
	(value==value_old) ? value
	:	summation_auto_fn_intern (fn, k+1,
			value + fn(k),
			value
		)
;

function product_fn (fn, n, k=0) =
	product_fn_intern_big (fn, n, k)
;
function product_fn_intern (fn, n, k, value=1) =
	(k>n) ? value :
	product_fn_intern(fn, n, k+1,
		value * fn(k)
	)
;
function product_fn_intern_big (fn, n, k, slice=100000) =
	(n > slice) ?
	 product_list([ for (i=[k:slice:n]) product_fn_intern(fn, min(i+slice,n), max(i,k)) ])
	:product_fn_intern(fn, n, k)
;

function taylor        (fn, x, n=0, k=0) =
	taylor_intern      (fn, x, n, k)
;
function taylor_intern (fn, x, n, k, value=0) =
	(k>n) ? value :
	taylor_intern (fn, x, n, k+1,
		value + fn(x, k)
	)
;

function taylor_auto (fn, x, n=undef, k=0) =
	(n==undef) ?
	 	taylor_auto_intern (fn, x, 100000, k+1, fn (x, k) )
	:	taylor_auto_intern (fn, x, n,      k+1, fn (x, k) )
;
function taylor_auto_intern (fn, x, n, k, value, value_old) =
	(k>n || value==value_old) ? value :
	taylor_auto_intern (fn, x, n, k+1,
		value + fn(x, k),
		value
	)
;

delta_std = 0.001;

function integrate (fn, begin, end, constant=0, delta=delta_std) =
	integrate_simpson (fn, begin, end, delta, constant)
;
//
function integrate_midpoint (fn, begin, end, constant=0, delta=delta_std) =
	(begin>end) ? undef :
	(delta<=0)  ? undef :
	let(
		delta_balanced = (end-begin)/ceil((end-begin)/delta)
	)
	integrate_midpoint_intern      (fn, begin, end, delta_balanced) + constant
;
function integrate_midpoint_intern (fn, begin, end, delta, value=0) =
	(begin>=end) ? value :
	integrate_midpoint_intern (fn, begin+delta, end, delta,
		value + fn(begin+delta/2) * delta
	)
;
//
function integrate_simpson (fn, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_simpson_intern (fn, begin, end, ceil((end-begin)/2/delta)) + constant
;
function integrate_simpson_intern (fn, begin, end, count, position=0, value=0) =
	(position>=count) ? value
	: integrate_simpson_intern (fn, begin, end, count, position+1,
		value + area_simpson(fn,
			begin+(end-begin)*(position  )/count,
			begin+(end-begin)*(position+1)/count)
		)
;
//
function integrate_simpson_2 (fn, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_simpson_2_intern (fn, begin, end, ceil((end-begin)/4/delta)) + constant
;
function integrate_simpson_2_intern (fn, begin, end, count, position=0, value=0) =
	(position>=count) ? value
	: integrate_simpson_2_intern (fn, begin, end, count, position+1,
		value + area_simpson_2(fn,
			begin+(end-begin)*(position  )/count,
			begin+(end-begin)*(position+1)/count)
		)
;
//
function area_simpson (fn, begin, end) =
	let( mid=(begin+end)/2 )
	( fn(begin)
	+ fn(mid) * 4
	+ fn(end)
	) * (end-begin) / 6
;

function area_simpson_2 (fn, begin, end) =
	let( mid=(begin+end)/2 )
	( 16 * (area_simpson(fn,begin,mid) + area_simpson(fn,mid,end))
	      - area_simpson(fn,begin,end)
	) / 15
;

function derivation (fn, value, delta=delta_std) =
	derivation_symmetric_2(fn, value, delta)
;
function derivation_symmetric (fn, value, delta=delta_std) =
	(fn(value+delta) - fn(value-delta)) / (2*delta)
;
function derivation_symmetric_2 (fn, value, delta=delta_std) =
	// ( 4*derivation_symmetric(fn,value,delta) - derivation_symmetric(fn,value,delta*2) ) / 3
	( (fn(value+  delta) - fn(value-  delta)) * 2
	- (fn(value+2*delta) - fn(value-2*delta)) / 4
	) / (3*delta)
;


// funktion(argument) muss value zurückgeben
function find_first_fn (fn, value, begin, end, step=1) =
	let(
		 Begin = is_num(begin) ? begin : 0
		,End   = is_num(end)   ? end   : 0
		,Step  = is_num(step)&&step!=0 ? step : 1
	)
	find_first_fn_intern        (fn, value, Begin, End, Step)
;
function find_first_fn_intern (fn, value, begin, end, step=1) =
	(sign(step)*begin>=sign(step)*end) ? undef :
	(fn(begin) == value) ?
		 begin
		:find_first_fn_intern(fn, value, begin+step, end, step)
;

