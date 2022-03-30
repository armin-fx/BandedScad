// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Objekte in Listen

use <banded/extend_logic.scad>
use <banded/helper_recondition.scad>
use <banded/math_vector.scad>
use <banded/draft_curves.scad>
use <banded/draft_transform.scad>
use <banded/draft_primitives_basic.scad>


// Erzeugt einen Keil mit den Parametern von FreeCAD
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
function wedge (v_min, v_max, v2_min, v2_max) =
	let(
	Vmin  = v_min,
	Vmax  = v_max,
	V2min = [v2_min[0], 0, v2_min[1]],
	V2max = [v2_max[0], 0, v2_max[1]],
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
		pick_vector( V2min, Vmax, V2max )]  //7
	,
	CubeFaces = [
		[0,1,2,3],  // bottom
		[7,6,5,4],  // top
		[4,5,1,0],  // front
		[6,7,3,2],  // back
		[5,6,2,1],  // right
		[7,4,0,3]]  // left
	)
	[CubePoints, CubeFaces]
;

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
function torus (r, w, ri, ro, angle=360, center=false, fn_ring) =
	let (
		 rx = parameter_ring_2r(r, w, ri, ro)
		,rm = (rx[1] + rx[0]) / 2
		,rw = (rx[1] - rx[0]) / 2
		,circle_angle =
			rw<=0   ? undef :
			rm<=-rw ? undef :
			rm>=rw  ? [360,0] :
			let( alpha=acos(rm/rw) )  [2*(180-alpha), 180+alpha]
		,fn_Ring =
			is_num(fn_ring) ? fn_ring
			: get_fn_circle_current_x (rw, angle=circle_angle[0], piece=false)
	)
	circle_angle==undef ? undef :
	//
	rotate_extrude_extend_points (angle=angle, $fn=get_fn_circle_current_x(rm+rw),
		list =
		translate_points(
			v    = [ rm, center==true ? 0 : rw],
			list = circle_curve (r=rw, angle=circle_angle, piece=false, slices=fn_Ring)
		)
	)
;

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
function ring_square (h, r, w, ri, ro, angle=360, center=false, d, di, do) =
	let (
		rx = parameter_ring_2r(r, w, ri, ro, d, di, do)
	)
	rotate_extrude_extend_points (
		angle= angle,
		list =
			translate_points( v=[rx[0], (center==true ? -h/2 : 0)], list=
			square_curve([ rx[1]-rx[0], h ]) )
	)
;

// Erzeugt einen Trichter
// Argumente:
//   h        - Höhe
//   ri1, ri2 - Innenradius unten, oben
//   ro1, ro2 - Außenradius unten, oben
//   w        - Breite der Wand. Optional
//   angle    - Öffnungswinkel des Trichters. Standard=360°. Benötigt Version 2019.05
function funnel (h=1, ri1, ri2, ro1, ro2, w, angle=360, di1, di2, do1, do2) =
	let (
		// return [ri1, ri2, ro1, ro2]
		 r  = parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2)
		,fn = get_fn_circle_current_x( max(r) )
	)
	rotate_extrude_extend_points (angle=angle, $fn=fn,
		list=[
			[r[0],0], [r[2],0],
			[r[3],h], [r[1],h]
		] )
;
