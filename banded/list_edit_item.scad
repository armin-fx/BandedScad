// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen ohne Zugriff auf den Inhalt

use <banded/helper.scad>


// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) for (b=a) b];

// kehrt die Reihenfolge einer Liste um
function reverse (list) = [for (a=[len(list)-1:-1:0]) list[a]];

// entfernt Elemente aus einer Liste
function remove (list, begin, count=1) =
	list==undef ? list :
	let (
		 size=len(list)
		,real_begin=get_position(list,begin)
		,real_count=get_position(list,count)
	)
	concat(
		 (real_begin==0)                ? []
		 :[for (i=[0:min(real_begin-1,size-1)])               list[i] ]
		,((real_begin+real_count)>=size) ? []
		 :[for (i=[min(real_begin+real_count,size-1):size-1]) list[i] ]
	)
;

// fügt alle Elemente einer Liste in die Liste ein
function insert (list, list_insert, position=-1, begin_insert=0, count_insert=-1) =
	let (
		 size        = len(list)
		,size_insert = len(list_insert)
		//
		,real_position = get_position_insert(list,position)
		//
		,real_begin_insert = get_position       (list_insert,begin_insert)
		,real_count_insert = get_position_insert(list_insert,count_insert)
		,real_last_insert  = min(real_begin_insert+real_count_insert-1,size_insert-1)
	)
	concat(
		 (real_position<=0)     ? []
		 :[for (i=[0:min(real_position-1,size-1)])           list[i] ]
		,(real_begin_insert>real_last_insert) ? []
		 :[for (i=[real_begin_insert:real_last_insert])      list_insert[i] ]
		,(real_position>=size)  ? []
		 :[for (i=[max(0,min(real_position,size-1)):size-1]) list[i] ]
	)
;

// ersetzt Elemente in einer Liste durch alle Elemente einer weiteren Liste
function replace (list, list_insert, begin=-1, count=0, begin_insert=0, count_insert=-1) =
	let (
		 size        = len(list)
		,size_insert = len(list_insert)
		//
		,real_begin=get_position_insert(list,begin)
		,real_count=get_position       (list,count)
		//
		,real_begin_insert = get_position       (list_insert,begin_insert)
		,real_count_insert = get_position_insert(list_insert,count_insert)
		,real_last_insert  = min(real_begin_insert+real_count_insert-1,size_insert-1)
	)
	concat(
		 (real_begin==0)                ? []
		 :[for (i=[0:min(real_begin-1,size-1)])               list[i] ]
		,(real_begin_insert>real_last_insert) ? []
		 :[for (i=[real_begin_insert:real_last_insert])       list_insert[i] ]
		,((real_begin+real_count)>=size) ? []
		 :[for (i=[min(real_begin+real_count,size-1):size-1]) list[i] ]
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
function extract (list, begin, last, count, range) =
	let(
		Range = parameter_range_safe (list, begin, last, count, range),
		Begin = Range[0],
		Last  = Range[1]
	)
	(Begin==0) && (Last==len(list)-1) ? list :
	[for (i=[Begin:1:Last]) list[i]]
;

// Erzeugt eine Liste mit 'count' Elementen gefüllt mit 'value'
function fill (count, value) =
	(!is_num(count) || count<1) ? [] :
	[ for (i=[0:count-1]) value ]
;

// gibt eine Liste zurück mit den Werten von der Liste 'base' in den Positionen 'positions'
//   base <-- positions
function refer_list (base, positions) =
	[ for (position=positions) base[position] ]
;
// gibt eine Liste zurück mit den Werten von der Liste 'base'
// von der Liste mit den Positionen 'link' von 'base'
// in den Positionen 'positions' in 'link'
//   base <-- link <-- positions
function refer_link_list (base, link, positions) =
	[ for (position=positions) base[link[position]] ]
;

