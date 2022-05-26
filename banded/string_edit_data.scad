// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten von Strings mit Zugriff auf den Inhalt
//

use <banded/string_convert.scad>
use <banded/list_edit_data.scad>

// sucht nach einem Buchstaben und gibt die Position des Treffers aus dem String heraus
function find_first_str (txt, letter, index=0) =
	find_first (txt, letter, index)
;
// sucht nach dem ersten Auftreten eines Buchstaben und gibt die Position des Treffers aus dem String heraus
function find_first_once_str (txt, letter) =
	find_first_once (txt, letter)
;

// sucht nach einem Buchstaben und gibt die Position des Treffers aus dem String heraus
// Der String wird vom Ende aus rückwärts durchsucht
function find_last_str (txt, letter, index=0) =
	find_last (txt, letter, index)
;
// sucht nach dem ersten Auftreten eines Buchstaben und gibt die Position des Treffers aus dem String heraus
// Der String wird vom Ende aus rückwärts durchsucht
function find_last_once_str (txt, letter) =
	find_last_once (txt, letter)
;

// Zählt das Vorkommen eines Buchstaben im String
function count_str (txt, letter, begin, last, count, range) =
	txt==undef ? 0 :
	let ( Range = parameter_range_safe (txt, begin, last, count, range) )
	(Range[0]==0 && Range[1]==len(txt)-1 && len(letter)==1) ?
		len( search(letter,txt,0)[0] )
	:	count_intern (txt, letter, 0, Range[0], Range[1])
;

// Entfernt alle Duplikate der Buchstaben aus dem String
function remove_duplicate_str (txt) =
	list_to_str ( remove_duplicate (txt) )
;

// Entfernt alle Vorkommen eines Buchstaben
function remove_value_str (txt, letter) =
	 list_to_str ( remove_value (txt, letter) )
;

// Entfernt alle Vorkommen von Buchstaben aus einer Liste von Buchstaben
function remove_all_values_str (txt, letter_list) =
	 list_to_str ( remove_all_values (txt, letter_list) )
;

// Ersetzt alle Vorkommen eines Buchstaben durch einen anderen String
function replace_value_str (txt, letter, new) =
	 list_to_str ( replace_value (txt, letter, new) )
;

// Ersetzt alle Vorkommen von Buchstaben aus einer Liste durch einen anderen String
function replace_all_values_str (txt, letter_list, new) =
	 list_to_str ( replace_all_values (txt, letter_list, new) )
;
