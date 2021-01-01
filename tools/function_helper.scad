// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// interne Hilfsfunktionen

use <tools/function_math.scad>

// extrahiert eine feste Position aus einer Liste
// extract_axis(list=[[x,y,z], [1,2,3], [11,12,13]], axis=1) => [y,2,12]
//                       ^        ^          ^                   ^ ^  ^
//                     0 1 2    0 1 2     0  1  2
function extract_axis (list, axis) = [ for (n=list) n[axis] ];

// gibt den größten Abstand der einzelnen Werte innerhalb einer Liste zurück
function diff_list     (list) = max(list) - min(list);
// gibt den größten Abstand jeder einzelnen Achse in einer Vektoren-Liste
function diff_axis_list (list) = [
	for (axis=[0 : len(list[0])-1]) diff_list(extract_axis(list, axis))
];
// gibt die maximal mögliche Raumdiagonale zurück
function max_norm (list) = norm(diff_axis_list(list));

// gibt die echte Position innerhalb einer Liste zurück
// Kodierung wie in python:
//     positive Angaben = Liste vom Anfang
//     negative Angaben = Liste vom Ende
//     [a,  b,  c,  d]
//      |   |   |   |
//      0   1   2   3
//     -4  -3  -2  -1
function get_position (list, position) =
	(position>=0) ? position : len(list)+position
;
// Positionen außerhalb der Liste werden an den Anfang oder das Ende gesetzt
function get_position_safe (list, position) =
	let( real = (position>=0) ? position : len(list)+position )
	constrain (real, 0, len(list)-1)
;
// gibt die echte Position innerhalb einer Liste zurück
// Kodierung sinnvoll für Einfügepositionen:
//     positive Angaben = Liste vom Anfang
//     negative Angaben = Liste vom Ende, nach dem Element
//     [a,  b,  c,  d]
//      |   |   |   |
//      0   1   2   3
//    ^   ^   ^   ^   ^
//     \   \   \   \   \
//     -5  -4  -3  -2  -1
function get_position_insert (list, position) =
	(position>=0) ? position : len(list)+position+1
;
function get_position_insert_safe (list, position) =
	let( real = (position>=0) ? position : len(list)+position+1 )
	constrain (real, 0, len(list))
;

// testet eine numerische Variable auf eine gültige Zahl (Not A Number)
function is_nan (value) = value!=value;
// testet eine numerische Variable auf unendlich
function is_inf (value) = value==1e200*1e200;
// testet eine numerische Variable unendlich oder -unendlich
function is_inf_abs (value) = is_num(value) && abs(value)==1e200*1e200;
// testet eine Variable ob sie eine Bereichsangabe enthält (z.B. [0:1:10])
function is_range (value) =
	   value!=undef
	&& !is_num   (value)
	&& !is_bool  (value)
	&& !is_list  (value)
	&& !is_string(value)
	&& !is_nan   (value)
;

// testet eine Variable, ob sie eine Liste enthält
// dimension - Tiefe der verschachtelten Listen,
//             ohne Angabe wird eine eindimensionale Liste getestet
//             bei 0 wird die Variable getestet, ob sie eine Zahl enthält
function is_list_depth (value, dimension=1) =
	(dimension==0) ? is_num(value) :
	(dimension==1) ? (is_list(value) && !is_list(value[0]))
	:                is_list_depth  (value[0], dimension-1)
;

// gibt die Verschachelungstiefe einer Liste zurück
function get_list_depth (list) = get_list_depth_intern(list);
function get_list_depth_intern (list, i=0) =
	(!is_list(list)) ? i
	:                  get_list_depth_intern (list[0], i+1)
;


// gibt einen Wert für mehrere gleiche Parameter zurück
// Sinnvoll, wenn z.B. der Parameter r oder d/2 für den Radius stehen sollen.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist (und nicht undef ist).
function get_first_good      (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 0)
;
// Parameter sind nur Zahlen
function get_first_num      (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 0)
;

// gibt einen Wert für mehrere gleiche Parameter zurück
// Die Parameter sind hier 1-Dimensionale Vektoren
// Alle einzelnen Parameter im Vektor müssen einen Wert haben, um akzeptiert zu werden.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist.
function get_first_good_1d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 1)
;
function get_first_num_1d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 1)
;

// gibt einen Wert für mehrere gleiche Parameter zurück
// Die Parameter sind hier 2-Dimensionale Vektoren
// Alle 2 Parameter im Vektor müssen einen Wert haben, um akzeptiert zu werden.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist.
function get_first_good_2d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 2)
;
function get_first_num_2d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 2)
;

// gibt einen Wert für mehrere gleiche Parameter zurück
// Die Parameter sind hier 3-Dimensionale Vektoren
// Alle 3 Parameter im Vektor müssen einen Wert haben, um akzeptiert zu werden.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist.
function get_first_good_3d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 3)
;
function get_first_num_3d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 3)
;

// gibt das erste gültige Element in der Liste zurück
// Es wird das erste Element genommen, das alle Bedingungen erfüllt.
// Begingungen:
//  - Element ist nicht undef
//  - Element ist eine Liste mit (mindestens) der Größe <size>
//    mit gültigen Werten
//  - wenn size==0 ist das Element ein gültiger Wert und keine Liste
//  - ein gültiger Wert: -> jeder Datentyp, nur nicht undef
// Argumente:
//   list    - Liste mit den Elementen
//   size    - Element muss eine Liste sein mit dieser Größe
//             wenn 0, dann muss das Element ein gültiger Wert sein und keine Liste
//   begin   - ab dieser Position wird getestet
function get_first_good_in_list (list, size=0, begin=0) =
	 (len(list)  ==undef) ? undef
	:(len(list)-1 <begin) ? undef
	:(size==0) ?
		(list[begin]==undef) ?
			get_first_good_in_list(list, size, begin+1)
		:	list[begin]
	  :
		 (list[begin]==undef || !is_good_list(list[begin],0,size)) ?
			get_first_good_in_list(list, size, begin+1)
		:	list[begin]
;

// testet eine Liste durch, ob alle Werte darin nicht undef sind
// gibt true zurück bei Erfolg
// Argumente:
//  - list    - Liste mit den Werten
//  - begin   - das erste Element das getestet wird
//  - end     - das erste Element das nicht mehr getestet wird
function is_good_list (list, begin=0, end=undef) =
	 (list==undef)   ? false
	:(begin==undef)  ? false
	:(end==undef)    ? is_good_list (list, begin, len(list))
	:(len(list)<end) ? false
	:(begin>=end)    ? true
	:(list[begin]==undef) ? false
	:(len(list)<end) ? false
	:is_good_list (list, begin+1, end)
;

// wie get_first_good_in_list () aber
//  - ein gültiger Wert: -> eine Zahl
function get_first_num_in_list (list, size=0, begin=0) =
	 (len(list)  ==undef) ? undef
	:(len(list)-1 <begin) ? undef
	:(size==0) ?
		(! is_num(list[begin])) ?
			get_first_num_in_list(list, size, begin+1)
		:	list[begin]
	  :
		 (list[begin]==undef || !is_num_list(list[begin],0,size)) ?
			get_first_num_in_list(list, size, begin+1)
		:	list[begin]
;
function is_num_list (list, begin=0, end=undef) =
	 (list==undef)   ? false
	:(begin==undef)  ? false
	:(end==undef)    ? is_num_list (list, begin, len(list))
	:(len(list)<end) ? false
	:(begin>=end)    ? true
	:(! is_num(list[begin])) ? false
	:(len(list)<end) ? false
	:is_num_list (list, begin+1, end)
;

function is_split_block (block, last, first=0) = last-first > block*2;
function    split_block (block, last, first=0) = last - (last-first)%block - block - 1;

// function returns value and echo a message if version of OpenSCAD is 2019.05 or greater
function do_echo (value, message) =
	version_num()<20190500 ? value
	: echo(message) + value
;

