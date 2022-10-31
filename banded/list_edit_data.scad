// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen mit Zugriff auf den Inhalt
//
// Die Funktionen für typabhängigen Zugriff wurden zum Teil inline eingesetzt
// um die Ausführgeschwindigkeit zu erhöhen,
// lässt sich bei Änderungen an den internen Typdaten aber schlecht warten.
// Funktionsaufrufe sind teuer.
// Außerdem wurden für jeden bekannten Typ eine eigene Version der Funktion
// erstellt, aus dem selben Grund.

use <banded/helper.scad>

use <banded/list_edit_type.scad>


// - Daten in der Liste bearbeiten:

// Listen sortieren
function sort (list, type=0, f) =
	sort_quicksort (list, type, f)
//	sort_mergesort (list, type, f)
;

// stabiles sortieren mit Quicksort
function sort_quicksort (list, type=0, f) =
	list==undef ? list :
	f==undef ?
		 type   ==0 ? sort_quicksort_direct (list)
		:type[0]>=0 ? sort_quicksort_list   (list, type[0])
		:             sort_quicksort_type   (list, type)
	:
		 type   ==0 ? sort_quicksort_f_direct (list, f)
		:type[0]>=0 ? sort_quicksort_f_list   (list, f, type[0])
		:             sort_quicksort_f_type   (list, f, type)
;
//
function sort_quicksort_direct (list) =
	list==[] ? list :
	let ( size = len(list) )
	size<=1  ? list :
	let(
		pivot   = list[floor(size/2)],
		lesser  = [ for (e=list) if (e  < pivot) e ],
		equal   = [ for (e=list) if (e == pivot) e ],
		greater = [ for (e=list) if (e  > pivot) e ]
	)
	[ each sort_quicksort_direct(lesser), each equal, each sort_quicksort_direct(greater) ]
;
function sort_quicksort_list (list, position=0) =
	list==[] ? list :
	let ( size = len(list) )
	size<=1  ? list :
	let(
		pivot   = list[floor(size/2)][position],
		lesser  = [ for (e=list) if (e[position]  < pivot) e ],
		equal   = [ for (e=list) if (e[position] == pivot) e ],
		greater = [ for (e=list) if (e[position]  > pivot) e ]
	)
	[ each sort_quicksort_list(lesser,position), each equal, each sort_quicksort_list(greater,position) ]
;
function sort_quicksort_type (list, type) =
	list==[] ? list :
	let ( size = len(list) )
	size<=1  ? list :
	let(
		values  = value_list (list,type),
		pivot   = values[floor(size/2)],
		lesser  = [ for (i=[0:1:size-1]) if (values[i]  < pivot) list[i] ],
		equal   = [ for (i=[0:1:size-1]) if (values[i] == pivot) list[i] ],
		greater = [ for (i=[0:1:size-1]) if (values[i]  > pivot) list[i] ]
	)
	[ each sort_quicksort_type(lesser,type), each equal, each sort_quicksort_type(greater,type) ]
;
//
function sort_quicksort_f_direct (list, f) =
	list==[] ? list :
	let ( size = len(list) )
	size<=1  ? list :
	let(
		pivot   = list[floor(size/2)],
		lesser  = [ for (e=list) if ( f(e,pivot)  < 0 ) e ],
		equal   = [ for (e=list) if ( f(e,pivot) == 0 ) e ],
		greater = [ for (e=list) if ( f(e,pivot)  > 0 ) e ]
	)
	[ each sort_quicksort_f_direct(lesser,f), each equal, each sort_quicksort_f_direct(greater,f) ]
;
function sort_quicksort_f_list (list, f, position=0) =
	list==[] ? list :
	let ( size = len(list) )
	size<=1  ? list :
	let(
		pivot   = list[floor(size/2)][position],
		lesser  = [ for (e=list) if ( f(e[position],pivot)  < 0 ) e ],
		equal   = [ for (e=list) if ( f(e[position],pivot) == 0 ) e ],
		greater = [ for (e=list) if ( f(e[position],pivot)  > 0 ) e ]
	)
	[ each sort_quicksort_f_list(lesser,f,position), each equal, each sort_quicksort_f_list(greater,f,position) ]
;
function sort_quicksort_f_type (list, f, type) =
	list==[] ? list :
	let ( size = len(list) )
	size<=1  ? list :
	let(
		values  = value_list (list,type),
		pivot   = values[floor(size/2)],
		lesser  = [ for (i=[0:1:size-1]) if ( f(values[i],pivot)  < 0 ) list[i] ],
		equal   = [ for (i=[0:1:size-1]) if ( f(values[i],pivot) == 0 ) list[i] ],
		greater = [ for (i=[0:1:size-1]) if ( f(values[i],pivot)  > 0 ) list[i] ]
	)
	[ each sort_quicksort_f_type(lesser,f,type), each equal, each sort_quicksort_f_type(greater,f,type) ]
;

// stabiles sortierten mit Mergesort
function sort_mergesort (list, type=0, f) =
	list==undef ? list :
	let ( size = len(list) )
	(size<=1) ? list :
	(size==2) ?
		f==undef ?
			type==0 ?   list[0]            <list[1]                  ? list : [list[1],list[0]]
			:           value(list[0],type)<value(list[1],type)      ? list : [list[1],list[0]]
		:
			type==0 ? f(list[0]            ,list[1]            ) < 0 ? list : [list[1],list[0]]
			:         f(value(list[0],type),value(list[1],type)) < 0 ? list : [list[1],list[0]]
	:
	let(
		middle = floor((size-1)/2)
	)
	merge(
		 sort_mergesort([for (i=[0       :1:middle]) list[i]], type, f)
		,sort_mergesort([for (i=[middle+1:1:size-1]) list[i]], type, f)
		,type, f
	)
;

// 2 sortierte Listen miteinander verschmelzen
function merge        (list1, list2, type=0, f) =
	list1==undef ? list2 :
	list2==undef ? list1 :
//	merge_intern_1 (list1, list2, type, f, len(list1), len(list2))
	merge_intern_2 (list1, list2, type, f)
;
function merge_intern_1 (list1, list2, type=0, f, size1=0, size2=0, i1=0, i2=0) =
	(i1>=size1 || i2>=size2) ?
		 (i1>=size1) ? [ for (e=[i2:size2-1]) list2[e] ]
		:(i2>=size2) ? [ for (e=[i1:size1-1]) list1[e] ]
		:[]
	:
	(	f==undef ?  value(list1[i1],type) <= value(list2[i2],type)
		:         f(value(list1[i1],type),   value(list2[i2],type)) <= 0
	)
	?	[ each [list1[i1]], each merge_intern_1 (list1, list2, type, f, size1, size2, i1+1, i2)   ]
	:	[ each [list2[i2]], each merge_intern_1 (list1, list2, type, f, size1, size2, i1,   i2+1) ]
;
function merge_intern_2 (list1, list2, type=0, f) =
	let(
		enda=len(list1),
		endb=len(list2),
		end=enda+endb - 1,
		a=list1,
		b=list2
	)
	!(enda>0) ? list2 :
	!(endb>0) ? list1 :
	//
	f==undef ?
	[for (
		i=0,j=0,
			A=type==0 ? a[i] : value(a[i],type),
			B=type==0 ? b[j] : value(b[j],type),
			q=j>=endb?true:i>=enda?false:A<B, v=q?a[i]:b[j]
		;i+j<=end;
		i=q?i+1:i, j=q?j:j+1,
			A=type==0 ? a[i] : value(a[i],type),
			B=type==0 ? b[j] : value(b[j],type),
			q=j>=endb?true:i>=enda?false:A<B, v=q?a[i]:b[j]
	) v ]
	:
	[for (
		i=0,j=0,
			A=type==0 ? a[i] : value(a[i],type),
			B=type==0 ? b[j] : value(b[j],type),
			q=j>=endb?true:i>=enda?false:f(A,B)<0, v=q?a[i]:b[j]
		;i+j<=end;
		i=q?i+1:i, j=q?j:j+1,
			A=type==0 ? a[i] : value(a[i],type),
			B=type==0 ? b[j] : value(b[j],type),
			q=j>=endb?true:i>=enda?false:f(A,B)<0, v=q?a[i]:b[j]
	) v ]
;

// Entfernt alle Duplikate aus der Liste
function remove_duplicate (list, type=0) =
	list==undef ? list :
	let ( size=len(list) )
	size==0     ? list :
	 type   == 0 ? remove_duplicate_intern_direct   (list,          size=size)
	:type[0]>= 0 ? remove_duplicate_intern_list     (list, type[0], size=size)
	:type[0]==-1 ? remove_duplicate_intern_function (list, type[1], size=size)
	:              remove_duplicate_intern_type     (list, type   , size=size)
;
function remove_duplicate_intern_direct (list, size=0, i=0, new=[], last=[]) =
	i>=size ? [each new, each last] :
	// test value is in 'new'
	((last!=[] && last[0]==list[i]) || ([for (e=new) if (e==list[i]) 0] != []) ) ?
		remove_duplicate_intern_direct (list, size, i+1, new, last)
	:	remove_duplicate_intern_direct (list, size, i+1, [each new, each last], [list[i]])
;
function remove_duplicate_intern_list (list, position=0, size=0, i=0, new=[], last=[]) =
	i>=size ? [each new, each last] :
	let( v = list[i][position] )
	// test value is in 'new'
	((last!=[] && last[0][position]==v) || ([for (e=new) if (e[position]==v) 0] != []) ) ?
		remove_duplicate_intern_list (list, position, size, i+1, new, last)
	:	remove_duplicate_intern_list (list, position, size, i+1, [each new, each last], [list[i]])
;
function remove_duplicate_intern_function (list, fn, size=0, i=0, new=[], values=[], last=[]) =
	i>=size ? new :
	let( v = fn(list[i]) )
	// test value is in 'new'
	((last!=[] && last[0]==v) || ([for (e=values) if (e==v) 0] != []) ) ?
		remove_duplicate_intern_function (list, fn, size, i+1, new, values, last)
	:	remove_duplicate_intern_function (list, fn, size, i+1, [each new, list[i]], [each values, each last], [v])
;
function remove_duplicate_intern_type (list, type, size=0, i=0, new=[], values=[], last=[]) =
	i>=size ? new :
	let( v = value(list[i],type) )
	// test value is in 'new'
	((last!=[] && last[0]==v) || ([for (e=values) if (e==v) 0] != []) ) ?
		remove_duplicate_intern_type (list, type, size, i+1, new, values, last)
	:	remove_duplicate_intern_type (list, type, size, i+1, [each new, list[i]], [each values, each last], [v])
;


// Entfernt alle Vorkommen eines Wertes
function remove_value (list, value, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0                   ? [ for (e=list) if (e            !=value) e ]
	:type[0]>= 0                   ? [ for (e=list) if (e[type[0]]   !=value) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)        !=value) e ]
	:                                [ for (e=list) if (value(e,type)!=value) e ]
;

// Entfernt alle Vorkommen von Werten aus einer Liste
function remove_all_values (list, value_list, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                         if ( [for(value=value_list) if (e ==value) 0] == [] ) e ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])    if ( [for(value=value_list) if (ev==value) 0] == [] ) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))         if ( [for(value=value_list) if (ev==value) 0] == [] ) e ]
	:                                [ for (e=list) let(ev = value(e,type)) if ( [for(value=value_list) if (ev==value) 0] == [] ) e ]
;

// Ersetzt alle Vorkommen eines Wertes durch einen anderen Wert
function replace_value (list, value, new, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0 ?                   [ for (e=list) if (e            !=value) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) if (e[type[0]]   !=value) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)        !=value) e else new ]
	:                                [ for (e=list) if (value(e,type)!=value) e else new ]
;

// Ersetzt alle Vorkommen von Werten aus einer Liste durch einen anderen Wert
function replace_all_values (list, value_list, new, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                         if ( [for(value=value_list) if (e ==value) 0] == [] ) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])    if ( [for(value=value_list) if (ev==value) 0] == [] ) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))         if ( [for(value=value_list) if (ev==value) 0] == [] ) e else new ]
	:                                [ for (e=list) let(ev = value(e,type)) if ( [for(value=value_list) if (ev==value) 0] == [] ) e else new ]
;

// Behält alle Vorkommen eines Wertes, entfernt alle anderen Werte
function keep_value (list, value, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0                   ? [ for (e=list) if (e            ==value) e ]
	:type[0]>= 0                   ? [ for (e=list) if (e[type[0]]   ==value) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)        ==value) e ]
	:                                [ for (e=list) if (value(e,type)==value) e ]
;

// Behält alle Vorkommen von Werten aus einer Liste, entfernt alle anderen Werte.
function keep_all_values (list, value_list, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                         if ( [for(value=value_list) if (e ==value) 0] != [] ) e ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])    if ( [for(value=value_list) if (ev==value) 0] != [] ) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))         if ( [for(value=value_list) if (ev==value) 0] != [] ) e ]
	:                                [ for (e=list) let(ev = value(e,type)) if ( [for(value=value_list) if (ev==value) 0] != [] ) e ]
;

// Entfernt alle aufeinanderfolgenden Duplikate
function unique (list, type=0, f=undef) =
	list==undef || len(list)<=1 ? list :
	let( size = len(list) )
	f==undef ?
		 type   == 0 ?
			[ each
				[ for (i=0  ,v=list[i]            ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i]            ,is_unique=!(v==last),last=is_unique?v:last ) if (is_unique) v ]
			, each ( list[size-2] == list[size-1] ) ? [] : [list[size-1]]
			]
		:type[0]>= 0 ?
			[ each
				[ for (i=0  ,v=list[i][type[0]]   ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i][type[0]]   ,is_unique=!(v==last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each ( list[size-2][type[0]] == list[size-1][type[0]] ) ? [] : [list[size-1]]
			]
		:type[0]==-1 ? let( fn=type[1] )
			[ each
				[ for (i=0  ,v=fn(list[i])        ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=fn(list[i])        ,is_unique=!(v==last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each ( fn(list[size-2]) == fn(list[size-1]) ) ? [] : [list[size-1]]
			]
		:
			[ each
				[ for (i=0  ,v=value(list[i],type),is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=value(list[i],type),is_unique=!(v==last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each ( value(list[size-2],type) == value(list[size-1],type) ) ? [] : [list[size-1]]
			]
	:
		 type   == 0 ?
			[ each
				[ for (i=0  ,v=list[i]            ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i]            ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) v ]
			, each f( list[size-2], list[size-1] ) ? [] : [list[size-1]]
			]
		:type[0]>= 0 ?
			[ each
				[ for (i=0  ,v=list[i][type[0]]   ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i][type[0]]   ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f( list[size-2][type[0]], list[size-1][type[0]] ) ? [] : [list[size-1]]
			]
		:type[0]==-1 ? let( fn=type[1] )
			[ each
				[ for (i=0  ,v=fn(list[i])        ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=fn(list[i])        ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f( fn(list[size-2]), fn(list[size-1]) ) ? [] : [list[size-1]]
			]
		:
			[ each
				[ for (i=0  ,v=value(list[i],type),is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=value(list[i],type),is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f( value(list[size-2],type), value(list[size-1],type) ) ? [] : [list[size-1]]
			]
;

// Entfernt alle aufeinanderfolgenden Duplikate komplett,
// behält nur die einzelstehenden Werte
function keep_unique (list, type=0, f) =
	list==undef ? list :
	let( size=len(list) )
	size==1     ? list :
	keep_unique_intern (list, type, f, size, value(list[0],type))
;
function keep_unique_intern (list, type=0, f, size=0, last_v, i=1, last_pos=0, result=[]) =
	i>size  ? result :
	i==size ? (last_pos==size-1) ? [ each result, list[last_pos] ] : result
	:
	let(
		v =
			 type==0     ? list[i]
			:type[0]>= 0 ? list[i][type[0]]
			:              value(list[i],type)
	)
	(f==undef ? v==last_v : f(v,last_v) ) ?
			keep_unique_intern (list, type, f, size, last_v, i+1, last_pos, result)
	:	last_pos==i-1
		?	keep_unique_intern (list, type, f, size, v     , i+1, i, [ each result, list[last_pos] ])
		:	keep_unique_intern (list, type, f, size, v     , i+1, i, result)
;

