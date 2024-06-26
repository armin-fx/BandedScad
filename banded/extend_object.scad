// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// stellt die Module bereit, die um weitere Eigenschaften ergänzt werden
// kann einzeln geladen werden

use <banded/extend_logic.scad>
use <banded/helper_native.scad>
use <banded/helper_recondition.scad>
use <banded/draft_curves.scad>


// - 2D:

// Erzeugt ein Rechteck
// Kompatibel mit OpenSCAD Modul square()
module square_extend (size, center, align)
{
	Size  = parameter_size_2d(size);
	Align = parameter_align (align, [1,1], center);
	
	translate ([for (i=[0:1:len(Size)-1]) Align[i]*Size[i]/2 ])
	square (Size, center=true);
}

// Erzeugt einen Kreis
// Argumente wie function circle_curve()
// Kompatibel mit OpenSCAD Modul circle()
module circle_extend (r, angle=360, slices="x", piece=true, outer, align, d)
{
	angles = parameter_angle (angle, [360,0]);
	
	polygon(circle_curve (r=r, angle=angle, slices=slices, piece=piece, outer=outer, align=align, d=d),
	        convexity=(piece==true && angles[0]>180) ? 4 : 2);
}

// - 3D:

// Erzeugt einen Quader
// Argumente wie OpenSCAD Modul cube()
module cube_extend (size, center, align)
{
	Size  = parameter_size_3d (size);
	Align = parameter_align   (align, [1,1,1], center);
	
	translate ([for (i=[0:1:len(Size)-1]) Align[i]*Size[i]/2 ])
	cube (Size, center=true);
}

// Erzeugt einen Zylinder
// Kompatibel mit OpenSCAD Modul cylinder()
// Argumente des Kreisbogens wie circle_extend()
module cylinder_extend (h, r1, r2, center, r, d, d1, d2, angle=360, slices="x", piece=true, outer, align)
{
	R        = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	R_sorted = R[0]>R[1] ? R : [R[1],R[0]]; // erster Radius muss größer oder gleich sein
	H        = get_first_num (h, 1);
	angles = parameter_angle (angle, [360,0]);
	Align  = parameter_align (align, [0,0,1], center);
	//
	module mirror_z_choice (choice)
	{
		if (choice==true) mirror_z() children();
		else              children();
	}
	
	translate ([ Align[0]*R_sorted[0], Align[1]*R_sorted[0], Align[2]*H/2 ])
	mirror_z_choice (R[0]<R[1])
	linear_extrude (height=H, center=true
		,scale=R_sorted[1]/R_sorted[0]
		,convexity=(piece==true && angles[0]>180) ? 4 : 2)
	circle_extend (r=R_sorted[0], angle=angles, slices=slices, piece=piece, outer=outer);
}

// Erzeugt eine Kugel
// Argumente wie OpenSCAD Modul sphere()
// TODO Argument angle
module sphere_extend (r, d, outer, align)
{
	R     = parameter_circle_r (r, d);
	Align = parameter_align (align, [0,0,0]);
	Outer = outer!=undef ? outer : 0;
	fn    = get_slices_circle_current_x (R);
	
	translate (Align*R)
	if (outer==0)
		sphere (r=R, $fn=fn);
	else
	{
		fn_polar  = fn + fn%2;
		fudge_pol = get_circle_factor (fn_polar, Outer);
		fudge_mid = get_circle_factor (fn      , Outer);
		fudge_all = fudge_pol * fudge_mid;
		//
		//scale (fudge_pol)
		scale ([fudge_all,fudge_all,fudge_pol])
		sphere (r=R, $fn=fn);
	}
}

// - 2D to 3D:

// modifiziert linear_extrude()
//
// Zusätzliche Angaben:
//   align   - Ausrichtung eines Objekts vom Mittelpunkt aus an der Z-Achse.
//           - als Liste wird nur die Z-Achse ausgewertet, andere Achsenangaben werden ignoriert
//           - als Zahl für die Z-Achse direkt
module linear_extrude_extend (height, center, twist, slices, scale, align, convexity)
{
	H     = height!=undef ? height : 100;
	Align = parameter_align (align, [0,0,1], center);
	
	translate ([0,0, H * (Align.z-1)/2 ])
	linear_extrude (height=H, twist=twist, slices=slices, scale=scale, convexity=convexity)
		children();
}

// modifiziert rotate_extrude()
// Objekte erstellt mit rotate_extrude() sind anders gedreht
// als z.B. das Objekt cylinder().
// Mit rotate_extrude_extend() können diese Objekte korrekt verbunden werden.
//
// Zusätzliche Angaben:
//   angle  - gezeichneter Winkel in Grad, Standart=360
//            als Zahl  = Winkel von 0 bis 'angle' = Öffnungswinkel
//            als Liste = [Öffnungswinkel, Anfangswinkel]
module rotate_extrude_extend (angle=360, slices, convexity)
{
	angles = parameter_angle (angle, 360);
	Slices =
		slices==undef ? undef :
		slices=="x"   ? undef :
	//	slices=="x"   ? get_slices_circle_current_x(r_max,angles[0]) :
		slices<2 ? angles[0]<180 ? 2 : 3
		:slices;
	fn = slices==undef ? $fn : get_fn_circle (slices, angles[0]);
	//
	rotate ([0,0, angles[1] + (abs(angles[0])>=360 ? 180 : 0) ])
	rotate_extrude (angle=angles[0], convexity=convexity, $fn=fn) children();
}
