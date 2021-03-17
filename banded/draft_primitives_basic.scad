// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen erzeugen Objekte in Listen,
// die an polygon() oder polyhedron() übergeben werden können.
//
// Listenkonvention:
// [ points ]
// [ points, path ]
// [ points, [path, path2, ...] ]    -> Standard
// [ [points, points2, ...], [path, path2, ...] ]
//


// - 2D:

function square (size, center=false) =
	let(
		points = square_curve(size,center),
		path   = [[for (i=[0:1:len(points)-1]) i ]]
	)
	[points, path]
;

function circle (r, angle=360, slices, piece=0, outer=0, d) =
	let(
		points = circle_curve (r, angle, slices, piece, outer, d),
		path   = [[for (i=[0:1:len(points)-1]) i ]]
	)
	[points, path]
;


// - 3D:

function cube (size, center) =
	let(
		 Size = parameter_size_3d (size)
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
		(center!=true) ? points : translate_points( points, -Size/2 )
	    , path
	]
;

function cylinder (h, r1, r2, center=false, r, d, d1, d2, angle, slices="x", piece=true) =
	let(
		 R      = parameter_cylinder_r (r, r1, r2, d, d1, d2)
		,R_max  = R[0]>R[1] ? R[0] : R[1]
		,H      = get_first_num (h, 1)
		,H_both = center==true ? [-H,H]/2 : [0,H]
		,angles = parameter_angle (angle, [360,0])
		,Angle  = angles[0]
		,Slices = // copy and paste from circle_curve():
			slices==undef ? get_fn_circle_current  (R_max,Angle,piece) :
			slices=="x"   ? get_fn_circle_current_x(R_max,Angle,piece) :
			slices<2 ?
				(piece==true || piece==0) ? 1 : 2
			:slices
		,c1 = circle_curve (r=R[0], angle=angles, slices=Slices, piece=piece)
		,c2 = circle_curve (r=R[1], angle=angles, slices=Slices, piece=piece)
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

function sphere (r, d) =
	let(
		 R        = parameter_circle_r (r, d)
		,fn       = get_fn_circle_current_x (R)
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
/*
// since OpenSCAD version 2021.01
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
*/

function translate (object, v) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		translate_points (list, v)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				translate_points (list, v)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				translate_points (list, v)
				]
			:undef
		:
			object[k]
	]
;

function rotate (object, a, v, backwards=false) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_points (list, a, v, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_points (list, a, v, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_points (list, a, v, backwards)
				]
			:undef
		:
			object[k]
	]
;

function mirror (object, v) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_points (list, v)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_points (list, v)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_points (list, v)
				]
			:undef
		:
			object[k]
	]
;

function scale (object, v) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		scale_points (list, v)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				scale_points (list, v)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				scale_points (list, v)
				]
			:undef
		:
			object[k]
	]
;

function resize (object, newsize) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		resize_points (list, newsize)
	:
	let( Object = unify_object(object) )
	[ for (k=[0:1:len(Object)-1])
		k==0 ?
			 is_num(Object[0][0][0]) ?
				let(list=Object[0])
				resize_points (list, newsize)
			:undef
		:
			Object[k]
	]
;

function multmatrix (object, m) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		multmatrix_points (list, m)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				multmatrix_points (list, m)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				multmatrix_points (list, m)
				]
			:undef
		:
			object[k]
	]
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
	
	if      (is_object_2d(o)) { polygon    (o[0], o[1]); }
	else if (is_object_3d(o)) { polyhedron (o[0], o[1]); }
}
