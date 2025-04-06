Polygon operations
==================

### defined in file
`banded/math.scad`  
` `|  
` `+--> ...  
` `+--> `banded/math_polygon.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

[<-- Math functions](math.md)

### Contents
[contents]: #contents "Up to Contents"
- [Vector operations ->](math_vector.md)

- [Polygones and lines](#polygones-and-lines-)
  - [Test functions for lines](#test-functions-for-lines-)
    - [`is_point_on_line()`][is_point_on_line]
    - [`is_point_on_segment()`][is_point_on_segment]
    - [`is_point_on_plane()`][is_point_on_plane]
    - [`is_point_upper_plane()`][is_point_upper_plane]
    - [`is_intersection_segments()`][is_intersection_segments]
    - [`is_intersection_polygon_segment()`][is_intersection_polygon_segment]
    - [`is_point_inside_triangle()`][is_point_inside_triangle]
    - [`is_point_inside_polygon()`][is_point_inside_polygon]
    - [`is_math_rotation_triangle()`][is_math_rotation_triangle]
    - [`is_math_rotation_polygon()`][is_math_rotation_polygon]
  - [Straight line, line segment and surfaces](#straight-line-line-segment-and-surfaces-)
    - [`get_gradient()`][get_gradient]
    - [`get_intersection_lines()`][get_intersection_lines]
    - [`get_intersection_line_plane()`][get_intersection_line_plane]
  - [Polygon functions](#polygon-functions-)
	- [`length_line()`][length_line]
    - [`length_trace()`][length_trace]
    - [`position_line()`][position_line]
    - [`position_trace()`][position_trace]
  - [Convert polygon data](#convert-polygon-data-)
    - [`trace_to_lines()`][trace_to_lines]
    - [`lines_to_trace()`][lines_to_trace]
    - [`line_to_vector()`][line_to_vector]
    - [`vector_to_line()`][vector_to_line]
  - [Data from lines](#data-from-lines-)
    - [`distance_line()`][distance_line]
    - [`distance_segment()`][distance_segment]
    - [`distance_trace()`][distance_trace]
    - [`nearest_point_line()`][nearest_point_line]
    - [`nearest_point_segment()`][nearest_point_segment]
    - [`nearest_point_trace()`][nearest_point_trace]


Polygones and Lines [^][contents]
---------------------------------


### Test functions for lines [^][contents]

#### is_point_on_line [^][contents]
[is_point_on_line]: #is_point_on_line-
Returns `true` if a point is exactly on a straight line.  
In 2D or 3D.

_Arguments:_
```OpenSCAD
is_point_on_line (line, point)
```
- `line` - a list with 2 points defines a straight line

#### is_point_on_segment [^][contents]
[is_point_on_segment]: #is_point_on_segment-
Returns `true` if a point is exactly on a line segment.  
Inclusive on the points.
In 2D or 3D.

_Arguments:_
```OpenSCAD
is_point_on_segment (line, point, ends)
```
- `line` - a list with 2 points defines the line segment
- `ends` - defines whether the endpoint is within the segment
  - `0`   - default, both sides are within the segment
  - `< 0` - left point is within the segment, e.g. `-1`
  - `> 0` - right point is within the segment, e.g. `1`

#### is_point_on_plane [^][contents]
[is_point_on_plane]: #is_point_on_plane-
Returns `true` if a point lies exactly in a plane.  
In 3D.

_Arguments:_
```OpenSCAD
is_point_on_plane (points, point)
```
- `points` - 3 points in a list defines the plane

#### is_point_upper_plane [^][contents]
[is_point_upper_plane]: #is_point_upper_plane-
Returns `true` if a point is upper a plane.  
In 3D.
Upper side means the same side of the direction of the normal vector
from the triangle defined by the 3 points.

_Arguments:_
```OpenSCAD
is_point_upper_plane (points, point)
```
- `points` - 3 points in a list defines the plane

#### is_intersection_segments [^][contents]
[is_intersection_segments]: #is_intersection_segments-
Returns `true` if two line segment intersect.  
Only in 2D plane.

_Arguments:_
```OpenSCAD
is_intersection_segments (line1, line2, point, no_parallel, ends)
```
- `line1` and `line2`
  - a list with 2 points defines the line segment
- `point`
  - optional
  - an already calculated intersection of both straight lines can be used,
    see [`get_intersection_lines()`][get_intersection_lines]
- `no_parallel`
  - optional, default = `false`
  - `false` - if the lines are collinear then it tests whether the straight lines overlap
  - `true`  - return always `false` if the lines are collinear
- `ends` - defines whether the endpoint is within the segment
  - `0`   - default, both sides are within the segment
  - `< 0` - left point is within the segment, e.g. `-1`
  - `> 0` - right point is within the segment, e.g. `1`

#### is_intersection_polygon_segment [^][contents]
[is_intersection_polygon_segment]: #is_intersection_polygon_segment-
Returns `true` if a line segment intersect any line from a polygon.  
Only in 2D plane.

_Arguments:_
```OpenSCAD
is_intersection_polygon_segment (points, line, path, without)
```
- `points` - a list with points defines the outline of the polygon
- `line`   - a list with 2 points defines the line segment
- `path`   - optional, a list with positions to `points`
  - defines the outline of the polygon if defined
- `without`
  - optional, a list with point positions, which are excluded from test
  - a point defined here will even exclude the point and the two line segments
    in the polygon before and after the point
  - there can set:
    - a number as position in `points`
    - a list with positions, if more then one point will excluded

#### is_point_inside_triangle [^][contents]
[is_point_inside_triangle]: #is_point_inside_triangle-
Returns `true` if a point lies exactly in a triangle.  
Inclusive the on the line.
Only 2D plane.

_Arguments:_
```OpenSCAD
is_point_inside_triangle (points, point, border, rotation)
```
- `points` - 3 points in a list defines the triangle
- `border` - optional, specify whether the border is included to the triangle
  - default = `true`, the triangle inclusive the border
- `rotation`
  - optional, set the rotation of the triangle must be, seen from top
  - default = `0`, both rotations
  - `== 0` - left rotation or right rotation
  - ` > 0` - only for left rotation, mathematical rotation
    - if the triangle is rotate the other way round, the point is always "outside"
    - can be used to test the rotation of the triangle
  - ` < 0` - only for right rotation, clockwise rotation


#### is_point_inside_polygon [^][contents]
[is_point_inside_polygon]: #is_point_inside_polygon-
Returns `true` if a point lies exactly in a closed trace.  
Inclusive the on the line.
The border of the trace must not intersect itself.
In 2D and 3D.

_Arguments:_
```OpenSCAD
is_point_inside_polygon (points, p, face)
```
- `points` - points in a list
- `p`      - point to test
- `face`
  - This list contains the positions in list `points` in order to define the closed trace.
  - If not defined, the order of `points` is used to define the trace.

_Specialized functions:_
- `is_point_inside_polygon_2d ()`
  - Test 2D trace
- `is_point_inside_polygon_3d ()`
  - Test 3D trace
  - The points must lie in the same plane, possibly check beforehand

#### is_math_rotation_triangle [^][contents]
[is_math_rotation_triangle]: #is_math_rotation_triangle-
Returns `true` if the triangle is in mathematical rotation = counter clockwise.

_Arguments:_
```OpenSCAD
is_math_rotation_triangle (points)
```

#### is_math_rotation_polygon [^][contents]
[is_math_rotation_polygon]: #is_math_rotation_polygon-
Returns `true` if the polygon is in mathematical rotation.

_Arguments:_
```OpenSCAD
is_math_rotation_polygon (trace)
```


### Straight line, segment line and surfaces [^][contents]

#### get_gradient [^][contents]
[get_gradient]: #get_gradient-
Returns the gradient `[c, m]` of a line.  
The result can used as coefficient in function `polynomial()`

_Arguments:_
```OpenSCAD
get_gradient (line)
```
- `line` - a list with 2 points defines the straight line

In 2D plane:  
`y = m*x + c`  
Where `m` means the slope of the line
and `c` means the intercept of the line throw the Y axis.
Vertical lines don't work, then it returns `undef`.  
Calculation for `y` with known `x` can done with:

_Arguments:_
```OpenSCAD
line = [ [0,0], [1,2] ];
g = get_gradient_2d (line); // [c, m] = [0, 2]
x = 4;

y  = g[1]*x + g[0];         // 8
y_ = polynomial (x, g);     // 8
```

_In 3D space:_  
`[x,y] = m*z + c`  
Where `m` means the slope of the line on X-axis and Y-axis as list `[m_x, m_y]`
and `c` means the intercept of the line throw the XY-plane at `Z=0` as point `[x,y]`.
Horizontal lines don't work, then it returns `undef`.  
Calculation for a 2D point with known `z` can done with:

_Arguments:_
```OpenSCAD
line = [ [0,0,-1], [1,2,3] ];
g = get_gradient_3d (line); // [[0.25, 0.5], [0.25, 0.5]]
z = 1;

p  = g[1]*z + g[0];         // [0.5, 1]
p_ = polynomial (z, g);     // [0.5, 1]

show_line  (line);
show_point ([p.x,p.y, z], "green");
```

_Specialized functions:_
- `get_gradient_2d (line)` - only in 2D plane
- `get_gradient_3d (line)` - only in 3D space

#### get_intersection_lines [^][contents]
[get_intersection_lines]: #get_intersection_lines-
Returns the crossing point where two straight lines intersect.  
Only in 2D plane.

_Arguments:_
```OpenSCAD
get_intersection_lines (line1, line2)
```
- `line1` and `line2`
  - a list with 2 points defines the straight line

_Return:_
- straight lines intersect: the crossing point
- lines lie in each other:  `true`
- lines are parallel:       `false`

_Example:_
```OpenSCAD
include <banded.scad>

l1=[ [-1,-1],[2, 2] ];
l2=[ [-1, 1],[1,-1] ];

show_line( l1 );
show_line( l2 );

show_point( get_intersection_lines(l1,l2) ,"green");
echo( is_intersection_segments(l1,l2) ); // ECHO: true
```

#### get_intersection_line_plane [^][contents]
[get_intersection_line_plane]: #get_intersection_line_plane-
Returns the intersecting point of a straight line through a plane.  
In 3D space.

_Arguments:_
```OpenSCAD
get_intersection_line_plane (points, line)
```
- `points` - 3 points in a list defines the plane
- `line`     - 2 points in a list defines the straight line


### Polygon functions [^][contents]

#### length_line [^][contents]
[length_line]: #length_line-
Return the length of a line segment.

_Arguments:_
```OpenSCAD
length_line (line)
```
- `line`
  - a list with 2 points defines the ends of the segment line.

#### length_trace [^][contents]
[length_trace]: #length_trace-
Return the length of a trace.

_Arguments:_
```OpenSCAD
length_trace (points, path, closed)
```
- `points` - a list with points
- `trace`
  - a list with the order to traverse the points
  - is not defined, all points are used in the order listed
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

#### position_line [^][contents]
[position_line]: #position_line-
Determines the position of a line
starting at a specified distance from the first point.  
Larger lengths are extrapolated.

_Returns_ a point.

_Arguments:_
```OpenSCAD
position_line (line, length)
```
- `line`
  - a list with 2 points defines the ends of the segment line.
- `length`
  - distance from the first point

#### position_trace [^][contents]
[position_trace]: #position_trace-
Determines the position of a trace
starting at a specified distance from the first point.  
Returns `undef` if the distance is outside the line segment.
If the ends are connected (`closed = true`), it returns the position
corresponding to the number of rotations around.

_Returns_ a list in point-direction form `[point, vector]`
- `point`  - Position on the line segment at the desired length
- `vector` - Direction of the line segment at the position, not normalized

_Arguments:_
```OpenSCAD
position_trace (points, path, length, closed)
```
- `points` - a list with points
- `trace`
  - a list with the order to traverse the points
  - is not defined, all points are used in the order listed
- `length`
  - distance from the first point
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point


### Convert polygon data [^][contents]

#### trace_to_lines [^][contents]
[trace_to_lines]: #trace_to_lines-
Convert a trace to a list with line segment.

_Arguments:_
```OpenSCAD
trace_to_lines (trace, closed)
```
- `trace`
  - a point list
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

#### lines_to_trace [^][contents]
[lines_to_trace]: #lines_to_trace-
Connect all lines in a list and return the trace as a point list.

_Arguments:_
```OpenSCAD
lines_to_trace (lines)
```

#### line_to_vector [^][contents]
[line_to_vector]: #line_to_vector-
Convert a line defined by 2 points to point and vector.  
Returns a list `[ starting point, vector ]`

_Arguments:_
```OpenSCAD
line_to_vector (line)
```
- `line` - 2 points in a list defines the straight line

#### vector_to_line [^][contents]
[vector_to_line]: #vector_to_line-
Convert a line defined by a starting point and a vector
to a list with 2 points defines the straight line.  
Returns a list `[ point 1, point 2 ]`

_Arguments:_
```OpenSCAD
vector_to_line (vector)
```
- `vector` - a list `[ starting point, vector ]`


### Data from lines [^][contents]

#### distance_line [^][contents]
[distance_line]: #distance_line-
Get the nearest distance of a straight line to a point.  
Works in 2D and 3D.

_Arguments:_
```OpenSCAD
distance_line (line, p)
```
- `line`
  - a list with 2 points defines the straight line
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### distance_segment [^][contents]
[distance_segment]: #distance_segment-
Get the nearest distance of a segment line to a point.  
Works in 2D and 3D.

_Arguments:_
```OpenSCAD
distance_segment (line, p)
```
- `line`
  - a list with 2 points defines the ends of the segment line.
    Inclusive the points.
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### distance_trace [^][contents]
[distance_trace]: #distance_trace-
Get the nearest distance of a trace to a point.  
Works in 2D and 3D.

_Arguments:_
```OpenSCAD
distance_trace (trace, p, closed)
```
- `trace`
  - a list with points defines the trace.
- `p`
  - the point with distance from the trace
  - default = origin of coordinates
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

#### nearest_point_line [^][contents]
[nearest_point_line]: #nearest_point_line-
Get the point on a straight line with the nearest distance to a point.  
Works in 2D and 3D.

_Arguments:_
```OpenSCAD
nearest_point_line (line, p)
```
- `line`
  - a list with 2 points defines the straight line
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### nearest_point_segment [^][contents]
[nearest_point_segment]: #nearest_point_segment-
Get the point on a segment line with the nearest distance to a point.  
Works in 2D and 3D.

_Arguments:_
```OpenSCAD
nearest_point_segment (line, p)
```
- `line`
  - a list with 2 points defines the ends of the segment line.
    Inclusive the points.
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### nearest_point_trace [^][contents]
[nearest_point_trace]: #nearest_point_trace-
Get the point on a trace with the nearest distance to a point.  
Works in 2D and 3D.

_Arguments:_
```OpenSCAD
nearest_point_trace (trace, p, closed)
```
- `trace`
  - a list with points defines the trace.
- `p`
  - the point with distance from the trace
  - default = origin of coordinates
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

