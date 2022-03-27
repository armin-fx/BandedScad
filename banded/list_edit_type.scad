// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Hilfsfunktionen für typabhängigen Zugriff auf den Inhalt von Listen
//
// Typenwerte:
//     0        = normaler Wert, Wert wird direkt zurückgegeben
//     [0]      = Liste mit Position [0,1,2, ... ]
//     [-1, fn] = Listeneintrag wird der Funktion fn übergeben
//


// gibt den Wert eines angegebenen Typs zurück
// Wird in den folgenden Listenfunktionen verwendet,
// um zwischen den Daten umschalten zu können von außerhalb der Funktion
// = Angabe Argument 'type'
function get_value (data, type=0) =
	 type   == 0 ? data
	:type[0]>= 0 ? data[type[0]]
	:type[0]==-1 ?
	//	type[1](data)            // direct function literal call, little faster
		let(fn=type[1]) fn(data) // call fallback function fn() if function literal is undef
	:undef
;

// schreibt einen Wert an der Stelle des eines angegebenen Typs ein
function set_value (data, value, type=0) =
	 type   == 0 ? value
	:type[0]>= 0 ? [ for (i=[0:1:len(data)]) i==type[0] ? value : data[i] ]
	:type[0]==-1 ?
		type[2]==undef ? value : // write value direct if write function is not defined
	//	type[2](data)
		let(fn_write=type[2]) fn_write (data, value)
	:undef
;

// Gibt eine Liste des gewählten Typs zurück aus einer Liste
function value_list (list, type=0) =
	 type   == 0 ? list
	:type[0]>= 0 ? let(p =type[0]) [ for (e=list) e[p]  ]
	:type[0]==-1 ? let(fn=type[1]) [ for (e=list) fn(e) ]
	:                              [ for (e=list) get_value(e,type) ]
;

// gibt den Typ der Liste zurück
//
// Elemente der Liste mit den normalen Werten direkt
function set_type_direct   ()           = 0;
// Elemente der Liste mit Listen als Wert,
// Angabe der Position des Wertes in diesen Listen
function set_type_list     (position=0) = [position];
// Elemente der Liste werden einer Funktion übergeben,
// Angabe des Funktionsliterals, welches den Wert liefert
//   Daten lesen:     fn()
//   Daten schreiben: fn_write()  - optional
function set_type_function (fn, fn_write) = fn_write==undef ? [-1, fn] : [-1, fn, fn_write];
// gibt den Typ der Liste zurück, entscheidet anhand des Arguments
function set_type          (argument, option) =
	 argument==undef       ? 0
	:is_num(argument)      ? [argument]
	:is_function(argument) ? option==undef ? [-1, argument] : [-1, argument, option]
	:0 // try normal direct value if argument is unknown
;

// Testfunktionen, um welchen Typ es sich handelt.
// geben true oder false zurück
//
function is_type_direct         (type) = (type==0);
function is_type_list           (type) = (type[0]!=undef && type[0]>=0);
function is_type_function       (type) = (type[0]==-1);
function is_type_function_write (type) = (type[0]==-1 && type[2]!=undef);
function is_type_unknown        (type) = (type!=0) && (type[0]!=undef && type[0]>=-1);

// ermittelt Infos aus der Typangabe,
// welche für den direkten Zugriff auf die Daten nötig sind
//
// ermittelt die Position der Liste aus der Typangabe
function get_position_type       (type) = type[0];
// ermittelt das Funktionsliteral aus der Typangabe
function get_function_type       (type) = type[1];
function get_function_write_type (type) = type[2];

