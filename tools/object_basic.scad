// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Objekte

use <tools/extend.scad>
use <tools/function_recondition.scad>
use <tools/function_helper.scad>
use <tools/function_curves.scad>
use <tools/operator_transform.scad>

// leeres Modul
module empty () {}


// Erzeugt einen Torus
// Argumente:
//   r  - mittlerer Radius
//   ri - Innenradius
//   ro - Außenradius
//   w  - Breite des Rings
// Angegeben müssen:
//   genau 2 Angaben von r oder r1 oder r2 oder w
// weitere Argumente:
//   angle   - Öffnungswinkel des Torus, Standart=360°. Benötigt Version 2019.05
//   center  - Torus in der Mitte (Z-Achse) zentrieren (bei center=true)
//   fn_ring - optionale Anzahl der Segmente des Rings
module torus (r, w, ri, ro, angle=360, center=false, fn_ring=undef)
{
	rx = parameter_ring_2r(r, w, ri, ro);
	rm = (rx[1] + rx[0]) / 2;
	rw = (rx[1] - rx[0]) / 2;
	fn_Ring = is_num(fn_ring) ? fn_ring : get_fn_circle_current_x(rw);
	//
	translate_z(center ? 0 : rw)
	rotate_extrude(angle=angle, $fn=get_fn_circle_current_x(rm+rw))
	difference()
	{
		translate([ rm,  0]) circle(r=rw, $fn=fn_Ring); 
		translate([-rw,-rw]) square([rw, 2*rw]);   
	}
}


function pick_vector (vx, vy, vz) = [vx.x, vy.y, vz.z] ;

// Erzeugt einen Keil mit den Parametern von FreeCAD
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
module wedge (v_min, v_max, v2_min, v2_max)
{
	Vmin  = v_min;
	Vmax  = v_max;
	V2min = [v2_min[0], 0, v2_min[1]];
	V2max = [v2_max[0], 0, v2_max[1]];
	//
	//    7 +---------+ 6
	//     /:        /|
	//  4 / :     5 / |
	//   +---------+  |
	//   |  + - - -|- +
	//   | . 3     | / 2
	//   |.        |/
	//   +---------+
	//  0          1
	//
	CubePoints = [
		//             X     Y      Z
		pick_vector(  Vmin, Vmin,  Vmin ),  //0
		pick_vector(  Vmax, Vmin,  Vmin ),  //1
		pick_vector( V2max, Vmax, V2min ),  //2
		pick_vector( V2min, Vmax, V2min ),  //3
		pick_vector(  Vmin, Vmin,  Vmax ),  //4
		pick_vector(  Vmax, Vmin,  Vmax ),  //5
		pick_vector( V2max, Vmax, V2max ),  //6
		pick_vector( V2min, Vmax, V2max )]; //7
	
	CubeFaces = [
		[0,1,2,3],  // bottom
		[4,5,1,0],  // front
		[7,6,5,4],  // top
		[5,6,2,1],  // right
		[6,7,3,2],  // back
		[7,4,0,3]]; // left
	
	polyhedron( CubePoints, CubeFaces );	
}

// erzeugt einen quadratischen Ring
// Argumente:
//   h      - Höhe
//   r      - mittlerer Radius
//   ri, di - Innenradius, Innendurchmesser
//   ro, do - Außenradius, Außendurchmesser
//   w      - Breite des Rings
//   angle  - gezeichneter Winkel in Grad, Standart=360
//            als Zahl  = Winkel von 0 bis 'angle' = Öffnungswinkel
//            als Liste = [Öffnungswinkel, Anfangswinkel]
// Angegeben müssen:
//   h
//   genau 2 Angaben von r oder ri oder ro oder w
module ring_square (h, r, w, ri, ro, angle=360, center=false, d, di, do)
{
	rx = parameter_ring_2r(r, w, ri, ro, d, di, do);
	translate_z(center ? -h/2 : 0)
	linear_extrude(height=h, convexity=4)
	difference()
	{
		polygon(circle_curve(r = rx[1], angle=angle, slices="x"));
		polygon(circle_curve(r = rx[0], angle=angle, slices="x"));
	}
}

// Erzeugt einen Trichter
// Argumente:
//   h        - Höhe
//   ri1, ri2 - Innenradius unten, oben
//   ro1, ro2 - Außenradius unten, oben
//   w        - Breite der Wand. Optional
//   angle    - Öffnungswinkel des Trichters. Standard=360°. Benötigt Version 2019.05
module funnel (h=1, ri1, ri2, ro1, ro2, w, angle=360, di1, di2, do1, do2)
{
	_ri1 = get_first_num (ri1, ro1-w, di1/2, do1/2-w, 1);
	_ri2 = get_first_num (ri2, ro2-w, di2/2, do2/2-w, 1);
	_ro1 = get_first_num (ro1, ri1+w, do1/2, di1/2+w, 2);
	_ro2 = get_first_num (ro2, ri2+w, do2/2, di2/2+w, 2);
	fn = get_fn_circle_current_x( max(_ri1, _ri2, _ro1, _ro2) );
	//
	rotate_extrude(angle=angle, $fn=fn)
	{
		polygon([
			[_ri1,0], [_ro1,0],
			[_ro2,h], [_ri2,h]
		]);
	}
}

// r  = radius middle --- h  = height barrel
// r1 = radius bottom --- h1 = height seal bottom to barrel
// r2 = radius top    --- h2 = height seal top to barrel
// barrelbase=true - barrel begins on orgin
module cylinder_bind (r=2, r1=1, r2=1, h=2, h1=1.5, h2=1.5, center=false, barrelbase=false)
{
	if      (center==false && barrelbase==false)                           cylinder_bind_basic (r, r1, r2, h, h1, h2);
	else if (center==true  && barrelbase==false) translate_z((-h-h1-h2)/2) cylinder_bind_basic (r, r1, r2, h, h1, h2);
	else if (center==false && barrelbase==true)  translate_z(-h1)          cylinder_bind_basic (r, r1, r2, h, h1, h2);
	else if (center==true  && barrelbase==true)  translate_z(-h1-h/2)      cylinder_bind_basic (r, r1, r2, h, h1, h2);
}

module cylinder_bind_basic (r=2, r1=1, r2=1, h=2, h1=1.5, h2=1.5)
{
	                  cylinder_extend (r1=r1, r2=r, h=h1);
	translate_z(h1)   cylinder_extend (r=r,         h=h);
	translate_z(h1+h) cylinder_extend (r1=r, r2=r2, h=h2);
}

