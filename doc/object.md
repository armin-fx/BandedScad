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
Create a 2D rectangle around the outermost points from a list.\
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

Arguments:
- `r`  - mean radius
- `ri` - inner radius
- `ro` - outside radius
- `w`  - width of the ring

Must specify:
- exactly 2 specifications of `r` or `r1` or `r2` or `w`

More arguments:
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

Example:
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

___Must specify:___
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

##### Repeating options: [^][contents]

- `type`
  - specify, which chamfer type should be used for the edge
    - `0` = no chamfer (default)
    - `1` = rounding
    - `2` = chamfer
- `type_xxx`
  - a list with specification of the chamfer types of the respective edge
  - if set a value instead a list,
    all described edges get the same type of the value
  - there will be more options on some modules,
    where `xxx` specify the name of a group of edges.\
    for example on a cube:
    - `type_bottom` - all 4 edges on the bottom
    - `type_top`    - all 4 edges on the top
    - `type_side`   - all 4 edges on the side
  - every edge can get his own chamfer,
    an entry `-1` will use the common value from `type`
- `r` - parameter of the chamfer, depending on the type
  - radius on rounded edges
  - width of the chamfered edge
- `edges_xxx`
  - a list which specifies which edges should be chamfered
    - `0` = not chamfered
    - `1` = chamfered
    - other number = radius or width will be increased by this number
  - if set a value instead a list,
    all described edges get the same value
  - there will be more options on some modules,
    where `xxx` specify the name of a group of edges.\
    for example on a cube:
    - `edges_bottom` - all 4 edges on the bottom
    - `edges_top`    - all 4 edges on the top
    - `edges_side`   - all 4 edges on the side
- `corner_xxx`
  - a list which specifies which corners should be chamfered
    `0` = not chamfered
    `1` = chamfered
  - if set a value instead a list,
    all described edges get the same value
  - there will be more options on some modules,
    where `xxx` specify the name of a group of edges.\
    for example on a cube:
    - `corner_bottom` - all 4 corners on bottom
    - `corner_top`    - all 4 corners top

Location of the edges specified on the lists
for example on a cube:
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
| option name     | position of edges
|-----------------|-------------------
|`xxx_bottom`     | `[0-1, 1-2, 2-3, 3-0]`
|`xxx_top`        | `[4-5, 5-6, 6-7, 7-4]`
|`xxx_side`       | `[0-4, 1-5, 2-6, 3-7]`
| `corner_bottom` | `[0,   1,   2,   3]`
| `corner_top`    | `[4,   5,   6,   7]`

##### Module name convention: [^][contents]
On modules with the name `_fillet` on the end you can
specify the type of the chamfer.\
But these modules have specialized derivation modules
with only one chamfer type.
- `xxx`         - base module
- `xxx_fillet`  - edges can specified with option `type`
- `xxx_rounded` - with rounded edges
- `xxx_chamfer` - with chamfered edges


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

___Specialized modules with no argument `type`___
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

___Specialized modules with no argument `type`___
- `edge_ring_rounded()` - creates a rounded edge
  - `d`      - diameter of the rounded edge, optional parameter
  - `d_ring` - diameter of the cylinder, optional parameter
- `edge_ring_chamfer()` - creates a chamfered edge

___Example:___
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

___Specialized modules with no argument `type`___
- `edge_trace_rounded()` - creates a rounded edge
  - `d`      - diameter of the rounded edge, optional parameter
- `edge_trace_chamfer()` - creates a chamfered edge

___Example:___
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

___Specialized modules with no argument `type`___
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

___Specialized modules with no argument `type`___
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
Based on `cube()`
```OpenSCAD
cube_fillet (size, r, type, edges_xxx, corner_xxx, type_xxx, center, align)
```
- `size` - size of cube like in `cube()`
- `r`    - parameter of the chamfer
- `type` - specify, which chamfer type should be used for all edges
- `edges_bottom`, `edges_top`, `edges_side`
  - a list set the 4 edges on bottom, top, side
  - default = `1` on every edge
- `corner_bottom`, `corner_top`
  - a list set the 4 corners on bottom, top
  - default = `1` on every corner
  - TODO Not implemented yet
- `type_bottom`, `type_top`, `type_side`
  - a list with specification of the chamfer types of the edges
    on the bottom, top, side
  - default = `-1` - use the entry from `type`
- `center` - center the cube if set `true`
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1,1]` = oriented on the positive side of axis

___Specialized modules with no arguments `type` and `type_xxx`___
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
cylinder_edges_fillet (h, r1, r2, r_edges, type, center, r, d, d1, d2, angle, slices, outer, align)
```
- `r_edges` - radius of both edges
  - as number: set the same radius for both edges
  - as list:   set the edge radius individually - `[bottom_radius, top_radius]`
- `type` - specify, which chamfer type should be used for the edges
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
  - as value: set the same edge type for both edges
  - as list:  set the edge type individually - `[bottom_edge, top_edge]`
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

___Specialized modules with no arguments `type` and `type_xxx`___
- `cylinder_edges_rounded()` - cylinder only with rounded edges
- `cylinder_edges_chamfer()` - cylinder only with chamfered edges

___Example:___
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
wedge_fillet (v_min, v_max, v2_min, v2_max, r, type, edges_xx, corner_xxx, type_xxx)
```
- `v_min`  = `[Xmin, Ymin, Zmin]`
- `v_max`  = `[Xmax, Ymax, Zmax]`
- `v2_min` = `[X2min, Z2min]`
- `v2_max` = `[X2max, Z2max]`
- `edges_bottom`, `edges_top`, `edges_side`
  - a list set the 4 edges on bottom, top, side
  - default = `1` on every edge
- `corner_bottom`, `corner_top`
  - a list set the 4 corners on bottom, top
  - default = `1` on every corner
  - TODO Not implemented yet
- `type_bottom`, `type_top`, `type_side`
  - a list with specification of the chamfer types of the edges
    on the bottom, top, side
  - default = `-1` - use the entry from `type`

___Specialized modules with no arguments `type` and `type_xxx`___
- `wedge_rounded()` - wedge only with rounded edges
- `wedge_chamfer()` - wedge only with chamfered edges

#### square_fillet [^][contents]
[square_fillet]: #square_fillet-
Square with rounded edges, every edge can be configured.\
Based on `square()` from OpenSCAD
```OpenSCAD
square_fillet (size, r, type, center, align)
```
- `size` - size of square like in `square()`
- `r` - radius of the edges
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

___Specialized modules with no arguments `type`___
- `square_rounded()` - square only with rounded edges
- `square_chamfer()` - square only with chamfered edges

