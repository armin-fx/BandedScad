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

// Testet 2 Listen nach Gleichheit und gibt 'true' bei Erfolg zurück
// Vergleicht die Daten direkt oder mit Funktion 'f', wenn angegeben
function equal (list1, list2, begin1=0, begin2=0, count=undef, type=0, f=undef) =
	let (
		Range1 = parameter_range_safe (list1, begin1, undef, count, undef),
		Range2 = parameter_range_safe (list2, begin2, undef, count, undef),
		Begin1 = Range1[0],
		Begin2 = Range2[0],
		Count  = Range1[1] - Range1[0] + 1,
		Count2 = Range2[1] - Range2[0] + 1
	)
	Count!=Count2 ? false :
	
	f==undef ?
		 type   == 0                   ? len([for(i=[0:1:Count-1]) if (list1[Begin1+i]                 != list2[Begin2+i]                ) 0]) == 0
		:type[0]>= 0                   ? len([for(i=[0:1:Count-1]) if (list1[Begin1+i][type[0]]        != list2[Begin2+i][type[0]]       ) 0]) == 0
		:type[0]==-1 ? let( fn=type[1] ) len([for(i=[0:1:Count-1]) if (fn(list1[Begin1+i])             != fn(list2[Begin2+i])            ) 0]) == 0
		:                                len([for(i=[0:1:Count-1]) if (get_value(list1[Begin1+i],type) != get_value(list1[Begin1+i],type)) 0]) == 0
	:
		 type   == 0                   ? len([for(i=[0:1:Count-1]) if (f( list1[Begin1+i]                , list2[Begin2+i]                ) !=true) 0]) == 0
		:type[0]>= 0                   ? len([for(i=[0:1:Count-1]) if (f( list1[Begin1+i][type[0]]       , list2[Begin2+i][type[0]]       ) !=true) 0]) == 0
		:type[0]==-1 ? let( fn=type[1] ) len([for(i=[0:1:Count-1]) if (f( fn(list1[Begin1+i])            , fn(list2[Begin2+i])            ) !=true) 0]) == 0
		:                                len([for(i=[0:1:Count-1]) if (f( get_value(list1[Begin1+i],type), get_value(list1[Begin1+i],type)) !=true) 0]) == 0
;
