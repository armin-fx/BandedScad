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
use <banded/list_edit.scad>
use <banded/math.scad>


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


// - Objekte bearbeiten:

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
	angle==undef || (is_num(angle) && abs(angle)>=360) ?
		rotate_extrude_extend_points (list, [360,180], slices)
	:	rotate_extrude_extend_points (list, angle    , slices)
;
function rotate_extrude_extend_points (list, angle=360, slices="x") =
	let (
		 r_max       = max_list (list, type=[0])
		,angles      = parameter_angle (angle, [360,0])
		,Angle_begin = angles[1]
		,Angle       = constrain (angles[0], -360, 360)
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
		get_color (c, alpha)
	]
;

function hull (object) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ? // simple point list
		let(list=object)
		hull_points (list)
	:
	let (
		h = 
			 is_num(object[0][0][0]) ? // object with one point list
				let(list=object[0])
				hull_points (list)
			:is_num(object[0][0][0][0]) ? // object with multiple point lists
				let(list=object[0])
				hull_points (concat_list(list))
			:undef // unknown object
	)
	h==undef ? undef
	:is_num(h[0][0]) ? // 2D trace
		[
			 h                        // all points as trace
			,range (i=[0:1:len(h)-1]) // count up all points
			,each [ for (k=[2:1:len(object)-1]) object[k] ] // keep all other data
		]

	:is_num(h[0][0][0]) ? // 3D object
		[
			 h[0]
			,h[1]
			,each [ for (k=[2:1:len(object)-1]) object[k] ] // keep all other data
		]
	:undef // unknown
;
// get a point list and returns an objekt as list
// - 2D: 'trace'
// - 3D: '[ points, path ]'
function hull_points (points) =
	points==undef ? points :
	len(points[0])==2 ? hull_2d_points (points) :
	len(points[0])==3 ? hull_3d_points (points) :
	undef
;

function hull_2d_points (points) = hull_2d_quickhull_points (points);
//
function hull_2d_quickhull_points (points) =
	!(len(points)>2) ? points :
	let(
		left_pos  = min_position (points, [0]),
		right_pos = max_position (points, [0]),
		left  = points[left_pos],
		right = points[right_pos],
		remainder = [ for (i=[0:len(points)-1]) if (i!=left_pos && i!=right_pos) points[i] ],
		g = get_gradient_2d ([ left,right ]),
		m = g[1], y0 = g[0],
		points_up   = [ for (e=remainder) if (y0+m*e.x < e.y) e ],
		points_down = [ for (e=remainder) if (y0+m*e.x > e.y) e ]
		
	)
	concat(
		[left],  hull_2d_quickhull_points_next (points_up,   left, right),
		[right], hull_2d_quickhull_points_next (points_down, right, left)
	)
;
function hull_2d_quickhull_points_next (points, left, right) =
	!(len(points)>1) ? points :
	let(
		do_flat = matrix_rotate_backwards( rotation_vector([1,0],right-left), d=2, short=true),
		flat_points= multmatrix_2d_points( points, do_flat ),
		flat_left  = multmatrix_2d_point ( left,   do_flat ),
		flat_right = multmatrix_2d_point ( right,  do_flat ),
		next_pos   = max_position(flat_points, [1]),
		next       = points     [next_pos],
		flat_next  = flat_points[next_pos],
		gl = get_gradient_2d ([ flat_left ,flat_next ]),
		gr = get_gradient_2d ([ flat_right,flat_next ]),
		points_left  = [ for (i=[0:len(points)-1])
			if (i!=next_pos) if (gl[0]+gl[1]*flat_points[i].x < flat_points[i].y) points[i] ],
		points_right = [ for (i=[0:len(points)-1])
			if (i!=next_pos) if (gr[0]+gr[1]*flat_points[i].x < flat_points[i].y) points[i] ]
	)
	concat(
		hull_2d_quickhull_points_next (points_left , left, next),
		[next],
		hull_2d_quickhull_points_next (points_right, next, right)
	)
;

function hull_3d_points (points) = hull_3d_grub_out_points (points);
//
function hull_3d_grub_out_points (points) =
	!(len(points)>3) ? undef :
	let( // get any first 3 points and generate a full object with these
		up_pos   = max_position (points, [2]),
		down_pos = min_position (points, [2])
	)
	up_pos==down_pos ? undef : // Flat object
	let(
		other_pos = find_first_if ( range([0:len(points)-1]), f=function(i)
				(i!=up_pos && i!=down_pos) &&
				(! is_nearly_collinear (points[up_pos]-points[down_pos], points[up_pos]-points[i]) )
			)
	)
	other_pos>=len(points) ? undef : // One line object
	let(
		remainder = [ for (i=[0:len(points)-1]) if (i!=up_pos && i!=down_pos && i!=other_pos) i ],
		triangles = [
			[up_pos,down_pos,other_pos],
			[down_pos,up_pos,other_pos]
			],
		result = hull_3d_grub_out_points_next (points, triangles, remainder, len(remainder)-1)
	)
	remove_unselected_points (result[0], result[1])
;
function hull_3d_grub_out_points_next (points, triangles, remainder, last=0) =
	last<0 ? [points, triangles] :
	let (
		next_pos    = remainder[last],
		next_point  = points[next_pos]
	)
	is_point_inside_polyhedron_hulled (points, triangles, next_point) ?
		hull_3d_grub_out_points_next (points, triangles, remainder, last-1)
	:
	let (
		keep_triangles =
			[ for (triangle=triangles)
			let (
			//	normal    = get_normal_face (points_3=select (points,triangle) ),
				normal    = cross (points[triangle[1]]-points[triangle[0]], points[triangle[2]]-points[triangle[0]]),
				direction = next_point - points[triangle[0]],
				angle     = angle_vector (normal, direction)
			)
			if (angle<90) triangle
			],
		edge_list = // list and sort all edges from the keeped triangles
			sort (type=[0] ,list=
			sort (type=[1] ,list=
			[for (triangle=keep_triangles)
			for  (i=[0:1:2])
				let (
					a=triangle[i],
					b=triangle[(i+1)%3]
				)
				a<b ? [a, b, false]
				:     [b, a, true ]
			] ) ),
		new_triangles = // remove double entries from edge_list and build new triangles
			[for
				(i=0           ,keep=([edge_list[i][0],edge_list[i][1]] != [edge_list[i+1][0],edge_list[i+1][1]]);
				i<len(edge_list);
				i=i+(keep?1:2) ,keep=([edge_list[i][0],edge_list[i][1]] != [edge_list[i+1][0],edge_list[i+1][1]]))
					if (keep)
						let (
							edge=edge_list[i]
						)
						edge[2] ? [edge[0],edge[1], next_pos]
						:         [edge[1],edge[0], next_pos]
			]
	)
	hull_3d_grub_out_points_next (points, [each keep_triangles, each new_triangles], remainder, last-1)
;


// - Objekt erzeugen:

// Objekt in Liste direkt in ein Objekt umwandeln
module build_object (object, convexity)
{
	o = unify_object (object);
	
	color (o[2])
	if      (is_object_2d(o)) { polygon    (o[0], o[1], convexity=convexity); }
	else if (is_object_3d(o)) { polyhedron (o[0], o[1], convexity=convexity); }
}

