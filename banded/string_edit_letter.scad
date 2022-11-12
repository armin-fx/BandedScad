// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten einzelner Zeichen in Strings.
// Übernommen von 'list_edit.scad', geben einen String zurück.
//
//
// Ermitteln von Daten von Strings:
// Hier können die Listenfunktionen direkt benutzt werden,
// da nur die Positionen auf den Buchstaben zurückgegeben werden oder anderes,
// aber kein String.
// Angabe 'type=0' der Standartwert, direkter Zugriff.
//
// Liste der Funktionen ohne String äquivalent:
// - min_value (list)
// - max_value (list)
// - min_entry (list)
// - max_entry (list)
// - min_position (list)
// - max_position (list)
// - count (list, value, type=0, begin, last, count, range)
// - find_first      (list, value, index, type=0, begin, last, count, range)
// - find_first_once (list, value,        type=0, begin, last, count, range)
// - find_last       (list, value, index, type=0, begin, last, count, range)
// - find_last_once  (list, value,        type=0, begin, last, count, range)
// - mismatch      (list1, list2, begin1, begin2, count, type=0, f)
// - mismatch_list (list1, list2, begin1, begin2, count, type=0, f)
// - adjacent_find (list, type=0, begin, last, count, range, f)
// - binary_search (list, value, type=0, f)
// - sorted_until      (list, f, type=0, begin, last, count, range)
// - sorted_until_list (list, f, type=0, begin, last, count, range)
// - lexicographical_compare (list1, list2, f, type=0)
// . . .
// - count_if           (list, f,        type=0, begin, last, count, range)
// - find_first_if      (list, f, index, type=0, begin, last, count, range)
// - find_first_once_if (list, f,        type=0, begin, last, count, range)
// - find_last_if       (list, f, index, type=0, begin, last, count, range)
// - find_last_once_if  (list, f,        type=0, begin, last, count, range)
// . . .
// - all_of  (list, f, type=0, begin, last, count, range)
// - none_of (list, f, type=0, begin, last, count, range)
// - any_of  (list, f, type=0, begin, last, count, range)
// - equal    (list1, list2, f, type=0, begin1, begin2, count)
// - includes (list1, list2, f, type=0, begin1, last1, count1, range1, begin2, last2, count2, range2)
// - is_sorted      (list, f, type=0, begin, last, count, range)
// - is_partitioned (list, f, type=0, begin, last, count, range)

use <banded/string_convert.scad>
use <banded/list_edit.scad>


// - Bearbeiten von Strings ohne Zugriff auf den Inhalt:

function concat_str (txt) = list_to_str (txt);

// kehrt die Reihenfolge der Buchstaben eines Strings um
function reverse_full_str (txt) =
	list_to_str ( reverse_full (txt) )
;
function reverse_str (txt, begin, last, count, range) =
	list_to_str ( reverse (txt, begin, last, count, range) )
;

function rotate_str (txt, middle, begin, last) =
	list_to_str ( rotate_list (list, middle, begin, last) )
;

function rotate_copy_str (list, middle, begin, last) =
	list_to_str ( rotate_copy (list, middle, begin, last) )
;

// entfernt Buchstaben aus einem String
function remove_str (txt, begin, count=1) =
	list_to_str ( remove (txt, begin, count) )
;

// fügt einen anderen String in den String ein
function insert_str (txt, txt_insert, position=-1, begin_insert=0, count_insert=-1) =
	list_to_str ( insert (txt, txt_insert, position, begin_insert, count_insert) )
;

// ersetzt Buchstaben in einem String durch einen anderen String
function replace_str (txt, txt_insert, begin=-1, count=0, begin_insert=0, count_insert=-1) =
	list_to_str ( replace (txt, txt_insert, begin, count, begin_insert, count_insert) )
;

// extrahiert eine Sequenz aus dem String
function extract_str (txt, begin, last, count, range) =
	list_to_str ( extract (txt, begin, last, count, range) )
;

// Erzeugt einen String mit 'count' Elementen gefüllt mit 'value'
function fill_str (count, value) =
	(!is_num(count) || count<1) ? "" :
	list_to_str ([ for (i=[0:count-1]) value ])
;

// gibt einen String zurück mit den Buchstaben vom String 'base' in den Positionen 'index'
// b.z.w. bestückt die Positionen in der Liste 'index' mit den entsprechenden Buchstaben von 'base'
//   base <-- index
function select_str (base, index) =
	list_to_str ([ for (i=index) base[i] ])
;

// bestückt alle Listen in 'indices' mit den entsprechenden Buchstaben von 'base'.
// Gibt eine Liste mit Strings zurück
//   [ base <-- index[0], base <-- index[1], base <-- index[2] ... ]
function select_all_str (base, indices) =
	[ for (index=indices)
		list_to_str ([ for (i=index) base[i] ])
	]
;

// gibt einen String zurück mit den Buchstaben von dem String 'base'
// von der Liste mit den Positionen 'link' von 'base'
// in den Positionen 'index' in 'link'
//   base <-- link <-- index
function select_link_str (base, link, index) =
	list_to_str ([ for (i=index) base[link[i]] ])
;

// löscht alle Positionen 'index' von einem String 'base'
function unselect_str (base, index) =
	list_to_str ( unselect (base, index) )
;

// gibt eine Liste mit den Positionen auf den Daten zurück
// in aufsteigender Reihenfolge
// gibt '[ Daten, [Index] ]' zurück
function index_str (txt) = index (txt);

// hängt alle Strings in einer Liste '[ Daten1, Daten2 ]' an einen String an
// und speichert Listen mit den Positionen darauf
// - 'list' - Liste mit Strings
// gibt '[ Daten, [Index1, Index2, ... ] ]' zurück
function index_all_str (list) =
	let ( res = index_all (list) )
	[ list_to_str (res[0]), res[1] ]
;

// entfernt alle Buchstaben, die nicht indiziert sind und schreibt alle Indizes neu
// gibt '[ Daten, [Index1, Index2, ... ] ]' zurück
function remove_unselected_str (txt, indices) =
	let ( res = remove_unselected (txt, indices) )
	[ list_to_str (res[0]), res[1] ]
;

// fasst alle mehrfach vorkommenden Datenelemente zusammen, schreibt alle Indizes neu
// gibt '[ Daten, [Index1, Index2, ... ] ]' zurück
function compress_selected_str (list, indices) =
	let ( res = compress_selected (list, indices) )
	[ list_to_str (res[0]), res[1] ]
;


// - Buchstaben im String bearbeiten:

// Buchstaben im String sortieren
function sort_str (txt, f) =
	list_to_str ( sort_quicksort (txt, type=0, f=f) )
//	list_to_str ( sort_mergesort (txt, type=0, f=f) )
;

// 2 sortierte Strings miteinander verschmelzen
function merge_str (txt1, txt2, f) =
	list_to_str ( merge (txt1, txt2, type=0, f=f) )
;

// Entfernt alle Duplikate aus dem String
function remove_duplicate_str (txt) =
	list_to_str ( remove_duplicate (list) )
;

// Entfernt alle Vorkommen eines Buchstaben
function remove_letter (txt, letter) =
	list_to_str ( remove_value (txt, letter) )
;

// Entfernt alle Vorkommen von Buchstaben aus einer Liste
function remove_all_letter (txt, letter_list) =
	list_to_str ( remove_all_values (txt, letter_list) )
;

// Ersetzt alle Vorkommen eines Buchstaben durch einen anderen
function replace_letter (txt, letter, new) =
	list_to_str ( replace_value (txt, letter, new) )
;

// Ersetzt alle Vorkommen von Buchstaben aus einer Liste durch einen anderen
function replace_all_letter (txt, letter_list, new) =
	list_to_str ( replace_all_values (txt, letter_list, new) )
;

// Behält alle Vorkommen eines Buchstaben, entfernt alle anderen.
// Macht kaum einen Sinn, der Vollständigkeit halber.
function keep_letter (txt, letter) =
	list_to_str ( keep_value (txt, letter) )
;

// Behält alle Vorkommen von Buchstaben aus einer Liste, entfernt alle anderen.
function keep_all_letter (txt, letter_list) =
	list_to_str ( keep_all_values (txt, letter_list) )
;

// Entfernt alle aufeinanderfolgenden Duplikate von Buchstaben
function unique_str (txt, f) =
	list_to_str ( unique (txt, type=0, f=f) )
;

// Entfernt alle aufeinanderfolgenden Duplikate komplett,
// behält nur die einzelstehenden Buchstaben
function keep_unique_str (txt, f) =
	list_to_str ( keep_unique (txt, type=0, f=f) )
;


// - Der Inhalt wird mit einer übergebenen Funktion bearbeitet:

// Führt Funktion 'f' auf die Buchstaben im String aus und entfernt alle Buchstaben
// bei der diese 'true' zurück gibt
function remove_if_str (txt, f) =
	list_to_str ( remove_if (txt, f, type=0) )
;

// Führt Funktion 'f' auf die Buchstaben im String aus und
// ersetzt alle Einträge bei der diese 'true' zurück gibt durch einen anderen String
function replace_if_str (txt, f, new) =
	list_to_str ( replace_if (txt, f, new, type=0) )
;

// Teilt einen String in 2 Teile auf
// Führt Funktion 'f' auf jeden Buchstaben aus
// Gibt 2 Strings in einer Liste zurück
// [ [String mif f()==true], [String mif f()==false] ]
function partition_str (txt, f, begin, last, count, range) =
	let ( res = partition (txt, f, 0, begin, last, count, range) )
	[ list_to_str (res[0])
	, list_to_str (res[1]) ]
;

// Führt Funktion 'f' auf jeden Buchstaben im String aus.
// Gibt den String mit den Ergebnissen zurück.
function for_each_str (txt, f, begin, last, count, range) =
	list_to_str ( for_each (list, f, 0, begin, last, count, range) )
;












