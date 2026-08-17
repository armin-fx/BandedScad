Transform and edit objects
==========================

### defined in file

`banded/operator.scad`  
` `|  
` `+--> `banded/operator_edit.scad`  
` `+--> `banded/operator_transform.scad`  
` `+--> `banded/operator_place.scad`  

`banded/draft.scad`  
` `|  
` `+--> `banded/draft_primitives.scad`  
` `| . . . . +--> `banded/draft_primitives_basic.scad`  
` `| . . . . +--> `banded/draft_primitives_transform.scad`  
` `| . . . . +--> `banded/draft_primitives_operator.scad`  
` `|  
` `+--> `banded/draft_transform.scad`  
` `| . . . . +--> `banded/draft_transform_basic.scad`  
` `| . . . . +--> `banded/draft_transform_common.scad`  
` `|  
` `+--> `banded/draft_matrix.scad`  
` `| . . . . +--> `banded/draft_matrix_basic.scad`  
` `| . . . . +--> `banded/draft_matrix_common.scad`  
` `. . .  


[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Contents"
- [Transform operators](#transform-operators-)
  - [Transformation modules and functions](#transformation-modules-and-functions-)
    - [`translate()`][translate]
    - [`rotate()`, `rotate_new()`][rotate]
    - [`rotate_backwards()`][rotate_backwards]
    - [`rotate_at()`][rotate_at]
    - [`rotate_to_vector()`][rotate_to_vector]
    - [`rotate_to_vector_at()`][rotate_to_vector_at]
    - [`mirror()`][mirror]
    - [`mirror_at()`][mirror_at]
    - [`mirror_copy()`][mirror_copy]
    - [`mirror_copy_at()`][mirror_copy_at]
    - [`mirror_repeat()`][mirror_repeat]
    - [`mirror_repeat_copy()`][mirror_repeat]
    - [`scale()`][scale]
    - [`scale_at()`][scale_at]
    - [`resize()`][resize]
    - [`skew()`][skew]
    - [`skew_at()`][skew_at]
    - [`multmatrix()`][multmatrix]
  - [Transformation with preset defaults](#transformation-with-preset-defaults-)
    - [Transformation operator backwards](#transformation-operator-backwards-)
    - [Transformation at a fixed axis](#transformation-at-a-fixed-axis-)
  - [Comparison same transformation](#comparison-same-transformation-)
    - [Built-in operator modules](#built-in-operator-modules-)
    - [More operator modules](#more-operator-modules-)
- [Place objects](#place-objects-)
  - [`connect()`][connect]
  - [`place()`][place]
  - [`place_line()`][place_line]
  - [`place_copy()`][place_copy]
  - [`place_copy_line()`][place_copy_line]
- [Edit and convert objects](#edit-and-convert-objects-)
  - [Combine operator](#combine-operator-)
    - [`combine()`][combine]
      - `part_main()`
      - `part_add()`
      - `part_cut()`
      - `part_cut_self()`
      - `part_cut_other()`
      - `part_cut_all()`
      - `part_limit()`
    - [`combine_fixed()`][combine_fixed]
    - [`select_object()`][select_object]
    - [`block()`][block]
  - [Modifying operations](#modifying-operations-)
    - [`xor()`][xor]
    - [`minkowski_difference()`][minkowski_difference]
    - [`hull_difference()`][hull_difference]
    - [`chain()`][chain]
    - [`bounding_box()`][bounding_box]
    - [`inject()`][inject]
    - [Split object in 2 parts][split_xxx]
      - `split_top()`
      - `split_bottom()`
      - `split_both()`
  - [2D to 3D extrusion](#2d-to-3d-extrusion-)
    - [`extrude_line()`][extrude_line]
    - [`plain_trace_extrude()`][plain_trace_extrude]
    - [`helix_extrude()`][helix_extrude]
    - [`tube_extrude()`][tube_extrude]
  - [3D to 2D projection](#3d-to-2d-projection-)
    - [`projection()`][projection]
    - [`projection_points()`][projection_points]

[align]: extend.md#extra-arguments-
[tube]:  object.md#tube-
[matrix_translate]:           draft_matrix.md#matrix_translate-
[matrix_rotate]:              draft_matrix.md#matrix_rotate-
[matrix_rotate_backwards]:    draft_matrix.md#matrix_rotate_backwards-
[matrix_rotate_at]:           draft_matrix.md#matrix_rotate_at-
[matrix_rotate_to_vector]:    draft_matrix.md#matrix_rotate_to_vector-
[matrix_rotate_to_vector_at]: draft_matrix.md#matrix_rotate_to_vector_at-
[matrix_mirror]:              draft_matrix.md#matrix_mirror-
[matrix_mirror_at]:           draft_matrix.md#matrix_mirror_at-
[matrix_scale]:               draft_matrix.md#matrix_scale-
[matrix_scale_at]:            draft_matrix.md#matrix_scale_at-
[matrix_skew]:                draft_matrix.md#matrix_skew-
[matrix_skew_at]:             draft_matrix.md#matrix_skew_at-
[O_translate]:  https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#translate
[O_rotate]:     https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#rotate
[O_mirror]:     https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#mirror
[O_scale]:      https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#scale
[O_resize]:     https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#resize
[O_projection]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_the_2D_Subsystem#3D_to_2D_Projection
[O_multmatrix]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#multmatrix


Transform operators [^][contents]
--------------------------------

Contains operator which transform objects with affine transformations.  
These replicate or extend OpenSCAD buildin operator family
and keep the same behavior and option names.  
[=> Wikipedia - Affine_transformation](https://en.wikipedia.org/wiki/Affine_transformation)  

Modules are defined in file:
- `operator_transform.scad`

All (mostly) operator modules already exists as
- __[Functions for objects in data list](draft_primitives.md)__  
  These functions will work on created objects stored in a data list
  and have the same names as the module version.  
  Defined in files:
  - `draft_primitives_basic.scad`
    - OpenSCAD's operators and objects as function
  - `draft_primitives_transform.scad`
    - additional operators
- __Functions for point lists__  
  These functions will work on lists with points, some even on one point.  
  The operators build upon these functions.
  The naming scheme consists of the module name with the suffix `_points`
  or `point` appended.  
  In files:
  - `draft_transform_basic.scad`
    - OpenSCAD's operators
  - `draft_transform_common.scad`
    - additional operators
- __[Functions to generate matrices](draft_matrix.md)__  
  These functions will generate a matrix for use with `multmatrix`.
  The naming scheme consists of the module name with the prefix `matrix_`.  
  In files:
  - `draft_matrix_basic.scad`
    - OpenSCAD's operators
  - `draft_matrix_common.scad`
    - additional operators

These functions have the same argument sequence as the module version,
but needs the _object data list_ or _list with points_ as first argument
(parameter `object` or parameter `list`),
except for functions to generate matrices.

_Example:_
```OpenSCAD
// Module version:
operator (xxx, ...)  object();

// Function version:
o = operator (object, xxx, ...);
build (o);

// Function for point lists:
l = operator_points (list, xxx, ...);
polygon (l);

// Function to generate matrices:
m = matrix_operator (xxx, ...);
multmatrix (m)  object();
```


### Transformation modules and functions [^][contents]

#### translate [^][contents]
[translate]: #translate-
Translate an object along a vector.  
Works like [`translate()` from OpenSCAD.][O_translate].

_Arguments:_
```OpenSCAD
// Operator as function:
translate (object, v)

// Operation to work on a point list
translate_points (list, v)
//
// Operation to work on one point
translate_point  (p,    v)
```
- `v` - vector

#### rotate, rotate_new [^][contents]
[rotate]: #rotate-rotate_new-
Rotate an object with additional options.  
Works like [=> `rotate()` from OpenSCAD.][O_rotate]

_Arguments:_  
```OpenSCAD
// Operator as module:
rotate_new (a, v, backwards)  ...

// Operator as function:
rotate (object, a, v, backwards)


// Operation to work on a point list
rotate_points (list, a, v, backwards)
//
// Operation to work on one point
rotate_point  (p,    a, v, backwards)
```
- `a` - angle parameter
  - as number: angle to rotate in degrees around an axis, defined in vector `v`
  - as list of 3 angles around a fixed axis `[X,Y,Z]`:
    The rotation is applied in the following order: X then Y then Z.
    Then the argument `v` is ignored.
- `v` - vector where rotating around, default = Z-axis
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

_You can replace buildin_ `rotate()` _with:_  
```OpenSCAD
module rotate(a,v,backwards) { rotate_new(a,v,backwards) children(); }
```

#### rotate_backwards [^][contents]
[rotate_backwards]: #rotate_backwards-
Rotate object backwards.  
Can undo forward rotate.

_Arguments:_
```OpenSCAD
// Operator as module:
rotate_backwards (a, v)  ...

// Operator as function:
rotate_backwards (object, a, v)

// Operation to work on a point list
rotate_backwards_points (list, a, v)
```
Options like [`rotate()`][rotate] with fixed argument `backwards = true`.

#### rotate_at [^][contents]
[rotate_at]: #rotate_at-
Rotate object at specific origin position.

_Arguments:_
```OpenSCAD
// Operator as module:
rotate_at (a, p, v, backwards)  ...

// Operator as function:
rotate_at (object, a, p, v, backwards)

// Operation to work on a point list
rotate_at_points (list, a, p, v, backwards)
```
- `a` - angle, see [`rotate()`][rotate]
- `v` - vector where it rotates around
- `p` - origin position at where it rotates
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### rotate_to_vector [^][contents]
[rotate_to_vector]: #rotate_to_vector-
Rotate object from direction Z axis to direction as vector.

_Arguments:_
```OpenSCAD
// Operator as module:
rotate_to_vector (v, a, backwards, d)  ...

// Operator as function:
rotate_to_vector (v, a, backwards)

// Operation to work on a point list
rotate_to_vector_points (list, v, a, backwards)
```
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d`
  - dimension of the object,
    on module version only
  - The operator can not get any data of the children object.
    It must therefore be defined what number of dimensions this has.
  - `3` - 3D object = default
  - `2` - 2D object (must set in this case)

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
- on module version the dimension number must be specified with `d=2`,
  since it cannot be determined from the object.

#### rotate_to_vector_at [^][contents]
[rotate_to_vector_at]: #rotate_to_vector_at-
Rotate object from direction Z axis to direction as vector.  
Rotate at a specific origin position.
Otherwise, it works like [rotate_to_vector][rotate_to_vector].

_Arguments:_
```OpenSCAD
// Operator as module:
rotate_to_vector_at (v, p, a, backwards)  ...

// Operator as function:
rotate_to_vector_at (object, v, p, a, backwards)

// Operation to work on a point list
rotate_to_vector_at_points (list, v, p, a, backwards)
```
- `v` - direction as vector
- `p` - origin position at where it rotates, default = `[0,0,0]`
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate


#### mirror [^][contents]
[mirror]: #mirror-
Mirror an object at origin along a vector.  
Works like  [=> `mirror()` from OpenSCAD.][O_mirror].

_Arguments:_
```OpenSCAD
// Operator as function:
mirror (object, v)

// Operation to work on a point list
mirror_points (list, v)
//
// Operation to work on one point
mirror_point  (p,    v)
```
- `v` - mirror along this direction, default = X axis

#### mirror_at [^][contents]
[mirror_at]: #mirror_at-
Mirror an object along a vector at specific origin position.

_Arguments:_
```OpenSCAD
// Operator as module:
mirror_at (v, p)  ...

// Operator as function:
mirror_at (object, v, p)

// Operation to work on a point list
mirror_at_points (list, v, p)
```
- `p` - origin position at where it mirrors, default = `[0,0,0]`
- `v` - mirror along this direction, default = X axis

#### mirror_copy [^][contents]
[mirror_copy]: #mirror_copy-
Mirror an object at origin along a vector `v`
and keep original object.

_Arguments:_
```OpenSCAD
// Operator as module:
mirror_copy (v)  ...

// Operator as function:
mirror_copy (object, v)
```
- `v` - mirror along this direction, standard = X axis

#### mirror_copy_at [^][contents]
[mirror_copy_at]: #mirror_copy_at-
Mirror an object along a vector `v` at origin position `p` and keep original object.

_Arguments:_
```OpenSCAD
// Operator as module:
mirror_copy_at (v, p)  ...

// Operator as function:
mirror_copy_at (object, v, p)
```
- `p` - origin position at where it mirrors
- `v` - mirror along this direction, standard = X axis

#### mirror_repeat [^][contents]
[mirror_repeat]: #mirror_repeat-
Mirror an object at origin up to 3 times along a vector `v`, then `v2`, `v3`.

_Arguments:_
```OpenSCAD
// Operator as module:
mirror_repeat (v, v2, v3)  ...

// Operator as function:
mirror_repeat (object, v, v2, v3)
```
- `v`  - mirror along this direction, standard = X axis
- `v2` - 2. mirror direction, optional
- `v3` - 3. mirror direction, optional

#### mirror_repeat_copy [^][contents]
[mirror_repeat_copy]: #mirror_repeat_copy-
Mirror an object at origin up to 3 times along a vector `v`, then `v2`, `v3`
and keep original object.

_Arguments:_
```OpenSCAD
// Operator as module:
mirror_repeat_copy (v, v2, v3)  ...

// Operator as function:
mirror_repeat_copy (object, v, v2, v3)
```
- `v`  - mirror along this direction, standard = X axis
- `v2` - 2. mirror direction, optional
- `v3` - 3. mirror direction, optional

#### scale [^][contents]
[scale]: #scale-
Scale an object on each axis.  
Works like [=> `scale()` from OpenSCAD][O_scale].

_Arguments:_
```OpenSCAD
// Operator as function:
scale (list, v)

// Operation to work on a point list
scale_points (list, v)
//
// Operation to work on one point
scale_point  (p,    v)
```
- `v`
  - vector with scale factor for each axis
  - missing numbers in the vector list will not scale the respective axis
  - as number, all axis will scale with this factor

#### scale_at [^][contents]
[scale_at]: #scale_at-
Scale an object on each axis at specific origin position.

_Arguments:_
```OpenSCAD
// Operator as module:
scale_at (v, p, d)  ...

// Operator as function:
scale_at (object, v, p)

// Operation to work on a point list
scale_at_points (list, v, p)
```
- `v`
  - vector with scale factor for each axis
  - missing numbers in the vector list will not scale the respective axis
  - as number, all axis will scale with this factor
- `p` - origin position at where it scales, default = `[0,0,0]`
- `d`
  - dimensions of object,
    needed for module version only
  - `3` - spatial (3D)
  - `2` - flat (2D)
  - not set - Try to get this value from the other options.
    Otherwise use 3D.
    It is not possible to get this information from the object.

#### resize [^][contents]
[resize]: #resize-
Resize and scale an object that it fits in `newsize`.  
Works like [=> `resize()` from OpenSCAD.][O_resize].

_Arguments:_
```OpenSCAD
// Operator as function:
resize (object, newsize)

// Operation to work on a point list
resize_points (list, newsize)
```
- `newsize` - vector with new size

#### skew [^][contents]
[skew]: #skew-
Skew an object.
- default for 3D = shear X along Z
- default for 2D = shear X along Y

_Arguments:_
```OpenSCAD
// Operator as module:
skew (v, t, m, a, d)  ...

// Operator as function:
skew (object, v, t, m, a)

// Operation to work on a point list
skew_points (list, v, t, m, a)
```
- `v` - vector, shear parallel to this axis
  - 3D:
    - as vector
    - standard = Z axis
  - 2D:
    - as vector
    - or as angle in degree
    - same operation like [`rotate_to_vector()`][rotate_to_vector]
    - standard = Y axis
- `t` - target vector, shear direction to this vector
  - 3D:
    - as vector
    - as angle in degree
    - standard = X axis
  - 2D:
    - not needed, undefined
- `m` - skew factor, standard = 0 
- `a` - angle in degree inside (-90 ... 90), alternative to 'm'
- `d`
  - dimensions of object,
    needed for module version only
  - `3` - spatial (3D)
  - `2` - flat (2D)
  - not set - Try to get this value from the other options.
    Otherwise use 3D.
    It is not possible to get this information from the object.

#### skew_at [^][contents]
[skew_at]: #skew_at-
Skew an object in a list at specific origin position.

_Arguments:_
```OpenSCAD
// Operator as module:
skew_at (v, t, m, a, p, d)  ...

// Operator as function:
skew_at (object, v, t, m, a, p)

// Operation to work on a point list
skew_at_points (list, v, t, m, a, p)
```
see [`skew()`][skew]
- `p` - origin position at where it skews, default = `[0,0,0]`

#### multmatrix [^][contents]
[multmatrix]: #multmatrix-
Multiply every point from an object with a affine transformation matrix.  
Works like [=> `multmatrix()` from OpenSCAD.][O_multmatrix].

_Arguments:_
```OpenSCAD
// Operator as function:
multmatrix (object, m)

// Operation to work on a point list
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


### Transformation with preset defaults [^][contents]

#### Transformation operator backwards [^][contents]
Contains modules that define known operations with operation backwards.  
Option `backwards` is removed and internally set to `true`.
Name convention: 'base operation' + '_backwards' + 'additional operations'  

| Base function                                  | operation backwards
|------------------------------------------------|---------------------
| `rotate()`, [`rotate_new()`][rotate]           | [`rotate_backwards()`][rotate_backwards]
| [`rotate_at()`][rotate_at]                     | `rotate_backwards_at()`
| [`rotate_to_vector()`][rotate_to_vector]       | `rotate_backwards_to_vector()`
| [`rotate_to_vector_at()`][rotate_to_vector_at] | `rotate_backwards_to_vector_at()`

#### Transformation at a fixed axis [^][contents]
Contains modules that define known operations on a fixed axis.  
Name convention: 'function operation name' + '_axis'  
Axis = x, y or z. later named as '?'

##### Basic transformation at fixed axis [^][contents]
| Base module buildin | with fixed axis           | description
|---------------------|---------------------------|-------------
| `translate()`       | `translate_? (l)`         | `l` - length to translate
| .                   | `translate_xy (t)`        | `t` - 2D position at X and Y axis
| `rotate()`          | `rotate_? (a, backwards)` | `a` - angle to rotate in degree<br> `backwards` - set `true` to rotate backwards, default = `false`
| `mirror()`          | `mirror_? ()`             |
| `scale()`           | `scale_? (f)`             | `f` - scale factor as numeric value
| `resize()`          | `resize_? (l)`            | `l` - new size of axis

| Base function on a point list     | with fixed axis                        | description
|-----------------------------------|----------------------------------------|-------------
| [`translate_points()`][translate] | `translate_?_points (list, l)`         | `l` - length to translate
| .                                 | `translate_xy_points (list, t)`        | `t` - 2D position at X and Y axis
| [`rotate_points()`][rotate]       | `rotate_?_points (list, a, backwards)` | `a` - angle to rotate in degree
| [`mirror_points()`][mirror]       | `mirror_?_points (list)`               |
| [`scale_points()`][scale]         | `scale_?_points (list, f)`             | `f` - scale factor as numeric value
| [`resize_points()`][resize]       | `resize_?_points (list, l)`            | `l` - new size of axis

##### More at fixed axis [^][contents]
| Base module                              | with fixed axis                 | description
|------------------------------------------|---------------------------------|-------------
| [`rotate_backwards()`][rotate_backwards] | `rotate_backwards_? (a)`        | `a` - angle
| [`rotate_at()`][rotate_at]               | `rotate_at_? (a, p, backwards)` | `a` - angle<br /> `p` - position
| `rotate_backwards_at()`                  | `rotate_backwards_at_? (a, p)`  | `a` - angle<br /> `p` - position
| [`mirror_at()`][mirror_at]               | `mirror_at_? (p)`               | `p` - position
| [`scale_at()`][scale_at]                 | `scale_at_? (f, p)`             | `f` - scale factor<br /> `p` - position

| Base function on a point list                   | with fixed axis                             | description
|-------------------------------------------------|---------------------------------------------|-------------
| [`rotate_backwards_points()`][rotate_backwards] | `rotate_backwards_?_points (list, a)`       | `a` - angle
| [`rotate_at_points()`][rotate_at]               | `rotate_at_?_points (list, a, p)`           | `a` - angle<br /> `p` - position
| `rotate_backwards_at_points()`                  | `rotate_backwards_at_?_points (list, a, p)` | `a` - angle<br /> `p` - position
| [`mirror_at_points()`][mirror_at]               | `mirror_at_?_points (list, p)`              | `p` - position
| [`scale_at_points()`][scale_at]                 | `scale_at_?_points (list, f, p)`            | `f` - scale factor<br /> `p` - position


### Comparison same transformation [^][contents]

#### Built-in operator modules [^][contents]
[=> OpenSCAD user manual, transformations](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations)

| operator                   | function on lists                        | generating matrix
|----------------------------|------------------------------------------|-------------------
| [translate()][translate]   | [translate_points()][translate]          | [matrix_translate()][matrix_translate]
| [rotate()][rotate]         | [rotate_points()][rotate]                | [matrix_rotate()][matrix_rotate]
| [mirror()][mirror]         | [mirror_points()][mirror]                | [matrix_mirror()][matrix_mirror]
| [scale()][scale]           | [scale_points()][scale]                  | [matrix_scale()][matrix_scale]
| [resize()][resize]         | [resize_points()][resize]                | -
| [projection()][projection] | [projection_points()][projection_points] | -
| [multmatrix()][multmatrix] | [multmatrix_points()][multmatrix]        | -

#### More operator modules [^][contents]

| operator                                     | function on lists                                   | generating matrix
|----------------------------------------------|-----------------------------------------------------|-------------------
| [rotate_backwards()][rotate_backwards]       | [rotate_backwards_points()][rotate_backwards]       | [matrix_rotate_backwards()][matrix_rotate_backwards]
| [rotate_at()][rotate_at]                     | [rotate_at_points()][rotate_at]                     | [matrix_rotate_at()][matrix_rotate_at]
| [rotate_to_vector()][rotate_to_vector]       | [rotate_to_vector_points()][rotate_to_vector]       | [matrix_rotate_to_vector()][matrix_rotate_to_vector]
| [rotate_to_vector_at()][rotate_to_vector_at] | [rotate_to_vector_at_points()][rotate_to_vector_at] | [matrix_rotate_to_vector_at()][matrix_rotate_to_vector_at]
| [mirror_at()][mirror_at]                     | [mirror_at_points()][mirror_at]                     | [matrix_mirror_at()][matrix_mirror_at]
| [mirror_copy()][mirror_copy]                 | -                                                   | -
| [mirror_copy_at()][mirror_copy_at]           | -                                                   | -
| [mirror_repeat()][mirror_repeat]             | -                                                   | -
| [mirror_repeat_copy()][mirror_repeat_copy]   | -                                                   | -
| [scale_at()][scale_at]                       | [scale_at_points][scale_at]                         | [matrix_scale_at()][matrix_scale_at]
| [skew()][skew]                               | [skew_points()][skew]                               | [matrix_skew()][matrix_skew]
| [skew_at()][skew_at]                         | [skew_at_points()][skew_at]                         | [matrix_skew_at()][matrix_skew_at]


Place objects [^][contents]
---------------------------
Modules which place objects in specific position

#### connect [^][contents]
[connect]: #connect-
Move and rotate an object to a specific position.

_Arguments:_
```OpenSCAD
// Operator as module:
connect (point, direction, orientation)

// Operator as function for object in a list:
connect (object, point, direction, orientation)

// Operator as function for a list with points:
connect_points (list, point, direction, orientation)
```

_3D:_  
The origin from the object will be moved to position `point`.  
The Z-axis from the object is the arrow direction, it will be rotated into the vector of `direction`.  
The X-axis is the direction of rotation, it will be rotated around the arrow direction to the point `orientation`.

_2D:_  
The origin from the object will be moved to position `point`.  
The X-axis from the object is the arrow direction, it will be rotated into the vector of `direction`.

#### place [^][contents]
[place]: #place-points-
Places the objects successively at the specified `points` in the list.  
Object 1 set to point 1, object 2 set to point 2, and so on.

_Arguments:_
```OpenSCAD
place (points)
```

#### place_line [^][contents]
[place_line]: #place_line-direction-distances-
Places the objects successively onto a line at the specified distances in the list.

_Arguments:_
```OpenSCAD
place_line (direction, distances)
```
- `direction` - direction of the line
- `distances`
  - distances as a list
    place the specific objects at given distance in a list
  - distances as a numeric value
    place all objects at this distance

_There exist specialized modules which places objects along a fixed axis at the specified distances:_  
`place_? (distances)`  
'?' means the axis. Axis = x, y or z.

#### place_copy [^][contents]
[place_copy]: #place_copy-points-
Places copies of an object at given `points` in the list.  

_Arguments:_
```OpenSCAD
place_copy (points)
```

#### place_copy_line [^][contents]
[place_copy_line]: #place_copy_line-direction-distances-
Places copies of an objects onto a line at given distances in the list.

_Arguments:_
```OpenSCAD
place_copy_line (direction, distances)
```
- `direction` - direction of the line
- `distances` - distances as a list

_There exist specialized modules which places copies of an object along a fixed axis at given distances:_  
`place_copy_? (distances)`  
'?' means the axis. Axis = x, y or z.


Edit and convert objects [^][contents]
-----------------------------------

### Combine operator [^][contents]

#### combine [^][contents]
[combine]: #combine-
This will add or remove parts from a main object.  
Inside a combine block you can define multiple parts
to add or remove in any order.
Add a predicate like `part_main()` (for a main object),
`part_add()` or `part_cut()` to each object.

_Example:_
```OpenSCAD
include <banded.scad>

$fn=24;
combine()
{
	part_main()
		cube([5,5,2], center=true);
	part_add()
		cylinder(d=3, h=4, center=true);
	part_cut()
		cylinder(d=4, h=3, center=true);
}
```

You can put these parts into a module, they will selected in the right order.
This is useful to edit a main object with additional parts.
The parts will always edit the main object, defined by `part_main()`.
But you can define elements, they can additional edit the additional parts.
You can put sibling parts together into a module or into an `union()` block
and additional edit these with specialized part predicates.

_Defined part elements:_
- `part_main ()`
  - defines the main object to edit
  - all operations will done on this object
- `part_add ()`
  - add an object
- `part_cut (self, other)`
  - remove a part from the main object
  - do nothing with all added objects by default
  - _Arguments:_
    - `self`
      - if set `true`, this will additional
        remove from the own sibling parts, defined in the same module
      - default = `false`
    - `other`
      - if set `true`, this will additional
        remove from all other added parts
      - default = `false`
- `part_cut_self (other)`
  - remove a part from the main object
  - remove from the own sibling parts, defined in the same module
  - do nothing with all other parts
  - this is useful e.g.
    if a hole must bored through the main object _and_ the added part
  - _Arguments:_
    - `other`
      - if set `true`, this will additional
        remove from all other added parts
      - default = `false`
- `part_cut_other (self)`
  - remove a part from the main object
  - remove from all other parts,
    except from the own sibling parts, defined in the same module
  - _Arguments:_
    - `self`
      - if set `true`, this will additional
        remove from the own sibling parts, defined in the same module
      - default = `false`
- `part_cut_all ()`
  - remove a part from the main object
  - remove from all added parts, inclusive the own sibling parts
- `part_limit ()`
  - defines a common hull for the main object,
    all parts they exceed this object will be removed
  - if you use this element, you _must_ set parameter `combine (limit=true)`
- `part_type (type)`
  - perform a part operation defined in argument `type`
  - This is useful if a module make different things with different arguments.
    So you can select the correct part type depend on the argument.
  - the types are defined in constants:
    - `combine_type_main`  - main part
    - `combine_type_add`   - add part
    - `combine_type_cut`   - remove part
    - `combine_type_cut_self`
    - `combine_type_cut_other`
    - `combine_type_cut_all`
    - `combine_type_limit` - common hull part

_Example:_
```OpenSCAD
include <banded.scad>

$fn=24;
combine()
{
	part_main()
		cube([11,5,4], center=true);
	
	translate_x( 3) tube_element();
	translate_x(-3) tube_element();
}

module tube_element ()
{
	part_add()
		translate_z(1)
		cylinder (d=3, h=5);
	
	part_cut()
		cylinder (d=4, h=5);
	
	part_cut_self()
		translate_z(-3)
		cylinder (d=2, h=10);
}
```

_Arguments:_
```OpenSCAD
combine (limit, type, select)
```
- `limit`
  - if set `true`, combine uses the element `part_limit()`
    to define a common hull for the main object
  - default = `false`, ignore `part_limit()`
  - this is necessary to prevent errors, mostly `part_limit()` is not used
- `type`
  - you can select one part element, only this parts will shows
  - e.g. for debug reason
  - the types are defined in constants:
    - `combine_type_undef` - default, normal working, no selecting
    - `combine_type_main`  - only main part
    - `combine_type_add`   - only added parts
    - `combine_type_cut`   - only removed parts
    - `combine_type_cut_self`
    - `combine_type_cut_other`
    - `combine_type_cut_all`
    - `combine_type_limit` - only common hull parts
- `select`
  - you can select a number of children in the combine block,
    then only these are used
  - as number: this children position is used
  - as list: only the children in the list are used
  - a negative number will count from the last children backwards,
    e.g. `-1` = last children

_Check current part type:_  
You can check the current selection of part type with functions.  
This is useful if you create modules, which do complex operations to the object.
- `is_part_main ()`
  - check the main object selection
- `is_part_add ()`
  - check the add part selection
- `is_part_cut ()`
  - check the cut part selection
  - specialized cut checks:
    - `is_part_cut_self ()`
      - check the cut part selection for sibling parts
    - `is_part_cut_other ()`
      - check the cut part selection for other parts
    - `is_part_cut_all ()`
      - check the cut part selection for all parts
- `is_part_limit ()`
  - check the limit part selection

#### combine_fixed [^][contents]
[combine_fixed]: #combine_fixed-
Put parts together to a main object in a fixed order.  
This is helpful, if more than one operator is needed to do this.
You can create a hole to the main object and put a part on this.
Maybe you can define a common hull for the complete object and
cut all parts outside of.
Every place on this operator has his specific operation.
You can "jump over" a place with the defined module `empty()`.

_Sequence of operator:_
```OpenSCAD
combine_fixed() { main_object(); adding_part(); cutting_part(); common_hull(); }
```

_Example:_
```OpenSCAD
include <banded.scad>
$fn=24;
d_inner=4;

combine_fixed()
{
	cube_extend([7,7,2], align=[0,0,-1]);
	tube       (h=2, di=d_inner, w=1);
	cylinder   (h=6, d =d_inner, center=true);
}
```

#### select_object [^][contents]
[select_object]: #select_object-
Chose one object on given position.  

_Arguments:_
```OpenSCAD
select_object (i)
```

_Usage:_
```OpenSCAD
// select one object, in this case number 1, the sphere
i = 1;

select_object (i)
{
	cube();     // i==0
	sphere();   // i==1
	cylinder(); // i==2
}
```

#### block [^][contents]
[block]: #block-
Module that initializes a block
allowing new values ​​to be assigned to variables within it,
without modifying them outside the block.  
When using braces alone, without any operator preceding them,
variables inside the braces overwrite the value of variables
with the same name outside them.
Even as the braces are not there.

_Example without `block()`:_
```OpenSCAD
include <banded.scad>

a = 0;
echo (a);     // ECHO: 1

{
	a = 1;    // Produces a warning that 'a' was assigned but was overwritten.
	echo (a); // ECHO: 1
}
```

_Example with `block()`:_
```OpenSCAD
include <banded.scad>

a = 0;
echo (a);     // ECHO: 0

block()
{
	a = 1;    // Here, 'a' is assigned a value within this block
	          // without changing outside of it.
	echo (a); // ECHO: 1
}
```

_Alternative:_
```OpenSCAD
if (true)
{ ... }
```


### Modifying operations [^][contents]

#### xor [^][contents]
[xor]: #xor-
Create the exclusive or with objects.  
Experimental, works with up to 8 objects and make sometimes errors.

_Arguments:_
```OpenSCAD
xor (d, skirt)
```
- `d`     - dimension of the objects, default = `3` - 3D object
- `skirt` - optional, create a little skirt around the object to prevent errors
  - default = constant `epsilon`

#### minkowski_difference [^][contents]
[minkowski_difference]: #minkowski_difference-
Removes shapes from a base shape surface.  
Takes a base shape and one or more diff shapes,
carves out the diff shapes from the surface of the base shape,
in a way complementary to how `minkowski()` unions shapes to the surface of its base shape.

_Arguments:_
```OpenSCAD
minkowski_difference (d, convexity)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `convexity`
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.

#### hull_difference [^][contents]
[hull_difference]: #hull_difference-
Create a difference from the convex hull of an object and the object itself.  
Experimental, make sometimes errors.

_Arguments:_
```OpenSCAD
hull_difference (d=3, skirt=epsilon)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `skirt` - optional, create a little skirt around the object to prevent errors
  - default = constant `epsilon`

#### chain [^][contents]
[chain]: #chain-
Fill the space between each object pair.  
Experimental, make sometimes errors.

_Arguments:_
```OpenSCAD
chain (d=3, skirt=epsilon)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `skirt` - optional, create a little skirt around the object to prevent errors
  - default = constant `epsilon`

#### bounding_box [^][contents]
[bounding_box]: #bounding_box-
Create the smallest bounding box of an object.

_Arguments:_
```OpenSCAD
bounding_box (d, height)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `height`
  - for internal use, any size greater then the biggest lenght of the object
  - default = `1000`

#### inject [^][contents]
[inject]: #inject-
Inject an object into a main object.  
Cuts out overlapping areas from the main object and inserts itself into them.

_Arguments:_
```OpenSCAD
inject (part)  { main_object(); injected_object(); }
```
- `part`
  - Optional, select the object to show.
    This is useful for controlling which part should be displayed.
  -  `0`  = default, show both objects
  - `< 0` = show only the main object
  - `> 0` = show only the injected object

_Example:_
```OpenSCAD
part = 0; // [-1:main_object, 0:both, 1:injected_object]

include <banded.scad>

inject (part)
{
	color("gold"  ,0.5) cube([3,3,3], center=true);
	color("orange",0.5) cylinder(r=1, h=2, $fn=24);
}
```

#### Split object in 2 parts: [^][contents]
[split_xxx]: #split-object-in-2-parts-
This will split a main object on the contour of a split object.  
There will create 2 objects:
- The inner part = an intersection of main object and split object
- The outer part = cut split object from main object

You can define a gap between both objects.  
If you define a gap, you must make the split object little bigger
then the main object, on parts where you won't carve out the gap.
Another way is to set the balance to `1`, carve the gap only on outer part.

_Operator:_
- `split_inner (gap, balance)`
  - Create the inner part
- `split_outer (gap, balance)`
  - Create the outer part

_Helper operator:_
- `split_both  (gap, balance)`
  - Create the inner part and outer part together
  - Useful for test reason

_Sequence of operator:_
```OpenSCAD
split_xxx() { split_object(); main_object(); }
```

_Arguments:_
- gap     = the gap between both parts, default = `0`
- balance = balance between inner and outer parts `-1 ... 0 ... 1`
  - ` 0` = carve out both parts half, default
  - `-1` = carve only inner part
  - `+1` = carve only outer part

_Example:_
```OpenSCAD
gap    = 0.5;
height = 1;

include <banded.scad>

module main (c)
{
	cube ([15,10,height]);
}
module split () union()
{
	$fn=24;
	translate([ 0,5,-gap]) cylinder (h=height + 2*gap, d=6);
	translate([ 5,5,-gap]) cylinder (h=height + 2*gap, d=6);
	translate([10,5,-gap]) cylinder (h=height + 2*gap, d=6);
}

%split();
//
split_inner (gap=gap) { split(); main(); }
split_outer (gap=gap) { split(); main(); }
```


### 2D to 3D extrusion [^][contents]

#### extrude_line [^][contents]
[extrude_line]: #extrude_line-
Extrudes and rotates the 2D object along the line.  
The object will rotate around the arrow direction of the line
till the stretched surface from X-axis of the 2D-object and the line
will touch the point of `rotational`.  
Only as _module version_.

_Arguments:_
```OpenSCAD
extrude_line (line, rotational, convexity, extra_h)
```
- `line` - list with 2 points `[from, to]`
- `rotational` - a vector, standard = X-axis
- `extra_h`
  - the line will make longer this length at both ends
  - default = `0`
- `convexity`
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.

#### plain_trace_extrude [^][contents]
[plain_trace_extrude]: #plain_trace_extrude-
This will extrude an 2D-object in the X-Y plane along a 2D-trace
(keeping only the right half, X >= 0).
Note that the object started on the X-Y plane but is tilted up
(rotated +90 degrees around the X-axis) to extrude,
then the new Y-axis is the direction which will set in the direction of the line.  
Only as _module version_.

_Arguments:_
```OpenSCAD
plain_trace_extrude (trace, range, closed, convexity, limit)
```
- `trace` - 2D point list, which compose the line
- `range` - index range of the trace used to extrude
  - You can use a part of the line `[first_point, last_point]`
  - negative indices will count backwards from the end of the trace
  - default = `[0, -1]` the complete trace from the first to last point
- `closed`
  - `true`  - the trace is a closed loop, the last point connect the first point
  - `false` - the trace from first to last point, default
- `convexity`
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.
- `limit` - internal parameter
  - The module knows nothing about the children to extrude,
    so internal objects to work on this must made much bigger then the
    children could be.
    The `limit` parameter can set to an other value if these internal objects
    are to small.
  - default = `1000`

_Specialized modules:_
- `plain_trace_extrude_open (trace, range, convexity, limit)`
  - This will keep the ends open
  - same as `plain_trace_extrude()` with `closed` set to the default `false`
- `plain_trace_extrude_closed (trace, range, convexity, limit)`
  - This will connect both ends to a closed trace.
  - like `plain_trace_extrude()` with `closed` set to `true`

#### helix_extrude [^][contents]
[helix_extrude]: #helix_extrude-
Creates a helix with a 2D-polygon similar rotate_extrude.  
As module and as function.

The _module version_ will generate every segment with operation `hull()` on the 2D-polygon ends.
It makes sometimes trouble when you want to render the object.
If you can, it is maybe better to use the _function version_.

_module version_ modified from Gael Lafond, <https://www.thingiverse.com/thing:2200395>  
License: CC0 1.0 Universal

_Arguments:_
```OpenSCAD
// module version
helix_extrude (angle, rotations, pitch, height, r, opposite, orientation, slices, convexity, scope, step)

// function version
helix_extrude (object, angle, rotations, pitch, height, r, opposite, orientation, slices)
```
- `object`    - 2D data object or a trace as point list
- `angle`     - angle of helix in degrees - default: `360`
- `rotations` - rotations of helix, can be used instead `angle`
- `height`    - height of helix - default: 0 like `rotate_extrude()`
- `pitch`     - rise per rotation
- `r`
  - radius as number or as list `[r1, r2]`
  - `r1` = bottom radius, `r2` = top radius
  - `r` as number means, bottom and top radius is the same size
- `opposite`  - if `true` reverse rotation of helix, default = `false`
- `orientation`
  - if `true`, orientation of Y-axis from the 2D-polygon is set along the surface of the cone.
  - `false` = default, orientation of Y-axis from the 2D-polygon is set to Z-axis
- `slices`    - count of segments from helix per full rotation
- `convexity`
  - only for module version
  - `0` - only concave polygon (default)
  - `1` - can handle one convex polygon only
  - `2` - can maybe handle more then one convex polygon
    - This will slice the 2D-polygon in little pieces and hope they are concave.  
      Experimental with some problems.  
      It's better to split it in concave helixes with the same parameter
      and make the difference with it.

#### tube_extrude [^][contents]
[tube_extrude]: #tube_extrude-
Extrudes a 2D object along an arc.  
The 2D object must be located on the positive side of the X-axis.
This will use an 2D object along the X axis,
extrude this to wall thickness and
put this around an imaginary cylinder in counterclock direction starting from the X axis.
As if you were to cover a cylinder with wallpaper.
Behaves similarly to figure [`tube()`][tube] and can be combined with it.  
Only as _module version_.

_Arguments:_
```OpenSCAD
tube_extrude (r, w, ri, ro, angle, outer, align, d, di, do, convexity, size)
```
- `r`, `d`   - The mean radius or diameter. The wall width is divided evenly between the inside and outside.
- `ri`, `di` - inner radius, inner diameter
- `ro`, `do` - outer radius, outer diameter
- `w`        - width of the wall
- `angle`    - drawed angle in degree, default=`360`
  - as number = angle from `0` to `angle` = opening angle
  - as list   = `[opening angle, start angle]`
  - The angle parameter refers to the _displayed open window_,
    viewed along the X-axis of the 2D object.
    E.g. you can use negative start angle to show object parts
    from the left side of the X-axis.
- `outer`
  - optional
  - value `0`...`1`
    - `0` - edges on real circle line, default
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle
    - the problem is described in website
      <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects>
  - or as a list for separate adjustment to the inner and outer radii `[for_inner_circle, for_outer_circle]`
- `align`
  - optional
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0]` = X and Y axis centered
  - The align value in X and Y axis refers to the outer radius.
  - The Z axis is not being aligned.
    It corresponds to the Y axis of the 2D object and must be aligned in there.
- `convexity`
  - optional
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.
- `size`
  - optional
  - Internally value in module version
  - Describes the intern working object size as numeric value.
    By default, `1000` is big enough to enclose most objects.

_Must be specified:_
- exactly 2 arguments `r` or `ri` or `ro` or `w`

_Example:_
```OpenSCAD
include <banded.scad>

tube_extrude (ri=10, w=1)
text ("Test Text");
```


### 3D to 2D projection [^][contents]

#### projection [^][contents]
[projection]: #projection-
Get projection of an Object to the XY-plane.  
Not working yet, only on point lists.  
[=> `projection()` from OpenSCAD][O_projection].

_Arguments:_
```OpenSCAD
// Operator as function:
projection (object, cut, plane)
```
- `cut`     - not implemented yet
- `plane`
  - `true`  - make a 2D-list, default
  - `false` - make a 3D-list, keep points on xy-plane
  - number  - make a 3D-list, set Z-axis to this height

#### projection_points [^][contents]
[projection_points]: #projection_points-
Get projection of every point in a list to the XY-plane.

_Arguments:_
```OpenSCAD
// Operation to work on a point list
projection_points (list, plane)
//
// Operation to work on one point
projection_point  (p,    plane)
```
- `plane`
  - `true`  - make a 2D-list, default
  - `false` - make a 3D-list, keep points on xy-plane
  - number  - make a 3D-list, set Z-axis to this height

