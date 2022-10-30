Draft objects as data list - Curves
===================================

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_curves.scad`\
` `| \
` `. . .

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Creates curves in a point list](#curves-)
  - [Bezier curve](#bezier-curve-)
  - [Circle](#circle-)
  - [Superellipse](#superellipse-)
  - [Superformula](#superformula-)
  - [Polynomial function](#polynomial-function-)
  - [Square](#square-)
  - [Helix](#helix-)
- [Creates fractal curves](#fractal-curves-)
  - [Koch curve](#koch-curve-)
  - [Hilbert curve](#hilbert-curve-)
  - [Dragon curve](#dragon-curve-)


Curves [^][contents]
--------------------
Creates curves in a point list

There is a name convention of functions from curves:
- Name of curve type with ending `_point` - creates a point of the curve at given position.\
  such as `circle_point()`
- Name of curve type with ending `_curve` - creates a curve with given parameters.\
  such as `circle_curve()`


### Bezier curve [^][contents]
Generates a Bézier curve.\
[=> Wikipedia - Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)

#### `bezier_point (t, p, n)` [^][contents]
Returns a point of a Bézier curve of the n'th degree depending on the parameters.

__Options:__
- `t`
  - a numeric value between `0`...`1`
- `p`
  - `[p0, ..., pn]` - list with control points
  - `p0` - first point of the curve, `pn` - last point of the curve
  - The array cannot contain fewer than `n+1` elements
- `n`
  - Specify of the degree of the Bézier curve
  - only the points up to `p[n]` are taken
  - if `n` is not specified, the degree is taken based on the size of the list

#### `bezier_curve (p, n, slices)` [^][contents]
Return a list with the points of a Bézier curve

__Options:__
- `t`
  - a numeric value between `0`...`1`
- `p`
  - `[p0, ..., pn]` - list with control points
  - `p0` - first point of the curve, `pn` - last point of the curve
  - The array cannot contain fewer than `n+1` elements
- `n`
  - Specify of the degree of the Bézier curve
  - only the points up to `p[n]` are taken
  - if `n` is not specified, the degree is taken based on the size of the list
- `slices`
  - Bézier curve is sliced in fragments into this number of points, at least 2 points
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken (roughly implemented)
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used  (roughly implemented)

#### `bezier_1 (t, p)` [^][contents]
Return a point of a Bézier curve with 1'st degree (linear Bézier curve)
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, p1]` - list with 2 control points
  - `p0` - first point of the curve, `p1` - last point of the curve

#### `bezier_2 (t, p)` [^][contents]
Return a point of a Bézier curve with 2'st degree (quadratic Bézier curve)
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, p1, p2]` - list with 3 control points
  - `p0` - first point of the curve, `p2` - last point of the curve

#### `bezier_3 (t, p)` [^][contents]
Return a point of a Bézier curve with 3'st degree (cubic Bézier curve)
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, p1, p2, p3]` - list with 4 control points
  - `p0` - first point of the curve, `p3` - last point of the curve

#### `bezier_4 (t, p)` [^][contents]
Return a point of a Bézier curve with 4'st degree
- `t` - a numeric value between `0`...`1`
- `p`
  - `[p0, ... , p4]` - list with 5 control points
  - `p0` - first point of the curve, `p4` - last point of the curve


### Circle [^][contents]
Generates a circle.

#### `circle_point (r, angle, d)` [^][contents]
Returns a 2d point of a circle with center at origin.\
Turns at mathematical direction of rotation = counter clockwise.

__Options:__
- `r, d`
  - radius or diameter of circle
- `angle`
  - point at given angle

#### `circle_curve (r, angle, slices, piece, outer, align, d)` [^][contents]
Return a 2d point list of a circle.

__Options:__
- `r, d`
  - radius or diameter of circle
- `angle`
  - drawed angle in degrees, default=`360`
    - as number -> angle from `0` to `angle` = opening angle
    - as list   -> range `[opening angle, begin angle]`
- `slices`
   - count of segments, without specification it gets the same like `circle()`
   - with `"x"` includes the [extra special variables](extend.md#special-variables-)
     to automatically control the count of segments
   - if an angle is specified, count of segments is like in `rotate_extrude()`
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
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align](extend.md#extra-arguments-)
  - default = `[0,0]` = centered


### Superellipse [^][contents]
Generates a Superellipse curve.\
[=> Wikipedia - Superellipse](https://en.wikipedia.org/wiki/Superellipse)

Example of Piet Hein's Superegg:
```OpenSCAD
include <banded.scad>

$fn=60;

rotate_extrude ()
polygon (
	superellipse_curve (interval=[-90,90], n=2.5, a=[3,4]) );
```

#### `superellipse_point (t, r, a, n, s)` [^][contents]
Return a point from a superellipse curve

__Options:__
- `t`
  - position of the point from `0`...`360`
- `r`
  - radius
- `a`
  - controls the width ratio of the respective axes
    - as number = every axis gets the same factor
    - as list   = every axis gets his own factor `[X,Y]`
    - default   = `[1,1]`
- `n`
  - order of the curve, controls the shape of the curve
    - as number = every axis gets the same parameter
    - as list   = every axis gets his own parameter `[X,Y]`
- `s`
  - parameter "superness", controls the shape of the curve, optional
  - If n is specified, s is ignored
    - as number = every axis gets the same parameter
    - as list   = every axis gets his own parameter `[X,Y]`

#### `superellipse_curve (interval, r, a, n, s, slices, piece)` [^][contents]
Return a list with the points of a superellipse

__Additional options:__
- `interval`
  - interval limit of `t`. `[begin, end]`
- `slices`
  - the curve is sliced in fragments into this number of points, at least 2 points
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenSCAD
  - `false` - connect the ends of the circle
  - `0`     - to work on, ends not connected, no edges, default


### Superformula [^][contents]
Generates a Superformula curve.\
[=> Wikipedia - Superformula](https://en.wikipedia.org/wiki/Superformula)

#### `superformula_point (t, a, m, n)` [^][contents]
Return a point from a superformula curve

__Options:__
- `t`
  - position of the point (angle) from `0`...`360`
- `a`
  - controls the width ratio of the respective axes
  - as number = every axis gets the same factor
  - as list   = every axis gets his own factor `[X,Y]`
  - default   = `[1,1]`
- `m`
  - symmetry
  - as number = every axis gets the same factor
  - as list   = every axis gets his own factor `[X,Y]`
  - default   = `[1,1]`
- `n`
  - Curve, controls the curve form
  - list with 3 parameter `[n1, n2, n3]`

#### `superformula_curve (interval, a, m, n, slices, piece)` [^][contents]
Return a list with the points of a superformula

__Additional options:__
- `interval`
  - interval limit of `t`. `[begin, end]`
- `slices`
  - the curve is sliced in fragments into this number of points, at least 2 points
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenSCAD
  - `false` - connect the ends of the circle
  - `0`     - to work on, ends not connected, no edges, default


### Polynomial function [^][contents]
`P(x) = a[0] + a[1]*x + a[2]*x^2 + ... + a[n]*x^n`\
[=> Wikipedia - Polynomial](https://en.wikipedia.org/wiki/Polynomial)

#### `polynomial (x, a, n)` [^][contents]
Return a numeric value from the polynomial function

__Options:__
- `x`
  - variable
- `a`
  - list with the coefficients
- `n`
  - Degree of the polynomial, only as many coefficients as specified are used
  - If not specified, the degree is taken according to the size of the array of coefficients

#### `polynomial_curve (interval, a, n, slices)` [^][contents]
Returns a list with the points of a polynomial interval

__Additional options:__
- `interval`
  - Interval limit from `x`. `[begin, end]`
- `slices`
  - Number of points in the interval


### Square [^][contents]

#### `square_curve (size, center, align)` [^][contents]
Return a 2D square as point list.
Options are like module `square()` from OpenSCAD.
Rotation is mathematical direction = counter clockwise.
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align](extend.md#extra-arguments-)
  - default = `[1,1]` = oriented on the positive side of axis


### Helix [^][contents]
[=> Wikipedia - Helix](https://en.wikipedia.org/wiki/Helix)

#### `helix_curve (r, rotations, pitch, height, opposite, slices, angle)` [^][contents]
Return a helix as point list.

__Options:__
- `r`
  - radius as number oder as list with numbers `[r1, r2]`
  - `r1` = bottom radius, `r2` = top radius
- `rotations`
  - count of the rotations
- `angle`
  - count of the rotations as angle in degree
  - replaces `rotations` if set
- `pitch`
  - height difference per rotation
- `height`
  -  height of the helix
- `opposite`
  - if `true` the opposite direction of rotation is used
  - default = `false`
- `slices`
  - count of segments per rotation
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken
  - With `"x"` includes the extra special variables to automatically control the count of segments

__Required options:__
- radius `r`
- only 2 arguments each: `pitch`, `rotations` or `height`


Fractal curves [^][contents]
----------------------------

### Koch curve [^][contents]

#### `koch_curve (trace, iteration, closed)` [^][contents]
Generates a Koch curve on a line defined in `trace`.\
[=> Wikipedia - Koch snowflake](https://en.wikipedia.org/wiki/Koch_snowflake)

__Options:__
- `trace`
  - a point list
- `iteration`
  - defines the nested iteration of the curve
  - default = 1 = one step
- `closed`
  - `true`  - for a closed trace = the end point is connected with the begin point
  - `false` - default, a line with open ends

__Example:__
```OpenSCAD
include <banded.scad>

iteration = 3;

// Triangle
trace = [
	[0  ,0],
	[1  ,0],
	[0.5,-sqrt(3)/2]
];

// Koch snowflake
polygon (
	koch_curve (trace * 10, iteration, closed=true) );
```


### Hilbert curve [^][contents]

#### `hilbert_curve (r, iteration)` [^][contents]
Generates a trace of a Hilbert curve.\
[=> Wikipedia - Hilbert curve](https://en.wikipedia.org/wiki/Hilbert_curve)

__Options:__
- `r`
  - the radius of the square which is filled with the hilbert curve
- `iteration`
  - defines the nested iteration of the curve
  - default = 1 = one step

__Example:__
```OpenSCAD
include <banded.scad>

iteration = 4;
r = 10;

show_trace (
	hilbert_curve (r, iteration)
	, c="green", d=r/pow(2,iteration) );
```

### Dragon curve [^][contents]

#### `dragon_curve (trace, iteration)` [^][contents]
Generates a trace of a Dragon curve.\
[=> Wikipedia - Dragon curve](https://en.wikipedia.org/wiki/Dragon_curve)

__Options:__
- `trace`
  - a point list with the initial line
- `iteration`
  - defines the nested iteration of the curve
  - default = 1 = one step

__Example:__
```OpenSCAD
include <banded.scad>

iteration=8;

a = dragon_curve ([[0,0], [20,0]], iteration);
show_trace (a, c="blue", d=8/pow(2,iteration/2));
```

