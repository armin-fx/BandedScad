// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Strings ohne Zugriff auf den Inhalt
//

use <banded/string_convert.scad>
use <banded/list_edit_item.scad>

// kehrt die Reihenfolge der Buchstaben eines Strings um
function reverse_str (txt) =
	let( list    = str_to_list (txt)
		,convert = reverse_list (list)
	)
	list_to_str (convert)
;

// entfernt Buchstaben aus einem String
function erase_str (txt, begin, count=1) =
	let(
		 list    = str_to_list (txt)
		,convert = erase_list (list, begin, count)
	)
	list_to_str (convert)
;

// fügt einen anderen String in den String ein
function insert_str (txt, txt_insert, position=-1, begin_insert=0, count_insert=-1) =
	let(
		 list        = str_to_list (txt)
		,list_insert = str_to_list (txt_insert)
		,convert = insert_list (list, list_insert, position, begin_insert, count_insert)
	)
	list_to_str (convert)
;

// ersetzt Buchstaben in einem String durch einen anderen String
function replace_str (txt, txt_insert, begin=-1, count=0, begin_insert=0, count_insert=-1) =
	let(
		 list        = str_to_list (txt)
		,list_insert = str_to_list (txt_insert)
		,convert = replace_list (list, list_insert, begin, count, begin_insert, count_insert)
	)
	list_to_str (convert)
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
function extract_str (txt, begin, last, count, range) =
	let(
		 list    = str_to_list (txt)
		,convert = extract_list (list, begin, last, count, range)
	)
	list_to_str (convert)
;

// Erzeugt einen String mit 'count' Elementen gefüllt mit 'value'
function fill_str (count, value) =
	(!is_num(count) || count<1) ? "" :
	list_to_str ([ for (i=[0:count-1]) value ])
;

/*
function _str (txt, args) =
	let(
		 list    = str_to_list (txt)
		,convert = _list (list, args)
	)
	list_to_str (convert)
;
*/
