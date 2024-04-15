// Copyright (c) 2022 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Enthält Hilfsfunktionen, die Objekte in Listen bearbeiten
//
// Version mit Listen vom Typ 'trace'.
// 'trace' ist eine Punkteliste,
// deren Reihenfolge ein geschlossenes Polygon definiert.
//

use <banded/list_edit.scad>


// teilt eine sich selbst kreuzende Umrandungen auf in einzelne Umrandungen
//
// erwartet eine Liste mit 2D Spuren
// gibt alle getrennten Umrandungen als Liste 'traces' zurück
function split_intersection_traces (traces) =
	let (
		uncrossed =
			[ for (trace=traces)
				each
					let(
						cutted     = split_intersection_trace (trace),
						is_good    = cutted==[] || is_math_rotation_polygon (cutted[0]),
						orientated = is_good ? cutted : [for (e=cutted) reverse(e)]
					) orientated
			]
		,xored = xor_all_traces (uncrossed)
	)
	//	echo("split_intersection_traces", xored)
	xored
;
// teilt eine sich selbst kreuzende Umrandung auf in einzelne Umrandungen
//
// erwartet 2D Spur
// gibt alle getrennten Umrandungen als Liste 'traces' zurück
function split_intersection_trace (trace) =
	let (
		ts1 = split_self_intersection_trace (trace),
		ts2 = [for (t=ts1) is_math_rotation_polygon(t) ? t : reverse(t) ],
		ts3 = xor_all_traces (ts2)
	)
	ts3
;

// gibt 'traces' zurück
// teilt sich selbst überkreuzende Umrandungen auf in einzelne Umrandungen
// TODO: Linien die sich überlappen behandeln
function split_self_intersection_trace (trace) =
	let (
		t = remove_expendable_points_trace (trace),
		//
		result = split_self_intersection_trace_intern (t)
	)
	result[1]==false ?
		[trace]
	:
		split_self_intersection_trace_two (result[0][0], result[0][1])
;
function split_self_intersection_trace_two (trace1, trace2) =
	let (
		res_l = split_self_intersection_trace_intern (trace1),
		res_r = split_self_intersection_trace_intern (trace2)
	)
	res_r[1]==false ?
		res_l[1]==false ?
			[trace1, trace2]
		: // res_l[1]==true ?
			let (
				l = split_self_intersection_trace_two (res_l[0][0], res_l[0][1])
			)
			[ each l, trace2 ]
	: // res_r[1]==true ?
		res_l[1]==false ?
			let (
				r = split_self_intersection_trace_two (res_r[0][0], res_r[0][1])
			)
			[ trace1, each r ]
		: // res_l[1]==true ?
			let (
				r_ = split_self_intersection_trace_two (res_r[0][0], res_r[0][1]),
				l_ = split_self_intersection_trace_two (res_l[0][0], res_l[0][1])
			)
			[ each l_, each r_ ]
;
function split_self_intersection_trace_intern (trace) =
	let(
		n = get_self_intersection_point_trace (trace)
	)
	n==undef ? [[trace], false] :
	let(
		size = len(trace),
		p = get_intersection_lines (
			 [ select (trace, n[0])[0], select (trace, (n[0]+1)%size)[0] ]
			,[ select (trace, n[1])[0], select (trace, (n[1]+1)%size)[0] ]
			),
		f1 = [ each [ for (i=[n[0]+1:1:n[1]]) trace[i] ], p ],
		f2 = [ each [ for (i=[0     :1:n[0]]) trace[i] ], p, each [ for (i=[n[1]+1:1:size-1]) trace[i] ] ]
	)
	[ [f1,f2], true]
//	[ [f1,reverse(f2)], true]
;

// gibt die Position in 'trace' der Überkreuzung zurück, sonst eine leere Liste
function get_self_intersection_point_trace (trace) =
	get_self_intersection_point_trace_intern (trace, len(trace))
;
function get_self_intersection_point_trace_intern (trace, size, n=0, k=0) =
	size<=3   ? undef:
	n>=size/2 ? undef :
	k>=size/2-1 ?
		get_self_intersection_point_trace_intern (trace, size, n+1, 0) :
	(! is_intersection_segments (
		[ trace[ n          ], trace[(n  +1)%size] ],
		[ trace[(n+k+2)%size], trace[(n+k+3)%size] ]
	))
	?	get_self_intersection_point_trace_intern (trace, size, n, k+1)
	:	[n, n+k+2]
;

// müssen einzelne Spuren sein, die sich nicht überkreuzen
function orientate_nested_traces (traces, backwards=false) =
	let (
		orientations = [for (e=list_polygon_holes_parent_traces(traces)) len(e) + (backwards ? 1:0) ],
		orientated   = unify_polygon_rotation_traces (traces, orientations)
	)
	orientated
;

function remove_expendable_points_trace (trace) =
	let (
		size = len(trace),
		t_p  = // mehrfach überlagerte Punkte raus
			[ for (i=[0:1:size-1])
				let(
					point1 = trace[(i  )%size],
					point2 = trace[(i+1)%size]
				)
				if ( !is_nearly(point1,point2) ) trace[i]
			],
		size2 = len(t_p),
		new_trace = // überflüssige Linien raus
			[ for (i=[size2:1:2*size2-1])
				let(
					line1 = [ t_p[(i-1)%size2], t_p[(i  )%size2] ],
					line2 = [ t_p[(i  )%size2], t_p[(i+1)%size2] ]
				)
				if ( !is_nearly_collinear( line1[1]-line1[0], line2[1]-line2[0] ) ) t_p[i%size2]
			]
	)
	len(new_trace)==size ?
		new_trace
	:	remove_expendable_points_trace (new_trace)
;

//--------------------------------------------------------------------------------

// dürfen sich nicht selbst überschneiden
function xor_all_traces (traces) =
	let (
		size = len(traces)
	)
	//	echo("xor_all_traces", size, traces)
	size<=1 ? traces :
	size==2 ? xor_2_traces (traces[0], traces[1]) :
	xor_all_traces_intern (traces)
;
function xor_all_traces_intern (traces, i=0, j=1) =
	let (
		size = len(traces)
	)
	i>=size-1 ? traces :
	let (
		res = xor_2_traces (traces[i], traces[j])
	)
	res==[traces[i], traces[j]] ?
		j>=size-1 ?
			xor_all_traces_intern (traces, i+1, i+2)
		:	xor_all_traces_intern (traces, i  , j+1)
	:
		let(
			res1 = remove (traces, begin=j, count=1),
			res2 = remove (res1  , begin=i, count=1),
			res3 = [ each res2, each res ]
		)
		xor_all_traces (res3)
;

function xor_2_traces_intersect (trace1, trace2) =
	let (
		size1=len(trace1),
		size2=len(trace2),
		// get intersecting points
		isp_l =
			[for (i=[0:1:size1-1])
				let (
					line1 = [trace1[i],trace1[(i+1)%size1]]
				)
				for (j=[0:1:size2-1])
					let (
						line2 = [trace2[j],trace2[(j+1)%size2]],
						point = get_intersection_lines (line1,line2)
					)
					if (line1[0]!=point && line1[1]!=point)
					if (is_intersection_segments (line1, line2, point, true))
						[point, i, j]
			],
		isp = isp_l[0]
	)
	//	echo("x2t", isp_l)
	isp==undef ? [trace1,trace2] :
	let (
		t1 = rotate_list (trace1, isp[1]+1),
		t2 = rotate_list (trace2, isp[2]+1),
		tx = [ isp[0], each t1, isp[0], each t2 ],
		res = split_self_intersection_trace(tx)
	)
	res
;

function xor_2_traces (trace1, trace2) =
	let (
		 size1=len(trace1)
		,size2=len(trace2)
		// get intersecting points
		,isp =
			[for (i=[0:1:size1-1])
				let (
					line1 = [trace1[i],trace1[(i+1)%size1]]
				)
				for (j=[0:1:size2-1])
					let (
						line2 = [trace2[j],trace2[(j+1)%size2]],
						point = get_intersection_lines (line1,line2)
					)
					each
				//	if (line1[0]!=point && line1[1]!=point)
					if (is_intersection_segments (line1, line2, point, ends=-1))
						point!=true
						?	//            |<-- debug part -->|
							[[point, i, j, undef, line1, line2]]
						:	// list all jointly points on the same segment line
						[for (e= //                                                     |<-- debug part ->|
						[	is_constrain(line1[0], line2[0],line2[1]) ? [line1[0], i, j, true, line1, line2] : []
						,	is_constrain(line1[1], line2[0],line2[1]) ? [line1[1], i, j, true, line1, line2] : []
						,	is_constrain(line2[0], line1[0],line1[1]) ? [line2[0], i, j, true, line1, line2] : []
						,	is_constrain(line2[1], line1[0],line1[1]) ? [line2[1], i, j, true, line1, line2] : []
						]) if (e!=[]) e ]
			]
	)
	/*
		echo("xor - trace:\n",  echo_list(trace1,"trace1"),echo_list(trace2, "trace2"))
		echo("xor - isp",       echo_list(isp))
	//*/
	isp==[] ? [trace1, trace2] :
	let (
		// sorting the points, they must insert into the traces in ascending order
		 size_isp = len (isp)
		,isp_sort = sort (isp     , [0])
		,isp_clean= keep_unique (isp_sort)
		,isp_1    = sort (isp_clean, [1])
		,isp_2    = sort (isp_clean, [2])
	)
	/*
		echo("xor - isp_clean", echo_list(isp_clean))
	//*/
	isp_clean==[]     ? [trace1, trace2] :
	len(isp_clean)==1 ? [trace1, trace2] :
	let (
		// insert points into the traces
		 tn_1a =
			[ for (i=[0:1:size1-1])
				let (
					 isp_i_ = keep_value(isp_1, i, [1])
					,isp_i  = trace1[i]<trace1[(i+1)%size1] ? isp_i_ : reverse(isp_i_)
				)
				each [trace1[i], each value_list(isp_i, [0]) ]
			]
		,tn_1b = unique (tn_1a)
		,tn_1  = tn_1b[0]!=tn_1b[len(tn_1b)-1] ? tn_1b : remove(tn_1b, -1)
		,tn_2a =
			[ for (i=[0:1:size2-1])
				let (
					 isp_i_ = keep_value(isp_2, i, [2])
					,isp_i  = trace2[i]<trace2[(i+1)%size2] ? isp_i_ : reverse(isp_i_)
				)
				each [trace2[i], each value_list(isp_i, [0]) ]
			]
		,tn_2b = unique (tn_2a)
		,tn_2  = tn_2b[0]!=tn_2b[len(tn_2b)-1] ? tn_2b : remove(tn_2b, -1)
		// get intersecting points again with already existing points
		// need no point, only the positions to the points
		,isp_n1 =
			[for (i=[0:1:len(tn_1)-1])
				for (j=[0:1:len(tn_2)-1])
					if (tn_1[i]==tn_2[j])
						[i, j]
			]
		,isp_n2 = sort (isp_n1, [1])
		,string1 = split_trace (tn_1, value_list(isp_n1,[0]), tn_2 )
		,string2 = split_trace (tn_2, value_list(isp_n2,[1]), tn_1 )
		//
		,string  = xor_remove_double ([ each string1, each string2])
		,res = xor_put_together (string)
	)
	/*
	echo("xor"
		,"\ntrace1\t", trace1
		,"\ntn_1\t",   tn_1
		,"\ntrace2\t", trace2
		,"\ntn_2\t",   tn_2
		,"\nisp\t",    echo_list_intern(isp)
		,"\nisp_clean\t", echo_list_intern(isp_clean)
		,"\nisp_n1\t",  isp_n1
		,"\nisp_n2\t",  isp_n2
		,"\nstring1\t", echo_list_intern(string1)
		,"\nstring2\t", echo_list_intern(string2)
		,"\nstring\t",  echo_list_intern(string)
		,"\nres\t",     echo_list_intern(res)
		)//*/
	res
;

function split_trace (trace, cuts, trace2) =
	let(
		 count  = len(cuts)
		,t_list =
			 count==0 ? [ trace ]
			:count==1 ? [ rotate_list (trace, middle=cuts[0]) ]
			:
			[	each [for (i=[1:1:count-1]) extract(trace, begin=cuts[i-1], last=cuts[i]) ]
			,	[ each extract(trace, begin=cuts[count-1]), each extract(trace, last=cuts[0]) ]
			]
		,data =
			[for (i=[0:1:count-1])
				//is_first_inside==is_even(i)
				is_point_inside_polygon (trace2, midpoint_2( t_list[i][0], t_list[i][1]) )
				// is_inside, string
				? [ true    , reverse (t_list[i]) ]
				: [ false   ,          t_list[i]  ]
			]
	)
	data
;
function xor_remove_double (string) =
	let (
	//	 s = sort (string, type=[1])
	//	,r = keep_unique (s)
		 p = partition (string, f=function(e) e[0]==true && len(e[1])==2 )
	)
	p[0]==[] ? string :
	let(
		 fp = function(e)
			e[1][0]<=e[1][1]
			?	[e[0],[e[1][0],e[1][1]]]
			:	[e[0],[e[1][1],e[1][0]]] 
		,ps = sort        (p[0], type=type_function(fp))
		,pr = keep_unique (ps  , type=type_function(fp))
	//	,r = keep_unique (s,[0])
	)
	/* echo("xor_remove_double"
	//	, echo_list(s,"s")
	//	, echo_list(r,"r")
		, echo_list(p[0],"p")
		, echo_list(ps,"ps")
		, echo_list(pr,"pr")
	)//*/
	[ each pr, each p[1] ]
//	[ each p[1], each pr ]
//	r
;

function xor_put_together (string, result=[]) =
	// neue Runde, neues Glück
	string==[] ? result :
	let (
		 is_reverse_n = string[0][0]
		,str_n        = string[0][1]
		,append_n     = remove (str_n, begin=0)
		,glue_p       = str_n[0]
		,string_n     = remove (string, begin=0)
	)
	/*
	echo("xpt - start"
		,"\nis_reverse1\t",is_reverse_n
		,"\nstring\t"    ,echo_list(string)
	)//*/
	last_value(append_n)==glue_p ?
		xor_put_together      (string_n, [ each result, append_n ])
	:	xor_put_together_next (string_n, result,  glue_p, !is_reverse_n, append_n)
;
function xor_put_together_next (string, result=[]
	, glue_point=undef, is_reverse=undef, append=[]
	, reverse=true, position=undef) =
	// bestehende Runde fortsetzen
	string==[] ?
		echo("TODO xor_put_together_next - empty working string")
		[ each result, append ]
	:
	let (
		pos = position!=undef
			?	position
			:	get_next_trace_position (string, append, xor(is_reverse,!reverse) )
	)
	pos==undef ?
		reverse==false
		?
			assert (false, "TODO xor_put_together_next - no match found")
			result
			// [each result, each value_list(string,[1]), [glue_point, each append] ]
		:	xor_put_together_next (string, result, glue_point, is_reverse, append, reverse=false)
	:
	let (
		 is_reverse_n = string[pos][0]
		,str_n        = string[pos][1]
		,str_a        = remove (str_n, begin=0)
		//
		,string_n = remove (string, begin=pos)
		,append_n = [ each append, each str_a ]
		//
		,pos_n = get_next_trace_position (string_n, append_n, !is_reverse_n)
	)
	/*
	echo("xpt - next"
		,"\npos\t"       ,pos
		,"\nreverse\t"     ,reverse
		,"\nis_reverse\t"  ,is_reverse
		,"\nis_reverse_n\t",is_reverse_n
		,"\nstring\t"     ,echo_list(string)
	)//*/
	pos_n==undef && last_value(append_n)==glue_point
	?	xor_put_together      (string_n, [ each result, append_n ])
	:	xor_put_together_next (string_n, result,  glue_point, !is_reverse_n, append_n, position=pos_n)
;

function get_next_trace_position (string, append, is_reverse) =
	let (
		pos_l =
			[for (i=[0:1:len(string)-1])
				if ( is_reverse==string[i][0] )
				if ( string[i][1][0]==last_value(append) )
				i
			]
		,pos   = pos_l[0]
	)
	pos
;

//------------------------------------------------------------------------

// Verbindet ineinander verschachtelte Polygone miteinander.
// Löcher werden mit der Außenwand verbunden.
// Vorbereitung zum Aufteilen in Dreiecke
function connect_polygon_holes_traces (traces) =
	let (
		 children  =         list_polygon_holes_next_traces  (traces)
		,orient    = [for (e=list_polygon_holes_parent_traces(traces)) len(e)]
		,t_rotated = unify_polygon_rotation_traces (traces, orient)
		,linked    =
			[for (i=[0:1:len(traces)-1])
				// only traces with math rotation has children holes
				if (is_even (orient[i]))
					connect_polygon_holes_trace (t_rotated[i], select(t_rotated,children[i]) )
			]
	)
	// echo("connect_polygon_holes_traces", echo_list(linked, "linked"))
	value_list (linked, [0])
;
function connect_polygon_holes_trace (trace, holes=[],  i=0) =
	holes==undef || holes==[] ? [trace] :
	i>=len(holes) ? [trace, holes] :
	let (
		pos = find_polygon_connect (trace, holes, i)
	)
	// echo("connect_polygon_holes_trace",i, len(holes), pos,"\n",holes[i], echo_list(holes))
	pos==undef ?
		connect_polygon_holes_trace (trace, holes, i+1)
	:
	let (
		 trace_n =
			[	each rotate_list (trace,    pos[0])
			,	trace   [ pos[0] ]
			,	each rotate_list (holes[i], pos[1])
			,	holes[i][ pos[1] ]
			]
		,holes_n = remove (holes, i)
	)
	connect_polygon_holes_trace (trace_n, holes_n, 0)
;
// return = [pos_trace, pos_hole]
// return = undef in nothing found
function find_polygon_connect (trace, holes, hole_number,  pos_trace=0, pos_hole=0) =
	pos_trace>=len(trace) ? undef :
	pos_hole >=len(holes[hole_number])
	?	find_polygon_connect (trace, holes, hole_number, pos_trace+1, 0)
	:
	let (
		 hole = holes[hole_number]
		,line = [ trace[pos_trace], hole[pos_hole] ]
	)
	is_intersection_polygon_segment (trace, line, without=pos_trace) ||
	is_intersection_polygon_segment (hole , line, without=pos_hole ) ||
	[for (i=[0:1:len(holes)-1])
		if (i!=hole_number)
		if (is_intersection_polygon_segment (holes[i], line) )
		i ] != []
	?	find_polygon_connect (trace, holes, hole_number, pos_trace, pos_hole+1)
	:
	[pos_trace, pos_hole]
;


function list_polygon_holes_next_traces (traces) =
	let (
		ch_ldren = list_polygon_holes_children_traces (traces),
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

function list_polygon_holes_parent_traces (traces) =
	traces==undef ? [] :
	[for (i=[0:1:len(traces)-1])
		[ for (j=[0:1:len(traces)-1])
			if (i!=j && is_point_inside_polygon (traces[j], traces[i][0])) j ]
	]
;

function list_polygon_holes_children_traces (traces) =
	traces==undef ? [] :
	[for (i=[0:1:len(traces)-1])
		[ for (j=[0:1:len(traces)-1])
			if (i!=j && is_point_inside_polygon (traces[i], traces[j][0])) j ]
	]
;

// 'orientation' - Liste mit Zahlen
// - ohne Angabe = mathematischer Drehsinn
// - gerade      = mathematischer Drehsinn
// - ungerade    = Uhrzeigersinn
function unify_polygon_rotation_traces (traces, orientation) =
	[for (i=[0:1:len(traces)-1])
		let (
			maintain =
				xor (
				 	!(orientation==undef || is_even(orientation[i]))
				,	is_math_rotation_polygon (traces[i])
				)
		)
		maintain ? traces[i] : reverse(traces[i])
	]
;

//------------------------------------------------------------------------

//
function tesselate_all_traces (traces) =
	let (
		 linked = connect_polygon_holes_traces (traces)
		,tessel = concat_list( [for (poly=linked) tesselate_trace (poly) ] )
	) tessel
;

//
function tesselate_trace (trace) =
//	tesselate_trace_next (trace)
	tesselate_trace_split (trace)
;

//----------------------------------------------------
function tesselate_trace_split (trace, triangles=[]) =
	let ( size = len(trace) )
	size<=2 ? triangles :
	size==3 ? [ each triangles, trace ] :
	let (
		// returns [pos1, pos2]
		pos = tesselate_trace_split_position (trace, size)
	)
	//	echo("tesselate_trace_split", size, pos)
	pos==[]
	?	 // TODO stupid tesselate at here possible
	//	[ each triangles, each tesselate_trace_next (trace) ]
		[ each triangles, each tesselate_trace_stupid (trace) ]
	//	[ each triangles, (trace) ]
	:
	let (
		 pos_s   = pos[0]<pos[1] ? pos : [pos[1],pos[0]]
		,trace_1 = extract (trace, begin=pos_s[0], last=pos_s[1])
		,trace_2 = [ each extract (trace, begin=pos_s[1])
		           , each extract (trace, last =pos_s[0]) ]
	)
	[ each tesselate_trace_split (trace_1, triangles)
	, each tesselate_trace_split (trace_2, triangles)
	]
;
function tesselate_trace_split_position (trace, size=0, i=0) =
	i>=size ? [] :
	let (
		r = trace[(i-1+size)%size],
		o = trace[  i  ],
		l = trace[(i+1)%size],
		angle = rotation_vector (l-o, r-o)
	)
	//	echo("tesselate_trace_split_position", i, angle)
	angle<180 || is_nan(angle)
	?	tesselate_trace_split_position (trace, size, i+1)
	:
	// Einbuchtung gefunden, gegenüberliegenden Punkt finden
	let (
		pos = find_connect_trace (trace, i)
	)
	pos==i || o==trace[pos]
	?	tesselate_trace_split_position (trace, size, i+1)
	:	[i, pos]
;

// gibt pos zurück im Fehlerfall
function find_connect_trace (trace, position, fast=true) =
	find_connect_trace_intern (trace, position, fast, len(trace)) [0]
;
function find_connect_trace_intern (trace, position, fast, size, i=0) =
	i>=size     ? [position] :
	i==(position-1+size)%size ? find_connect_trace_intern (trace, position, fast, size, i+1) :
	i== position              ? find_connect_trace_intern (trace, position, fast, size, i+1) :
	i==(position+1)%size      ? find_connect_trace_intern (trace, position, fast, size, i+1) :
	let(
		 without = [i, position]
		,line    = select (trace, without)
	)
	//	echo("find_connect_trace", size, position, i)
	    is_intersection_polygon_segment (trace, line, without=without)
	|| !is_point_inside_polygon_2d  (trace, midpoint_line(line) )
	?	find_connect_trace_intern (trace, position, fast, size, i+1)
	:	
	//	echo("find_connect_trace - found", size, position, i)
	fast==true ? [i] :
	// try a better position
	let(
		 d    = length_line (line)
		,next = find_connect_trace_intern (trace, position, fast, size, i+1)
	)
	next[0]==position || d<next[1]
	?	[i, d]
	:	next
;

// Zerlegt das Polygon in Dreiecke ohne irgendeinen Test.
// Geht nur gut mit Innenwinkeln kleiner als 180°
function tesselate_trace_stupid (trace) =
	let(
		 size = len(trace)
		,middle = floor(size/2)
	)
	size<=3 ? [trace] :
	[ each tesselate_trace_stupid (       extract (trace, last =middle) )
	, each tesselate_trace_stupid ([ each extract (trace, begin=middle), trace[0] ] )
	]
;

//-----------------------------------------------------
// Entfernt nacheinander jedes Dreieck aus dem Polygon,
// das keine Überschneidungen mit der Außenlinie hat.
// TODO Hat Probleme mit Segmenten in einer Geraden verbunden.
function tesselate_trace_next (trace, triangles=[]) =
	//	echo("tesselate_trace_next - start", len(triangles)-1,"\n---->", trace,"\n", echo_list(triangles))
	let (
		size=len(trace)
	)
	size <3 ? triangles :
	size==3 ? [ each triangles, trace ] :
	let (
		pos = tesselate_trace_next_intern_find (trace, size),
		sel = [ pos, (pos+1)%size, (pos+2)%size ]
	)
	pos==size ?
		//	echo ("tesselate_trace_next() - break", trace)
		triangles
	:
	let (
		sel = [ pos, (pos+1)%size, (pos+2)%size ]
	)
	tesselate_trace_next (
		 [ for (j=[0:1:size-1]) if (j!=sel[1]) trace[j] ]
		,[ each triangles, select(trace, sel) ]
	)
;
function tesselate_trace_next_intern_find (trace, size, i=0) =
	i>=size ? size :
	let (
		r = trace[  i       ],
		o = trace[(i+1)%size],
		l = trace[(i+2)%size],
		angle = rotation_vector (l-o, r-o)
	)
	//	echo(i, angle)
	( angle<180 ) && ( count_points_inside_triangle ([r,o,l], trace, false)<=0 )
	?	i
	:	tesselate_trace_next_intern_find (trace, size, i+1)
;

