
Control the level of detail of a mesh
=====================================

### defined in file

`banded/extend.scad`\
` `| \
` `+--> `banded/extend_logic.scad`\
` `+--> `banded/extend_object.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Contents"
[Extra special Variables](#special-variables-)\
[Defined modules](#defined-modules-)\
[Functions](#functions-)


Special variables [^][contents]
-------------------------------

The buildin special variables in OpenScad `$fa`, `$fs` and `$fn` special variables
control the number of facets used to generate an arc.
This library contains extra special variables and functions to control the level of detail
and defines modules to extend the buildin objects like `circle()` and `cylinder()`.

| variable | description
|----------|-------------
| `$fa`    | Minimum angle (in degrees) of each fragment
| `$fs`    | Minimum circumferential length of each fragment
| `$fn`    | Fixed number of fragments in 360 degrees. Values of 3 or more override `$fa` and `$fs`.

By default all extra special variables are set off to keep compatibility with
original functionality from OpenSCAD.
If `$fn` is defined, this value will be used and the other variables are ignored,
and a full circle is rendered using this number of fragments.
Variables can set off with `0`.

| variable      | description
|---------------|-------------
| `$fn_min`     | Number of fragments which will never lesser then this value
| `$fn_max`     | Number of fragments which will never bigger then this value
| `$fd`         | Maximum distance of deviation from model, distance in mm which will not exceeded
| `$fa_enabled` | `$fa` can be switch off when set with `false`
| `$fs_enabled` | `$fs` can be switch off when set with `false`
| `$fn_safe`    | If all special variables are off, this number of fragments will be used. standard = `12`


Defined modules [^][contents]
-----------------------------
Keep compatibility with buildin modules in OpenScad with same arguments and can controlled
with extra special variables, some modules have extra arguments

| buildin      | extended
|--------------|----------
| `circle()`   | `circle_extend()`
| `cylinder()` | `cylinder_extend()`
| `sphere()`   | `sphere_extend()`

#### `circle_extend()` [^][contents]
Creates a circle with [options of `circle_curve()`](draft.md#circle-)

#### `cylinder_extend()` [^][contents]
Creates a cylinder with ground circle [options of `circle_curve()`](draft.md#circle-)

#### `sphere_extend()` [^][contents]
Creates a sphere at moment only control with extra special variables.


Functions [^][contents]
-----------------------

#### `get_angle_from_percent (value)` [^][contents]
Get the minimum angle for a fragment from maximum distance of deviation
in percent to set value in special variable `$fa`


Functions internal [^][contents]
--------------------------------

...
