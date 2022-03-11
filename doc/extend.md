Control the level of detail of a mesh
=====================================

### defined in file

`banded/extend.scad`\
` `| \
` `+--> `banded/extend_logic.scad`\
` `+--> `banded/extend_object.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Contents"
- [Extra special variables](#special-variables-)
- [Defined modules](#defined-modules-)
  - [Extra arguments](#extra-arguments-)
  - [Modules controlled with extra special variables](#modules-controlled-with-extra-special-variables-)
    - [`circle_extend()`][circle]
    - [`cylinder_extend()`][cylinder]
    - [`sphere_extend()`][sphere]
  - [Modules with extra arguments only ](#modules-with-extra-arguments-only-)
    - [`square_extend()`][square]
    - [`cube_extend()`][cube]
    - [`rotate_extrude_extend`][rotate_extrude_extend]
- [Functions](#functions-)
  - [Convert values](#convert-values-)
    - [`get_angle_from_percent()`][get_angle_from_percent]
  - [Get fragments of a circle](#get-fragments-of-a-circle-)
    - [Recurring arguments](#recurring-arguments-)
    - [`get_fn_circle_current()`][get_fn_circle_current]
    - [`get_fn_circle_current_x()`][get_fn_circle_current_x]
    - [`get_fn_circle_closed()`][get_fn_circle_closed]
    - [`get_fn_circle_closed_x()`][get_fn_circle_closed_x]
    - [`get_fn_circle()`][get_fn_circle]
    - [`get_fn_circle_x()`][get_fn_circle_x]
  - [Internal use](#internal-use-)
    - [`is_sf_activated()`][is_sf_activated]
    - [`is_sf_enabled()`][is_sf_enabled]
    - [`if_sf_value()`][if_sf_value]
    - [`sf_safe()`][sf_safe]
    - [`sf_constrain_minmax()`][sf_constrain_minmax]


Special variables [^][contents]
-------------------------------

The buildin special variables in OpenSCAD `$fa`, `$fs` and `$fn` special variables
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
| `$fn_safe`    | If all special variables are off, this number of fragments will be used. default = `12`


Defined modules [^][contents]
-----------------------------
Keep compatibility with buildin modules in OpenSCAD with same arguments and can controlled
with extra special variables, some modules have extra arguments

| buildin      | extended
|--------------|----------
| `circle()`   | `circle_extend()`
| `cylinder()` | `cylinder_extend()`
| `sphere()`   | `sphere_extend()`


### Extra arguments [^][contents]
- `align`
  - Side from origin away that the part should be.
    It will set as a vector.
    Every axis can set with a value `-1...0...1`.
    - `1` means for example the object will set into the positive side
      of this axis and touch origin.
    - `0` means this axis of the object is centered
  - If the module has an argument `center`:
    Specifying `align` replaces specifying `center`,
    `center` is then ignored.


### Modules controlled with extra special variables [^][contents]

#### `circle_extend()` [^][contents]
[circle]: #circle_extend-
Creates a circle with [options of `circle_curve()`](curves.md#circle-)

#### `cylinder_extend()` [^][contents]
[cylinder]: #cylinder_extend-
Creates a cylinder with ground circle [options of `circle_curve()`](curves.md#circle-)
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align](#extra-arguments-)
  - default = `[0,0,1]` = X-Y-axis centered

#### `sphere_extend()` [^][contents]
[sphere]: #sphere_extend-
Creates a sphere at moment only control with extra special variables.
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align](#extra-arguments-)
  - default = `[0,0,0]` = centered


### Modules with extra arguments only [^][contents]

#### `square_extend (size, center, align)` [^][contents]
[square]: #square_extend-size-center-align-
Creates a square
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align](#extra-arguments-)
  - default = `[1,1]` = oriented on the positive side of axis

#### `cube_extend (size, center, align)` [^][contents]
[cube]: #cube_extend-size-center-align-
Creates a cube
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align](#extra-arguments-)
  - default = `[1,1,1]` = oriented on the positive side of axis

#### `rotate_extrude_extend (angle, convexity)` [^][contents]
[rotate_extrude_extend]: #rotate_extrude_extend-angle-convexity-
Modifies `rotate_extrude()`.\
Objects created with `rotate_extrude()` are rotated differently
as e.g. the object `cylinder()`.
With `rotate_extrude_extend()` these objects can be connected correctly.

___Additional options:___
- `angle` - drawn angle in degree, default=`360`
  - as number -> angle from `0` to `angle` = opening angle
  - as list   -> range `[opening angle, begin angle]`

___Example:___
```OpenSCAD
include <banded.scad>
$fn=7;

cylinder (r=2, h=1);
%rotate_extrude_extend() square([2, 1.5]);
#rotate_extrude()        square([2, 2]);
```


Functions [^][contents]
-----------------------

### Convert values [^][contents]

#### `get_angle_from_percent (value)` [^][contents]
[get_angle_from_percent]: #get_angle_from_percent-value-
Get the minimum angle for a fragment from maximum distance of deviation
in percent to set value in special variable `$fa`.
Angle for a fragment is equivalent to distance of deviation in percent.


### Get fragments of a circle [^][contents]

#### Function name convention: [^][contents]
- function name _without_ ending `_x` return a value with original OpenSCAD behavior
- function name _with_ ending `_x` return a value with control of the extra special variables

#### Recurring arguments: [^][contents]

Values:
- `r`     - radius of a circle
- `angle` - opening angle of a part of a circle in degrees
- `piece` - control the look of the part of a circle [-> see options of `circle_curve()`](curves.md#circle-)

Control the fragment count of a circle (buildin):
- `fn` - like `$fn`, fixed number of fragments
- `fa` - like `$fa`, minimum angle (in degrees) of each fragment
- `fs` - like `$fs`, minimum circumferential length of each fragment

Control the fragment count of a circle (extend):
- `fn_min` - like `$fn_min` , minimum number of fragments
- `fn_max` - like `$fn_max` , maximum number of fragments
- `fd`     - like `$fd`, maximum distance of deviation from model in mm
- `fa_enabled` - like `$fa_enabled`, `fa` can be disabled with `false`
- `fs_enabled` - like `$fs_enabled`, `fs` can be disabled with `false`
- `fn_safe`    - like `$fn_safe`

#### `get_fn_circle_current (r, angle, piece)` [^][contents]
[get_fn_circle_current]: #get_fn_circle_current-r-angle-piece-
Returns the number of fragment on a part of a circle
with the current _buildin special variables_ `$fn`, `$fa` and `$fs`.

#### `get_fn_circle_current_x (r, angle, piece)` [^][contents]
[get_fn_circle_current_x]: #get_fn_circle_current_x-r-angle-piece-
Returns the number of fragment on a part of a circle
with the current _buildin special variables_ `$fn`, `$fa` and `$fs`,
and the _extra special variables_ `$fn_min`, `$fn_max`, `$fd`, `$fa_enabled`, `$fs_enabled`.

#### `get_fn_circle_closed (r, fn, fa, fs)` [^][contents]
[get_fn_circle_closed]: #get_fn_circle_closed-r-fn-fa-fs-
Returns the number of fragment on a closed circle
with the _buildin special variables_.\
Original OpenSCAD function.

#### `get_fn_circle_closed_x (r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled)` [^][contents]
[get_fn_circle_closed_x]: #get_fn_circle_closed_x-r-fn-fa-fs-fn_min-fn_max-fd-fa_enabled-fs_enabled-
Returns the number of fragment on a closed circle
with the _extra special variables_.

#### `get_fn_circle (r, angle, piece, fn, fa, fs)` [^][contents]
[get_fn_circle]: #get_fn_circle-r-angle-piece-fn-fa-fs-
Returns the number of fragment on a part of a circle
with the _buildin special variables_.\
Based on the behavior of rotate_extrude() in OpenSCAD.

#### `get_fn_circle_x (r, angle, piece, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled)` [^][contents]
[get_fn_circle_x]: #get_fn_circle_x-r-angle-piece-fn-fa-fs-fn_min-fn_max-fd-fa_enabled-fs_enabled-
Returns the number of fragment on a part of a circle
with the _extra special variables_.


### Internal use [^][contents]

#### `is_sf_activated (fn_base)` [^][contents]
[is_sf_activated]: #is_sf_activated-fn_base-
Returns whether a special variable `$fxxx` is activated.

#### `is_sf_enabled (fn_base_enabled)` [^][contents]
[is_sf_enabled]: #-is_sf_enabled-fn_base_enabled-
Returns the status of an extra special variable `$fxxx_enabled`.
- if set `true`  - special variable `$fxxx` is activated, default if undefined
- if set `false` - special variable `$fxxx` is deactivated

#### `if_sf_value (base, n, safe)` [^][contents]
[if_sf_value]: #if_sf_value-base-n-safe-
Returns fragment count `n` if special variable `$fxxx` (specified in `base`) is activated,
else a security value is returned.
- `safe` - optional, can set a security value, default = value from `$fn_safe`

#### `sf_safe ()` [^][contents]
[sf_safe]: #sf_safe-
Returns the current value from `$sf_safe`.

#### `sf_constrain_minmax (fn_min, fn_max, n)` [^][contents]
[sf_constrain_minmax]: #sf_constrain_minmax-fn_min-fn_max-n-
Returns the limit of a fragment number `n` between `$fn_min` and `$fn_max`.\
Depends on whether these limits are enabled.

