// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Testen von Listen auf den Inhalt
// Der Inhalt wird mit einer übergebenen Funktion bearbeitet

use <banded/helper.scad>

use <banded/list_edit_type.scad>
use <banded/list_edit_predicate.scad>


// Führt Funktion 'f' auf die Elemente in der Liste aus und
// gibt 'true' zurück, wenn alle Aufrufe von f() 'true' zurückgeben
function all_of (list, f, type=0, begin, last, count, range) =
	list==undef ? true :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	all_of_intern      (list, f, type, Range[0], Range[1])
;
function all_of_intern (list, f, type=0, begin=0, last=-1) =
	begin>last ? true :
	 type   == 0                   ? [for(i=[begin:1:last]) if (f( list[i]             )!=true) 0] == []
	:type[0]>= 0                   ? [for(i=[begin:1:last]) if (f( list[i][type[0]]    )!=true) 0] == []
	:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last]) if (f( fn(list[i])         )!=true) 0] == []
	:                                [for(i=[begin:1:last]) if (f( value(list[i],type) )!=true) 0] == []
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
	 type   == 0                   ? [for(i=[begin:1:last]) if (f( list[i]             )==true) 0] == []
	:type[0]>= 0                   ? [for(i=[begin:1:last]) if (f( list[i][type[0]]    )==true) 0] == []
	:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last]) if (f( fn(list[i])         )==true) 0] == []
	:                                [for(i=[begin:1:last]) if (f( value(list[i],type) )==true) 0] == []
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
	 type   == 0                   ? [for(i=[begin:1:last]) if (f( list[i]             )==true) 0] != []
	:type[0]>= 0                   ? [for(i=[begin:1:last]) if (f( list[i][type[0]]    )==true) 0] != []
	:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last]) if (f( fn(list[i])         )==true) 0] != []
	:                                [for(i=[begin:1:last]) if (f( value(list[i],type) )==true) 0] != []
;

// Testet 2 Listen nach Gleichheit und gibt 'true' bei Erfolg zurück
// Vergleicht die Daten direkt oder mit Funktion 'f', wenn angegeben
function equal (list1, list2, f, type=0, begin1=0, begin2=0, count=undef) =
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
		 type   == 0                   ? [for(i=[0:1:Count-1]) if (list1[Begin1+i]             != list2[Begin2+i]            ) 0] == []
		:type[0]>= 0                   ? [for(i=[0:1:Count-1]) if (list1[Begin1+i][type[0]]    != list2[Begin2+i][type[0]]   ) 0] == []
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[0:1:Count-1]) if (fn(list1[Begin1+i])         != fn(list2[Begin2+i])        ) 0] == []
		:                                [for(i=[0:1:Count-1]) if (value(list1[Begin1+i],type) != value(list2[Begin1+i],type)) 0] == []
	:
		 type   == 0                   ? [for(i=[0:1:Count-1]) if (f( list1[Begin1+i]            , list2[Begin2+i]            ) !=true) 0] == []
		:type[0]>= 0                   ? [for(i=[0:1:Count-1]) if (f( list1[Begin1+i][type[0]]   , list2[Begin2+i][type[0]]   ) !=true) 0] == []
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[0:1:Count-1]) if (f( fn(list1[Begin1+i])        , fn(list2[Begin2+i])        ) !=true) 0] == []
		:                                [for(i=[0:1:Count-1]) if (f( value(list1[Begin1+i],type), value(list2[Begin1+i],type)) !=true) 0] == []
;

// Testet, ob eine sortierte Liste 1 alle Elemente aus der sortierten Liste 2 enthält
function includes (list1, list2, f=undef, type=0, begin1, last1, count1, range1, begin2, last2, count2, range2) =
	let (
		Range1 = parameter_range_safe (list1, begin1, last1, count1, range1),
		Range2 = parameter_range_safe (list2, begin2, last2, count2, range2)
	)
	f==undef ?
		 type   == 0 ? includes_intern_direct    (list1, list2,             Range1[0], Range1[1], Range2[0], Range2[1])
		:type[0]>= 0 ? includes_intern_list      (list1, list2,    type[0], Range1[0], Range1[1], Range2[0], Range2[1])
		:type[0]==-1 ? includes_intern_function  (list1, list2,    type[1], Range1[0], Range1[1], Range2[0], Range2[1])
		:              includes_intern_type      (list1, list2,    type   , Range1[0], Range1[1], Range2[0], Range2[1])
	:
		 type   == 0 ? includes_intern_f_direct  (list1, list2, f,          Range1[0], Range1[1], Range2[0], Range2[1])
		:type[0]>= 0 ? includes_intern_f_list    (list1, list2, f, type[0], Range1[0], Range1[1], Range2[0], Range2[1])
		:type[0]==-1 ? includes_intern_f_function(list1, list2, f, type[1], Range1[0], Range1[1], Range2[0], Range2[1])
		:              includes_intern_f_type    (list1, list2, f, type   , Range1[0], Range1[1], Range2[0], Range2[1])
;
function includes_intern_direct (list1, list2, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = list1[first1],
		value2 = list2[first2]
	)
	(value2<value1) ? false :
	includes_intern_direct (list1, list2,
		first1+1, last1,
		!(value1<value2) ? first2+1 : first2, last2
	)
;
function includes_intern_f_direct (list1, list2, f, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = list1[first1],
		value2 = list2[first2]
	)
	f(value2,value1) ? false :
	includes_intern_f_direct (list1, list2, f,
		first1+1, last1,
		!f(value1,value2) ? first2+1 : first2, last2
	)
;
function includes_intern_list (list1, list2, position=0, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = list1[first1][position],
		value2 = list2[first2][position]
	)
	(value2<value1) ? false :
	includes_intern_list (list1, list2, position,
		first1+1, last1,
		!(value1<value2) ? first2+1 : first2, last2
	)
;
function includes_intern_f_list (list1, list2, f, position=0, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = list1[first1][position],
		value2 = list2[first2][position]
	)
	f(value2,value1) ? false :
	includes_intern_f_list (list1, list2, f, position,
		first1+1, last1,
		!f(value1,value2) ? first2+1 : first2, last2
	)
;
function includes_intern_function (list1, list2, fn, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = fn(list1[first1]),
		value2 = fn(list2[first2])
	)
	(value2<value1) ? false :
	includes_intern_function (list1, list2, type,
		first1+1, last1,
		!(value1<value2) ? first2+1 : first2, last2
	)
;
function includes_intern_f_function (list1, list2, f, fn, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = fn(list1[first1]),
		value2 = fn(list2[first2])
	)
	f(value2,value1) ? false :
	includes_intern_f_function (list1, list2, f, type,
		first1+1, last1,
		!f(value1,value2) ? first2+1 : first2, last2
	)
;
function includes_intern_type (list1, list2, type=0, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = value(list1[first1],type),
		value2 = value(list2[first2],type)
	)
	(value2<value1) ? false :
	includes_intern_type (list1, list2, type,
		first1+1, last1,
		!(value1<value2) ? first2+1 : first2, last2
	)
;
function includes_intern_f_type (list1, list2, f, type=0, first1=0, last1=-1, first2=0, last2=-1) =
	first2>last2 ? true :
	first1>last1 ? false :
	let(
		value1 = value(list1[first1],type),
		value2 = value(list2[first2],type)
	)
	f(value2,value1) ? false :
	includes_intern_f_type (list1, list2, f, type,
		first1+1, last1,
		!f(value1,value2) ? first2+1 : first2, last2
	)
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
		 type   == 0                   ? [for(i=[begin:1:last-1]) if (list[i+1]             < list[i]            ) 0] == []
		:type[0]>= 0                   ? [for(i=[begin:1:last-1]) if (list[i+1][type[0]]    < list[i][type[0]]   ) 0] == []
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last-1]) if (fn(list[i+1])         < fn(list[i])        ) 0] == []
		:                                [for(i=[begin:1:last-1]) if (value(list[i+1],type) < value(list[i],type)) 0] == []
	:
		 type   == 0                   ? [for(i=[begin:1:last-1]) if (f( list[i+1]            , list[i]            )) 0] == []
		:type[0]>= 0                   ? [for(i=[begin:1:last-1]) if (f( list[i+1][type[0]]   , list[i][type[0]]   )) 0] == []
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last-1]) if (f( fn(list[i+1])        , fn(list[i])        )) 0] == []
		:                                [for(i=[begin:1:last-1]) if (f( value(list[i+1],type), value(list[i],type))) 0] == []
;

// Testet, ob eine Liste in 2 Bereiche aufgeteilt ist.
// 1. Teil: f() == true
// 2. Teil: f() == false
function is_partitioned (list, f, type=0, begin, last, count, range) =
	let (
		Range = parameter_range_safe (list, begin, last, count, range),
		g = function(v) !f(v),
		true_pos  = find_first_once_if_intern (list, g, type, Range[0], Range[1]),
		false_pos = find_first_once_if_intern (list, f, type, true_pos, Range[1])
	)
	false_pos==Range[1]+1
;
