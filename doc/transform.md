Draft objects as data list - Transform functions
================================================

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_transform.scad`\
` `| . . . . +--> `banded/draft_transform_basic.scad`\
` `| . . . . +--> `banded/draft_transform_common.scad`\
` `. . .

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Transform functions on point list](#transform-functions-on-point-lists-)
  - [Basic transformation](#basic-transformation-)
    - [`translate_points()`][translate_points]
    - [`rotate_points()`][rotate_points]
    - [`mirror_points()`][mirror_points]
    - [`scale_points()`][scale_points]
    - [`resize_points()`][resize_points]
    - [`projection_points()`][projection_points]
    - [`multmatrix_points()`][multmatrix_points]
  - [More transformation](#more-transformation-)
    - [`rotate_backwards_points()`][rotate_backwards_points]
    - [`rotate_at_points()`][rotate_at_points]
    - [`rotate_to_vector_points()`][rotate_to_vector_points]
    - [`rotate_to_vector_at_points()`][rotate_to_vector_at_points]
    - [`mirror_at_points()`][mirror_at_points]
    - [`skew_points()`][skew_points]
    - [`skew_at_points()`][skew_at_points]
  - [Transformation with preset defaults](#transformation-with-preset-defaults-)
    - [Transformation function backwards](#transformation-function-backwards-)
    - [Transformation at a fixed axis](#transformation-at-a-fixed-axis-)


Transform functions on point lists [^][contents]
------------------------------------------------

Contains functions which transform point lists with affine transformations.\
[=> Wikipedia - Affine_transformation](https://en.wikipedia.org/wiki/Affine_transformation)

### Basic transformation [^][contents]
Works like transformation operator in OpenSCAD for object modules,
result is the same.

#### `translate_points (list, v)` [^][contents]
[translate_points]: #translate_points-list-v- "translate_points (list, v)"
Translate every point in `list` at `v`.
Works like `translate()`.
- `v` - vector

#### `rotate_points (list, a, v, backwards)` [^][contents]
[rotate_points]: #rotate_points-list-a-v-backwards- "rotate_points (list, a, v, backwards)"
Rotate every point in `list`.
Works like `rotate()`.
- `a` - angle to rotate in degree
- `v` - vector where rotating around
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `mirror_points (list, v)` [^][contents]
[mirror_points]: #mirror_points-list-v- "mirror_points (list, v)"
Mirror every point at origin along a vector `v` in a `list`.
Works like `mirror()`.
- `v` - mirror along this direction, default = X axis

#### `scale_points (list, v)` [^][contents]
[scale_points]: #scale_points-list-v- "scale_points (list, v)"
Scale every point in `list` at given axis in vector `v`.
Works like `scale()`.
- `v` - vector with scale factor for each axis

#### `resize_points (list, newsize)` [^][contents]
[resize_points]: #resize_points-list-newsize- "resize_points (list, newsize)"
Resize and scale every point in `list` that it fits in `newsize`
Works like `resize()`.
- `newsize` - Vector with new size

#### `projection_points (list, plane)` [^][contents]
[projection_points]: #projection_points-list-plane- "projection_points (list, plane)"
Get projection of every point in `list` to xy-plane.
- `plane`
  - `true`  - make a 2D-list, default
  - `false` - make a 3D-list, keep points on xy-plane

#### `multmatrix_points (list, m)` [^][contents]
[multmatrix_points]: #multmatrix_points-list-m- "multmatrix_points (list, m)"
Multiply every point in `list` with matrix `m`.
Works like `multmatrix()`.
- `m`
  - 3D: 4x3 or 4x4 matrix
  - 2D: 3x2 or 3x3 matrix

#### `multmatrix_xx_point (p, m)` [^][contents]
[multmatrix_xx_point]: multmatrix_xx_point-p-m- "multmatrix_xx_point (p, m)"
Multiply one point in `p` with matrix `m`.
```OpenSCAD
multmatrix_2D_point()  // 2D version
multmatrix_3D_point()  // 3D version
```
- `m`
  - 3D: 4x4 matrix
  - 2D: 3x3 matrix


### More transformation [^][contents]

#### `rotate_backwards_points (list, a, v)` [^][contents]
[rotate_backwards_points]: #rotate_backwards_points-list-a-v-
Rotate backwards every point in `list`.
Options like `rotate()`.
- `a` - angle
- `v` - vector where rotating around

#### `rotate_at_points (list, a, p, v, backwards)` [^][contents]
[rotate_at_points]: #rotate_at_points-list-a-p-v-backwards-
Rotate every point in `list` at position `p`.
- `a` - angle
- `v` - vector where it rotates around
- `p` - origin position at where it rotates
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `rotate_to_vector_points (list, v, a, backwards)` [^][contents]
[rotate_to_vector_points]: #rotate_to_vector_points-list-v-a-backwards-
Rotate every point in `list` from direction Z axis to direction at vector `v`.
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

___way of working in 3D:___
- procedure 1, `a` as angle:
  - vector `v` will split in
    - inclination angle, rotate around Y axis
    - and azimuthal angle, rotate around Z axis
  - make rotation around Y axis with inclination angle
  - make rotation around Z axis with azimuthal angle
  - make rotation around vector `v` with angle `a`

- procedure 2, `a` as orientation vector:
  - make rotation from Z axis to vector `v`
  - make rotation around vector `v`, so that the originally X axis point to
    orientation vector `a`

___way of working in 2D:___
- rotate the object from direction X axis to vector `v`
- option `a` will be ignored

#### `rotate_to_vector_at_points (list, v, p, a, backwards)` [^][contents]
[rotate_to_vector_at_points]: #rotate_to_vector_at_points-list-v-p-a-backwards-
Rotate every point in `list` from direction Z axis to direction at vector `v`.
Rotate origin at vector `v`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `mirror_at_points (list, v, p)` [^][contents]
[mirror_at_points]: #mirror_at_points-list-v-p-
Mirror every point in `list` along a vector `v` at origin position `p`.
- `p` - origin position at where it mirrors
- `v` - mirror along this direction, default = X axis

#### `skew_points (list, v, t, m, a)` [^][contents]
[skew_points]: #skew_points-list-v-t-m-a-
skew an object in a list.\
default for 3D = shear X along Z\
default for 2D = shear X along Y
- `v` - vector, shear parallel to this axis
  - 3D:
    - as vector
    - default = Z axis
  - 2D:
    - as vector
    - or as angle in degree
    - same operation like [`rotate_to_vector()`][rotate_to_vector_points]
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

#### `skew_at_points (list, v, t, m, a, p)` [^][contents]
[skew_at_points]: #skew_at_points-list-v-t-m-a-p-
skew an object in a list at position `p`.\
see [`skew_points()`][skew_points]
- `p` - origin position at where it skews


### Transformation with preset defaults [^][contents]

#### Transformation function backwards [^][contents]
Contains functions that define known functions with operation backwards.\
Option `backwards` is removed and internally set to `true`.
Name convention: 'base operation' + '_backwards' + 'additional operations'\

| Base function                                                | operation backwards
|--------------------------------------------------------------|---------------------
| [`rotate_points()`][rotate_points]                           | [`rotate_backwards_points (list, a, v, d)`][rotate_backwards_points]
| [`rotate_at_points()`][rotate_at_points]                     | `rotate_backwards_at_points (list, a, p, v, d)`
| [`rotate_to_vector_points()`][rotate_to_vector_points]       | `rotate_backwards_to_vector_points (list, v, a)`
| [`rotate_to_vector_at_points()`][rotate_to_vector_at_points] | `rotate_backwards_to_vector_at_points (list, v, p, a)`

#### Transformation at a fixed axis [^][contents]
Contains functions that define known functions on a fixed axis.\
Name convention: 'function operation name' + '_axis'\
Axis = x, y or z. later named as '?'

##### Basic transformation at fixed axis [^][contents]
| Base function                            | with fixed axis                        | description
|------------------------------------------|----------------------------------------|-------------
| [`translate_points()`][translate_points] | `translate_?_points (list, l)`         | `l` - length to translate
| .                                        | `translate_xy_points (list, t)`        | `t` - 2D position at X and Y axis
| [`rotate_points()`][rotate_points]       | `rotate_?_points (list, a, backwards)` | `a` - angle to rotate in degree
| .                                        |                                        | `backwards` - set `true` to rotate backwards, default = `false`
| [`mirror_points()`][mirror_points]       | `mirror_?_points (list)`               |
| [`scale_points()`][scale_points]         | `scale_?_points (list, f)`             | `f` - scale factor as numeric value
| [`resize_points()`][resize_points]       | `resize_?_points (list, l)`            | `l` - new size of axis

##### More at fixed axis [^][contents]
| Base function                                          | with fixed axis                             | description
|--------------------------------------------------------|---------------------------------------------|-------------
| [`rotate_backwards_points()`][rotate_backwards_points] | `rotate_backwards_?_points (list, a)`       | `a` - angle
| [`rotate_at_points()`][rotate_at_points]               | `rotate_at_?_points (list, a, p)`           | `a` - angle<br /> `p` - position
| `rotate_backwards_at_points()`                         | `rotate_backwards_at_?_points (list, a, p)` | `a` - angle<br /> `p` - position
| [`mirror_at_points()`][mirror_at_points]               | `mirror_at_?_points (list, p)`              | `p` - position

