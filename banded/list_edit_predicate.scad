// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen mit Zugriff auf den Inhalt
// Der Inhalt wird mit einer übergebenen Funktion bearbeitet

use <banded/helper.scad>

use <banded/list_edit_type.scad>


// - Daten in Listen bearbeiten:

// Führt Funktion 'f' auf die Elemente in der Liste aus und entfernt alle Elemente
// bei der diese 'true' zurück gibt
function remove_if (list, f, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0                   ? [ for (e=list) if (f( e                 )!=true) e ]
	:type[0]>= 0                   ? [ for (e=list) if (f( e[type[0]]        )!=true) e ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (f( fn(e)             )!=true) e ]
	:                                [ for (e=list) if (f( get_value(e,type) )!=true) e ]
;

// Führt Funktion 'f' auf die Elemente in der Liste aus und
// ersetzt alle Einträge bei der diese 'true' zurück gibt durch einen anderen Wert
function replace_if (list, f, new, type=0) =
	list==undef || len(list)==0 ? list :
	 type   == 0 ?                   [ for (e=list) if (f( e                 )!=true) e else new ]
	:type[0]>= 0 ?                   [ for (e=list) if (f( e[type[0]]        )!=true) e else new ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (e=list) if (f( fn(e)             )!=true) e else new ]
	:                                [ for (e=list) if (f( get_value(e,type) )!=true) e else new ]
;

// Teilt eine Liste in 2 Teile auf
// gibt 2 Listen zurück
// [ [Elemente mif f()==true], [Elemente mif f()==false] ]
function partition (list, f, type=0, begin, last, count, range) =
	let(
		Range = parameter_range_safe (list, begin, last, count, range),
		choice_list =
			 type   == 0                   ? [for (i=[Range[0]:1:Range[1]]) f( list[i]                ) ]
			:type[0]>= 0                   ? [for (i=[Range[0]:1:Range[1]]) f( list[i][type[0]]       ) ]
			:type[0]==-1 ? let( fn=type[1] ) [for (i=[Range[0]:1:Range[1]]) f( fn(list[i])            ) ]
			:                                [for (i=[Range[0]:1:Range[1]]) f( get_value(list[i],type)) ]
	)
	[ [for (i=[Range[0]:1:Range[1]]) if (  choice_list[i-Range[0]]) list[i] ]
	, [for (i=[Range[0]:1:Range[1]]) if (! choice_list[i-Range[0]]) list[i] ] ]
;


// - Daten aus Listen ermitteln:

// Führt Funktion 'f' auf jedes Element in der Liste aus.
// Gibt die Liste mit den Ergebnissen zurück.
function for_each (list, f, type=0, begin, last, count, range) =
	list==undef || len(list)==0 ? list :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	//
	for_each_intern (list, f, type, Range[0], Range[1])
;
function for_each_intern (list, f, type=0, begin=0, last=-1) =
	 type   == 0 ?                   [ for (i=[begin:1:last]) f( list[i]                 ) ]
	:type[0]>= 0 ?                   [ for (i=[begin:1:last]) f( list[i][type[0]]        ) ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (i=[begin:1:last]) f( fn(list[i])             ) ]
	:                                [ for (i=[begin:1:last]) f( get_value(list[i],type) ) ]
;

// Führt Funktion 'f' auf die Elemente in der Liste aus und zählt Rückgaben von 'true'
// Argumente:
//   list    -Liste
//   f       -Funktionsliteral zum Testen des Wertes
// Optionale Angabe des Bereichs:
//     begin = erstes Element aus der Liste
//     last  = letztes Element
// oder
//     range = [begin, last]
// Kodierung wie in python
function count_if        (list, f, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	count_if_intern      (list, f, type, Range[0], Range[1])
;
// Zähle alles durch von Position n nach k
function count_if_intern (list, f, type=0, n=0, k=-1) =
	n>k ? 0 :
	 type   == 0                   ? len([for(i=[n:1:k]) if (f( list[i]                 )==true) 0])
	:type[0]>= 0                   ? len([for(i=[n:1:k]) if (f( list[i][type[0]]        )==true) 0])
	:type[0]==-1 ? let( fn=type[1] ) len([for(i=[n:1:k]) if (f( fn(list[i])             )==true) 0])
	:                                len([for(i=[n:1:k]) if (f( get_value(list[i],type) )==true) 0])
;

// Führt Funktion 'f' auf die Elemente in der Liste aus und gibt die Position zurück wo diese 'true' zurück gibt
// Die Liste wird vom Anfang aus durchsucht
// Wurde das Element nicht gefunden, wird die Position nach dem letzten Element zurückgegeben
// Argumente:
//   list    -Liste
//   f       -Funktionsliteral mit einem Argument für den zu testenden Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function find_first_if (list, f, index=0, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	index==0 ? find_first_once_if_intern (list, f, type, Range[0], Range[1]) :
	//
	 type   == 0 ? find_first_if_intern_direct   (list, f, index         , Range[0], Range[1])
	:type[0]>= 0 ? find_first_if_intern_list     (list, f, index, type[0], Range[0], Range[1])
	:type[0]==-1 ? find_first_if_intern_function (list, f, index, type[1], Range[0], Range[1])
	:              find_first_if_intern_type     (list, f, index, type   , Range[0], Range[1])
;
function find_first_if_intern_direct (list, f, index=0, n=0, last=-1) =
	(n>last) ? n :
	(f( list[n] )==true) ?
		(index==0) ? n
		:	find_first_if_intern_direct (list, f, index-1, n+1, last)
	:		find_first_if_intern_direct (list, f, index,   n+1, last)
;
function find_first_if_intern_list (list, f, index=0, position=0, n=0, last=-1) =
	(n>last) ? n :
	(f( list[n][position] )==true) ?
		(index==0) ? n
		:	find_first_if_intern_list (list, f, index-1, position, n+1, last)
	:		find_first_if_intern_list (list, f, index,   position, n+1, last)
;
function find_first_if_intern_function (list, f, index=0, fn, n=0, last=-1) =
	(n>last) ? n :
	(f( fn(list[n]) )==true) ?
		(index==0) ? n
		:	find_first_if_intern_function (list, f, index-1, fn, n+1, last)
	:		find_first_if_intern_function (list, f, index,   fn, n+1, last)
;
function find_first_if_intern_type (list, f, index=0, type, n=0, last=-1) =
	(n>last) ? n :
	(f( get_value(list[n],type) )==true) ?
		(index==0) ? n
		:	find_first_if_intern_type (list, f, index-1, type, n+1, last)
	:		find_first_if_intern_type (list, f, index,   type, n+1, last)
;
//
// sucht nach der ersten Rückgabe 'true' von Funktion f() und gibt die Position des Treffers aus einer Liste zurück
function find_first_once_if (list, f, type=0, begin, last, count, range) =
	list==undef ? 0 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_first_once_if_intern (list, f, type, Range[0], Range[1])
;
function find_first_once_if_intern (list, f, type=0, n=0, last=-1) =
	 type   == 0 ? find_first_once_if_intern_direct   (list, f         , n, last)
	:type[0]>= 0 ? find_first_once_if_intern_list     (list, f, type[0], n, last)
	:type[0]==-1 ? find_first_once_if_intern_function (list, f, type[1], n, last)
	:              find_first_once_if_intern_type     (list, f, type   , n, last)
;
function find_first_once_if_intern_direct   (list, f, n=0, last=-1) =
	(n>last) || (f( list[n]                 )==true) ? n :
	find_first_once_if_intern_direct        (list, f, n+1, last)
;
function find_first_once_if_intern_list     (list, f, position, n=0, last=-1) =
	(n>last) || (f( list[n][position]       )==true) ? n :
	find_first_once_if_intern_list          (list, f, position, n+1, last)
;
function find_first_once_if_intern_function (list, f, fn, n=0, last=-1) =
	(n>last) || (f( fn(list[n])             )==true) ? n :
	find_first_once_if_intern_function      (list, f, fn, n+1, last)
;
function find_first_once_if_intern_type     (list, f, type, n=0, last=-1) =
	(n>last) || (f( get_value(list[n],type) )==true) ? n :
	find_first_once_if_intern_type          (list, f, type, n+1, last)
;

// Führt Funktion 'f' auf die Elemente in der Liste aus und gibt die Position zurück wo diese 'true' zurück gibt
// Die Liste wird vom Ende aus rückwärts durchsucht
// Wurde der Wert nicht gefunden, wird die Position vor dem ersten Element zurückgegeben
// Argumente:
//   list    -Liste
//   f       -Funktionsliteral mit einem Argument für den zu testenden Wert
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste vom Ende aus gefundene Schlüssel genommen (index=0)
function find_last_if (list, f, index=0, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	index==0 ? find_last_once_if_intern (list, f, type, Range[1], Range[0]) :
	//
	 type   == 0 ? find_last_if_intern_direct   (list, f, index         , Range[1], Range[0])
	:type[0]>= 0 ? find_last_if_intern_list     (list, f, index, type[0], Range[1], Range[0])
	:type[0]==-1 ? find_last_if_intern_function (list, f, index, type[1], Range[1], Range[0])
	:              find_last_if_intern_type     (list, f, index, type   , Range[1], Range[0])
;
function find_last_if_intern_direct (list, f, index=0, n=-2, first=0) =
	(n<first) ? n
	:(f( list[n] )==true) ?
		(index==0) ? n
		:	find_last_if_intern_direct (list, f, index-1, n-1, first)
	:		find_last_if_intern_direct (list, f, index,   n-1, first)
;
function find_last_if_intern_list (list, f, index=0, position=0, n=-2, first=0) =
	(n<first) ? n
	:(f( list[n][position] )==true) ?
		(index==0) ? n
		:	find_last_if_intern_list (list, f, index-1, position, n-1, first)
	:		find_last_if_intern_list (list, f, index,   position, n-1, first)
;
function find_last_if_intern_function (list, f, index=0, fn, n=-2, first=0) =
	(n<first) ? n
	:(f( fn(list[n]) )==true) ?
		(index==0) ? n
		:	find_last_if_intern_function (list, f, index-1, fn, n-1, first)
	:		find_last_if_intern_function (list, f, index,   fn, n-1, first)
;
function find_last_if_intern_type (list, f, index=0, type, n=-2, first=0) =
	(n<first) ? n
	:(f( get_value(list[n],type) )==true) ?
		(index==0) ? n
		:	find_last_if_intern_type (list, f, index-1, type, n-1, first)
	:		find_last_if_intern_type (list, f, index,   type, n-1, first)
;
//
// sucht rückwärts nach der ersten Rückgabe 'true' von Funktion f() und gibt die Position des Treffers aus einer Liste zurück
function find_last_once_if (list, f, type=0, begin, last, count, range) =
	list==undef ? -1 :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	find_last_once_if_intern (list, f, type, Range[1], Range[0])
;
function find_last_once_if_intern (list, f, type=0, n=-1, first=0) =
	 type   == 0 ? find_last_once_if_intern_direct   (list, f         , n, first)
	:type[0]>= 0 ? find_last_once_if_intern_list     (list, f, type[0], n, first)
	:type[0]==-1 ? find_last_once_if_intern_function (list, f, type[1], n, first)
	:              find_last_once_if_intern_type     (list, f, type   , n, first)
;
function find_last_once_if_intern_direct   (list, f, n=-2, first=0) =
	(n<first) || (f( list[n] )                ==true) ? n :
	find_last_once_if_intern_direct        (list, f, n-1, first)
;
function find_last_once_if_intern_list     (list, f, position, n=-2, first=0) =
	(n<first) || (f( list[n][position] )      ==true) ? n :
	find_last_once_if_intern_list          (list, f, position, n-1, first)
;
function find_last_once_if_intern_function (list, f, fn, n=-2, first=0) =
	(n<first) || (f( fn(list[n]) )            ==true) ? n :
	find_last_once_if_intern_function      (list, f, fn, n-1, first)
;
function find_last_once_if_intern_type     (list, f, type, n=-2, first=0) =
	(n<first) || (f( get_value(list[n],type) )==true) ? n :
	find_last_once_if_intern_type          (list, f, type, n-1, first)
;

