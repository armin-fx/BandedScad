// object_rounded.scad
//
// Enthält einige Objekte mit abgerundeten Ecken


// Quader mit abgerundeten Kanten, alle Kanten mit gleichen Radius/Durchmesser
// Argumente:
//   size         - Größe des Quaders wie bei cube()
//   r, d         - Radius,Durchmesser der Kanten
//   center
module cube_rounded_full (size, r, center=false, d)
{
	// TODO interne Tests der Argumente auf Plausibilität fehlen
	R    = parameter_circle_r(r, d);
	Size = parameter_size_3d (size);
	
	center_offset = (center==false) ? [0,0,0] : [-Size[0]/2, -Size[1]/2, -Size[2]/2];
	
	fn=get_fn_circle_current (R);
	fn_polar=ceil(fn / 2) * 2;
	//
	segment_angle = 180/fn_polar;
	fudge_polar = 1/cos(180/fn_polar);
	scale_y = (fn_polar/2 % 2) ? fudge_polar : 1;
	r_polar = (fn_polar/2 % 2) ? R : R * fudge_polar;
	offset  = (fn_polar/2 % 2) ? R * (1/cos(180/(fn_polar)) - 1) * cos(180/(fn_polar)) : 0;
	
	translate(center_offset) union()
	{
		$fn=fn_polar;
		// Quader ohne die Rundungen
		translate([0,R,R-offset]) cube(size=[Size[0]    , Size[1]-2*R, Size[2]-2*R+2*offset]);
		translate([R,0,R-offset]) cube(size=[Size[0]-2*R, Size[1]    , Size[2]-2*R+2*offset]);
		translate([R,R,0])        cube(size=[Size[0]-2*R, Size[1]-2*R, Size[2]]);
		
		// Rundungen in der z-Achse; [x,y,z]
		translate([R,        R,-offset])         scale([1,scale_y,1])  cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([R,Size[1]-R,-offset])         scale([1,scale_y,1])  cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([Size[0]-R,        R,-offset]) scale([1,scale_y,1])          cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([Size[0]-R,Size[1]-R,-offset]) scale([1,scale_y,1])          cylinder_rounded(r=R, h=Size[2]+2*offset);
		//
		mirror([0,1,0]) rotate([90,0,0]) union ()
		{ // Rundungen in der y-Achse; [x,z,y]
		translate([R,R-offset,R])                 rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([R,Size[2]-R+offset,R])         rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([Size[0]-R,R-offset,R])         rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([Size[0]-R,Size[2]-R+offset,R]) rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		}
		//
		mirror([0,0,1]) rotate([0,90,0]) union ()
		{ // Rundungen in der x-Achse; [z,y,x]
		translate([R-offset,        R,R])         rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([R-offset,Size[1]-R,R])         rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([Size[2]-R+offset,        R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([Size[2]-R+offset,Size[1]-R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		}
	}
}

// Quader mit abgerundeten Kanten, alle Kanten mit gleichen Radius/Durchmesser
// Argumente:
//   size         - Größe des Quaders wie bei cube()
//   r, d         - Radius,Durchmesser der Kanten
//   edges_xxx    - Angabe, welche Kanten abgerundet sein sollen
//                  0           = nicht abgerundet
//                  1           = abgerundet
//             TODO andere Zahl = Radius wird um diese Zahl vergrößert
//                  [x0(->x1), x1(->y1), y1(->y0), y0(->x0)]
//                            y
//                     x0     |     y1
//                      +-----|-----+
//                      |     |     |
//                  ----------+--------->x
//                      |     |     |
//                      +-----|-----+
//                     x0     |     x1
//
//   edges_bottom - alle 4 Kanten am Boden
//   edges_top    - alle 4 Kanten oben
//   edges_side   - alle 4 Kanten an der Seite (vertikal)
module cube_rounded (size, r, edges_bottom=[1,1,1,1], edges_top=[1,1,1,1], edges_side=[1,1,1,1], center=false, d)
{
	// TODO interne Tests der Argumente auf Plausibilität
	R    = parameter_circle_r(r, d);
	Size = parameter_size_3d (size);
	
	center_offset = (center==false) ? [0,0,0] : [-Size[0]/2, -Size[1]/2, -Size[2]/2];
	
	fn=get_fn_circle_current (R);
	fn_polar=ceil(fn / 2) * 2;
	//
	segment_angle = 180/fn_polar;
	fudge_polar = 1/cos(180/fn_polar);
	scale_y = (fn_polar/2 % 2) ? fudge_polar : 1;
	r_polar = (fn_polar/2 % 2) ? R : R * fudge_polar;
	offset  = (fn_polar/2 % 2) ? R * (1/cos(180/(fn_polar)) - 1) * cos(180/(fn_polar)) : 0;
	
	translate(center_offset) union()
	{
		
		//cube (size=Size);
		
		
		union ()
		{ // Rundungen in der z-Achse; [x,y,z]
		$fn = fn_polar;
		translate([R,        R,-offset])         scale([1,scale_y,1]) mirror() cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([R,Size[1]-R,-offset])         scale([1,scale_y,1]) mirror() cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([Size[0]-R,        R,-offset]) scale([1,scale_y,1])          cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([Size[0]-R,Size[1]-R,-offset]) scale([1,scale_y,1])          cylinder_rounded(r=R, h=Size[2]+2*offset);
		}
		
		*mirror([0,1,0]) rotate([90,0,0])
		union ()
		{ // Rundungen in der y-Achse; [x,z,y]
		$fn=fn_polar;
		translate([R,R-offset,R])                 rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([R,Size[2]-R+offset,R])         rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([Size[0]-R,R-offset,R])         rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([Size[0]-R,Size[2]-R+offset,R]) rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		}
		
		mirror([0,0,1]) rotate([0,90,0])
		union ()
		{ // Rundungen in der x-Achse; [z,y,x]
		$fn=fn_polar;
		translate([R-offset,        R,R])         rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([R-offset,Size[1]-R,R])         rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([Size[2]-R+offset,        R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([Size[2]-R+offset,Size[1]-R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		}
	}
}


// Zylinder mit abgerundeten Enden
module cylinder_rounded (h=3, r, center=false, d)
{
	r = parameter_circle_r (r, d);
	//
	translate([0,0, get_center_z(center,-h/2)])
	union ()
	{
		if (h <= 2*r) scale([1,1,h/(2*r)]) translate([0,0,r]) sphere (r);
		else union()
			{
				fn      = get_fn_circle_current (r);
				fn_polar= ceil(fn / 2) * 2;
				r_polar = (fn_polar/2 % 2) ? r : r * 1/cos(180/fn_polar);
				//
				translate([0,0,r])   sphere   (r_polar);
				translate([0,0,r])   cylinder (r=r, h=h-2*r);
				translate([0,0,h-r]) sphere   (r_polar);
			}
	}
}

// Zylinder mit abgerundeten Kanten, mit angegebenen Radius
module cylinder_edges_rounded (h=1, r, r_bottom=0, r_top=0, center=false, d)
{
	r = parameter_circle_r (r, d);
	fn=get_fn_circle_current (r);
	segment_angle = (fn % 2) ? 180/fn : 0;
	//
	translate([0,0, get_center_z(center,-h/2) ])
	difference()
	{
		cylinder (r=r, h=h);
		union()
		{
			if (r_bottom > 0)
			{
				fn_ring=ceil((get_fn_circle_current(r_bottom) - 1) / 4) * 4;
				//
				difference()
				{
					translate([0,0,-extra])  ring_square (ro=r+extra, ri=r-r_bottom, h=r_bottom+extra, $fn=fn);
					translate([0,0,r_bottom]) rotate([0,0,segment_angle])
						torus (r=r-r_bottom, w=r_bottom*2-epsilon, center=true, fn_ring=fn_ring);
				}
			}
			if (r_top > 0)
			{
				fn_ring=ceil((get_fn_circle_current(r_top) - 1) / 4) * 4;
				//
				difference()
				{
					translate([0,0,h-r_top]) ring_square (ro=r+extra, ri=r-r_top, h=r_top+extra, $fn=fn);
					translate([0,0,h-r_top]) rotate([0,0,segment_angle])
						torus (r=r-r_top, w=r_top*2-epsilon, center=true, fn_ring=fn_ring);
				}
			}
		}
	}
}
