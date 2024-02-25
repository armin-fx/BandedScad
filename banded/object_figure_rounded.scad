// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige Objekte mit abgerundeten Ecken und Kanten

use <banded/object_figure.scad>
use <banded/object_rounded.scad>
//
include <banded/constants.scad>
//
use <banded/extend.scad>
use <banded/helper.scad>
use <banded/math_vector.scad>
use <banded/draft_curves.scad>
use <banded/draft_transform.scad>
use <banded/operator_transform.scad>


// - 3D:

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
	
	fn=get_slices_circle_current (R);
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
                   , edges_bottom,   edges_top,   edges_side
                   ,corner_bottom,  corner_top
                   ,  type_bottom=-1, type_top=-1, type_side=-1
                   ,center=false, align)
{
	Size = parameter_size_3d (size);
	//
	Align = parameter_align   (align, [1,1,1], center);
	//
	Type_bottom = parameter_types (type_bottom, type);
	Type_top    = parameter_types (type_top   , type);
	Type_side   = parameter_types (type_side  , type);
	//
	r_bottom = parameter_edges_radius (edges_bottom, r);
	r_top    = parameter_edges_radius (edges_top   , r);
	r_side   = parameter_edges_radius (edges_side  , r);
	
	module trans_side   ()  {                                  translate_z(-extra) children(); }
	module trans_bottom ()  { rotate_y(90)rotate_z(90)         translate_z(-extra) children(); }
	module trans_top    ()  { translate_z(Size[2])rotate_y(90) translate_z(-extra) children(); }
	//
	module trans_up () { mirror_at_z(Size[2]/2) children(); }
	//
	module trans_0 ()  { translate([0      ,0      ]) rotate_z(  0) children(); }
	module trans_1 ()  { translate([Size[0],0      ]) rotate_z( 90) children(); }
	module trans_2 ()  { translate([Size[0],Size[1]]) rotate_z(180) children(); }
	module trans_3 ()  { translate([0      ,Size[1]]) rotate_z(270) children(); }
	
	//render()
	color("gold")
	translate ([for (i=[0:1:len(Size)-1]) (Align[i]-1)*Size[i]/2 ])
	difference()
	{
		cube (size=Size);
		
		union ()
		{ // Fase in der Seite (edges_side)
		trans_0() trans_side() edge_fillet (h=Size[2]+2*extra, r=r_side[0], type=Type_side[0]);
		trans_1() trans_side() edge_fillet (h=Size[2]+2*extra, r=r_side[1], type=Type_side[1]);
		trans_2() trans_side() edge_fillet (h=Size[2]+2*extra, r=r_side[2], type=Type_side[2]);
		trans_3() trans_side() edge_fillet (h=Size[2]+2*extra, r=r_side[3], type=Type_side[3]);
		}
		union ()
		{ // Fase auf dem Boden (edges_bottom)
		trans_0() trans_bottom() edge_fillet (h=Size[0]+2*extra, r=r_bottom[0], type=Type_bottom[0]);
		trans_1() trans_bottom() edge_fillet (h=Size[1]+2*extra, r=r_bottom[1], type=Type_bottom[1]);
		trans_2() trans_bottom() edge_fillet (h=Size[0]+2*extra, r=r_bottom[2], type=Type_bottom[2]);
		trans_3() trans_bottom() edge_fillet (h=Size[1]+2*extra, r=r_bottom[3], type=Type_bottom[3]);
		}
		union ()
		{ // Fase auf der Dachseite (edges_top)
		trans_0() trans_top() edge_fillet (h=Size[0]+2*extra, r=r_top[0], type=Type_top[0]);
		trans_1() trans_top() edge_fillet (h=Size[1]+2*extra, r=r_top[1], type=Type_top[1]);
		trans_2() trans_top() edge_fillet (h=Size[0]+2*extra, r=r_top[2], type=Type_top[2]);
		trans_3() trans_top() edge_fillet (h=Size[1]+2*extra, r=r_top[3], type=Type_top[3]);
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
module cube_rounded (size, r, edges_bottom,  edges_top, edges_side,
                             corner_bottom, corner_top,
                     center=false, align, d)
{
	cube_fillet (size=size, r=parameter_circle_r(r, d, undef), type=1,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top,
		center=center, align=align
	);
}
// Quader mit abgeschrägten Kanten
// Argumente wie bei cube_rounded()
//   c  - Breite der Schräge
module cube_chamfer (size, r, edges_bottom,  edges_top, edges_side,
                             corner_bottom, corner_top,
                     center=false, align)
{
	cube_fillet (size=size, r=r, type=2,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top,
		center=center, align=align
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
				fn      = get_slices_circle_current_x (R);
				fn_polar= ceil(fn / 2) * 2;
				r_polar = (fn_polar/2 % 2 != 0) ? R : R * 1/cos(180/fn_polar);
				//
				translate_z(R)   sphere_extend   (r_polar);
				translate_z(R)   cylinder_extend (r=R, h=h-2*R);
				translate_z(h-R) sphere_extend   (r_polar);
			}
	}
}


// Zylinder mit gefasten Kanten, wahlweise abgerundet oder angeschrägt
// fehlt noch: outer, piece
module cylinder_edges_fillet (h, r1, r2, r_edges=0, type=0, center, r, d, d1, d2, angle=360, slices, outer, align)
{
	angles   = parameter_angle (angle, [360,0]);
	Outer    = outer!=undef ? outer : 0;
	R        = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	R_max    = max(R);
	fn       = parameter_slices_circle_x (slices, R_max, angles[0]);
	R_outer  = R * get_circle_factor (fn, Outer);
	H        = get_first_num (h, 1);
	Types    = parameter_types (type, 0, 2);
	a        = atan ( H / (R_outer[0]-R_outer[1]) );
	angle_bottom = a<0 ? a+180 : a;
	angle_edges  = [angle_bottom, 180-angle_bottom];
	R_edges  = parameter_numlist (2, r_edges, [0,0], true);
	R_both   = [for (i=[0:1])
		Types[i]==1 ? min (  R[i]*tan(angle_edges[i]/2), R_edges[i])
		:             min (2*R[i]*sin(angle_edges[i]/2), R_edges[i])
		];
	Align    = parameter_align (align, [0,0,1], center);
	
	translate ([ Align[0]*R_max, Align[1]*R_max, Align[2]*H/2 - H/2])
	difference()
	{
		cylinder_extend (r1=R[0], r2=R[1], h=H, angle=angles, slices=fn, outer=Outer);
		//
		if (R_both[0] > 0)
		{
			edge_ring_fillet (r_ring=R[0], r=R_both[0], angle=[angle_edges[0],180-angle_edges[0]],
				angle_ring=angles, type=Types[0], slices=fn, outer=Outer);
		}
		if (R_both[1] > 0)
		{
			translate_z (H)
			edge_ring_fillet (r_ring=R[1], r=R_both[1], angle=[angle_edges[1],180],
				angle_ring=angles, type=Types[1], slices=fn, outer=Outer);
		}
	}
}
// Zylinder mit abgerundeten Kanten
module cylinder_edges_rounded (h, r1, r2, r_edges=0, center, r, d, d1, d2, angle=360, slices, outer, align)
{
	cylinder_edges_fillet (h, r1, r2, r_edges, 1, center, r, d, d1, d2, angle, slices, outer, align);
}
// Zylinder mit abgeschrägten Kanten
module cylinder_edges_chamfer (h, r1, r2, r_edges=0, center, r, d, d1, d2, angle=360, slices, outer, align)
{
	cylinder_edges_fillet (h, r1, r2, r_edges, 2, center, r, d, d1, d2, angle, slices, outer, align);
}

// Erzeugt einen Keil mit den Parametern von FreeCAD mit gefasten Kanten
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
// Kantenargumente wie bei cube_fillet()
module wedge_fillet (v_min, v_max, v2_min, v2_max
                    , r, type=0
                    , edges_bottom,   edges_top,   edges_side
                    ,corner_bottom,  corner_top
                    ,  type_bottom=-1, type_top=-1, type_side=-1 )
{
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
                      edges_bottom,  edges_top, edges_side,
                     corner_bottom, corner_top,
                     d)
{
	wedge_fillet (v_min, v_max, v2_min, v2_max,
		r=parameter_circle_r(r, d), type=1,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top
	);
}
// Keil mit abgeschrägten Kanten
module wedge_chamfer (v_min, v_max, v2_min, v2_max, r,
                      edges_bottom,  edges_top, edges_side,
                     corner_bottom, corner_top,
                     )
{
	wedge_fillet (v_min, v_max, v2_min, v2_max,
		r=r, type=2,
		 edges_bottom= edges_bottom,  edges_top= edges_top, edges_side=edges_side,
		corner_bottom=corner_bottom, corner_top=corner_top
	);
}


// - 2D:

// Rechteck mit abgerundeten Ecken
// - type - Typ der Ecke als Zahl für alle Ecken
//        - oder als Liste für jede einzelne Ecke
//   r    - Radius der Kanten oder Breite der Schräge
//        - als Zahl für alle Ecken
//        - als Liste für jede einzelne Ecke
//          [p0, p1, p2, p3]
//                    y
//             p3     |     p2
//              +-----|-----+
//              |     |     |
//          ----------+--------->x
//              |     |     |
//              +-----|-----+
//             p0     |     p1
//
module square_fillet (size, r, type, center, align)
{
	Size    = parameter_size_2d(size);
	Align   = parameter_align (align, [1,1], center);
	Types   = parameter_types (type);
	R_edges = parameter_edges_radius (r);
	square_list = square_curve (Size, center=true);
	
	translate ([for (i=[0:1:len(Size)-1]) Align[i]*Size[i]/2 ])
	difference ()
	{
		square (Size, center=true);
		//
		for (i=[0:3])
		translate (square_list[i])
		edge_fillet_plane (R_edges[i], [90, i*90], Types[i]);
	}
}
// abgerundete Ecken
module square_rounded (size, r, center, align)
{
	square_fillet (size, r, 1, center, align);
}
// abgeschrägte Ecken
module square_chamfer (size, r, center, align)
{
	square_fillet (size, r, 2, center, align);
}
