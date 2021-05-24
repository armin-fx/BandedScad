// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Strings mit Zugriff auf den Inhalt
//

use <banded/string_convert.scad>
use <banded/list_edit_data.scad>

// sucht nach einem Buchstaben und gibt die Position des Treffers aus dem String heraus
function find_first_str (txt, value, index=0) =
	find_first_list (txt, value, index)
;
// sucht nach dem ersten Auftreten eines Buchstaben und gibt die Position des Treffers aus dem String heraus
function find_first_once_str (txt, value) =
	find_first_once_list (txt, value)
;

// sucht nach einem Buchstaben und gibt die Position des Treffers aus dem String heraus
// Der String wird vom Ende aus rückwärts durchsucht
function find_last_str (txt, value, index=0) =
	find_last_list (txt, value, index)
;
// sucht nach dem ersten Auftreten eines Buchstaben und gibt die Position des Treffers aus dem String heraus
// Der String wird vom Ende aus rückwärts durchsucht
function find_last_once_str (txt, value) =
	find_last_once_list (txt, value)
;

// Zählt das Vorkommen eines Buchstaben im String
function count_str (txt, value, begin, last, count, range) =
	txt==undef ? 0 :
	let ( Range = parameter_range_safe (txt, begin, last, count, range) )
	(Range[0]==0 && Range[1]==len(txt)-1 && len(value)==1) ?
		len( search(value,txt,0)[0] )
	:	count_list_intern (txt, value, 0, Range[0], Range[1])
;

// Entfernt alle Duplikate der Buchstaben aus dem String
function remove_duplicate_str (txt) =
	list_to_str ( remove_duplicate_list (txt) )
;

// Entfernt alle Vorkommen eines Buchstaben
function remove_value_str (txt, letter) =
	 list_to_str ( remove_value_list (txt, letter) )
;

// Entfernt alle Vorkommen von Buchstaben aus einer Liste von Buchstaben
function remove_values_str (txt, letter_list) =
	 list_to_str ( remove_values_list (txt, letter_list) )
;

// Ersetzt alle Vorkommen eines Buchstaben durch einen anderen String
function replace_value_str (txt, letter, new) =
	 list_to_str ( replace_value_list (txt, letter, new) )
;

// Ersetzt alle Vorkommen von Buchstaben aus einer Liste durch einen anderen String
function replace_values_str (txt, letter_list, new) =
	 list_to_str ( replace_values_list (txt, letter_list, new) )
;
