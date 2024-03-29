Draft objects as data list - Generate matrix
============================================

### defined in file
`banded/draft.scad`  
` `|  
` `+--> `banded/draft_matrix.scad`  
` `| . . . . +--> `banded/draft_matrix_basic.scad`  
` `| . . . . +--> `banded/draft_matrix_common.scad`  
` `. . .  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Generate matrices](#generate-matrices-)
  - [Parameter `short`, size of the matrix][short]
  - [Basic functions to generate a matrix](#basic-functions-to-generate-a-matrix-)
    - [`matrix_translate()`][matrix_translate]
    - [`matrix_rotate()`][matrix_rotate]
    - [`matrix_mirror()`][matrix_mirror]
    - [`matrix_scale()`][matrix_scale]
    - [`matrix_projection()`][matrix_projection]
  - [More functions to generate a matrix](#more-functions-to-generate-a-matrix-)
    - [`matrix_rotate_backwards()`][matrix_rotate_backwards]
    - [`matrix_rotate_at()`][matrix_rotate_at]
    - [`matrix_rotate_to_vector()`][matrix_rotate_to_vector]
    - [`matrix_rotate_to_vector_at()`][matrix_rotate_to_vector_at]
    - [`matrix_mirror_at()`][matrix_mirror_at]
    - [`matrix_skew()`][matrix_skew]
    - [`matrix_skew_at()`][matrix_skew_at]
  - [Generate matrix with preset defaults](#generate-matrix-with-preset-defaults-)
    - [Transform backwards](#transform-backwards-)
    - [Transform on a fixed axis](#transform-on-a-fixed-axis-)


Generate matrices [^][contents]
-------------------------------
Returns matrices for use with `multmatrix()`.  
These can linked with matrix multiplication.
```OpenSCAD
multmatrix( matrix_translate() * matrix_rotate() * matrix_scale() )
    object();

// same order as
translate() rotate() scale()
    object();
```
The functions of OpenSCAD modules for transformation are reproduced.  
[=> Wikipedia - Transformation matrix](https://en.wikipedia.org/wiki/Transformation_matrix)

#### Parameter `short`, size of the matrix [^][contents]
[short]: #parameter-short-size-of-the-matrix-

Some functions can generate a "short" matrix.  
They have the same n×n size like a n-dimensional point and
can directly multiplicated in OpenSCAD to get the transformed point.
E.g. `matrix * point`
Calculations are twice as fast, but they can only generate transformations around origin.

You can:
- rotate
- mirror
- scale
- scew

You can _not_:
- translate
  - inclusive all matrix functions with name endings `_at`

If you want to mix with translate transformation,
you must use the default matrix with size n+1.
Matrices with different size can not mixed.  
The size of a short n×n matrix can pushed up to default size n+1 with:
```OpenSCAD
m = repair_matrix (m_short, n + 1);
```


### Basic functions to generate a matrix [^][contents]

#### matrix_translate [^][contents]
[matrix_translate]: #matrix_translate-
Generate a matrix to translate along a vector.

_Arguments:_
```OpenSCAD
matrix_translate (v, d)
```
- `v` - vector
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default, result is a 4×4 matrix
    - `2` - flat (2D), result is a 3×3 matrix

#### matrix_rotate [^][contents]
[matrix_rotate]: #matrix_rotate-
Generate a matrix to rotate.

_Arguments:_
```OpenSCAD
matrix_rotate (a, v, backwards, d, short)
```
- `a` - angle parameter
  - as number: angle to rotate in degrees around an axis, defined in vector `v`
  - as list of 3 angles around a fixed axis `[X,Y,Z]`:
    The rotation is applied in the following order: X then Y then Z.
    Then the argument `v` is ignored.
- `v` - vector where rotating around, default = Z axis
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix

#### matrix_mirror [^][contents]
[matrix_mirror]: #matrix_mirror-
Generate a matrix to mirror at origin along a vector.

_Arguments:_
```OpenSCAD
matrix_mirror (v, d, short)`
```
- `v` - mirror along this direction, default = X axis
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix

#### matrix_scale [^][contents]
[matrix_scale]: #matrix_scale-
Generate a matrix to scale to a given axis in vector.

_Arguments:_
```OpenSCAD
matrix_scale (v, d, short)
```
- `v` - vector with scale factor for each axis
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix

#### matrix_projection [^][contents]
[matrix_projection]: #matrix_projection-
Generate a matrix to get a projection on a plane (3D) or on a line (2D)
which crosses origin.

_Arguments:_
```OpenSCAD
matrix_projection (v, d, short)
```
- `v` - normal vector of the plane (3D) or the line (2D)
  - 2D-default = X-axis
  - 3D-default = Z-axis
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix


### More functions to generate a matrix [^][contents]

#### matrix_rotate_backwards [^][contents]
[matrix_rotate_backwards]: #matrix_rotate_backwards-
Generate a matrix to rotate backwards.

_Arguments:_
```OpenSCAD
matrix_rotate_backwards (a, v, d, short)
```
- `a` - angle
- `v` - vector where it rotating around
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix

#### matrix_rotate_at [^][contents]
[matrix_rotate_at]: #matrix_rotate_at-
Generate a matrix to rotate at specific origin position.

_Arguments:_
```OpenSCAD
matrix_rotate_at (a, p, v, backwards, d)
```
- `a` - angle
- `v` - vector where it rotates around
- `p` - origin position at where it rotates
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### matrix_rotate_to_vector [^][contents]
[matrix_rotate_to_vector]: #matrix_rotate_to_vector-
Generate a matrix to rotate from direction Z axis to direction as vector.

_Arguments:_
```OpenSCAD
matrix_rotate_to_vector (v, a, backwards, d, short)
```
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
  - only needed for 3D
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix

procedure 1 (3D), `a` as angle:
- vector `v` will split in
  - inclination angle, rotate around Y axis
  - and azimuthal angle, rotate around Z axis
- make rotation around Y axis with inclination angle
- make rotation around Z axis with azimuthal angle
- make rotation around vector `v` with angle `a`

procedure 2 (3D), `a` as orientation vector:
- make rotation from Z axis to vector `v`
- make rotation around vector `v`, so that the originally X axis point to
  orientation vector `a`

#### matrix_rotate_to_vector_at [^][contents]
[matrix_rotate_to_vector_at]: #matrix_rotate_to_vector_at-
Generate a matrix to rotate from direction Z axis to direction as vector.  
Rotate at a specific origin position.

_Arguments:_
```OpenSCAD
matrix_rotate_to_vector_at (v, p, a, backwards, d)
```
- `v` - direction as vector
- `p` - origin position at where it rotates
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### matrix_mirror_at [^][contents]
[matrix_mirror_at]: #matrix_mirror_at-
Generate a matrix to mirror along a vector at specific origin position.

_Arguments:_
```OpenSCAD
matrix_mirror_at (v, p, d)
```
- `v` - mirror along this direction, default = X axis
- `p` - origin position at where it mirrors
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### matrix_skew [^][contents]
[matrix_skew]: #matrix_skew-
Generate a matrix to skew an object.
- default for 3D = shear X along Z
- default for 2D = shear X along Y

_Arguments:_
```OpenSCAD
matrix_skew (v, t, m, a, d, short)
```
- `v` - vector, shear parallel to this axis
  - 3D:
    - as vector
    - default = Z axis
  - 2D:
    - as vector
    - or as angle in degree
    - same operation like rotate_to_vector()
    - default = Y axis
- `t` - target vector, shear direction to this vector
  - 3D:
    - as vector
    - as angle in degree
    - default = X axis
  - 2D:
    - not needed, undefined
- `m` - skew factor, default = 0
- `a` - angle in degree inside (-90 ... 90), alternative to 'm'
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)
- [`short`][short]
  - `false` = default, size of matrix = `d` + 1
  - `true`  = short d×d matrix

#### matrix_skew_at [^][contents]
[matrix_skew_at]: #matrix_skew_at-
Generate a matrix to skew an object at specific origin position.

_Arguments:_
```OpenSCAD
matrix_skew_at (v, t, m, a, p, d)
```
see [`matrix_skew()`][matrix_skew]
- `p` - origin position at where it skews


### Generate matrix with preset defaults [^][contents]

#### Transform backwards: [^][contents]
Contains functions that define known functions with operation backwards.  
Option `backwards` is removed and internally set to `true`.  
Name convention: 'base operation' + '_backwards' + 'additional operations'

| Base function                                                | operation backwards
|--------------------------------------------------------------|---------------------
| [`matrix_rotate()`][matrix_rotate]                           | [`matrix_rotate_backwards (a, v, d, short)`][matrix_rotate_backwards]
| [`matrix_rotate_at()`][matrix_rotate_at]                     | `matrix_rotate_backwards_at (a, p, v, d)`
| [`matrix_rotate_to_vector()`][matrix_rotate_to_vector]       | `matrix_rotate_backwards_to_vector (v, a, short)`
| [`matrix_rotate_to_vector_at()`][matrix_rotate_to_vector_at] | `matrix_rotate_backwards_to_vector_at (v, p, a)`

#### Transform on a fixed axis: [^][contents]
Contains functions that define known functions on a fixed axis.  
Name convention: 'function operation name' + '_axis'  
Axis = x, y or z. later named as '?'

##### Basic at fixed axis: [^][contents]
| Base function                              | with fixed axis                  | description
|--------------------------------------------|----------------------------------|-------------
| [`matrix_translate()`][matrix_translate]   | `matrix_translate_?  (l, d)`     | `l` - length to translate        <br> `d` - dimension
| .                                          | `matrix_translate_z  (l)`        | only in 3 dimension
| .                                          | `matrix_translate_xy (t, d)`     | `t` - 2D position at X and Y axis<br> `d` - dimension
| [`matrix_rotate()`][matrix_rotate]         | `matrix_rotate_? (a, d, short)`  | `a` - angle to rotate in degree  <br> `d` - dimension
| [`matrix_mirror()`][matrix_mirror]         | `matrix_mirror_? (d, short)`     | `d` - dimension
| .                                          | `matrix_mirror_z (short)`        | only in 3 dimension
| [`matrix_scale()`][matrix_scale]           | `matrix_scale_? (f, d, short)`   | `f` - scale factor               <br> `d` - dimension
| .                                          | `matrix_scale_z (f, short)`      | only in 3 dimension
| [`matrix_projection()`][matrix_projection] | `matrix_projection_? (d, short)` | `d` - dimension
| .                                          | `matrix_projection_z (d, short)` | only in 3 dimension

##### More matrix at fixed axis: [^][contents]
| Base function                            | with fixed axis                           | description
|------------------------------------------|-------------------------------------------|-------------
| `matrix_rotate_backwards()`              | `matrix_rotate_backwards_? (a, short)`    | `a` - angle <br> only in 3 dimension
| .                                        | `matrix_rotate_backwards_z (a, d, short)` | `d` - dimension
| [`matrix_rotate_at()`][matrix_rotate_at] | `matrix_rotate_at_?           (a, p)`     | `a` - angle <br> `p` - position <br> only in 3 dimension
| .                                        | `matrix_rotate_at_z           (a, p, d)`  | `d` - dimension
| `matrix_rotate_backwards_at()`           | `matrix_rotate_backwards_at_? (a, p)`     | `a` - angle <br> `p` - position <br> only in 3 dimension
| .                                        | `matrix_rotate_backwards_at_z (a, p, d)`  | `d` - dimension
| [`matrix_mirror_at()`][matrix_mirror_at] | `matrix_mirror_at_? (p, d)`               | `p` - position <br> `d` - dimension
| .                                        | `matrix_mirror_at_z (p)`                  | only in 3 dimension

