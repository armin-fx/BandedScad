Draft objects as data list - Multmatrix
=======================================

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_multmatrix.scad`\
` `| . . . . +--> `banded/draft_multmatrix_basic.scad`\
` `| . . . . +--> `banded/draft_multmatrix_common.scad`\
` `. . .

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Curves in a point list ->][curves]
- [Transform functions on point list ->][transform]
- [Convert colors ->][color]
- [Primitives in data lists ->][primitives]

- [Multmatrix][multmatrix]
  - [Basic multmatrix functions](#basic-multmatrix-functions-)
    - [`matrix_translate()`][matrix_translate]
    - [`matrix_rotate()`][matrix_rotate]
    - [`matrix_mirror()`][matrix_mirror]
    - [`matrix_scale()`][matrix_scale]
    - [`matrix_projection()`][matrix_projection]
  - [More multmatrix functions](#more-multmatrix-functions-)
    - [`matrix_rotate_backwards()`][matrix_rotate_backwards]
    - [`matrix_rotate_at()`][matrix_rotate_at]
    - [`matrix_rotate_to_vector()`][matrix_rotate_to_vector]
    - [`matrix_rotate_to_vector_at()`][matrix_rotate_to_vector_at]
    - [`matrix_mirror_at()`][matrix_mirror_at]
    - [`matrix_skew()`][matrix_skew]
    - [`matrix_skew_at()`][matrix_skew_at]
  - [Multmatrix with preset defaults](#multmatrix-with-preset-defaults-)
    - [Multmatrix function backwards](#multmatrix-function-backwards-)
    - [Multmatrix on a fixed axis](#multmatrix-on-a-fixed-axis-)

[curves]:     curves.md
[transform]:  transform.md
[multmatrix]: #multmatrix-
[color]:      color.md
[primitives]: primitives.md


Multmatrix [^][contents]
------------------------
Returns matrices for use with `multmatrix()`.
These can linked with matrix multiplication.
```OpenSCAD
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
[matrix_translate]: #matrix_translate-v-d-
Generate a matrix to translate to `v`.
- `v` - vector
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### `matrix_rotate (a, v, backwards, d)` [^][contents]
[matrix_rotate]: #matrix_rotate-a-v-backwards-d-
Generate a matrix to rotate.
- `a` - angle
- `v` - vector where rotating around
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### `matrix_mirror (v, d)` [^][contents]
[matrix_mirror]: #matrix_mirror-v-d-
Generate a matrix to mirror at origin along a vector `v`.
- `v` - mirror along this direction, default = X axis
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### `matrix_scale (v, d)` [^][contents]
[matrix_scale]: #matrix_scale-v-d-
Generate a matrix to scale to a given axis in vector `v`.
- `v` - vector with scale factor for each axis
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### `matrix_projection (v, d)` [^][contents]
[matrix_projection]: #matrix_projection-v-d-
Generate a matrix to get a projection on a plane (3D) or on a line (2D)
which crosses origin.
- `v` - normal vector of the plane (3D) or the line (2D)
  - 2D-default = X-axis
  - 3D-default = Z-axis
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)


### More multmatrix functions [^][contents]

#### `matrix_rotate_backwards (a, v, d)` [^][contents]
[matrix_rotate_backwards]: #matrix_rotate_backwards-a-v-d-
Generate a matrix to rotate backwards.
- `a` - angle
- `v` - vector where it rotating around
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### `matrix_rotate_at (a, p, v, backwards, d)` [^][contents]
[matrix_rotate_at]: #matrix_rotate_at-a-p-v-backwards-d-
Generate a matrix to rotate at position `p`.
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

#### `matrix_rotate_to_vector (v, a, backwards)` [^][contents]
[matrix_rotate_to_vector]: #matrix_rotate_to_vector-v-a-backwards-
Generate a matrix to rotate from direction Z axis to direction at vector `v`.
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

procedure 1, `a` as angle:
- vector `v` will split in
  - inclination angle, rotate around Y axis
  - and azimuthal angle, rotate around Z axis
- make rotation around Y axis with inclination angle
- make rotation around Z axis with azimuthal angle
- make rotation around vector `v` with angle `a`

procedure 2, `a` as orientation vector:
- make rotation from Z axis to vector `v`
- make rotation around vector `v`, so that the originally X axis point to
  orientation vector `a`

#### `matrix_rotate_to_vector_at (v, p, a, backwards)` [^][contents]
[matrix_rotate_to_vector_at]: #matrix_rotate_to_vector_at-v-p-a-backwards-
Generate a matrix to rotate from direction Z axis to direction at vector `v`.
Rotate origin at vector `p`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `matrix_mirror_at (v, p, d)` [^][contents]
[matrix_mirror_at]: #matrix_mirror_at-v-p-d-
Generate a matrix to mirror along a vector `v` at origin position `p`.
- `v` - mirror along this direction, default = X axis
- `p` - origin position at where it mirrors
- `d`
  - dimensions of vector which will transformed with matrix
    - `3` - spatial (3D) - default
    - `2` - flat (2D)

#### `matrix_skew (v, t, m, a, d)` [^][contents]
[matrix_skew]: #matrix_skew-v-t-m-a-d-
Generate a matrix to skew an object.\
default for 3D = shear X along Z\
default for 2D = shear X along Y
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

#### `matrix_skew_at (v, t, m, a, p, d)` [^][contents]
[matrix_skew_at]: #matrix_skew_at-v-t-m-a-p-d-
Generate a matrix to skew an object at position `p`.\
see [`matrix_skew()`][matrix_skew]
- `p` - origin position at where it skews


### Multmatrix with preset defaults [^][contents]

#### Multmatrix function backwards [^][contents]
Contains functions that define known functions with operation backwards.\
Option `backwards` is removed and internally set to `true`.
Name convention: 'base operation' + '_backwards' + 'additional operations'\

| Base function                                                | operation backwards
|--------------------------------------------------------------|---------------------
| [`matrix_rotate()`][matrix_rotate]                           | [`matrix_rotate_backwards (a, v, d)`][matrix_rotate_backwards]
| [`matrix_rotate_at()`][matrix_rotate_at]                     | `matrix_rotate_backwards_at (a, p, v, d)`
| [`matrix_rotate_to_vector()`][matrix_rotate_to_vector]       | `matrix_rotate_backwards_to_vector (v, a)`
| [`matrix_rotate_to_vector_at()`][matrix_rotate_to_vector_at] | `matrix_rotate_backwards_to_vector_at (v, p, a)`

#### Multmatrix on a fixed axis [^][contents]
Contains functions that define known functions on a fixed axis.\
Name convention: 'function operation name' + '_axis'\
Axis = x, y or z. later named as '?'

##### Basic multmatrix at fixed axis [^][contents]
| Base function                              | with fixed axis              | description
|--------------------------------------------|------------------------------|-------------
| [`matrix_translate()`][matrix_translate]   | `matrix_translate_?  (l, d)` | `l` - length to translate        <br> `d` - dimension
| .                                          | `matrix_translate_z  (l)`    | only in 3 dimension
| .                                          | `matrix_translate_xy (t, d)` | `t` - 2D position at X and Y axis<br> `d` - dimension
| [`matrix_rotate()`][matrix_rotate]         | `matrix_rotate_? (a, d)`     | `a` - angle to rotate in degree  <br> `d` - dimension
| [`matrix_mirror()`][matrix_mirror]         | `matrix_mirror_? (d)`        | `d` - dimension
| .                                          | `matrix_mirror_z ()`         | only in 3 dimension
| [`matrix_scale()`][matrix_scale]           | `matrix_scale_? (f, d)`      | `f` - scale factor               <br> `d` - dimension
| .                                          | `matrix_scale_z (f)`         | only in 3 dimension
| [`matrix_projection()`][matrix_projection] | `matrix_projection_? (d)`    | `d` - dimension
| .                                          | `matrix_projection_z (d)`    | only in 3 dimension

##### More multmatrix at fixed axis [^][contents]
| Base function                            | with fixed axis                          | description
|------------------------------------------|------------------------------------------|-------------
| `matrix_rotate_backwards()`              | `matrix_rotate_backwards_? (a)`          | `a` - angle <br> only in 3 dimension
| .                                        | `matrix_rotate_backwards_z (a, d)`       | `d` - dimension
| [`matrix_rotate_at()`][matrix_rotate_at] | `matrix_rotate_at_?           (a, p)`    | `a` - angle <br> `p` - position <br> only in 3 dimension
| .                                        | `matrix_rotate_at_z           (a, p, d)` | `d` - dimension
| `matrix_rotate_backwards_at()`           | `matrix_rotate_backwards_at_? (a, p)`    | `a` - angle <br> `p` - position <br> only in 3 dimension
| .                                        | `matrix_rotate_backwards_at_z (a, p, d)` | `d` - dimension
| [`matrix_mirror_at()`][matrix_mirror_at] | `matrix_mirror_at_? (p, d)`              | `p` - position <br> `d` - dimension
| .                                        | `matrix_mirror_at_z (p)`                 | only in 3 dimension
