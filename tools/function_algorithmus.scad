// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later


//
function select_function (number, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =
	 (number==undef) ? undef
	// Liste als Parameter
	:(is_list(number)) ? number[argument]
	// interne Funtionen
	:(number==Si_taylor_index)   ? Si_taylor_index  (argument, arg2)
	// frei benutzbare funktionen
	:(number==fn_0) ? fn_0(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_1) ? fn_1(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_2) ? fn_2(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_3) ? fn_3(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_4) ? fn_4(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_5) ? fn_5(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_6) ? fn_6(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_7) ? fn_7(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_8) ? fn_8(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:(number==fn_9) ? fn_9(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	 // fuer Benchmark-Zwecke
	:(number==fn_empty) ? fn_empty()
	// extern definierbare Funktionen
	:select_function_extern(number, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
;
fn_0=str("fn_0");
fn_1=str("fn_1");
fn_2=str("fn_2");
fn_3=str("fn_3");
fn_4=str("fn_4");
fn_5=str("fn_5");
fn_6=str("fn_6");
fn_7=str("fn_7");
fn_8=str("fn_8");
fn_9=str("fn_9");

// leere Funktion fuer Benchmark-Zwecke
fn_empty=str("fn_empty");
function fn_empty () = undef;

// Benchmark ausführen
// Testfunktion fn_test() muss dafür definiert werden
// count = Anzahl der Schleifendurchgänge (0 => 1 Aufruf)
function function_benchmark (count=0) = function_benchmark_intern( ceil(sqrt(count/2)) );
function function_benchmark_intern (count=0) =
	(count==0) ? fn_test() : function_benchmark_intern(count-1) + function_benchmark_intern_2(count)
;
function function_benchmark_intern_2 (count) =
	(count==0) ? 0 : function_benchmark_intern_2(count-1) + 0 * fn_test()
;


debug=false;

function summation (number, n, k=0) =
	(n==undef) ?
	 summation_intern_auto(number, k+1, select_function(number, k), debug=debug)
	:summation_intern_big(number, n, k)
;
function summation_intern_big (number, n, k, slice=100000) =
	(n > slice) ?
	 summation_list([ for (i=[k:slice:n]) summation_intern(number, min(i+slice,n), max(i,k)) ])
	:summation_intern(number, n, k)
;
function summation_intern (number, n, k, value=0) =
	 (k>n) ? value
	:summation_intern(number, n, k+1,
		value + select_function(number, k))
;
function summation_intern_auto (number, k, value, value_old) =
	(value==value_old) ?
		(debug) ? [value,k] : value
	:	summation_intern_auto (number, x, k+1,
			value + select_function(number, k),
			value,
			debug)
;
//
function summation_list (list, n, k=0) =
	let (
	last = (n==undef) ? len(list)-1
	       :            min(n, len(list)-1)
	)
	(k>last) ? undef :
	summation_list_intern(list, last, k)
;
function summation_list_intern (list, n, k) =
	(k==n) ? list[k]
	:is_split_block(8,n,k) ?
		let (mid_n = split_block(8,n,k))
		summation_list_intern_8(list, mid_n, k) +
		summation_list_intern  (list, n,     mid_n+1)
	:
		summation_list_intern_1(list, n, k)
;
function summation_list_intern_1 (list, n, k, value=0) =
	(k>n) ? value :
	summation_list_intern_1(list, n, k+1, value + list[k])
;
function summation_list_intern_8 (list, n, k) =
    let (
	new_list = [ for (i=[k:8:n-7])
		list[i]   + list[i+1] + list[i+2] + list[i+3] +
		list[i+4] + list[i+5] + list[i+6] + list[i+7]
	] )
	summation_list_intern (new_list, len(new_list)-1, 0)
;

function product (number, n, k=0) = product_intern (number, n, k);
function product_intern (number, n, k, value=1) =
	 (k>n) ? value
	:product_intern(number, n, k+1,
		value * select_function(number, k))
;
//
function product_list (list, n, k=0) =
	let (
	last = (n==undef) ? len(list)-1
	       :            min(n, len(list)-1)
	)
	(k>last) ? undef :
	product_list_intern(list, last, k)
;
function product_list_intern (list, n, k) =
	(k==n) ? list[k]
	:is_split_block(8,n,k) ?
		let (mid_n = split_block(8,n,k))
		product_list_intern_8(list, mid_n, k) *
		product_list_intern  (list, n,     mid_n+1)
	:
		product_list_intern_1(list, n, k)
;
function product_list_intern_1 (list, n, k, value=1) =
	(k>n) ? value :
	product_list_intern_1(list, n, k+1, value * list[k])
;
function product_list_intern_8 (list, n, k) =
    let (
	new_list = [ for (i=[k:8:n-7])
		list[i]   * list[i+1] * list[i+2] * list[i+3] *
		list[i+4] * list[i+5] * list[i+6] * list[i+7]
	] )
	product_list_intern (new_list, len(new_list)-1, 0)
;

function taylor        (number, x, n=0, k=0) = taylor_intern(number, x, n, k);
function taylor_intern (number, x, n,   k,  value=0) =
	(k>n) ? value
	:taylor_intern(number, x, n, k+1,
		value + select_function(number, x, k))
;
function taylor_auto (number, x, n=undef, k=0) =
	(n==undef) ?
	 taylor_auto_intern (number, x, 100000, k+1, select_function(number, x, k), debug=debug)
	:taylor_auto_intern (number, x, n,      k+1, select_function(number, x, k), debug=debug)
;
function taylor_auto_intern (number, x, n, k, value, value_old) =
	(k>n || value==value_old) ?
		((debug) ? [value,k] : value)
	:	taylor_auto_intern (number, x, n, k+1,
			value + select_function(number, x, k),
			value,
			debug)
;

delta_std = 0.001;

function integrate (number, begin, end, constant=0, delta=delta_std) =
	integrate_simpson (number, begin, end, delta, constant)
;
function integrate_midpoint (number, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_midpoint_intern (number, begin, end, (end-begin)/ceil((end-begin)/delta)) + constant
;
function integrate_midpoint_intern (number, begin, end, delta, value=0) =
	(begin>=end) ? value
	: integrate_midpoint_intern (number, begin+delta, end, delta,
		value + select_function(number, begin+delta/2) * delta
		)
;
function integrate_simpson (number, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_simpson_intern (number, begin, end, ceil((end-begin)/2/delta)) + constant
;
function integrate_simpson_intern (number, begin, end, count, position=0, value=0) =
	(position>=count) ? value
	: integrate_simpson_intern (number, begin, end, count, position+1,
		value + area_simpson(number,
			begin+(end-begin)*(position  )/count,
			begin+(end-begin)*(position+1)/count)
		)
;
function integrate_simpson_2 (number, begin, end, constant=0, delta=delta_std) =
	 (begin>end) ? undef
	:(delta<=0)  ? undef
	:integrate_simpson_2_intern (number, begin, end, ceil((end-begin)/4/delta)) + constant
;
function integrate_simpson_2_intern (number, begin, end, count, position=0, value=0) =
	(position>=count) ? value
	: integrate_simpson_2_intern (number, begin, end, count, position+1,
		value + area_simpson_2(number,
			begin+(end-begin)*(position  )/count,
			begin+(end-begin)*(position+1)/count)
		)
;
function area_simpson (number, begin, end) =
	( select_function(number, begin)
	+ select_function(number, (begin+end)/2) * 4
	+ select_function(number, end)
	) * (end-begin) / 6
;
function area_simpson_2 (number, begin, end) =
	( 16 * (area_simpson(number,begin,(begin+end)/2) + area_simpson(number,(begin+end)/2,end))
	      - area_simpson(number,begin,end)
	) / 15
;

function derivation (number, value, delta=delta_std) =
	derivation_symmetric_2(number, value, delta)
;
function derivation_symmetric (number, value, delta=delta_std) =
	(select_function(number, value+delta) - select_function(number, value-delta)) / (2*delta)
;
function derivation_symmetric_2 (number, value, delta=dx) =
	//( 4*derivation_symmetric(number,x,delta) - derivation_symmetric(number,x,delta*2) ) / 3
	(   (select_function(number, value+  delta) - select_function(number, value-  delta)) * 2
	  - (select_function(number, value+2*delta) - select_function(number, value-2*delta)) / 4
	) / (3*delta)
;



// funktion(argument) muss value zurückgeben
function function_find_first (number, value, begin, end, step=1) =
	(sign(step)*begin>=sign(step)*end) ? undef
	:(select_function(number, begin) == value) ?
		 begin
		:function_find_first(number, value, begin+step, end)
;

