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
		:                                len([for(i=[0:1:Count-1]) if (get_value(list1[Begin1+i],type) != get_value(list2[Begin1+i],type)) 0]) == 0
	:
		 type   == 0                   ? len([for(i=[0:1:Count-1]) if (f( list1[Begin1+i]                , list2[Begin2+i]                ) !=true) 0]) == 0
		:type[0]>= 0                   ? len([for(i=[0:1:Count-1]) if (f( list1[Begin1+i][type[0]]       , list2[Begin2+i][type[0]]       ) !=true) 0]) == 0
		:type[0]==-1 ? let( fn=type[1] ) len([for(i=[0:1:Count-1]) if (f( fn(list1[Begin1+i])            , fn(list2[Begin2+i])            ) !=true) 0]) == 0
		:                                len([for(i=[0:1:Count-1]) if (f( get_value(list1[Begin1+i],type), get_value(list2[Begin1+i],type)) !=true) 0]) == 0
;

// Testet eine Liste ob diese sortiert ist und gibt bei Erfolg 'true' zurück
// Vergleicht die Daten mit dem Operator '<' oder mit Funktion 'f', wenn angegeben
function is_sorted (list, f=undef, type=0, begin, last, count, range) =
	list==undef ? true :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	is_sorted_intern (list, f, type, Range[0], Range[1])
;
function is_sorted_intern (list, f=undef, type=0, begin=0, last=-1) =
	f==undef ?
		 type   == 0                   ? len([for(i=[begin:1:last-1]) if (list[i+1]                 < list[i]                ) 0]) == 0
		:type[0]>= 0                   ? len([for(i=[begin:1:last-1]) if (list[i+1][type[0]]        < list[i][type[0]]       ) 0]) == 0
		:type[0]==-1 ? let( fn=type[1] ) len([for(i=[begin:1:last-1]) if (fn(list[i+1])             < fn(list[i])            ) 0]) == 0
		:                                len([for(i=[begin:1:last-1]) if (get_value(list[i+1],type) < get_value(list[i],type)) 0]) == 0
	:
		 type   == 0                   ? len([for(i=[begin:1:last-1]) if (f( list[i+1]                , list[i]                )) 0]) == 0
		:type[0]>= 0                   ? len([for(i=[begin:1:last-1]) if (f( list[i+1][type[0]]       , list[i][type[0]]       )) 0]) == 0
		:type[0]==-1 ? let( fn=type[1] ) len([for(i=[begin:1:last-1]) if (f( fn(list[i+1])            , fn(list[i])            )) 0]) == 0
		:                                len([for(i=[begin:1:last-1]) if (f( get_value(list[i+1],type), get_value(list[i],type))) 0]) == 0
;

// Testet eine Liste ob diese sortiert ist und gibt die erste Position zurück, die nicht sortiert ist.
// Vergleicht die Daten mit dem Operator '<' oder mit Funktion 'f', wenn angegeben
function is_sorted_until (list, f=undef, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	f==undef ?
		 type   == 0 ? is_sorted_until_intern_direct   (list,          Range[0], Range[1])
		:type[0]>= 0 ? is_sorted_until_intern_list     (list, type[0], Range[0], Range[1])
		:type[0]==-1 ? is_sorted_until_intern_function (list, type[1], Range[0], Range[1])
		:              is_sorted_until_intern_type     (list, type   , Range[0], Range[1])
	:
		 type   == 0 ? is_sorted_until_intern_f_direct   (list, f,          Range[0], Range[1])
		:type[0]>= 0 ? is_sorted_until_intern_f_list     (list, f, type[0], Range[0], Range[1])
		:type[0]==-1 ? is_sorted_until_intern_f_function (list, f, type[1], Range[0], Range[1])
		:              is_sorted_until_intern_f_type     (list, f, type   , Range[0], Range[1])
;
//
function is_sorted_until_intern_direct (list, begin=0, last=-1) =
	begin>=last ? begin+1:
	(list[begin+1] < list[begin]) ? begin+1 :
	is_sorted_until_intern_direct (list, begin+1, last)
;
function is_sorted_until_intern_list (list, position=0, begin=0, last=-1) =
	begin>=last ? begin+1:
	(list[begin+1][position] < list[begin][position]) ? begin+1 :
	is_sorted_until_intern_list (list, position, begin+1, last)
;
function is_sorted_until_intern_function (list, fn, begin=0, last=-1) =
	begin>=last ? begin+1:
	is_sorted_until_intern_function_loop (list, fn, begin, last, fn(list[begin]), fn(list[begin+1]))
;
function is_sorted_until_intern_function_loop (list, fn, begin=0, last=-1, this, next) =
	(next < this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	is_sorted_until_intern_function_loop (list, fn, begin+1, last, next, fn(list[begin+2]))
;
function is_sorted_until_intern_type (list, type, begin=0, last=-1) =
	begin>=last ? begin+1:
	is_sorted_until_intern_type_loop (list, type, begin, last, get_value(list[begin],type), get_value(list[begin+1],type))
;
function is_sorted_until_intern_type_loop (list, type, begin=0, last=-1, this, next) =
	(next < this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	is_sorted_until_intern_type_loop (list, type, begin+1, last, next, get_value(list[begin+2],type))
;
//
function is_sorted_until_intern_f_direct (list, f, begin=0, last=-1) =
	begin>=last ? begin+1:
	f (list[begin+1], list[begin]) ? begin+1 :
	is_sorted_until_intern_f_direct (list, begin+1, last)
;
function is_sorted_until_intern_f_list (list, f, position=0, begin=0, last=-1) =
	begin>=last ? begin+1:
	f (list[begin+1][position], list[begin][position]) ? begin+1 :
	is_sorted_until_intern_f_list (list, position, begin+1, last)
;
function is_sorted_until_intern_f_function (list, f, fn, begin=0, last=-1) =
	begin>=last ? begin+1:
	is_sorted_until_intern_f_function_loop (list, f, fn, begin, last, fn(list[begin]), fn(list[begin+1]))
;
function is_sorted_until_intern_f_function_loop (list, f, fn, begin=0, last=-1, this, next) =
	f (next, this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	is_sorted_until_intern_f_function_loop (list, f, fn, begin+1, last, next, fn(list[begin+2]))
;
function is_sorted_until_intern_f_type (list, f, type, begin=0, last=-1) =
	begin>=last ? begin+1:
	is_sorted_until_intern_f_type_loop (list, f, type, begin, last, get_value(list[begin],type), get_value(list[begin+1],type))
;
function is_sorted_until_intern_f_type_loop (list, f, type, begin=0, last=-1, this, next) =
	f (next, this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	is_sorted_until_intern_f_type_loop (list, f, type, begin+1, last, next, get_value(list[begin+2],type))
;

// Testet eine Liste ob diese sortiert ist und gibt alle Position als Liste zurück,
// ab die ein vorhergehender Block nicht mehr sortiert ist.
// Position 0 ist nicht enthalten in der Rückgabeliste.
// Gibt eine leere Liste zurück, wenn die Liste sortiert ist
// Vergleicht die Daten mit dem Operator '<' oder mit Funktion 'f', wenn angegeben
function sorted_until_list (list, f=undef, type=0, begin, last, count, range) =
	list==undef ? [] :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	sorted_until_list_intern (list, f, type, Range[0], Range[1])
;
//
function sorted_until_list_intern (list, f=undef, type=0, begin=0, last=-1) =
	f==undef ?
		 type   == 0                   ? [for(i=[begin:1:last-1]) if (list[i+1]                 < list[i]                ) i+1]
		:type[0]>= 0                   ? [for(i=[begin:1:last-1]) if (list[i+1][type[0]]        < list[i][type[0]]       ) i+1]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last-1]) if (fn(list[i+1])             < fn(list[i])            ) i+1]
		:                                [for(i=[begin:1:last-1]) if (get_value(list[i+1],type) < get_value(list[i],type)) i+1]
		//	[ each [for(i=begin,this=get_value(list[i],type),next=get_value(list[i+1],type); i<=last-2; i=i+1,this=next,next=get_value(list[i+1],type))
		//		 if (next < this) i+1]
		//	, each (fn(list[last]) < fn(list[last-1])) ? [last] : [] ]
	:
		 type   == 0                   ? [for(i=[begin:1:last-1]) if (f( list[i+1]                , list[i]                )) i+1]
		:type[0]>= 0                   ? [for(i=[begin:1:last-1]) if (f( list[i+1][type[0]]       , list[i][type[0]]       )) i+1]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last-1]) if (f( fn(list[i+1])            , fn(list[i])            )) i+1]
		:                                [for(i=[begin:1:last-1]) if (f( get_value(list[i+1],type), get_value(list[i],type))) i+1]
;
