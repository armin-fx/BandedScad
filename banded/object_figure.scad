// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Objekte

use <banded/extend.scad>
use <banded/helper.scad>
use <banded/math_vector.scad>
use <banded/list_edit_info.scad>
use <banded/draft_curves.scad>
use <banded/draft_primitives_figure.scad>
use <banded/operator_transform.scad>


// - 2D:

// Erzeugt ein Dreieck, ein halbiertes Rechteck
// Parameter wie bei square_extend()
// Mit 'side' wird die übrigbleibende Seite des Dreiecks festgelegt
module triangle (size, center, align, side)
{
	polygon (
		triangle_curve (size, center, align, side) );
}


// - 3D:

// Erzeugt einen Keil, einen halbierten Quader
// Parameter wie bei cube_extend()
// Mit 'side' wird die übrigbleibende Seite des Keils festgelegt
module wedge (size, center, align, side)
{
	o = wedge (size, center, align, side);
	//
	polyhedron( o[0], o[1] );
}

// Erzeugt einen Keil mit den Parametern von FreeCAD
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
module wedge_freecad (v_min, v_max, v2_min, v2_max)
{
	o = wedge_freecad (v_min, v_max, v2_min, v2_max);
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
module torus (r, w, ri, ro, angle=360, center=false, fn_ring, outer, align)
{
	rx = parameter_ring_2r(r, w, ri, ro);
	rm = (rx[1] + rx[0]) / 2;
	rw = (rx[1] - rx[0]) / 2;
	//
	if (! (rw<=0 || rm<=-rw) )
	{
		max_r = max(rx);
		Align = parameter_align (align, [0,0,1], center);
		align_v = [ Align[0]*max_r, Align[1]*max_r, Align[2]*rw - rw];
		angles = parameter_angle (angle, [360,0]);
		circle_angle =
			rm>=rw  ? [360,0] :
			let( alpha=acos(rm/rw) )  [2*(180-alpha), 180+alpha]
		;
		fn_Ring =
			is_num(fn_ring) ? fn_ring
			: get_slices_circle_current_x (rw, angle=circle_angle[0], piece=false)
		;
		fn_Torus     = get_slices_circle_current_x(rm+rw);
		slices_Torus = get_slices_circle_current_x(rm+rw, angles[0]);
		Outer  = outer!=undef ? outer : 0;
		fudge_torus = get_circle_factor (slices_Torus, Outer, angles[0]);
		fudge_ring  = get_circle_factor (fn_Ring     , Outer, circle_angle[0]);
		//
		c   = circle_curve (r=rw, angle=circle_angle, piece=false, slices=fn_Ring);
		c_R = rotate_list (c  , find_first_once_if (c, function(p) p.x> 0) );
		c_r = rotate_list (c_R, find_first_once_if (c, function(p) p.x<=0) );
		h_i = [for (p=c_r) if (p.x<=0) p];
		h_o = [for (p=c_r) if (p.x> 0) p];
		s_i = scale_points (h_i, fudge_ring);
		s_o = scale_points (h_o, fudge_ring * [fudge_torus, 1]);
		t_i = translate_points(s_i, [rm            , rw]);
		t_o = translate_points(s_o, [rm*fudge_torus, rw]);
		curve = [ each t_i, each t_o];
		size = len(curve);
		curve_p =
			[for (i=[size:1:2*size])
				if (curve[i%size].x>=0) curve[i%size]
				else let (
					p = curve[(i-1)%size],
					o = curve[ i   %size],
					n = curve[(i+1)%size]
				)	
				each [
					 if (p.x>=0) [0, lerp (p.y,o.y, 0, [p.x,o.x]) ]
					,if (n.x>=0) [0, lerp (o.y,n.y, 0, [o.x,n.x]) ]
				]
			];
		
		translate (align_v)
		rotate_extrude_extend (angle=angles, $fn=fn_Torus)
		polygon(curve_p);
	}
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
module ring_square (h=1, r, w, ri, ro, angle=360, center=false, d, di, do, outer, align)
{
	rx     = parameter_ring_2r (r, w, ri, ro, d, di, do);
	angles = parameter_angle (angle, [360,0]);
	slices = get_slices_circle_current_x (max(rx), angles[0], true);
	Outer  = parameter_numlist (2, outer, [0,0], true);
	rx_o   = [for (i=[0:1]) rx[i] * get_circle_factor (slices, Outer[i], angles[0]) ];
	Align  = parameter_align (align, [0,0,1], center);
	//
	translate ([ Align[0]*rx[1], Align[1]*rx[1], Align[2]*h/2 - h/2])
	linear_extrude(height=h, convexity=4)
	difference()
	{
		polygon(circle_curve(r = rx_o[1], angle=angles, piece=true, slices=slices));
		polygon(circle_curve(r = rx_o[0], angle=angles, piece=true, slices=slices));
	}
}

// Erzeugt einen Trichter
// Argumente:
//   h        - Höhe
//   ri1, ri2 - Innenradius unten, oben
//   ro1, ro2 - Außenradius unten, oben
//   w        - Breite der Wand. Optional
//   angle    - Öffnungswinkel des Trichters. Standard=360°. Benötigt Version 2019.05
module funnel (h=1, ri1, ri2, ro1, ro2, w, angle=360, di1, di2, do1, do2, outer, align)
{
	// return [ri1, ri2, ro1, ro2]
	r  = parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2);
	max_r = max(r);
	fn    = get_slices_circle_current_x( max_r );
	angles = parameter_angle (angle, [360,0]);
	Outer  = parameter_numlist (2, outer, [0,0], true);
	r_o    = [for (s=[0:1]) for (i=[0:1]) r[i+2*s] * get_circle_factor (fn, Outer[s], angles[0]) ];
	Align = parameter_align (align, [0,0,1]);
	
	translate ([ Align[0]*max_r, Align[1]*max_r, Align[2]*h/2 - h/2])
	rotate_extrude_extend (angle=angles, $fn=fn)
	{
		polygon([
			[r_o[0],0], [r_o[2],0],
			[r_o[3],h], [r_o[1],h]
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


// - Verschiedenes:

// leeres Modul
module empty () {}

// Erzeugt ein Rechteck um die äußersten Punkte aus einer Liste
module bounding_square (points)
{
	trace = bounding_square_curve (points);
	//
	if (trace!=undef) polygon (trace);
}

// Erzeugt ein Quader um die äußersten Punkte aus einer Liste
module bounding_cube (points)
{
	o = bounding_cube (points);
	//
	if (points!=undef) polyhedron( o[0], o[1] );
}

