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
		translate([R,R,0       ]) cube(size=[Size[0]-2*R, Size[1]-2*R, Size[2]]);
		
		// Rundungen in der z-Achse; [x,y,z]
		translate([R        ,        R,-offset]) scale([1,scale_y,1])  cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([R        ,Size[1]-R,-offset]) scale([1,scale_y,1])  cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([Size[0]-R,        R,-offset]) scale([1,scale_y,1])  cylinder_rounded(r=R, h=Size[2]+2*offset);
		translate([Size[0]-R,Size[1]-R,-offset]) scale([1,scale_y,1])  cylinder_rounded(r=R, h=Size[2]+2*offset);
		//
		mirror([0,1,0]) rotate([90,0,0]) union ()
		{ // Rundungen in der y-Achse; [x,z,y]
		translate([R        ,        R-offset,R]) rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([R        ,Size[2]-R+offset,R]) rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([Size[0]-R,        R-offset,R]) rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		translate([Size[0]-R,Size[2]-R+offset,R]) rotate([0,0,90+segment_angle]) cylinder(r=r_polar, h=Size[1]-2*R);
		}
		//
		mirror([0,0,1]) rotate([0,90,0]) union ()
		{ // Rundungen in der x-Achse; [z,y,x]
		translate([R-offset        ,        R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([R-offset        ,Size[1]-R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([Size[2]-R+offset,        R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		translate([Size[2]-R+offset,Size[1]-R,R]) rotate([0,0,segment_angle]) cylinder(r=r_polar, h=Size[0]-2*R);
		}
	}
}

// Quader mit abgerundeten Kanten, alle Kanten mit gleichen Radius/Durchmesser
// Argumente:
//   size          - Größe des Quaders wie bei cube()
//   r, d          - Radius,Durchmesser der Kanten
//   edges_xxx     - Angabe, welche Kanten abgerundet sein sollen
//                   0  = nicht abgerundet
//                   1  = abgerundet
//                   andere Zahl = Radius wird um diese Zahl vergrößert
//                   [x0(->x1), x1(->y1), y1(->y0), y0(->x0)]  -> bottom, top
//                   [x0      , x1      , y1      , y0      ]  -> side
//                             y
//                      y0     |     y1
//                       +-----|-----+
//                       |     |     |
//                   ----------+--------->x
//                       |     |     |
//                       +-----|-----+
//                      x0     |     x1
//
//   edges_bottom  - alle 4 Kanten am Boden
//   edges_top     - alle 4 Kanten oben
//   edges_side    - alle 4 Kanten an der Seite (vertikal)
// TODO Noch nicht implementiert:
//   corner_xxx    - Angabe, welche Ecken abgerundet sein sollen
//                   0  = nicht abgerundet
//                   1  = abgerundet
//                   [x0, x1, y1, y0]  -> bottom, top
//   corner_bottom - alle 4 Ecken am Boden
//   corner_top    - alle 4 Ecken oben
module cube_rounded (size, r, edges_bottom=[1,1,1,1],  edges_top=[1,1,1,1], edges_side=[1,1,1,1],
                             corner_bottom=[1,1,1,1], corner_top=[1,1,1,1],
                     center=false, d)
{
	R    = parameter_circle_r(r, d);
	Size = parameter_size_3d (size);
	
	center_offset = (center==false) ? [0,0,0] : [-Size[0]/2, -Size[1]/2, -Size[2]/2];
	
	render()
	translate(center_offset) difference()
	{
		cube (size=Size);
		
		union ()
		{ // Rundungen in der Seite (edges_side)
		translate([0      ,0      ]) rotate_z(  0) cut_edge_round(h=Size[2], r=R*edges_side[0]);
		translate([Size[0],0      ]) rotate_z( 90) cut_edge_round(h=Size[2], r=R*edges_side[1]);
		translate([Size[0],Size[1]]) rotate_z(180) cut_edge_round(h=Size[2], r=R*edges_side[2]);
		translate([0      ,Size[1]]) rotate_z(270) cut_edge_round(h=Size[2], r=R*edges_side[3]);
		}
		union ()
		{ // Rundungen auf dem Boden (edges_bottom)
		translate([0      ,0      ]) rotate_z(  0) rotate_y(90)rotate_z(90) cut_edge_round (h=Size[0], r=R*edges_bottom[0]);
		translate([Size[0],0      ]) rotate_z( 90) rotate_y(90)rotate_z(90) cut_edge_round (h=Size[1], r=R*edges_bottom[1]);
		translate([Size[0],Size[1]]) rotate_z(180) rotate_y(90)rotate_z(90) cut_edge_round (h=Size[0], r=R*edges_bottom[2]);
		translate([0      ,Size[1]]) rotate_z(270) rotate_y(90)rotate_z(90) cut_edge_round (h=Size[1], r=R*edges_bottom[3]);
		}
		union ()
		{ // Rundungen auf der Dachseite (edges_top)
		translate([0      ,0      ]) rotate_z(  0) translate_z(Size[2])rotate_y(90) cut_edge_round (h=Size[0], r=R*edges_top[0]);
		translate([Size[0],0      ]) rotate_z( 90) translate_z(Size[2])rotate_y(90) cut_edge_round (h=Size[1], r=R*edges_top[1]);
		translate([Size[0],Size[1]]) rotate_z(180) translate_z(Size[2])rotate_y(90) cut_edge_round (h=Size[0], r=R*edges_top[2]);
		translate([0      ,Size[1]]) rotate_z(270) translate_z(Size[2])rotate_y(90) cut_edge_round (h=Size[1], r=R*edges_top[3]);
		}
	}
}


// Zylinder mit abgerundeten Enden
module cylinder_rounded (h=3, r, center=false, d)
{
	R = parameter_circle_r (r, d);
	//
	translate([0,0, get_center_z(center,-h/2)])
	union ()
	{
		if (h <= 2*R) scale([1,1,h/(2*R)]) translate([0,0,R]) sphere (R);
		else union()
			{
				fn      = get_fn_circle_current (R);
				fn_polar= ceil(fn / 2) * 2;
				r_polar = (fn_polar/2 % 2) ? R : R * 1/cos(180/fn_polar);
				//
				translate([0,0,R])   sphere   (r_polar);
				translate([0,0,R])   cylinder (r=R, h=h-2*R);
				translate([0,0,h-R]) sphere   (r_polar);
			}
	}
}

// Zylinder mit abgerundeten Kanten, mit angegebenen Radius
module cylinder_edges_rounded (h=1, r, r_bottom=0, r_top=0, center=false, d)
{
	R = parameter_circle_r (r, d);
	fn=get_fn_circle_current (R);
	segment_angle = (fn % 2) ? 180/fn : 0;
	//
	translate([0,0, get_center_z(center,-h/2) ])
	difference()
	{
		cylinder (r=R, h=h);
		union()
		{
			if (r_bottom > 0)
			{
				fn_ring=ceil((get_fn_circle_current(r_bottom) - 1) / 4) * 4;
				//
				difference()
				{
					translate([0,0,-extra])  ring_square (ro=R+extra, ri=R-r_bottom, h=r_bottom+extra, $fn=fn);
					translate([0,0,r_bottom]) rotate([0,0,segment_angle])
						torus (r=R-r_bottom, w=r_bottom*2-epsilon, center=true, fn_ring=fn_ring);
				}
			}
			if (r_top > 0)
			{
				fn_ring=ceil((get_fn_circle_current(r_top) - 1) / 4) * 4;
				//
				difference()
				{
					translate([0,0,h-r_top]) ring_square (ro=R+extra, ri=R-r_top, h=r_top+extra, $fn=fn);
					translate([0,0,h-r_top]) rotate([0,0,segment_angle])
						torus (r=R-r_top, w=r_top*2-epsilon, center=true, fn_ring=fn_ring);
				}
			}
		}
	}
}

// erzeugt eine abgerundete Ecke zum Auschneiden
// Argumente:
//   h       Höhe der Kante
//   r, d    Radius oder Durchmesser der Rundung
//   angle   Winkel der Ecke, Standart=90° (rechter Winkel)
//   extra   zusätzlichen Überstand abschneiden, wegen Z-Fighting
module cut_edge_round (h=1, r, angle=90, extra=extra, d)
{
	R        = parameter_circle_r(r, d);
	t_factor = sin(90-angle/2) / sin(angle/2);
	//
	if (R>0)
	linear_extrude(height=h, convexity=2)
	polygon( concat(
		translate_list(
			circle_curve(r=R, angle=180-angle, angle_begin=90+angle, piece=0)
			,[R*t_factor,R]
		)
		,[
			 [ R    *t_factor,-extra]
			,[-extra*t_factor,-extra]
			,translate_list(
				[circle_point(r=R+extra, angle=90+angle)]
				,[R*t_factor,R]
			)[0]
		]
	));
}

// erzeugt eine abgeschrägte Kante zum Auschneiden
// Argumente:
//   h       Höhe der Kante
//   size    Breite der Schräge
//   angle   Winkel der Ecke, Standart=90° (rechter Winkel)
//   extra   zusätzlichen Überstand abschneiden, wegen Z-Fighting
module cut_edge_chamfer (h=1, size, angle=90, extra=extra)
{
	t       = size/2 / sin(angle/2);
	h_extra = extra * cot(angle/2);
	//
	if (size>0)
	linear_extrude(height=h, convexity=2)
	polygon([
		 [ t,       0]
		,[ t      ,-extra]
		,[-h_extra,-extra]
		,translate_list(
			[circle_point(r=t+h_extra, angle=angle)]
			,[-h_extra,-extra]
		)[0]
		,circle_point(r=t, angle=angle)
	]);
}
