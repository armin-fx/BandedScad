// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later


// wählt Funktionen aus entsprechend der 'Nummer' und führt sie aus
function select_function (label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =
	select_function_intern (label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
;
function select_function_intern (label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =
	 (label==undef) ? undef
	// Liste als Parameter
	:(is_list(label)) ? label[argument]
	// interne Funtionen
	:(label=="Si_taylor_index") ? Si_taylor_index (argument, arg2)
	:(label[0]=="f" && label[1]=="n" && label[2]=="_") ?
	// frei benutzbare funktionen
		 (label=="fn_0") ? fn_0(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_1") ? fn_1(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_2") ? fn_2(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_3") ? fn_3(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_4") ? fn_4(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_5") ? fn_5(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_6") ? fn_6(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_7") ? fn_7(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_8") ? fn_8(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		:(label=="fn_9") ? fn_9(argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	// fuer Benchmark-Zwecke
		:(label=="fn_empty") ? fn_empty()
	// extern definierbare Funktionen
		:select_function_extern(label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	:	 select_function_extern(label, argument, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
;

fn_0="fn_0";
fn_1="fn_1";
fn_2="fn_2";
fn_3="fn_3";
fn_4="fn_4";
fn_5="fn_5";
fn_6="fn_6";
fn_7="fn_7";
fn_8="fn_8";
fn_9="fn_9";

// leere Funktion fuer Benchmark-Zwecke
fn_empty="fn_empty";
function fn_empty () = undef;
