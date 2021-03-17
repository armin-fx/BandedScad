// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen zum transformieren von Objekte in Listen,
// die an polygon() oder polyhedron() übergeben werden können.

use <banded/draft_transform_common.scad>
use <banded/draft_transform_basic.scad>
use <banded/draft_multmatrix_common.scad>
use <banded/draft_multmatrix_basic.scad>


function rotate_backwards (object, a, v) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_points (list, a, v)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_points (list, a, v)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_points (list, a, v)
				]
			:undef
		:
			object[k]
	]
;
function rotate_at (object, a, p, v, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_at_points (list, a, p, v, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_at_points (list, a, p, v, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_at_points (list, a, p, v, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_at (object, a, p, v) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_at_points (list, a, p, v)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_at_points (list, a, p, v)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_at_points (list, a, p, v)
				]
			:undef
		:
			object[k]
	]
;
function rotate_to_vector (object, v, a, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_to_vector_points (list, v, a, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_to_vector_points (list, v, a, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_to_vector_points (list, v, a, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_to_vector (object, v, a) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_to_vector_points (list, v, a)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_to_vector_points (list, v, a)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_to_vector_points (list, v, a)
				]
			:undef
		:
			object[k]
	]
;
function rotate_to_vector_at (object, v, p, a, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_to_vector_at_points (list, v, p, a, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_to_vector_at_points (list, v, p, a, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_to_vector_at_points (list, v, p, a, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_to_vector_at (object, v, p, a) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_to_vector_at_points (list, v, p, a)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_to_vector_at_points (list, v, p, a)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_to_vector_at_points (list, v, p, a)
				]
			:undef
		:
			object[k]
	]
;

//---------------------------------------------------------
function rotate_x (object, a, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_x_points (list, a, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_x_points (list, a, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_x_points (list, a, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_y (object, a, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_y_points (list, a, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_y_points (list, a, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_y_points (list, a, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_z (object, a, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_z_points (list, a, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_z_points (list, a, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_z_points (list, a, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_x (object, a) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_x_points (list, a)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_x_points (list, a)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_x_points (list, a)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_y (object, a) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_y_points (list, a)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_y_points (list, a)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_y_points (list, a)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_z (object, a) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_z_points (list, a)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_z_points (list, a)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_z_points (list, a)
				]
			:undef
		:
			object[k]
	]
;
function rotate_at_x (object, a, p, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_at_x_points (list, a, p, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_at_x_points (list, a, p, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_at_x_points (list, a, p, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_at_y (object, a, p, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_at_y_points (list, a, p, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_at_y_points (list, a, p, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_at_y_points (list, a, p, backwards)
				]
			:undef
		:
			object[k]
	]
;
function rotate_at_z (object, a, p, backwards) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_at_z_points (list, a, p, backwards)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_at_z_points (list, a, p, backwards)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_at_z_points (list, a, p, backwards)
				]
			:undef
		:
			object[k]
	]
;

function rotate_backwards_at_x (object, a, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_at_x_points (list, a, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_at_x_points (list, a, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_at_x_points (list, a, p)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_at_y (object, a, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_at_y_points (list, a, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_at_y_points (list, a, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_at_y_points (list, a, p)
				]
			:undef
		:
			object[k]
	]
;
function rotate_backwards_at_z (object, a, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		rotate_backwards_at_z_points (list, a, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				rotate_backwards_at_z_points (list, a, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				rotate_backwards_at_z_points (list, a, p)
				]
			:undef
		:
			object[k]
	]
;

//---------------------------------------------------------
function translate_x (object, l) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		translate_x_points (list, l)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				translate_x_points (list, l)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				translate_x_points (list, l)
				]
			:undef
		:
			object[k]
	]
;
function translate_y (object, l) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		translate_y_points (list, l)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				translate_y_points (list, l)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				translate_y_points (list, l)
				]
			:undef
		:
			object[k]
	]
;
function translate_z (object, l) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		translate_z_points (list, l)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				translate_z_points (list, l)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				translate_z_points (list, l)
				]
			:undef
		:
			object[k]
	]
;

function translate_xy (object, t) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		translate_xy_points (list, t)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				translate_xy_points (list, t)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				translate_xy_points (list, t)
				]
			:undef
		:
			object[k]
	]
;

//---------------------------------------------------------
function mirror_at (object, v, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_at_points (list, v, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_at_points (list, v, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_at_points (list, v, p)
				]
			:undef
		:
			object[k]
	]
;

//
function mirror_x (object) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_x_points (list)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_x_points (list)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_x_points (list)
				]
			:undef
		:
			object[k]
	]
;
function mirror_y (object) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_y_points (list)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_y_points (list)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_y_points (list)
				]
			:undef
		:
			object[k]
	]
;
function mirror_z (object) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_z_points (list)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_z_points (list)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_z_points (list)
				]
			:undef
		:
			object[k]
	]
;
//
function mirror_at_x (object, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_at_x_points (list, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_at_x_points (list, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_at_x_points (list, p)
				]
			:undef
		:
			object[k]
	]
;
function mirror_at_y (object, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_at_y_points (list, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_at_y_points (list, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_at_y_points (list, p)
				]
			:undef
		:
			object[k]
	]
;
function mirror_at_z (object, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		mirror_at_z_points (list, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				mirror_at_z_points (list, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				mirror_at_z_points (list, p)
				]
			:undef
		:
			object[k]
	]
;

//---------------------------------------------------------
function scale_x (object, f) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		scale_x_points (list, f)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				scale_x_points (list, f)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				scale_x_points (list, f)
				]
			:undef
		:
			object[k]
	]
;
function scale_y (object, f) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		scale_y_points (list, f)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				scale_y_points (list, f)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				scale_y_points (list, f)
				]
			:undef
		:
			object[k]
	]
;

function scale_z (object, f) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		scale_z_points (list, f)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				scale_z_points (list, f)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				scale_z_points (list, f)
				]
			:undef
		:
			object[k]
	]
;

//---------------------------------------------------------
function resize_x (object, l) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		resize_x_points (list, l)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				resize_x_points (list, l)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				resize_x_points (list, l)
				]
			:undef
		:
			object[k]
	]
;
function resize_y (object, l) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		resize_y_points (list, l)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				resize_y_points (list, l)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				resize_y_points (list, l)
				]
			:undef
		:
			object[k]
	]
;

function resize_z (object, l) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		resize_z_points (list, l)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				resize_z_points (list, l)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				resize_z_points (list, l)
				]
			:undef
		:
			object[k]
	]
;

//---------------------------------------------------------
function skew    (object, v, t, m, a) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		skew_points (list, v, t, m, a)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				skew_points (list, v, t, m, a)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				skew_points (list, v, t, m, a)
				]
			:undef
		:
			object[k]
	]
;
function skew_at (object, v, t, m, a, p) =
	(object==undef || !is_list(object)) ? undef :
	is_num(object[0][0]) ?
		let(list=object)
		skew_at_points (list, v, t, m, a, p)
	:
	[ for (k=[0:1:len(object)-1])
		k==0 ?
			 is_num(object[0][0][0]) ?
				let(list=object[0])
				skew_at_points (list, v, t, m, a, p)
			:is_num(object[0][0][0][0]) ?
				[for (list=object[0])
				skew_at_points (list, v, t, m, a, p)
				]
			:undef
		:
			object[k]
	]
;

