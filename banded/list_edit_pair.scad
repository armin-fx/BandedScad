// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// pair-Funktionen
//
// Aufbau eines Paares: [key, value]
// list = Liste mehrerer Schlüssel-Wert-Paare z.B. [ [key1,value1], [key2,value2], ... ]

use <banded/list_edit_type.scad>
use <banded/list_edit_data.scad>


// Typ-Konstanten für die Listenfunktionen
type_pair_key  = set_type_list(0);
type_pair_value= set_type_list(1);

// gibt den Wert eines Schlüssels aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Schlüssel zum Wert
//   index   -Bei gleichen Schlüsselwerten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function pair_value     (list, key, index=0) =
	list[find_first_list(list, key, index, type=type_pair_key)] [get_position_type(type_pair_value)];

// gibt den Schlüssel eines Wertes aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Wert zum Schlüssel
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Wert genommen (index=0)
function pair_key       (list, value, index=0) =
	list[find_first_list(list, value, index, type=type_pair_value)] [get_position_type(type_pair_key)];

// erzeugt ein Schlüssel-Werte-Paar
function pair (key, value) = [key, value];
