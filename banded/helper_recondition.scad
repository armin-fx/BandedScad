// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen zum Bearbeiten, Auswählen und Reparieren von Argumenten

use <banded/helper_native.scad>
use <banded/math_matrix.scad>

function repair_matrix (m, d) =
	m[0][0]==undef ? identity_matrix(d) :
	let (
		n = len(m[0]),
		D = d!=undef ? d : n
	)
	n==D ?
		len(m)==D ? m :
		len(m)==D-1 ?
			D==2 ? [m[0],           [0,1]] :
			D==3 ? [m[0],m[1],      [0,0,1]] :
			D==4 ? [m[0],m[1],m[2], [0,0,0,1]] :
			//	concat (m, [concat([for (i=[0:1:D-2]) 0], 1)] ) :
			//	concat (m, [                       [for (i=[0:1:D-1]) i<D-1 ? 0 : 1] ] ) :
				[ for (k=[0:1:D-1]) k<D-1 ? m[k] : [for (i=[0:1:D-1]) i<D-1 ? 0 : 1] ] :
		fill_missing_matrix (m, identity_matrix(D)) :
	fill_missing_matrix     (m, identity_matrix(D))
;

function fill_missing_matrix (m, c) =
	!is_list(m) ? c :
	[ for (i=[0:len(c)-1])
		[ for (j=[0:len(c[i])-1])
		//	is_num(m[i][j])                     ? m[i][j] : c[i][j] // slow, safe
			(m[i][j]!=undef && is_num(m[i][j])) ? m[i][j] : c[i][j] // middle, safe
		//	m[i][j]!=undef                      ? m[i][j] : c[i][j] // fast, no type test
		]
	]
;
function fill_missing_list (list, c) =
	!is_list(list) ? c :
	[ for (i=[0:len(c)-1])
		(list[i]!=undef || is_num(list[i])) ? list[i] : c[i]
	]
;

// gibt einen Bereich für eine Liste aus
// Kodierung wie in python
// (z.B. -1 = letztes Element, -1 bei count = Anzahl aller Elemente)
//     begin = erstes Element aus der Liste
//     last  = letztes Element
// oder
//     count = Anzahl der Elemente
//     range = [begin, last]
// Ergebnis:
//     [begin, last]
// Rangordnung der Argumente:
//  - begin, last
//  - begin, count
//  - last, count
//  - range[0], count
//  - range[1], count
//  - range
//  - einzelne Argumente (begin, last, count)
//  - [0, -1]
//
function parameter_range (list, begin, last, count, range) =
	let(
		Range = // [Begin, Last]
			(begin!=undef && last!=undef) ?
				[get_position(list,begin), get_position(list,last)]
			:(begin!=undef && count!=undef) ?
				[get_position(list,begin), get_position(list,begin)+get_position_insert(list,count)-1]
			:(last!=undef && count!=undef) ?
				[get_position(list,last)-get_position_insert(list,count), get_position(list,last)]
			:(range!=undef && range[0]!=undef && count!=undef) ?
				[get_position(list,range[0]), get_position(list,range[0])+get_position_insert(list,count)-1]
			:(range!=undef && range[1]!=undef && count!=undef) ?
				[get_position(list,range[1])-get_position_insert(list,count), get_position(list,range[1])]
			:(range!=undef && range[0]!=undef && range[1]!=undef) ?
				[get_position(list,range[0]), get_position(list,range[1])]
			:(begin !=undef) ? [get_position(list,begin), len(list)-1]
			:(last  !=undef) ? [0, get_position(list,last)]
			:(count !=undef) ? [0, get_position_insert(list,count)-1]
			:[0, len(list)-1]
	)
	// [Begin, Last    >=Begin    ? Last     : Begin   -1]
	[Range[0], Range[1]>=Range[0] ? Range[1] : Range[0]-1]
;
function parameter_range_safe (list, begin, last, count, range) =
	let(
		Range = // [Begin, Last]
			(begin!=undef && last!=undef) ?
				[get_position(list,begin), get_position_safe(list,last)]
			:(begin!=undef && count!=undef) ?
				[get_position(list,begin), get_position(list,begin)+get_position_insert_safe(list,count)-1]
			:(last!=undef && count!=undef) ?
				[get_position(list,last)-get_position_insert_safe(list,count), get_position_safe(list,last)]
			:(range!=undef && range[0]!=undef && count!=undef) ?
				[get_position(list,range[0]), get_position(list,range[0])+get_position_insert_safe(list,count)-1]
			:(range!=undef && range[1]!=undef && count!=undef) ?
				[get_position(list,range[1])-get_position_insert_safe(list,count), get_position_safe(list,range[1])]
			:(range!=undef && range[0]!=undef && range[1]!=undef) ?
				[get_position(list,range[0]), get_position_safe(list,range[1])]
			:(begin !=undef) ? [get_position(list,begin), len(list)-1]
			:(last  !=undef) ? [0, get_position_safe(list,last)]
			:(count !=undef) ? [0, get_position_insert_safe(list,count)-1]
			:[0, len(list)-1]
	)
	// [Begin, Last    >=Begin    ? Last     : Begin   -1]
	[Range[0], Range[1]>=Range[0] ? Range[1] : Range[0]-1]
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
		r =d !=undef&&is_num(d ) ? d /2 :  r !=undef&&is_num(r ) ? r  :  undef,
		w =w,
		r1=d1!=undef&&is_num(d1) ? d1/2 :  r1!=undef&&is_num(r1) ? r1 :  undef,
		r2=d2!=undef&&is_num(d2) ? d2/2 :  r2!=undef&&is_num(r2) ? r2 :  undef
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

// Rückgabe:
//   [ri1, ri2, ro1, ro2]
// Argumente:
//   ri1, ri2 - Innenradius unten, oben
//   ro1, ro2 - Außenradius unten, oben
//   ri, ro   - Innen- und Außenradius allgemein, gemeinsame Maße für unten und oben
//   w        - Breite der Wand. Optional
// Regeln:
// - Radius geht vor Durchmesser
// - spezieller Radius/Durchmesser geht vor allgemeinen Radius/Durchmesser,
//   z.B. 'ri1' (Innenradius unten) überschreibt 'ri' (Innenradius für beide Seiten)
// - fehlender Radius oder Durchmesser wird mit Wandparameter aus dem
//   gegenüberliegenden Radius oder Durchmesser ermittelt
// - fehlender Innenradius wird auf 1 gesetzt,
//   fehlender Außenradius wird auf 2 gesetzt.
function parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2, ri, ro, di, do) =
	let (
		// easier to read, but warnings since OpenSCAD version 2021.01
		// _ri1 = get_first_num (ri1, di1/2, ri, di/2, ro1-w, do1/2-w, ro-w, do/2-w, 1)
		//,_ri2 = get_first_num (ri2, di2/2, ri, di/2, ro2-w, do2/2-w, ro-w, do/2-w, 1)
		//,_ro1 = get_first_num (ro1, do1/2, ro, do/2, ri1+w, di1/2+w, ri+w, di/2+w, 2)
		//,_ro2 = get_first_num (ro2, do2/2, ro, do/2, ri2+w, di2/2+w, ri+w, di/2+w, 2)
		
		 is_ri1 = ri1!=undef && is_num(ri1)
		,is_ri2 = ri2!=undef && is_num(ri2)
		,is_ro1 = ro1!=undef && is_num(ro1)
		,is_ro2 = ro2!=undef && is_num(ro2)
		,is_w   =   w!=undef && is_num(w)
		,is_di1 = di1!=undef && is_num(di1)
		,is_di2 = di2!=undef && is_num(di2)
		,is_do1 = do1!=undef && is_num(do1)
		,is_do2 = do2!=undef && is_num(do2)
		,is_ri  =  ri!=undef && is_num(ri)
		,is_ro  =  ro!=undef && is_num(ro)
		,is_di  =  di!=undef && is_num(di)
		,is_do  =  do!=undef && is_num(do)
		//
		,_ri1 =
			is_ri1         ? ri1 :
			is_di1         ? di1/2 :
			is_ri          ? ri :
			is_di          ? di/2 :
			is_ro1 && is_w ? ro1-w :
			is_do1 && is_w ? do1/2-w :
			is_ro  && is_w ? ro-w :
			is_do  && is_w ? do/2-w :
				1
		,_ri2 =
			is_ri2         ? ri2 :
			is_di2         ? di2/2 :
			is_ri          ? ri :
			is_di          ? di/2 :
			is_ro2 && is_w ? ro2-w :
			is_do2 && is_w ? do2/2-w :
			is_ro  && is_w ? ro-w :
			is_do  && is_w ? do/2-w :
				1
		,_ro1 =
			is_ro1         ? ro1 :
			is_do1         ? do1/2 :
			is_ro          ? ro :
			is_do          ? do/2 :
			is_ri1 && is_w ? ri1+w :
			is_di1 && is_w ? di1/2+w :
			is_ri  && is_w ? ri+w :
			is_di  && is_w ? di/2+w :
				2
		,_ro2 =
			is_ro2         ? ro2 :
			is_do2         ? do2/2 :
			is_ro          ? ro :
			is_do          ? do/2 :
			is_ri2 && is_w ? ri2+w :
			is_di2 && is_w ? di2/2+w :
			is_ri  && is_w ? ri+w :
			is_di  && is_w ? di/2+w :
				2
	)
	[_ri1, _ri2, _ro1, _ro2]
;

// gibt [rotations, pitch] einer Helix zurück
// Argumente:
//   rotations - Anzahl der Umdrehungen
//   pitch     - Höhenunterschied je Umdrehung
//   height    - Höhe der Helix
function parameter_helix_to_rp (rotations, pitch, height) =
	let(
		is_rotations = rotations!=undef && is_num(rotations),
		is_pitch     = pitch    !=undef && is_num(pitch),
		is_height    = height   !=undef && is_num(height)
	)
	 (is_pitch  && is_rotations) ? [rotations,    pitch]
	:(is_pitch  && is_height)    ? [height/pitch, pitch]
	:(is_height && is_rotations) ? [rotations,    height/rotations]
	:(is_pitch)     ? [1,         pitch]
	:(is_height)    ? [1,         height]
	:(is_rotations) ? [rotations, 0]
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
//   preset - optional, wird als Radius genommen, wenn nichts passt
// Regeln wie bei cylinder() von OpenSCAD
// - Durchmesser geht vor Radius
// - spezielle Angaben (r1, r2) gehen vor allgemeine Angaben (r)
// - ohne Angabe: r=1
function parameter_cylinder_r (r, r1, r2, d, d1, d2, preset) =
	parameter_cylinder_r_basic (
		r =(d !=undef&&is_num(d ) ? d /2 :  r !=undef&&is_num(r ) ? r  :  undef),
		r1=(d1!=undef&&is_num(d1) ? d1/2 :  r1!=undef&&is_num(r1) ? r1 :  undef),
		r2=(d2!=undef&&is_num(d2) ? d2/2 :  r2!=undef&&is_num(r2) ? r2 :  undef),
		preset=preset)
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
function parameter_circle_r (r, d, default=1) =
	d!=undef&&is_num(d) ? d/2 :
	r!=undef&&is_num(r) ? r :
	default
;

// wandelt das Argument 'size' um in einen Tripel [1,2,3]
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
// wandelt das Argument 'size' um in einen Dupel [1,2]
// aus size=3       wird   [3,3]
// aus size=[1,2]   bleibt [1,2]
function parameter_size_2d (size) =
	(is_list(size) && len(size)>0 && is_num(size[0])) ?
		(is_num(size[1])) ?
		 size          // f([1,2])
		:[size[0], 0]  // f([1])
	:is_num   (size) ?
		[size, size]   // f(1)
	:	[1,1]          // f(undef)
;

// wandelt das Argument 'scale' in einen d-Dimensionalen Vektor um
// 'd' ist standartmäßig 3
// aus scale=3        wird [3,3,3]
// aus size=[1,2,2]   bleibt [1,2,2]
// aus size=[2,2]     wird [2,2,1], fehlende Werte werden mit 1 aufgefüllt
//
// Ist scale=undef wird preset dafür genommen.
// preset als Zahl: alle Werte von scale werden mit dieser Zahl belegt
function parameter_scale (scale, d=3, preset) =
	scale!=undef && scale[0]!=undef ?
		let( len_scale = len(scale) )
		len_scale==d ? scale :
		[ for (i=[0:1:d-1]) (len_scale>i && is_num(scale[i])) ? scale[i] : 1 ]
	:scale!=undef && is_num(scale) ?
		 d==3 ? [scale, scale, scale]
		:d==2 ? [scale, scale]
		:       [ for (i=[0:1:d-1]) scale ]
	:
		 preset==undef    ?
			 d==3 ? [1,1,1]
			:d==2 ? [1,1]
			:       [ for (i=[0:1:d-1]) 1 ]
		:preset[0]!=undef ? preset
		:is_num(preset) ?
			 d==3 ? [preset,preset,preset]
			:d==2 ? [preset,preset]
			:       [ for (i=[0:1:d-1]) preset ]
		:preset
;

// Ausrichtung eines Objekts vom Mittelpunkt aus an der jeweiligen Achse.
// An der jeweiligen Achse können Werte gegeben werden '-1...0...1'.
// - '1' = Ausrichtung des Objekts an der positiven Seite der jeweiligen Achse.
// - '0' = Das Objekt ist an der jeweiligen Achse im Mittelpunkt
// Bei Angabe als Zahlwert wird jede Achse auf diese Ausrichtung gesetzt.
// [0,0,0] ist wie center=true, Standartverhalten ist center=false, angegeben in preset.
// Angabe von 'align' überschreibt Angabe 'center'.
function parameter_align (align, preset, center) =
	 preset==undef ?
		align==undef  ? [0,0,0] :
		is_num(align) ? [align,align,align] :
		align
	:align==undef ?
		center!=undef ?
			center==true ? [for (i=[0:1:len(preset)-1]) 0 ]
			:              preset
		:	preset
	:is_num(align) ?
		[for (e=preset) align ]
	:[for (i=[0:1:len(preset)-1])
		align[i]==undef ? preset[i]
		:                 align[i]
	]
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
//                - Zahl  = Positionsangabe, einen Wert nehmen aus `value` an
//                          dieser Positionsangabe und die Liste damit auffüllen.
//                          Geht das nicht, wird 'preset' genommen
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
function parameter_angle (angle, angle_std=360) =
	is_num (angle) ?    [angle   , 0] :
	is_list(angle) ?
		len(angle)==2 ? angle         :
		len(angle)==1 ? [angle[0], 0] :
		len(angle) >2 ? [angle[0], angle[1]] :
		parameter_angle (angle_std, [360,0]) :
	parameter_angle     (angle_std, [360,0])
;

function parameter_slices_circle (slices, r=1, angle=360, piece=true) =
	slices==undef ? get_slices_circle_current  (r,angle,piece) :
	slices=="x"   ? get_slices_circle_current_x(r,angle,piece) :
	slices<2 ?
		(piece==true || piece==0) ? 1 : 2
	:slices
;
function parameter_slices_circle_x (slices, r=1, angle=360, piece=true) =
	slices==undef ? get_slices_circle_current_x (r,angle,piece) :
	parameter_slices_circle (slices, r, angle, piece)
;

// test and may load default for vector in mirror function
function parameter_mirror_vector_2d (v, v_std=[1,0]) =
	(v!=undef && len(v)>=2) ? v : v_std
;
function parameter_mirror_vector_3d (v, v_std=[1,0,0]) =
	 v==undef  ? v_std
	:len(v)==3 ? v
	:len(v) >3 ? [v[0],v[1],v[2]]
	:len(v)==2 ? [v[0],v[1],0]
	:v_std
;

// Stellen die Parameter für die Kanten und Ecken vom Module cube_fillet() ein.
function parameter_edges_cube (edges) =
	parameter_edges_radius (edges, undef, 12)
;
function parameter_types_cube (types) =
	parameter_types (types, undef, 12)
;
function parameter_corner_cube (corner) =
	parameter_edges_radius (corner, undef, 8)
;


// Wertet die Parameter edges_xxx vom Module cube_fillet() aus,
// gibt eine 4 elementige Liste zurück
// Argumente:
//   r         - Radius oder Breite aller Kanten
//   edge_list - 4-elementige Auswahlliste der jeweiligen Kanten,
//             - wird mit r multipliziert sofern angegeben
//             - als Zahl werden alle Kanten auf diesen Wert gesetzt
//             - ist edge_list undefiniert und r angegeben, werden alle Kanten auf r gesetzt
//             - andernfalls wird der Wert auf 0 gesetzt = nicht gefaste Kante
//   n         - Es kann hier eine andere Elementanzahl als standardmäßig 4 angegeben werden
function parameter_edges_radius (edge_list, r, n=4) =
	is_list(edge_list) ?
		[ for (i=[0:1:n-1]) parameter_edge_radius (edge_list[i], r) ]
	:is_num(edge_list) ?
		[ for (i=[0:1:n-1]) parameter_edge_radius (edge_list,    r) ]
	:(edge_list==undef) && is_num(r) ?
		[ for (i=[0:1:n-1]) r ]
	:	[ for (i=[0:1:n-1]) 0 ]
;
function parameter_edge_radius (edge, r) =
	is_num(edge) ?
		is_num(r) ? edge * r
		:           edge
	: 0
;

// Wertet die Parameter type_xxx vom Module cube_fillet() aus,
// gibt eine 4 elementige Liste zurück
// Argumente:
//   type_list - 4 elementige Liste mit den Typ der jeweiligen Ecke
//             - als einzelner Typ = dieser Wert wird für alle Elemente genommen
//             - als Liste = fehlerhafte Werte werden mit 'type' ersetzt
//   type      - vordefinierter Typ einer Ecke, Standart = keine Ecke
//   n         - Es kann hier eine andere Elementanzahl als standardmäßig 4 angegeben werden
function parameter_types (type_list, type, n=4) =
	is_list(type_list) ?
		[ for (i=[0:1:n-1]) parameter_type (type_list[i], type) ]
	:	[ for (i=[0:1:n-1]) parameter_type (type_list,    type) ]
;
function parameter_type (type_x, type) =
	 (type_x == undef) ? parameter_type (type, 0)
	:(type_x < 0     ) ? parameter_type (type, 0)
	: type_x
;
