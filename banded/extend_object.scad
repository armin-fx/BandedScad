// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// stellt die Module bereit, die um weitere Eigenschaften ergänzt werden
// kann einzeln geladen werden

use <banded/extend_logic.scad>
use <banded/helper_native.scad>
use <banded/helper_recondition.scad>
use <banded/draft_curves.scad>


// Erzeugt einen Kreis
// Argumente wie function circle_curve()
// Kompatibel mit OpenSCAD Modul circle()
module circle_extend (r, angle, slices="x", piece=true, d)
{
	angles = parameter_angle (angle, [360,0]);
	polygon(circle_curve (r=r, angle=angle, slices=slices, piece=piece, d=d),
	        convexity=(piece==true && angles[0]>180) ? 4 : 2);
}

// Erzeugt einen Zylinder
// Kompatibel mit OpenSCAD Modul cylinder()
// Argumente des Kreisbogens wie circle_extend()
module cylinder_extend (h, r1, r2, center=false, r, d, d1, d2, angle, slices="x", piece=true)
{
	R        = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	R_sorted = R[0]>R[1] ? R : [R[1],R[0]]; // erster Radius muss größer oder gleich sein
	H        = get_first_num (h, 1);
	angles = parameter_angle (angle, [360,0]);
	//
	module mirror_at_z_choice (p, choice)
	{
		if (choice==true) mirror_at_z(p) children();
		else              children();
	}
	
	mirror_at_z_choice ([0,0,H/2], R[0]<R[1])
	linear_extrude(height=H, center=center
		,scale=R_sorted[1]/R_sorted[0]
		,convexity=(piece==true && angles[0]>180) ? 4 : 2)
	circle_extend (r=R_sorted[0], angle=angles, slices=slices, piece=piece);
}
/*
module cylinder_extend (h, r1, r2, center=false, r, d, d1, d2)
{
	R = parameter_cylinder_r (r, r1, r2, d, d1, d2);
	cylinder(h=h, r1=R[0], r2=R[1], center=center, $fn=get_fn_circle_current_x(max(R[0],R[1]));
}*/

// Erzeugt eine Kugel
// Argumente wie OpenSCAD Modul sphere()
// TODO Argument angle
module sphere_extend (r, d)
{
	R = parameter_circle_r (r, d);
	sphere(r=R, $fn=get_fn_circle_current_x(R));
}

