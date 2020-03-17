// function_helper.scad
//
// interne Hilfsfunktionen


// extrahiert eine Dimension aus einer Liste
// extract_dimension(list=[[x,y,z], [1,2,3], [11,12,13]], axis=1) => [y,2,12]
//                            ^        ^          ^                   ^ ^  ^ 
function extract_dimension (list, axis) = [ for (n=list) n[axis] ];

// gibt den größten Abstand der einzelnen Werte innerhalb einer Liste zurück
function diff_list     (list) = max(list) - min(list);
// gibt den größten Abstand der einzelnen Werte aller Dimensionen
function diff_list_all (list) = [
	for (axis=[0 : len(list[0])-1]) diff_list(extract_dimension(list, axis))
];
// gibt die maximal mögliche Raumdiagonale zurück
function max_norm (list) = norm(diff_list_all(list));

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

// extrahiert eine Sequenz aus der Liste
// Angaben:
//     list  = Liste mit der enthaltenen Sequenz
//     begin = erstes Element aus der Liste
//     end   = letztes Element
// oder
//     range = [begin, last]
// Kodierung wie in python
function extract_list (list, begin, last, range) =
	[for (i=[
		get_position(list, get_first_good(begin,range[0], 0))
		:1:
		get_position(list, get_first_good(last ,range[1],-1))
		]) list[i]]
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
function get_first_good    (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 0)
;

// gibt einen Wert für mehrere gleiche Parameter zurück
// Die Parameter sind hier 1-Dimensionale Vektoren
// Alle einzelnen Parameter im Vektor müssen einen Wert haben, um akzeptiert zu werden.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist.
function get_first_good_1d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 1)
;

// gibt einen Wert für mehrere gleiche Parameter zurück
// Die Parameter sind hier 2-Dimensionale Vektoren
// Alle 2 Parameter im Vektor müssen einen Wert haben, um akzeptiert zu werden.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist.
function get_first_good_2d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 2)
;

// gibt einen Wert für mehrere gleiche Parameter zurück
// Die Parameter sind hier 3-Dimensionale Vektoren
// Alle 3 Parameter im Vektor müssen einen Wert haben, um akzeptiert zu werden.
// Sind mehrere Parameter gesetzt, wird der erste genommen, der gesetzt ist.
function get_first_good_3d (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =
	 get_first_good_in_list ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9], 3)
;

// gibt das erste gültige Element in der Liste zurück
// Es wird das erste Element genommen, das alle Bedingungen erfüllt.
// Begingungen:
//  - Element ist nicht undef
//  - Element ist eine Liste mit (mindestens) <dimension> Elementen
//    mit gültigen Werten
//  - wenn dimension==0 ist das Element eine gültiger Wert
//  - ein gültiger Wert: -> nicht undef
// Argumente:
//   list      - Liste mit den Elementen
//   dimension - Element muss eine Liste sein mit dieser Größe
//               wenn 0, dann muss das Element eine Zahl sein und keine Liste
//   begin     - ab dieser Position wird getestet
function get_first_good_in_list (list, dimension=0, begin=0) =
	 (len(list)  ==undef) ? undef
	:(len(list)-1 <begin) ? undef
	:(dimension==0) ?
		(list[begin]==undef) ? get_first_good_in_list(list, dimension, begin+1)
		:	list[begin]
	  :
		 (list[begin]==undef)                           ? get_first_good_in_list(list, dimension, begin+1)
		:(!is_good_value_list(list[begin],0,dimension)) ? get_first_good_in_list(list, dimension, begin+1)
		:	list[begin]
;

// testet eine Liste durch, ob alle Werte darin nicht undef sind
// gibt true zurück bei Erfolg
// Argumente:
//  - list    - Liste mit den Werten
//  - begin   - das erste Element das getestet wird
//  - end     - das erste Element das nicht mehr getestet wird
function is_good_value_list (list, begin=0, end=undef) =
	 (list==undef)   ? false
	:(begin==undef)  ? false
	:(end==undef)    ? is_good_value_list (list, begin, len(list))
	:(len(list)<end) ? false
	:(begin>=end)    ? true
	:(list[begin]==undef) ? false
	:(len(list)<end) ? false
	:is_good_value_list (list, begin+1, end)
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
		r =get_first_good(d /2,  r),
		w =w,
		r1=get_first_good(d1/2, r1),
		r2=get_first_good(d2/2, r2)
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
function parameter_cylinder_r (r, r1, r2, d, d1, d2) =
	parameter_cylinder_r_basic (
		get_first_good(d /2, r),
		get_first_good(d1/2, r1),
		get_first_good(d2/2, r2))
;
function parameter_cylinder_r_basic (r, r1, r2) =
	get_first_good_2d (
		[r1,r2],
		[r1,r ],
		[r, r2],
		[r, r ],
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

// wandelt das Argument um in einen Tupel [1,2,3]
// aus size=3       wird   [3,3,3]
// aus size=[1,2,3] bleibt [1,2,3]
function parameter_size_3d (size) =
	 (size   ==undef) ?	[1,1,1] // f(undef)
	:(size[2]==undef) ?
	 (size[1]==undef) ?
	 (size[0]==undef) ?
	 [size   ,    size, size] // f(1)
	:[size[0],       0,    0] // f([1])
	:[size[0], size[1],    0] // f([1,2])
	:size                     // f([1,2,3])
;

function get_circle_fudge (fn, scale=1) = scale/cos(180/fn) + 1-scale;

// gibt einen Wert in der z-Achse zurück, wenn center gesetzt ist (true)
function get_center_z (center, z_true=0, z_false=0) = (center) ? z_true : z_false;

// function returns value and echo a message if version of OpenSCAD is 2019.05 or greater
function do_echo (value, message) =
	version_num()<20190500 ? value
	: echo(message) + value
;

