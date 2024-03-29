// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, für Objekte in Listen
//

use <banded/list_edit.scad>
use <banded/list_math.scad>

include <banded/helper_primitives_path.scad>
include <banded/helper_primitives_trace.scad>


// Schablone um Objekte zu transformieren,
// wenn nur die Punkte alleine bearbeitet werden
function transform_function (object, fn) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ? // simple point list
		let(list=object)
		fn (list)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ? // object with one point list
				let(list=object[0])
				fn (list)
			:is_num(object[0][0][0][0]) ? // object with multiple point lists
				[for (list=object[0])
				fn (list)
				]
			:undef // unknown object
		:
			object[k] // keep all other data
	]
;


// - Daten der Objekte:

// Objekt in Liste in ein einheitliches Format ausgeben.
// to_trace = false:
// - [ points, [path, path2, ...], (properties) ]
// to_trace = true:
// - [ [points, points2, ...], -empty- , (properties) ]
//
function unify_object (object, to_trace=false) =
	to_trace==false
	?	unify_object_path  (object)
	:	unify_object_trace (object)
;
function unify_object_path (object) =
	object==undef ? undef :
	is_num(object[0][0][0]) ?          // [ points, ... ]
		// standard format
		//
		!is_list(object[1]) ?          // [ points, -empty- ]
			// no path -> only an object with one point list
			//
			copy_object_properties (object,
				unify_object(object[0])
			)
		:is_num(object[1][0][0]) ?     // [ points, [path, path2] ]
			// standard format
			// an object with a path list
			//
			(len(object[0])>0 && len(object[0][0])==2) ||
			(len(object[0])>2 && len(object[0][0])==3) ?
				// 2D or 3D
				object
			:undef
		:is_num(object[1][0]) ?        // [ points, path ]
			// path only as list
			//
			(len(object[0])>0 && len(object[0][0])==2) ||
			(len(object[0])>2 && len(object[0][0])==3) ?
				// 2D or 3D
				[ for (k=[0:1:len(object)-1])
					k==1 ? [object[1]]
					:	object[k]
				]
			:undef
		:undef
	:is_num(object[0][0]) ?            // points
		// only a point list as trace
		//
		 len(object)>0 && len(object[0])==2 ?
			// 2D - count up all points
			index (object)
		:len(object)>2 && len(object[0])==3 ?
			// 3D - create a path list with triangles on every next 3 point
			[	object
			,	[ for (i=[2:3:len(object)-1]) [i-2,i-1,i] ]
			]
		:undef
	:is_num(object[0][0][0][0]) ?      // [ [points,points2], ... ]
		//
		is_list(object[1]) ?           // [ [points,points2], [path, path2] ]
			// each point list with his path list
			let(
				// make a [points, path] pair list and remove unusable pair
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
			copy_object_properties (object,
				[	merged_points
				,	paths
				] )
		:                              // - [ [points,points2] ]
			// a list with traces
			//
			(len(object[0][0][0])==2) ||
			(len(object[0][0][0])==3) ?
				// 2D or 3D
				// put points together and make path lists
				copy_object_properties (object,
					index_all (object[0])
				)
			:undef
	:undef
;
function unify_object_trace (object) =
	object==undef ? undef :
	is_num(object[0][0][0]) ?          // [ points, ... ]
		// standard format
		//
		!is_list(object[1]) ?          // [ points, -empty- ]
			// no path -> only an object with one point list
			//
			copy_object_properties (object, [ [object[0]] ] )
		:is_num(object[1][0][0]) ?     // [ points, [path, path2] ]
			// standard format
			// an object with a path list
			//
			(len(object[0])>0 && len(object[0][0])==2) ||
			(len(object[0])>2 && len(object[0][0])==3) ?
				// 2D or 3D
				copy_object_properties (object,
					 [ select_all (object[0], object[1]) ]
				)
			:undef
		:is_num(object[1][0]) ?        // [ points, path ]
			// path only as list
			//
			(len(object[0])>0 && len(object[0][0])==2) ?
				// 2D only
				copy_object_properties (object,
					[ [ select (object[0], object[1]) ] ]
				)
			:undef
		:undef
	:is_num(object[0][0]) ?            // points
		// only a point list as trace
		//
		(len(object)>0 && len(object[0])==2) ||
		(len(object)>2 && len(object[0])==3) ?
			// 2D and 3D
			[ [object] ]
		:undef
	:is_num(object[0][0][0][0]) ?      // [ [points,points2], ... ]
		//
		is_list(object[1]) ?           // [ [points,points2], [path, path2] ]
			// each point list with his path list
			let(
				// make a [points, path] pair list and remove unusable pair
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
				// append point lists
				,traces = [ for (e=pair) select (e[0],e[1]) ]
			)
			traces==[] ? undef :
			copy_object_properties (object,
				[ traces ] )
		:                              // - [ [points,points2] ]
			// a list with traces
			//
			(len(object[0][0][0])==2) ||
			(len(object[0][0][0])==3) ?
				// 2D or 3D
				object
			:undef
	:undef
;

function copy_object_properties (source, target) =
	len(source)<3 ?
		target[1]==undef
		? [ target[0] ]
		: [ target[0], target[1] ]
	:
		[	target[0]
		,	target[1]
		,	each [ for (i=[2:1:len(source)-1]) source[i] ]
		]
;

// prepare 2D objects, so they don't intersect himself and
// holes have the counter direction,
// remove unused points
// returns 'false' if it fails
function prepare_object_2d (object, to_trace=false) =
	to_trace==false
	?	prepare_object_2d_path  (object)
	:	prepare_object_2d_trace (object)
;
function prepare_object_2d_path (object) =
	let(
		 unified    = unify_object_trace (object)
	)
	!is_object_2d (unified) ? undef :
	let(
		 traces     = unified[0]
		,separate   = split_intersection_traces (traces)
		,orientated = orientate_nested_traces (separate)
		,indexed    = index_all (orientated)
		,Object     = compress_selected (indexed[0], indexed[1])
	)
	copy_object_properties (object, Object)
;
function prepare_object_2d_trace (object) =
	let(
		 unified    = unify_object_trace (object)
	)
	!is_object_2d (unified) ? undef :
	let(
		 traces     = unified[0]
		,separate   = split_intersection_traces (traces)
		,orientated = orientate_nested_traces (separate)
	)
	copy_object_properties (object, [orientated])
;


// - Test der Objekt-Daten:

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


// - Objekte bearbeiten:

// append 2 objects without any data transformation
function append_object (object, object2, to_trace=false) =
	let(
		 o1 = unify_object (object,  to_trace)
		,o2 = unify_object (object2, to_trace)
	)
	o2==undef ? o1 :
	o1==undef ? o2 :
	to_trace!=true ?
		let(
			 p1_size = len(o1[0])
			,oa = [
				[ each o1[0], each o2[0] ],
				[ each o1[1], each add_all_each_with (o2[1], p1_size) ]
			]
		)
		copy_object_properties (o1, oa)
	:
		let(
			oa = [ [ each o1[0], each o2[0] ] ]
		)
		copy_object_properties (o1, oa)
;

// append a list with objects without any data transformation
function append_object_list (objects, to_trace=false) =
	let ( size=len(objects) )
	 size==0 ? []
	:size==1 ? objects[0]
	:size==2 ?
		append_object (objects[0], objects[1], to_trace)
	:size==3 ?
		append_object (
			  objects[0]
			, append_object (objects[1], objects[2], to_trace)
			, to_trace )
	:size==4 ?
		append_object (
			  append_object (objects[0], objects[1], to_trace)
			, append_object (objects[2], objects[3], to_trace)
			, to_trace )
	:
		let ( mid=floor(size/2) )
		append_object_list (
			[ append_object_list ([for (i=[0  :1:mid -1]) objects[i]], to_trace)
			, append_object_list ([for (i=[mid:1:size-1]) objects[i]], to_trace)
			]
			, to_trace )
;

