Configurable objects
====================

### defined in file
`banded/object.scad`\
` `| \
` `+--> `banded/object_figure.scad`\
` `+--> `banded/object_figure_rounded.scad`\
` `+--> `banded/object_rounded.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Figures](#figures-)
  - [`empty()`][empty]
  - [`wedge()`][wedge]
  - [`bounding_square()`][bounding_square]
  - [`bounding_cube()`][bounding_cube]
  - [`torus()`][torus]
  - [`ring_square()`][ring_square]
  - [`funnel()`][funnel]
- [Rounded edges](#rounded-edges-)
  - [Repeating options](#repeating-options-)
  - [Module name convention](#module-name-convention-)
  - [Module characteristic](#module-characteristic-)
  - [Cutting or adding parts for edges](#cutting-or-adding-parts-for-edges-)
    - [`edge_fillet()`][edge_fillet]
    - [`edge_ring_fillet()`][edge_ring_fillet]
    - [`edge_trace_fillet()`][edge_trace_fillet]
    - [`edge_fillet_plane()`][edge_fillet_plane]
    - [`edge_fillet_to()`][edge_fillet_to]
  - [Figures with rounded edges](#figures-with-rounded-edges-)
    - [`cube_rounded_full()`][cube_rounded_full]
    - [`cube_fillet()`][cube_fillet]
    - [`cylinder_rounded()`][cylinder_rounded]
    - [`cylinder_edges_fillet()`][cylinder_edges_fillet]
    - [`wedge_fillet()`][wedge_fillet]
    - [`square_fillet()`][square_fillet]
  - [Helper functions](#helper-functions-)
    - [`configure_edges()`][configure_edges]
    - [`configure_types()`][configure_types]
    - [`configure_corner()`][configure_corner]

[align]:     extend.md#extra-arguments-
[special_x]: extend.md#special-variables-
[cylinder_extend]:     extend.md#cylinder_extend-
[plain_trace_extrude]: operator.md#plain_trace_extrude-


Figures [^][contents]
---------------------
Modules to create configurable objects

#### empty [^][contents]
[empty]: #empty-
Module which create nothing.\
Useful if an operator needs an object.
```OpenSCAD
empty ()
```

#### wedge [^][contents]
[wedge]: #wedge-
Creates a wedge with the parameter form FreeCAD's wedge.
```OpenSCAD
wedge (v_min, v_max, v2_min, v2_max)
```
- `v_min`  = `[Xmin, Ymin, Zmin]`
- `v_max`  = `[Xmax, Ymax, Zmax]`
- `v2_min` = `[X2min, Z2min]`
- `v2_max` = `[X2max, Z2max]`

Location of the parameter:
```
           X2min X2max
             +-----+ Z2max
           / :    /|
        /    :   / | - - Ymax
 Zmax +---------+  |
      |      + -|- + Z2min
      |    ·    | /
      |  ·      |- - - - Ymin
      |.        |/
 Zmin +---------+
     Xmin      Xmax


   Z
   ^ .Y
   |/
   +--> X

```

#### bounding_square [^][contents]
[bounding_square]: #bounding_square-
Create a 2D rectangle around the outermost points from a list.
```OpenSCAD
bounding_square (points)
```
- `points`
  - a list with minimum 2 points

#### bounding_cube [^][contents]
[bounding_cube]: #bounding_cube-
Create a 3D cube around the outermost points from a list.\
```OpenSCAD
bounding_cube (points)
```
- `points`
  - a list with minimum 2 points

#### torus [^][contents]
[torus]: #torus-
Creates a torus.
```OpenSCAD
torus (r, w, ri, ro, angle, center, fn_ring, outer, align)
```

_Arguments:_
- `r`  - mean radius
- `ri` - inner radius
- `ro` - outside radius
- `w`  - width of the ring

_Must specify:_
- exactly 2 specifications of `r` or `r1` or `r2` or `w`

_More arguments:_
- `angle`   - opening angle of the torus in degree, default=`360`.
    Requires OpenSCAD version 2019.05 or above
- `center`  - center the torus in the middle (Z-axis) (if center=`true`)
- `fn_ring` - optional number of segments of the ring
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0,1]` = X-Y-axis centered
- `outer`
  - value `0`...`1`
    - `0` - edges on real circle line, default like `circle()` in OpenSCAD
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle
  - the problem is described in website
    <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects>
  - The tube circle will split in 2 parts.
    This has no effect if `outer` is set `0`.
    If `outer` is set `1`, the edges of the inner circle segment
    touch on the real surface and even the faces of the outer circle segment.
    Both circle parts differs a little and on the transition to both
    the object slightly differs from the real surface.

_Example:_
``` OpenSCAD
include <banded.scad>

r=6; w=8;
	color ("gold",0.5)
	       torus (r=r, w=w, $fn=500);
	color ("grey",0.5)
//	build( torus (r=r, w=w, outer=0.99, $fn=7) );
	       torus (r=r, w=w, outer=0.99, $fn=7) ;
```

#### ring_square [^][contents]
[ring_square]: #ring_square-
Creates a square ring.
```OpenSCAD
ring_square (h, r, w, ri, ro, angle, center, d, di, do, outer, align)
```
- `h`        - height
- `r`        - mean radius, middle line of the ring
- `ri`, `di` - inner radius, inner diameter
- `ro`, `do` - outside radius, outside diameter
- `w`        - width of the ring
- `angle`    - drawed angle in degree, default=`360`
  - as number = angle from `0` to `angle` = opening angle
  - as list   = `[opening angle, start angle]`
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0,1]` = X-Y-axis centered
- `outer`
  - value `0`...`1`
    - `0` - edges on real circle line, default like `circle()` in OpenSCAD
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle
  - or as list `[inner circle, outer circle]`
  - the problem is described in website
    <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects>

_Must specify:_
- `h`
- exactly 2 specifications of `r` or `ri` or `ro` or `w`

#### funnel [^][contents]
[funnel]: #funnel-
Creates a funnel.
```OpenSCAD
funnel (h, ri1, ri2, ro1, ro2, w, angle, di1, di2, do1, do2, align)
```
- `h`          - height
- `ri1`, `ri2` - inner radius bottom, top
- `ro1`, `ro2` - outer radius bottom, top
- `w`          - width of the wall. Optional
- `angle`
  - opening angle in degree of the funnel. Default=`360`.
  - requires OpenSCAD version 2019.05 or above
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[0,0,1]` = X-Y-axis centered
- `outer`
  - value `0`...`1`
    - `0` - edges on real circle line, default like `circle()` in OpenSCAD
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle
  - or as list `[inner circle, outer circle]`
  - the problem is described in website
    <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects>

Example:
```OpenSCAD
include <banded.scad>
$fn=24;

funnel (h=6, w=1, ri1=2, ri2=3);
translate ([0,0,6])
funnel (h=3, w=1, ri1=3, ri2=7);
translate ([0,0,9])
ring_square (h=0.5, w=1, ri=7);
```


Rounded edges [^][contents]
---------------------------

This section is split in 2 parts:
- Modules and functions to create different configurable edges to add or
  remove from objects.
- Existing modules which are extended with fillet edges.

#### Repeating options: [^][contents]

- `type`
  - describe the type of the fillet edge
    - as value: set the same type for all edges
    - as list:  set the chamfer types of the respective edge individually
  - chamfer types:
    - `0` = no chamfer (default)
    - `1` = rounding
    - `2` = chamfer
  - the count of edges depends on the figures
    - `cube()`   has 12 edges
    - `square()` has  4 edges
- `edges`
  - describe the parameter of the chamfer from each fillet edge,
    depending on the type
    - a numeric value set the same value for all edges
    - a list set the value of each respective edge individually
  - possible values for an edge:
    - `0`         = not chamfered
    - greater `0` = radius or width of the chamfered edge
  - the count of edges depends on the figures,
    the size and the positions of the respective edge in the list
    are the same like in parameter `type`
- `corner`
  - describe which corner should be chamfered
    - a numeric value set the same value for all corners
    - a list set the value of each respective edge individually
  - possible values for a corner:
    `0` = not chamfered
    `1` = chamfered
  - the count of corners depends on the figures
    - `cube()`   has 8 corners
    - `square()` has 4 corners

_Location of the edges specified on the lists_
_for example on a cube:_
```

    7 +---------+ 6
     /:        /|
  4 / :     5 / |
   +---------+  |
   |  + - - -|- +
   | · 3     | / 2
   |·        |/
   +---------+
  0          1


   Z
   ^ .Y
   |/
   +--> X

```
| name               | position of edges
|--------------------|-------------------
| _bottom_           | `[0-1, 1-2, 2-3, 3-0]`
| _top_              | `[4-5, 5-6, 6-7, 7-4]`
| _side_ or _around_ | `[0-4, 1-5, 2-6, 3-7]`
| corner, _bottom_   | `[0,   1,   2,   3]`
| corner, _top_      | `[4,   5,   6,   7]`

- `type` and `edges` are defined on a cube as a 12 element list:
  - the first 4 elements correspond to:  _bottom_ - all 4 edges at the bottom,      first edge begins at front
  - the following 4 elements correspond: _top_    - all 4 edges at the top,         first edge begins at front
  - the last 4 elements correspond to:   _around_ - all vertical edges on the side, first edge begins at front left
- `corner` is defined on a cube as a 8 element list:
  - the first 4 elements correspond to: _bottom_ - all 4 corner at the bottom, first corner begins at front left
  - the last 4 elements correspond to:  _top_    - all 4 corner at the top,    first corner begins at front left

#### Module name convention: [^][contents]
On modules with the name `_fillet` on the end you can
specify the type of the chamfer.\
But these modules have specialized derivation modules
with only one chamfer type.
- `xxx`         - base module
- `xxx_fillet`  - edges can specified with option `type`
- `xxx_rounded` - with rounded edges
- `xxx_chamfer` - with chamfered edges

#### Module characteristic: [^][contents]
List of characteristic behavior of modules with fillet edges:
- The base module is shown by default, the edges must extra set
  - The type of the edge is set by default to _no fillet edge_.
  - If the edge type is set, all edges have the size `0`, means they are unset.
  - You can define every edge size specially with the parameter `edge`


### Cutting or adding parts for edges [^][contents]

#### edge_fillet [^][contents]
[edge_fillet]: #edge_fillet-
Creates a fillet edge, used for cutting or adding to edges.\
Optionally rounded or chamfered.
It does `linear_extrude()` with module [`edge_fillet_plane()`][edge_fillet_plane].
```OpenSCAD
edge_fillet (h, r, angle, type, center, extra)
```
- `h`     - heigth of the edge
- `r`     - parameter of the chamfer
- `angle` - angle of the edge in degree
  - as number, default=`90` (right angle)
  - as list, `[opening_angle, begin_angle]`
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
- `center` - `true` = center the edge shaft in the middle, default=`false`
- `extra`  - set an amount extra overhang, because of z-fighting
  - default = constant `extra`

_Specialized modules with no argument `type`:_
- `edge_rounded()` - creates a rounded edges
  - `d` - diameter of the rounded edge, optional parameter
- `edge_chamfer()` - creates a chamfered edges

#### edge_ring_fillet [^][contents]
[edge_ring_fillet]: #edge_ring_fillet-
Creates a chamfered edge for a cylinder for cutting or gluing.\
Optionally rounded or chamfered.
It does `rotate_extrude()` with module [`edge_fillet_plane()`][edge_fillet_plane].
```OpenSCAD
edge_ring_fillet (r_ring, r, angle, angle_ring, type, outer, slices, extra)
```
- `r_ring`     - radius of the cylinder on the edge
- `angle_ring` - angle of the cylinder in degree, default=`360`
- `r`     - parameter of the chamfer
- `angle` - angle of the edge in degree
  - as number, default=`90` (right angle)
  - as list, `[opening_angle, begin_angle]`
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
- `outer`
  - value `0`...`1`
    - `0` - edges on real circle line from the cylinder, default
    - `1` - tangent on real circle line
    - any value between, such as `0.5` = middle around inner or outer circle
- `slices`
   - count of segments of the cylinder, optional.
   - Without specification it includes the [extra special variables][special_x]
     to automatically control the count of segments
   - if an angle is specified, the circle section keeps the count of segments.
     Elsewise with `$fn` the segment count scale down to the circle section,
     the behavior like in `rotate_extrude()` to keep the desired precision.
- `extra`  - set an amount extra overhang, because of z-fighting
  - default = constant `extra`

_Specialized modules with no argument `type`:_
- `edge_ring_rounded()` - creates a rounded edge
  - `d`      - diameter of the rounded edge, optional parameter
  - `d_ring` - diameter of the cylinder, optional parameter
- `edge_ring_chamfer()` - creates a chamfered edge

_Example:_
```OpenSCAD
include <banded.scad>

angle=180; // [0:360]
$fn=24;

difference()
{
	union()
	{
		color("orange", 0.5)
		{
			cylinder       (r=7, h=2);
			cylinder_extend(r=3, h=10, angle=angle);
		}
		
		// fill the room on the edge with smooth transition
		translate([0,0,2])
		edge_ring_rounded (r_ring=3, r=2, angle_ring=angle);
	}
	
	// cut the upper edge on the cylinder and make a round edge
	#translate([0,0,10])
	edge_ring_rounded (r_ring=3, r=2, angle=[90, 180] , angle_ring=angle);
}
```

#### edge_trace_fillet [^][contents]
[edge_trace_fillet]: #edge_trace_fillet-
Creates a chamfered edge along a 2D trace for cutting or gluing.\
Optionally rounded or chamfered.
It does [`plane_trace_extrude()`][plain_trace_extrude]
with module [`edge_fillet_plane()`][edge_fillet_plane].
```OpenSCAD
edge_trace_fillet (trace, r, angle, type, closed, extra)
```
- `trace` - 2D point list, which compose the line from the edge
- `r`     - parameter of the chamfer
- `angle` - angle of the edge in degree
  - opening angle between `0...180`
  - as number, default=`90` (right angle)
  - as list, `[opening_angle, begin_angle]`
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
- `closed`
  - `true`  - the trace is a closed loop, the last point connect the first point
  - `false` - the trace from first to last point, default
- `extra`  - set an amount extra overhang, because of z-fighting
  - default = constant `extra`

_Specialized modules with no argument `type`:_
- `edge_trace_rounded()` - creates a rounded edge
  - `d`      - diameter of the rounded edge, optional parameter
- `edge_trace_chamfer()` - creates a chamfered edge

_Example:_
```OpenSCAD
include <banded.scad>

$fd=0.02;

trace=bezier_curve ([[10,0],[0,0],[0,5]]);

difference()
{
	linear_extrude(5) polygon(trace);
	
	render(convexity=2)
	edge_trace_rounded (trace, 2);
}
```

#### edge_fillet_plane [^][contents]
[edge_fillet_plane]: #edge_fillet_plane-
Creates a profile of a chamfered edge as a 2D object.
```OpenSCAD
edge_fillet_plane (r, angle, type, extra)
```
- `r`     - parameter of the chamfer
- `angle` - angle of the edge in degree
  - opening angle between `0...180`
  - as number, default=`90` (right angle)
  - as list, `[opening_angle, begin_angle]`
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
- `extra`  - set an amount extra overhang, because of z-fighting
  - default = constant `extra`

_Specialized modules with no argument `type`:_
- `edge_rounded_plane()` - creates a rounded edges
  - `d` - diameter of the rounded edge, optional parameter
- `edge_chamfer_plane()` - creates a chamfered edges

#### edge_fillet_to [^][contents]
[edge_fillet_to]: #edge_fillet_to-
Creates a chamfered edge from the data
_line of the edge_ and _2 vertices_ of the adjacent faces.
```OpenSCAD
edge_fillet_to (line, point1, point2, r, type, extra, extra_h, directed)
```
- `line`   - 2 point list, line defined from first point to second point
- `point1` - first point, begin of the edge
- `point2` - second point, end of the edge
- `r`     - parameter of the chamfer
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
- `extra`  - set an amount extra overhang, because of z-fighting
  - default = constant `extra`
- `extra_h`
  - the line will make longer this length at both ends
  - default = `0`
- `directed`
  - If the angle around the line from point1 to point2 counter clockwise
    is greater then 180°, a chamfered edge is impossible to create.
    This parameter controls the behavior.
  - `true` = default, line is considered as directed\
    Create nothing if the angle is greater then 180°.
  - `false`, line is considered as undirected\
    Flip the chamfered edge to the side with an angle < 180°

_Specialized modules with no argument `type`:_
- `edge_rounded_to()` - creates a rounded edges
- `edge_chamfer_to()` - creates a chamfered edges


### Figures with rounded edges [^][contents]

#### cube_rounded_full [^][contents]
[cube_rounded_full]: #cube_rounded_full-
Cube with rounded edges, all edges with the same radius/diameter.\
Based on `cube()`\
_needs a rework_

```OpenSCAD
cube_rounded_full (size, r, center, d)
```
- `size`   - size of the cube like `cube()`
- `r`, `d` - radius,diameter of the rounded edges
- `center` - center the cube if set `true`

#### cube_fillet [^][contents]
[cube_fillet]: #cube_fillet-
Cube with rounded edges, every edge can be configured.\
Based on `cube()`.

_Arguments:_
```OpenSCAD
cube_fillet (size, type, edges, corner, center, align)
```
- `size` - size of cube like in `cube()`
- `type`
  - specify the chamfer type of the 12 edges on bottom, top, side
  - see [Repeating options](#repeating-options-)
  - see [function `configure_types()`][configure_types]
    for more options to load this parameter
- `edges`
  - set the radius or width of 12 edges on bottom, top, side
  - see [function `configure_edges()`][configure_edges]
    for more options to load this parameter
- `corner`
  - configure the 8 corners on bottom, top
  - see [function `configure_corner()`][configure_corner]
    for more options to load this parameter
  - TODO Only implemented for rounded corners
- `center` - center the cube if set `true`
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1,1]` = oriented on the positive side of axis

_Details to the arguments:_
- `type` and `edges` are defined as a 12 element list.\
  This list is partitioned in 3 parts, each part correspond 4 edges at one side.
  The rotation of the 4 edges on each partition is left around, seen from above.
  - the first 4 elements correspond to:  All 4 edges at the bottom.      First edge begins at front.
  - the following 4 elements correspond: All 4 edges at the top.         First edge begins at front.
  - the last 4 elements correspond to:   All vertical edges on the side. First edge begins at front left.
- `corner` is defined on a cube as a 8 element list:
  This list is partitioned in 2 parts, each part correspond 4 edges at one side.
  The rotation of the 4 edges on each partition is left around, seen from above.
  - the first 4 elements correspond to: All 4 corner at the bottom. First corner begins at front left.
  - the last 4 elements correspond to:  All 4 corner at the top.    First corner begins at front left.

_Specialized modules with no arguments `type`:_
- `cube_rounded()` - cube only with rounded edges
- `cube_chamfer()` - cube only with chamfered edges

#### cylinder_rounded [^][contents]
[cylinder_rounded]: #cylinder_rounded-
Cylinder with rounded edges on bottom and top,
all edges with the same radius like the cylinder radius.\
Based on `cylinder()`
```OpenSCAD
cylinder_rounded (h, r, center, d)
```
- `h`      - height of cylinder inclusive rounded edges
- `r`, `d` - radius or diameter of the cylinder
- `center` - center the cylinder if set `true`

#### cylinder_edges_fillet [^][contents]
[cylinder_edges_fillet]: #cylinder_edges_fillet-
Cylinder with chamfered edges on bottom and top.\
Based on [`cylinder_extend()`][cylinder_extend], compatible with `cylinder()`
```OpenSCAD
cylinder_edges_fillet (h, r1, r2, type, edges, center, r, d, d1, d2, angle, slices, outer, align)
```
- `type` - specify, which chamfer type should be used for the edges
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
  - as value: set the same edge type for both edges
  - as list:  set the edge type individually - `[bottom_edge, top_edge]`
- `edges` - radius of both edges
  - as number: set the same radius for both edges
  - as list:   set the edge radius individually - `[bottom_radius, top_radius]`
- `angle`
  - drawed angle in degree, default=`360`
    - as number -> angle from `0` to `angle` = opening angle
    - as list   -> range `[opening angle, begin angle]`
- `slices`
   - count of segments of the cylinder,
     without specification it gets the same like `circle()`
   - includes the [extra special variables][special_x]
     to automatically control the count of segments
   - if an angle is specified, the circle section keeps the count of segments.
     Elsewise with `$fn` the segment count scale down to the circle section,
     the behavior like in `rotate_extrude()` to keep the desired precision.
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
  - default = `[0,0,1]` = X-Y-axis centered

_Specialized modules with no arguments `type`:_
- `cylinder_edges_rounded()` - cylinder only with rounded edges
- `cylinder_edges_chamfer()` - cylinder only with chamfered edges

_Example:_
```OpenSCAD
include <banded.scad>
$fn=24;

cylinder_edges_fillet (
	h=10, r1=3, r2=4,
	type=[1,2], r_edges=2, angle=240, align=[1,0,1]
);
```

#### wedge_fillet [^][contents]
[wedge_fillet]: #wedge_fillet-
Creates a wedge with the parameter form FreeCAD's wedge
with rounded edges, every edge can be configured.\
Based on [`wedge()`][wedge]
```OpenSCAD
wedge_fillet (v_min, v_max, v2_min, v2_max, type, edges, corner)
```
- `v_min`  = `[Xmin, Ymin, Zmin]`
- `v_max`  = `[Xmax, Ymax, Zmax]`
- `v2_min` = `[X2min, Z2min]`
- `v2_max` = `[X2max, Z2max]`
- `type`
  - specify the chamfer type of the 12 edges on bottom, top, side
  - see [Repeating options](#repeating-options-)
  - see [function `configure_types()`][configure_types]
    for more options to load this parameter
- `edges`
  - set the radius or width of 12 edges on bottom, top, side
  - see [function `configure_edges()`][configure_edges]
    for more options to load this parameter
- `corner`
  - configure the 8 corners on bottom, top
  - see [function `configure_corner()`][configure_corner]
    for more options to load this parameter
  - TODO Not implemented yet

_Details to the arguments:_
- `type` and `edges` are defined as a 12 element list.\
  This list is partitioned in 3 parts, each part correspond 4 edges at one side.
  The rotation of the 4 edges on each partition is left around, seen from above.
  - the first 4 elements correspond to:  All 4 edges at the bottom.      First edge begins at front.
  - the following 4 elements correspond: All 4 edges at the top.         First edge begins at front.
  - the last 4 elements correspond to:   All vertical edges on the side. First edge begins at front left.
- `corner` is defined on a cube as a 8 element list:
  This list is partitioned in 2 parts, each part correspond 4 edges at one side.
  The rotation of the 4 edges on each partition is left around, seen from above.
  - the first 4 elements correspond to: All 4 corner at the bottom. First corner begins at front left.
  - the last 4 elements correspond to:  All 4 corner at the top.    First corner begins at front left.

_Specialized modules with no arguments `type`_
- `wedge_rounded()` - wedge only with rounded edges
- `wedge_chamfer()` - wedge only with chamfered edges

#### square_fillet [^][contents]
[square_fillet]: #square_fillet-
Square with rounded edges, every edge can be configured.\
Based on `square()` from OpenSCAD
```OpenSCAD
square_fillet (size, edges, type, center, align)
```
- `size`  - size of square like in `square()`
- `edges` - radius of the edges
  - as number: set the same radius for all 4 edges
  - as list:   set the edge radius individually - `[p0, p1, p2, p3]`
    ```
              Y
       p3     |     p2
        +-----|-----+
        |     |     |
    ----------+---------> X
        |     |     |
        +-----|-----+
       p0     |     p1
    ```
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
  - as number: set the same type for all 4 edges
  - as list:   set the edge type individually - `[p0, p1, p2, p3]`
- `center` - center the square if set `true`
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1]` = oriented on the positive side of axis

_Specialized modules with no arguments `type`:_
- `square_rounded()` - square only with rounded edges
- `square_chamfer()` - square only with chamfered edges


### Helper functions [^][contents]

#### configure_edges [^][contents]
[configure_edges]: #configure_edges-
Sets the `edges` parameter of the module `cube_fillet()`.

3 groups of edges, each completely encompassing the cuboid:
- bottom, top, around
- left, right, forward
- front, back, sideways

In the 3 groups all edges will be defined 3 times each,
therefore there is a priority, the higher one overrides the lower one.
Individual edges can be set as undefined with `undef`.

Order, those further to the left overwrite those further to the right:
- bottom, top, around, left, right, forward, front, back, sideways

_Arguments:_
```OpenSCAD
configure_edges (bottom,top,around, left,right,forward, front,back,sideways, r, default)
```
- | edge argument | description                                | first edge   | rotation on cube
  |---------------|--------------------------------------------|--------------|------------------
  | `bottom`      | 4 edges around the rectangle on the bottom | front        | left around, seen from above
  | `top`         | 4 edges around the rectangle on the top    | front        | left around, seen from above
  | `around`      | 4 edges vertical from bottom the top       | front left   | left around, seen from above
  | `left`        | 4 edges around the rectangle left side     | bottom left  | left around, seen from the left
  | `right`       | 4 edges around the rectangle right side    | bottom right | left around, seen from the left
  | `forward`     | 4 edges horizontal from left to right      | bottom front | left around, seen from the left
  | `front`       | 4 edges around the rectangle front side    | bottom front | left around, seen from the front
  | `back`        | 4 edges around the rectangle back side     | bottom back  | left around, seen from the front
  | `sideways`    | 4 edges horizontal from front to back      | bottom right | left around, seen from the front
- `r`
  - optional parameter
  - All edges are multiplied by this value if specified.
  - If `r` is set, this value will multiplied with every edge size,
    so you can activate every specific edge with `1` and deactivate with `0`,
    all so activated edges so gets the size `r`.
- `default`
  - value taken for edges that have not been set
  - default = `0`, edge not rounded

_Return:_
- 12 element list:
  - the first 4 elements correspond to:  `bottom` - all 4 edges at the bottom
  - the following 4 elements correspond: `top`    - all 4 edges at the top
  - the last 4 elements correspond to:   `around` - all vertical edges on the side

#### configure_types [^][contents]
[configure_types]: #configure_types-
Sets the `type` parameter of the module `cube_fillet()`.

_Arguments:_
```OpenSCAD
configure_types (bottom,top,around, left,right,forward, front,back,sideways, default)
```
The same like [`configure_edges()`][configure_edges]
(but without parameter `r`)

#### configure_corner [^][contents]
[configure_corner]: #configure_corner-
Sets the `corner` parameter of the module `cube_fillet()`.

3 groups of corner, each completely encompassing the cuboid:
- bottom, top
- left, right
- front, back

In the 3 groups all corner will be defined 3 times each,
therefore there is a priority, the higher one overrides the lower one.
Individual corner can be set as undefined with `undef`.

Order, those further to the left overwrite those further to the right:
- bottom, top, left, right, front, back

_Arguments:_
```OpenSCAD
configure_corner (bottom,top, left,right, front,back, default)
```
- | edge argument | description                                 | first edge   | rotation on cube
  |---------------|---------------------------------------------|--------------|------------------
  | `bottom`      | 4 corner around the rectangle on the bottom | front left   | left around, seen from above
  | `top`         | 4 corner around the rectangle on the top    | front left   | left around, seen from above
  | `left`        | 4 corner around the rectangle left side     | bottom front | left around, seen from the left
  | `right`       | 4 corner around the rectangle right side    | bottom front | left around, seen from the left
  | `front`       | 4 corner around the rectangle front side    | bottom right | left around, seen from the front
  | `back`        | 4 corner around the rectangle back side     | bottom right | left around, seen from the front
- `default`
  - value taken for corner that have not been set
  - default = `0`, corner not rounded

_Return:_
- 8 element list:
  - the first 4 elements correspond to: `bottom` - all 4 corner at the bottom
  - the last  4 elements correspond to: `top`    - all 4 corner at the top

