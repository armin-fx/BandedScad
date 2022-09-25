// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen zum bearbeiten von Objekte in Listen,
// die an polygon() oder polyhedron() übergeben werden können.

use <banded/draft_curves.scad>
use <banded/draft_multmatrix_basic.scad>
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
//   opposite  = if true reverse rotation of helix, false = standard
//   slices    = count of segments from helix per full rotation
//
function helix_extrude_points (list, angle, rotations, pitch, height, r, opposite, slices) =
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
		,r_max_list = max_list (list, type=[0])
		,R_max      = max(R) + r_max_list
		,Slices =
			slices==undef ? get_slices_circle_current  (R_max, Angle) :
			slices=="x"   ? get_slices_circle_current_x(R_max, Angle) :
			max(2, ceil(slices * Rotations))
		,is_full = Angle==360 && Pitch==0
		
		// Y-Axis --to--> Z-Axis
		// TODO: use only right side
		,base     = [ for (e=list) [e[0],0,e[1]] ]
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
			  for (k=[0:1:len_base-1])
				[ n_a +  k
				, n_a + (k+1)%len_base
				, n_b + (k+1)%len_base
				, n_b +  k
				]
			]
		,faces_ends = is_full ? [] :
			[[ for (i=[len_base-1:-1:0]) i]
			,[ for (i=[0:1:len_base-1])  i + Slices*len_base ]
			]
	)
	is_full ? [points, faces]
	:         [points, concat(faces,faces_ends)]
;
