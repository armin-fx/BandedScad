// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen und Punktlisten

use <tools/function_helper.scad>

// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) for (b=a) b];

// kehrt die Reihenfolge einer Liste um
function reverse_list (list) = [for (a=[len(list)-1:-1:0]) list[a]];

// entfernt Elemente aus einer Liste
function erase_list (list, begin, count=1) =
	let (size=len(list))
	concat(
		 (get_position(list,begin)==0) ? []
		 :[for (i=[0:min(get_position(list,begin)-1,size-1)])
				list[i]]
		,(get_position(list,begin)+get_position(list,count)>=size) ? []
		 :[for (i=[min(get_position(list,begin)+get_position(list,count),size-1):size-1])
				list[i]]
	)
;

// fügt alle Elemente einer Liste in die Liste ein
function insert_list (list, list_insert, position=-1, begin=0, count=-1) =
	let (size=len(list), size_insert=len(list_insert))
	concat(
		 (get_position_insert(list,position)<=0) ? []
		 :[for (i=[0:min(get_position_insert(list,position)-1,size-1)])
				list[i] ]
		,(get_position(list_insert,begin)>min(get_position(list_insert,begin)+get_position_insert(list_insert,count)-1,size_insert-1)) ? []
		 :[for (i=[get_position(list_insert,begin):min(get_position(list_insert,begin)+get_position_insert(list_insert,count)-1,size_insert-1)])
				list_insert[i] ]
		,(get_position_insert(list,position)>=size) ? []
		 :[for (i=[max(0,min(get_position_insert(list,position),size-1)):size-1])
				list[i] ]
	)
;

// extrahiert eine Sequenz aus der Liste
// Angaben:
//     list  = Liste mit der enthaltenen Sequenz
//     begin = erstes Element aus der Liste
//     last  = letztes Element
// oder
//     range = [begin, last]
// Kodierung wie in python
function extract_list (list, begin, last, range) =
	let(
		Range = parameter_range_safe (list, begin, last, range),
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

// Listenfunktionen

// gibt den Wert eines angegebenen Typs zurück
// Typen:
//     0     = normaler Wert
//     1...n = Liste mit Position [1,2,3]
//
// Wird in den folgenden Listenfunktionen verwendet,
// um zwischen den Daten umschalten zu können von außerhalb der Funktion
// = Angabe Argument 'type'
function get_value (data, type=0) = (type==0) ? data : data[type-1];

// Gibt eine Liste des gewählten Typs zurück aus einer Liste
function value_list (list, type=0) = (type==0) ? list : let(i=type-1) [ for (e=list) e[i] ];

// Maximum oder Minimum einer Liste gemäß des Typs
function min_list(list, type=0) = min (value_list(list, type));
function max_list(list, type=0) = max (value_list(list, type));

// Listen sortieren
function sort_list (list, type=0) = sort_list_quicksort (list, type);

// stabiles sortieren mit Quicksort
function sort_list_quicksort (list, type=0) =
	!(len(list)>1) ? list :
	let(
		pivot   = get_value( list[floor(len(list)/2)] ,type),
		lesser  = [ for (e = list) if (get_value(e,type)  < pivot) e ],
		equal   = [ for (e = list) if (get_value(e,type) == pivot) e ],
		greater = [ for (e = list) if (get_value(e,type)  > pivot) e ]
	) concat(
		sort_list_quicksort(lesser,type), equal, sort_list_quicksort(greater,type)
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
function find_first_list        (list, value, index=0, type=0) = find_first_list_intern(list, value, index, type);
function find_first_list_intern (list, value, index,   type, n=0) =
	(list[n]==undef) ? len(list)
	:(get_value(list[n],type)==value) ?
		(index==0) ? n
		:	find_first_list_intern (list, value, index-1, type, n+1)
	:		find_first_list_intern (list, value, index,   type, n+1)
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
function count_list        (list, value, type=0, begin, last, range) =
	let (Range = parameter_range_safe (list, begin, last, range))
	count_list_intern (list, value, type, Range[0], Range[1])
;
function count_list_intern (list, value, type, n=0, k=-1, count=0) =
	n>k ? count :
	count_list_intern (list, value, type
		, n+1, k,
		, count + ( get_value(list[n],type)==value ? 1 : 0 )
	)
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
	list[find_first_list(list, key, index, type_pair_key)][type_pair_value-1];

// gibt den Schlüssel eines Wertes aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Wert zum Schlüssel
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Wert genommen (index=0)
function pair_key       (list, value, index=0) =
	list[find_first_list(list, value, index, type_pair_value)][type_pair_key-1];

// erzeugt ein Schlüssel-Werte-Paare
function pair (key, value) = [key, value];


