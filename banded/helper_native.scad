// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// interne Hilfsfunktionen

use <banded/math_common.scad>

// extrahiert eine feste Position aus einer Liste
// extract_axis(list=[[x,y,z], [1,2,3], [11,12,13]], axis=1) => [y,2,12]
//                       ^        ^          ^                   ^ ^  ^
//                     0 1 2    0 1 2     0  1  2
function extract_axis (list, axis) = [ for (n=list) n[axis] ];

// gibt den größten Abstand der einzelnen Werte innerhalb einer Liste zurück
function diff_list (list) = max(list) - min(list);
// gibt den größten Abstand jeder einzelnen Achse aus einer Vektoren-Liste
function diff_axis_list (list) = [
	for (axis=[0:1:len(list[0])-1]) diff_list (extract_axis (list, axis))
];

// Wandelt eine Bereichsangabe in eine Liste um
//     [0:3]  ==>  [0,1,2,3]
function range (value) = [ for (e=value) e ];

// gibt die echte Position innerhalb einer Liste zurück
// Kodierung wie in python:
//     positive Angaben = Liste vom Anfang
//     negative Angaben = Liste vom Ende
//     [a,  b,  c,  d]
//      |   |   |   |
//      0   1   2   3
//     -4  -3  -2  -1
function get_position (list, position) =
	position>=0 ? position : len(list)+position
;
// Positionen außerhalb der Liste werden an den Anfang oder das Ende gesetzt
function get_position_safe (list, position) =
	list==undef || list==[] ? -1 :
	// constrain (get_position (list, position), 0, len(list)-1)
	//
	let( size = len(list) )
	position>=0 ?
		(position>size-1) ? size-1 : position
	: // position<0
		(size+position<0) ? 0      : size+position
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
	position>=0 ? position : len(list)+position+1
;
function get_position_insert_safe (list, position) =
	// constrain (get_position_insert (list, position), 0, len(list))
	//
	let( size = len(list) )
	position>=0 ?
		(position>size)     ? size : position
	: // position<0
		(size+position+1<0) ? 0    : size+position+1
;

// letztes Element in der Liste
function last_position (list)          =       len(list) - 1;
function last_value    (list, index=0) = list[ len(list) - 1 - index ];

// Wie 'get_position()'.
// Angabe der Größe der Liste, an statt der Liste selber.
function get_index (size, position) =
	position>=0 ? position : size+position
;
function get_index_safe (size, position) =
	// constrain (get_index (size, position), 0, size-1)
	//
	position>=0 ?
		(position>size-1) ? size-1 : position
	: // position<0
		(size+position<0) ? 0      : size+position
;
function get_index_insert (size, position) =
	position>=0 ? position : size+position+1
;
function get_index_insert_safe (size, position) =
	// constrain (get_index_insert (size, position), 0, size)
	//
	position>=0 ?
		(position>size)     ? size : position
	: // position<0
		(size+position+1<0) ? 0    : size+position+1
;

// testet eine numerische Variable auf eine gültige Zahl (Not A Number)
function is_nan (value) = value!=value;
// testet eine numerische Variable auf unendlich
function is_inf (value) = value==1e200*1e200;
// testet eine numerische Variable unendlich oder -unendlich
function is_inf_abs (value) = value==1e200*1e200 || value==-1e200*1e200;
// testet eine Variable ob sie eine Bereichsangabe enthält (z.B. [0:1:10])
function is_range (value) =
	   value!=undef
	&& value[0]!=undef
	&& !is_list(value)
	&& !is_string(value)
;

// testet eine Variable, ob sie eine Liste mit einer angegebenen
// Verschachtelungstiefe enthält.
// depth - Tiefe der verschachtelten Listen,
//         ohne Angabe (= 1) wird auf eine einfache unverschachtelte Liste getestet
//         bei 0 wird die Variable getestet, ob sie nicht undef und keine Liste ist
function is_list_depth (value, depth=1) =
	depth==0 ? value!=undef && !is_list(value) :
	is_list_depth_intern (value, depth)
;
function is_list_depth_intern (value, depth=1) =
	depth==1 ? (!is_list(value[0]) && is_list(value))
	:          is_list_depth_intern (value[0], depth-1)
;
// testet eine Variable, ob sie eine Liste mit einer angegebenen
// Verschachtelungstiefe enthält und die letzte Liste numerische Werte enthält.
// depth - Tiefe der verschachtelten Listen,
//         ohne Angabe (= 1) wird auf eine einfache unverschachtelte Liste getestet
//         bei 0 wird die Variable getestet, ob sie eine Zahl enthält
function is_list_depth_num (value, depth=1) =
	depth==0 ? is_num(value) :
	is_list_depth_num (value, depth)
;
function is_list_depth_num_intern (value, depth=1) =
	depth==1 ? (is_num(value[0]) && is_list(value))
	:          is_list_depth_num_intern (value[0], depth-1)
;

// gibt die Verschachtelungstiefe einer Liste zurück
function get_list_depth (list) = get_list_depth_intern(list);
function get_list_depth_intern (list, i=0) =
	list[0]==undef && !is_list(list) ? i
	:	get_list_depth_intern (list[0], i+1)
;


// gibt einen Wert für mehrere gleichartige Parameter zurück
// Sinnvoll, wenn z.B. der Parameter r oder d/2 für den Radius stehen sollen.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist (und nicht undef ist).
function get_first_good (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 0)
	a0!=undef ? a0 :
	a1!=undef ? a1 :
	a2!=undef ? a2 :
	a3!=undef ? a3 :
	a4!=undef ? a4 :
	a5!=undef ? a5 :
	a6!=undef ? a6 :
	a7!=undef ? a7 :
	a8!=undef ? a8 :
	a9
;

// Parameter sind nur Zahlen
function get_first_num (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 0)
	a0!=undef && is_num(a0) ? a0 :
	a1!=undef && is_num(a1) ? a1 :
	a2!=undef && is_num(a2) ? a2 :
	a3!=undef && is_num(a3) ? a3 :
	a4!=undef && is_num(a4) ? a4 :
	a5!=undef && is_num(a5) ? a5 :
	a6!=undef && is_num(a6) ? a6 :
	a7!=undef && is_num(a7) ? a7 :
	a8!=undef && is_num(a8) ? a8 :
	a9!=undef && is_num(a9) ? a9 :
	undef
;

// gibt das erste Argument 'a?' zurück, das eine Liste enthält,
// die 'length' groß sind und alle Werte in dieser nicht undef sind
function get_first_good_list (length, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	length==1 ? get_first_good_1d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) :
	length==2 ? get_first_good_2d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) :
	length==3 ? get_first_good_3d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) :
	length!=undef && is_num(length) && length>=4 ?
		get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], length)
	:	undef
;
// gibt das erste Argument 'a?' zurück, das eine Liste enthält,
// die 'length' groß sind und alle Werte in dieser nicht undef sind
// und alle einen numerischen Wert enthalten
function get_first_num_list (length, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	length==1 ? get_first_num_1d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) :
	length==2 ? get_first_num_2d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) :
	length==3 ? get_first_num_3d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) :
	length!=undef && is_num(length) && length>=4 ?
		get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], length)
	:	undef
;

// spezialisierte Funktion von get_first_good_list () für Listen mit 1 Element
function get_first_good_1d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 1)
	a0!=undef && is_list(a0) && len(a0)==1 && a0[0]!=undef ? a0 :
	a1!=undef && is_list(a1) && len(a1)==1 && a1[0]!=undef ? a1 :
	a2!=undef && is_list(a2) && len(a2)==1 && a2[0]!=undef ? a2 :
	a3!=undef && is_list(a3) && len(a3)==1 && a3[0]!=undef ? a3 :
	a4!=undef && is_list(a4) && len(a4)==1 && a4[0]!=undef ? a4 :
	a5!=undef && is_list(a5) && len(a5)==1 && a5[0]!=undef ? a5 :
	a6!=undef && is_list(a6) && len(a6)==1 && a6[0]!=undef ? a6 :
	a7!=undef && is_list(a7) && len(a7)==1 && a7[0]!=undef ? a7 :
	a8!=undef && is_list(a8) && len(a8)==1 && a8[0]!=undef ? a8 :
	a9!=undef && is_list(a9) && len(a9)==1 && a9[0]!=undef ? a9 :
	undef
;
function get_first_num_1d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 1)
	a0!=undef && is_list(a0) && len(a0)==1 && is_num(a0[0]) ? a0 :
	a1!=undef && is_list(a1) && len(a1)==1 && is_num(a1[0]) ? a1 :
	a2!=undef && is_list(a2) && len(a2)==1 && is_num(a2[0]) ? a2 :
	a3!=undef && is_list(a3) && len(a3)==1 && is_num(a3[0]) ? a3 :
	a4!=undef && is_list(a4) && len(a4)==1 && is_num(a4[0]) ? a4 :
	a5!=undef && is_list(a5) && len(a5)==1 && is_num(a5[0]) ? a5 :
	a6!=undef && is_list(a6) && len(a6)==1 && is_num(a6[0]) ? a6 :
	a7!=undef && is_list(a7) && len(a7)==1 && is_num(a7[0]) ? a7 :
	a8!=undef && is_list(a8) && len(a8)==1 && is_num(a8[0]) ? a8 :
	a9!=undef && is_list(a9) && len(a9)==1 && is_num(a9[0]) ? a9 :
	undef
;

// spezialisierte Funktion von get_first_good_list () für Listen mit 2 Elementen
function get_first_good_2d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 2)
	a0!=undef && is_list(a0) && len(a0)==2 && a0[0]!=undef && a0[1]!=undef ? a0 :
	a1!=undef && is_list(a1) && len(a1)==2 && a1[0]!=undef && a1[1]!=undef ? a1 :
	a2!=undef && is_list(a2) && len(a2)==2 && a2[0]!=undef && a2[1]!=undef ? a2 :
	a3!=undef && is_list(a3) && len(a3)==2 && a3[0]!=undef && a3[1]!=undef ? a3 :
	a4!=undef && is_list(a4) && len(a4)==2 && a4[0]!=undef && a4[1]!=undef ? a4 :
	a5!=undef && is_list(a5) && len(a5)==2 && a5[0]!=undef && a5[1]!=undef ? a5 :
	a6!=undef && is_list(a6) && len(a6)==2 && a6[0]!=undef && a6[1]!=undef ? a6 :
	a7!=undef && is_list(a7) && len(a7)==2 && a7[0]!=undef && a7[1]!=undef ? a7 :
	a8!=undef && is_list(a8) && len(a8)==2 && a8[0]!=undef && a8[1]!=undef ? a8 :
	a9!=undef && is_list(a9) && len(a9)==2 && a9[0]!=undef && a9[1]!=undef ? a9 :
	undef
;
function get_first_num_2d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 2)
	a0!=undef && is_list(a0) && len(a0)==2 && is_num(a0[0]) && is_num(a0[1]) ? a0 :
	a1!=undef && is_list(a1) && len(a1)==2 && is_num(a1[0]) && is_num(a1[1]) ? a1 :
	a2!=undef && is_list(a2) && len(a2)==2 && is_num(a2[0]) && is_num(a2[1]) ? a2 :
	a3!=undef && is_list(a3) && len(a3)==2 && is_num(a3[0]) && is_num(a3[1]) ? a3 :
	a4!=undef && is_list(a4) && len(a4)==2 && is_num(a4[0]) && is_num(a4[1]) ? a4 :
	a5!=undef && is_list(a5) && len(a5)==2 && is_num(a5[0]) && is_num(a5[1]) ? a5 :
	a6!=undef && is_list(a6) && len(a6)==2 && is_num(a6[0]) && is_num(a6[1]) ? a6 :
	a7!=undef && is_list(a7) && len(a7)==2 && is_num(a7[0]) && is_num(a7[1]) ? a7 :
	a8!=undef && is_list(a8) && len(a8)==2 && is_num(a8[0]) && is_num(a8[1]) ? a8 :
	a9!=undef && is_list(a9) && len(a9)==2 && is_num(a9[0]) && is_num(a9[1]) ? a9 :
	undef
;

// spezialisierte Funktion von get_first_good_list () für Listen mit 3 Elementen
function get_first_good_3d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 3)
	a0!=undef && is_list(a0) && len(a0)==3 && a0[0]!=undef && a0[1]!=undef && a0[2]!=undef ? a0 :
	a1!=undef && is_list(a1) && len(a1)==3 && a1[0]!=undef && a1[1]!=undef && a1[2]!=undef ? a1 :
	a2!=undef && is_list(a2) && len(a2)==3 && a2[0]!=undef && a2[1]!=undef && a2[2]!=undef ? a2 :
	a3!=undef && is_list(a3) && len(a3)==3 && a3[0]!=undef && a3[1]!=undef && a3[2]!=undef ? a3 :
	a4!=undef && is_list(a4) && len(a4)==3 && a4[0]!=undef && a4[1]!=undef && a4[2]!=undef ? a4 :
	a5!=undef && is_list(a5) && len(a5)==3 && a5[0]!=undef && a5[1]!=undef && a5[2]!=undef ? a5 :
	a6!=undef && is_list(a6) && len(a6)==3 && a6[0]!=undef && a6[1]!=undef && a6[2]!=undef ? a6 :
	a7!=undef && is_list(a7) && len(a7)==3 && a7[0]!=undef && a7[1]!=undef && a7[2]!=undef ? a7 :
	a8!=undef && is_list(a8) && len(a8)==3 && a8[0]!=undef && a8[1]!=undef && a8[2]!=undef ? a8 :
	a9!=undef && is_list(a9) && len(a9)==3 && a9[0]!=undef && a9[1]!=undef && a9[2]!=undef ? a9 :
	undef
;
function get_first_num_3d   (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	// get_first_num_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 3)
	a0!=undef && is_list(a0) && len(a0)==3 && is_num(a0[0]) && is_num(a0[1]) && is_num(a0[2]) ? a0 :
	a1!=undef && is_list(a1) && len(a1)==3 && is_num(a1[0]) && is_num(a1[1]) && is_num(a1[2]) ? a1 :
	a2!=undef && is_list(a2) && len(a2)==3 && is_num(a2[0]) && is_num(a2[1]) && is_num(a2[2]) ? a2 :
	a3!=undef && is_list(a3) && len(a3)==3 && is_num(a3[0]) && is_num(a3[1]) && is_num(a3[2]) ? a3 :
	a4!=undef && is_list(a4) && len(a4)==3 && is_num(a4[0]) && is_num(a4[1]) && is_num(a4[2]) ? a4 :
	a5!=undef && is_list(a5) && len(a5)==3 && is_num(a5[0]) && is_num(a5[1]) && is_num(a5[2]) ? a5 :
	a6!=undef && is_list(a6) && len(a6)==3 && is_num(a6[0]) && is_num(a6[1]) && is_num(a6[2]) ? a6 :
	a7!=undef && is_list(a7) && len(a7)==3 && is_num(a7[0]) && is_num(a7[1]) && is_num(a7[2]) ? a7 :
	a8!=undef && is_list(a8) && len(a8)==3 && is_num(a8[0]) && is_num(a8[1]) && is_num(a8[2]) ? a8 :
	a9!=undef && is_list(a9) && len(a9)==3 && is_num(a9[0]) && is_num(a9[1]) && is_num(a9[2]) ? a9 :
	undef
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
	list==undef || !is_list(list) ? undef :
	 size==0 ? get_first_good_in_list_intern      (list, begin)
	:size==3 ? get_first_good_in_list_intern_l_3  (list, begin)
	:size==2 ? get_first_good_in_list_intern_l_2  (list, begin)
	:size==1 ? get_first_good_in_list_intern_l_1  (list, begin)
	:          get_first_good_in_list_intern_list (list, size, begin)
;
/*
function get_first_good_in_list_intern (list, begin=0) =
	(len(list)-1 <begin) ? undef :
	(list[begin]!=undef) ?
		list[begin]
	:	get_first_good_in_list_intern(list, begin+1)
;*/
function get_first_good_in_list_intern (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]  !=undef ? list[begin]   :
	list[begin+1]!=undef ? list[begin+1] :
	list[begin+2]!=undef ? list[begin+2] :
	list[begin+3]!=undef ? list[begin+3] :
	get_first_good_in_list_intern (list, begin+4)
;
function get_first_good_in_list_intern_l_1 (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]!=undef && is_list(list[begin]) && len(list[begin])==1
	 && list[begin][0]!=undef ?
		list[begin]
	:	get_first_good_in_list_intern_l_1(list, begin+1)
;
function get_first_good_in_list_intern_l_2 (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]!=undef && is_list(list[begin]) && len(list[begin])==2
	 && list[begin][0]!=undef && list[begin][1]!=undef ?
		list[begin]
	:	get_first_good_in_list_intern_l_2(list, begin+1)
;
function get_first_good_in_list_intern_l_3 (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]!=undef && is_list(list[begin]) && len(list[begin])==3
	 && list[begin][0]!=undef && list[begin][1]!=undef && list[begin][2]!=undef ?
		list[begin]
	:	get_first_good_in_list_intern_l_3(list, begin+1)
;
function get_first_good_in_list_intern_list (list, size, begin=0) =
	 len(list)-1<begin ? undef
	:is_good_list(list[begin],0,size) ?
		list[begin]
	:	get_first_good_in_list_intern_list(list, size, begin+1)
;

// wie get_first_good_in_list () aber
//  - ein gültiger Wert: -> eine Zahl
function get_first_num_in_list (list, size=0, begin=0) =
	list==undef || !is_list(list) ? undef :
	 size==0 ? get_first_num_in_list_intern      (list, begin)
	:size==3 ? get_first_num_in_list_intern_l_3  (list, begin)
	:size==2 ? get_first_num_in_list_intern_l_2  (list, begin)
	:size==1 ? get_first_num_in_list_intern_l_1  (list, begin)
	:          get_first_num_in_list_intern_list (list, size, begin)
;
/*
function get_first_num_in_list_intern (list, begin=0) =
	len(list)-1 <begin  ? undef :
	list[begin]!=undef && is_num(list[begin]) ?
		list[begin]
	:	get_first_num_in_list_intern(list, begin+1)
;*/
function get_first_num_in_list_intern (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin  ]!=undef && is_num(list[begin])   ? list[begin]   :
	list[begin+1]!=undef && is_num(list[begin+1]) ? list[begin+1] :
	list[begin+2]!=undef && is_num(list[begin+2]) ? list[begin+2] :
	list[begin+3]!=undef && is_num(list[begin+3]) ? list[begin+3] :
	get_first_num_in_list_intern (list, begin+4)
;
function get_first_num_in_list_intern_l_1 (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]!=undef && is_list(list[begin]) && len(list[begin])==1
	 && is_num(list[begin][0]) ?
		list[begin]
	:	get_first_num_in_list_intern_l_1(list, begin+1)
;
function get_first_num_in_list_intern_l_2 (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]!=undef && is_list(list[begin]) && len(list[begin])==2
	 && is_num(list[begin][0]) && is_num(list[begin][1]) ?
		list[begin]
	:	get_first_num_in_list_intern_l_2(list, begin+1)
;
function get_first_num_in_list_intern_l_3 (list, begin=0) =
	len(list)-1<begin ? undef :
	list[begin]!=undef && is_list(list[begin]) && len(list[begin])==3
	 && is_num(list[begin][0]) && is_num(list[begin][1]) && is_num(list[begin][2]) ?
		list[begin]
	:	get_first_num_in_list_intern_l_3(list, begin+1)
;
function get_first_num_in_list_intern_list (list, size, begin=0) =
	len(list)-1<begin ? undef :
	is_num_list(list[begin],0,size) ?
		list[begin]
	:	get_first_num_in_list_intern_list(list, size, begin+1)
;

// testet eine Liste durch, ob alle Werte darin nicht undef sind
// gibt true zurück bei Erfolg
// Argumente:
//  - list    - Liste mit den Werten
//  - begin   - das erste Element das getestet wird
//              Standard = vom ersten Element an
//  - end     - das erste Element das nicht mehr getestet wird
//              Standart = bis zum letzten Element
function is_good_list (list, begin=0, end=undef) =
	 list==undef      ? false
	:!is_list(list)   ? false
	:begin==undef     ? false
	:end==undef       ? is_good_list_intern (list, begin, len(list))
	:! len(list)>=end ? false
	:is_good_list_intern (list, begin, end)
;
function is_good_list_intern (list, begin, end) =
	 begin>=end         ? true
	:list[begin]==undef ? false
	:is_good_list_intern (list, begin+1, end)
;

// testet eine Liste durch, ob alle Werte darin eine numerische Zahl sind
// gibt true zurück bei Erfolg
// Argumente wie is_good_list()
function is_num_list (list, begin=0, end=undef) =
	 list==undef      ? false
	:!is_list(list)   ? false
	:begin==undef     ? false
	:end==undef       ? is_num_list_intern (list, begin, len(list))
	:! len(list)>=end ? false
	:is_num_list_intern (list, begin, end)
;
function is_num_list_intern (list, begin, end) =
	 begin>=end            ? true
	:list[begin]==undef    ? false
	:! is_num(list[begin]) ? false
	:is_num_list_intern (list, begin+1, end)
;

// testet eine Liste mit fester Größe, ob alle Werte darin nicht undef sind
// gibt true zurück bei Erfolg
function is_good_1d (list) =
	 list!=undef && is_list(list) && len(list)==1
	 && list[0]!=undef
;
function is_good_2d (list) =
	 list!=undef && is_list(list) && len(list)==2
	 && list[0]!=undef && list[1]!=undef
;
function is_good_3d (list) =
	 list!=undef && is_list(list) && len(list)==3
	 && list[0]!=undef && list[1]!=undef && list[2]!=undef
;
function is_good_4d (list) =
	 list!=undef && is_list(list) && len(list)==4
	 && list[0]!=undef && list[1]!=undef && list[2]!=undef && list[4]!=undef
;

// testet eine Liste mit fester Größe, ob alle Werte darin eine numerische Zahl sind
// gibt true zurück bei Erfolg
function is_num_1d (list) =
	 list!=undef && is_list(list) && len(list)==1
	 && is_num(list[0])
;
function is_num_2d (list) =
	 list!=undef && is_list(list) && len(list)==2
	 && is_num(list[0]) && is_num(list[1])
;
function is_num_3d (list) =
	 list!=undef && is_list(list) && len(list)==3
	 && is_num(list[0]) && is_num(list[1]) && is_num(list[2])
;
function is_num_4d (list) =
	 list!=undef && is_list(list) && len(list)==4
	 && is_num(list[0]) && is_num(list[1]) && is_num(list[2]) && is_num(list[3])
;


function is_split_block (block, last, first=0) = last-first > block*2;
function    split_block (block, last, first=0) = last - (last-first)%block - block - 1;

