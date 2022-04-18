// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen erzeugen Objekte in Listen,
// deren Daten an polygon() oder polyhedron() übergeben werden können.
//
// Listenkonvention:
// [ points ]
// [ points, path ]
// [ points, [path, path2, ...] ]    -> Standard
// [ [points, points2, ...], [path, path2, ...] ]
//
// Position in der Objektliste:
//  [0] - Punktliste
//  [1] - Zusammengehörigkeit der Punkte
//  [2] - Farbe des Objekts

use <banded/draft_curves.scad>
use <banded/draft_multmatrix.scad>
use <banded/draft_transform.scad>
use <banded/draft_color.scad>
//
use <banded/helper.scad>
use <banded/extend.scad>
use <banded/list_edit_data.scad>


// - 2D:

function square (size, center, align) =
	let(
		points = square_curve (size, center, align),
		path   = [[for (i=[0:1:len(points)-1]) i ]]
	)
	[points, path]
;

function circle (r, angle=360, slices, piece=0, outer, align, d) =
	let(
		points = circle_curve (r=r, angle=angle, slices=slices, piece=piece, outer=outer, align=align, d=d),
		path   = [[for (i=[0:1:len(points)-1]) i ]]
	)
	[points, path]
;


// - 3D:

function cube (size, center, align) =
	let(
		 Size = parameter_size_3d (size)
		,Align = parameter_align  (align, [1,1,1], center)
		,translate_align = [for (i=[0:1:len(Size)-1]) Align[i]*Size[i]/2 ]
		,x    = Size.x
		,y    = Size.y
		,z    = Size.z
		,points =
			[[0,0,0],[x,0,0],[x,y,0],[0,y,0]
			,[0,0,z],[x,0,z],[x,y,z],[0,y,z]]
		,path =
			[[0,1,2,3]  // bottom
			,[7,6,5,4]  // top
			,[4,5,1,0]  // front
			,[6,7,3,2]  // back
			,[5,6,2,1]  // right
			,[7,4,0,3]] // left
	)
	[
		translate_points( points, translate_align - Size/2 )
	    , path
	]
;

function cylinder (h, r1, r2, center, r, d, d1, d2, angle=360, slices="x", piece=true, outer, align) =
	let(
		 R      = parameter_cylinder_r (r, r1, r2, d, d1, d2)
		,R_max  = R[0]>R[1] ? R[0] : R[1]
		,H      = get_first_num (h, 1)
		,H_both = center==true ? [-H,H]/2 : [0,H]
		,angles = parameter_angle (angle, [360,0])
		,Angle  = angles[0]
		,Slices = // copy and paste from circle_curve():
			slices==undef ? get_slices_circle_current  (R_max,Angle,piece) :
			slices=="x"   ? get_slices_circle_current_x(R_max,Angle,piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,c1 = circle_curve (r=R[0], angle=angles, slices=Slices, piece=piece, outer=outer, align=align)
		,c2 = circle_curve (r=R[1], angle=angles, slices=Slices, piece=piece, outer=outer, align=align)
		,n  = len(c1)
	)
	[
		concat(
			[ for (i=[0:1:n-1]) [c1[i][0],c1[i][1],H_both[0]] ],
			[ for (i=[0:1:n-1]) [c2[i][0],c2[i][1],H_both[1]] ]
		),
		concat(
			[[ for (i=[0    : 1:n-1]) i ]
			,[ for (i=[n*2-1:-1:n  ]) i ]
			]
			,
			//[ for (i=[0:1:n-1]) [(i+1)%n, i%n, n+i%n, n+(i+1)%n] ]
			[[ 0, n-1, n*2-1, n ]],
			[ for (i=[0:1:n-2]) [i+1, i, n+i, n+i+1] ]
		)
	]
;

function sphere (r, d, align) =
	let(
		 R        = parameter_circle_r (r, d)
		,Align    = parameter_align (align, [0,0,0])
		,translate_align = R*Align
		,fn       = get_slices_circle_current_x (R)
		,fn_polar = fn + fn%2
		,c =
			[ for (a=[1:2:fn_polar])
				let(
					// von oben nach unten: [höhe, radius]
					p=circle_point_r (R, 180*a/fn_polar)
				)
				// von unten nach oben [Kreisscheiben]
				[ for (e=circle_curve_intern (r=p[1], slices=fn))
					[e[0],e[1],-p[0]]
					+ translate_align
				]
			]
	)
	[
		concat_list (c)
		,
		concat(
			[	//  untere Kreisscheibe
				[for (i=[0:1:fn-1]) i ]
				,// obere Kreisscheibe
				[for (i=[fn*fn_polar/2-1:-1:(fn)*(fn_polar/2-1)]) i ]
			]
			, // Seitenflächen
			concat_list (
			[ for (k=[0:1:fn_polar/2-2])
				let( o = fn*k )
				[ for (i=[0:1:fn-1])
					[(i+1)%fn+o, i%fn+o, fn+i%fn+o, fn+(i+1)%fn+o]
				]
			] )
		)
	]
;

// - Objekte transformieren:

function transform_function (object, fn) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		fn (list)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				fn (list)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				fn (list)
				]
			:undef
		:
			object[k]
	]
;

function translate (object, v) = transform_function (object, function (list)
    translate_points (list, v) )
;
function rotate (object, a, v, backwards=false) = transform_function (object, function (list)
    rotate_points (list, a, v, backwards=false) )
;
function mirror (object, v) = transform_function (object, function (list)
    mirror_points (list, v) )
;
function scale (object, v) = transform_function (object, function (list)
    scale_points (list, v) )
;
function resize (object, newsize) = transform_function (object, function (list)
    resize_points (list, newsize) )
;
function multmatrix (object, m) = transform_function (object, function (list)
    multmatrix_points (list, m) )
;

function projection (object, cut, plane) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		projection_points (object, plane)
	:
	echo("Not working yet")
	let(
		Object = unify_object(object)
	)
	Object
;

function rotate_extrude_points (list, angle=360, slices) =
	angle==360 ?
		rotate_extrude_extend_points (list, [360,180], slices)
	:	rotate_extrude_extend_points (list, angle    , slices)
;
function rotate_extrude_extend_points (list, angle=360, slices="x") =
	let (
		 r_max       = max_list (list, type=[0])
		,angles      = parameter_angle (angle, [360,0])
		,Angle_begin = angles[1]
		,Angle       = angles[0]
		,Slices =
			slices==undef ? get_slices_circle_current  (r_max,Angle) :
			slices=="x"   ? get_slices_circle_current_x(r_max,Angle) :
			slices<2 ? Angle<180 ? 2 : 3
			:slices
		,is_full = Angle==360
		// Y-Axis --to--> Z-Axis
		// TODO: use only right side
		,base     = [ for (e=list) [e[0],0,e[1]] ]
		,len_base = len(base)
		,points =
			[ for (n=[0:1: Slices - (is_full ? 1 : 0) ])
				let ( m = matrix_rotate_z (Angle_begin + Angle * n/Slices, d=3, short=true) )
				for (e=base) m * e
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

function linear_extrude_points (list, height, center, twist, slices, scale) =
	(list==undef || len(list)<3) ? undef :
	let(
		 H     = height!=undef ? height : 100
		,Twist = twist !=undef ? twist  : 0
		,Scale = parameter_scale (scale, 2)
		,Center = center==true
		,Slices = get_slices_extrude (list, H, Twist, slices, Scale, $fn, $fs, $fa)
		//
		,len_base = len(list)
		//
		,points =
			[ for (n=[0:1:Slices])
				let (
					 m_r = matrix_rotate_z  (-Twist * n/Slices, d=2, short=true)
				//	,m_s = matrix_scale     (bezier_1 (n/Slices, [[1,1],Scale]), d=2, short=true)
					,m_s = matrix_scale     ([1,1] * ((Slices-n)/Slices) + Scale * (n/Slices), d=2, short=true)
					,z   = H * n/Slices
				)
				for (e=list) let( b = m_s * m_r * e ) [b.x,b.y, z]
			]
		,faces =
			[ for (n=[0:1:Slices-1])
				let(
				 n_a =  n   *len_base
				,n_b = (n+1)*len_base
				)
			  for (k=[0:1:len_base-1])
			  for (a=[0,1])
				Twist>=0 ?
					a==0 ?
					[ n_a +  k
					, n_b + (k+1)%len_base
					, n_a + (k+1)%len_base
					]
					:
					[ n_a +  k
					, n_b +  k
					, n_b + (k+1)%len_base
					]
				:
					a==0 ?
					[ n_b +  k
					, n_b + (k+1)%len_base
					, n_a + (k+1)%len_base
					]
					:
					[ n_b +  k
					, n_a + (k+1)%len_base
					, n_a +  k
					]
			]
		,faces_ends =
			[[ for (i=[0:1:len_base-1])  i]
			,[ for (i=[len_base-1:-1:0]) i + Slices*len_base]
			]
	)
	[points, concat(faces,faces_ends)]
;

function color (object, c, alpha) =
	[ for (i=[0:1:max(3,len(object)-1)])
		i!=2 ? object[i] :
		// write color as rgb or rgba list
		is_string(c) ?
			c[0]=="#" ?
				color_hex_to_list (c, alpha)
			:	color_name        (c, alpha)
		:is_num(c[2]) ?
			alpha==undef ? c : [c[0],c[1],c[2],alpha]
		:undef
	]
;

// - Hilfsfunktionen:

// Objekt in Liste in ein einheitliches Format ausgeben.
// [ points, [path, path2, ...] ]
function unify_object (object) =
	object==undef ? undef :
	is_num(object[0][0][0]) ?
		// standard format
		// [ points, ... ]
		!is_list(object[1]) ?
			// no path -> only an object with a point list
			// [ points, -empty- ]
			unify_object(object[0])
		:is_num(object[1][0][0]) ?
			// standard format
			// an object with a path list
			// [ points, [path, path2] ]
			 len(object[0])>0 && len(object[0][0])==2 ?
				// 2D
				object
			:len(object[0])>2 && len(object[0][0])==3 ?
				// 3D
				object
			:undef
		:is_num(object[1][0]) ?
			// path only as list
			// [ points, path ]
			 len(object[0])>0 && len(object[0][0])==2 ?
				// 2D
				[ for (k=[0:1:len(object)-1])
					k==1 ? [object[1]]
					:	object[k]
				]
			:len(object[0])>2 && len(object[0][0])==3 ?
				// 3D
				[ for (k=[0:1:len(object)-1])
					k==1 ? [object[1]]
					:	object[k]
				]
			:undef
		:undef
	:is_num(object[0][0]) ?
		// only a point list
		// points
		 len(object)>0 && len(object[0])==2 ?
			// 2D - count up all points
			[ object
			, [ [ for (i=[0:1:len(object)-1]) i ] ]
			]
		:len(object)>2 && len(object[0])==3 ?
			// 3D - create a path list with triangles on every next 3 point
			[ object
			, [ for (i=[2:3:len(object)-1]) [i-2,i-1,i] ]
			]
		:undef
	:is_num(object[0][0][0][0]) ?
		// [ [points,points2], [path, path2] ]
		//
		let(
			// make a [point, path] pair list and remove unusable pair
			len_pair = min( len(object[0]), len(object[1]) )
			,pair =
				len_pair==0 ? [] :
				concat_list (
				[ for (i=[0:1:len_pair-1])
					!is_num(object[0][i][0][0]) ? []
					:is_num(object[1][i][0][0][0]) ?
						// a path list
						[[object[0][i], object[1][i]]]
					:is_num(object[1][i][0][0]) ?
						// path only as list
						[[object[0][i], [object[1][i]]]]
					:[]
				] )
			// append and merge point lists, correct pair lists
			,merged_points = [ for (e=pair) for (p=e[0]) p ]
			,paths_offset = sum_each_next ([ for (e=pair) len(e[0]) ])
			,paths  =
				len(pair)==0 ? [] :
				[ for (i=[0:1:len(pair)-1])
					[ for (path=pair[i][1]) for (p=path)
						[ for (e=p) e+paths_offset[i] ]
					]
				]
		)
		merged_points==[] ? undef :
		paths==[]         ? undef :
		[ for (k=[0:1:len(object)-1])
			k==0 ? merged_points :
			k==1 ? paths :
			object[k]
		]
	:undef
;

function is_pointlist (list) =
	   list!=undef
	&& is_list(list)
	&& is_num(list[0][0])
;

function is_object (object) =
	object==undef || !is_list(object[1]) ?
		false :
	object[0][0][0]   !=undef && is_num(object[0][0][0])    && len(object[0][0])   >2 ?
		true :
	object[0][0]      !=undef && is_num(object[0][0])       && len(object[0])      >2 ?
		true :
	object[0][0][0][0]!=undef && is_num(object[0][0][0][0]) && len(object[0][0][0])>2 ?
		true :
	false
;

function is_object_2d (object) =
	object==undef ?
		false :
	object[0][0][0]   !=undef && is_num(object[0][0][0])    && len(object[0][0])   ==2 ?
		true :
	object[0][0]      !=undef && is_num(object[0][0])       && len(object[0])      ==2 ?
		true :
	object[0][0][0][0]!=undef && is_num(object[0][0][0][0]) && len(object[0][0][0])==2 ?
		true :
	false
;
function is_object_3d (object) =
	object==undef ?
		false :
	object[0][0][0]   !=undef && is_num(object[0][0][0])    && len(object[0][0])   ==3 ?
		true :
	object[0][0]      !=undef && is_num(object[0][0])       && len(object[0])      ==3 ?
		true :
	object[0][0][0][0]!=undef && is_num(object[0][0][0][0]) && len(object[0][0][0])==3 ?
		true :
	false
;


// Objekt in Liste direkt in ein Objekt umwandeln
module build_object (object)
{
	o = unify_object (object);
	
	color (o[2])
	if      (is_object_2d(o)) { polygon    (o[0], o[1]); }
	else if (is_object_3d(o)) { polyhedron (o[0], o[1]); }
}
