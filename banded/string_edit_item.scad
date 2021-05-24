// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Strings ohne Zugriff auf den Inhalt
//

use <banded/string_convert.scad>
use <banded/list_edit_item.scad>

// kehrt die Reihenfolge der Buchstaben eines Strings um
function reverse_str (txt) =
	list_to_str ( reverse_list (txt) )
;

// entfernt Buchstaben aus einem String
function erase_str (txt, begin, count=1) =
	list_to_str ( erase_list (txt, begin, count) )
;

// fügt einen anderen String in den String ein
function insert_str (txt, txt_insert, position=-1, begin_insert=0, count_insert=-1) =
	list_to_str ( insert_list (txt, txt_insert, position, begin_insert, count_insert) )
;

// ersetzt Buchstaben in einem String durch einen anderen String
function replace_str (txt, txt_insert, begin=-1, count=0, begin_insert=0, count_insert=-1) =
	list_to_str ( replace_list (txt, txt_insert, begin, count, begin_insert, count_insert) )
;

// extrahiert eine Sequenz aus dem String
function extract_str (txt, begin, last, count, range) =
	list_to_str ( extract_list (txt, begin, last, count, range) )
;

// Erzeugt einen String mit 'count' Elementen gefüllt mit 'value'
function fill_str (count, value) =
	(!is_num(count) || count<1) ? "" :
	list_to_str ([ for (i=[0:count-1]) value ])
;

