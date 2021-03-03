// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later


// Benchmark ausführen
// Testfunktion fn_test() muss dafür definiert werden
//   1. fn_test() als Funktion definieren
//   2. seit OpenSCAD Version 2021.01: Funktionsliteral übergeben über Option fn_test
// count = Anzahl der Schleifendurchgänge (0 => 1 Aufruf)
function benchmark (count=0, fn_test) =
	(fn_test!=undef && !is_function(fn_test)) ?
		benchmark_select (count, fn_test)
	:
	let( Count = (is_num(count) && count>=0) ? count : 0
		,c = max( floor(sqrt((Count+1)*2)-1), 0)
		,r = Count - (ceil((c+1)*(c+1)/2)-floor(c/2))
	)
	benchmark_intern  (c, fn_test,
	benchmark_intern_2(r, fn_test) )
;
function benchmark_intern (count=0, fn_test, trash) =
	(count<=0) ? fn_test() :
	benchmark_intern  (count-1, fn_test,
	benchmark_intern_2(count  , fn_test) )
;
function benchmark_intern_2 (count=0, fn_test, trash) =
	(count<=0) ? 0 :
	benchmark_intern_2(count-1, fn_test,
	fn_test() )
;

// ruft select_function() mit der entsprechenden Kennung der Testfunktion auf
function benchmark_select (count=0, fn, arg, arg2, arg3, arg4) =
	let( Count = (is_num(count) && count>=0) ? count : 0
		,c = max( floor(sqrt((Count+1)*2)-1), 0)
		,r = Count - (ceil((c+1)*(c+1)/2)-floor(c/2))
	)
	benchmark_select_intern  (c, fn, arg, arg2, arg3, arg4,
	benchmark_select_intern_2(r, fn, arg, arg2, arg3, arg4) )
;
function benchmark_select_intern (count=0, fn, arg, arg2, arg3, arg4, trash) =
	(count<=0) ? select_function      (fn, arg, arg2, arg3, arg4) :
	benchmark_select_intern  (count-1, fn, arg, arg2, arg3, arg4,
	benchmark_select_intern_2(count  , fn, arg, arg2, arg3, arg4) )
;
function benchmark_select_intern_2 (count=0, fn, arg, arg2, arg3, arg4, trash) =
	(count<=0) ? 0 :
	benchmark_select_intern_2(count-1, fn, arg, arg2, arg3, arg4,
	select_function                   (fn, arg, arg2, arg3, arg4) )
;
