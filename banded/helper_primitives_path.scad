// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Hilfsfunktionen, die Objekte in Listen bearbeiten
//
// Version mit Listen vom Typ '[points, path]',
// 'path' definiert ein geschlossenes Polygon
// mit Index auf Punkteliste 'points'.
//

use <banded/list_edit.scad>


// TODO - function split_intersection_paths (points, paths)

// TODO - function split_intersection_path (points, path)

// gibt [points, faces] zurück
// teilt sich selbst überkreuzende Umrandungen auf in einzelne Umrandungen
// TODO: Linien die sich überlappen behandeln
function split_self_intersection_path (points, face) =
	let (
		f = remove_expendable_points_path (points, face),
		//
		result = split_self_intersection_path_intern (points, f)
	)
	result[2]==false ?
		[points, [face]]
	:
		split_self_intersection_path_two (result[0], result[1][0], result[1][1])
;
function split_self_intersection_path_two (points, face1, face2) =
	let (
		res_l = split_self_intersection_path_intern (points,   face1),
		res_r = split_self_intersection_path_intern (res_l[0], face2),
		p     = res_r[0]
	)
	res_r[2]==false ?
		res_l[2]==false ?
			[points, [face1, face2]]
		: // res_l[2]==true ?
			let (
				l = split_self_intersection_path_two (p, res_l[1][0], res_l[1][1])
			)
			[l[0], concat(l[1], [face2])]
	: // res_r[2]==true ?
		res_l[2]==false ?
			let (
				r = split_self_intersection_path_two (p, res_r[1][0], res_r[1][1])
			)
			[r[0], concat([face1], r[1])]
		: // res_l[2]==true ?
			let (
				r_ = split_self_intersection_path_two (p,     res_r[1][0], res_r[1][1]),
				l_ = split_self_intersection_path_two (r_[0], res_l[1][0], res_l[1][1])
			)
			[l_[0], concat(l_[1], r_[1])]
;
function split_self_intersection_path_intern (points, face) =
	let(
		n = get_self_intersection_point_path (points, face)
	)
	n==undef ? [points, [face], false] :
	let(
		size = len(face),
		p = get_intersection_lines (
			 [ select_link (points, face, n[0])[0], select_link (points, face, (n[0]+1)%size)[0] ]
			,[ select_link (points, face, n[1])[0], select_link (points, face, (n[1]+1)%size)[0] ]
			),
		new_points = concat(points, [p]),
		f1 = concat( [ for (i=[n[0]+1:1:n[1]]) face[i] ], len(points) ),
		f2 = concat( [ for (i=[0     :1:n[0]]) face[i] ], len(points), [ for (i=[n[1]+1:1:size-1]) face[i] ] )
	)
	[new_points, [f1,f2], true]
;

// gibt die Position in 'face' der Überkreuzung zurück, sonst eine leere Liste
function get_self_intersection_point_path (points, face) =
	get_self_intersection_point_path_intern (points, face, len(face))
;
function get_self_intersection_point_path_intern (points, face, size, n=0, k=0) =
	size<=3   ? undef:
	n>=size/2 ? undef :
	k>=size/2-1 ?
		get_self_intersection_point_path_intern (points, face, size, n+1, 0) :
	(! is_intersection_segments (
		[ points[face[ n          ]], points[face[(n  +1)%size]] ],
		[ points[face[(n+k+2)%size]], points[face[(n+k+3)%size]] ]
	))
	?	get_self_intersection_point_path_intern (points, face, size, n, k+1)
	:	[n, n+k+2]
;

// TODO - function orientate_nested_traces (traces, backwards=false)

function remove_expendable_points_path (points, face) =
	let (
		size = len(face),
		f_p  = // mehrfach überlagerte Punkte raus
			[ for (i=[0:1:size-1])
				let(
					point1 = points[face[(i  )%size]],
					point2 = points[face[(i+1)%size]]
				)
				if ( point1!=point2 ) face[i]
			],
		size2 = len(f_p),
		new_face = // überflüssige Linien raus
			[ for (i=[size2:1:2*size2-1])
				let(
					line1 = [ points[f_p[(i-1)%size2]], points[f_p[(i  )%size2]] ],
					line2 = [ points[f_p[(i  )%size2]], points[f_p[(i+1)%size2]] ]
				)
				if ( !is_collinear( line1[1]-line1[0], line2[1]-line2[0] ) ) f_p[i%size2]
			]
	)
	len(new_face)==size ?
		new_face
	:	remove_expendable_points_path (points, new_face)
;

// TODO - function xor_all_paths (points, paths)

//------------------------------------------------------------------------

// TODO - function connect_polygon_holes_paths (points, paths)

// TODO - function connect_polygon_holes_path (points, path)

// TODO - function list_polygon_holes_next_paths (points, paths)

// TODO - function list_polygon_holes_parent_paths (points, paths)

// TODO - function list_polygon_holes_children_paths (points, paths)

// TODO - function unify_polygon_rotation_paths (points, paths, orientation)

//------------------------------------------------------------------------

// TODO - function tesselate_all_paths (points, paths)

// TODO - function tesselate_path (points, path)

