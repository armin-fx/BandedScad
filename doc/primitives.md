Draft objects as data list - Primitives
=======================================

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_primitives.scad`\
` `| . . . . +--> `banded/draft_primitives_basic.scad`\
` `| . . . . +--> `banded/draft_primitives_figure.scad`\
` `| . . . . +--> `banded/draft_primitives_transform.scad`\
` `. . .

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Primitives in data lists](#primitives-)
  - [List convention](#list-convention-)
  - [Generate objects](#functions-to-generate-objects-)
    - buildin OpenSCAD primitives
    - more primitives
  - [Functions to transform objects](#functions-to-transform-objects-)
    - [From OpenSCAD buildin modules](#functions-from-openscad-buildin-modules-)
    - [More functions to transform objects](#more-functions-to-transform-objects-)
  - [Functions to edit objects](#functions-to-edit-objects-)
    - [`linear_extrude_points()`][linear_extrude_points]
    - [`rotate_extrude_points()`][rotate_extrude_points]
    - [`helix_extrude_points()`][helix_extrude_points]


Primitives [^][contents]
------------------------
Functions to create and edit OpenSCAD primitives in lists

These list can set as argument for `polygon()` and `polyhedron()`,
this is implemented in module `build_object()`.
This functions to generate and transform objects have the same behavior
like OpenSCAD modules.

#### List convention [^][contents]
- default:
  - `[ points, [path, path2, ...], color ]`
- other:
  - `[ points ]`
  - `[ points, path ]`
  - `[ [points, points2, ...], [path, path2, ...] ]`
- color:
  - color as list in `[red, green, blue]` or `[red, green, blue, alpha]`
  - color entry as value between `0...1`, where
    - `0` = dark
    - `1` = bright

### Functions to generate objects [^][contents]
- 2D:
  - [`square()`](extend.md#square_extend-size-center-align-)
  - [`circle()`](extend.md#circle_extend-r-angle-slices-piece-outer-align-d-)
- 3D:
  - [`cube()`](extend.md#square_extend-size-center-align-)
  - [`cylinder()`](extend.md#cylinder_extend-h-r1-r2-center-r-d-d1-d2-angle-slices-piece-outer-align-)
  - [`sphere()`](extend.md#sphere_extend-r-d-align-)
- more objects:
  - [`wedge()`](object.md#wedge-v_min-v_max-v2_min-v2_max-)
  - [`torus()`](object.md#torus-r-w-ri-ro-angle-center-fn_ring-align-)
  - [`ring_square()`](object.md#ring_square-h-r-w-ri-ro-angle-center-d-di-do-align-)
  - [`funnel()`](object.md#funnel-h-ri1-ri2-ro1-ro2-w-angle-di1-di2-do1-do2-align-)

___example:___
```OpenSCAD
include <banded.scad>

a = cylinder (h=10, r=4);
b = translate (a, v=[10,0,0]);
c = color (b, "yellowgreen");

build_object(a);
build_object(c);
```


### Functions to transform objects [^][contents]
Argument convention:
- `transform_function (object, transform_arguments)`

#### Functions from OpenSCAD buildin modules [^][contents]
- `translate (object, v)`
- `rotate    (object, a, v, backwards)`
- `mirror    (object, v)`
- `scale     (object, v)`
- `resize    (object, newsize)`
- `projection()` - not working yet, only on point lists
- `multmatrix(object, m)`
- `color     (object, c, alpha)`


#### More functions to transform objects [^][contents]
- All modules from file
  [`operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")
  as function.
  - In file `draft_primitives_transform.scad`.
  - Implemented:
    - `rotate_backwards    (object, a, v)`
    - `rotate_at           (object, a, p, v, backwards)`
    - `rotate_to_vector    (object, v, a, backwards, d)`
    - `rotate_to_vector_at (object, v, p, a, backwards)`
    - `mirror_at (object, v, p)`
    - `skew    (object, v, t, m, a, d)`
    - `skew_at (object, v, t, m, a, p, d)`
  - Not yet implemented:
    - `mirror_copy        (object, v)`
    - `mirror_copy_at     (object, v, p)`
    - `mirror_repeat      (object, v, v2, v3)`
    - `mirror_repeat_copy (object, v, v2, v3)`


### Functions to edit objects [^][contents]

#### `linear_extrude_points (list, height, center, twist, slices, scale)` [^][contents]
[linear_extrude_points]: #linear_extrude_points-list-height-center-twist-slices-scale-
Extrudes a 2D hull as trace in a point list to a 3D solid object.\
Uses the same arguments like `linear_extrude()` in OpenSCAD.
- `list` - 2D trace in a point list

#### `rotate_extrude_points (list, angle, slices)` [^][contents]
[rotate_extrude_points]: #rotate_extrude_points-list-angle-slices-
Rotational extrudes a 2D hull as trace in a point list
around the Z axis to a 3D solid object.\
Uses the same arguments like `rotate_extrude()` in OpenSCAD.
- `list` - 2D trace in a point list

#### `helix_extrude_points (angle, rotations, pitch, height, r, opposite, orientation, slices)` [^][contents]
[helix_extrude_points]: #helix_extrude_points-angle-rotations-pitch-height-r-opposite-orientation-slices-
Creates a helix with a 2D hull as trace similar rotate_extrude.
- `angle`     - angle of helix in degrees - default: `360`
- `rotations` - rotations of helix, can be used instead `angle`
- `height`    - height of helix - default: 0 like `rotate_extrude()`
- `pitch`     - rise per rotation
- `r`
  - radius as number or `[r1, r2]`
  - `r1` = bottom radius, `r2` = top radius
- `opposite`  - if `true` reverse rotation of helix, default = `false`
- `orientation`
  - if `true`, orientation of Y-axis from the 2D-polygon is set along the surface of the cone.
  - `false` = default, orientation of Y-axis from the 2D-polygon is set to Z-axis
- `slices`    - count of segments from helix per full rotation


. . .


### Not yet implemented, but planned [^][contents]
- `hull()`
- `minkowski()`

- `linear_extrude()`
  - but as function [`linear_extrude_points()`][linear_extrude_points]
    to create an object from a 2D trace in a point list.
- `rotate_extrude()`
  - but as function [`rotate_extrude_points()`][rotate_extrude_points]
    (and function `rotate_extrude_extend_points()`)
    to create an object from a 2D trace in a point list.

- `union()`
- `difference()`
- `intersection()`

### Not implemented [^][contents]
- `text()`
- `offset()`
