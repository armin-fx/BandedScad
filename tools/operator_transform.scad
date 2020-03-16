// operator_transform.scad
//
// Enthält zusätzliche Operatoren zum Transformieren von Objekten
//
// Aufbau: modul() {Objekt();}


// Spiegelt an der jeweiligen Achse wie die Hauptfunktionen
module mirror_x () { mirror([1,0,0]) children(); }
module mirror_y () { mirror([0,1,0]) children(); }
module mirror_z () { mirror([0,0,1]) children(); }
//
module mirror_copy_x () { mirror_copy([1,0,0]) children(); }
module mirror_copy_y () { mirror_copy([0,1,0]) children(); }
module mirror_copy_z () { mirror_copy([0,0,1]) children(); }
//
module mirror_at_x (p=[0,0,0]) { mirror_at([1,0,0], p) children(); }
module mirror_at_y (p=[0,0,0]) { mirror_at([0,1,0], p) children(); }
module mirror_at_z (p=[0,0,0]) { mirror_at([0,0,1], p) children(); }
//
module mirror_copy_at_x (p=[0,0,0]) { mirror_copy_at([1,0,0], p) children(); }
module mirror_copy_at_y (p=[0,0,0]) { mirror_copy_at([0,1,0], p) children(); }
module mirror_copy_at_z (p=[0,0,0]) { mirror_copy_at([0,0,1], p) children(); }

// erzeugt ein Objekt und ein gespiegeltes Objekt
module mirror_copy (v=[1,0,0])
{
	children(0);
	mirror(v)
	children(0);
}

// erzeugt ein gespiegeltes Objekt
// Spiegel an Position p
module mirror_at (v=[1,0,0], p=[0,0,0])
{
	translate(p)
	mirror(v)
	translate(-p)
	children(0);
}

// erzeugt ein Objekt und ein gespiegeltes Objekt
// Spiegel an Position p
module mirror_copy_at (v=[1,0,0], p=[0,0,0])
{
	children(0);
	mirror_at(v, p)
	children(0);
}

// spiegelt ein Objekt mehrfach (bis zu 3 mal) hintereinander
module mirror_repeat (v=[1,0,0], v2=undef, v3=undef)
{
	mirror(v) mirror_check(v2) mirror_check(v3) children(0);
}

// erzeugt ein Objekt und ein gespiegeltes Objekt
// spiegelt das Objekt mehrfach (bis zu 3 mal) hintereinander
module mirror_repeat_copy (v=[1,0,0], v2=undef, v3=undef)
{
	children(0);
	mirror(v) mirror_check(v2) mirror_check(v3) children(0);
}

module mirror_check (v)
{
	if (v==undef)  children(0);
	else mirror(v) children(0);
}

// rotiert ein Objekt rückwärts
// Argumente wie bei rotate()
module rotate_backwards (a, v=undef)
{
	if (is_list(a))
		rotate_x(-a[0]) rotate_y(-a[1]) rotate_z(-a[2]) children(0);
	else if (is_num(a))
		rotate(-a,v) children(0);
	else
		children(0);
}

// rotiert ein Objekt an der angegebenen Position
// Argumente:
// a, (v) - wie bei rotate()
// p      - wie bei translate()
module rotate_at (a=[0,0,0], p=[0,0,0], v=undef)
{
	translate(p)
	rotate(a, v)
	translate(-p)
	children(0);
}

// rotiert ein Objekt rückwärts an der angegebenen Position
// Argumente wie rotate_at()
// a, (v) - wie bei rotate()
// p      - wie bei translate()
module rotate_backwards_at (a=[0,0,0], p=[0,0,0], v=undef)
{
	translate(p)
	rotate_backwards(a, v)
	translate(-p)
	children(0);
}

// Objekt von in Richtung Z-Achse in Richtung Vektor v drehen
// a = Objekt um die eigene Achse drehen
module rotate_to_vector (v=[0,0,1], a=0)
{
	b = acos(v[2]/norm(v)); // inclination angle
	c = atan2(v[1],v[0]);   // azimuthal angle
	
	rotate([0, b, c]) rotate_z(a) children(0);
}
// Objekt von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
module rotate_backwards_to_vector (v=[0,0,1], a=0)
{
	b = acos(v[2]/norm(v)); // inclination angle
	c = atan2(v[1],v[0]);   // azimuthal angle
	
	rotate_backwards_z(a) rotate_backwards([0, b, c]) children(0);
}

// Objekt von in Richtung Z-Achse in Richtung Vektor v drehen an der angegebenen Position
module rotate_to_vector_at (v=[0,0,1], p=[0,0,0], a=0)
{
	translate(p)
	rotate_to_vector(v, a)
	translate(-p)
	children(0);
}
// Objekt von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen an der angegebenen Position
module rotate_backwards_to_vector_at (v=[0,0,1], p=[0,0,0], a=0)
{
	translate(p)
	rotate_backwards_to_vector(v, a)
	translate(-p)
	children(0);
}

// rotiert um die jeweilige Achse wie die Hauptfunktion
module rotate_x (a) { rotate([a,0,0]) children(0); }
module rotate_y (a) { rotate([0,a,0]) children(0); }
module rotate_z (a) { rotate([0,0,a]) children(0); }
//
module rotate_backwards_x (a) { rotate_backwards([a,0,0]) children(0); }
module rotate_backwards_y (a) { rotate_backwards([0,a,0]) children(0); }
module rotate_backwards_z (a) { rotate_backwards([0,0,a]) children(0); }
//
module rotate_at_x (a, p=[0,0,0]) { rotate_at([a,0,0], p) children(0); }
module rotate_at_y (a, p=[0,0,0]) { rotate_at([0,a,0], p) children(0); }
module rotate_at_z (a, p=[0,0,0]) { rotate_at([0,0,a], p) children(0); }
//
module rotate_backwards_at_x (a, p=[0,0,0]) { rotate_backwards_at([a,0,0], p) children(0); }
module rotate_backwards_at_y (a, p=[0,0,0]) { rotate_backwards_at([0,a,0], p) children(0); }
module rotate_backwards_at_z (a, p=[0,0,0]) { rotate_backwards_at([0,0,a], p) children(0); }

// verschiebt in der jeweiligen Achse wie die Hauptfunktion
module translate_x  (l) { translate([l,0,0]) children(0); }
module translate_y  (l) { translate([0,l,0]) children(0); }
module translate_z  (l) { translate([0,0,l]) children(0); }
module translate_xy (t) { translate([t[0],t[1],0]) children(0); }

