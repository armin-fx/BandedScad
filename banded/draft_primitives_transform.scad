// Copyright (c) 2021 Armin Frenzel
// License: LGPL-2.1-or-later
//
// Funktionen zum transformieren von Objekte in Listen,
// die an polygon() oder polyhedron() übergeben werden können.

use <banded/helper_primitives.scad>

use <banded/draft_transform.scad>
use <banded/draft_multmatrix.scad>
use <banded/draft_primitives_basic.scad>


function rotate_backwards (object, a, v) = transform_function (object, function (list)
    rotate_backwards_points (list, a, v) )
;
function rotate_at (object, a, p, v, backwards) = transform_function (object, function (list)
    rotate_at_points (list, a, p, v, backwards) )
;
function rotate_backwards_at (object, a, p, v) = transform_function (object, function (list)
    rotate_backwards_at_points (list, a, p, v) )
;
function rotate_to_vector (object, v, a, backwards) = transform_function (object, function (list)
    rotate_to_vector_points (list, v, a, backwards) )
;
function rotate_backwards_to_vector (object, v, a) = transform_function (object, function (list)
    rotate_backwards_to_vector_points (list, v, a) )
;
function rotate_to_vector_at (object, v, p, a, backwards) = transform_function (object, function (list)
    rotate_to_vector_at_points (list, v, p, a, backwards) )
;
function rotate_backwards_to_vector_at (object, v, p, a) = transform_function (object, function (list)
    rotate_backwards_to_vector_at_points (list, v, p, a) )
;

//---------------------------------------------------------
function rotate_x (object, a, backwards) = transform_function (object, function (list)
    rotate_x_points (list, a, backwards) )
;
function rotate_y (object, a, backwards) = transform_function (object, function (list)
    rotate_y_points (list, a, backwards) )
;
function rotate_z (object, a, backwards) = transform_function (object, function (list)
    rotate_z_points (list, a, backwards) )
;
function rotate_backwards_x (object, a) = transform_function (object, function (list)
    rotate_backwards_x_points (list, a) )
;
function rotate_backwards_y (object, a) = transform_function (object, function (list)
    rotate_backwards_y_points (list, a) )
;
function rotate_backwards_z (object, a) = transform_function (object, function (list)
    rotate_backwards_z_points (list, a) )
;
function rotate_at_x (object, a, p, backwards) = transform_function (object, function (list)
    rotate_at_x_points (list, a, p, backwards) )
;
function rotate_at_y (object, a, p, backwards) = transform_function (object, function (list)
    rotate_at_y_points (list, a, p, backwards) )
;
function rotate_at_z (object, a, p, backwards) = transform_function (object, function (list)
    rotate_at_z_points (list, a, p, backwards) )
;

function rotate_backwards_at_x (object, a, p) = transform_function (object, function (list)
    rotate_backwards_at_x_points (list, a, p) )
;
function rotate_backwards_at_y (object, a, p) = transform_function (object, function (list)
    rotate_backwards_at_y_points (list, a, p) )
;
function rotate_backwards_at_z (object, a, p) = transform_function (object, function (list)
    rotate_backwards_at_z_points (list, a, p) )
;

//---------------------------------------------------------
function translate_x (object, l) = transform_function (object, function (list)
    translate_x_points (list, l) )
;
function translate_y (object, l) = transform_function (object, function (list)
    translate_y_points (list, l) )
;
function translate_z (object, l) = transform_function (object, function (list)
    translate_z_points (list, l) )
;

function translate_xy (object, t) = transform_function (object, function (list)
    translate_xy_points (list, t) )
;

//---------------------------------------------------------
function mirror_at (object, v, p) = transform_function (object, function (list)
    mirror_at_points (list,   v, p) )
;

//
function mirror_x (object) = transform_function (object, function (list)
    mirror_x_points (list) )
;
function mirror_y (object) = transform_function (object, function (list)
    mirror_y_points (list) )
;
function mirror_z (object) = transform_function (object, function (list)
    mirror_z_points (list) )
;
//
function mirror_at_x (object, p) = transform_function (object, function (list)
    mirror_at_x_points (list, p) )
;
function mirror_at_y (object, p) = transform_function (object, function (list)
    mirror_at_y_points (list, p) )
;
function mirror_at_z (object, p) = transform_function (object, function (list)
    mirror_at_z_points (list, p) )
;

//---------------------------------------------------------
function scale_x (object, f) = transform_function (object, function (list)
    scale_x_points (list, f) )
;
function scale_y (object, f) = transform_function (object, function (list)
    scale_y_points (list, f) )
;

function scale_z (object, f) = transform_function (object, function (list)
    scale_z_points (list, f) )
;

//---------------------------------------------------------
function resize_x (object, l) = transform_function (object, function (list)
    resize_x_points (list, l) )
;
function resize_y (object, l) = transform_function (object, function (list)
    resize_y_points (list, l) )
;

function resize_z (object, l) = transform_function (object, function (list)
    resize_z_points (list, l) )
;

//---------------------------------------------------------
function skew (object, v, t, m, a) = transform_function (object, function (list)
    skew_points (list, v, t, m, a) )
;
function skew_at (object, v, t, m, a, p) = transform_function (object, function (list)
    skew_at_points (list, v, t, m, a, p) )
;

