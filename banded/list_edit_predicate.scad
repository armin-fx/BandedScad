// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Listen mit Zugriff auf den Inhalt
// Der Inhalt wird mit einer übergebenen Funktion bearbeitet

use <banded/helper.scad>

use <banded/list_edit_type.scad>

// Führt Funktion 'f' auf jedes Element in der Liste aus.
// Gibt die Liste mit den Ergebnissen zurück.
function for_each_list (list, f, type=0, begin, last, count, range) =
	list==undef || len(list)==0 ? list :
	let (Range = parameter_range_safe (list, begin, last, count, range))
	//
	for_each_list_intern (list, f, type, Range[0], Range[1])
;
function for_each_list_intern (list, f, type=0, begin=0, last=-1) =
	 type   == 0 ?                   [ for (i=[begin:1:last]) f( list[i]                 ) ]
	:type[0]>= 0 ?                   [ for (i=[begin:1:last]) f( list[i][type[0]]        ) ]
	:type[0]==-1 ? let( fn=type[1] ) [ for (i=[begin:1:last]) f( fn(list[i])             ) ]
	:                                [ for (i=[begin:1:last]) f( get_value(list[i],type) ) ]
;

