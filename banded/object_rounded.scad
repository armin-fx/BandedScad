// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige Objekte zum Erzeugen von abgerundeten Ecken und Kanten

include <banded/constants.scad>
//
use <banded/extend.scad>
use <banded/helper_native.scad>
use <banded/helper_recondition.scad>
use <banded/math_vector.scad>
use <banded/draft_curves.scad>
use <banded/draft_transform_common.scad>
use <banded/draft_transform_basic.scad>
use <banded/operator_transform.scad>


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
//   extra   zusätzlichen Überstand anlegen, wegen Z-Fighting
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
module edge_ring_fillet (r_ring, r, angle=90, angle_ring=360, type, outer, extra=extra)
{
	Type = is_num(type) ? type : 0;
	if (Type==1) edge_ring_rounded (r_ring, r, angle, angle_ring, outer, extra=extra);
	if (Type==2) edge_ring_chamfer (r_ring, r, angle, angle_ring, outer, extra=extra);
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
//   extra   zusätzlichen Überstand anlegen, wegen Z-Fighting
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
//   r_ring      Radius des Zylinders an der Kante
//   angle_ring  Winkel des Zylinders, Standart=360°
module edge_ring_rounded (r_ring, r, angle=90, angle_ring=360, outer, extra=extra, d, d_ring)
{
	R       = parameter_circle_r(r, d);
	R_ring  = parameter_circle_r(r_ring, d_ring);
	angles_ring = parameter_angle(angle_ring, 360);
	fn      = get_slices_circle_current_x(R);
	fn_ring = get_slices_circle_current_x(R_ring);
	Outer   = outer!=undef ? outer : 0;
	R_ring_outer = R_ring * get_circle_factor (fn_ring, Outer, angles_ring[0]);
	//
	if (R>0 && R_ring>0) // TODO no fillet
	{
		rotate_extrude_extend (angle=angles_ring, convexity=4, $fn=fn_ring)
		translate_x (R_ring_outer)
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
	if (R>0 && Angle<180)
	rotate_z(rotation)
	polygon( concat(
		translate_points(
			circle_curve(r=R, angle=[180-Angle, 90+Angle], piece=0, slices="x")
			,[R*t_factor,R]
		)
		,[
			 [ R    *t_factor,-extra]
			,[-extra*t_factor,-extra]
			,translate_points(
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
module edge_ring_chamfer (r_ring, c, angle=90, angle_ring=360, outer, extra=extra, d_ring)
{
	R_ring   = parameter_circle_r(r_ring, d_ring);
	angles_ring = parameter_angle(angle_ring, 360);
	fn_ring = get_slices_circle_current_x(R_ring);
	Outer   = outer!=undef ? outer : 0;
	R_ring_outer = R_ring * get_circle_factor (fn_ring, Outer, angles_ring[0]);
	//
	if (c>0 && R_ring>0) // TODO no fillet
	{
		rotate_extrude_extend (angle=angles_ring, convexity=2, $fn=fn_ring)
		translate_x (R_ring_outer)
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
	if (c>0 && Angle<180)
	rotate_z(rotation)
	polygon([
		 [ t,       0]
		,[ t      ,-extra]
		,[-h_extra,-extra]
		,translate_points(
			[circle_point(r=t+h_extra, angle=Angle)]
			,[-h_extra,-extra]
		)[0]
		,circle_point(r=t, angle=Angle)
	]);
}

// erzeugt eine gefaste Kante aus den Daten Linie der Kante und 2 Eckpunkten der angrenzenden Flächen
module edge_fillet_to (line, point1, point2, r, type, extra=extra, extra_h=0, directed=true)
{
	base_vector = [1,0];
	origin      = line[0];
	line_vector = line[1] - line[0];
	up_to_z     = rotate_backwards_to_vector_points ( translate_points ([point1,point2], -origin), line_vector);
	plane       = projection_points (up_to_z);
	angle_base  = rotation_vector (base_vector, plane[0]);
	angle_points= rotation_vector (plane[0]   , plane[1]);
	angle_fillet=    angle_vector (plane[0]   , plane[1]);
	//
	if (directed==false ? true : angle_points<180)
	{
		translate (origin)
		rotate_to_vector (line_vector, angle_base - (angle_points<180 ? 0 : angle_fillet))
		translate_z (-extra_h)
		edge_fillet (h=norm(line_vector)+extra_h*2, r=r, angle=angle_fillet, type=type, extra=extra);
	}
}
module edge_rounded_to (line, point1, point2, r, extra=extra, extra_h=0, directed=true)
{
	edge_fillet_to (line, point1, point2, r, type=1, extra=extra, extra_h=extra_h, directed=directed);
}
module edge_chamfer_to (line, point1, point2, c, extra=extra, extra_h=0, directed=true)
{
	edge_fillet_to (line, point1, point2, c, type=2, extra=extra, extra_h=extra_h, directed=directed);
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
	if (c==max(a,b,c))  render(convexity=8) intersection()
	{
		fn_c = get_slices_circle_current_x (c, 90);
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
