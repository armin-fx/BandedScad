// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later


// Benchmark ausführen
// Testfunktion fn_test() muss dafür definiert werden
// count = Anzahl der Schleifendurchgänge (0 => 1 Aufruf)
function function_benchmark (count=0) =
	let( c = max( floor(sqrt((count+1)*2)-1), 0)
	   , r = count - (ceil((c+1)*(c+1)/2)-floor(c/2))
	)
	function_benchmark_intern  (c) +
	function_benchmark_intern_2(r)
;
function function_benchmark_intern (count=0) =
	(count<=0) ? fn_test() :
	function_benchmark_intern  (count-1) +
	function_benchmark_intern_2(count)
;
function function_benchmark_intern_2 (count=0) =
	(count<=0) ? 0 :
	function_benchmark_intern_2(count-1) +
	fn_test() * 0
;

// ruft select_function() mit der entsprechenden Kennung der Testfunktion auf
function function_benchmark_select (count=0, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =
	let( c = max( floor(sqrt((count+1)*2)-1), 0)
	   , r = count - (ceil((c+1)*(c+1)/2)-floor(c/2))
	)
	function_benchmark_select_intern  (c, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) +
	function_benchmark_select_intern_2(r, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
;
function function_benchmark_select_intern (count=0, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =
	(count<=0) ? select_function(label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) :
	function_benchmark_select_intern  (count-1, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) +
	function_benchmark_select_intern_2(count  , label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
;
function function_benchmark_select_intern_2 (count=0, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =
	(count<=0) ? 0 :
	function_benchmark_select_intern_2(count-1, label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) +
	select_function(label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) * 0
;
