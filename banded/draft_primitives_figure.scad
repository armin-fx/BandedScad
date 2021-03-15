// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält einige zusätzliche Objekte in Listen

use <banded/math_vector.scad>


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
