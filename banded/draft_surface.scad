// Copyright (c) 2024 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Funktionen, die Oberflächen beschreiben

use <banded/extend_logic_circle.scad>
use <banded/math_vector.scad>
use <banded/math_matrix.scad>
use <banded/list_edit_item.scad>
use <banded/draft_curves.scad>


function bezier_surface_point (t, p) =
	let (
		,bezier = [ for (b=p) bezier_point (t[1], b) ]
		,point  =             bezier_point (t[0], bezier)
	)
	point
;
function bezier_surface_grid (p, slices) =
	let (
		Slices =
			slices==undef ? max(2, get_slices_circle_current  (max_norm(concat_list(p))/4) ) :
			slices=="x"   ? max(2, get_slices_circle_current_x(max_norm(concat_list(p))/4) ) :
			slices< 2     ? 2 :
			slices
		,bezier = transpose ([ for (b=p)      bezier_curve (b, slices=Slices) ])
		,points =            [ for (b=bezier) bezier_curve (b, slices=Slices) ]
	)
	points
;
function bezier_surface_mesh (p, slices) =
	grid_to_mesh_square (bezier_surface_grid (p, slices) )
;

function bezier_triangle_point (t,p) =
	let (
		 s = len (p)
		,c = t[0]+t[1]+t[2]
	)
	c==0 ? undef :
	s<=1 ? undef :
	s==2 ?
		( p[0][0]*t[0]
		+ p[0][1]*t[1]
		+ p[1][0]*t[2]) / c :
	bezier_triangle_point (t,
		[ for (i=[0:1:s-2])
		[ for (j=[0:1:s-i-2])
			( p[i  ][j  ]*t[0]
			+ p[i  ][j+1]*t[1]
			+ p[i+1][j  ]*t[2]) / c
		]]
	)
;
function bezier_triangle_grid (p, slices) =
	let (
		n =
			slices==undef ? max(2, get_slices_circle_current  (max_norm(concat_list(p))/4) ) :
			slices=="x"   ? max(2, get_slices_circle_current_x(max_norm(concat_list(p))/4) ) :
			slices< 2     ? 2 :
			slices
	)
	[ for (i=[0:1:n-1])
	[ for (j=[0:1:n-i-1])
		bezier_triangle_point ([ (n-i-1)-j, j, i], p)
	] ]
;
function bezier_triangle_mesh (p, slices) =
	grid_to_mesh (bezier_triangle_grid (p, slices) )
;

function grid_to_mesh (p) =
	let (
		 points = concat_list(p)
		,faces  = grid_to_mesh_intern (p, points, len(p))
	)
	[points, faces]
;
function grid_to_mesh_intern (p, points, s, k=0, i=0, faces=[]) =
	i==s-1 ? faces :
	let (
		z = len(p[i]),
		Z = len(p[i+1]),
		f = [ each faces
			, each
			  (z==Z) ?
				[for (j=[k:1:k+(z-2)])
				if ( norm(points[j]-points[j+z+1]) <= norm(points[j+z]-points[j+1]) )
					each
					[ [j,j+z  ,j+z+1]
					, [j,j+z+1,j+1  ]
					]
				else
					each
					[ [j+z,j+1  ,j  ]
					, [j+z,j+z+1,j+1]
					]
				]
			  : (z==Z+1) ?
				[ each [for (j=[k:1:k+(z-2)]) [j  ,j+z  ,j+1] ]
				, each [for (j=[k:1:k+(Z-2)]) [j+z,j+z+1,j+1] ]
				]
			  : (z==Z-1) ?
				[ each [for (j=[k:1:k+(Z-2)]) [j,j+z  ,j+z+1] ]
				, each [for (j=[k:1:k+(z-2)]) [j,j+z+1,j+1  ] ]
				]
			  :	[] // TODO
			]
	)
	grid_to_mesh_intern (p, points, s, k+z, i+1, f)
;

function grid_to_mesh_square (p) =
	let (
		 points = concat_list(p)
		,s      = len(p)
		,z      = len(p[0])
		,faces  =
			[ for (i=[0:1:s-2])
			  for (j=[0:s:s*(z-2)])
				if ( norm(points[j+i]-points[j+i+s+1]) <= norm(points[j+i+s]-points[j+i+1]) )
					each
					[ [j+i,j+i+s  ,j+i+s+1]
					, [j+i,j+i+s+1,j+i+1  ]
					]
				else
					each
					[ [j+i+s,j+i+1  ,j+i  ]
					, [j+i+s,j+i+s+1,j+i+1]
					]
			]
	)
	[points, faces]
;

