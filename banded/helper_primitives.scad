// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// enthält Hilfsfunktionen, für Objekte in Listen
//


// - Daten der Objekte:

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

function remove_unselected_points (points, faces) =
	let (
		pos = remove_duplicate( sort( concat_list (faces) ) ),
		pos_table = [
			for (i=[-1:len(pos)-2])
			for (e=(
				(i==-1) ?
					[ for (j=[0     :1:pos[0]    ]) 0   ]
				:	[ for (j=[pos[i]:1:pos[i+1]-1]) i+1 ]
			) ) e
			],
		new_faces  = [ for (f=faces) [ for (e=f) pos_table[e] ] ],
		new_points = [ for (i=pos) points[i] ]
	)
	[new_points, new_faces]
;

