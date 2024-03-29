// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen ohne Zugriff auf den Inhalt

use <banded/helper.scad>


// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) each a];

// kehrt die Reihenfolge einer Liste um
function reverse_full (list) = [for (a=[len(list)-1:-1:0]) list[a]];
function reverse      (list, begin, last, count, range) =
	(begin==undef && last==undef && count==undef && range==undef) ?
		//reverse_full (list)
		[for (a=[len(list)-1:-1:0]) list[a]]
	:
	let(
		Range = parameter_range_safe (list, begin, last, count, range),
		Begin = Range[0],
		Last  = Range[1],
		size  = len(list)
	)
	[	each ( Begin  <=0)     ? [] : [for (i=[0     :1:Begin-1]) list[i] ]
	,	each ( Last   < Begin) ? [] : [for (i=[Last :-1:Begin  ]) list[i] ]
	,	each ((Last+1)>=size)  ? [] : [for (i=[Last+1:1:size-1 ]) list[i] ]
	]
;

// kehrt die Reihenfolge aller Listen in einer Liste um
function reverse_all (list) =
	[for (l=list)
	[for (a=[len(l)-1:-1:0]) l[a]]
	]
;

function rotate_list (list, middle, begin=0, last=-1) =
	let (
		Range  = parameter_range_safe (list, begin, last),
		Begin  = Range[0],
		Last   = Range[1],
		Middle = constrain (middle, Begin, Last),
		Size   = len (list)
	)
	[	for (i=[0     :1:Begin-1 ]) list[i]
	,	for (i=[Middle:1:Last    ]) list[i]
	,	for (i=[Begin :1:Middle-1]) list[i]
	,	for (i=[Last+1:1:Size-1  ]) list[i]
	]
;

function rotate_copy (list, middle, begin=0, last=-1) =
	let (
		Range  = parameter_range_safe (list, begin, last),
		Begin  = Range[0],
		Last   = Range[1],
		Middle = constrain (middle, Begin, Last)
	)
	[	for (i=[Middle:1:Last    ]) list[i]
	,	for (i=[Begin :1:Middle-1]) list[i]
	]
;

// entfernt Elemente aus einer Liste
function remove (list, begin, count=1) =
	list==undef ? list :
	let (
		 size=len(list)
		,real_begin=get_position(list,begin)
		,real_count=get_position(list,count)
	)
	[	each
			(real_begin==0)                ? []
			:[for (i=[0:1:min(real_begin-1,size-1)])               list[i] ]
	,	each
			((real_begin+real_count)>=size) ? []
			:[for (i=[min(real_begin+real_count,size-1):1:size-1]) list[i] ]
	]
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
	[	each
			(real_position<=0)     ? []
			:[for (i=[0:1:min(real_position-1,size-1)])           list[i] ]
	,	each
			(real_begin_insert>real_last_insert) ? []
			:[for (i=[real_begin_insert:1:real_last_insert])      list_insert[i] ]
	,	each
			(real_position>=size)  ? []
			:[for (i=[max(0,min(real_position,size-1)):1:size-1]) list[i] ]
	]
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
	[	each
			(real_begin==0)                 ? []
			:[for (i=[0:1:min(real_begin-1,size-1)])               list[i] ]
	,	each
			(real_begin_insert>real_last_insert) ? []
			:[for (i=[real_begin_insert:1:real_last_insert])       list_insert[i] ]
	,	each
			((real_begin+real_count)>=size) ? []
			:[for (i=[min(real_begin+real_count,size-1):1:size-1]) list[i] ]
	]
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
	[ for (i=[Begin:1:Last]) list[i] ]
;

// Erzeugt eine Liste mit 'count' Elementen gefüllt mit 'value'
function fill (count, value) =
	(!is_num(count) || count<1) ? [] :
	[ for (i=[0:1:count-1]) value ]
;

// gibt eine Liste zurück mit den Werten von der Liste 'base' in den Positionen 'index'
// b.z.w. bestückt die Positionen in der Liste 'index' mit den entsprechenden Werten von 'base'
//   base <-- index
function select (base, index) =
	[ for (i=index) base[i] ]
;
// bestückt alle Listen in 'indices' mit den entsprechenden Werten von 'base'
//   [ base <-- index[0], base <-- index[1], base <-- index[2] ... ]
function select_all (base, indices) =
	[ for (index=indices)
		[ for (i=index) base[i] ]
	]
;
// gibt eine Liste zurück mit den Werten von der Liste 'base'
// von der Liste mit den Positionen 'link' von 'base'
// in den Positionen 'index' in 'link'
//   base <-- link <-- index
function select_link (base, link, index) =
	[ for (i=index) base[link[i]] ]
;

// löscht alle Positionen 'index' von einer Liste 'base'
use <banded/list_edit_data.scad>
use <banded/list_edit_test.scad>
function unselect (base, index) =
	let (
		size = len(base),
		p = (is_sorted (index)) ? index : sort (index),
		u = [for (
			i=0  , is_in=p[0]!=0, l=  (is_in?0:1); i<=size-1;
			i=i+ ( (!is_in)&&(p[l]==i) ? 0:1 )
			,      is_in=p[l]!=i, l=l+(is_in?0:1)) if (is_in) i ]
	)
	[ for (position=u) base[position] ]
;

// gibt eine Liste mit den Positionen auf den Daten zurück
// in aufsteigender Reihenfolge
// gibt '[ Daten, [Index] ]' zurück
function index (list) = [ list, [[for (i=[0:1:len(list)-1]) i ]] ];

// hängt alle Daten '[ Daten1, Daten2 ]' an einer Liste an und speichert Listen mit den Positionen darauf
// - 'list' - enthält Listen mit Daten
// gibt '[ Daten, [Index1, Index2, ... ] ]' zurück
function index_all (list) =
	index_all_intern (list, len(list))
;
function index_all_intern (lists, size=0, i=0, l=0, data=[], indices=[]) =
	i>=size ? [data, indices] :
	let ( size_i = len(lists[i]) )
	index_all_intern (lists, size, i+1, l+size_i
		, [ each data, each lists[i] ]
		, [ each indices, [for (i=[l:1:l+size_i-1]) i ] ]
	)
;

// entfernt alle Datenelemente, die nicht indiziert sind und schreibt alle Indizes neu
// gibt '[ Daten, [Index1, Index2, ... ] ]' zurück
function remove_unselected (list, indices) =
	let (
		pos = unique( sort( concat_list (indices) ) ),
		pos_table = [
			for (i=[-1:len(pos)-2])
			for (e=(
				(i==-1) ?
					[ for (j=[0     :1:pos[0]    ]) 0   ]
				:	[ for (j=[pos[i]:1:pos[i+1]-1]) i+1 ]
			) ) e
			],
		new_indices = [ for (x=indices) [ for (e=x) pos_table[e] ] ],
		new_list    = [ for (i=pos) list[i] ]
	)
	[new_list, new_indices]
;

// fasst alle mehrfach vorkommenden Datenelemente zusammen, schreibt alle Indizes neu
// gibt '[ Daten, [Index1, Index2, ... ] ]' zurück
function compress_selected (list, indices, comparable=true) =
	let (
		size     = len(list),
		data     = comparable!=false
			? [for (i=[0:1:size-1]) [i, list[i]]               ]
			: [for (i=[0:1:size-1]) [i, list[i], str(list[i])] ],
		data1    = sort       (data , type=[1 + (comparable!=false ? 0:1)]),
		//
		list1    = unique     (data1, type=[1]),
	//	list1    = remove_duplicate (data1, type=[1]),
		list_new = value_list (list1, type=[1]),
		//
		index1      =
			[ for (i=0  ,new_i=0;  i<size;
				   i=i+1,new_i=new_i + (data1[i-1][1]==data1[i][1] ? 0:1) )
				[ data1[i][0], new_i]
			],
		index2      = sort       (index1, type=[0]),
		index_link  = value_list (index2, type=[1]),
		indices_new = [for (index=indices) [for (i=index) index_link[i] ] ]
	)
	[list_new, indices_new]
;

