// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen zum transformieren von Objekte in Listen,
// die an polygon() oder polyhedron() übergeben werden können.

use <banded/draft_transform_common.scad>
use <banded/draft_transform_basic.scad>
use <banded/draft_multmatrix_common.scad>
use <banded/draft_multmatrix_basic.scad>
use <banded/draft_primitives_basic.scad>


function rotate_backwards (object, a, v) = transform_function (object, function (list)
    rotate_backwards_list (list,   a, v) )
;
function rotate_at (object, a, p, v, backwards) = transform_function (object, function (list)
    rotate_at_list (list,   a, p, v, backwards) )
;
function rotate_backwards_at (object, a, p, v) = transform_function (object, function (list)
    rotate_backwards_at_list (list,   a, p, v) )
;
function rotate_to_vector (object, v, a, backwards) = transform_function (object, function (list)
    rotate_to_vector_list (list,   v, a, backwards) )
;
function rotate_backwards_to_vector (object, v, a) = transform_function (object, function (list)
    rotate_backwards_to_vector_list (list,   v, a) )
;
function rotate_to_vector_at (object, v, p, a, backwards) = transform_function (object, function (list)
    rotate_to_vector_at_list (list,   v, p, a, backwards) )
;
function rotate_backwards_to_vector_at (object, v, p, a) = transform_function (object, function (list)
    rotate_backwards_to_vector_at_list (list,   v, p, a) )
;

//---------------------------------------------------------
function rotate_x (object, a, backwards) = transform_function (object, function (list)
    rotate_x_list (list,   a, backwards) )
;
function rotate_y (object, a, backwards) = transform_function (object, function (list)
    rotate_y_list (list,   a, backwards) )
;
function rotate_z (object, a, backwards) = transform_function (object, function (list)
    rotate_z_list (list,   a, backwards) )
;
function rotate_backwards_x (object, a) = transform_function (object, function (list)
    rotate_backwards_x_list (list,   a) )
;
function rotate_backwards_y (object, a) = transform_function (object, function (list)
    rotate_backwards_y_list (list,   a) )
;
function rotate_backwards_z (object, a) = transform_function (object, function (list)
    rotate_backwards_z_list (list,   a) )
;
function rotate_at_x (object, a, p, backwards) = transform_function (object, function (list)
    rotate_at_x_list (list,   a, p, backwards) )
;
function rotate_at_y (object, a, p, backwards) = transform_function (object, function (list)
    rotate_at_y_list (list,   a, p, backwards) )
;
function rotate_at_z (object, a, p, backwards) = transform_function (object, function (list)
    rotate_at_z_list (list,   a, p, backwards) )
;

function rotate_backwards_at_x (object, a, p) = transform_function (object, function (list)
    rotate_backwards_at_x_list (list,   a, p) )
;
function rotate_backwards_at_y (object, a, p) = transform_function (object, function (list)
    rotate_backwards_at_y_list (list,   a, p) )
;
function rotate_backwards_at_z (object, a, p) = transform_function (object, function (list)
    rotate_backwards_at_z_list (list,   a, p) )
;

//---------------------------------------------------------
function translate_x (object, l) = transform_function (object, function (list)
    translate_x_list (list,   l) )
;
function translate_y (object, l) = transform_function (object, function (list)
    translate_y_list (list,   l) )
;
function translate_z (object, l) = transform_function (object, function (list)
    translate_z_list (list,   l) )
;

function translate_xy (object, t) = transform_function (object, function (list)
    translate_xy_list (list,   t) )
;

//---------------------------------------------------------
function mirror_at (object, v, p) = transform_function (object, function (list)
    mirror_at_list (list,   v, p) )
;

//
function mirror_x (object) = transform_function (object, function (list)
    mirror_x_list (list) )
;
function mirror_y (object) = transform_function (object, function (list)
    mirror_y_list (list) )
;
function mirror_z (object) = transform_function (object, function (list)
    mirror_z_list (list) )
;
//
function mirror_at_x (object, p) = transform_function (object, function (list)
    mirror_at_x_list (list,   p) )
;
function mirror_at_y (object, p) = transform_function (object, function (list)
    mirror_at_y_list (list,   p) )
;
function mirror_at_z (object, p) = transform_function (object, function (list)
    mirror_at_z_list (list,   p) )
;

//---------------------------------------------------------
function scale_x (object, f) = transform_function (object, function (list)
    scale_x_list (list,   f) )
;
function scale_y (object, f) = transform_function (object, function (list)
    scale_y_list (list,   f) )
;

function scale_z (object, f) = transform_function (object, function (list)
    scale_z_list (list,   f) )
;

//---------------------------------------------------------
function resize_x (object, l) = transform_function (object, function (list)
    resize_x_list (list,   l) )
;
function resize_y (object, l) = transform_function (object, function (list)
    resize_y_list (list,   l) )
;

function resize_z (object, l) = transform_function (object, function (list)
    resize_z_list (list,   l) )
;

//---------------------------------------------------------
function skew (object, v, t, m, a) = transform_function (object, function (list)
    skew_list (list,   v, t, m, a) )
;
function skew_at (object, v, t, m, a, p) = transform_function (object, function (list)
    skew_at_list (list,   v, t, m, a, p) )
;

