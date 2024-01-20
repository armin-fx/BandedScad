Vector operations
=================

### defined in file
`banded/math.scad`\
` `| \
` `+--> ...\
` `+--> `banded/math_vector.scad`\

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Matrix operations ->](math_matrix.md)
- [Polygon operations ->](math_polygon.md)

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


Vector operations [^][contents]
-------------------------------


### Buildin vector operations in OpenSCAD [^][contents]

#### Addition and subtraction: [^][contents]
[vector_add]: #addition-and-subtraction-
```OpenSCAD
a = [1,2,3];
b = [1,1,2];

echo( a + b ); // addition,    return [2,3,5]
echo( a - b ); // subtraction, return [0,1,1]
```
#### Dot product or scalar multiplikation: [^][contents]
[vector_scalar]: #dot-product-or-scalar-multiplikation-
[=> Wikipedia - Dot product](https://en.wikipedia.org/wiki/Dot_product)
[=> Wikipedia - Scalar multiplication](https://en.wikipedia.org/wiki/Scalar_multiplication)
```OpenSCAD
a = [1,2,3];
b = [1,1,2];

echo( a * b ); // dot product,           return 9
echo( 2 * a ); // scalar multiplikation, return [2,4,6]
```
#### Cross product: [^][contents]
[vector_cross]: #cross-product-
[=> Wikipedia - Cross product](https://en.wikipedia.org/wiki/Cross_product)
```OpenSCAD
a = [1,2,3];
b = [1,1,2];

echo( cross( a, b ) ); // cross product, return [1,1,-1]
```


### Defined operations [^][contents]

#### unit_vector [^][contents]
[unit_vector]: #unit_vector-
Return the normalized vector of `v`.\
= vector in the same direction with length 1
```OpenSCAD
unit_vector (v)
```

[=> Wikipedia - Unit vector](https://en.wikipedia.org/wiki/Unit_vector)

#### angle_vector [^][contents]
[angle_vector]: #angle_vector-
Return the minimum angle inside 2 vector `v1` and `v2`
```OpenSCAD
angle_vector (v1, v2)
```

#### rotation_vector [^][contents]
[rotation_vector]: #rotation_vector-
Return the angle from vector `v1` to `v2` in 2D plane in
mathematical direction = counter clockwise\
If spatial 3D vector are used, only return the minimum angle inside `v1` and `v2`.
The 3D rotation vector can get with cross product `cross()`.
```OpenSCAD
rotation_vector (v1, v2)
```

#### rotation_around_vector [^][contents]
[rotation_around_vector]: #rotation_around_vector-
Return the angle around vector `v` from points `p1` to `p2` in
mathematical direction = counter clockwise.\
This is the angle you see if you show into the vector `v` from the upper side,
from point `p1` to `p2`.
```OpenSCAD
rotation_around_vector (v, p1, p2)
```
`v`  - vector, line defined from origin to this point
`p1` - first vector, rotate begin
`p2` - second vector, rotate end

#### rotation_around_line [^][contents]
[rotation_around_line]: #rotation_around_line-
Return the angle around a line from points `p1` to `p2` in
mathematical direction = counter clockwise.\
This is the angle you see if you show into the line from the upper side,
from point `p1` to `p2`.
```OpenSCAD
rotation_around_line (line, p1, p2)
```
`line` - 2 point list, line defined from first point to second point
`p1`   - first vector, rotate begin
`p2`   - second vector, rotate end

#### normal_vector [^][contents]
[normal_vector]: #normal_vector-
Return the normal vector of vector `v` and `w`.\
A normal is an object such as a line, ray, or vector
that is perpendicular to a given object.
```OpenSCAD
normal_vector (v, w)
```
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

#### normal_unit_vector [^][contents]
[normal_unit_vector]: #normal_unit_vector-
Return the normal unit vector of vector `v` and `w`.\
A normal is an object such as a line, ray, or vector
that is perpendicular to a given object.
A normal unit vector has the length 1.
```OpenSCAD
normal_unit_vector (v, w)
```
- 2D vector -> 2D normal vector
  - only `v` is needed,
  - returns the vector in right angle to `v` around origin
- 3D vector -> 3D normal vector = cross product
  - needs `v` and `w`
  - returns a vector that is perpendicular to a spanned plane
    defined by 3 points origin, `v` and `w` as point

#### normal_triangle [^][contents]
[normal_triangle]: #normal_triangle-
Return the normal vector of a triangle
defined by 3 points in 3D space.
```OpenSCAD
normal_triangle (p1, p2, p3, points)
```
- 3 points defined in `p1`, `p2` and `p2`
- or 3 points in a list `points`

#### triple_product [^][contents]
[triple_product]: #triple_product-
Calculate the triple productof three 3-dimensional vectors `a`, `b` and `c`.
Return the (signed) volume of the parallelepiped defined by the three vectors given.\
```OpenSCAD
triple_product (a, b, c)
```
[=> Wikipedia - Triple product](https://en.wikipedia.org/wiki/Triple_product)

#### cross_universal [^][contents]
[cross_universal]: #cross_universal-
Calculate the cross product for n dimensional vector in a list of n-1 vectors.\
Characteristic in this version:
- it uses the right hand rule in every dimension
- if will set in order the n-1 unit vector,
  then the last missing unit vector will be the result
```OpenSCAD
cross_universal (list)
```


### Test functions for vector [^][contents]

#### is_collinear [^][contents]
[is_collinear]: #is_collinear-
Return `true` if the 2 vectors are collinear.
This means they are parallel or anti parallel.
```OpenSCAD
is_collinear (v1, v2)
```

#### is_nearly_collinear [^][contents]
[is_nearly_collinear]: #is_nearly_collinear-
Return `true` if the 2 vectors are nearly collinear.
```OpenSCAD
is_nearly_collinear (v1, v2, deviation)
```
- `deviation`
  - deviation of the target from the normalized vectors,
    as ratio - deviation per longest vector
  - to prevent calculation deviation
  - default = `1e-14`, defined in customizable constant `deviation`

#### is_coplanar [^][contents]
[is_coplanar]: #is_coplanar-
Returns `true` if the 3 spanned vectors in 3D space are coplanar.
This means they are in the same plane.
```OpenSCAD
is_coplanar (v1, v2, v3)
```

#### is_nearly_coplanar [^][contents]
[is_nearly_coplanar]: #is_nearly_coplanar-
Returns `true` if the 3 spanned vectors in 3D space are nearly coplanar.
```OpenSCAD
is_nearly_coplanar (v1, v2, v3, deviation)
```
- `deviation`
  - to prevent calculation deviation
  - default = `1e-14`, defined in customizable constant `deviation`


### Euclidean norm [^][contents]

#### reverse_norm [^][contents]
[reverse_norm]: #reverse_norm-
Invert the euclidean norm
```OpenSCAD
reverse_norm (n, v)
```
- `n` - diagonal value or value of euclidean norm
- `v` - cathetus or a list of cathetus

_Example:_
```OpenSCAD
include <banded.scad>

echo( norm         (  [4,3]) ); // 5
echo( reverse_norm (5, 4   ) ); // 3

echo( norm         (    [12,4,3]) ); // 13
echo( reverse_norm (13, [12,4]  ) ); // 3
```

#### norm_sqr [^][contents]
[norm_sqr]: #norm_sqr-
Returns the squared euclidean norm of a vector.
```OpenSCAD
norm_sqr (v)
```

#### max_norm [^][contents]
[max_norm]: #max_norm-
Returns the maximum possible space diagonal of all vectors in a list.
```OpenSCAD
max_norm (list)
```

#### max_norm_sqr [^][contents]
[max_norm_sqr]: #max_norm_sqr-
Returns the maximum possible squared space diagonal of all vectors in a list.
```OpenSCAD
max_norm_sqr (list)
```

