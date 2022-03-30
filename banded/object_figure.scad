// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Objekte

use <banded/extend.scad>
use <banded/helper.scad>
use <banded/math_vector.scad>
use <banded/draft_curves.scad>
use <banded/draft_primitives_figure.scad>
use <banded/operator_transform.scad>


// leeres Modul
module empty () {}

// Erzeugt einen Keil mit den Parametern von FreeCAD
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
module wedge (v_min, v_max, v2_min, v2_max)
{
	o = wedge (v_min, v_max, v2_min, v2_max);
	//
	polyhedron( o[0], o[1] );
}

// Erzeugt einen Torus
// Argumente:
//   r  - mittlerer Radius
//   ri - Innenradius
//   ro - Außenradius
//   w  - Breite des Rings
// Angegeben müssen:
//   genau 2 Angaben von r oder r1 oder r2 oder w
// weitere Argumente:
//   angle   - Öffnungswinkel des Torus, Standart=360°. Benötigt Version ab 2019.05
//   center  - Torus in der Mitte (Z-Achse) zentrieren (bei center=true)
//   fn_ring - optionale Anzahl der Segmente des Rings
module torus (r, w, ri, ro, angle=360, center=false, fn_ring)
{
	rx = parameter_ring_2r(r, w, ri, ro);
	rm = (rx[1] + rx[0]) / 2;
	rw = (rx[1] - rx[0]) / 2;
	circle_angle =
		rw<=0   ? undef :
		rm<=-rw ? undef :
		rm>=rw  ? [360,0] :
		let( alpha=acos(rm/rw) )  [2*(180-alpha), 180+alpha];
	fn_Ring =
		is_num(fn_ring) ? fn_ring
		: get_fn_circle_current_x (rw, angle=circle_angle[0], piece=false);
	//
	rotate_extrude_extend (angle=angle, $fn=get_fn_circle_current_x(rm+rw))
	polygon (
		translate_points(
			v    = [ rm, center==true ? 0 : rw],
			list = circle_curve (r=rw, angle=circle_angle, piece=false, slices=fn_Ring)
		)
	);
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
	translate_z(center==true ? -h/2 : 0)
	linear_extrude(height=h, convexity=4)
	difference()
	{
		polygon(circle_curve(r = rx[1], angle=angle, piece=true, slices="x"));
		polygon(circle_curve(r = rx[0], angle=angle, piece=true, slices="x"));
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
	// return [ri1, ri2, ro1, ro2]
	r  = parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2);
	fn = get_fn_circle_current_x( max(r) );
	
	rotate_extrude_extend (angle=angle, $fn=fn)
	{
		polygon([
			[r[0],0], [r[2],0],
			[r[3],h], [r[1],h]
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

