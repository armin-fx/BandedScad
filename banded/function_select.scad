// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later


// wählt Funktionen aus entsprechend der 'Nummer' und führt sie aus
function select_function (fn, arg, arg2, arg3, arg4) =
	// select_function_intern (fn, arg, arg2, arg3, arg4)
	
	// inline function select_function_intern() for speed up:
	
	// function literal call or run defined function fn()
	(fn==undef || is_function(fn)) ?
		 arg4!=undef ? fn (arg, arg2, arg3, arg4)
		:arg3!=undef ? fn (arg, arg2, arg3)
		:arg2!=undef ? fn (arg, arg2)
		:arg !=undef ? fn (arg)
		:              fn ()
	// intern functions
	:(fn=="Si_taylor_index") ? Si_taylor_index (arg, arg2)
	// list as parameter
	:(is_list(fn)) ? fn[arg]
	// for benchmark reason
	:(fn=="fn_empty") ? fn_empty()
	// extern definable functions
	:select_function_extern(fn, arg, arg2, arg3, arg4)
;

function select_function_intern (fn, arg, arg2, arg3, arg4) =
	// function literal call or run defined function fn()
	(fn==undef || is_function(fn)) ?
		 arg4!=undef ? fn (arg, arg2, arg3, arg4)
		:arg3!=undef ? fn (arg, arg2, arg3)
		:arg2!=undef ? fn (arg, arg2)
		:arg !=undef ? fn (arg)
		:              fn ()
	// intern functions
	:(fn=="Si_taylor_index") ? Si_taylor_index (arg, arg2)
	// list as parameter
	:(is_list(fn)) ? fn[arg]
	// for benchmark reason
	:(fn=="fn_empty") ? fn_empty()
	// extern definable functions
	:select_function_extern(fn, arg, arg2, arg3, arg4)
;

function is_select_function (fn) = ! (fn==undef || is_function(fn));

// empty function for benchmark reason
fn_empty="fn_empty";
function fn_empty () = undef;
