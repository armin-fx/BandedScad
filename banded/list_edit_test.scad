// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Testen von Listen auf den Inhalt
// Der Inhalt wird mit einer übergebenen Funktion bearbeitet

use <banded/helper.scad>

use <banded/list_edit_type.scad>


// Führt Funktion 'f' auf die Elemente in der Liste aus und
// gibt 'true' zurück, wenn alle Aufrufe von f() 'true' zurückgeben
function all_of (list, f, type=0, begin, last, count, range) =
	list==undef ? true :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	all_of_intern      (list, f, type, Range[0], Range[1])
;
function all_of_intern (list, f, type=0, begin=0, last=-1) =
	begin>last ? true :
	 type   == 0                   ? len([for(i=[begin:1:last]) if (f( list[i]                 )!=true) 0]) == 0
	:type[0]>= 0                   ? len([for(i=[begin:1:last]) if (f( list[i][type[0]]        )!=true) 0]) == 0
	:type[0]==-1 ? let( fn=type[1] ) len([for(i=[begin:1:last]) if (f( fn(list[i])             )!=true) 0]) == 0
	:                                len([for(i=[begin:1:last]) if (f( get_value(list[i],type) )!=true) 0]) == 0
;

// Führt Funktion 'f' auf die Elemente in der Liste aus und
// gibt 'true' zurück, wenn keine Aufrufe von f() 'true' zurückgeben
function none_of (list, f, type=0, begin, last, count, range) =
	list==undef ? false :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	none_of_intern      (list, f, type, Range[0], Range[1])
;
function none_of_intern (list, f, type=0, begin=0, last=-1) =
	begin>last ? false :
	 type   == 0                   ? len([for(i=[begin:1:last]) if (f( list[i]                 )==true) 0]) == 0
	:type[0]>= 0                   ? len([for(i=[begin:1:last]) if (f( list[i][type[0]]        )==true) 0]) == 0
	:type[0]==-1 ? let( fn=type[1] ) len([for(i=[begin:1:last]) if (f( fn(list[i])             )==true) 0]) == 0
	:                                len([for(i=[begin:1:last]) if (f( get_value(list[i],type) )==true) 0]) == 0
;

// Führt Funktion 'f' auf die Elemente in der Liste aus und
// gibt 'true' zurück, wenn mindestens 1 Aufruf von f() 'true' zurückgibt
function any_of (list, f, type=0, begin, last, count, range) =
	list==undef ? true :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	any_of_intern      (list, f, type, Range[0], Range[1])
;
function any_of_intern (list, f, type=0, begin=0, last=-1) =
	begin>last ? true :
	 type   == 0                   ? len([for(i=[begin:1:last]) if (f( list[i]                 )==true) 0]) > 0
	:type[0]>= 0                   ? len([for(i=[begin:1:last]) if (f( list[i][type[0]]        )==true) 0]) > 0
	:type[0]==-1 ? let( fn=type[1] ) len([for(i=[begin:1:last]) if (f( fn(list[i])             )==true) 0]) > 0
	:                                len([for(i=[begin:1:last]) if (f( get_value(list[i],type) )==true) 0]) > 0
;
