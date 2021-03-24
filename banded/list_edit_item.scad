// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen ohne Zugriff auf den Inhalt

use <banded/helper_native.scad>


// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) for (b=a) b];

// kehrt die Reihenfolge einer Liste um
function reverse_list (list) = [for (a=[len(list)-1:-1:0]) list[a]];

// entfernt Elemente aus einer Liste
function erase_list (list, begin, count=1) =
	list==undef ? list :
	let (
		size=len(list),
		pos_begin=get_position(list,begin),
		pos_count=get_position(list,count)
	)
	concat(
		 (pos_begin==0)                ? []
		 :[for (i=[0:min(pos_begin-1,size-1)])              list[i] ]
		,((pos_begin+pos_count)>=size) ? []
		 :[for (i=[min(pos_begin+pos_count,size-1):size-1]) list[i] ]
	)
;

// fügt alle Elemente einer Liste in die Liste ein
function insert_list (list, list_insert, position=-1, begin=0, count=-1) =
	let (
		 size        = len(list)
		,size_insert = len(list_insert)
		,real_position = get_position_insert(list,position)
		,real_begin    = get_position       (list_insert,begin)
		,real_count    = get_position_insert(list_insert,count)
		,real_last     = min(real_begin+real_count-1,size_insert-1)
	)
	concat(
		 (real_position<=0)     ? []
		 :[for (i=[0:min(real_position-1,size-1)])           list[i] ]
		,(real_begin>real_last) ? []
		 :[for (i=[real_begin:real_last])                    list_insert[i] ]
		,(real_position>=size)  ? []
		 :[for (i=[max(0,min(real_position,size-1)):size-1]) list[i] ]
	)
;

// extrahiert eine Sequenz aus der Liste
// Angaben:
//     list  = Liste mit der enthaltenen Sequenz
//
// 2 benötigte Angaben von:
//     begin = erstes Element aus der Liste
//     last  = letztes Element
//     count = Anzahl der Elemente
// oder
//     range = [begin, last]
// Kodierung wie in python
function extract_list (list, begin, last, count, range) =
	let(
		Range = parameter_range_safe (list, begin, last, count, range),
		Begin = Range[0],
		Last  = Range[1]
	)
	(Begin==0) && (Last==len(list)-1) ? list :
	[for (i=[Begin:1:Last]) list[i]]
;

// Erzeugt eine Liste mit 'count' Elementen gefüllt mit 'value'
function fill_list (count, value) =
	(!is_num(count) || count<1) ? [] :
	[ for (i=[0:count-1]) value ]
;
