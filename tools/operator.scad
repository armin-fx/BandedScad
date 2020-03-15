// operator.scad
//
// Enthält einige zusätzliche Operatoren
//
// Aufbau: modul() {Objekt(); <Objekt2; ...>}


// Setzt ein Objekt mit anderen Objekten zusammen
//
// Reihenfolge: Hauptobjekt(); zugefuegtes_Objekt(); abzuschneidendes_Objekt(); gemeinsames_Objekt();
//
module build ()
{
	if ($children==0);
	if ($children==1)
		children(0);
	if ($children==2)
		union()
		{
			children(0);
			children(1);
		}
	if ($children==3)
		union()
		{
			difference()
			{
					children(0);
					children(2);
			}
			children(1);
		}
	if ($children==4)
		union()
		{
			difference()
			{
				intersection()
					{
						children(0);
						children(3);
					}
				children(2);
			}
			children(1);
		}
}

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
// angle = Objekt um die eigene Achse drehen
module rotate_to_vector (v=[0,0,1], angle=0)
{
	b = acos(v[2]/norm(v)); // inclination angle
	c = atan2(v[1],v[0]);   // azimuthal angle
	
	rotate([0, b, c]) rotate_z(angle) children(0);
}
// Objekt von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen
module rotate_backwards_to_vector (v=[0,0,1], angle=0)
{
	b = acos(v[2]/norm(v)); // inclination angle
	c = atan2(v[1],v[0]);   // azimuthal angle
	
	rotate_backwards_z(angle) rotate_backwards([0, b, c]) children(0);
}

// Objekt von in Richtung Z-Achse in Richtung Vektor v drehen an der angegebenen Position
module rotate_to_vector_at (v=[0,0,1], p=[0,0,0], angle=0)
{
	translate(p)
	rotate_to_vector(v, angle)
	translate(-p)
	children(0);
}
// Objekt von in Richtung Z-Achse in Richtung Vektor v rückwärts drehen an der angegebenen Position
module rotate_backwards_to_vector_at (v=[0,0,1], p=[0,0,0], angle=0)
{
	translate(p)
	rotate_backwards_to_vector(v, angle)
	translate(-p)
	children(0);
}

// rotiert um die jeweilige Achse wie die Hauptfunktion
module rotate_x (x) { rotate([x,0,0]) children(0); }
module rotate_y (y) { rotate([0,y,0]) children(0); }
module rotate_z (z) { rotate([0,0,z]) children(0); }
//
module rotate_backwards_x (x) { rotate_backwards([x,0,0]) children(0); }
module rotate_backwards_y (y) { rotate_backwards([0,y,0]) children(0); }
module rotate_backwards_z (z) { rotate_backwards([0,0,z]) children(0); }
//
module rotate_at_x (x, p=[0,0,0]) { rotate_at([x,0,0], p) children(0); }
module rotate_at_y (y, p=[0,0,0]) { rotate_at([0,y,0], p) children(0); }
module rotate_at_z (z, p=[0,0,0]) { rotate_at([0,0,z], p) children(0); }
//
module rotate_backwards_at_x (x, p=[0,0,0]) { rotate_backwards_at([x,0,0], p) children(0); }
module rotate_backwards_at_y (y, p=[0,0,0]) { rotate_backwards_at([0,y,0], p) children(0); }
module rotate_backwards_at_z (z, p=[0,0,0]) { rotate_backwards_at([0,0,z], p) children(0); }

// verschiebt in der jeweiligen Achse wie die Hauptfunktion
module translate_x (x) { translate([x,0,0]) children(0); }
module translate_y (y) { translate([0,y,0]) children(0); }
module translate_z (z) { translate([0,0,z]) children(0); }
module translate_xy (t) { translate([t[0],t[1],0]) children(0); }

// Schneidet eine Scheibe aus einem Objekt, geeignet um testweise versteckte Details eines Objekts ansehen zu können
module object_slice (axis=[0,1,0], position=0, thickness=1, height=1000)
{
	trans_side = (thickness>=0) ? 0 : -thickness;
	intersection()
	{
		children();
		//
		if      (axis[0]!=0) translate([position+trans_side,-height/2,-height/2]) cube([abs(thickness),height,height]);
		else if (axis[1]!=0) translate([-height/2,position+trans_side,-height/2]) cube([height,abs(thickness),height]);
		else if (axis[2]!=0) translate([-height/2,-height/2,position+trans_side]) cube([height,height,abs(thickness)]);
	}
}

// create a small pane of an object at given height (Z-axis)
module object_pane (thickness=epsilon*2, size=[1000,1000])
{
	intersection()
	{
		children();
		//
		translate([-size[0]/2,-size[1]/2,-thickness/2])
			cube([size[0],size[1],thickness]);
	}
}


function get_trace_connect(trace) =
	concat ( [trace[len(trace)-1]], trace, [trace[0],trace[1]] )
;
range_connect=[1,-2];
//
function get_angle_between (ratio, a, b) =
	(a+b + ((abs(a-b)<180)?0:360) ) * ratio
;

//
module plain_trace_extrude (trace, range=[0,-1], convexity, lenght=1000, test=false)
{
	if (test) children();
	//
	begin = get_position(trace, range[0]);
	last  = get_position(trace, range[1]) - 1;
	overlap=epsilon;
	//
	for (i=[begin:last])
	{
		difference()
		{
			translate(trace[i])
			rotate([0,0,rotation_vector([0,-1], trace[i+1]-trace[i])])
			rotate([90,0,0]) linear_extrude(height=lenght, center=true, convexity=convexity) children();
			//
			translate(trace[i])
			rotate([0,0,
				(i==0) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i]-trace[i-1]))
			])
			translate([-lenght/2,overlap,-lenght/2]) cube([lenght,lenght,lenght]);
			//
			translate(trace[i+1])
			rotate([0,0,
				(i>=len(trace)-2) ?
					rotation_vector([0,-1], trace[i+1]-trace[i])
				:	get_angle_between(0.5, rotation_vector([0,-1], trace[i+1]-trace[i]), rotation_vector([0,-1], trace[i+2]-trace[i+1]))
			])
			translate([-lenght/2,-lenght-overlap,-lenght/2]) cube([lenght,lenght,lenght]);
		}
	}
}
module plain_trace_connect_extrude (trace, range=[0,-1], convexity, lenght=1000, test=false)
{
	plain_trace_extrude (
		trace=get_trace_connect(extract_list(trace, range=range))
		,range=range_connect, convexity=convexity, lenght=lenght, test=test
	) children();
}

/*
module trace_extrude (trace, rotation, convexity, lenght=1000)
{}
*/
