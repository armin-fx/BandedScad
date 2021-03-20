// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen und Punktlisten

use <banded/helper_native.scad>


// Listenfunktionen ohne Zugriff auf den Inhalt


// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) for (b=a) b];

// kehrt die Reihenfolge einer Liste um
function reverse_list (list) = [for (a=[len(list)-1:-1:0]) list[a]];

// entfernt Elemente aus einer Liste
function erase_list (list, begin, count=1) =
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


// Listenfunktionen mit Zugriff auf den Inhalt


// gibt den Wert eines angegebenen Typs zurück
// Typen:
//     0     = normaler Wert
//     1...n = Liste mit Position [1,2,3]
//
// Wird in den folgenden Listenfunktionen verwendet,
// um zwischen den Daten umschalten zu können von außerhalb der Funktion
// = Angabe Argument 'type'
function get_value (data, type=0) =
	 type==0 ? data
	:type> 0 ? data[type-1]
	:undef
;

// Gibt eine Liste des gewählten Typs zurück aus einer Liste
function value_list (list, type=0) =
	 type==0 ? list
	:type >0 ? let(p=type-1) [ for (e=list) e[p] ]
	:undef
;

// Maximum oder Minimum einer Liste gemäß des Typs
function min_list(list, type=0) = min (value_list(list, type));
function max_list(list, type=0) = max (value_list(list, type));

// Position des kleinsten Wertes einer Liste gemäß des Typs zurückgeben
function min_position (list, type=0) =
	 type==0 ? min_position_intern_direct (list)
	:type> 0 ? min_position_intern_list   (list, type-1)
	:          min_position_intern_type   (list, type)
;
function min_position_intern_direct (list, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_direct (list
		,list[pos]<=list[i] ? pos : i
		,i+1
		)
;
function min_position_intern_list (list, position=0, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_list (list, position
		,list[pos][position]<=list[i][position] ? pos : i
		,i+1
		)
;
function min_position_intern_type (list, type, pos=0, i=0) =
	i>=len(list) ? pos :
	min_position_intern_type (list, type
		,get_value(list[pos],type)<=get_value(list[i],type) ? pos : i
		,i+1
		)
;

// Position des größten Wertes einer Liste gemäß des Typs zurückgeben
function max_position (list, type=0) =
	 type==0 ? max_position_intern_direct (list)
	:type> 0 ? max_position_intern_list   (list, type-1)
	:          max_position_intern_type   (list, type)
;
function max_position_intern_direct (list, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_direct (list
		,list[pos]>=list[i] ? pos : i
		,i+1
		)
;
function max_position_intern_list (list, position=0, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_list (list, position
		,list[pos][position]>=list[i][position] ? pos : i
		,i+1
		)
;
function max_position_intern_type (list, type, pos=0, i=0) =
	i>=len(list) ? pos :
	max_position_intern_type (list, type
		,get_value(list[pos],type)>=get_value(list[i],type) ? pos : i
		,i+1
		)
;

// Listen sortieren
function sort_list (list, type=0) = sort_list_quicksort (list, type);

// stabiles sortieren mit Quicksort
function sort_list_quicksort (list, type=0) =
	 type==0 ? sort_list_quicksort_direct (list)
	:type> 0 ? sort_list_quicksort_list   (list, type-1)
	:          sort_list_quicksort_type   (list, type)
;
function sort_list_quicksort_direct (list) =
	!(len(list)>1) ? list :
	let(
		pivot   = list[floor(len(list)/2)],
		lesser  = [ for (e=list) if (e  < pivot) e ],
		equal   = [ for (e=list) if (e == pivot) e ],
		greater = [ for (e=list) if (e  > pivot) e ]
	) concat(
		sort_list_quicksort_direct(lesser), equal, sort_list_quicksort_direct(greater)
	)
;
function sort_list_quicksort_list (list, position=0) =
	!(len(list)>1) ? list :
	let(
		pivot   = list[floor(len(list)/2)][position],
		lesser  = [ for (e=list) if (e[position]  < pivot) e ],
		equal   = [ for (e=list) if (e[position] == pivot) e ],
		greater = [ for (e=list) if (e[position]  > pivot) e ]
	) concat(
		sort_list_quicksort_list(lesser,position), equal, sort_list_quicksort_list(greater,position)
	)
;
function sort_list_quicksort_type (list, type) =
	!(len(list)>1) ? list :
	let(
		pivot   = get_value( list[floor(len(list)/2)] ,type),
		lesser  = [ for (e=list) if (get_value(e,type)  < pivot) e ],
		equal   = [ for (e=list) if (get_value(e,type) == pivot) e ],
		greater = [ for (e=list) if (get_value(e,type)  > pivot) e ]
	) concat(
		sort_list_quicksort_type(lesser,type), equal, sort_list_quicksort_type(greater,type)
	)
;

// stabiles sortierten mit Mergesort
function sort_list_mergesort (list, type=0) =
	!(len(list)>1) ? list :
	(len(list)==2) ?
		get_value(list[0],type)<get_value(list[1],type) ?
			[list[0],list[1]] : [list[1],list[0]] :
	let(end=len(list)-1, middle=floor((len(list)-1)/2))
	merge_list(
		 sort_list_mergesort([for (i=[0:middle])     list[i]], type)
		,sort_list_mergesort([for (i=[middle+1:end]) list[i]], type)
		,type
	)
;

// 2 sortierte Listen miteinander verschmelzen
// sehr langsame Implementierung
function merge_list        (list1, list2, type=0) = merge_list_intern_2 (list1, list2, type);
function merge_list_intern (list1, list2, type=0, i1=0, i2=0) =
	(i1>=len(list1) || i2>=len(list2)) ?
		(i1>=len(list1)) ? [ for (e=[i2:len(list2)-1]) list2[e] ]
	:	(i2>=len(list2)) ? [ for (e=[i1:len(list1)-1]) list1[e] ]
	:   []
	:(get_value(list1[i1],type) <= get_value(list2[i2],type)) ?
		 concat([list1[i1]], merge_list_intern (list1, list2, type, i1+1, i2))
		:concat([list2[i2]], merge_list_intern (list1, list2, type, i1,   i2+1))
;
function merge_list_intern_2 (list1, list2, type=0) =
	let(
		enda=len(list1),
		endb=len(list2)
	)
	!(enda>0) ? list2 :
	!(endb>0) ? list1 :
	let (
		a=list1,
		b=list2,
		end=enda+endb - 1
	)
	[for (
		i=0,j=0,
			A=get_value(a[i],type),
			B=get_value(b[j],type),
			q=j>=endb?true:A<B, v=q?a[i]:b[j]
		;i+j<=end;
		i=q?i+1:i, j=q?j:j+1,
			A=get_value(a[i],type),
			B=get_value(b[j],type),
			q=j>=endb?true:A<B, v=q?a[i]:b[j]
	) v ]
;

function binary_search_list        (list, value, type=0) = (len(list)<=1) ? 0 : binary_search_list_intern (list, value, type, 0, len(list)-1);
function binary_search_list_intern (list, value, type, begin, end) =
	(end<begin)        ? -begin
	:let(middle=floor((begin+end)/2))
	 (get_value(list[middle])==value) ? middle
	:(get_value(list[middle])< value) ? binary_search_list_intern (list, value, middle+1, end)
	:                                   binary_search_list_intern (list, value, begin   , middle-1)
;

// sucht nach einem Wert und gibt die Position des Treffers aus einer Liste heraus
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function find_first_list (list, value, index=0, type=0) =
	 type==0 ? find_first_list_intern_direct (list, value, index)
	:type> 0 ? find_first_list_intern_list   (list, value, index, type-1)
	:          find_first_list_intern_type   (list, value, index, type)
;
function find_first_list_intern_direct (list, value, index=0, n=0) =
	(list[n]==undef) ? len(list)
	:(list[n]==value) ?
		(index==0) ? n
		:	find_first_list_intern_direct (list, value, index-1, n+1)
	:		find_first_list_intern_direct (list, value, index,   n+1)
;
function find_first_list_intern_list (list, value, index=0, position=0, n=0) =
	(list[n]==undef) ? len(list)
	:(list[n][position]==value) ?
		(index==0) ? n
		:	find_first_list_intern_list (list, value, index-1, position, n+1)
	:		find_first_list_intern_list (list, value, index,   position, n+1)
;
function find_first_list_intern_type (list, value, index=0, type, n=0) =
	(list[n]==undef) ? len(list)
	:(get_value(list[n],type)==value) ?
		(index==0) ? n
		:	find_first_list_intern_type (list, value, index-1, type, n+1)
	:		find_first_list_intern_type (list, value, index,   type, n+1)
;

// Zählt das Vorkommen eines Wertes in der Liste
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
// Optionale Angabe des Bereichs:
//     begin = erstes Element aus der Liste
//     last  = letztes Element
// oder
//     range = [begin, last]
// Kodierung wie in python
function count_list        (list, value, type=0, begin, last, count, range) =
	let (Range = parameter_range_safe (list, begin, last, count, range))
	 type==0 ? count_list_intern_direct (list, value,         Range[0], Range[1])
	:type >0 ? count_list_intern_list   (list, value, type-1, Range[0], Range[1])
	:          count_list_intern_type   (list, value, type,   Range[0], Range[1])
;
function count_list_intern_direct (list, value, n=0, k=-1, count=0) =
	n>k ? count :
	count_list_intern_direct (list, value
		, n+1, k,
		, count + ( list[n]==value ? 1 : 0 )
	)
;
function count_list_intern_list (list, value, position=0, n=0, k=-1, count=0) =
	n>k ? count :
	count_list_intern_list (list, value, position
		, n+1, k,
		, count + ( list[n][position]==value ? 1 : 0 )
	)
;
function count_list_intern_type (list, value, type, n=0, k=-1, count=0) =
	n>k ? count :
	count_list_intern_type (list, value, type
		, n+1, k,
		, count + ( get_value(list[n],type)==value ? 1 : 0 )
	)
;

// Entfernt alle Duplikate aus der Liste
function remove_duplicate_list (list, type=0) =
	len(list)==0 ? list :
	 type==0 ? remove_duplicate_list_intern_direct (list)
	:type >0 ? remove_duplicate_list_intern_list   (list, type-1)
	:          remove_duplicate_list_intern_type   (list, type)
;
function remove_duplicate_list_intern_direct (list, i=0, new=[]) =
	i==len(list) ? new :
	(find_first_list (new, list[i]) == len(new)) ?
		remove_duplicate_list_intern_direct (list, i+1, concat(new,[list[i]]))
	:	remove_duplicate_list_intern_direct (list, i+1, new)
;
function remove_duplicate_list_intern_list (list, position=0, i=0, new=[]) =
	i==len(list) ? new :
	(find_first_list_intern_list (new, list[i][position], position=position) == len(new)) ?
		remove_duplicate_list_intern_list (list, position, i+1, concat(new,[list[i]]))
	:	remove_duplicate_list_intern_list (list, position, i+1, new)
;
function remove_duplicate_list_intern_type (list, type, i=0, new=[]) =
	i==len(list) ? new :
	(find_first_list (new, get_value(list[i],type), type=type) == len(new)) ?
		remove_duplicate_list_intern_type (list, type, i+1, concat(new,[list[i]]))
	:	remove_duplicate_list_intern_type (list, type, i+1, new)
;

// Entfernt alle Vorkommen eines Wertes
function remove_value_list (list, value, type=0) =
	len(list)==0 ? list :
	 type==0 ? [ for (e=list) if (e                !=value) e ]
	:type >0 ? [ for (e=list) if (e[type-1]        !=value) e ]
	:          [ for (e=list) if (get_value(e,type)!=value) e ]
;


// pair-Funktionen
//
// Aufbau eines Paares: [key, value]
// list = Liste mehrerer Schlüssel-Wert-Paare z.B. [ [key1,value1], [key2,value2], ... ]

// Typ-Konstanten für die Listenfunktionen
type_pair_key  =1;
type_pair_value=2;

// gibt den Wert eines Schlüssels aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Schlüssel zum Wert
//   index   -Bei gleichen Schlüsselwerten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function pair_value     (list, key, index=0) =
	list[find_first_list(list, key, index, type=type_pair_key)][type_pair_value-1];

// gibt den Schlüssel eines Wertes aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Wert zum Schlüssel
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Wert genommen (index=0)
function pair_key       (list, value, index=0) =
	list[find_first_list(list, value, index, type=type_pair_value)][type_pair_key-1];

// erzeugt ein Schlüssel-Werte-Paare
function pair (key, value) = [key, value];


