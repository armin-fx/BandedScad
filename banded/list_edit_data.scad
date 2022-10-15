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
function sort (list, type=0) = sort_quicksort (list, type);

// stabiles sortieren mit Quicksort
function sort_quicksort (list, type=0) =
	list==undef ? list :
	 type   ==0 ? sort_quicksort_direct (list)
	:type[0]>=0 ? sort_quicksort_list   (list, type[0])
	:             sort_quicksort_type   (list, type)
;
function sort_quicksort_direct (list) =
	!(len(list)>1) ? list :
	let(
		pivot   = list[floor(len(list)/2)],
		lesser  = [ for (e=list) if (e  < pivot) e ],
		equal   = [ for (e=list) if (e == pivot) e ],
		greater = [ for (e=list) if (e  > pivot) e ]
	) concat(
		sort_quicksort_direct(lesser), equal, sort_quicksort_direct(greater)
	)
;
function sort_quicksort_list (list, position=0) =
	!(len(list)>1) ? list :
	let(
		pivot   = list[floor(len(list)/2)][position],
		lesser  = [ for (e=list) if (e[position]  < pivot) e ],
		equal   = [ for (e=list) if (e[position] == pivot) e ],
		greater = [ for (e=list) if (e[position]  > pivot) e ]
	) concat(
		sort_quicksort_list(lesser,position), equal, sort_quicksort_list(greater,position)
	)
;
function sort_quicksort_type (list, type) =
	!(len(list)>1) ? list :
	let(
		pivot   = get_value( list[floor(len(list)/2)] ,type),
		lesser  = [ for (e=list) if (get_value(e,type)  < pivot) e ],
		equal   = [ for (e=list) if (get_value(e,type) == pivot) e ],
		greater = [ for (e=list) if (get_value(e,type)  > pivot) e ]
	) concat(
		sort_quicksort_type(lesser,type), equal, sort_quicksort_type(greater,type)
	)
;

// stabiles sortierten mit Mergesort
function sort_mergesort (list, type=0) =
	list==undef || !(len(list)>1) ? list :
	(len(list)==2) ?
		get_value(list[0],type)<get_value(list[1],type) ?
			[list[0],list[1]] : [list[1],list[0]] :
	let(
		end    = len(list)-1,
		middle = floor((len(list)-1)/2)
	)
	merge(
		 sort_mergesort([for (i=[0:middle])     list[i]], type)
		,sort_mergesort([for (i=[middle+1:end]) list[i]], type)
		,type
	)
;

// 2 sortierte Listen miteinander verschmelzen
// sehr langsame Implementierung
function merge        (list1, list2, type=0) =
	list1==undef ? list2 :
	list2==undef ? list1 :
	merge_intern_2 (list1, list2, type)
;
function merge_intern (list1, list2, type=0, i1=0, i2=0) =
	(i1>=len(list1) || i2>=len(list2)) ?
		 (i1>=len(list1)) ? [ for (e=[i2:len(list2)-1]) list2[e] ]
		:(i2>=len(list2)) ? [ for (e=[i1:len(list1)-1]) list1[e] ]
		:[]
	:(get_value(list1[i1],type) <= get_value(list2[i2],type)) ?
		 [ each [list1[i1]], each merge_intern (list1, list2, type, i1+1, i2)   ]
		:[ each [list2[i2]], each merge_intern (list1, list2, type, i1,   i2+1) ]
;
function merge_intern_2 (list1, list2, type=0) =
	let(
		enda=len(list1),
		endb=len(list2),
		end=enda+endb - 1,
		a=list1,
		b=list2
	)
	!(enda>0) ? list2 :
	!(endb>0) ? list1 :
	[for (
		i=0,j=0,
			A=get_value(a[i],type),
			B=get_value(b[j],type),
			q=j>=endb?true:i>=enda?false:A<B, v=q?a[i]:b[j]
		;i+j<=end;
		i=q?i+1:i, j=q?j:j+1,
			A=get_value(a[i],type),
			B=get_value(b[j],type),
			q=j>=endb?true:i>=enda?false:A<B, v=q?a[i]:b[j]
	) v ]
;

// Entfernt alle Duplikate aus der Liste
function remove_duplicate (list, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0 ? remove_duplicate_intern_direct   (list)
	:type[0]>= 0 ? remove_duplicate_intern_list     (list, type[0])
	:type[0]==-1 ? remove_duplicate_intern_function (list, type[1])
	:              remove_duplicate_intern_type     (list, type)
;
function remove_duplicate_intern_direct (list, i=0, new=[], last=[]) =
	i==len(list) ? concat(new,last):
	// test value is in 'new'
	((last!=[] && last[0]==list[i]) || (len([for (e=new) if (e==list[i]) 0]) != 0) ) ?
		remove_duplicate_intern_direct (list, i+1, new, last)
	:	remove_duplicate_intern_direct (list, i+1, concat(new,last), [list[i]])
;
function remove_duplicate_intern_list (list, position=0, i=0, new=[], last=[]) =
	i==len(list) ? concat(new,last):
	let( v = list[i][position] )
	// test value is in 'new'
	((last!=[] && last[0][position]==v) || (len([for (e=new) if (e[position]==v) 0]) != 0) ) ?
		remove_duplicate_intern_list (list, position, i+1, new, last)
	:	remove_duplicate_intern_list (list, position, i+1, concat(new,last), [list[i]])
;
function remove_duplicate_intern_function (list, fn, i=0, new=[], values=[], last=[]) =
	i==len(list) ? new :
	let( v = fn(list[i]) )
	// test value is in 'new'
	((last!=[] && last[0]==v) || (len([for (e=values) if (e==v) 0]) != 0) ) ?
		remove_duplicate_intern_function (list, fn, i+1, new, values, last)
	:	remove_duplicate_intern_function (list, fn, i+1, concat(new,[list[i]]), concat(values,last), [v])
;
function remove_duplicate_intern_type (list, type, i=0, new=[], values=[], last=[]) =
	i==len(list) ? new :
	let( v = get_value(list[i],type) )
	// test value is in 'new'
	((last!=[] && last[0]==v) || (len([for (e=values) if (e==v) 0]) != 0) ) ?
		remove_duplicate_intern_type (list, type, i+1, new, values, last)
	:	remove_duplicate_intern_type (list, type, i+1, concat(new,[list[i]]), concat(values,last), [v])
;


// Entfernt alle Vorkommen eines Wertes
function remove_value (list, value, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0                   ? [ for (e=list) if (e                !=value) e ]
	:type[0]>= 0                   ? [ for (e=list) if (e[type[0]]       !=value) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)            !=value) e ]
	:                                [ for (e=list) if (get_value(e,type)!=value) e ]
;

// Entfernt alle Vorkommen von Werten aus einer Liste
function remove_all_values (list, value_list, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                             if ( len([for(value=value_list) if (e ==value) 0]) == 0 ) e ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])        if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))             if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e ]
	:                                [ for (e=list) let(ev = get_value(e,type)) if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e ]
;

// Ersetzt alle Vorkommen eines Wertes durch einen anderen Wert
function replace_value (list, value, new, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0 ?                   [ for (e=list) if (e                !=value) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) if (e[type[0]]       !=value) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (fn(e)            !=value) e else new ]
	:                                [ for (e=list) if (get_value(e,type)!=value) e else new ]
;

// Ersetzt alle Vorkommen von Werten aus einer Liste durch einen anderen Wert
function replace_all_values (list, value_list, new, type=0) =
	list==undef || len(list)==0 ? list :
	value_list==undef || len(value_list)==0 ? list :
	 type   == 0 ?                   [ for (e=list)                             if ( len([for(value=value_list) if (e ==value) 0]) == 0 ) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) let(ev = e[type[0]])        if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) let(ev = fn(e))             if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e else new ]
	:                                [ for (e=list) let(ev = get_value(e,type)) if ( len([for(value=value_list) if (ev==value) 0]) == 0 ) e else new ]
;

// Entfernt alle aufeinanderfolgenden Duplikate
function unique (list, type=0, f=undef) =
	list==undef || len(list)<=1 ? list :
	let( size = len(list) )
	f==undef ?
		 type   == 0 ?
			[ each
				[ for (i=0  ,v=list[i]                ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i]                ,is_unique=!(v==last),last=is_unique?v:last )
				if (is_unique) v ]
			, each (list[size-2]                ==list[size-1]                ) ? [] : [list[size-1]]
			]
		:type[0]>= 0 ?
			[ each
				[ for (i=0  ,v=list[i][type[0]]       ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i][type[0]]       ,is_unique=!(v==last),last=is_unique?v:last )
				if (is_unique) list[i] ]
			, each (list[size-2][type[0]]       ==list[size-1][type[0]]       ) ? [] : [list[size-1]]
			]
		:type[0]==-1 ? let( fn=type[1] )
			[ each
				[ for (i=0  ,v=fn(list[i])            ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=fn(list[i])            ,is_unique=!(v==last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each (fn(list[size-2])            ==fn(list[size-1])            ) ? [] : [list[size-1]]
			]
		:
			[ each
				[ for (i=0  ,v=get_value(list[i],type),is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=get_value(list[i],type),is_unique=!(v==last),last=is_unique?v:last )
				if (is_unique) list[i] ]
			, each (get_value(list[size-2],type)==get_value(list[size-1],type)) ? [] : [list[size-1]]
			]
	:
		 type   == 0 ?
			[ each
				[ for (i=0  ,v=list[i]                ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i]                ,is_unique=!f(v,last),last=is_unique?v:last )
				if (is_unique) v ]
			, each f(list[size-2]                ,list[size-1]                ) ? [] : [list[size-1]]
			]
		:type[0]>= 0 ?
			[ each
				[ for (i=0  ,v=list[i][type[0]]       ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=list[i][type[0]]       ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f(list[size-2][type[0]]       ,list[size-1][type[0]]       ) ? [] : [list[size-1]]
			]
		:type[0]==-1 ? let( fn=type[1] )
			[ each
				[ for (i=0  ,v=fn(list[i])            ,is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=fn(list[i])            ,is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f(fn(list[size-2])            ,fn(list[size-1])            ) ? [] : [list[size-1]]
			]
		:
			[ each
				[ for (i=0  ,v=get_value(list[i],type),is_unique=true      ,last=v; i<size-1;
				       i=i+1,v=get_value(list[i],type),is_unique=!f(v,last),last=is_unique?v:last ) if (is_unique) list[i] ]
			, each f(get_value(list[size-2],type),get_value(list[size-1],type)) ? [] : [list[size-1]]
			]
;

