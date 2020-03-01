// function_list.scad
//
// Enthält Funktionen zum Bearbeiten von Listen und Punktlisten


// verbindet einzelne Listen innerhalb einer Liste miteinander
// aus z.B  [ [1,2,3], [4,5] ]  wird  [1,2,3,4,5]
function concat_list (list) = [for (a=list) for (b=a) b];

// kehrt die Reihenfolge einer Liste um
function reverse_list (list) = [for (a=[len(list)-1:-1:0]) list[a]];


// Punkt-Listen transformieren

// jeden Punkt in der Liste <list> um <v> verschieben
// funktioniert wie translate()
function translate_list (v, list) =
	[for (e=list) e+v]
;

/*
function rotate_list (a, v, list) =
	[for (e=list) e+v]
;
*/

// pair-Funktionen
//
// Aufbau eines Paares: [key, value]
// list = Liste mehrerer Schlüssel-Wert-Paare z.B. [ [key1,value1], [key2,value2], ... ]

// gibt den Wert eines Schlüssels aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Schlüssel zum Wert
//   index   -Bei gleichen Schlüsselwerten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Schlüssel genommen (index=0)
function pair_value        (list, key, index=0) = pair_value_intern(list, key, index);
function pair_value_intern (list, key, index, n=0) =
	(list[n]==undef) ? undef
	:(list[n][0]==key) ?
		(index==0) ? list[n][1]
		:	pair_value_intern (list, key, index-1, n+1)
	:		pair_value_intern (list, key, index,   n+1)
;

// gibt den Schlüssel eines Wertes aus einer Liste heraus
// Argumente:
//   list    -Liste aus Schlüssel-Wert-Paaren
//   key     -gesuchter Wert zum Schlüssel
//   index   -Bei gleichen Werten wird index-mal übersprungen
//            standartmäßig wird der erste gefundene Wert genommen (index=0)
function pair_key        (list, value, index=0) = pair_key_intern(list, value, index);
function pair_key_intern (list, value, index, n=0) =
	(list[n]==undef) ? undef
	:(list[n][1]==value) ?
		(index==0) ? list[n][0]
		:	pair_key_intern (list, value, index-1, n+1)
	:		pair_key_intern (list, value, index,   n+1)
;

// erzeugt ein Schlüssel-Werte-Paare
function pair (key, value) = [key, value];


