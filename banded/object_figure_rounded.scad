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
//   type          - Fasentyp für alle Kanten als Liste
//                 - Bei Angabe des Fasentyps direkt werden alle Kanten auf diesen Fasentyp gesetzt
//                 - mögliche Werte:
//                   - 0 = keine Fase (Standart)
//                   - 1 = Rundung
//                   - 2 = Schräge
//                 - Die Liste enthält 12 Elemente. Die Positionen konfigurieren jeweils eine Kante:
//                   [ 4 Kanten am Boden (bottom), 4 Kanten oben (top), 4 Kanten an der Seite (around)]
//                 - Positionen der Kanten auf dem Würfel (Ansicht von oben)
//                   [x0(->x1), x1(->y1), y1(->y0), y0(->x0)]  -> bottom, top
//                   [x0      , x1      , y1      , y0      ]  -> around
//                             y
//                      y0     |     y1
//                       +-----|-----+
//                       |     |     |
//                   ----------+--------->x
//                       |     |     |
//                       +-----|-----+
//                      x0     |     x1
//
//   edges         - Radius der Kanten oder Breite der Schräge der jeweiligen Kante als Liste
//                 - Wird ein Zahlwert direkt angegeben, wird dieser für alle Kanten genommen
//                 - mögliche Werte:
//                   0        = nicht gefast
//                   größer 0 = Radius oder Breite der Fase
//                 - Die Liste enthält 12 Elemente. Positionen wie bei Parameter 'type'
//   center        - wenn true, Quader wird zum Koordinatenursprung zentriert, Standart=false
//   align         - Ausrichtung des Quaders
//
// TODO Noch nicht implementiert:
//   corner        - Angabe, welche Ecken gefast sein sollen als Liste
//                 - Wird ein Wert direkt angegeben, wird dieser für alle Ecken genommen
//                 - mögliche Werte:
//                   0  = nicht gefast
//                   1  = gefast
//                 - Die Liste enthält 8 Elemente. Die Positionen konfigurieren jeweils eine Ecke:
//                   [ 4 Ecken am Boden (bottom), 4 Ecken oben (top)]
//                 - Positionen der Ecken auf dem Würfel (Ansicht von oben)
//                   [x0, x1, y1, y0]  -> bottom, top
module cube_fillet (size, type, edges, corner, center, align)
{
	Size = parameter_size_3d (size);
	//
	Align = parameter_align   (align, [1,1,1], center);
	//
	Types       = parameter_types_cube (type);
	Type_bottom = [for (i=[0: 3]) Types[i] ];
	Type_top    = [for (i=[4: 7]) Types[i] ];
	Type_side   = [for (i=[8:11]) Types[i] ];
	//
	Edges    = parameter_edges_cube (edges);
	r_bottom = [for (i=[0: 3]) Edges[i] ];
	r_top    = [for (i=[4: 7]) Edges[i] ];
	r_side   = [for (i=[8:11]) Edges[i] ];
	//
	Corner = parameter_corner_cube (corner);
	
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
			if (Corner[0]==1) trans_0() corner_fillet_cube(
				r    =[    r_bottom[0],    r_bottom[3],    r_side[0] ],
				types=[ Type_bottom[0], Type_bottom[3], Type_side[0] ]);
			if (Corner[1]==1) trans_1() corner_fillet_cube(
				r    =[    r_bottom[1],    r_bottom[0],    r_side[1] ],
				types=[ Type_bottom[1], Type_bottom[0], Type_side[1] ]);
			if (Corner[2]==1) trans_2() corner_fillet_cube(
				r    =[    r_bottom[2],    r_bottom[1],    r_side[2] ],
				types=[ Type_bottom[2], Type_bottom[1], Type_side[2] ]);
			if (Corner[3]==1) trans_3() corner_fillet_cube(
				r    =[    r_bottom[3],    r_bottom[2],    r_side[3] ],
				types=[ Type_bottom[3], Type_bottom[2], Type_side[3] ]);
		}
		trans_up() union()
		{ // Ecke am Dach
			if (Corner[4]==1) trans_0() corner_fillet_cube(
				r    =[    r_top[0],    r_top[3],    r_side[0] ],
				types=[ Type_top[0], Type_top[3], Type_side[0] ]);
			if (Corner[5]==1) trans_1() corner_fillet_cube(
				r    =[    r_top[1],    r_top[0],    r_side[1] ],
				types=[ Type_top[1], Type_top[0], Type_side[1] ]);
			if (Corner[6]==1) trans_2() corner_fillet_cube(
				r    =[    r_top[2],    r_top[1],    r_side[2] ],
				types=[ Type_top[2], Type_top[1], Type_side[2] ]);
			if (Corner[7]==1) trans_3() corner_fillet_cube(
				r    =[    r_top[3],    r_top[2],    r_side[3] ],
				types=[ Type_top[3], Type_top[2], Type_side[3] ]);
		}
	}
}

// Quader mit abgerundeten Kanten
// Argumente wie bei cube_fillet()
module cube_rounded (size, edges, corner, center, align)
{
	cube_fillet (size, 1, edges, corner, center, align);
}
// Quader mit abgeschrägten Kanten
// Argumente wie bei cube_rounded()
module cube_chamfer (size, edges, corner, center, align)
{
	cube_fillet (size, 2, edges, corner, center, align);
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
module cylinder_edges_fillet (h, r1, r2, type, edges, center, r, d, d1, d2, angle, slices, outer, align)
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
	R_edges  = parameter_numlist (2, edges, [0,0], true);
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
module cylinder_edges_rounded (h, r1, r2, edges, center, r, d, d1, d2, angle, slices, outer, align)
{
	cylinder_edges_fillet (h, r1, r2, 1, edges, center, r, d, d1, d2, angle, slices, outer, align);
}
// Zylinder mit abgeschrägten Kanten
module cylinder_edges_chamfer (h, r1, r2, edges, center, r, d, d1, d2, angle, slices, outer, align)
{
	cylinder_edges_fillet (h, r1, r2, 2, edges, center, r, d, d1, d2, angle, slices, outer, align);
}

// Erzeugt einen Keil mit den Parametern von FreeCAD mit gefasten Kanten
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
// Kantenargumente wie bei cube_fillet()
module wedge_fillet (v_min, v_max, v2_min, v2_max, type, edges, corner)
{
	Types       = parameter_types_cube (type);
	Type_bottom = [for (i=[0: 3]) Types[i] ];
	Type_top    = [for (i=[4: 7]) Types[i] ];
	Type_side   = [for (i=[8:11]) Types[i] ];
	//
	Edges    = parameter_edges_cube (edges);
	r_bottom = [for (i=[0: 3]) Edges[i] ];
	r_top    = [for (i=[4: 7]) Edges[i] ];
	r_side   = [for (i=[8:11]) Edges[i] ];
	//
	Corner = parameter_corner_cube (corner); // TODO Not implemented
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
module wedge_rounded (v_min, v_max, v2_min, v2_max, edges, corner)
{
	wedge_fillet (v_min, v_max, v2_min, v2_max, 1, edges, corner);
}
// Keil mit abgeschrägten Kanten
module wedge_chamfer (v_min, v_max, v2_min, v2_max, edges, corner)
{
	wedge_fillet (v_min, v_max, v2_min, v2_max, 2, edges, corner);
}


// - 2D:

// Rechteck mit abgerundeten Ecken
// - type  - Typ der Ecke als Zahl für alle Ecken
//         - oder als Liste für jede einzelne Ecke
//   edges - Radius der Kanten oder Breite der Schräge
//         - als Zahl für alle Ecken
//         - als Liste für jede einzelne Ecke
//           [p0, p1, p2, p3]
//                     y
//              p3     |     p2
//               +-----|-----+
//               |     |     |
//           ----------+--------->x
//               |     |     |
//               +-----|-----+
//              p0     |     p1
//
module square_fillet (size, type, edges, center, align)
{
	Size    = parameter_size_2d(size);
	Align   = parameter_align (align, [1,1], center);
	Types   = parameter_types (type);
	R_edges = parameter_edges_radius (edges);
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
module square_rounded (size, edges, center, align)
{
	square_fillet (size, edges, 1, center, align);
}
// abgeschrägte Ecken
module square_chamfer (size, edges, center, align)
{
	square_fillet (size, edges, 2, center, align);
}


// - Parameter konfigurieren:

// Stellt den Parameter 'edges' vom Module cube_fillet() ein.
//
// 3 Gruppen von Kanten, die den Quader jeweils vollständig umfassen:
// - bottom, top, around
// - left, right, forward
// - front, back, sideways
// In den 3 Gruppen werden alle Kanten jeweils 3 mal definiert werden,
// daher gibt es eine Priorität, die höhere überschreibt die niedrige.
// Einzelne Kanten können mit 'undef' als nicht definiert gesetzt werden.
// Reihenfolge, weiter links liegende überschreibt weiter rechts liegende:
// - bottom, top, around,  left, right, forward,  front, back, sideways
//
// Argumente:
// - 'bottom'   - 4 Kanten um das Rechteck am Boden    - 1. Kante = vorne,       links herum von oben gesehen
// - 'top'      - 4 Kanten um das Rechteck am Dach     - 1. Kante = vorne,       links herum von oben gesehen
// - 'around'   - 4 Kanten vertikal vom Boden zum Dach - 1. Kante = vorne links, links herum von oben gesehen
// - 'left'     - 4 Kanten um das Rechteck linke Seite      - 1. Kante = links unten,  links herum von links gesehen
// - 'right'    - 4 Kanten um das Rechteck rechte Seite     - 1. Kante = rechts unten, links herum von links gesehen
// - 'forward'  - 4 Kanten horizontal von links nach rechts - 1. Kante = vorne unten,  links herum von links gesehen
// - 'front'    - 4 Kanten um das Rechteck vordere Seite    - 1. Kante = vorne unten,  links herum von vorne gesehen
// - 'back'     - 4 Kanten um das Rechteck hintere Seite    - 1. Kante = hinten unten, links herum von vorne gesehen
// - 'sideways' - 4 Kanten horizontal von vorne nach hinten - 1. Kante = rechts unten, links herum von vorne gesehen
// - 'r'        - optionaler Parameter
//                Alle Kanten werden mit diesen Wert multipliziert, wenn angegeben.
// - 'default'  - Wert, der genommen wird, für Kanten die nicht gesetzt wurden
//              - Standart = 0, Kante nicht abgerundet
// Rückgabe:
// - 12 Element Liste:
//   - die ersten 4 Elemente entsprechen:        'bottom' - alle 4 Kanten am Boden
//   - die nachfolgenden 4 Elemente entsprechen: 'top'    - alle 4 Kanten oben
//   - die letzten 4 Elemente entsprechen:       'around' - alle vertikalen Kanten an der Seite
//
function configure_edges (bottom,top,around, left,right,forward, front,back,sideways, r, default=0) =
	let (
		 Bottom = configure_edges_prepare (bottom)
		,Top    = configure_edges_prepare (top)
		,Around = configure_edges_prepare (around)
		,Left    = configure_edges_prepare (left)
		,Right   = configure_edges_prepare (right)
		,Forward = configure_edges_prepare (forward)
		,Front    = configure_edges_prepare (front)
		,Back     = configure_edges_prepare (back)
		,Sideways = configure_edges_prepare (sideways)
		//
		,edges_bottom = configure_edges_priority
			( Bottom
			, [ Forward[0], Right   [0], Forward[3], Left    [0] ]
			, [ Front  [0], Sideways[0], Back   [0], Sideways[3] ]
			)
		,edges_top = configure_edges_priority
			( Top
			, [ Forward[1], Right   [2], Forward[2], Left    [2] ]
			, [ Front  [2], Sideways[1], Back   [2], Sideways[2] ]
			)
		,edges_around = configure_edges_priority
			( Around
			, [ Left [1], Right[1], Right[3], Left[3] ]
			, [ Front[3], Front[1], Back [1], Back[3] ]
			)
	)
	[ each configure_edges_radius (edges_bottom, r, default)
	, each configure_edges_radius (edges_top   , r, default)
	, each configure_edges_radius (edges_around, r, default)
	]
;
function configure_edges_prepare (edges, n=4) =
	 is_num (edges) ? [for (i=[0:1:n-1]) edges   ]
	:is_list(edges) ? [for (i=[0:1:n-1]) edges[i]]
	:                 [for (i=[0:1:n-1]) undef  ]
;
function configure_edges_priority (edges1, edges2, edges3, n=4) =
	[ for (i=[0:1:n-1])
		edges1[i]!=undef ? edges1[i] :
		edges2[i]!=undef ? edges2[i] :
		edges3[i]!=undef ? edges3[i] :
		undef
	]
;
function configure_edges_radius (edges, r, default=0) =
	(r==undef) || !is_num(r) ?
		[ for (i=[0:1:len(edges)-1]) edges[i]==undef ? default : edges[i] ]
	:	[ for (i=[0:1:len(edges)-1]) edges[i]==undef ? default : edges[i] ] * r
;

// Stellt den Parameter 'edges' vom Module cube_fillet() ein.
//
// Argumente wie bei 'configure_edges()', nur ohne r
function configure_types (bottom,top,around, left,right,forward, front,back,sideways, default=0) =
	configure_edges (bottom,top,around, left,right,forward, front,back,sideways, undef, default)
;

// Stellt den Parameter 'corner' vom Module cube_fillet() ein.
//
// 3 Gruppen von Ecken, die den Quader jeweils vollständig umfassen:
// - bottom, top
// - left, right
// - front, back
// In den 3 Gruppen werden alle Ecken jeweils 3 mal definiert werden,
// daher gibt es eine Priorität, die höhere überschreibt die niedrige.
// Einzelne Ecken können mit 'undef' als nicht definiert gesetzt werden.
// Reihenfolge, weiter links liegende überschreibt weiter rechts liegende:
// - bottom, top,  left, right,  front, back
//
// Argumente:
// - 'bottom'   - 4 Ecken um das Rechteck am Boden      - 1. Ecken = vorne links,  links herum von oben gesehen
// - 'top'      - 4 Ecken um das Rechteck am Dach       - 1. Ecken = vorne links,  links herum von oben gesehen
// - 'left'     - 4 Ecken um das Rechteck linke Seite   - 1. Ecken = vorne unten,  links herum von links gesehen
// - 'right'    - 4 Ecken um das Rechteck rechte Seite  - 1. Ecken = vorne unten,  links herum von links gesehen
// - 'front'    - 4 Ecken um das Rechteck vordere Seite - 1. Ecken = rechts unten, links herum von vorne gesehen
// - 'back'     - 4 Ecken um das Rechteck hintere Seite - 1. Ecken = rechts unten, links herum von vorne gesehen
// - 'default'  - Wert, der genommen wird, für Ecken die nicht gesetzt wurden
//              - Standart = 0, Ecken nicht abgerundet
// Rückgabe:
// - 8 Element Liste:
//   - die ersten 4 Elemente entsprechen:  'bottom' - alle 4 Ecken am Boden
//   - die letzten 4 Elemente entsprechen: 'top'    - alle 4 Ecken oben
//
function configure_corner (bottom,top, left,right, front,back, default=0) =
	let (
		 Bottom = configure_edges_prepare (bottom)
		,Top    = configure_edges_prepare (top)
		,Left    = configure_edges_prepare (left)
		,Right   = configure_edges_prepare (right)
		,Front    = configure_edges_prepare (front)
		,Back     = configure_edges_prepare (back)
		//
		,edges_bottom = configure_edges_priority
			( Bottom
			, [ Left [0], Right[0], Right[3], Left[3] ]
			, [ Front[3], Front[0], Back [0], Back[3] ]
			)
		,edges_top = configure_edges_priority
			( Top
			, [ Left [1], Right[1], Right[2], Left[2] ]
			, [ Front[2], Front[1], Back [1], Back[2] ]
			)
	)
	[ each configure_edges_radius (edges_bottom, undef, default)
	, each configure_edges_radius (edges_top   , undef, default)
	]
;

