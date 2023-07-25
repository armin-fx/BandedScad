// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum ermitteln von Daten von Listen mit Zugriff auf den Inhalt
//
// Die Funktionen für typabhängigen Zugriff wurden zum Teil inline eingesetzt
// um die Ausführgeschwindigkeit zu erhöhen,
// lässt sich bei Änderungen an den internen Typdaten aber schlecht warten.
// Funktionsaufrufe sind teuer.
// Außerdem wurden für jeden bekannten Typ eine eigene Version der Funktion
// erstellt, aus dem selben Grund.

use <banded/helper.scad>

use <banded/list_edit_type.scad>


// Maximum oder Minimum einer Liste gemäß des Typs
function min_value   (list, type=0) = min (value_list(list, type));
function max_value   (list, type=0) = max (value_list(list, type));
function bound_value (list, type=0) =
	let( v=value_list(list, type) )
	[min(v), max(v)]
;

function min_entry (list, type=0) = type==0 ? min(list) : list[ min_position (list, type) ];
function max_entry (list, type=0) = type==0 ? max(list) : list[ max_position (list, type) ];

// Position des kleinsten Wertes einer Liste gemäß des Typs zurückgeben
function min_position (list, type=0) =
	list==undef || list==[] ? -1 :
	let ( size=len(list) )
	size==1 ? 0 :
	 type   == 0 ? min_position_intern_direct   (list         , size)
	:type[0]>= 0 ? min_position_intern_list     (list, type[0], size)
	:type[0]==-1 ? min_position_intern_function (list, type[1], size)
	:              min_position_intern_type     (list, type   , size)
;
function min_position_intern_direct (list, size=0, pos=0, i=1) =
	i>=size ? pos :
	min_position_intern_direct (list, size
		,list[pos]<=list[i] ? pos : i
		,i+1
		)
;
function min_position_intern_list (list, position, size=0, pos=0, i=1) =
	i>=size ? pos :
	min_position_intern_list (list, position, size
		,list[pos][position]<=list[i][position] ? pos : i
		,i+1
		)
;
function min_position_intern_function (list, fn, size=0, pos=0, i=1) =
	i>=size ? pos :
	min_position_intern_function (list, fn, size
		,fn(list[pos])<=fn(list[i]) ? pos : i
		,i+1
		)
;
function min_position_intern_type (list, type, size, pos=0, i=1) =
	i>=size ? pos :
	min_position_intern_type (list, type, size
		,value(list[pos],type)<=value(list[i],type) ? pos : i
		,i+1
		)
;

// Position des größten Wertes einer Liste gemäß des Typs zurückgeben
function max_position (list, type=0) =
	list==undef || list==[] ? -1 :
	let ( size=len(list) )
	size==1 ? 0 :
	 type   ==0 ? max_position_intern_direct (list         , size)
	:type[0]>=0 ? max_position_intern_list   (list, type[0], size)
	:             max_position_intern_type   (list, type   , size)
;
function max_position_intern_direct (list, size, pos=0, i=1) =
	i>=size ? pos :
	max_position_intern_direct (list, size
		,list[pos]>=list[i] ? pos : i
		,i+1
		)
;
function max_position_intern_list (list, position, size, pos=0, i=1) =
	i>=size ? pos :
	max_position_intern_list (list, position, size
		,list[pos][position]>=list[i][position] ? pos : i
		,i+1
		)
;
function max_position_intern_function (list, fn, size, pos=0, i=1) =
	i>=size ? pos :
	max_position_intern_function (list, fn, size
		,fn(list[pos])>=fn(list[i]) ? pos : i
		,i+1
		)
;
function max_position_intern_type (list, type, size, pos=0, i=1) =
	i>=size ? pos :
	max_position_intern_type (list, type, size
		,value(list[pos],type)>=value(list[i],type) ? pos : i
		,i+1
		)
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
function count        (list, value, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	count_intern      (list, value, type, Range[0], Range[1])
;
// Zähle alles durch von Position n nach k
function count_intern (list, value, type=0, n=0, k=-1) =
	n>k ? 0 :
	 type   == 0                   ? len([for(i=[n:1:k]) if (list[i]            ==value) 0])
	:type[0]>= 0                   ? len([for(i=[n:1:k]) if (list[i][type[0]]   ==value) 0])
	:type[0]==-1 ? let( fn=type[1] ) len([for(i=[n:1:k]) if (fn(list[i])        ==value) 0])
	:                                len([for(i=[n:1:k]) if (value(list[i],type)==value) 0])
;
function count_intern_old (list, value, type=0, n=0, k=-1, count=0) =
	 type   == 0 ? count_intern_direct   (list, value,          n, k)
	:type[0]>= 0 ? count_intern_list     (list, value, type[0], n, k)
	:type[0]==-1 ? count_intern_function (list, value, type[1], n, k)
	:              count_intern_type     (list, value, type,    n, k)
;
function count_intern_direct (list, value, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_direct (list, value
		, n+1, k
		, count + ( list[n]==value ? 1 : 0 )
	)
;
function count_intern_list (list, value, position=0, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_list (list, value, position
		, n+1, k
		, count + ( list[n][position]==value ? 1 : 0 )
	)
;
function count_intern_function (list, value, fn, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_function (list, value, fn
		, n+1, k
		, count + ( fn(list[n])==value ? 1 : 0 )
	)
;
function count_intern_type (list, value, type, n=0, k=-1, count=0) =
	n>k ? count :
	count_intern_type (list, value, type
		, n+1, k
		, count + ( value(list[n],type)==value ? 1 : 0 )
	)
;

// sucht nach einem Wert und gibt die Position des Treffers aus einer Liste heraus
// Die Liste wird vom Anfang aus durchsucht
// Wurde der Wert nicht gefunden, wird die Position nach dem letzten Element zurückgegeben
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function find  (list, value, index=0, type=0, begin, last, count, range) =
	find_first (list, value, index  , type  , begin, last, count, range)
;
function find_first (list, value, index=0, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	index==0 ? find_first_once_intern (list, value, type, Range[0], Range[1]) :
	//
	 type   == 0 ? find_first_intern_direct   (list, value, index         , Range[0], Range[1])
	:type[0]>= 0 ? find_first_intern_list     (list, value, index, type[0], Range[0], Range[1])
	:type[0]==-1 ? find_first_intern_function (list, value, index, type[1], Range[0], Range[1])
	:              find_first_intern_type     (list, value, index, type   , Range[0], Range[1])
;
function find_first_intern_direct (list, value, index=0, n=0, last=-1) =
	(n>last) ? n :
	(list[n]==value) ?
		(index==0) ? n
		:	find_first_intern_direct (list, value, index-1, n+1, last)
	:		find_first_intern_direct (list, value, index,   n+1, last)
;
function find_first_intern_list (list, value, index=0, position=0, n=0, last=-1) =
	(n>last) ? n :
	(list[n][position]==value) ?
		(index==0) ? n
		:	find_first_intern_list (list, value, index-1, position, n+1, last)
	:		find_first_intern_list (list, value, index,   position, n+1, last)
;
function find_first_intern_function (list, value, index=0, fn, n=0, last=-1) =
	(n>last) ? n :
	(fn(list[n])==value) ?
		(index==0) ? n
		:	find_first_intern_function (list, value, index-1, fn, n+1, last)
	:		find_first_intern_function (list, value, index,   fn, n+1, last)
;
function find_first_intern_type (list, value, index=0, type, n=0, last=-1) =
	(n>last) ? n :
	(value(list[n],type)==value) ?
		(index==0) ? n
		:	find_first_intern_type (list, value, index-1, type, n+1, last)
	:		find_first_intern_type (list, value, index,   type, n+1, last)
;
//
// sucht nach dem ersten Auftreten eines Wertes und gibt die Position des Treffers aus einer Liste heraus
function find_first_once (list, value, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_first_once_intern (list, value, type, Range[0], Range[1])
;
function find_first_once_intern (list, value, type=0, n=0, last=-1) =
	 type   == 0 ? find_first_once_intern_direct   (list, value         , n, last)
	:type[0]>= 0 ? find_first_once_intern_list     (list, value, type[0], n, last)
	:type[0]==-1 ? find_first_once_intern_function (list, value, type[1], n, last)
	:              find_first_once_intern_type     (list, value, type   , n, last)
;
function find_first_once_intern_direct   (list, value, n=0, last=-1) =
	(n>last) || (list[n]            ==value) ? n :
	find_first_once_intern_direct        (list, value, n+1, last)
;
function find_first_once_intern_list     (list, value, position, n=0, last=-1) =
	(n>last) || (list[n][position]  ==value) ? n :
	find_first_once_intern_list          (list, value, position, n+1, last)
;
function find_first_once_intern_function (list, value, fn, n=0, last=-1) =
	(n>last) || (fn(list[n])        ==value) ? n :
	find_first_once_intern_function      (list, value, fn, n+1, last)
;
function find_first_once_intern_type     (list, value, type, n=0, last=-1) =
	(n>last) || (value(list[n],type)==value) ? n :
	find_first_once_intern_type          (list, value, type, n+1, last)
;

// sucht eine Liste von Werte und gibt die Position des Treffers aus einer Liste heraus
// Die Liste wird vom Anfang aus durchsucht
// Wurde kein Treffer gefunden, wird die Position nach dem letzten Element zurückgegeben
// Argumente:
//   list       -Liste
//   value_list - Liste mit gesuchten Werten
//   index      -Bei gleichen Werten wird index-mal übersprungen
//               standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function find_first_of (list, value_list, index=0, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
//	index==0 ? find_first_of_once_intern (list, value_list, type, Range[0], Range[1]) :
	//
	 type   == 0 ? find_first_of_intern_direct   (list, value_list, index         , Range[0], Range[1])
	:type[0]>= 0 ? find_first_of_intern_list     (list, value_list, index, type[0], Range[0], Range[1])
	:type[0]==-1 ? find_first_of_intern_function (list, value_list, index, type[1], Range[0], Range[1])
	:              find_first_of_intern_type     (list, value_list, index, type   , Range[0], Range[1])
;
function find_first_of_intern_direct (list, value_list, index=0, n=0, last=-1) =
	(n>last) ? n :
	( [for (value=value_list) if (list[n]==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_first_of_intern_direct (list, value_list, index-1, n+1, last)
	:		find_first_of_intern_direct (list, value_list, index,   n+1, last)
;
function find_first_of_intern_list (list, value_list, index=0, position=0, n=0, last=-1) =
	(n>last) ? n :
	( [for (value=value_list) if (list[n][position]==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_first_of_intern_list (list, value_list, index-1, position, n+1, last)
	:		find_first_of_intern_list (list, value_list, index  , position, n+1, last)
;
function find_first_of_intern_function (list, value_list, index=0, fn, n=0, last=-1) =
	(n>last) ? n :
	let( v = fn(list[n]) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_first_of_intern_function (list, value_list, index-1, fn, n+1, last)
	:		find_first_of_intern_function (list, value_list, index  , fn, n+1, last)
;
function find_first_of_intern_type (list, value_list, index=0, type, n=0, last=-1) =
	(n>last) ? n :
	let( v = value(list[n],type) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_first_of_intern_type (list, value_list, index-1, type, n+1, last)
	:		find_first_of_intern_type (list, value_list, index  , type, n+1, last)
;
//
// sucht nach dem ersten Auftreten von Werten und gibt die Position des Treffers aus einer Liste heraus
function find_first_of_once (list, value_list, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_first_of_once_intern (list, value_list, type, Range[0], Range[1])
;
function find_first_of_once_intern (list, value_list, type=0, n=0, last=-1) =
	 type   == 0 ? find_first_of_once_intern_direct   (list, value_list         , n, last)
	:type[0]>= 0 ? find_first_of_once_intern_list     (list, value_list, type[0], n, last)
	:type[0]==-1 ? find_first_of_once_intern_function (list, value_list, type[1], n, last)
	:              find_first_of_once_intern_type     (list, value_list, type   , n, last)
;
function find_first_of_once_intern_direct   (list, value_list, n=0, last=-1) =
	(n>last) ? n :
	( [for (value=value_list) if (list[n]==value) 0 ] != [] ) ? n :
	find_first_of_once_intern_direct        (list, value_list, n+1, last)
;
function find_first_of_once_intern_list     (list, value_list, position, n=0, last=-1) =
	(n>last) ? n :
	( [for (value=value_list) if (list[n][position]==value) 0 ] != [] ) ? n :
	find_first_of_once_intern_list          (list, value_list, position, n+1, last)
;
function find_first_of_once_intern_function (list, value_list, fn, n=0, last=-1) =
	(n>last) ? n :
	let( v = fn(list[n]) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ? n :
	find_first_of_once_intern_function      (list, value_list, fn, n+1, last)
;
function find_first_of_once_intern_type     (list, value_list, type, n=0, last=-1) =
	(n>last) ? n :
	let( v = value(list[n],type) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ? n :
	find_first_of_once_intern_type          (list, value_list, type, n+1, last)
;

// sucht nach einem Wert und gibt die Position des Treffers aus einer Liste heraus
// Die Liste wird vom Ende aus rückwärts durchsucht
// Wurde der Wert nicht gefunden, wird die Position vor dem ersten Element zurückgegeben
// Argumente:
//   list    -Liste
//   value   -gesuchter Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste vom Ende aus gefundene Schlüssel genommen (index=0)
function find_last (list, value, index=0, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	index==0 ? find_last_once_intern (list, value, type, Range[1], Range[0]) :
	//
	 type   == 0 ? find_last_intern_direct   (list, value, index         , Range[1], Range[0])
	:type[0]>= 0 ? find_last_intern_list     (list, value, index, type[0], Range[1], Range[0])
	:type[0]==-1 ? find_last_intern_function (list, value, index, type[1], Range[1], Range[0])
	:              find_last_intern_type     (list, value, index, type   , Range[1], Range[0])
;
function find_last_intern_direct (list, value, index=0, n=-2, first=0) =
	(n<first) ? n
	:(list[n]==value) ?
		(index==0) ? n
		:	find_last_intern_direct (list, value, index-1, n-1, first)
	:		find_last_intern_direct (list, value, index,   n-1, first)
;
function find_last_intern_list (list, value, index=0, position=0, n=-2, first=0) =
	(n<first) ? n
	:(list[n][position]==value) ?
		(index==0) ? n
		:	find_last_intern_list (list, value, index-1, position, n-1, first)
	:		find_last_intern_list (list, value, index,   position, n-1, first)
;
function find_last_intern_function (list, value, index=0, fn, n=-2, first=0) =
	(n<first) ? n
	:(fn(list[n])==value) ?
		(index==0) ? n
		:	find_last_intern_function (list, value, index-1, fn, n-1, first)
	:		find_last_intern_function (list, value, index,   fn, n-1, first)
;
function find_last_intern_type (list, value, index=0, type, n=-2, first=0) =
	(n<first) ? n
	:(value(list[n],type)==value) ?
		(index==0) ? n
		:	find_last_intern_type (list, value, index-1, type, n-1, first)
	:		find_last_intern_type (list, value, index,   type, n-1, first)
;
//
// sucht rückwärts nach dem ersten Auftreten eines Wertes und gibt die Position des Treffers aus einer Liste heraus
function find_last_once (list, value, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_last_once_intern (list, value, type, Range[1], Range[0])
;
function find_last_once_intern (list, value, type=0, n=-1, first=0) =
	 type   == 0 ? find_last_once_intern_direct   (list, value         , n, first)
	:type[0]>= 0 ? find_last_once_intern_list     (list, value, type[0], n, first)
	:type[0]==-1 ? find_last_once_intern_function (list, value, type[1], n, first)
	:              find_last_once_intern_type     (list, value, type   , n, first)
;
function find_last_once_intern_direct   (list, value, n=-2, first=0) =
	(n<first) || (list[n]            ==value) ? n :
	find_last_once_intern_direct        (list, value, n-1, first)
;
function find_last_once_intern_list     (list, value, position, n=-2, first=0) =
	(n<first) || (list[n][position]  ==value) ? n :
	find_last_once_intern_list          (list, value, position, n-1, first)
;
function find_last_once_intern_function (list, value, fn, n=-2, first=0) =
	(n<first) || (fn(list[n])        ==value) ? n :
	find_last_once_intern_function      (list, value, fn, n-1, first)
;
function find_last_once_intern_type     (list, value, type, n=-2, first=0) =
	(n<first) || (value(list[n],type)==value) ? n :
	find_last_once_intern_type          (list, value, type, n-1, first)
;

// sucht nach Werte und gibt die Position des Treffers aus einer Liste heraus
// Die Liste wird vom Ende aus rückwärts durchsucht
// Wurde kein Treffer gefunden, wird die Position vor dem ersten Element zurückgegeben
// Argumente:
//   list       -Liste
//   value_list -gesuchte Werte in einer Liste
//   index      -Bei gleichen Werten wird index-mal übersprungen
//               standartmäßig wird der erste vom Ende aus gefundene Schlüssel genommen (index=0)
function find_last_of (list, value_list, index=0, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
//	index==0 ? find_last_of_once_intern (list, value_list, type, Range[1], Range[0]) :
	//
	 type   == 0 ? find_last_of_intern_direct   (list, value_list, index         , Range[1], Range[0])
	:type[0]>= 0 ? find_last_of_intern_list     (list, value_list, index, type[0], Range[1], Range[0])
	:type[0]==-1 ? find_last_of_intern_function (list, value_list, index, type[1], Range[1], Range[0])
	:              find_last_of_intern_type     (list, value_list, index, type   , Range[1], Range[0])
;
function find_last_of_intern_direct (list, value_list, index=0, n=-2, first=0) =
	(n<first) ? n :
	( [for (value=value_list) if (list[n]==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_last_of_intern_direct (list, value_list, index-1, n-1, first)
	:		find_last_of_intern_direct (list, value_list, index,   n-1, first)
;
function find_last_of_intern_list (list, value_list, index=0, position=0, n=-2, first=0) =
	(n<first) ? n :
	( [for (value=value_list) if (list[n][position]==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_last_of_intern_list (list, value_list, index-1, position, n-1, first)
	:		find_last_of_intern_list (list, value_list, index,   position, n-1, first)
;
function find_last_of_intern_function (list, value_list, index=0, fn, n=-2, first=0) =
	(n<first) ? n :
	let( v = fn(list[n]) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_last_of_intern_function (list, value_list, index-1, fn, n-1, first)
	:		find_last_of_intern_function (list, value_list, index,   fn, n-1, first)
;
function find_last_of_intern_type (list, value_list, index=0, type, n=-2, first=0) =
	(n<first) ? n :
	let( v = value(list[n],type) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ?
		(index==0) ? n
		:	find_last_of_intern_type (list, value_list, index-1, type, n-1, first)
	:		find_last_of_intern_type (list, value_list, index,   type, n-1, first)
;
//
// sucht rückwärts nach dem ersten Auftreten von Werten und gibt die Position des Treffers aus einer Liste heraus
function find_last_of_once (list, value_list, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_last_of_once_intern (list, value_list, type, Range[1], Range[0])
;
function find_last_of_once_intern (list, value_list, type=0, n=-1, first=0) =
	 type   == 0 ? find_last_of_once_intern_direct   (list, value_list         , n, first)
	:type[0]>= 0 ? find_last_of_once_intern_list     (list, value_list, type[0], n, first)
	:type[0]==-1 ? find_last_of_once_intern_function (list, value_list, type[1], n, first)
	:              find_last_of_once_intern_type     (list, value_list, type   , n, first)
;
function find_last_of_once_intern_direct   (list, value_list, n=-2, first=0) =
	(n<first) ? n :
	( [for (value=value_list) if (list[n]==value) 0 ] != [] ) ? n :
	find_last_of_once_intern_direct        (list, value_list, n-1, first)
;
function find_last_of_once_intern_list     (list, value_list, position, n=-2, first=0) =
	(n<first) ? n :
	( [for (value=value_list) if (list[n][position]==value) 0 ] != [] ) ? n :
	find_last_of_once_intern_list          (list, value_list, position, n-1, first)
;
function find_last_of_once_intern_function (list, value_list, fn, n=-2, first=0) =
	(n<first) ? n :
	let( v = fn(list[n]) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ? n :
	find_last_of_once_intern_function      (list, value_list, fn, n-1, first)
;
function find_last_of_once_intern_type     (list, value_list, type, n=-2, first=0) =
	(n<first) ? n :
	let( v = value(list[n],type) )
	( [for (value=value_list) if (v==value) 0 ] != [] ) ? n :
	find_last_of_once_intern_type          (list, value_list, type, n-1, first)
;

// Sucht eine Sequenz von Daten und gibt die Position vom ersten Treffer zurück.
// Wurde die Sequenz nicht gefunden, wird die Position nach dem letzten Element zurückgegeben.
function search_sequence (list, sequence, type=0, begin, last, count, range) =
	list    ==undef ? 0 :
	let(
		Range  = parameter_range_safe (list, begin, last, count, range),
		size_l = len(list)
	)
	size_l  ==0     ? 0 :
	sequence==undef ? Range[0] :
	let(
		size_s = len(sequence)
	)
	size_s==0 ? Range[0] :
	size_s==1 ? find_first_once_intern (list, sequence[0], type, Range[0], Range[1]) :
	//
	 type   == 0 ? search_sequence_intern_direct (list,                  sequence,          Range[1]+1, size_s, Range[0])
	:type[0]>= 0 ? search_sequence_intern_list   (list,                  sequence, type[0], Range[1]+1, size_s, Range[0])
	:              search_sequence_intern_direct (value_list(list,type), sequence,          Range[1]+1, size_s, Range[0])
;	
function search_sequence_intern_direct (list, sequence, size_l=0, size_s=0, i_l=0, i_s=0) =
	i_l    >=size_l ? size_l :
	i_s    >=size_s ? i_l :
	i_l+i_s>=size_l ? size_l :
	(list[i_l+i_s] == sequence[i_s])
	?	search_sequence_intern_direct (list, sequence, size_l, size_s, i_l  , i_s+1)
	:	search_sequence_intern_direct (list, sequence, size_l, size_s, i_l+1, 0    )
;
function search_sequence_intern_list (list, sequence, position=0, size_l=0, size_s=0, i_l=0, i_s=0) =
	i_l    >=size_l ? size_l :
	i_s    >=size_s ? i_l :
	i_l+i_s>=size_l ? size_l :
	(list[i_l+i_s][position] == sequence[i_s])
	?	search_sequence_intern_list (list, sequence, position, size_l, size_s, i_l  , i_s+1)
	:	search_sequence_intern_list (list, sequence, position, size_l, size_s, i_l+1, 0    )
;

// Sucht eine Sequenz von Daten und gibt alle Positionen der Treffer in einer Liste zurück.
// Wurde die Sequenz nicht gefunden, wird eine leere Liste zurückgegeben.
function sequence_positions (list, sequence, type=0, begin, last, count, range) =
	list    ==undef ? [] :
	sequence==undef ? [] :
	let(
		Range  = parameter_range_safe (list, begin, last, count, range),
		size_l = len(list),
		size_s = len(sequence)
	)
	size_l==0 ? [] :
	size_s==0 ? [] :
	size_s==1 ?
		let ( value=sequence[0] )
		 type   == 0 ?                 [ for (i=[Range[0]:1:Range[1]]) if (      list[i]      ==value) i ]
		:type[0]>= 0 ? let(p =type[0]) [ for (i=[Range[0]:1:Range[1]]) if (      list[i][p]   ==value) i ]
		:type[0]==-1 ? let(fn=type[1]) [ for (i=[Range[0]:1:Range[1]]) if (fn   (list[i])     ==value) i ]
		:                              [ for (i=[Range[0]:1:Range[1]]) if (value(list[i],type)==value) i ]
	:
	 type   == 0 ? sequence_positions_intern_direct (list,                  sequence,          Range[1]+1, size_s, Range[0])
//	:type[0]>= 0 ? sequence_positions_intern_list   (list,                  sequence, type[0], Range[1]+1, size_s, Range[0])
	:              sequence_positions_intern_direct (value_list(list,type), sequence,          Range[1]+1, size_s, Range[0])
;	
function sequence_positions_intern_direct (list, sequence, size_l=0, size_s=0, i_l=0, result=[]) =
	let(
		pos = search_sequence_intern_direct (list, sequence, size_l, size_s, i_l)
	)
	pos       >=size_l ? result :
	pos+size_s>=size_l ? [ each result, pos ] :
	sequence_positions_intern_direct (list, sequence, size_l, size_s, pos+size_s, [ each result, pos ])
;

// Testet 2 Listen nach Gleichheit und gibt den ersten Treffer bei 'list1', der nicht gleich ist.
// Die Rückgabe enthält die Position des Treffers beider Listen als Liste [pos list1, pos list2].
// Vergleicht die Daten direkt mit dem Operator == oder mit Funktion 'f', wenn angegeben
function mismatch (list1, list2, begin1=0, begin2=0, count=undef, type=0, f=undef) =
	list1==undef || list2==undef ? 0 :
	let (
		Range1 = parameter_range_safe (list1, begin1, undef, count, undef),
		Range2 = parameter_range_safe (list2, begin2, undef, count, undef),
		Begin1 = Range1[0],
		Begin2 = Range2[0],
		Count1 = Range1[1] - Range1[0] + 1,
		Count2 = Range2[1] - Range2[0] + 1,
		Count  = min (Count1, Count2),
		result =
			f==undef ?
				 type   == 0 ? mismatch_count_intern_direct   (list1, list2,          Begin1, Begin2, Count)
				:type[0]>= 0 ? mismatch_count_intern_list     (list1, list2, type[0], Begin1, Begin2, Count)
				:type[0]==-1 ? mismatch_count_intern_function (list1, list2, type[1], Begin1, Begin2, Count)
				:              mismatch_count_intern_type     (list1, list2, type   , Begin1, Begin2, Count)
			:
				 type   == 0 ? mismatch_count_intern_f_direct   (list1, list2, f,          Begin1, Begin2, Count)
				:type[0]>= 0 ? mismatch_count_intern_f_list     (list1, list2, f, type[0], Begin1, Begin2, Count)
				:type[0]==-1 ? mismatch_count_intern_f_function (list1, list2, f, type[1], Begin1, Begin2, Count)
				:              mismatch_count_intern_f_type     (list1, list2, f, type   , Begin1, Begin2, Count)
	)
	[Begin1+result, Begin2+result]
;
//
function mismatch_count_intern_direct (list1, list2, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(list1[begin1+i] != list2[begin2+i]) ? i :
	mismatch_count_intern_direct (list1, list2, begin1, begin2, count, i+1)
;
function mismatch_count_intern_list (list1, list2, position=0, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(list1[begin1+i][position] != list2[begin2+i][position]) ? i :
	mismatch_count_intern_list (list1, list2, position, begin1, begin2, count, i+1)
;
function mismatch_count_intern_function (list1, list2, fn, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(fn(list1[begin1+i]) != fn(list2[begin2+i])) ? i :
	mismatch_count_intern_function (list1, list2, fn, begin1, begin2, count, i+1)
;
function mismatch_count_intern_type (list1, list2, type, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	(value(list1[begin1+i],type) != value(list2[begin2+i],type)) ? i :
	mismatch_count_intern_type (list1, list2, type, begin1, begin2, count, i+1)
;
//
function mismatch_count_intern_f_direct (list1, list2, f, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (list1[begin1+i], list2[begin2+i]) ? i :
	mismatch_count_intern_f_direct (list1, list2, f, begin1, begin2, count, i+1)
;
function mismatch_count_intern_f_list (list1, list2, f, position=0, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (list1[begin1+i][position], list2[begin2+i][position]) ? i :
	mismatch_count_intern_f_list (list1, list2, f, position, begin1, begin2, count, i+1)
;
function mismatch_count_intern_f_function (list1, list2, f, fn, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (fn(list1[begin1+i]), fn(list2[begin2+i])) ? i :
	mismatch_count_intern_f_function (list1, list2, f, fn, begin1, begin2, count, i+1)
;
function mismatch_count_intern_f_type (list1, list2, f, type, begin1=0, begin2=0, count=0, i=0) =
	i>=count ? i :
	!f (value(list1[begin1+i],type), value(list2[begin2+i],type)) ? i :
	mismatch_count_intern_f_type (list1, list2, f, type, begin1, begin2, count, i+1)
;

// Testet 2 Listen nach Gleichheit und gibt alle Treffer, die nicht gleich sind als Liste aus.
// Die Werte in der Rückgabeliste enthält die Positionen der Treffer beider Listen als Liste [pos list1, pos list2].
// Vergleicht die Daten direkt mit dem Operator == oder mit Funktion 'f', wenn angegeben
function mismatch_list (list1, list2, begin1=0, begin2=0, count=undef, type=0, f=undef) =
	let (
		Range1 = parameter_range_safe (list1, begin1, undef, count, undef),
		Range2 = parameter_range_safe (list2, begin2, undef, count, undef),
		Begin1 = Range1[0],
		Begin2 = Range2[0],
		Count1 = Range1[1] - Range1[0] + 1,
		Count2 = Range2[1] - Range2[0] + 1,
		Count     = min (Count1, Count2),
		Count_max = max (Count1, Count2)
	)
	[ each
	f==undef ?
		 type   == 0                   ? [for(i=[0:1:Count-1]) if (list1[Begin1+i]             != list2[Begin2+i]            ) [Begin1+i, Begin2+i] ]
		:type[0]>= 0                   ? [for(i=[0:1:Count-1]) if (list1[Begin1+i][type[0]]    != list2[Begin2+i][type[0]]   ) [Begin1+i, Begin2+i] ]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[0:1:Count-1]) if (fn(list1[Begin1+i])         != fn(list2[Begin2+i])        ) [Begin1+i, Begin2+i] ]
		:                                [for(i=[0:1:Count-1]) if (value(list1[Begin1+i],type) != value(list1[Begin1+i],type)) [Begin1+i, Begin2+i] ]
	:
		 type   == 0                   ? [for(i=[0:1:Count-1]) if (f( list1[Begin1+i]            , list2[Begin2+i]            ) !=true) [Begin1+i, Begin2+i] ]
		:type[0]>= 0                   ? [for(i=[0:1:Count-1]) if (f( list1[Begin1+i][type[0]]   , list2[Begin2+i][type[0]]   ) !=true) [Begin1+i, Begin2+i] ]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[0:1:Count-1]) if (f( fn(list1[Begin1+i])        , fn(list2[Begin2+i])        ) !=true) [Begin1+i, Begin2+i] ]
		:                                [for(i=[0:1:Count-1]) if (f( value(list1[Begin1+i],type), value(list1[Begin1+i],type)) !=true) [Begin1+i, Begin2+i] ]
	, each Count==Count_max ? [] : [for(i=[Count:1:Count_max-1]) [Begin1+i, Begin2+i] ]
	]
;

// Findet 2 benachbarte gleiche Werte in der Liste
// und gibt die Position des ersten Wertes aus.
// Vergleicht die Daten direkt mit dem Operator == oder mit Funktion 'f', wenn angegeben
function adjacent_find (list, type=0, begin, last, count, range, f=undef) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	f==undef ?
		 type   == 0 ? adjacent_find_intern_direct   (list,          Range[0], Range[1])
		:type[0]>= 0 ? adjacent_find_intern_list     (list, type[0], Range[0], Range[1])
		:type[0]==-1 ? adjacent_find_intern_function (list, type[1], Range[0], Range[1])
		:              adjacent_find_intern_type     (list, type   , Range[0], Range[1])
	:
		 type   == 0 ? adjacent_find_intern_f_direct   (list, f,          Range[0], Range[1])
		:type[0]>= 0 ? adjacent_find_intern_f_list     (list, f, type[0], Range[0], Range[1])
		:type[0]==-1 ? adjacent_find_intern_f_function (list, f, type[1], Range[0], Range[1])
		:              adjacent_find_intern_f_type     (list, f, type   , Range[0], Range[1])
;
//
function adjacent_find_intern_direct (list, begin=0, last=-1) =
	begin>=last ? last+1 :
	(list[begin] == list[begin+1]) ? begin :
	adjacent_find_intern_direct (list, begin+1, last)
;
function adjacent_find_intern_list (list, position=0, begin=0, last=-1) =
	begin>=last ? last+1 :
	(list[begin][position] == list[begin+1][position]) ? begin :
	adjacent_find_intern_list (list, position, begin+1, last)
;
function adjacent_find_intern_function (list, fn, begin=0, last=-1) =
	begin>=last ? last+1 :
	adjacent_find_intern_function_loop (list, fn, begin, last, fn(list[begin]), fn(list[begin+1]))
;
function adjacent_find_intern_function_loop (list, fn, begin=0, last=-1, this, next) =
	(this == next) ? begin :
	begin+1>=last ? last+1 :
	adjacent_find_intern_function_loop (list, fn, begin+1, last, next, fn(list[begin+2]))
;
function adjacent_find_intern_type (list, type, begin=0, last=-1) =
	begin>=last ? last+1 :
	adjacent_find_intern_type_loop (list, type, begin, last, value(list[begin],type), value(list[begin+1],type))
;
function adjacent_find_intern_type_loop (list, type, begin=0, last=-1, this, next) =
	(this == next) ? begin :
	begin+1>=last ? last+1 :
	adjacent_find_intern_type_loop (list, type, begin+1, last, next, value(list[begin+2],type))
;
//
function adjacent_find_intern_f_direct (list, f, begin=0, last=-1) =
	begin>=last ? last+1 :
	f (list[begin], list[begin+1]) ? begin :
	adjacent_find_intern_f_direct (list, f, begin+1, last)
;
function adjacent_find_intern_f_list (list, f, position=0, begin=0, last=-1) =
	begin>=last ? last+1 :
	f (list[begin][position], list[begin+1][position]) ? begin :
	adjacent_find_intern_f_list (list, f, position, begin+1, last)
;
function adjacent_find_intern_f_function (list, f, fn, begin=0, last=-1) =
	begin>=last ? last+1 :
	adjacent_find_intern_f_function_loop (list, f, fn, begin, last, fn(list[begin]), fn(list[begin+1]))
;
function adjacent_find_intern_f_function_loop (list, f, fn, begin=0, last=-1, this, next) =
	f (this, next) ? begin :
	begin+1>=last ? last+1 :
	adjacent_find_intern_f_function_loop (list, f, fn, begin+1, last, next, fn(list[begin+2]))
;
function adjacent_find_intern_f_type (list, f, type, begin=0, last=-1) =
	begin>=last ? last+1 :
	adjacent_find_intern_f_type_loop (list, f, type, begin, last, value(list[begin],type), value(list[begin+1],type))
;
function adjacent_find_intern_f_type_loop (list, f, type, begin=0, last=-1, this, next) =
	f (this, next) ? begin :
	begin+1>=last ? last+1 :
	adjacent_find_intern_f_type_loop (list, f, type, begin+1, last, next, value(list[begin+2],type))
;

// sucht einen Wert in einer aufsteigend sortierten Liste und gibt die Position zurück.
// Gibt einen negativen Wert zurück, wenn nichts gefunden wurde. Der Betrag des Wertes
// ist die letzte Position, wo gesucht wurde.
function binary_search (list, value, type=0, f=undef) =
	list==undef || len(list)<=1 ? 0 :
	f==undef ?
		binary_search_intern   (list, value, type, 0, len(list)-1)
	:
		binary_search_intern_f (list, value, type, f, 0, len(list)-1)
;
function binary_search_intern (list, value, type, begin, end) =
	(end<begin)        ? -begin
	:let(
		middle=floor((begin+end)/2),
		v=
			 type   == 0 ?                   list[middle]
			:type[0]>= 0 ?                   list[middle][type[0]]
			:type[0]==-1 ? let( fn=type[1] ) fn(list[middle])
			:                                value(list[middle],type)
	)
	 (v==value) ? middle
	:(v< value) ? binary_search_intern (list, value, type, middle+1, end)
	:             binary_search_intern (list, value, type, begin   , middle-1)
;
function binary_search_intern_f (list, value, type, f, begin, end) =
	(end<begin)        ? -begin
	:let(
		middle=floor((begin+end)/2),
		v=
			 type   == 0 ?                   list[middle]
			:type[0]>= 0 ?                   list[middle][type[0]]
			:type[0]==-1 ? let( fn=type[1] ) fn(list[middle])
			:                                value(list[middle],type)
	)
	 (f(v,value)==0) ? middle
	:(f(v,value)< 0) ? binary_search_intern_f (list, value, type, f, middle+1, end)
	:                  binary_search_intern_f (list, value, type, f, begin   , middle-1)
;

// Testet eine Liste ob diese sortiert ist und gibt die erste Position zurück, die nicht sortiert ist.
// Vergleicht die Daten mit dem Operator '<' oder mit Funktion 'f', wenn angegeben
function sorted_until (list, f=undef, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	f==undef ?
		 type   == 0 ? sorted_until_intern_direct   (list,          Range[0], Range[1])
		:type[0]>= 0 ? sorted_until_intern_list     (list, type[0], Range[0], Range[1])
		:type[0]==-1 ? sorted_until_intern_function (list, type[1], Range[0], Range[1])
		:              sorted_until_intern_type     (list, type   , Range[0], Range[1])
	:
		 type   == 0 ? sorted_until_intern_f_direct   (list, f,          Range[0], Range[1])
		:type[0]>= 0 ? sorted_until_intern_f_list     (list, f, type[0], Range[0], Range[1])
		:type[0]==-1 ? sorted_until_intern_f_function (list, f, type[1], Range[0], Range[1])
		:              sorted_until_intern_f_type     (list, f, type   , Range[0], Range[1])
;
//
function sorted_until_intern_direct (list, begin=0, last=-1) =
	begin>=last ? begin+1:
	(list[begin+1] < list[begin]) ? begin+1 :
	sorted_until_intern_direct (list, begin+1, last)
;
function sorted_until_intern_list (list, position=0, begin=0, last=-1) =
	begin>=last ? begin+1:
	(list[begin+1][position] < list[begin][position]) ? begin+1 :
	sorted_until_intern_list (list, position, begin+1, last)
;
function sorted_until_intern_function (list, fn, begin=0, last=-1) =
	begin>=last ? begin+1:
	sorted_until_intern_function_loop (list, fn, begin, last, fn(list[begin]), fn(list[begin+1]))
;
function sorted_until_intern_function_loop (list, fn, begin=0, last=-1, this, next) =
	(next < this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	sorted_until_intern_function_loop (list, fn, begin+1, last, next, fn(list[begin+2]))
;
function sorted_until_intern_type (list, type, begin=0, last=-1) =
	begin>=last ? begin+1:
	sorted_until_intern_type_loop (list, type, begin, last, value(list[begin],type), value(list[begin+1],type))
;
function sorted_until_intern_type_loop (list, type, begin=0, last=-1, this, next) =
	(next < this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	sorted_until_intern_type_loop (list, type, begin+1, last, next, value(list[begin+2],type))
;
//
function sorted_until_intern_f_direct (list, f, begin=0, last=-1) =
	begin>=last ? begin+1:
	f (list[begin+1], list[begin]) ? begin+1 :
	sorted_until_intern_f_direct (list, begin+1, last)
;
function sorted_until_intern_f_list (list, f, position=0, begin=0, last=-1) =
	begin>=last ? begin+1:
	f (list[begin+1][position], list[begin][position]) ? begin+1 :
	sorted_until_intern_f_list (list, position, begin+1, last)
;
function sorted_until_intern_f_function (list, f, fn, begin=0, last=-1) =
	begin>=last ? begin+1:
	sorted_until_intern_f_function_loop (list, f, fn, begin, last, fn(list[begin]), fn(list[begin+1]))
;
function sorted_until_intern_f_function_loop (list, f, fn, begin=0, last=-1, this, next) =
	f (next, this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	sorted_until_intern_f_function_loop (list, f, fn, begin+1, last, next, fn(list[begin+2]))
;
function sorted_until_intern_f_type (list, f, type, begin=0, last=-1) =
	begin>=last ? begin+1:
	sorted_until_intern_f_type_loop (list, f, type, begin, last, value(list[begin],type), value(list[begin+1],type))
;
function sorted_until_intern_f_type_loop (list, f, type, begin=0, last=-1, this, next) =
	f (next, this) ? begin+1 :
	(begin+1)>=last ? begin+2 :
	sorted_until_intern_f_type_loop (list, f, type, begin+1, last, next, value(list[begin+2],type))
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
		 type   == 0                   ? [for(i=[begin:1:last-1]) if (list[i+1]             < list[i]            ) i+1]
		:type[0]>= 0                   ? [for(i=[begin:1:last-1]) if (list[i+1][type[0]]    < list[i][type[0]]   ) i+1]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last-1]) if (fn(list[i+1])         < fn(list[i])        ) i+1]
		:                                [for(i=[begin:1:last-1]) if (value(list[i+1],type) < value(list[i],type)) i+1]
		//	[ each [for(i=begin,this=value(list[i],type),next=value(list[i+1],type); i<=last-2;
		//	            i=i+1  ,this=next               ,next=value(list[i+1],type))
		//		 if (next < this) i+1]
		//	, each (fn(list[last]) < fn(list[last-1])) ? [last] : [] ]
	:
		 type   == 0                   ? [for(i=[begin:1:last-1]) if (f( list[i+1]            , list[i]            )) i+1]
		:type[0]>= 0                   ? [for(i=[begin:1:last-1]) if (f( list[i+1][type[0]]   , list[i][type[0]]   )) i+1]
		:type[0]==-1 ? let( fn=type[1] ) [for(i=[begin:1:last-1]) if (f( fn(list[i+1])        , fn(list[i])        )) i+1]
		:                                [for(i=[begin:1:last-1]) if (f( value(list[i+1],type), value(list[i],type))) i+1]
;

// Lexikographischer kleiner-als Vergleich zweier Listen
function lexicographical_compare (list1, list2, f, type=0) =
	f==undef ?
		type==0 ? list1<list2
		:         value_list(list1,type)<value_list(list2,type)
	:
		type==0 ? lexicographical_compare_intern (list1                 , list2                 , f, 0, len(list1)-1, 0, len(list2)-1)
		:         lexicographical_compare_intern (value_list(list1,type), value_list(list2,type), f, 0, len(list1)-1, 0, len(list2)-1)
;
function lexicographical_compare_intern (list1, list2, f, begin1=0, last1=-1, begin2=0, last2=-1) =
	begin1>last1 ? begin2<=last2 :
	begin2>last2 ? false :
	let (
		value1 = list1[begin1],
		value2 = list2[begin2]
	)
	f (value2,value1) ? false :
	f (value1,value2) ? true :
	lexicographical_compare_intern (list1, list2, f, begin1+1, last1, begin2+1, last2)
;
