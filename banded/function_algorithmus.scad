// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later

include <banded/constants.scad>
use <banded/list_algorithmus.scad>
use <banded/math_common.scad>
use <banded/math_formula.scad>


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
	 summation([ for (i=[k:slice:n]) summation_fn_intern(fn, min(i+slice,n), max(i,k)) ])
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
	 product([ for (i=[k:slice:n]) product_fn_intern(fn, min(i+slice,n), max(i,k)) ])
	:product_fn_intern(fn, n, k)
;


function taylor        (fn, x, n=0, k=0, step=1) =
	taylor_intern      (fn, x, n, k, step)
;
function taylor_intern (fn, x, n, k, step, value=0) =
	(k>n) ? value :
	taylor_intern (fn, x, n, k+step, step,
		value + fn(x, k)
	)
;

function taylor_auto (fn, x, n=undef, k=0, step=1) =
	(n==undef) ?
	 	taylor_auto_intern (fn, x, 10000, k+step, step, fn (x, k) )
	:	taylor_auto_intern (fn, x, n,     k+step, step, fn (x, k) )
;
function taylor_auto_intern (fn, x, n, k, step, value, value_old) =
	(k>n || value==value_old) ? value :
	taylor_auto_intern (fn, x, n, k+step, step,
		value + fn(x, k),
		value
	)
;


function integrate (fn, begin, end, constant=0, delta=delta_std) =
	integrate_simpson (fn, begin, end, constant, delta)
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


// fn - function with one argument
// m  - function returns a correctur factor
//    - arguments: (a, b, c)
//    - a, b, c:   a list [x, y]
function zero_regula_falsi (fn, a, b, m=undef, deviation=deviation, iteration=200) =
	m==undef
	? zero_regula_falsi_intern   (fn, a, b,    deviation, iteration, fn(a), fn(b))
	: zero_regula_falsi_m_intern (fn, a, b, m, deviation, iteration, fn(a), fn(b))
;
function zero_regula_falsi_intern (fn, a, b, deviation, iteration, ya, yb) =
	let (
		c  = (a*yb - b*ya) / (yb - ya),
		yc = fn (c)
	) // echo("zero_regula_falsi",iteration, c, yc, a, b)
	iteration<=0 || yc!=yc ? c :
	(yc+deviation>=0) && (yc-deviation<=0) ? c :
	(yc*ya)>0 ? zero_regula_falsi_intern (fn, c, b, deviation, iteration-1, yc, yb) :
	            zero_regula_falsi_intern (fn, a, c, deviation, iteration-1, ya, yc)
;
function zero_regula_falsi_m_intern (fn, a, b, m, deviation, iteration, ya, yb) =
	let (
		c  = (a*yb - b*ya) / (yb - ya),
		yc = fn (c)
	) // echo("zero_regula_falsi_m",iteration, c, yc, a, b)
	iteration<=0 || yc!=yc ? c :
	(yc+deviation>=0) && (yc-deviation<=0) ? c :
	(yc*yb)<0 ? zero_regula_falsi_m_intern (fn, b, c, m, deviation, iteration-1, yb, yc)
	          : let( M = m ([a,ya], [b,yb], [c,yc]) )
	            zero_regula_falsi_m_intern (fn, a, c, m, deviation, iteration-1, M*ya, yc)
;

// Function literals to modify zero_regula_falsi()
// to set parameter 'm'
//
// do nothing
regula_falsi_m = function (a,b,c)
	1
;
// Illinois algorithm:
regula_falsi_m_illinois = function (a,b,c)
	0.5
;
// Pegasus algorithm:
regula_falsi_m_pegasus = function (a,b,c)
	b.y/(b.y+c.y)
;
// Anderson-Björck algorithm:
regula_falsi_m_anderson_bjorck = function (a,b,c)
	let ( M=1-(c.y/b.y) )
	M>0 ? M : 0.5
;
// Anderson-Björck algorithm modified with Pegasus algorithm:
regula_falsi_m_anderson_bjorck_pegasus = function (a,b,c)
	let ( M=1-(c.y/b.y) )
	M>0 ? M : b.y/(b.y+c.y)
;
//
function zero_regula_falsi_illinois (fn, a, b, deviation=deviation, iteration=200) =
	zero_regula_falsi (fn, a, b, regula_falsi_m_illinois, deviation, iteration)
;
function zero_regula_falsi_pegasus (fn, a, b, deviation=deviation, iteration=200) =
	zero_regula_falsi (fn, a, b, regula_falsi_m_pegasus, deviation, iteration)
;
function zero_regula_falsi_anderson_bjorck (fn, a, b, deviation=deviation, iteration=200) =
	zero_regula_falsi (fn, a, b, regula_falsi_m_anderson_bjorck, deviation, iteration)
;
function zero_regula_falsi_anderson_bjorck_pegasus (fn, a, b, deviation=deviation, iteration=200) =
	zero_regula_falsi (fn, a, b, regula_falsi_m_anderson_bjorck_pegasus, deviation, iteration);


function zero_regula_falsi_parabola (fn, a, b, deviation=deviation, iteration=200) =
	zero_regula_falsi_parabola_intern (fn, a, b, deviation, iteration, fn(a), fn(b))
;
function zero_regula_falsi_parabola_intern (fn, a, b, deviation, iteration, ya, yb) =
	let (
		xm = (a+b)/2,
		ym = fn ((a+b)/2),
		P  = get_parabola_from_points ([a,ya], [b,yb], [xm,ym]),
		c  = get_parabola_zero (P, chosen=(ya*P[2]<0 ? 1 : -1) ),
		yc = fn (c)
	) // echo("zero_regula_falsi_parabola",iteration, c, yc, a, b)
	iteration<=0 || yc!=yc ? c :
	(yc+deviation>=0) && (yc-deviation<=0) ? c :
	sign(yc)==sign(ya) ? zero_regula_falsi_parabola_intern (fn, c, b, deviation, iteration-1, yc, yb) :
	                     zero_regula_falsi_parabola_intern (fn, a, c, deviation, iteration-1, ya, yc)
;

function zero_bisection (fn, a, b, deviation=deviation, iteration=200) =
	zero_bisection_intern (fn, a, b, deviation, iteration, fn(a), fn(b))
;
function zero_bisection_intern (fn, a, b, deviation, iteration, ya, yb) =
	let (
		c  = (a+b)/2,
		yc = fn (c)
	) // echo("zero_bisection",iteration, c, yc, a, b)
	iteration<=0 || yc!=yc ? c :
	(yc+deviation>=0) && (yc-deviation<=0) ? c :
	sign(yc)==sign(ya) ? zero_bisection_intern (fn, c, b, deviation, iteration-1, yc, yb) :
	                     zero_bisection_intern (fn, a, c, deviation, iteration-1, ya, yc)
;

function zero_secant (fn, a, b, deviation=deviation, iteration=200) =
	zero_secant_intern (fn, a, b, deviation, iteration, fn(a), fn(b))
;
function zero_secant_intern (fn, a, b, deviation, iteration, ya, yb) =
	let (
		c  = (a*yb - b*ya) / (yb - ya),
		yc = fn (c)
	) // echo("zero_secant",iteration, c, yc, a, b)
	iteration<=0 || yc!=yc ? c :
	(yc+deviation>=0) && (yc-deviation<=0) ? c :
	zero_secant_intern (fn, b, c, deviation, iteration-1, yb, yc)
;

function zero_newton (fn, fn_d, x, deviation=deviation, iteration=200) =
	let (
		fn_d_ = fn_d!=undef ? fn_d : function(x) derivation (fn, x)
	)
	zero_newton_intern (fn, fn_d_, x, deviation, iteration)
;
function zero_newton_auto (fn, x, deviation=deviation, iteration=200) =
	let (
		fn_d = function(x) derivation (fn, x)
	)
	zero_newton_intern (fn, fn_d, x, deviation, iteration)
;
function zero_newton_intern (fn, fn_d, x, deviation, iteration) =
	let (
		y   = fn   (x),
		y_d = fn_d (x),
		b   = x - (y / y_d)
	) // echo("zero_newton",iteration, b, y, y_d)
	iteration<=0 || b!=b ? b :
	(y+deviation>=0) && (y-deviation<=0) ? b :
	zero_newton_intern (fn, fn_d, b, deviation, iteration-1)
;

function zero_halley (fn, fn_d, fn_dd, x, deviation=deviation, iteration=200) =
	let (
		fn_d_  = fn_d !=undef ? fn_d  : function(x) derivation (fn   , x),
		fn_dd_ = fn_dd!=undef ? fn_dd : function(x) derivation (fn_d_, x)
	)
	zero_halley_intern (fn, fn_d_, fn_dd_, x, deviation, iteration)
;
function zero_halley_auto (fn, x, deviation=deviation, iteration=200) =
	let (
		fn_d  = function(x) derivation (fn  , x),
		fn_dd = function(x) derivation (fn_d, x)
	)
	zero_halley_intern (fn, fn_d, fn_dd, x, deviation, iteration)
;
function zero_halley_intern (fn, fn_d, fn_dd, x, deviation, iteration) =
	let (
		y    = fn    (x),
		y_d  = fn_d  (x),
		y_dd = fn_dd (x),
		b    =
			x - ( ( 2*y*y_d            )
			    / ( 2*y_d*y_d - y*y_dd ) )
	) // echo("zero_halley",iteration, b, y, y_d, y_dd)
	iteration<=0 || b!=b ? b :
	(y+deviation>=0) && (y-deviation<=0) ? b :
	zero_halley_intern (fn, fn_d, fn_dd, b, deviation, iteration-1)
;

function zero_euler_tschebyschow (fn, fn_d, fn_dd, x, deviation=deviation, iteration=200) =
	let (
		fn_d_  = fn_d !=undef ? fn_d  : function(x) derivation (fn   , x),
		fn_dd_ = fn_dd!=undef ? fn_dd : function(x) derivation (fn_d_, x)
	)
	zero_euler_tschebyschow_intern (fn, fn_d_, fn_dd_, x, deviation, iteration)
;
function zero_euler_tschebyschow_auto (fn, x, deviation=deviation, iteration=200) =
	let (
		fn_d  = function(x) derivation (fn  , x),
		fn_dd = function(x) derivation (fn_d, x)
	)
	zero_euler_tschebyschow_intern (fn, fn_d, fn_dd, x, deviation, iteration)
;
function zero_euler_tschebyschow_intern (fn, fn_d, fn_dd, x, deviation, iteration) =
	let (
		y    = fn    (x),
		y_d  = fn_d  (x),
		y_dd = fn_dd (x),
		s = -y / y_d,
		t = (-1/2) * (y_dd*s*s) / (y_d),
		b = x + s + t
	) // echo("zero_euler_tschebyschow",iteration, b, y, y_d, y_dd)
	iteration<=0 || b!=b ? b :
	(y+deviation>=0) && (y-deviation<=0) ? b :
	zero_euler_tschebyschow_intern (fn, fn_d, fn_dd, b, deviation, iteration-1)
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

