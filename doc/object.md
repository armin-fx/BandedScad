Configurable objects
====================

### defined in file
`banded/object.scad`  
` `|  
` `+--> `banded/object_figure.scad`  
` `+--> `banded/object_figure_rounded.scad`  
` `+--> `banded/object_rounded.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Figures](#figures-)
  - [2D](#2d-)
    - [`triangle()`][triangle]
    - [`ring()`][ring]
  - [3D](#3d-)
    - [`wedge()`][wedge]
    - [`wedge_freecad()`][wedge_freecad]
    - [`torus()`][torus]
    - [`tube()`][tube]
    - [`funnel()`][funnel]
  - [Miscellaneous](#miscellaneous-)
    - [`empty()`][empty]
    - [`bounding_square()`][bounding_square]
    - [`bounding_cube()`][bounding_cube]
- [Rounded edges](#rounded-edges-)
  - Description
    - [Repeating options](#repeating-options-)
    - [Module name convention](#module-name-convention-)
    - [Module characteristic](#module-characteristic-)
  - [Cutting or adding parts for edges](#cutting-or-adding-parts-for-edges-)
    - [`edge_fillet()`][edge_fillet]
    - [`edge_ring_fillet()`][edge_ring_fillet]
    - [`edge_trace_fillet()`][edge_trace_fillet]
    - [`edge_fillet_plane()`][edge_fillet_plane]
    - [`edge_fillet_to()`][edge_fillet_to]
- [Figures with chamfered edges](#figures-with-chamfered-edges-)
  - [2D](#2d---)
    - [`square_fillet()`][square_fillet]
    - [`triangle_fillet()`][triangle_fillet]
  - [3D](#3d---)
    - [`cube_rounded_full()`][cube_rounded_full]
    - [`cube_fillet()`][cube_fillet]
    - [`cylinder_rounded()`][cylinder_rounded]
    - [`cylinder_edges_fillet()`][cylinder_edges_fillet]
    - [`wedge_fillet()`][wedge_fillet]
    - [`wedge_freecad_fillet()`][wedge_freecad_fillet]

[align]:     extend.md#extra-arguments-
[special_x]: extend.md#special-variables-
[cylinder_extend]:     extend.md#cylinder_extend-
[square_extend]:       extend.md#square_extend-
[cube_extend]:         extend.md#cube_extend-
[plain_trace_extrude]: operator.md#plain_trace_extrude-
[configure_types]:  helper.md#configure_types-
[configure_edges]:  helper.md#configure_edges-
[configure_corner]: helper.md#configure_corner-


Figures [^][contents]
---------------------

Modules to create configurable objects


### 2D [^][contents]

#### triangle [^][contents]
[triangle]: #triangle-
Creates a triangle, a half square
with arguments from [`square_extend()`][square_extend].

_Arguments:_
```OpenSCAD
triangle (size, center, align, side)
```
- `side`
  - sets the remaining side of the triangle.
    - 0 = keep the bottom left triangle, default
    - 1 = keep the bottom right triangle
    - 2 = keep the top right triangle
    - 3 = keep the top left triangle
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1]` = oriented on the positive side of axis
    like `square_extend()`

#### ring [^][contents]
[ring]: #ring-
Creates a ring.  
A circle with a circle hole.

_Arguments:_
```OpenSCAD
ring (r, w, ri, ro, angle, center, d, di, do, outer, align)
```
- `r`        - mean radius, distance between midpoint and middle of the wall
- `ri`, `di` - inner radius, inner diameter
- `ro`, `do` - outside radius, outside diameter
- `w`        - width of the wall
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
- exactly 2 specifications of `r` or `ri` or `ro` or `w`


### 3D [^][contents]

#### wedge [^][contents]
[wedge]: #wedge-
Creates a wedge, a half cube.  
With arguments from [`cube_extend()`][cube_extend].

_Arguments:_
```OpenSCAD
wedge (size, center, align, side)
```
- `side`
  - sets the remaining side of the wedge.
    -  0 = keep the bottom and front side, default
    -  1 = keep the bottom and right side
    -  2 = keep the bottom and back side
    -  3 = keep the bottom and left side
    -  4 = keep the top and front side
    -  5 = keep the top and right side
    -  6 = keep the top and back side
    -  7 = keep the top and left side
    -  8 = keep the left and front side
    -  9 = keep the front and right side
    - 10 = keep the right and back side
    - 11 = keep the back and left side
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1,1]` = oriented on the positive side of axis
    like `cube_extend()`

_Example:_
```OpenSCAD
include <banded.scad>

for (i=[0:11])
translate ([i%4, -floor(i/4)%3] * 8)
{
	color("black")
	translate_y (-2.5) scale(0.2)
	linear_extrude(1) text(str(i));
	//
	wedge ([4,3,2], side=i);
	%cube ([4,3,2]);
}
```

#### wedge_freecad [^][contents]
[wedge_freecad]: #wedge_freecad-
Creates a wedge with the parameter from FreeCAD's wedge.

_Arguments:_
```OpenSCAD
wedge_freecad (v_min, v_max, v2_min, v2_max)
```
- `v_min`  = `[Xmin, Ymin, Zmin]`
- `v_max`  = `[Xmax, Ymax, Zmax]`
- `v2_min` = `[X2min, Z2min]`
- `v2_max` = `[X2max, Z2max]`

_Location of the parameter:_
```
           X2min X2max
             +-----+ Z2max
           / :    /|
        /    :   / · - - Ymax
 Zmax +---------+  |
      |      + -|- + Z2min
      |    ·    | /
      |  ·      ·- - - - Ymin
      |.        |/
 Zmin +---------+
     Xmin      Xmax


   Z
   ^ .Y
   |/
   +--> X

```

#### torus [^][contents]
[torus]: #torus-
Creates a torus.

_Arguments:_
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

#### tube [^][contents]
[tube]: #tube-
Creates a tube.  
A cylinder with a cylinder hole.

_Arguments:_
```OpenSCAD
tube (h, r, w, ri, ro, angle, center, d, di, do, outer, align)
```
- `h`        - height
- `r`        - mean radius, distance between midpoint and middle of the wall
- `ri`, `di` - inner radius, inner diameter
- `ro`, `do` - outside radius, outside diameter
- `w`        - width of the wall
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

_Deprecated name:_
- `ring_square()`
  - A link to `tube()`. This will be removed in future releases.

#### funnel [^][contents]
[funnel]: #funnel-
Creates a funnel.

_Arguments:_
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
tube   (h=0.5, w=1, ri=7);
```


### Miscellaneous [^][contents]

#### empty [^][contents]
[empty]: #empty-
Module which create nothing.  
Useful if an operator needs an object.

_Arguments:_
```OpenSCAD
empty ()
```

#### bounding_square [^][contents]
[bounding_square]: #bounding_square-
Create a 2D rectangle around the outermost points from a list.

_Arguments:_
```OpenSCAD
bounding_square (points)
```
- `points`
  - a list with minimum 2 points

#### bounding_cube [^][contents]
[bounding_cube]: #bounding_cube-
Create a 3D cube around the outermost points from a list.  

_Arguments:_
```OpenSCAD
bounding_cube (points)
```
- `points`
  - a list with minimum 2 points


Rounded edges [^][contents]
---------------------------

Modules and functions to create different configurable edges to add or
remove from objects.

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
specify the type of the chamfer.  
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
Creates a fillet edge, used for cutting or adding to edges.  
Optionally rounded or chamfered.
It does `linear_extrude()` with module [`edge_fillet_plane()`][edge_fillet_plane].

_Arguments:_
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
Creates a chamfered edge for a cylinder for cutting or gluing.  
Optionally rounded or chamfered.
It does `rotate_extrude()` with module [`edge_fillet_plane()`][edge_fillet_plane].

_Arguments:_
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
Creates a chamfered edge along a 2D trace for cutting or gluing.  
Optionally rounded or chamfered.
It does [`plane_trace_extrude()`][plain_trace_extrude]
with module [`edge_fillet_plane()`][edge_fillet_plane].

_Arguments:_
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

_Arguments:_
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
This can directly set on 3D edges.

_Arguments:_
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
  - `true` = default, line is considered as directed  
    Create nothing if the angle is greater then 180°.
  - `false`, line is considered as undirected  
    Flip the chamfered edge to the side with an angle < 180°

_Specialized modules with no argument `type`:_
- `edge_rounded_to()` - creates a rounded edge
- `edge_chamfer_to()` - creates a chamfered edge

#### edge_fillet_plane_to [^][contents]
[edge_fillet_plane_to]: #edge_fillet_plane_to-
Creates a profile of a chamfered edge as 2D object from data.  
This can directly set on 2D edges.
It needs the point from the edge and the points of both sides outgoing from edge.

_Arguments:_
```OpenSCAD
edge_fillet_plane_to (origin, point1, point2, r, type, extra, directed)
```
- `origin` - point at the edge
- `point1` - first point, build the line `origin`->`point1`, first side of the edge
- `point2` - second point, build the line `origin`->`point2`, last side of the edge
- `r`     - parameter of the chamfer
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
- `extra`  - set an amount extra overhang, because of z-fighting
  - default = constant `extra`
- `directed`
  - If the angle around the line from point1 to point2 counter clockwise
    is greater then 180°, a chamfered edge is impossible to create.
    This parameter controls the behavior.
  - `true` = default, line is considered as directed  
    Create nothing if the angle is greater then 180°.
  - `false`, line is considered as undirected  
    Flip the chamfered edge to the side with an angle < 180°

_Specialized modules with no argument `type`:_
- `edge_rounded_plane_to()` - creates a rounded edge
- `edge_chamfer_plane_to()` - creates a chamfered edge


Figures with chamfered edges [^][contents]
----------------------------------------

Existing modules which are extended with chamfered edges.


### 2D - [^][contents]

#### square_fillet [^][contents]
[square_fillet]: #square_fillet-
Square with chamfered edges, every edge can be configured.  
Based on `square()` from OpenSCAD

_Arguments:_
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

#### triangle_fillet [^][contents]
[triangle_fillet]: #triangle_fillet-
Creates a triangle (a half square) with chamfered edges
with arguments from [`square_extend()`][square_extend].

_Arguments:_
```OpenSCAD
triangle_fillet (size, type, edges, center, align, side)
```
- `side`
  - sets the remaining side of the triangle.
    - 0 = keep the bottom left triangle, default
    - 1 = keep the bottom right triangle
    - 2 = keep the top right triangle
    - 3 = keep the top left triangle
- `center` - center the triangle if set `true`
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1]` = oriented on the positive side of axis
    like `square_extend()`
- `type`  - specify, which chamfer type should be used for the edge
  - `0` = no chamfer (default)
  - `1` = rounding
  - `2` = chamfer
  - as number: set the same type for all 3 edges
  - as list:   set the edge type individually
    - Here the first position in the list points to the completely
      remaining corner of the imaginary rectangle.
      The other positions run counterclockwise.
- `edges` - radius of the edges
  - as number: set the same radius for all 3 edges
  - as list:   set the edge radius individually
    - positions in list like argument `type`

_Specialized modules with no arguments `type`:_
- `triangle_rounded()` - triangle only with rounded edges
- `triangle_chamfer()` - triangle only with chamfered edges


### 3D - [^][contents]

#### cube_rounded_full [^][contents]
[cube_rounded_full]: #cube_rounded_full-
Cube with rounded edges, all edges with the same radius/diameter.  
Based on `cube()`  
_needs a rework_

_Arguments:_
```OpenSCAD
cube_rounded_full (size, r, center, d)
```
- `size`   - size of the cube like `cube()`
- `r`, `d` - radius,diameter of the rounded edges
- `center` - center the cube if set `true`

#### cube_fillet [^][contents]
[cube_fillet]: #cube_fillet-
Cube with chamfered edges, every edge can be configured.  
Based on `cube()`.

_Arguments:_
```OpenSCAD
cube_fillet (size, type, edges, corner, center, align)
```
- `size` - size of cube like in `cube()`
- `type`
  - specify the chamfer type of the 12 edges on bottom, top, side
  - see [Repeating options](#repeating-options-)
  - see function [`configure_types()`][configure_types]
    for more options to load this parameter
- `edges`
  - set the radius or width of 12 edges on bottom, top, side
  - see function [`configure_edges()`][configure_edges]
    for more options to load this parameter
- `corner`
  - configure the 8 corners on bottom, top
  - see function [`configure_corner()`][configure_corner]
    for more options to load this parameter
  - TODO Only implemented for rounded corners
- `center` - center the cube if set `true`
- `align`
  - Side from origin away that the part should be.
  - [Extra arguments - align][align]
  - default = `[1,1,1]` = oriented on the positive side of axis

_Details to the arguments:_
- `type` and `edges` are defined as a 12 element list.  
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
all edges with the same radius like the cylinder radius.  
Based on `cylinder()`

_Arguments:_
```OpenSCAD
cylinder_rounded (h, r, center, d)
```
- `h`      - height of cylinder inclusive rounded edges
- `r`, `d` - radius or diameter of the cylinder
- `center` - center the cylinder if set `true`

#### cylinder_edges_fillet [^][contents]
[cylinder_edges_fillet]: #cylinder_edges_fillet-
Cylinder with chamfered edges on bottom and top.  
Based on [`cylinder_extend()`][cylinder_extend], compatible with `cylinder()`

_Arguments:_
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
Creates a wedge, a half cube
with chamfered edges, every edge can be configured.  
Based on [`wedge()`][wedge]

_Arguments:_
```OpenSCAD
wedge_fillet (size, center, align, side, type, edges, corner)
```
- `type`
  - specify the chamfer type of the 9 edges
  - see [Repeating options](#repeating-options-)
- `edges`
  - set the radius or width of the 9 edges
- `corner`
  - configure the 6 corners on bottom, top
  - TODO Not implemented yet

_Details to the arguments:_
- `type` and `edges` are defined as a 9 element list.  
  The locations in the list of an specific edge is defined by
  distinctive positions in the wedge.
  These are not fixed defined by X, Y or Z axis, but by the structure of the wedge.
  Turn the wedge in your mind to striking points to find the right locations.
  
  The list is partitioned in 3 parts, each part correspond 3 edges at one side.
  - `0`,`1`,`2`
    - the 3 lines from first triangle to second triangle,
      begins with the line from the remaining side,
      the line with the right angle on both faces
  - `3`,`4`,`5`
    - the 3 lines around first triangle,
      begins from the corner with the right angle
  - `6`,`7`,`8`
    - the 3 lines around second triangle,
      begins from the corner with the right angle
  
  _Striking points:_
  - The line where the two rectangular surfaces are at right angles.
    This means the first line.
  - The both triangles.
    When the first triangle is on the bottom and the second on the top,
    the rotation of all edges is left around, seen from above.
    A location of a bottom line on a triangle is the same position
    on the top line, but shiftet upwards.
  
  _Location of the first triangle by parameter_ `side`_:_
  - `0-3`  - left side, if you see the front rectangle in front
  - `4-7`  - left side, if you see the front rectangle in front
  - `8-11` - bottom side
  
- `corner` is defined on a cube as a 6 element list:
  This list is partitioned in 2 parts, each part correspond 3 corner at one triangle side.
  The rotation of the 3 corner location on each partition is left around, seen from above.
  First corner begins on the triangle where both lines form a right angle.
  - the first 3 elements correspond to: All 3 corner at the first triangle (bottom).
  - the last 3 elements correspond to:  All 3 corner at the second triangle (top).

_Specialized modules with no arguments `type`_
- `wedge_rounded()` - wedge only with rounded edges
- `wedge_chamfer()` - wedge only with chamfered edges

_Example:_
```OpenSCAD
include <banded.scad>

// lists wedges with all different sides in a grid
for (i=[0:11])
translate ([i%4, -floor(i/4)%3] * 8)
{
	color("black")
	translate_y (-2.5)
	linear_extrude(0.2) scale(0.2) text(str(i));
	//
	$fn=48;
	wedge_rounded ([4,3,3], side=i, edges=[0.2,0,0, 1]);
}
```

#### wedge_freecad_fillet [^][contents]
[wedge_freecad_fillet]: #wedge_freecad_fillet-
Creates a wedge with the parameter form FreeCAD's wedge
with chamfered edges, every edge can be configured.  
Based on [`wedge_freecad()`][wedge_freecad]

_Arguments:_
```OpenSCAD
wedge_freecad_fillet (v_min, v_max, v2_min, v2_max, type, edges, corner)
```
- `v_min`  = `[Xmin, Ymin, Zmin]`
- `v_max`  = `[Xmax, Ymax, Zmax]`
- `v2_min` = `[X2min, Z2min]`
- `v2_max` = `[X2max, Z2max]`
- `type`
  - specify the chamfer type of the 12 edges on bottom, top, side
  - see [Repeating options](#repeating-options-)
  - see function [`configure_types()`][configure_types]
    for more options to load this parameter
- `edges`
  - set the radius or width of 12 edges on bottom, top, side
  - see function [`configure_edges()`][configure_edges]
    for more options to load this parameter
- `corner`
  - configure the 8 corners on bottom, top
  - see function [`configure_corner()`][configure_corner]
    for more options to load this parameter
  - TODO Not implemented yet

_Details to the arguments:_
- `type` and `edges` are defined as a 12 element list.  
  This list is partitioned in 3 parts, each part correspond 4 edges at one side.
  The rotation of the 4 edges on each partition is left around, seen from above.
  - the first 4 elements correspond to:  All 4 edges at the bottom.      First edge begins at front.
  - the following 4 elements correspond: All 4 edges at the top.         First edge begins at front.
  - the last 4 elements correspond to:   All vertical edges on the side. First edge begins at front left.
- `corner` is defined on a cube as a 8 element list:
  This list is partitioned in 2 parts, each part correspond 4 corner at one side.
  The rotation of the 4 corner location on each partition is left around, seen from above.
  - the first 4 elements correspond to: All 4 corner at the bottom. First corner begins at front left.
  - the last 4 elements correspond to:  All 4 corner at the top.    First corner begins at front left.

_Specialized modules with no arguments `type`_
- `wedge_freecad_rounded()` - wedge only with rounded edges
- `wedge_freecad_chamfer()` - wedge only with chamfered edges

