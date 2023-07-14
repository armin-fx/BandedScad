// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen zum bearbeiten von Objekte in Listen,
// die an polygon() oder polyhedron() übergeben werden können.

use <banded/draft_curves.scad>
use <banded/draft_matrix_basic.scad>
//
use <banded/helper.scad>
use <banded/extend.scad>
use <banded/math_common.scad>
use <banded/list_edit_data.scad>


// creates a helix with a 2D-polygon similar rotate_extrude
//
//   angle     = angle of helix in degrees - default: 360°
//   rotations = rotations of helix, can be used instead angle
//   height    = height of helix - default: 0 like rotate_extrude
//   pitch     = rise per rotation
//   r         = radius as number or [r1, r2]
//               r1 = bottom radius, r2 = top radius
//
//   opposite  = if true reverse rotation of helix, false = default
//   orientation = if true, orientation of Y-axis from the 2D-polygon is set along the surface of the cone.
//                 false = default, orientation of Y-axis from the 2D-polygon is set to Z-axis
//   slices    = count of segments from helix per full rotation
//
function helix_extrude_points (list, angle, rotations, pitch, height, r, opposite, orientation, slices) =
	helix_extrude (list, angle, rotations, pitch, height, r, opposite, orientation, slices)
;
//
function helix_extrude (object, angle, rotations, pitch, height, r, opposite, orientation, slices) =
	let(
		 Object = prepare_object_2d_path (object)
	)
	Object==undef ? undef :
	let (
		 R  = parameter_cylinder_r_basic (r, r[0], r[1], preset=[0,0])
		,rp = parameter_helix_to_rp (
			is_num(angle) ? angle/360 : rotations,
			pitch,
			height
			)
		,Rotations = abs(rp[0])
		,Angle     = Rotations * 360
		,Angle_begin = 0 // TODO or remove
		,Pitch     = rp[1]
		,Height    = Rotations * Pitch
		,Opposite  = xor( (is_bool(opposite) ? opposite : false), rp[0]<0 )
		,r_max_obj = max_value (Object[0], type=[0])
		,R_max     = max(R) + r_max_obj
		,Slices =
			slices==undef ? get_slices_circle_current  (R_max, Angle) :
			slices=="x"   ? get_slices_circle_current_x(R_max, Angle) :
			max(2, ceil(slices * Rotations))
		,is_full = Angle==360 && Pitch==0
		,points_obj =
			orientation==true ?
				let(
					m = matrix_rotate (-90, d=2, short=true)
					  * matrix_rotate_to_vector ([-(R[0]-R[1]),Height], d=2, short=true)
				)
				[ for (e=Object[0]) m*e ]
			:	Object[0]
		
		// Y-Axis --to--> Z-Axis
		// TODO: use only right side
		,base     = [ for (e=points_obj) [e[0],0,e[1]] ]
		,len_base = len(base)
		,points =
			[ for (n=[0:1: Slices - (is_full ? 1 : 0) ])
				let (
					 m = matrix_rotate_z (
						 Angle_begin + Angle * n/Slices * (Opposite==true ? -1 : 1)
						 , d=3, short=true )
					,z = Height * n/Slices
					,r = bezier_1(n/Slices, R)
				)
				for (e=base) m * (e + [r,0,z])
			]
		,faces =
			[ for (n=[0:1:Slices-1])
				let(
				 n_a = n*len_base
				,n_b = is_full ?
					 (n+1)%Slices*len_base
					:(n+1)       *len_base
				)
			  for (p=Object[1])
				let( len_p = len(p) )
			  for (k=[0:1:len_p-1])
				[ n_a + p[ k ]
				, n_a + p[(k+1)%len_p ]
				, n_b + p[(k+1)%len_p ]
				, n_b + p[ k ]
				]
			]
	)
	is_full ? [points, faces]
	:
	let (
		 triangles        = tesselate_all_paths ( Object[0], Object[1] )
		,bottom_triangles = reverse_all (triangles)
		,top_triangles    = add_all_each_with (triangles, Slices*len_base )
	)
	[points, [ each faces, each bottom_triangles, each top_triangles ] ]
;
