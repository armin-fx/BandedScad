Matrix and vector operations
============================

### defined in file
`banded/math.scad`\
` `| \
` `+--> ...\
` `+--> `banded/math_vector.scad`\
` `+--> `banded/math_polygon.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Matrix operations ->](math_matrix.md)

- [Vector operations](#vector-operations-)
  - [Buildin vector operations in OpenSCAD](#buildin-vector-operations-in-openscad-)
    - [Addition and subtraction][vector_add]
    - [Dot product or scalar multiplikation][vector_scalar]
    - [Cross product][vector_cross]
  - [Defined operations](#defined-operations-)
    - [`unit_vector()`][unit_vector]
    - [`angle_vector()`][angle_vector]
    - [`rotation_vector()`][rotation_vector]
    - [`rotation_around_vector()`][rotation_around_vector]
    - [`rotation_around_line()`][rotation_around_line]
    - [`normal_vector()`][normal_vector]
    - [`normal_unit_vector()`][normal_unit_vector]
    - [`normal_triangle()`][normal_triangle]
    - [`triple_product()`][triple_product]
    - [`cross_universal()`][cross_universal]
  - [Test functions for vector](#test-functions-for-vector-)
    - [`is_collinear()`][is_collinear]
    - [`is_nearly_collinear()`][is_nearly_collinear]
    - [`is_coplanar()`][is_coplanar]
    - [`is_nearly_coplanar()`][is_nearly_coplanar]
  - [Euclidean norm](#euclidean-norm-)
    - [`reverse_norm()`][reverse_norm]
    - [`norm_sqr()`][norm_sqr]
    - [`max_norm()`][max_norm]
    - [`max_norm_sqr()`][max_norm_sqr]
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
    - [`length_trace()`][length_trace]
    - [`length_line()`][length_line]
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


Vector operations [^][contents]
-------------------------------


### Buildin vector operations in OpenSCAD [^][contents]

#### Addition and subtraction [^][contents]
[vector_add]: #addition-and-subtraction-
```OpenSCAD
a = [1,2,3];
b = [1,1,2];

echo( a + b ); // addition,    return [2,3,5]
echo( a - b ); // subtraction, return [0,1,1]
```
#### Dot product or scalar multiplikation [^][contents]
[vector_scalar]: #dot-product-or-scalar-multiplikation-
[=> Wikipedia - Dot product](https://en.wikipedia.org/wiki/Dot_product)
[=> Wikipedia - Scalar multiplication](https://en.wikipedia.org/wiki/Scalar_multiplication)
```OpenSCAD
a = [1,2,3];
b = [1,1,2];

echo( a * b ); // dot product,           return 9
echo( 2 * a ); // scalar multiplikation, return [2,4,6]
```
#### Cross product [^][contents]
[vector_cross]: #cross-product-
[=> Wikipedia - Cross product](https://en.wikipedia.org/wiki/Cross_product)
```OpenSCAD
a = [1,2,3];
b = [1,1,2];

echo( cross( a, b ) ); // cross product, return [1,1,-1]
```


### Defined operations [^][contents]

#### `unit_vector (v)` [^][contents]
[unit_vector]: #unit_vector-v-
Return the normalized vector of `v`.\
= vector in the same direction with length 1

[=> Wikipedia - Unit vector](https://en.wikipedia.org/wiki/Unit_vector)

#### `angle_vector (v1, v2)` [^][contents]
[angle_vector]: #angle_vector-v1-v2-
Return the minimum angle inside 2 vector `v1` and `v2`

#### `rotation_vector (v1, v2)` [^][contents]
[rotation_vector]: #rotation_vector-v1-v2-
Return the angle from vector `v1` to `v2` in 2D plane in
mathematical direction = counter clockwise\
If spatial 3D vector are used, only return the minimum angle inside `v1` and `v2`.
The 3D rotation vector can get with cross product `cross()`.

#### `rotation_around_vector (v, p1, p2)` [^][contents]
[rotation_around_vector]: #rotation_around_vector-v-p1-p2-
Return the angle around vector `v` from points `p1` to `p2` in
mathematical direction = counter clockwise.\
This is the angle you see if you show into the vector `v` from the upper side,
from point `p1` to `p2`.
`v`  - vector, line defined from origin to this point
`p1` - first vector, rotate begin
`p2` - second vector, rotate end

#### `rotation_around_line (line, p1, p2)` [^][contents]
[rotation_around_line]: #rotation_around_line-line-p1-p2-
Return the angle around a line from points `p1` to `p2` in
mathematical direction = counter clockwise.\
This is the angle you see if you show into the line from the upper side,
from point `p1` to `p2`.
`line` - 2 point list, line defined from first point to second point
`p1`   - first vector, rotate begin
`p2`   - second vector, rotate end

#### `normal_vector (v, w)` [^][contents]
[normal_vector]: #normal_vector-v-w-
Return the normal vector of vector `v` and `w`.\
A normal is an object such as a line, ray, or vector
that is perpendicular to a given object.
- 2D vector -> 2D normal vector
  - only `v` is needed,
  - returns the vector in right angle to `v` around origin
  - the length of the returned vector is the same length like `v`
- 3D vector -> 3D normal vector = cross product
  - needs `v` and `w`
  - returns a vector that is perpendicular to a spanned plane
    defined by 3 points origin, `v` and `w` as point
  - the length of the returned vector
    is the directed area of the spanned vectors as parallelogram

#### `normal_unit_vector (v, w)` [^][contents]
[normal_unit_vector]: #normal_unit_vector-v-w-
Return the normal unit vector of vector `v` and `w`.\
A normal is an object such as a line, ray, or vector
that is perpendicular to a given object.
A normal unit vector has the length 1.
- 2D vector -> 2D normal vector
  - only `v` is needed,
  - returns the vector in right angle to `v` around origin
- 3D vector -> 3D normal vector = cross product
  - needs `v` and `w`
  - returns a vector that is perpendicular to a spanned plane
    defined by 3 points origin, `v` and `w` as point

#### `normal_triangle (p1, p2, p3, points)` [^][contents]
[normal_triangle]: #normal_triangle-p1-p2-p3-
Return the normal vector of a triangle
defined by 3 points in 3D space.
- 3 points defined in `p1`, `p2` and `p2`
- or 3 points in a list `points`

#### `triple_product (a, b, c)` [^][contents]
[triple_product]: #triple_product-a-b-c-
Calculate the triple productof three 3-dimensional vectors `a`, `b` and `c`.
Return the (signed) volume of the parallelepiped defined by the three vectors given.\
[=> Wikipedia - Triple product](https://en.wikipedia.org/wiki/Triple_product)

#### `cross_universal (list)` [^][contents]
[cross_universal]: #cross_universal-list-
Calculate the cross product for n dimensional vector in a list of n-1 vectors.\
Characteristic in this version:
- it uses the right hand rule in every dimension
- if will set in order the n-1 unit vector,
  then the last missing unit vector will be the result


### Test functions for vector [^][contents]

#### `is_collinear (v1, v2)` [^][contents]
[is_collinear]: #is_collinear-v1-v2-
Return `true` if the 2 vectors are collinear.
This means they are parallel or anti parallel.

#### `is_nearly_collinear (v1, v2, deviation)` [^][contents]
[is_nearly_collinear]: #is_nearly_collinear-v1-v2-deviation-
Return `true` if the 2 vectors are nearly collinear.
- `deviation`
  - deviation of the target from the normalized vectors,
    as ratio - deviation per longest vector
  - to prevent calculation deviation
  - default = `1e-14`, defined in customizable constant `deviation`

#### `is_coplanar (v1, v2, v3)` [^][contents]
[is_coplanar]: #is_coplanar-v1-v2-v3-
Returns `true` if the 3 spanned vectors in 3D space are coplanar.
This means they are in the same plane.

#### `is_nearly_coplanar (v1, v2, v3, deviation)` [^][contents]
[is_nearly_coplanar]: #is_nearly_coplanar-v1-v2-v3-deviation-
Returns `true` if the 3 spanned vectors in 3D space are nearly coplanar.
- `deviation`
  - to prevent calculation deviation
  - default = `1e-14`, defined in customizable constant `deviation`


### Euclidean norm [^][contents]

#### `reverse_norm (n, v)` [^][contents]
[reverse_norm]: #reverse_norm-n-v-
Invert the euclidean norm
- `n` - diagonal value or value of euclidean norm
- `v` - cathetus or a list of cathetus

Example:
```OpenSCAD
include <banded.scad>

echo( norm         (  [4,3]) ); // 5
echo( reverse_norm (5, 4   ) ); // 3

echo( norm         (    [12,4,3]) ); // 13
echo( reverse_norm (13, [12,4]  ) ); // 3
```

#### `norm_sqr (v)` [^][contents]
[norm_sqr]: #norm_sqr-v-
Returns the squared euclidean norm of a vector.

#### `max_norm (list)` [^][contents]
[max_norm]: #max_norm-list-
Returns the maximum possible space diagonal of all vectors in a list.

#### `max_norm_sqr (list)` [^][contents]
[max_norm_sqr]: #max_norm_sqr-list-
Returns the maximum possible squared space diagonal of all vectors in a list.


Polygones and Lines [^][contents]
---------------------------------


### Test functions for lines [^][contents]

#### `is_point_on_line (line, point)` [^][contents]
[is_point_on_line]: #is_point_on_line-line-point-
Returns `true` if a point is exactly on a straight line.\
In 2D or 3D.
- `line` - a list with 2 points defines a straight line

#### `is_point_on_segment (line, point, ends)` [^][contents]
[is_point_on_segment]: #is_point_on_segment-line-point-
Returns `true` if a point is exactly on a line segment.\
Inclusive on the points.
In 2D or 3D.
- `line` - a list with 2 points defines the line segment
- `ends` - defines whether the endpoint is within the segment
  - `0`   - default, both sides are within the segment
  - `< 0` - left point is within the segment, e.g. `-1`
  - `> 0` - right point is within the segment, e.g. `1`

#### `is_point_on_plane (points, point)` [^][contents]
[is_point_on_plane]: #is_point_on_plane-points-point-
Returns `true` if a point lies exactly in a plane.\
In 3D.
- `points` - 3 points in a list defines the plane

#### `is_point_upper_plane (points, point)` [^][contents]
[is_point_upper_plane]: #is_point_upper_plane-points-point-
Returns `true` if a point is upper a plane.\
In 3D.
Upper side means the same side of the direction of the normal vector
from the triangle defined by the 3 points.
- `points` - 3 points in a list defines the plane

#### `is_intersection_segments (line1, line2, point, no_parallel, ends)` [^][contents]
[is_intersection_segments]: #is_intersection_segments-line1-line2-point-no_parallel-
Returns `true` if two line segment intersect.\
Only in 2D plane.
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

#### `is_intersection_polygon_segment (points, line, path, without)` [^][contents]
[is_intersection_polygon_segment]: #is_intersection_polygon_segment-points-line-path-without-
Returns `true` if a line segment intersect any line from a polygon.\
Only in 2D plane.
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

#### `is_point_inside_triangle (points, point, border, rotation)` [^][contents]
[is_point_inside_triangle]: #is_point_inside_triangle-points-point-border-rotation-
Returns `true` if a point lies exactly in a triangle.\
Inclusive the on the line.
Only 2D plane.
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


#### `is_point_inside_polygon (points, p, face)` [^][contents]
[is_point_inside_polygon]: #is_point_inside_polygon-points-p-face-
Returns `true` if a point lies exactly in a closed trace.\
Inclusive the on the line.
The border of the trace must not intersect itself.
In 2D and 3D.
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

#### `is_math_rotation_triangle (points)` [^][contents]
[is_math_rotation_triangle]: #is_math_rotation_triangle-points-
Returns `true` if the triangle is in mathematical rotation = counter clockwise.

#### `is_math_rotation_polygon (trace)` [^][contents]
[is_math_rotation_polygon]: #is_math_rotation_polygon-trace-
Returns `true` if the polygon is in mathematical rotation.


### Straight line, segment line and surfaces [^][contents]

#### `get_gradient (line)` [^][contents]
[get_gradient]: #get_gradient-line-
Returns the gradient `[c, m]` of a line.\
The result can used as coefficient in function `polynomial()`
- `line` - a list with 2 points defines the straight line

In 2D plane:\
`y = m*x + c`\
Where `m` means the slope of the line
and `c` means the intercept of the line throw the Y axis.
Vertical lines don't work, then it returns `undef`.\
Calculation for `y` with known `x` can done with:
```OpenSCAD
line = [ [0,0], [1,2] ];
g = get_gradient_2d (line); // [c, m] = [0, 2]
x = 4;

y  = g[1]*x + g[0];         // 8
y_ = polynomial (x, g);     // 8
```

In 3D space:\
`[x,y] = m*z + c`\
Where `m` means the slope of the line on X-axis and Y-axis as list `[m_x, m_y]`
and `c` means the intercept of the line throw the XY-plane at `Z=0` as point `[x,y]`.
Horizontal lines don't work, then it returns `undef`.\
Calculation for a 2D point with known `z` can done with:
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

#### `get_intersection_lines (line1, line2)` [^][contents]
[get_intersection_lines]: #get_intersection_lines-line1-line2-
Returns the crossing point where two straight lines intersect.\
Only in 2D plane.
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

#### `get_intersection_line_plane (points, line)` [^][contents]
[get_intersection_line_plane]: #get_intersection_line_plane-points-line-
Returns the intersecting point of a straight line through a plane.\
In 3D space.
- `points` - 3 points in a list defines the plane
- `line`     - 2 points in a list defines the straight line


### Polygon functions [^][contents]

#### `length_trace (points, path, closed)` [^][contents]
[length_trace]: #length_trace-points-path-closed-
Return the length of a trace.
- `points` - a list with points
- `trace`
  - a list with the order to traverse the points
  - is not defined, all points are used in the order listed
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

#### `length_line (line)` [^][contents]
[length_line]: #length_line-line-
Return the length of a line segment.
- `line`
  - a list with 2 points defines the ends of the segment line.


### Convert polygon data [^][contents]

#### `trace_to_lines (trace, closed)` [^][contents]
[trace_to_lines]: #trace_to_lines-trace-closed-
Convert a trace to a list with line segment.
- `trace`
  - a point list
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

#### `lines_to_trace (lines)` [^][contents]
[lines_to_trace]: #lines_to_trace-lines-
Connect all lines in a list and return the trace as a point list.

#### `line_to_vector (line)` [^][contents]
[line_to_vector]: #line_to_vector-line-
Convert a line defined by 2 points to point and vector.\
Returns a list `[ starting point, vector ]`
- `line` - 2 points in a list defines the straight line

#### `vector_to_line (vector)` [^][contents]
[vector_to_line]: #vector_to_line-vector-
Convert a line defined by a starting point and a vector
a list with 2 points defines the straight line.\
Returns a list `[ point 1, point 2 ]`
- `vector` - a list `[ starting point, vector ]`


### Data from lines [^][contents]

#### `distance_line (line, p)` [^][contents]
[distance_line]: #distance_line-line-p-
Get the nearest distance of a straight line to a point.\
Works in 2D and 3D.
- `line`
  - a list with 2 points defines the straight line
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### `distance_segment (line, p)` [^][contents]
[distance_segment]: #distance_segment-line-p-
Get the nearest distance of a segment line to a point.\
Works in 2D and 3D.
- `line`
  - a list with 2 points defines the ends of the segment line.
    Inclusive the points.
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### `distance_trace (trace, p, closed)` [^][contents]
[distance_trace]: #distance_trace-trace-p-closed-
Get the nearest distance of a trace to a point.\
Works in 2D and 3D.
- `trace`
  - a list with points defines the trace.
- `p`
  - the point with distance from the trace
  - default = origin of coordinates
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

#### `nearest_point_line (line, p)` [^][contents]
[nearest_point_line]: #nearest_point_line-line-p-
Get the point on a straight line with the nearest distance to a point.\
Works in 2D and 3D.
- `line`
  - a list with 2 points defines the straight line
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### `nearest_point_segment (line, p)` [^][contents]
[nearest_point_segment]: #nearest_point_segment-line-p-
Get the point on a segment line with the nearest distance to a point.\
Works in 2D and 3D.
- `line`
  - a list with 2 points defines the ends of the segment line.
    Inclusive the points.
- `p`
  - the point with distance from the line
  - default = origin of coordinates

#### `nearest_point_trace (trace, p, closed)` [^][contents]
[nearest_point_trace]: #nearest_point_trace-trace-p-closed-
Get the point on a trace with the nearest distance to a point.\
Works in 2D and 3D.
- `trace`
  - a list with points defines the trace.
- `p`
  - the point with distance from the trace
  - default = origin of coordinates
- `closed`
  - `false` - the trace from first to last point, default
  - `true`  - the trace is a closed loop, the last point connect the first point

