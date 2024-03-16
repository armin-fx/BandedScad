Draft objects as data list - Transform functions
================================================

### defined in file
`banded/draft.scad`  
` `|  
` `+--> `banded/draft_transform.scad`  
` `| . . . . +--> `banded/draft_transform_basic.scad`  
` `| . . . . +--> `banded/draft_transform_common.scad`  
` `. . .  

[<-- file overview](file_overview.md)  
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

Contains functions which transform point lists with affine transformations.  
[=> Wikipedia - Affine_transformation](https://en.wikipedia.org/wiki/Affine_transformation)


### Basic transformation [^][contents]
Works like transformation operator in OpenSCAD for object modules,
result is the same.

#### translate_points [^][contents]
[translate_points]: #translate_points-
Translate every point in a list along a vector.  
Works like `translate()`.

_Arguments:_
```OpenSCAD
translate_points (list, v)
```
- `v` - vector

_Operation for one point:_  
`translate_point (p, v)`
- `p` - point

#### rotate_points [^][contents]
[rotate_points]: #rotate_points-
Rotate every point in a list.  
Works like `rotate()`.

_Arguments:_
```OpenSCAD
rotate_points (list, a, v, backwards)
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

_Operation for one point:_  
`rotate_point (p, a, v, backwards)`
- `p` - point

#### mirror_points [^][contents]
[mirror_points]: #mirror_points-
Mirror every point at origin along a vector in a list.  
Works like `mirror()`.

_Arguments:_
```OpenSCAD
mirror_points (list, v)
```
- `v` - mirror along this direction, default = X axis

_Operation for one point:_  
`mirror_point (p, v)`
- `p` - point

#### scale_points [^][contents]
[scale_points]: #scale_points-
Scale every point in a list at given axis.  
Works like `scale()`.

_Arguments:_
```OpenSCAD
scale_points (list, v)
```
- `v` - vector with scale factor for each axis

_Operation for one point:_  
`scale_point (p, v)`
- `p` - point

#### resize_points [^][contents]
[resize_points]: #resize_points-
Resize and scale every point in a list that it fits in `newsize`.  
Works like `resize()`.

_Arguments:_
```OpenSCAD
resize_points (list, newsize)
```
- `newsize` - vector with new size

#### projection_points [^][contents]
[projection_points]: #projection_points-
Get projection of every point in a list to the XY-plane.

_Arguments:_
```OpenSCAD
projection_points (list, plane)
```
- `plane`
  - `true`  - make a 2D-list, default
  - `false` - make a 3D-list, keep points on xy-plane
  - number  - make a 3D-list, set Z-axis to this height

_Operation for one point:_  
`projection_point (p, plane)`
- `p` - point

#### multmatrix_points [^][contents]
[multmatrix_points]: #multmatrix_points-
Multiply every point in a list with a matrix.  
Works like `multmatrix()`.

_Arguments:_
```OpenSCAD
multmatrix_points (list, m)
```
- `m`
  - 3D: 4x3 or 4x4 matrix (or 3x3)
  - 2D: 3x2 or 3x3 matrix (or 2x2)

_Operation for one point:_
```OpenSCAD
multmatrix_point   (p, m)  // common version
multmatrix_2D_point(p, m)  // 2D version
multmatrix_3D_point(p, m)  // 3D version
```
- `p` - point
- `m`
  - 3D: must be 4x4 or 3x3 matrix
  - 2D: must be 3x3 or 2x2 matrix


### More transformation [^][contents]

#### rotate_backwards_points [^][contents]
[rotate_backwards_points]: #rotate_backwards_points-
Rotate backwards every point in a list.  
Options like `rotate()`.

_Arguments:_
```OpenSCAD
rotate_backwards_points (list, a, v)
```
- `a` - angle
- `v` - vector where rotating around

#### rotate_at_points [^][contents]
[rotate_at_points]: #rotate_at_points-
Rotate every point in `list` at position `p`.

_Arguments:_
```OpenSCAD
rotate_at_points (list, a, p, v, backwards)
```
- `a` - angle
- `v` - vector where it rotates around
- `p` - origin position at where it rotates, default = `[0,0,0]`
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### rotate_to_vector_points [^][contents]
[rotate_to_vector_points]: #rotate_to_vector_points-
Rotate every point in a list from direction Z axis to direction as vector.

_Arguments:_
```OpenSCAD
rotate_to_vector_points (list, v, a, backwards)
```
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

_Way of working in 3D:_
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

_Way of working in 2D:_
- rotate the object from direction X axis to vector `v`
- option `a` will be ignored

#### rotate_to_vector_at_points [^][contents]
[rotate_to_vector_at_points]: #rotate_to_vector_at_points-
Rotate every point in a list from direction Z axis to direction as vector.  
Rotate at specific origin position.

_Arguments:_
```OpenSCAD
rotate_to_vector_at_points (list, v, p, a, backwards)
```
- `v` - vector where it rotates around
- `p` - origin point, default = `[0,0,0]`
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### mirror_at_points [^][contents]
[mirror_at_points]: #mirror_at_points-
Mirror every point in a list along a vector at specific origin position.

_Arguments:_
```OpenSCAD
mirror_at_points (list, v, p)
```
- `p` - origin position at where it mirrors, default = `[0,0,0]`
- `v` - mirror along this direction, default = X axis

#### skew_points [^][contents]
[skew_points]: #skew_points-
skew an object in a list.  
- default for 3D = shear X along Z
- default for 2D = shear X along Y

_Arguments:_
```OpenSCAD
skew_points (list, v, t, m, a)
```
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

#### skew_at_points [^][contents]
[skew_at_points]: #skew_at_points-
skew an object in a list at position `p`.

_Arguments:_
```OpenSCAD
skew_at_points (list, v, t, m, a, p)
```
see [`skew_points()`][skew_points]
- `p` - origin position at where it skews, default = `[0,0,0]`


### Transformation with preset defaults [^][contents]

#### Transformation function backwards: [^][contents]
Contains functions that define known functions with operation backwards.  
Option `backwards` is removed and internally set to `true`.
Name convention: 'base operation' + '_backwards' + 'additional operations'  

| Base function                                                | operation backwards
|--------------------------------------------------------------|---------------------
| [`rotate_points()`][rotate_points]                           | [`rotate_backwards_points (list, a, v, d)`][rotate_backwards_points]
| [`rotate_at_points()`][rotate_at_points]                     | `rotate_backwards_at_points (list, a, p, v, d)`
| [`rotate_to_vector_points()`][rotate_to_vector_points]       | `rotate_backwards_to_vector_points (list, v, a)`
| [`rotate_to_vector_at_points()`][rotate_to_vector_at_points] | `rotate_backwards_to_vector_at_points (list, v, p, a)`

#### Transformation at a fixed axis: [^][contents]
Contains functions that define known functions on a fixed axis.  
Name convention: 'function operation name' + '_axis' 
Axis = x, y or z. later named as '?'

##### Basic transformation at fixed axis: [^][contents]
| Base function                            | with fixed axis                        | description
|------------------------------------------|----------------------------------------|-------------
| [`translate_points()`][translate_points] | `translate_?_points (list, l)`         | `l` - length to translate
| .                                        | `translate_xy_points (list, t)`        | `t` - 2D position at X and Y axis
| [`rotate_points()`][rotate_points]       | `rotate_?_points (list, a, backwards)` | `a` - angle to rotate in degree
| .                                        |                                        | `backwards` - set `true` to rotate backwards, default = `false`
| [`mirror_points()`][mirror_points]       | `mirror_?_points (list)`               |
| [`scale_points()`][scale_points]         | `scale_?_points (list, f)`             | `f` - scale factor as numeric value
| [`resize_points()`][resize_points]       | `resize_?_points (list, l)`            | `l` - new size of axis

##### More at fixed axis: [^][contents]
| Base function                                          | with fixed axis                             | description
|--------------------------------------------------------|---------------------------------------------|-------------
| [`rotate_backwards_points()`][rotate_backwards_points] | `rotate_backwards_?_points (list, a)`       | `a` - angle
| [`rotate_at_points()`][rotate_at_points]               | `rotate_at_?_points (list, a, p)`           | `a` - angle<br /> `p` - position
| `rotate_backwards_at_points()`                         | `rotate_backwards_at_?_points (list, a, p)` | `a` - angle<br /> `p` - position
| [`mirror_at_points()`][mirror_at_points]               | `mirror_at_?_points (list, p)`              | `p` - position

