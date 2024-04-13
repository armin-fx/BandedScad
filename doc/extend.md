Control the level of detail of a mesh
=====================================

### defined in file

`banded/extend.scad`  
` `|  
` `+--> `banded/extend_logic.scad`  
` `| . . . . +--> `banded/extend_logic_helper.scad`  
` `| . . . . +--> `banded/extend_logic_circle.scad`  
` `| . . . . +--> `banded/extend_logic_linear_extrude.scad`  
` `+--> `banded/extend_object.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Contents"
- [Extra special variables](#special-variables-)
- [Defined modules](#defined-modules-)
  - [Extra arguments](#extra-arguments-)
  - [Modules controlled with extra special variables](#modules-controlled-with-extra-special-variables-)
    - [`circle_extend()`][circle_extend]
    - [`cylinder_extend()`][cylinder_extend]
    - [`sphere_extend()`][sphere_extend]
  - [Modules with extra arguments only ](#modules-with-extra-arguments-only-)
    - [`square_extend()`][square_extend]
    - [`cube_extend()`][cube_extend]
    - [`linear_extrude_extend()`][linear_extrude_extend]
    - [`rotate_extrude_extend()`][rotate_extrude_extend]
- [Functions](#functions-)
  - [Convert values](#convert-values-)
    - [`get_angle_from_percent()`][get_angle_from_percent]
  - [Get fragments of a circle](#get-fragments-of-a-circle-)
    - [Recurring arguments](#recurring-arguments-)
    - [`get_slices_circle_current()`][get_slices_circle_current]
    - [`get_slices_circle_current_x()`][get_slices_circle_current_x]
    - [`get_slices_circle_closed()`][get_slices_circle_closed]
    - [`get_slices_circle_closed_x()`][get_slices_circle_closed_x]
    - [`get_slices_circle()`][get_slices_circle]
    - [`get_slices_circle_x()`][get_slices_circle_x]
    - [`get_fn_circle()`][get_fn_circle]
  - [Internal use](#internal-use-)
    - [`is_sf_activated()`][is_sf_activated]
    - [`is_sf_enabled()`][is_sf_enabled]
    - [`if_sf_value()`][if_sf_value]
    - [`sf_safe()`][sf_safe]
    - [`sf_constrain_minmax()`][sf_constrain_minmax]

[align]:     #extra-arguments-
[special_x]: #special-variables-
[circle_curve]: draft_curves.md#circle-
[circle]:   https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_the_2D_Subsystem#circle
[cylinder]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#cylinder
[sphere]:   https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#sphere


Special variables [^][contents]
-------------------------------

The _buildin special variables_ in OpenSCAD `$fa`, `$fs` and `$fn`
control the number of facets to generate an arc.
This library contains _extra special variables_ and _functions_ to control the level of detail
and defines modules to extend the buildin objects like `circle()` and `cylinder()`.

| buildin variable | description
|------------------|-------------
| `$fa`            | Minimum angle (in degrees) of each fragment
| `$fs`            | Minimum circumferential length of each fragment
| `$fn`            | Fixed number of fragments in 360 degrees. Values of 3 or more override `$fa` and `$fs`.

By default all _extra special variables_ are set off to keep compatibility with
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

If you want define the maximum deviation from the model in percent,
you can do this with the _buildin special variable_ `$fa`.
The angle for a fragment is equivalent to distance of deviation in percent.  
You can convert this with function [`get_angle_from_percent()`][get_angle_from_percent]:
```OpenSCAD
$fa = get_angle_from_percent (2); // 2% deviation
```


Defined modules [^][contents]
-----------------------------
Keep compatibility with _buildin modules_ in OpenSCAD with same arguments and can controlled
with _extra special variables_, some modules have extra arguments.

| buildin                  | extended
|--------------------------|----------
| [`circle()`][circle]     | [`circle_extend()`][circle_extend]
| [`cylinder()`][cylinder] | [`cylinder_extend()`][cylinder_extend]
| [`sphere()`][sphere]     | [`sphere_extend()`][sphere_extend]


##### Extra arguments: [^][contents]
- `align`
  - Side from origin away that the part should be.
    It will set as a vector.
    Every axis can set with a value `-1...0...1`.
    - `1` means for example the object will set into the positive side
      of this axis and touch origin.
    - `0` means this axis of the object is centered
  - You can set a numeric value, then all axis will set to this align value.
  - If the module has an argument `center`:
    Specifying `align` replaces specifying `center`,
    `center` is then ignored.


### Modules controlled with extra special variables [^][contents]

#### circle_extend [^][contents]
[circle_extend]: #circle_extend-
Creates a circle with [options of `circle_curve()`][circle_curve]

_Arguments:_
```OpenSCAD
circle_extend (r, angle, slices, piece, outer, align, d)
```
- `r, d`
  - radius or diameter of circle
- `angle`
  - drawed angle in degrees, default=`360`
    - as number -> angle from `0` to `angle` = opening angle
    - as list   -> range `[opening angle, begin angle]`
- `slices`
   - count of segments, without specification it gets the same like `circle()`
   - with `"x"` includes the [extra special variables][special_x]
     to automatically control the count of segments
   - if an angle is specified, the circle section keeps the count of segments.
     Elsewise with `$fn` the segment count scale down to the circle section,
     the behavior like in `rotate_extrude()` to keep the desired precision.
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenSCAD
  - `false` - connect the ends of the circle,
            - generate an extra edge if count of segments is too small
  - `0`     - curve only, no extra edges if "circle is only a line", default
- `outer`
  - value `0`...`1`
    - `0` - edges on real circle line, default like `circle()` in OpenSCAD
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle
  - the problem is described in website
    <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects>
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0]` = centered

#### cylinder_extend [^][contents]
[cylinder_extend]: #cylinder_extend-
Creates a cylinder with ground circle [options of `circle_curve()`][circle_curve].

_Arguments:_
```OpenSCAD
cylinder_extend (h, r1, r2, center, r, d, d1, d2, angle, slices, piece, outer, align)
```
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0,1]` = X-Y-axis centered

#### sphere_extend [^][contents]
[sphere_extend]: #sphere_extend-
Creates a sphere at moment only control with extra special variables.

_Arguments:_
```OpenSCAD
sphere_extend (r, d, outer, align)
```
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0,0]` = centered
- `outer`
  - value `0`...`1`
    - `0` - edges on real sphere surface, default like `sphere()` in OpenSCAD
    - `1` - each face on real sphere surface
    - any value between, such as `0.5` = middle around inner or outer sphere
  - the problem is described in website
    <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects>


### Modules with extra arguments only [^][contents]

#### square_extend [^][contents]
[square_extend]: #square_extend-
Creates a square with extra arguments.

_Arguments:_
```OpenSCAD
square_extend (size, center, align)
```
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1]` = oriented on the positive side of axis

#### cube_extend [^][contents]
[cube_extend]: #cube_extend-
Creates a cube with extra arguments.

_Arguments:_
```OpenSCAD
cube_extend (size, center, align)
```
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1,1]` = oriented on the positive side of axis

#### linear_extrude_extend [^][contents]
[linear_extrude_extend]: linear_extrude_extend-
Extend `linear_extrude_extend()` with extra arguments.

_Additional options:_
```OpenSCAD
linear_extrude_extend (height, center, twist, slices, scale, align, convexity)
```
- `align`
  - Side from origin away that the part should be.
    Configures only the Z-Axis, all other axis will be ignored.
  - [Extra arguments- align][align]

#### rotate_extrude_extend [^][contents]
[rotate_extrude_extend]: #rotate_extrude_extend-
Modifies `rotate_extrude()`.  
Objects created with `rotate_extrude()` are rotated differently
as e.g. the object `cylinder()`.
With `rotate_extrude_extend()` these objects can be connected correctly.

_Additional options:_
```OpenSCAD
rotate_extrude_extend (angle, slices, convexity)
```
- `angle` - drawn angle in degree, default=`360`
  - as number -> angle from `0` to `angle` = opening angle
  - as list   -> range `[opening angle, begin angle]`
- `slices`
   - count of segments, optional
   - if an angle is specified, the circle section keeps the count of segments.
     Elsewise with `$fn` the segment count scale down to the circle section,
     the behavior like in `rotate_extrude()` to keep the desired precision.

_Example:_
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
in percent to set value in _buildin special variable_ `$fa`.  
The angle for a fragment is equivalent to distance of deviation in percent.

_Usage:_
```OpenSCAD
$fa = get_angle_from_percent (2); // 2% deviation
```


### Get fragments of a circle [^][contents]

#### Function name convention: [^][contents]
- function name _without_ ending `_x` return a value with original OpenSCAD behavior
- function name _with_ ending `_x` return a value with control of the _extra special variables_

#### Recurring arguments: [^][contents]
_Values:_
- `r`     - radius of a circle
- `angle` - opening angle of a part of a circle in degrees
- `piece` - control the look of the part of a circle [-> see options of `circle_curve()`][circle_curve]

_Control the fragment count of a circle (buildin):_
- `fn` - like `$fn`, fixed number of fragments
- `fa` - like `$fa`, minimum angle (in degrees) of each fragment
- `fs` - like `$fs`, minimum circumferential length of each fragment

_Control the fragment count of a circle (extend):_
- `fn_min` - like `$fn_min` , minimum number of fragments
- `fn_max` - like `$fn_max` , maximum number of fragments
- `fd`     - like `$fd`, maximum distance of deviation from model in mm
- `fa_enabled` - like `$fa_enabled`, `fa` can be disabled with `false`
- `fs_enabled` - like `$fs_enabled`, `fs` can be disabled with `false`
- `fn_safe`    - like `$fn_safe`

#### get_slices_circle_current [^][contents]
[get_slices_circle_current]: #get_slices_circle_current-
Returns the number of fragment on a _part of_ a circle
with the current _buildin special variables_ `$fn`, `$fa` and `$fs`.

_Arguments:_
```OpenSCAD
get_slices_circle_current (r, angle, piece)
```

#### get_slices_circle_current_x [^][contents]
[get_slices_circle_current_x]: #get_slices_circle_current_x-
Returns the number of fragment on a _part of_ a circle
with the current _buildin special variables_ `$fn`, `$fa` and `$fs`,
and the _extra special variables_ `$fn_min`, `$fn_max`, `$fd`, `$fa_enabled`, `$fs_enabled`.

_Arguments:_
```OpenSCAD
get_slices_circle_current_x (r, angle, piece)
```

#### get_slices_circle_closed [^][contents]
[get_slices_circle_closed]: #get_slices_circle_closed-
Returns the number of fragment on a _closed_ circle
with arguments based on the _buildin special variables_.  
Original OpenSCAD function.

_Arguments:_
```OpenSCAD
get_slices_circle_closed (r, fn, fa, fs)
```

#### get_slices_circle_closed_x [^][contents]
[get_slices_circle_closed_x]: #get_slices_circle_closed_x-
Returns the number of fragment on a _closed_ circle
with arguments based on the _extra special variables_.

_Arguments:_
```OpenSCAD
get_slices_circle_closed_x (r, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled)
```

#### get_slices_circle [^][contents]
[get_slices_circle]: #get_slices_circle-
Returns the number of fragment on a _part of_ a circle
with arguments based on the _buildin special variables_.  
Based on the behavior of rotate_extrude() in OpenSCAD.

_Arguments:_
```OpenSCAD
get_slices_circle (r, angle, piece, fn, fa, fs)
```

#### get_slices_circle_x [^][contents]
[get_slices_circle_x]: #get_slices_circle_x-
Returns the number of fragment on a _part of_ a circle
with arguments based on the _extra special variables_.

_Arguments:_
```OpenSCAD
get_slices_circle_x (r, angle, piece, fn, fa, fs, fn_min, fn_max, fd, fa_enabled, fs_enabled)
```

#### get_fn_circle` [^][contents]
[get_fn_circle]: #get_fn_circle-
Returns the number for `$fn` if a fixed number of segments is desired.  
For e.g. rotate_extrude(), if an opening angle is specified,
the number of segments is divided internally to keep the desired precision.
This function calculate the value for `$fn`, so the object gets
the real number of segments for the opening angle.

_Arguments:_
```OpenSCAD
get_fn_circle (slices, angle)
```


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
Returns the limit of a fragment number `n` between `$fn_min` and `$fn_max`.  
Depends on whether these limits are enabled.

