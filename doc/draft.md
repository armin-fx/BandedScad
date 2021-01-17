
Draft objects in a point list
=============================

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_curves.scad`\
` `| \
` `+--> `banded/draft_transform.scad`\
` `| . . . . +--> `banded/draft_transform_basic.scad`\
` `| . . . . +--> `banded/draft_transform_common.scad`\
` `| \
` `+--> `banded/draft_multmatrix.scad`\
` `. . . . . +--> `banded/draft_multmatrix_basic.scad`\
` `. . . . . +--> `banded/draft_multmatrix_common.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Curves](#curves-)
  - [Bezier curve](#bezier-curve-)
  - [Circle](#circle-)
  - [Superellipse](#superellipse-)
  - [Superformula](#superformula-)
  - [Polynomial function](#polynomial-function-)
  - [Square](#square-)
  - [Helix](#helix-)
- [Transform functions on list](#transform-functions-)
  - [Basic transformation](#basic-transformation-)
    - [`translate_list()`](#translate_list-list-v-)
    - [`rotate_list()`](#rotate_list-list-a-v-)
    - [`mirror_list()`](#mirror_list-list-v-)
    - [`scale_list()`](#scale_list-list-v-)
    - [`resize_list()`](#resize_list-list-newsize-)
    - [`projection_list()`](#projection_list-list-plane-)
    - [`multmatrix_list()`](#multmatrix_list-list-m-)
  - [More transformation](#more-transformation-)
    - [`rotate_backwards_list()`](#rotate_backwards_list-list-a-v-)
    - [`rotate_at_list()`](#rotate_at_list-list-a-p-v-)
    - [`rotate_to_vector_list()`](#rotate_to_vector_list-list-v-a-)
    - [`rotate_to_vector_at_list()`](#rotate_to_vector_at_list-list-v-p-a-)
    - [`mirror_at_list()`](#mirror_at_list-list-v-p-)
  - [Transformation at a fixed axis](#transformation-at-a-fixed-axis-)
- [Multmatrix](#multmatrix-)
  - [Basic multmatrix functions](#basic-multmatrix-functions-)
    - [`matrix_translate()`](#matrix_translate-v-d-)
    - [`matrix_rotate()`](#matrix_rotate-a-v-d-)
    - [`matrix_mirror()`](#matrix_mirror-v-d-)
    - [`matrix_scale()`](#matrix_scale-v-d-)
  - [More multmatrix functions](#more-multmatrix-functions-)
    - [`matrix_rotate_backwards()`](#matrix_rotate_backwards-a-v-d-)
    - [`matrix_rotate_at()`](#matrix_rotate_at-a-p-v-d-)
    - [`matrix_rotate_to_vector()`](#matrix_rotate_to_vector-v-a-)
    - [`matrix_rotate_to_vector_at()`](#matrix_rotate_to_vector_at-v-p-a-)
    - [`matrix_mirror_at()`](#matrix_mirror_at-v-p-d-)
  - [Multmatrix on a fixed axis](#multmatrix-on-a-fixed-axis-)
    - [Basic multmatrix at fixed axis](#basic-multmatrix-at-fixed-axis-)
    - [More multmatrix at fixed axis](#more-multmatrix-at-fixed-axis-)

Curves [^][contents]
--------------------

Creates curves in a list

There is a name convention of functions from curves:
- Name of curve type with ending `_point` - creates a point of the curve at given position.\
  such as `circle_point()`
- Name of curve type with ending `_curve` - creates a curve with given parameters.\
  such as `circle_curve()`

### defined in file
`banded/draft_curves.scad`

### Bezier curve [^][contents]
Generates a Bézier curve.\
[=> Wikipedia - Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)

#### `bezier_point (t, p, n)` [^][contents]
Returns a point of a Bézier curve of the n'th degree depending on the parameters.

__Options:__
- `t`
  - a numeric value between `0`...`1`
- `p`
  - `[p0, ..., pn]` - list with control points
  - `p0` - first point of the curve, `pn` - last point of the curve
  - The array cannot contain fewer than `n+1` elements
- `n`
  - Specify of the degree of the Bézier curve
  - only the points up to `p[n]` are taken
  - if `n` is not specified, the degree is taken based on the size of the list

#### `bezier_curve (p, n, slices)` [^][contents]
Return a list with the points of a Bézier curve

__Options:__
- `t`
  - a numeric value between `0`...`1`
- `p`
  - `[p0, ..., pn]` - list with control points
  - `p0` - first point of the curve, `pn` - last point of the curve
  - The array cannot contain fewer than `n+1` elements
- `n`
  - Specify of the degree of the Bézier curve
  - only the points up to `p[n]` are taken
  - if `n` is not specified, the degree is taken based on the size of the list
- `slices`
  - Bézier curve is sliced in fragments into this number of points, at least 2 points
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken (roughly implemented)
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used  (roughly implemented)

#### `bezier_1 (t, p)` [^][contents]
Return a point of a Bézier curve with 1'st degree (linear Bézier curve)
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, p1]` - list with 2 control points
  - `p0` - first point of the curve, `p1` - last point of the curve

#### `bezier_2 (t, p)` [^][contents]
Return a point of a Bézier curve with 2'st degree (quadratic Bézier curve)
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, p1, p2]` - list with 3 control points
  - `p0` - first point of the curve, `p2` - last point of the curve

#### `bezier_3 (t, p)` [^][contents]
Return a point of a Bézier curve with 3'st degree (cubic Bézier curve)
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, p1, p2, p3]` - list with 4 control points
  - `p0` - first point of the curve, `p3` - last point of the curve

#### `bezier_4 (t, p)` [^][contents]
Return a point of a Bézier curve with 4'st degree
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, ... , p4]` - list with 5 control points
  - `p0` - first point of the curve, `p4` - last point of the curve


### Circle [^][contents]
Generates a circle.

#### `circle_point (r, angle, d)` [^][contents]
Returns a 2d point of a circle with center at origin.\
Turns at mathematical direction of rotation = counter clockwise.

__Options:__
- `r, d`
  - radius or diameter of circle
- `angle`
  - point at given angle

#### `circle_curve (r, angle, slices, piece, outer, d)` [^][contents]
Return a 2d point list of a circle.

__Options:__
- `r, d`
  - radius or diameter of circle
- `angle`
  - drawed angle in grad, standard=360°
    - as number -> angle from 0 to `angle` = opening angle
    - as list   -> range `[opening angle, begin angle]`
- `slices`
   - count of segments, without specification it gets the same like `circle()`
   - with `"x"` includes the extra special variables to automatically control the count of segments
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenScad
  - `false` - connect the ends of the circle
  - `0`     - to work on, ends not connected, no edges, standard
- `outer`
  - value `0`...`1`
    - `0` - edges on real circle line, standard like `circle()` in OpenScad
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle


### Superellipse [^][contents]
Generates a Superellipse curve.\
[=> Wikipedia - Superellipse](https://en.wikipedia.org/wiki/Superellipse)

Example of Piet Hein's Superegg:
```OpenSCAD
include <banded.scad>

$fn=60;

rotate_extrude ()
polygon (
	superellipse_curve (interval=[-90,90], n=2.5, a=[3,4]) );
```

#### `superellipse_point (t, r, a, n, s)` [^][contents]
Return a point from a superellipse curve

__Options:__
- `t`
  - position of the point from `0`...`360`
- `r`
  - radius
- `a`
  - controls the width ratio of the respective axes
    - as number = every axis gets the same factor
    - as list   = every axis gets his own factor `[X,Y]`
    - standard  = `[1,1]`
- `n`
  - order of the curve, controls the shape of the curve
    - as number = every axis gets the same parameter
    - as list   = every axis gets his own parameter `[X,Y]`
- `s`
  - parameter "superness", controls the shape of the curve, optional
  - If n is specified, s is ignored
    - as number = every axis gets the same parameter
    - as list   = every axis gets his own parameter `[X,Y]`

#### `superellipse_curve (interval, r, a, n, s, slices, piece)` [^][contents]
Return a list with the points of a superellipse

__Additional options:__
- `interval`
  - interval limit of `t`. `[begin, end]`
- `slices`
  - the curve is sliced in fragments into this number of points, at least 2 points
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenScad
  - `false` - connect the ends of the circle
  - `0`     - to work on, ends not connected, no edges, standard


### Superformula [^][contents]
Generates a Superformula curve.\
[=> Wikipedia - Superformula](https://en.wikipedia.org/wiki/Superformula)

#### `superformula_point (t, a, m, n)` [^][contents]
Return a point from a superformula curve

__Options:__
- `t`
  - position of the point (angle) from `0`...`360`
- `a`
  - controls the width ratio of the respective axes
  - as number = every axis gets the same factor
  - as list   = every axis gets his own factor `[X,Y]`
  - standard  = `[1,1]`
- `m`
  - symmetry
  - as number = every axis gets the same factor
  - as list   = every axis gets his own factor `[X,Y]`
  - standard  = `[1,1]`
- `n`
  - Curve, controls the curve form
  - list with 3 parameter `[n1, n2, n3]`

#### `superformula_curve (interval, a, m, n, slices, piece)` [^][contents]
Return a list with the points of a superformula

__Additional options:__
- `interval`
  - interval limit of `t`. `[begin, end]`
- `slices`
  - the curve is sliced in fragments into this number of points, at least 2 points
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenScad
  - `false` - connect the ends of the circle
  - `0`     - to work on, ends not connected, no edges, standard


### Polynomial function [^][contents]
`P(x) = a[0] + a[1]*x + a[2]*x^2 + ... + a[n]*x^n`\
[=> Wikipedia - Polynomial](https://en.wikipedia.org/wiki/Polynomial)

#### `polynomial (x, a, n)` [^][contents]
Return a numeric value from the polynomial function

__Options:__
- `x`
  - variable
- `a`
  - list with the coefficients
- `n`
  - Degree of the polynomial, only as many coefficients as specified are used
  - If not specified, the degree is taken according to the size of the array of coefficients

#### `polynomial_curve (interval, a, n, slices)` [^][contents]
Returns a list with the points of a polynomial interval

__Additional options:__
- `interval`
  - Interval limit from `x`. `[begin, end]`
- `slices`
  - Number of points in the interval


### Square [^][contents]

#### `square_curve (size, center)` [^][contents]
Return a 2D square as point list.
Options are like module `square()` from OpenScad.
Rotation is mathematical direction = counter clockwise.


### Helix [^][contents]
[=> Wikipedia - Helix](https://en.wikipedia.org/wiki/Helix)

#### `helix_curve (r, rotations, pitch, height, opposite, slices, angle)` [^][contents]
Return a helix as point list.

__Options:__
- `r`
  - radius as number oder as list with numbers `[r1, r2]`
  - `r1` = bottom radius, `r2` = top radius
- `rotations`
  - count of the rotations
- `angle`
  - count of the rotations as angle in degree
  - replaces `rotations` if set
- `pitch`
  - height difference per rotation
- `height`
  -  height of the helix
- `opposite`
  - if `true` the opposite direction of rotation is used
  - standard = `false`
- `slices`
  - count of segments per rotation
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken
  - With `"x"` includes the extra special variables to automatically control the count of segments

__Required options:__
- radius `r`
- only 2 arguments each: `pitch`, `rotations` or `height`


Transform functions [^][contents]
---------------------------------
Contains functions which transform point lists with affine transformations.\
[=> Wikipedia - Affine_transformation](https://en.wikipedia.org/wiki/Affine_transformation)

### Basic transformation [^][contents]
Works like transformation operator in OpenScad for object modules,
result is the same.

#### `translate_list (list, v)` [^][contents]
Translate every point in `list` at `v`.
Works like `translate()`.
- `v` - vector

#### `rotate_list (list, a, v)` [^][contents]
Rotate every point in `list`.
Works like `rotate()`.
- `a` - angle to rotate in degree
- `v` - vector where rotating around

#### `mirror_list (list, v)` [^][contents]
Mirror every point at origin along a vector `v` in a `list`.
Works like `mirror()`.
- `v` - mirror along this direction

#### `scale_list (list, v)` [^][contents]
Scale every point in `list` at given axis in vector `v`.
Works like `scale()`.

#### `resize_list (list, newsize)` [^][contents]
Resize and scale every point in `list` that it fits in `newsize`
Works like `resize()`.
- `newsize` - Vector with new size

#### `projection_list (list, plane)` [^][contents]
Get projection of every point in `list` to xy-plane.
- `cut`
  - get only the hull wich goes throw the xy-plane
  - **TODO** Not implemented jet
- `plane`
  - `true`  - make a 2D-list, standard
  - `false` - make a 3D-list, keep points on xy-plane

#### `multmatrix_list (list, m)` [^][contents]
Multiply every point in `list` with matrix `m`.
Works like `multmatrix()`.
 - m - 4x3 or 4x4 matrix


### More transformation [^][contents]

#### `rotate_backwards_list (list, a, v)` [^][contents]
Rotate backwards every point in `list`.
Options like `rotate()`.
- `a` - angle
- `v` - vector where rotating around

#### `rotate_at_list (list, a, p, v, backwards)` [^][contents]
Rotate every point in `list` at position `p`.
- `a` - angle
- `v` - vector where it rotates around
- `p` - position at where it rotates
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `rotate_backwards_at_list (list, a, p, v)` [^][contents]
Rotate backwards every point in `list` at position `p`.
- `a` - angle
- `v` - vector where it rotates around
- `p` - position at where it rotates

#### `rotate_to_vector_list (list, v, a, backwards)` [^][contents]
Rotate every point in `list` from direction Z axis to direction at vector `v`.
Rotate previous angle `a` around Z axis.
- `p` - direction as vector
- `a` - angle in degree
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `rotate_backwards_to_vector_list (list, v, a)` [^][contents]
Rotate backwards every point in `list` from direction Z axis to direction at vector `v`.
Rotate afterwards angle `a` around Z axis.
(makes `rotate_to_vector_list()` undone)
- `p` - direction as vector
- `a` - angle in degree

#### `rotate_to_vector_at_list (list, v, p, a, backwards)` [^][contents]
Rotate every point in `list` from direction Z axis to direction at vector `v`.
Rotate previous angle `a` around Z axis.
Rotate at vector `v`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `rotate_backwards_to_vector_at_list (list, v, p, a)` [^][contents]
Rotate backwards every point in `list` from direction Z axis to direction at vector `v`.
Rotate afterwards angle `a` around Z axis.
(makes `rotate_to_vector_at_list()` undone)
Rotate at vector `v`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree

#### `mirror_at_list (list, v, p)` [^][contents]
Mirror every point in `list` at origin along a vector `v` at position `p`.
- `p` - position at where it mirrors
- `v` - mirror along this direction


### Transformation at a fixed axis [^][contents]
Contains functions that define known functions on a fixed axis.\
Name convention: 'function operation name' + '_axis'\
Axis = x, y or z. later named as '?'


#### Basic transformation at fixed axis [^][contents]

| Base function      | with fixed axis               | description
|--------------------|-------------------------------|-------------
| `translate_list()` | `translate_?_list (list, l)`  | `l` - length to translate
| `translate_list()` | `translate_xy_list (list, t)` | `t` - 2D position at X and Y axis
| `rotate_list()`    | `rotate_?_list (list, a)`     | `a` - angle to rotate in degree
| `mirror_list()`    | `mirror_?_list (list)`        |
| `scale_list()`     | `scale_?_list (list, f)`      | `f` - scale factor as numeric value
| `resize_list()`    | `resize_?_list (list, l)`     | `l` - new size of axis


#### More at fixed axis [^][contents]

| Base function                | with fixed axis                           | description
|------------------------------|-------------------------------------------|-------------
| `rotate_backwards_list()`    | `rotate_backwards_?_list (list, a)`       | `a` - angle
| `rotate_at_list()`           | `rotate_at_?_list (list, a, p)`           | `a` - angle<br /> `p` - position
| `rotate_backwards_at_list()` | `rotate_backwards_at_?_list (list, a, p)` | `a` - angle<br /> `p` - position
| `mirror_at_list()`           | `mirror_at_?_list (list, p)`              | `p` - position


Multmatrix [^][contents]
------------------------
Returns matrices for use with `multmatrix()`.
These can linked with matrix multiplication.
```OpenScad
multmatrix( matrix_translate() * matrix_rotate() * matrix_scale() )
    object();

// same order as
translate() rotate() scale()
    object();
```
The functions of OpenSCAD modules for transformation are reproduced.\
[=> Wikipedia - Transformation matrix](https://en.wikipedia.org/wiki/Transformation_matrix)

### Basic multmatrix functions [^][contents]

#### `matrix_translate (v, d)` [^][contents]
Generate a matrix to translate at `v`.
- `v` - vector
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)

#### `matrix_rotate (a, v, d)` [^][contents]
Generate a matrix to rotate.
- `a` - angle
- `v` - vector where rotating around
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)

#### `matrix_mirror (v, d)` [^][contents]
Generate a matrix to mirror at origin along a vector `v`.
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)

#### `matrix_scale (v, d)` [^][contents]
Generate a matrix to scale to a given axis in vector `v`.
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)


### More multmatrix functions [^][contents]

#### `matrix_rotate_backwards (a, v, d)` [^][contents]
Generate a matrix to rotate backwards.
- `a` - angle
- `v` - vector where rotating around
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)

#### `matrix_rotate_at (a, p, v, d, backwards)` [^][contents]
Generate a matrix to rotate at position `p`.
- `a` - angle
- `v` - vector where it rotates around
- `p` - position at where it rotates
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `matrix_rotate_backwards_at (a, p, v, d)` [^][contents]
Generate a matrix to rotate backwards at position `p`.
- `a` - angle
- `v` - vector where it rotates around
- `p` - position at where it rotates
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)

#### `matrix_rotate_to_vector (v, a, backwards)` [^][contents]
Generate a matrix to rotate from direction Z axis to direction at vector `v`.
Rotate previous angle `a` around Z axis.
- `p` - direction as vector
- `a` - angle in degree
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `matrix_rotate_backwards_to_vector (v, a)` [^][contents]
Generate a matrix to rotate backwards from direction Z axis to direction at vector `v`.
Rotate previous angle `a` around Z axis.
- `p` - direction as vector
- `a` - angle in degree

#### `matrix_rotate_to_vector_at (v, p, a, backwards)` [^][contents]
Generate a matrix to rotate from direction Z axis to direction at vector `v`.
Rotate previous angle `a` around Z axis.
Rotate at vector `v`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `matrix_rotate_backwards_to_vector_at (v, p, a)` [^][contents]
Generate a matrix to rotate backwards from direction Z axis to direction at vector `v`.
Rotate afterwards angle `a` around Z axis.
(makes `matrix_rotate_to_vector_at()` undone)
Rotate at vector `v`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree

#### `matrix_mirror_at (v, p, d)` [^][contents]
Generate a matrix to  mirror at origin along a vector `v` at position `p`.
- `p` - position at where it mirrors
- `v` - mirror along this direction
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - standard
    - `2` - flat (2D)


### Multmatrix on a fixed axis [^][contents]
Contains functions that define known functions on a fixed axis.\
Name convention: 'function operation name' + '_axis'\
Axis = x, y or z. later named as '?'


#### Basic multmatrix at fixed axis [^][contents]
| Base function        | with fixed axis              | description
|----------------------|------------------------------|-------------
| `matrix_translate()` | `matrix_translate_?  (l, d)` | `l` - length to translate        <br> `d` - dimension
| .                    | `matrix_translate_z  (l)`    | only in 3 dimension
| .                    | `matrix_translate_xy (t, d)` | `t` - 2D position at X and Y axis<br> `d` - dimension
| `matrix_rotate()`    | `matrix_rotate_? (a, d)`     | `a` - angle to rotate in degree  <br> `d` - dimension
| `matrix_mirror()`    | `matrix_mirror_? (d)`        | `d` - dimension
| .                    | `matrix_mirror_z ()`         | only in 3 dimension
| `matrix_scale()`     | `matrix_scale_? (f, d)`      | `f` - scale factor               <br> `d` - dimension
| .                    | `matrix_scale_z (f)`         | only in 3 dimension


#### More multmatrix at fixed axis [^][contents]

| Base function                  | with fixed axis                          | description
|--------------------------------|------------------------------------------|-------------
| `matrix_rotate_backwards()`    | `matrix_rotate_backwards_? (a)`          | `a` - angle <br> only in 3 dimension
| .                              | `matrix_rotate_backwards_z (a, d)`       | `d` - dimension
| `matrix_rotate_at()`           | `matrix_rotate_at_?           (a, p)`    | `a` - angle <br> `p` - position <br> only in 3 dimension
| .                              | `matrix_rotate_at_z           (a, p, d)` | `d` - dimension
| `matrix_rotate_backwards_at()` | `matrix_rotate_backwards_at_? (a, p)`    | `a` - angle <br> `p` - position <br> only in 3 dimension
| .                              | `matrix_rotate_backwards_at_z (a, p, d)` | `d` - dimension
| `matrix_mirror_at()`           | `matrix_mirror_at_? (p, d)`              | `p` - position <br> `d` - dimension
| .                              | `matrix_mirror_at_z (p)`                 | only in 3 dimension

