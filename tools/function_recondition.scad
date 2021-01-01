// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten, Auswählen und Reparieren von Argumenten

use <tools/function_helper.scad>
use <tools/function_matrix.scad>

function repair_matrix_3d (m) =
	fill_matrix_with (m, identity_matrix(4))
;
function repair_matrix_2d (m) =
	fill_matrix_with (m, identity_matrix(3))
;

function fill_matrix_with (m, c) =
	!is_list(m) ? c :
	[ for (i=[0:len(c)-1])
		[ for (j=[0:len(c[i])-1])
			is_num(m[i][j]) ? m[i][j] : c[i][j]
		]
	]
;
function fill_list_with (list, c) =
	!is_list(list) ? c :
	[ for (i=[0:len(c)-1])
		is_num(list[i]) ? list[i] : c[i]
	]
;

// gibt einen Bereich für eine Liste aus
// Kodierung wie in python (z.B. -1 = letztes Element)
//     begin = erstes Element aus der Liste
//     last  = letztes Element
// oder
//     range = [begin, last]
// Ergebnis:
//     [begin, last]
function parameter_range (list, begin, last, range) =
	let(
		Begin = get_position(list, get_first_good(begin,range[0], 0)),
		Last  = get_position(list, get_first_good(last ,range[1],-1))
	)
	[Begin, Last]
;
function parameter_range_safe (list, begin, last, range) =
	let(
		Begin = get_position_safe(list, get_first_good(begin,range[0], 0)),
		Last  = get_position_safe(list, get_first_good(last ,range[1],-1))
	)
	[Begin, Last]
;

// gibt [Innenradius, Außenradius] zurück
// Argumente:
//   r, d   - mittlerer Radius oder Durchmesser
//   r1, d1 - Innenradius oder Innendurchmesser
//   r2, d2 - Außenradius oder Außendurchmesser
//   w      - Breite des Rings
// Angegeben müssen:
//   genau 2 Angaben von r oder r1 oder r2 oder w
// Regeln in Anlehnung von OpenSCAD
// - Durchmesser geht vor Radius
// - ohne Angabe: r1=1, r2=2
function parameter_ring_2r (r, w, r1, r2, d, d1, d2) =
	parameter_ring_2r_basic (
		r =get_first_num(d /2,  r),
		w =w,
		r1=get_first_num(d1/2, r1),
		r2=get_first_num(d2/2, r2)
	)
;
function parameter_ring_2r_basic (r, w, r1, r2) =
	 (r !=undef && w !=undef) ? [r-w/2   , r+w/2]
	:(r1!=undef && r2!=undef) ? [r1      , r2]
	:(r !=undef && r1!=undef) ? [r1      , 3*r-2*r1]
	:(r !=undef && r2!=undef) ? [3*r-2*r2, r2]
	:(r1!=undef && w !=undef) ? [r1      , r1+w]
	:(r2!=undef && w !=undef) ? [r2-w    , r2]
	:[1, 2]
;

// gibt [rotations, pitch] einer Helix zurück
// Argumente:
//   rotations - Anzahl der Umdrehungen
//   pitch     - Höhenunterschied je Umdrehung
//   height    - Höhe der Helix
function parameter_helix_to_rp (rotations, pitch, height) =
	 (is_num(pitch)  && is_num(rotations)) ? [rotations,    pitch]
	:(is_num(pitch)  && is_num(height))    ? [height/pitch, pitch]
	:(is_num(height) && is_num(rotations)) ? [rotations,    height/rotations]
	:(is_num(pitch))     ? [1,         pitch]
	:(is_num(height))    ? [1,         height]
	:(is_num(rotations)) ? [rotations, 0]
	:[1, 0]
;

// gibt [radius_unten, radius_oben] zurück
// Argumente:
//   r  - Radius oben und unten
//   r1 - Radius unten
//   r2 - Radius oben
//   d  - Durchmesser oben und unten 
//   d1 - Durchmesser unten
//   d2 - Durchmesser oben
// Regeln wie bei cylinder() von OpenSCAD
// - Durchmesser geht vor Radius
// - spezielle Angaben (r1, r2) gehen vor allgemeine Angaben (r)
// - ohne Angabe: r=1
function parameter_cylinder_r (r, r1, r2, d, d1, d2, preset) =
	parameter_cylinder_r_basic (
		get_first_num(d /2, r),
		get_first_num(d1/2, r1),
		get_first_num(d2/2, r2),
		preset)
;
function parameter_cylinder_r_basic (r, r1, r2, preset) =
	get_first_num_2d (
		[r1,r2],
		[r1,r ],
		[r, r2],
		[r, r ],
		preset,
		[1,1])
;

// gibt den Radius zurück
// Argumente:
//   r  - Radius
//   d  - Durchmesser
// Regeln wie bei circle() von OpenSCAD
// - Durchmesser geht vor Radius
// - ohne Angabe: r=1
function parameter_circle_r (r, d) = get_first_good (d/2, r, 1);

// wandelt das Argument 'size' um in einen Tupel [1,2,3]
// aus size=3       wird   [3,3,3]
// aus size=[1,2,3] bleibt [1,2,3]
function parameter_size_3d (size) =
	(is_list(size) && len(size)>0 && is_num(size[0])) ?
		(is_num(size[1])) ?
		(is_num(size[2])) ?
		 size                  // f([1,2,3])
		:[size[0], size[1], 0] // f([1,2])
		:[size[0], 0      , 0] // f([1])
	:(is_num (size)) ?
		 [size, size, size]    // f(1)
	:	 [1,1,1]               // f(undef)

;
function parameter_size_2d (size) =
	get_first_good_2d (size+[0,0], [size+0,size+0], [1,1])
;

// Wandelt das Argument 'value' in eine Liste mit 'dimension' Elementen
// Falls das nicht geht, wird der Standartwert 'preset' genommen
// Argumente:
//   dimension - Gewünschte Größe der Liste
//   value     - Argument, welches bearbeitet wird
//                - Als Liste = wird übernommen und auf 'dimension' Elemente gesetzt
//                - Als Wert  = es wird eine Liste mit 'dimension' Elementen mit diesen Wert erzeugt
//   preset    - Standartwert, wenn die Umwandlung nicht gelingt
//   fill      - Behandlung, wenn die Liste kleiner als 'dimension' ist
//                - true  = fehlende Werte werden mit preset aufgefüllt
//                - false = es wird 'preset' genommen
//                - undef = value so lassen (Standart)
//                - Zahl  = mit den Wert aus dieser Position in 'value' auffüllen
//                          geht das nicht, wird 'preset' genommen
//                - Liste = mit den Werten aus der Liste 'fill' an den entsprechenden Positionen auffüllen
function parameter_numlist (dimension, value, preset, fill) =
	 is_num(value)  ? [for (i=[0:dimension-1]) value]
	:is_list(value) ?
		 len(value)> dimension ? [for (i=[0:dimension-1]) value[i]]
		:len(value)< dimension ?
			 fill==true   ? concat( value, [for (i=[len(value):dimension-1]) preset[i]] )
			:fill==false  ? preset
			:is_num(fill) ?
				fill>len(value)-1 ? preset
				: concat( value, [for (i=[len(value):dimension-1]) value[fill]] )
			:is_list(fill) ? concat( value, [for (i=[len(value):dimension-1]) fill[i]] )
			:value
		:value
	:preset
;



// gibt den Winkel zurück
// Rückgabe:
//   [Öffnungswinkel, Anfangswinkel]
// Argumente:
//   angle     - Als Zahl  = Angabe Öffnungswinkel, Anfangswinkel wird auf 0 gesetzt
//             - Als Liste = [Öffnungswinkel, Anfangswinkel]
//   angle_std - Standartangabe des Winkels, wenn angle nicht gesetzt wurde
//               (Standart = [360, 0])
function parameter_angle (angle, angle_std) =
	(is_num (angle))                  ? [angle   , 0] :
	(is_list(angle) && len(angle)==2) ? angle         :
	(is_list(angle) && len(angle)==1) ? [angle[0], 0] :
	(is_list(angle) && len(angle) >2) ? [angle[0], angle[1]] :
	parameter_angle (angle_std, [360,0])
;

function parameter_mirror_vector_2d (v, v_std=[1,0]) =
	(is_list(v) && len(v)>=2) ? v : v_std
;
function parameter_mirror_vector_3d (v, v_std=[1,0,0]) =
	 !is_list(v) ? v_std
	:len(v)>=3   ? v
	:len(v)==2   ? [v[0],v[1],0]
	:v_std
;

// Wertet die Parameter edges_xxx vom Module cube_fillet() aus,
// gibt eine 4 elementige Liste zurück
// Argumente:
//   r         - Radius oder Breite
//   edge_list - 4-elementige Auswahlliste der jeweiligen Kanten,
//               wird mit r multipliziert
//             - als Zahl werden alle Elemente mit diesen Wert gesetzt
//             - andernfalls wird der Wert auf 0 gesetzt = nicht gefaste Kante
function parameter_edges_radius (edge_list, r) =
	is_list(edge_list) ?
		[ for (i=[0:3]) parameter_edge_radius (edge_list[i], r) ]
	:is_num(edge_list) ?
		[ for (i=[0:3]) parameter_edge_radius (edge_list,    r) ]
	:	[ for (i=[0:3]) 0 ]
;
function parameter_edge_radius (edge, r) =
	is_num(edge) ?
		is_num(r) ? edge * r
		:           edge
	: 0
;

// Wertet die Parameter type_xxx vom Module cube_fillet() aus,
// gibt eine 4 elementige Liste zurück
function parameter_types (type_list, type) =
	is_list(type_list) ?
		[ for (i=[0:3]) parameter_type (type_list[i], type) ]
	:	[ for (i=[0:3]) parameter_type (type_list,    type) ]
;
function parameter_type (type_x, type) =
	 (type_x == undef) ? parameter_type (type, 0)
	:(type_x < 0     ) ? parameter_type (type, 0)
	: type_x
;
