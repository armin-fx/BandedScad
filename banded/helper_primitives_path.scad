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

// Verbindet ineinander verschachtelte Polygone miteinander.
// Löcher werden mit der Außenwand verbunden.
// Vorbereitung zum Aufteilen in Dreiecke
// returns only all path in a list
function connect_polygon_holes_paths (points, paths) =
	let (
		,children  =         list_polygon_holes_next_paths (points, paths)
		,orient    = [for (e=list_polygon_holes_parent_paths(points, paths)) len(e)]
		,t_rotated = unify_polygon_rotation_paths (points, paths, orient)
		,linked    =
			[for (i=[0:1:len(paths)-1])
				// only paths with math rotation has children holes
				if (is_even (orient[i]))
					connect_polygon_holes_path (points, t_rotated[i], select(t_rotated,children[i]) )
			]
	)
	// echo("connect_polygon_holes_paths", echo_list(linked, "linked"))
	value_list (linked, [0])
;
function connect_polygon_holes_path (points, path, holes=[],  i=0) =
	holes==undef || holes==[] ? [path] :
	i>=len(holes) ? [path, holes] :
	let (
		pos = find_polygon_connect_path (points, path, holes, i)
	)
	// echo("connect_polygon_holes_path",i, len(holes), pos,"\n",holes[i], echo_list(holes))
	pos==undef ?
		connect_polygon_holes_path (points, path, holes, i+1)
	:
	let (
		 path_n =
			[	each rotate_list (path,     pos[0])
			,	path    [ pos[0] ]
			,	each rotate_list (holes[i], pos[1])
			,	holes[i][ pos[1] ]
			]
		,holes_n = remove (holes, i)
	)
	connect_polygon_holes_path (points, path_n, holes_n, 0)
;
// return = [pos_path, pos_hole]
// return = undef in nothing found
function find_polygon_connect_path (points, path, holes, hole_number,  pos_path=0, pos_hole=0) =
	pos_path>=len(path) ? undef :
	pos_hole>=len(holes[hole_number])
	?	find_polygon_connect_path (points, path, holes, hole_number, pos_path+1, 0)
	:
	let (
		 hole = holes[hole_number]
		,line = [ points[path[pos_path]], points[hole[pos_hole]] ]
	)
	is_intersection_polygon_segment (points, line, path=path, without=pos_path) ||
	is_intersection_polygon_segment (points, line, path=hole, without=pos_hole) ||
	[for (i=[0:1:len(holes)-1])
		if (i!=hole_number)
		if (is_intersection_polygon_segment (points, line, path=holes[i]) )
		i ] != []
	?	find_polygon_connect_path (points, path, holes, hole_number, pos_path, pos_hole+1)
	:
	[pos_path, pos_hole]
;


function list_polygon_holes_next_paths (points, paths) =
	let (
		ch_ldren = list_polygon_holes_children_paths (points, paths),
		next =
			[for (e=ch_ldren)
				let(
					not = [for (i=e) each ch_ldren[i] ],
					yes = remove_all_values (e, not)
				)
				yes
			]
	)
	next
;

function list_polygon_holes_parent_paths (points, paths) =
	paths==undef ? [] :
	[for (i=[0:1:len(paths)-1])
		[ for (j=[0:1:len(paths)-1])
			if (i!=j && is_point_inside_polygon (points, points[paths[i][0]], path=paths[j])) j ]
	]
;

function list_polygon_holes_children_paths (points, paths) =
	paths==undef ? [] :
	[for (i=[0:1:len(paths)-1])
		[ for (j=[0:1:len(paths)-1])
			if (i!=j && is_point_inside_polygon (points, points[paths[j][0]], path=paths[i])) j ]
	]
;

// 'orientation' - Liste mit Zahlen
// - ohne Angabe = mathematischer Drehsinn
// - gerade      = mathematischer Drehsinn
// - ungerade    = Uhrzeigersinn
function unify_polygon_rotation_paths (points, paths, orientation) =
	[for (i=[0:1:len(paths)-1])
		let (
			keep =
				!(orientation!=undef && is_odd(orientation[i]))
				&& is_math_rotation_polygon (select (points, paths[i]))
		)
		keep ? paths[i] : reverse(paths[i])
	]
;

//------------------------------------------------------------------------

// creates no new points
function tesselate_all_paths (points, paths) =
	let (
		 linked = connect_polygon_holes_paths (points, paths)
		,tessel = concat_list( [for (path=linked) tesselate_path (points, path) ] )
	) tessel
;

// returns only all path in a list
function tesselate_path (points, path) =
//	tesselate_path_next (points, path)
	tesselate_path_split (points, path)
;

//----------------------------------------------------
function tesselate_path_split (points, path, triangles=[]) =
	let ( size = len(path) )
	size<=2 ? triangles :
	size==3 ? [ each triangles, path ] :
	let (
		// returns [pos1, pos2]
		pos = tesselate_path_split_position (points, path, size)
	)
	//	echo("tesselate_path_split", size, pos)
	pos==[]
	?	 // TODO stupid tesselate at here possible
	//	[ each triangles, each tesselate_path_next (points, path) ]
		[ each triangles, each tesselate_trace_stupid (path) ]
	//	[ each triangles, (path) ]
	:
	let (
		 pos_s  = pos[0]<pos[1] ? pos : [pos[1],pos[0]]
		,path_1 = extract (path, begin=pos_s[0], last=pos_s[1])
		,path_2 = [ each extract (path, begin=pos_s[1])
		          , each extract (path, last =pos_s[0]) ]
	)
	[ each tesselate_path_split (points, path_1, triangles)
	, each tesselate_path_split (points, path_2, triangles)
	]
;
function tesselate_path_split_position (points, path, size=0, i=0) =
	i>=size ? [] :
	let (
		r = points[ path[(i-1+size)%size] ],
		o = points[ path[  i  ] ],
		l = points[ path[(i+1)%size] ],
		angle = rotation_vector (l-o, r-o)
	)
	//	echo("tesselate_path_split_position", i, angle)
	angle<180 || is_nan(angle)
	?	tesselate_path_split_position (points, path, size, i+1)
	:
	// Einbuchtung gefunden, gegenüberliegenden Punkt finden
	let (
		pos = find_connect_path (points, path, i)
	)
	pos==i || o==points[ path[pos] ]
	?	tesselate_path_split_position (points, path, size, i+1)
	:	[i, pos]
;

// gibt '[position] zurück im Fehlerfall
function find_connect_path (points, path, position, fast=true) =
	find_connect_path_intern (points, path, position, fast, len(path)) [0]
;
function find_connect_path_intern (points, path, position, fast, size, i=0) =
	i>=size     ? [position] :
	i==(position-1+size)%size ? find_connect_path_intern (points, path, position, fast, size, i+1) :
	i== position              ? find_connect_path_intern (points, path, position, fast, size, i+1) :
	i==(position+1)%size      ? find_connect_path_intern (points, path, position, fast, size, i+1) :
	let(
		 without = [i, position]
		,line    = select_link (points, path, without)
	)
	//	echo("find_connect_path", size, position, i)
	    is_intersection_polygon_segment (points, line, path=path, without=without)
	|| !is_point_inside_polygon_2d  (points, midpoint_line(line), path=path)
	?	find_connect_path_intern (points, path, position, fast, size, i+1)
	:	
	//	echo("find_connect_path - found", size, position, i)
	fast==true ? [i] :
	// try a better position
	let(
		 d    = length_line (line)
		,next = find_connect_path_intern (points, path, position, fast, size, i+1)
	)
	next[0]==position || d<next[1]
	?	[i, d]
	:	next
;

//-----------------------------------------------------
// Entfernt nacheinander jedes Dreieck aus dem Polygon,
// das keine Überschneidungen mit der Außenlinie hat.
// TODO Hat Probleme mit Segmenten in einer Geraden verbunden.

// TODO - function tesselate_path_next (points, path, triangles=[]) =

