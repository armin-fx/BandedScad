// object_rounded.scad
//
// Enthält einige Objekte mit abgerundeten Ecken und Kanten


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

// Quader mit gefasten Kanten, wahlweise abgerundet oder angeschrägt
// Argumente:
//   size          - Größe des Quaders wie bei cube()
//   r             - Radius der Kanten oder Breite der Schräge
//   type          - allgemein, welcher Fasentyp für alle Kanten verwendet werden sollen
//                   0 = keine Fase (Standart)
//                   1 = Rundung
//                   2 = Schräge
//   edges_xxx     - Angabe, welche Kanten gefast sein sollen
//                   0  = nicht gefast
//                   1  = gefast
//                   andere Zahl = Radius oder Breite wird um diese Zahl vergrößert
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
//
//   type_xxx      - spezielle Angabe des Fasentyp der jeweiligen Kante
//                   Liste wie bei edges_xxx ([x,x,x,x])
//                   Werte wie bei type (0...1...2)
//                   -1 = Angabe von type nehmen (Standart)
//   type_bottom   - alle 4 Kanten am Boden
//   type_top      - alle 4 Kanten oben
//   type_side     - alle 4 Kanten an der Seite (vertikal)
//
//   center        - wenn true, Quader wird zum Koordinatenursprung zentriert, Standart=false
// TODO Noch nicht implementiert:
//   corner_xxx    - Angabe, welche Ecken gefast sein sollen
//                   0  = nicht gefast
//                   1  = gefast
//                   [x0, x1, y1, y0]  -> bottom, top
//   corner_bottom - alle 4 Ecken am Boden
//   corner_top    - alle 4 Ecken oben
module cube_fillet (size, r, type=0
                   , edges_bottom=[1,1,1,1],   edges_top=[1,1,1,1],   edges_side=[1,1,1,1]
                   ,corner_bottom=[1,1,1,1],  corner_top=[1,1,1,1]
                   ,  type_bottom=[-1,-1,-1,-1],type_top=[-1,-1,-1,-1],type_side=[-1,-1,-1,-1]
                   ,center=false)
{
	Size = parameter_size_3d (size);
	//
	center_offset = (center==false) ? [0,0,0] : [-Size[0]/2, -Size[1]/2, -Size[2]/2];
	//
	Type_bottom = parameter_types (type_bottom, type);
	Type_top    = parameter_types (type_top   , type);
	Type_side   = parameter_types (type_side  , type);
	//
	r_bottom = parameter_edges_radius (edges_bottom, r);
	r_top    = parameter_edges_radius (edges_top   , r);
	r_side   = parameter_edges_radius (edges_side  , r);
	
	module trans_side   ()  {                                  children(); }
	module trans_bottom ()  { rotate_y(90)rotate_z(90)         children(); }
	module trans_top    ()  { translate_z(Size[2])rotate_y(90) children(); }
	//
	module trans_up () { mirror_at_z(Size[2]/2) children(); }
	//
	module trans_0 ()  { translate([0      ,0      ]) rotate_z(  0) children(); }
	module trans_1 ()  { translate([Size[0],0      ]) rotate_z( 90) children(); }
	module trans_2 ()  { translate([Size[0],Size[1]]) rotate_z(180) children(); }
	module trans_3 ()  { translate([0      ,Size[1]]) rotate_z(270) children(); }
	
	//render()
	color("gold")
	translate(center_offset) difference()
	{
		cube (size=Size);
		
		union ()
		{ // Fase in der Seite (edges_side)
		trans_0() trans_side() edge_fillet (h=Size[2], r=r_side[0], type=Type_side[0]);
		trans_1() trans_side() edge_fillet (h=Size[2], r=r_side[1], type=Type_side[1]);
		trans_2() trans_side() edge_fillet (h=Size[2], r=r_side[2], type=Type_side[2]);
		trans_3() trans_side() edge_fillet (h=Size[2], r=r_side[3], type=Type_side[3]);
		}
		union ()
		{ // Fase auf dem Boden (edges_bottom)
		trans_0() trans_bottom() edge_fillet (h=Size[0], r=r_bottom[0], type=Type_bottom[0]);
		trans_1() trans_bottom() edge_fillet (h=Size[1], r=r_bottom[1], type=Type_bottom[1]);
		trans_2() trans_bottom() edge_fillet (h=Size[0], r=r_bottom[2], type=Type_bottom[2]);
		trans_3() trans_bottom() edge_fillet (h=Size[1], r=r_bottom[3], type=Type_bottom[3]);
		}
		union ()
		{ // Fase auf der Dachseite (edges_top)
		trans_0() trans_top() edge_fillet (h=Size[0], r=r_top[0], type=Type_top[0]);
		trans_1() trans_top() edge_fillet (h=Size[1], r=r_top[1], type=Type_top[1]);
		trans_2() trans_top() edge_fillet (h=Size[0], r=r_top[2], type=Type_top[2]);
		trans_3() trans_top() edge_fillet (h=Size[1], r=r_top[3], type=Type_top[3]);
		}
		
		// TODO verschiedene Ecken testen
		union()
		{ // Ecken am Boden
			if (corner_bottom[0]==1) trans_0() corner_fillet_cube(
				r    =[    r_bottom[0],    r_bottom[3],    r_side[0] ],
				types=[ Type_bottom[0], Type_bottom[3], Type_side[0] ]);
			if (corner_bottom[1]==1) trans_1() corner_fillet_cube(
				r    =[    r_bottom[1],    r_bottom[0],    r_side[1] ],
				types=[ Type_bottom[1], Type_bottom[0], Type_side[1] ]);
			if (corner_bottom[2]==1) trans_2() corner_fillet_cube(
				r    =[    r_bottom[2],    r_bottom[1],    r_side[2] ],
				types=[ Type_bottom[2], Type_bottom[1], Type_side[2] ]);
			if (corner_bottom[3]==1) trans_3() corner_fillet_cube(
				r    =[    r_bottom[3],    r_bottom[2],    r_side[3] ],
				types=[ Type_bottom[3], Type_bottom[2], Type_side[3] ]);
		}
		trans_up() union()
		{ // Ecke am Dach
			if (corner_top[0]==1) trans_0() corner_fillet_cube(
				r    =[    r_top[0],    r_top[3],    r_side[0] ],
				types=[ Type_top[0], Type_top[3], Type_side[0] ]);
			if (corner_top[1]==1) trans_1() corner_fillet_cube(
				r    =[    r_top[1],    r_top[0],    r_side[1] ],
				types=[ Type_top[1], Type_top[0], Type_side[1] ]);
			if (corner_top[2]==1) trans_2() corner_fillet_cube(
				r    =[    r_top[2],    r_top[1],    r_side[2] ],
				types=[ Type_top[2], Type_top[1], Type_side[2] ]);
			if (corner_top[3]==1) trans_3() corner_fillet_cube(
				r    =[    r_top[3],    r_top[2],    r_side[3] ],
				types=[ Type_top[3], Type_top[2], Type_side[3] ]);
		}
	}
}

// Quader mit abgerundeten Kanten
// Argumente wie bei cube_fillet()
//   r, d  - Radius,Durchmesser der Kanten
module cube_rounded (size, r, edges_bottom=[1,1,1,1],  edges_top=[1,1,1,1], edges_side=[1,1,1,1],
                             corner_bottom=[1,1,1,1], corner_top=[1,1,1,1],
                     center=false, d)
{
	cube_fillet (size=size, r=parameter_circle_r(r, d), type=1,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top,
		center=center
	);
}
// Quader mit abgeschrägten Kanten
// Argumente wie bei cube_rounded()
//   r  - Breite der Schräge
module cube_chamfer (size, c, edges_bottom=[1,1,1,1],  edges_top=[1,1,1,1], edges_side=[1,1,1,1],
                             corner_bottom=[1,1,1,1], corner_top=[1,1,1,1],
                     center=false)
{
	cube_fillet (size=size, r=c, type=2,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top,
		center=center
	);
}


// Zylinder mit abgerundeten Enden
module cylinder_rounded (h=3, r, center=false, d)
{
	R = parameter_circle_r (r, d);
	//
	translate_z(center ? -h/2 : 0)
	union ()
	{
		if (h <= 2*R) scale([1,1,h/(2*R)]) translate_z(R) sphere_extend (R);
		else union()
			{
				fn      = get_fn_circle_current_x (R);
				fn_polar= ceil(fn / 2) * 2;
				r_polar = (fn_polar/2 % 2 != 0) ? R : R * 1/cos(180/fn_polar);
				//
				translate_z(R)   sphere_extend   (r_polar);
				translate_z(R)   cylinder_extend (r=R, h=h-2*R);
				translate_z(h-R) sphere_extend   (r_polar);
			}
	}
}

// Zylinder mit abgerundeten Kanten, mit angegebenen Radius
module cylinder_edges_rounded (h=1, r, r_bottom=0, r_top=0, center=false, d)
{
	R = parameter_circle_r (r, d);
	R_bottom = min (R, r_bottom);
	R_top    = min (R, r_top);
	fn = get_fn_circle_current_x (R);
	segment_angle = (fn % 2) ? 180/fn : 0;
	//
	translate_z(center ? -h/2 : 0)
	difference()
	{
		cylinder_extend (r=R, h=h);
		union()
		{
			if (R_bottom > 0)
			{
				fn_ring=ceil((get_fn_circle_current_x(R_bottom) - 1) / 4) * 4;
				//
				difference()
				{
					translate_z(-extra)  ring_square (ro=R+extra, ri=R-R_bottom, h=R_bottom+extra, $fn=fn);
					translate_z(R_bottom) rotate_z(segment_angle)
						torus (r=R-R_bottom, w=R_bottom*2-epsilon, center=true, fn_ring=fn_ring);
				}
			}
			if (R_top > 0)
			{
				fn_ring=ceil((get_fn_circle_current_x(R_top) - 1) / 4) * 4;
				//
				difference()
				{
					translate_z(h-R_top) ring_square (ro=R+extra, ri=R-R_top, h=R_top+extra, $fn=fn);
					translate_z(h-R_top) rotate_z(segment_angle)
						torus (r=R-R_top, w=R_top*2-epsilon, center=true, fn_ring=fn_ring);
				}
			}
		}
	}
}

// Erzeugt einen Keil mit den Parametern von FreeCAD mit gefasten Kanten
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
// Kantenargumente wie bei cube_fillet()
module wedge_fillet (v_min, v_max, v2_min, v2_max
                    , r, type=0
                    , edges_bottom=[1,1,1,1],   edges_top=[1,1,1,1],   edges_side=[1,1,1,1]
                    ,corner_bottom=[1,1,1,1],  corner_top=[1,1,1,1]
                    ,  type_bottom=[-1,-1,-1,-1],type_top=[-1,-1,-1,-1],type_side=[-1,-1,-1,-1] )
{
	function get_type (type_xxx, type=type) =
		 (type_xxx == undef) ? get_type (type, 0)
		:(type_xxx < 0     ) ? get_type (type, 0)
		: type_xxx
	;
	
	Type_bottom = parameter_types (type_bottom, type);
	Type_top    = parameter_types (type_top   , type);
	Type_side   = parameter_types (type_side  , type);
	//
	r_bottom = parameter_edges_radius (edges_bottom, r);
	r_top    = parameter_edges_radius (edges_top   , r);
	r_side   = parameter_edges_radius (edges_side  , r);
	//
	Vmin  = v_min;
	Vmax  = v_max;
	V2min = [v2_min[0], 0, v2_min[1]];
	V2max = [v2_max[0], 0, v2_max[1]];
	
	P = [
		//             X     Y      Z
		pick_vector(  Vmin, Vmin,  Vmin ),  //0
		pick_vector(  Vmax, Vmin,  Vmin ),  //1
		pick_vector( V2max, Vmax, V2min ),  //2
		pick_vector( V2min, Vmax, V2min ),  //3
		pick_vector(  Vmin, Vmin,  Vmax ),  //4
		pick_vector(  Vmax, Vmin,  Vmax ),  //5
		pick_vector( V2max, Vmax, V2max ),  //6
		pick_vector( V2min, Vmax, V2max )]; //7
	
	k = max_norm(P); // Fase länger auschneiden als die Kante lang ist, mit ordentlich Sicherheitsreserve
	
	render()
	difference()
	{
		wedge (v_min, v_max, v2_min, v2_max);
		
		union()
		{ // Fase in der Seite (edges_side)
			edge_fillet_to ([P[0],P[4]], P[1], P[3], r=r_side[0], type=Type_side[0], extra_h=k);
			edge_fillet_to ([P[1],P[5]], P[2], P[0], r=r_side[1], type=Type_side[1], extra_h=k);
			edge_fillet_to ([P[2],P[6]], P[3], P[1], r=r_side[2], type=Type_side[2], extra_h=k);
			edge_fillet_to ([P[3],P[7]], P[0], P[2], r=r_side[3], type=Type_side[3], extra_h=k);
		}
		union()
		{ // Fase auf dem Boden (edges_bottom)
			edge_fillet_to ([P[0],P[1]], P[3], P[4], r=r_bottom[0], type=Type_bottom[0], extra_h=k);
			edge_fillet_to ([P[1],P[2]], P[0], P[5], r=r_bottom[1], type=Type_bottom[1], extra_h=k);
			edge_fillet_to ([P[2],P[3]], P[1], P[6], r=r_bottom[2], type=Type_bottom[2], extra_h=k);
			edge_fillet_to ([P[3],P[0]], P[2], P[7], r=r_bottom[3], type=Type_bottom[3], extra_h=k);
		}
		union ()
		{ // Fase auf der Dachseite (edges_top)
			edge_fillet_to ([P[4],P[5]], P[0], P[7], r=r_top[0], type=Type_top[0], extra_h=k);
			edge_fillet_to ([P[5],P[6]], P[1], P[4], r=r_top[1], type=Type_top[1], extra_h=k);
			edge_fillet_to ([P[6],P[7]], P[2], P[5], r=r_top[2], type=Type_top[2], extra_h=k);
			edge_fillet_to ([P[7],P[4]], P[3], P[6], r=r_top[3], type=Type_top[3], extra_h=k);
		}

	}
}
// Keil mit abgerundeten Kanten
module wedge_rounded (v_min, v_max, v2_min, v2_max, r,
                      edges_bottom=[1,1,1,1],  edges_top=[1,1,1,1], edges_side=[1,1,1,1],
                     corner_bottom=[1,1,1,1], corner_top=[1,1,1,1],
                     d)
{
	wedge_fillet (v_min, v_max, v2_min, v2_max,
		r=parameter_circle_r(r, d), type=1,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top
	);
}
// Keil mit abgeschrägten Kanten
module wedge_chamfer (v_min, v_max, v2_min, v2_max, c,
                      edges_bottom=[1,1,1,1],  edges_top=[1,1,1,1], edges_side=[1,1,1,1],
                     corner_bottom=[1,1,1,1], corner_top=[1,1,1,1],
                     )
{
	wedge_fillet (v_min, v_max, v2_min, v2_max,
		r=c, type=2,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top
	);
}

// erzeugt eine gefaste Kante zum auschneiden oder ankleben, wahlweise abgerundet oder angeschrägt
// Argumente:
//   h       Höhe der Kante
//   r       Radius r der Rundung oder Breite der Schräge
//   angle   Winkel der Kante
//           als Zahlwert, Standart=90° (rechter Winkel)
//           als Liste von-bis [Startwinkel, Endwinkel]
//   type    allgemein, welcher Fasentyp für alle Kanten verwendet werden sollen
//           0 = keine Fase (Standart)
//           1 = Rundung
//           2 = Schräge
//   center  true = den Kantenschaft mittig zentrieren, Standart=false
//   extra   zusätzlichen Überstand abschneiden, wegen Z-Fighting
module edge_fillet (h=1, r, angle=90, type, center=false, extra=extra)
{
	Type = is_num(type) ? type : 0;
	if (Type==1) edge_rounded (h, r, angle, center, extra=extra);
	if (Type==2) edge_chamfer (h, r, angle, center, extra=extra);
}
// erzeugt eine gefaste Kante eines Zylinders zum auschneiden oder ankleben, wahlweise abgerundet oder angeschrägt
// Argumente:
//   r_ring      Radius der Kante des Zylinders
//   angle_ring  Winkel des Zylinders, Standart=360°
module edge_ring_fillet (r_ring, r, angle=90, angle_ring=360, type, extra=extra)
{
	Type = is_num(type) ? type : 0;
	if (Type==1) edge_ring_rounded (r_ring, r, angle, angle_ring, extra=extra);
	if (Type==2) edge_ring_chamfer (r_ring, r, angle, angle_ring, extra=extra);
}
// erzeugt einen Umriss einer gefaste Kante als 2D-Objekt
module edge_fillet_plane (r, angle=90, type, extra=extra)
{
	Type = is_num(type) ? type : 0;
	if (Type==1) edge_rounded_plane (r, angle, extra=extra);
	if (Type==2) edge_chamfer_plane (r, angle, extra=extra);
}

// erzeugt eine abgerundete Kante zum auschneiden oder ankleben
// Argumente:
//   h       Höhe der Kante
//   r, d    Radius oder Durchmesser der Rundung
//   angle   Winkel der Kante, Standart=90° (rechter Winkel)
//   extra   zusätzlichen Überstand abschneiden, wegen Z-Fighting
module edge_rounded (h=1, r, angle=90, center=false, extra=extra, d)
{
	R        = parameter_circle_r(r, d);
	//
	if (R>0 && h>0)
		linear_extrude (height=h, center=center, convexity=2)
		edge_rounded_plane (R, angle, extra=extra);
}
// erzeugt eine abgerundete Kante eines Zylinders zum auschneiden oder ankleben
// Argumente:
//   r_ring      Radius der Kante des Zylinders
//   angle_ring  Winkel des Zylinders, Standart=360°
module edge_ring_rounded (r_ring, r, angle=90, angle_ring=360, extra=extra, d, d_ring)
{
	R        = parameter_circle_r(r, d);
	R_ring   = parameter_circle_r(r_ring, d_ring);
	angles_ring = parameter_angle(angle_ring, 360);
	fn      = get_fn_circle_current_x(R);
	fn_ring = get_fn_circle_current_x(R_ring) + floor(360/angles_ring[0]);
	//
	if (R>0 && R_ring>0)
	{
		rotate_z (angles_ring[1])
		rotate_extrude (angle=angles_ring[0], convexity=4, $fn=fn_ring)
		translate_x (R_ring)
		edge_rounded_plane (R, angle, extra=extra, $fn=fn);
	}
}
// erzeugt einen Umriss einer abgerundeten Kante als 2D-Objekt
module edge_rounded_plane (r, angle, extra=extra, d)
{
	R        = parameter_circle_r(r, d);
	angles   = parameter_angle (angle, 90);
	Angle    = angles[0];
	rotation = angles[1];
	t_factor = sin(90-Angle/2) / sin(Angle/2);
	//
	if (R>0)
	rotate_z(rotation)
	polygon( concat(
		translate_list(
			circle_curve(r=R, angle=[180-Angle, 90+Angle], piece=0, slices="x")
			,[R*t_factor,R]
		)
		,[
			 [ R    *t_factor,-extra]
			,[-extra*t_factor,-extra]
			,translate_list(
				[circle_point(r=R+extra, angle=90+Angle)]
				,[R*t_factor,R]
			)[0]
		]
	));
}

// erzeugt eine abgeschrägte Kante zum auschneiden oder ankleben
// Argumente:
//   h       Höhe der Kante
//   c       Breite der Schräge
//   angle   Winkel der Kante, Standart=90° (rechter Winkel)
//   extra   zusätzlichen Überstand abschneiden, wegen Z-Fighting
module edge_chamfer (h=1, c, angle=90, center=false, extra=extra)
{
	if (c>0 && h>0)
		linear_extrude (height=h, center=center, convexity=2)
		edge_chamfer_plane (c, angle, extra=extra);
}
// erzeugt eine abgerundete Kante eines Zylinders zum auschneiden oder ankleben
// Argumente:
//   r_ring      Radius der Kante des Zylinders
//   angle_ring  Winkel des Zylinders, Standart=360°
module edge_ring_chamfer (r_ring, c, angle=90, angle_ring=360, extra=extra, d_ring)
{
	R_ring   = parameter_circle_r(r_ring, d_ring);
	angles_ring = parameter_angle(angle_ring, 360);
	fn_ring = get_fn_circle_current_x(R_ring) + floor(360/angles_ring[0]);
	//
	if (c>0 && R_ring>0)
	{
		rotate_z (angles_ring[1])
		rotate_extrude (angle=angles_ring[0], convexity=2, $fn=fn_ring)
		translate_x (R_ring)
		edge_chamfer_plane (c, angle, extra=extra);
	}
}
// erzeugt einen Umriss einer abgeschrägten Kante als 2D-Objekt
module edge_chamfer_plane (c, angle=90, extra=extra)
{
	angles   = parameter_angle (angle, 90);
	Angle    = angles[0];
	rotation = angles[1];
	t       = c/2 / sin(Angle/2);
	h_extra = extra * cot(Angle/2);
	//
	if (c>0)
	rotate_z(rotation)
	polygon([
		 [ t,       0]
		,[ t      ,-extra]
		,[-h_extra,-extra]
		,translate_list(
			[circle_point(r=t+h_extra, angle=Angle)]
			,[-h_extra,-extra]
		)[0]
		,circle_point(r=t, angle=Angle)
	]);
}

// erzeugt eine gefaste Kante aus den Daten Linie der Kante und 2 Eckpunkten der angrenzenden Flächen
module edge_fillet_to (line, point1, point2, r, type, extra=extra, extra_h=0)
{
	base_vector = [1,0];
	origin      = line[0];
	line_vector = line[1] - line[0];
	up_to_z     = rotate_backwards_to_vector_list ( translate_list ([point1,point2], -origin), line_vector);
	plane       = projection_list (up_to_z);
	angle_base  = rotation_vector (base_vector, plane[0]);
	angle_fillet= rotation_vector (plane[0]   , plane[1]);
	//
	translate (origin)
	rotate_to_vector (line_vector, angle_base)
	translate_z (-extra_h)
	edge_fillet (h=norm(line_vector)+extra_h*2, r=r, angle=angle_fillet, type=type, extra=extra);
}
module edge_rounded_to (line, point1, point2, r, extra=extra, extra_h=0)
{
	edge_fillet_to (line, point1, point2, r, type=1, extra=extra, extra_h=extra_h);
}
module edge_chamfer_to (line, point1, point2, c, extra=extra, extra_h=0)
{
	edge_fillet_to (line, point1, point2, c, type=2, extra=extra, extra_h=extra_h);
}


module corner_fillet_cube (r=[1,1,1], types=[0,0,0])
{
	Types = [ for (i=[0:2]) is_num(types[i]) ? types[i] : 0 ];
	if (Types[0]==1 && Types[1]==1 && Types[2]==1) corner_rounded_cube (r);
}

// erzeugt eine abgerundete Ecke für einen Quader
// Argumente:
//   r   Radius der jeweiligen Achse (Ecke im Koordinatenursprung)
//       [ X, Y, Z ]
module corner_rounded_cube (r=[1,1,1])
{
	R = is_num(r) ? [r,r,r] : r;
	a = parameter_circle_r (R[0]);
	b = parameter_circle_r (R[1]);
	c = parameter_circle_r (R[2]);
	//
	if (c==max(a,b,c))  render(convexity=4) intersection()
	{
		fn_c = get_fn_circle_current_x (c, 90);
		//
		for (i=[0.5:fn_c])
		{
			t = i/fn_c;
			rotate_at_z(90*t, [c,c,0])
			rotate_x(270)
		//	edge_rounded(r=bezier_1(t, [   b ,   a ]), h=a+b+c, angle=[90,270], extra=a+b+c);
			edge_rounded(r=lookup  (t, [[0,b],[1,a]]), h=a+b+c, angle=[90,270], extra=a+b+c);
		}
		
		translate(-[extra,extra,extra])
		cube(      [extra,extra,extra] + [c*(1+2/fn_c),c*(1+2/fn_c),max(a,b)]);
	}
	else if (b==max(a,b,c))
	{
		rotate (240, [1,1,1])  corner_rounded_cube ([c,a,b]);
	}
	else if (a==max(a,b,c))
	{
		rotate (120, [1,1,1])  corner_rounded_cube ([b,c,a]);
	}
}
