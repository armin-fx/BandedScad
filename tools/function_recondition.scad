// function_recondition.scad
//
// Enthält Funktionen zum Bearbeiten, Auswählen und Reparieren von Argumenten


function repair_matrix_3d (m) =
	fill_matrix_with (m, unit_matrix(4))
;
function repair_matrix_2d (m) =
	fill_matrix_with (m, unit_matrix(3))
;

function fill_matrix_with (m, c) =
	!is_list(m) ? c :
	[ for (i=[0:len(c)-1])
		[ for (j=[0:len(c[i])-1])
			is_num(m[i][j]) ? m[i][j] : c[i][j]
		]
	]
;
function fill_list_with (l, c) =
	!is_list(l) ? c :
	[ for (i=[0:len(c)-1])
		is_num(l[i]) ? l[i] : c[i]
	]
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

function parameter_mirror_vector_2d (v, v_std=[1,0]) =
	(is_list(v) && len(v)>=2) ? v : v_std
;
function parameter_mirror_vector_3d (v, v_std=[1,0,0]) =
	 !is_list(v) ? v_std
	:len(v)>=3   ? v
	:len(v)==2   ? [v[0],v[1],0]
	:v_std
;
