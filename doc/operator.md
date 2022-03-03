Transform and edit objects
==========================


### defined in file

`banded/operator.scad`\
` `| \
` `+--> `banded/operator_edit.scad`\
` `+--> `banded/operator_transform.scad`\
` `+--> `banded/operator_place.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Contents"
- [Transform operator](#transform-operator-)
  - [Transformation modules](#transformation-modules-)
    - [`rotate_new()`][rotate_new]
    - [`rotate_backwards()`][rotate_backwards]
    - [`rotate_at()`][rotate_at]
    - [`rotate_to_vector()`][rotate_to_vector]
    - [`rotate_to_vector_at()`][rotate_to_vector_at]
    - [`mirror_at()`][mirror_at]
    - [`mirror_copy()`][mirror_copy]
    - [`mirror_copy_at()`][mirror_copy_at]
    - [`mirror_repeat()`][mirror_repeat]
    - [`mirror_repeat_copy()`][mirror_repeat]
    - [`skew()`][skew]
    - [`skew_at()`][skew_at]
  - [Transformation with preset defaults](#transformation-with-preset-defaults-)
    - [Transformation operator backwards](#transformation-operator-backwards-)
    - [Transformation at a fixed axis](#transformation-at-a-fixed-axis-)
  - [Comparison same transformation](#comparison-same-transformation-)
    - [Buildin operator modules](#buildin-operator-modules-)
    - [More operator modules](#more-operator-modules-)
- [Place objects](#place-objects-)
  - [`connect()`][connect]
  - [`place()`][place]
  - [`place_line()`][place_line]
  - [`place_copy()`][place_copy]
  - [`place_copy_line()`][place_copy_line]
- [Edit and test objects](#edit-and-test-objects-)


Transform operator [^][contents]
--------------------------------
Contains modules which extend OpenSCAD buildin operator family
and keep the same behavior and option names.

### Transformation modules [^][contents]

#### `rotate_new` (a, v, backwards)` [^][contents]
[rotate_new]: #rotate_new-a-v-backwards-
Rotate object with additional options.
Works like `rotate()`.\
You can replace buildin `rotate()` with:
```OpenSCAD
module rotate(a,v,backwards=false) { rotate_new(a,v,backwards) children(); }
```
- `a` - angle to rotate in degree
- `v` - vector where rotating around
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `rotate_backwards (a, v)` [^][contents]
[rotate_backwards]: #rotate_backwards-a-v-
Rotate object backwards.
Options like `rotate()`.
- `a` - angle
- `v` - vector where rotating around

#### `rotate_at (a, p, v, backwards)` [^][contents]
[rotate_at]: #rotate_at-a-p-v-backwards-
Rotate object at position `p`.
- `a` - angle
- `v` - vector where it rotates around
- `p` - origin position at where it rotates
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `rotate_to_vector (v, a, backwards, d)` [^][contents]
[rotate_to_vector]: #rotate_to_vector-v-a-backwards-d-
Rotate object from direction Z axis to direction at vector `v`.
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d` - dimension of the object
  - `3`     - 3D object = standard
  - `2`     - 2D object (must set in this case)

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
- the dimension number must be specified with `d=2`,
  since it cannot be determined from the object.

#### `rotate_to_vector_at (v, p, a, backwards)` [^][contents]
[rotate_to_vector_at]: #rotate_to_vector_at-v-p-a-backwards-
Rotate object from direction Z axis to direction at vector `v`.
Rotate origin at vector `v`.
- `v` - vector where it rotates around
- `p` - direction as vector
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### `mirror_at (v, p)` [^][contents]
[mirror_at]: #mirror_at-v-p-
Mirror an object along a vector `v` at origin position `p`.
- `p` - origin position at where it mirrors
- `v` - mirror along this direction, standard = X axis

#### `mirror_copy (v)` [^][contents]
[mirror_copy]: #mirror_copy-v-
Mirror an object at origin along a vector `v`
and keep original object.
- `v` - mirror along this direction, standard = X axis

#### `mirror_copy_at (v, p)` [^][contents]
[mirror_copy_at]: #mirror_copy_at-v-p-
Mirror an object along a vector `v` at origin position `p` and keep original object.
- `p` - origin position at where it mirrors
- `v` - mirror along this direction, standard = X axis

#### `mirror_repeat (v, v2, v3)` [^][contents]
[mirror_repeat]: #mirror_repeat-v-v2-v3-
Mirror an object at origin up to 3 times along a vector `v`, then `v2`, `v3`.
- `v`  - mirror along this direction, standard = X axis
- `v2` - 2. mirror direction, optional
- `v3` - 3. mirror direction, optional

#### `mirror_repeat_copy (v, v2, v3)` [^][contents]
[mirror_repeat_copy]: mirror_repeat_copy-v-v2-v3-
Mirror an object at origin up to 3 times along a vector `v`, then `v2`, `v3`
and keep original object.
- `v`  - mirror along this direction, standard = X axis
- `v2` - 2. mirror direction, optional
- `v3` - 3. mirror direction, optional

#### `skew (v, t, m, a, d)` [^][contents]
[skew]: #skew-v-t-m-a-d-
skew an object.\
standard 3D = shear X along Z\
standard 2D = shear X along Y
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
- `d` - dimensions of object
  - `3` - spatial (3D)
  - `2` - flat (2D)
  - not set - Try to get this value from the other options.
    Otherwise use 3D.
    It is not possible to get this information from the object.

#### `skew_at (v, t, m, a, p, d)` [^][contents]
[skew_at]: #skew_at-v-t-m-a-p-d-
skew an object in a list at position `p`.\
see [`skew()`][skew]
- `p` - origin position at where it skews


### Transformation with preset defaults [^][contents]

#### Transformation operator backwards [^][contents]
Contains modules that define known operations with operation backwards.\
Option `backwards` is removed and internally set to `true`.
Name convention: 'base operation' + '_backwards' + 'additional operations'\

| Base function                                  | operation backwards
|------------------------------------------------|---------------------
| `rotate()`, [`rotate_new()`][rotate_new]       | [`rotate_backwards (a, v, d)`][rotate_backwards]
| [`rotate_at()`][rotate_at]                     | `rotate_backwards_at (a, p, v, d)`
| [`rotate_to_vector()`][rotate_to_vector]       | `rotate_backwards_to_vector (v, a)`
| [`rotate_to_vector_at()`][rotate_to_vector_at] | `rotate_backwards_to_vector_at (v, p, a)`

#### Transformation at a fixed axis [^][contents]
Contains modules that define known operations on a fixed axis.\
Name convention: 'function operation name' + '_axis'\
Axis = x, y or z. later named as '?'

##### Basic transformation at fixed axis [^][contents]
| Base module buildin | with fixed axis    | description
|---------------------|--------------------|-------------
| `translate()`       | `translate_? (l)`  | `l` - length to translate
| .                   | `translate_xy (t)` | `t` - 2D position at X and Y axis
| `rotate()`          | `rotate_? (a)`     | `a` - angle to rotate in degree
| `mirror()`          | `mirror_? ()`      |
| `scale()`           | `scale_? (f)`      | `f` - scale factor as numeric value
| `resize()`          | `resize_? (l)`     | `l` - new size of axis

##### More at fixed axis [^][contents]
| Base module                              | with fixed axis                | description
|------------------------------------------|--------------------------------|-------------
| [`rotate_backwards()`][rotate_backwards] | `rotate_backwards_? (a)`       | `a` - angle
| [`rotate_at()`][rotate_at]               | `rotate_at_? (a, p)`           | `a` - angle<br /> `p` - position
| `rotate_backwards_at()`                  | `rotate_backwards_at_? (a, p)` | `a` - angle<br /> `p` - position
| [`mirror_at()`][mirror_at]               | `mirror_at_? (p)`              | `p` - position


### Comparison same transformation [^][contents]

#### Buildin operator modules [^][contents]
[=> OpenSCAD user manual, transformations](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations)

| operator module        | function on lists                        | generating matrix
|------------------------|------------------------------------------|-------------------
| translate()            | [translate_points()][translate_points]   | [matrix_translate()][matrix_translate]
| [rotate()][rotate_new] | [rotate_points()][rotate_points]         | [matrix_rotate()][matrix_rotate]
| mirror()               | [mirror_points()][mirror_points]         | [matrix_mirror()][matrix_mirror]
| scale()                | [scale_points()][scale_points]           | [matrix_scale()][matrix_scale]
| resize()               | [resize_points()][resize_points]         | -
| projection()           | [projection_points()][projection_points] | -
| multmatrix()           | [multmatrix_points()][multmatrix_points] | -

[translate_points]:  draft.md#translate_points-list-v-
[rotate_points]:     draft.md#rotate_points-list-a-v-backwards-
[mirror_points]:     draft.md#mirror_points-list-v-
[scale_points]:      draft.md#scale_points-list-v-
[resize_points]:     draft.md#resize_points-list-newsize-
[projection_points]: draft.md#projection_points-list-plane-
[multmatrix_points]: draft.md#multmatrix_points-list-m-

[matrix_translate]: draft.md#matrix_translate-v-d-
[matrix_rotate]:    draft.md#matrix_rotate-a-v-backwards-d-
[matrix_mirror]:    draft.md#matrix_mirror-v-d-
[matrix_scale]:     draft.md#matrix_scale-v-d-

#### More operator modules [^][contents]

| operator module                              | function on lists                                          | generating matrix
|----------------------------------------------|------------------------------------------------------------|-------------------
| [rotate_backwards()][rotate_backwards]       | [rotate_backwards_points()][rotate_backwards_points]       | [matrix_rotate_backwards()][matrix_rotate_backwards]
| [rotate_at()][rotate_at]                     | [rotate_at_points()][rotate_at_points]                     | [matrix_rotate_at()][matrix_rotate_at]
| [rotate_to_vector()][rotate_to_vector]       | [rotate_to_vector_points()][rotate_to_vector_points]       | [matrix_rotate_to_vector()][matrix_rotate_to_vector]
| [rotate_to_vector_at()][rotate_to_vector_at] | [rotate_to_vector_at_points()][rotate_to_vector_at_points] | [matrix_rotate_to_vector_at()][matrix_rotate_to_vector_at]
| [mirror_at()][mirror_at]                     | [mirror_at_points()][mirror_at_points]                     | [matrix_mirror_at()][matrix_mirror_at]
| [mirror_copy()][mirror_copy]                 | -                                                          | -
| [mirror_copy_at()][mirror_copy_at]           | -                                                          | -
| [mirror_repeat()][mirror_repeat]             | -                                                          | -
| [mirror_repeat_copy()][mirror_repeat_copy]   | -                                                          | -
| [skew()][skew]                               | [skew_points()][skew_points]                               | [matrix_skew()][matrix_skew]
| [skew_at()][skew_at]                         | [skew_at_points()][skew_at_points]                         | [matrix_skew_at()][matrix_skew_at]

[rotate_backwards_points]:    draft.md#rotate_backwards_points-list-a-v-
[rotate_at_points]:           draft.md#rotate_at_points-list-a-p-v-backwards-
[rotate_to_vector_points]:    draft.md#rotate_to_vector_points-list-v-a-backwards-
[rotate_to_vector_at_points]: draft.md#rotate_to_vector_at_points-list-v-p-a-backwards-
[mirror_at_points]:           draft.md#mirror_at_points-list-v-p-
[skew_points]:                draft.md#skew_points-list-v-t-m-a-
[skew_at_points]:             draft.md#skew_at_points-list-v-t-m-a-p-

[matrix_rotate_backwards]:    draft.md#matrix_rotate_backwards-a-v-d-
[matrix_rotate_at]:           draft.md#matrix_rotate_at-a-p-v-backwards-d-
[matrix_rotate_to_vector]:    draft.md#matrix_rotate_to_vector-v-a-backwards-
[matrix_rotate_to_vector_at]: draft.md#matrix_rotate_to_vector_at-v-p-a-backwards-
[matrix_mirror_at]:           draft.md#matrix_mirror_at-v-p-d-
[matrix_skew]:                draft.md#matrix_skew-v-t-m-a-d-
[matrix_skew_at]:             draft.md#matrix_skew_at-v-t-m-a-p-d-


Place objects [^][contents]
---------------------------
Modules which place objects in specific position

#### `connect (point, direction, orientation)` [^][contents]
[connect]: #connect-point-direction-orientation-
Move and rotate an object to a specific position.

___3D:___
The origin from the object will be moved to position `point`.\
The Z-axis from the object is the arrow direction, it will be rotated into the vector of `direction`.\
The X-axis is the direction of rotation, it will be rotated around the arrow direction to the point `orientation`.

___2D:___
The origin from the object will be moved to position `point`.\
The X-axis from the object is the arrow direction, it will be rotated into the vector of `direction`.

#### `place (points)` [^][contents]
[place]: #place-points-
Places the objects successively at the specified `points` in the list.\
Object 1 set to point 1, object 2 set to point 2, and so on.

#### `place_line (direction, distances)` [^][contents]
[place_line]: #place_line-direction-distances-
Places the objects successively onto a line at the specified distances in the list.
- `direction` - direction of the line
- `distances`
  - distances as a list
    place the specific objects at given distance in a list
  - distances as a numeric value
    place all objects at this distance

There exist specialized modules which places objects along a fixed axis at the specified distances.\
`place_? (distances)`\
'?' means the axis. Axis = x, y or z.

#### `place_copy (points)` [^][contents]
[place_copy]: #place_copy-points-
Places copies of an object at given `points` in the list.\

#### `place_copy_line (direction, distances)` [^][contents]
[place_copy_line]: #place_copy_line-direction-distances-
Places copies of an objects onto a line at given distances in the list.
- `direction` - direction of the line
- `distances` - distances as a list

There exist specialized modules which places copies of an object along a fixed axis at given distances.\
`place_copy_? (distances)`\
'?' means the axis. Axis = x, y or z.


Edit and test objects [^][contents]
-----------------------------------

...

