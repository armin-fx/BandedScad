// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Objekte in Listen

use <banded/extend_logic.scad>
use <banded/helper_recondition.scad>
use <banded/math_vector.scad>
use <banded/list_edit_info.scad>
use <banded/draft_curves.scad>
use <banded/draft_transform.scad>
use <banded/draft_primitives_basic.scad>

use <banded/version.scad>


// - 2D:

// Erzeugt ein Dreieck, ein halbiertes Rechteck
// Parameter wie bei square_extend()
// Mit 'side' wird die übrigbleibende Seite des Dreiecks festgelegt
function triangle (size, center, align, side) =
	let (
		trace = triangle_curve (size, center, align, side)
	)
	[ trace, [[for (i=[0:1:len(trace)-1]) i]] ]
;

// erzeugt einen Ring als 2D Objekt
// Argumente:
//   r      - mittlerer Radius
//   ri, di - Innenradius, Innendurchmesser
//   ro, do - Außenradius, Außendurchmesser
//   w      - Breite der Wand
//   angle  - gezeichneter Winkel in Grad, Standart=360
//            als Zahl  = Winkel von 0 bis 'angle' = Öffnungswinkel
//            als Liste = [Öffnungswinkel, Anfangswinkel]
// Angegeben müssen:
//   genau 2 Angaben von r oder ri oder ro oder w
function ring (r, w, ri, ro, angle=360, center=false, d, di, do, outer, align) =
	let (
		 rx    = parameter_ring_2r(r, w, ri, ro, d, di, do)
		,angles = parameter_angle (angle, [360,0])
		,slices = get_slices_circle_current_x (max(rx), angles[0], true)
		,Outer  = parameter_numlist (2, outer, [0,0], true)
		,rx_o   = [for (i=[0:1]) rx[i] * get_circle_factor (slices, Outer[i], angles[0]) ]
		,Align = parameter_align (align, [0,0], center)
	)
	translate (v=[ Align.x*rx[1], Align.y*rx[1]], object=append_object(
		             circle_curve(r = rx_o[1], angle=angles, piece=true, slices=slices),
		reverse_full(circle_curve(r = rx_o[0], angle=angles, piece=true, slices=slices))
	) )
;


// - 3D:

// Erzeugt einen Keil, einen halbierten Quader
// Parameter wie bei cube_extend()
// Mit 'side' wird die übrigbleibende Seite des Keils festgelegt
function wedge (size, center, align, side) =
	let(
		 Size  = parameter_size_3d (size)
		,Align = parameter_align  (align, [1,1,1], center)
		,translate_align = [for (i=[0:1:len(Size)-1]) (Align[i]-1)*Size[i]/2 ]
		,Side = side==undef ? 0 : (side%12+12)%12
		//
		,x = Size.x
		,y = Size.y
		,z = Size.z
		//
		,a = [0,0,0] + translate_align
		,b = [x,0,0] + translate_align
		,c = [x,y,0] + translate_align
		,d = [0,y,0] + translate_align
		,e = [0,0,z] + translate_align
		,f = [x,0,z] + translate_align
		,g = [x,y,z] + translate_align
		,h = [0,y,z] + translate_align
		//
		,path = [[0,1,2],[5,4,3],[0,2,5,3],[1,0,3,4],[2,1,4,5]]
	)
	//             /_\   /_\
	//            0 1 2 3 4 5
	Side== 0 ? [ [a,d,e,b,c,f], path ] :
	Side== 1 ? [ [b,a,f,c,d,g], path ] :
	Side== 2 ? [ [d,h,a,c,g,b], path ] :
	Side== 3 ? [ [a,e,b,d,h,c], path ] :
	Side== 4 ? [ [e,a,h,f,b,g], path ] :
	Side== 5 ? [ [f,b,e,g,c,h], path ] :
	Side== 6 ? [ [h,e,d,g,f,c], path ] :
	Side== 7 ? [ [e,f,a,h,g,d], path ] :
	Side== 8 ? [ [a,b,d,e,f,h], path ] :
	Side== 9 ? [ [b,c,a,f,g,e], path ] :
	Side==10 ? [ [c,d,b,g,h,f], path ] :
	Side==11 ? [ [d,a,c,h,e,g], path ] :
	undef
;

// Erzeugt einen Keil mit den Parametern von FreeCAD
// v_min  = [Xmin, Ymin, Zmin]
// v_max  = [Xmax, Ymax, Zmax]
// v2_min = [X2min, Z2min]
// v2_max = [X2max, Z2max]
function wedge_freecad (v_min, v_max, v2_min, v2_max) =
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
function torus (r, w, ri, ro, angle=360, center=false, fn_ring, outer, align) =
	let (
		 rx = parameter_ring_2r(r, w, ri, ro)
		,rm = (rx[1] + rx[0]) / 2
		,rw = (rx[1] - rx[0]) / 2
	)
	rw<=0   ? undef :
	rm<=-rw ? undef :
	let (
		 max_r = max(rx)
		,Align = parameter_align (align, [0,0,1], center)
		,align_v = [ Align.x*max_r, Align.y*max_r, (Align.z-1)*rw]
		,angles = parameter_angle (angle, [360,0])
		,circle_angle =
			rm>=rw  ? [360,0] :
			let( alpha=acos(rm/rw) )  [2*(180-alpha), 180+alpha]
		,fn_Ring =
			is_num(fn_ring) ? fn_ring
			: get_slices_circle_current_x (rw, angle=circle_angle[0], piece=false)
		,fn_Torus     = get_slices_circle_current_x(rm+rw)
		,slices_Torus = get_slices_circle_current_x(rm+rw, angles[0])
		,Outer  = outer!=undef ? outer : 0
		,fudge_torus = get_circle_factor (slices_Torus, Outer, angles[0])
		,fudge_ring  = get_circle_factor (fn_Ring     , Outer, circle_angle[0])
		//
		,c   = circle_curve (r=rw, angle=circle_angle, piece=false, slices=fn_Ring)
		,c_R = rotate_list (c  , find_first_once_if (c, function(p) p.x> 0) )
		,c_r = rotate_list (c_R, find_first_once_if (c, function(p) p.x<=0) )
		,h_i = [for (p=c_r) if (p.x<=0) p]
		,h_o = [for (p=c_r) if (p.x> 0) p]
		,s_i = scale_points (h_i, fudge_ring)
		,s_o = scale_points (h_o, fudge_ring * [fudge_torus, 1])
		,t_i = translate_points(s_i, [rm            , rw])
		,t_o = translate_points(s_o, [rm*fudge_torus, rw])
		,curve = [ each t_i, each t_o]
		,size = len(curve)
		,curve_p =
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
			]
	)
	translate (v=align_v, object=
		rotate_extrude_extend_points (angle=angles, $fn=fn_Torus, list=curve_p)
	)
;

// erzeugt eine Röhre
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
function tube (h=1, r, w, ri, ro, angle=360, center=false, d, di, do, outer, align) =
	let (
		 rx    = parameter_ring_2r(r, w, ri, ro, d, di, do)
		,angles = parameter_angle (angle, [360,0])
		,slices = get_slices_circle_current_x (max(rx), angles[0], true)
		,Outer  = parameter_numlist (2, outer, [0,0], true)
		,rx_o   = [for (i=[0:1]) rx[i] * get_circle_factor (slices, Outer[i], angles[0]) ]
		,Align = parameter_align (align, [0,0,1], center)
	)
	translate (v=[ Align.x*rx[1], Align.y*rx[1], (Align.z-1)*h/2], object=
	rotate_extrude_extend_points (
		angle= angles,
		list =
			translate_points( v=[rx_o[0], 0], list=
			square_curve([ rx_o[1]-rx_o[0], h ]) )
	) )
;
function ring_square (h=1, r, w, ri, ro, angle=360, center=false, d, di, do, outer, align) =
	let(_= deprecated ("ring_square", "tube") )
	tube (h, r, w, ri, ro, angle, center, d, di, do, outer, align)
;

// Erzeugt einen Trichter
// Argumente:
//   h        - Höhe
//   ri1, ri2 - Innenradius unten, oben
//   ro1, ro2 - Außenradius unten, oben
//   ri, ro   - Innen- und Außenradius allgemein, gemeinsame Maße für unten und oben
//   w        - Breite der Wand. Optional
//   angle    - Öffnungswinkel des Trichters. Standard=360°. Benötigt Version 2019.05
function funnel (h=1, ri1, ri2, ro1, ro2, w, angle=360, di1, di2, do1, do2, ri, ro, di, do, outer, align) =
	let (
		// return [ri1, ri2, ro1, ro2]
		 r  = parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2, ri, ro, di, do)
		,max_r = max(r)
		,fn    = get_slices_circle_current_x( max_r )
		,angles = parameter_angle (angle, [360,0])
		,Outer  = parameter_numlist (2, outer, [0,0], true)
		,r_o    = [for (s=[0:1]) for (i=[0:1]) r[i+2*s] * get_circle_factor (fn, Outer[s], angles[0]) ]
		,Align = parameter_align (align, [0,0,1])
	)
	translate (v=[ Align.x*max_r, Align.y*max_r, (Align.z-1)*h/2], object=
	rotate_extrude_extend_points (angle=angles, $fn=fn,
		list=[
			[r_o[0],0], [r_o[2],0],
			[r_o[3],h], [r_o[1],h]
		]
	) )
;


// - Verschiedenes:

// Erzeugt ein Rechteck um die äußersten Punkte aus einer Liste
function bounding_square (points) =
	let (
		trace = bounding_square_curve (points)
	)
	trace==undef ? undef :
	let(
		path  = [[for (i=[0:1:len(trace)-1]) i ]]
	)
	[trace, path]
;

// Erzeugt ein Quader um die äußersten Punkte aus einer Liste
function bounding_cube (points) =
	(points==undef || len(points)<2) ? undef :
	let (
		 bx = bound_value (points, type=[0])
		,by = bound_value (points, type=[1])
		,bz = bound_value (points, type=[2])
	)
	(bx[0]>=bx[1] || by[0]>=by[1] || bz[0]>=bz[1]) ? undef :
	let (
		 x=bx[0], y=by[0], z=bz[0]
		,X=bx[1], Y=by[1], Z=bz[1]
		,points =
			[[x,y,z],[X,y,z],[X,Y,z],[x,Y,z]
			,[x,y,Z],[X,y,Z],[X,Y,Z],[x,Y,Z]]
		,path =
			[[0,1,2,3]  // bottom
			,[7,6,5,4]  // top
			,[4,5,1,0]  // front
			,[6,7,3,2]  // back
			,[5,6,2,1]  // right
			,[7,4,0,3]] // left
	)
	[points, path]
;

