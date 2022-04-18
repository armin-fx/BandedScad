Matrix and vector operations
============================

### defined in file
`banded/math.scad`\
` `| \
` `+--> ...\
` `+--> `banded/math_vector.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Matrix operations ->](matrix.md)

- [Vector operations][vector]
  - [Buildin vector operations in OpenSCAD][vector_buildin]
    - [Addition and subtraction][vector_add]
    - [Dot product or scalar multiplikation][vector_scalar]
    - [Cross product][vector_cross]
  - [Defined operations][vector_defined]
    - [`unit_vector()`][unit_vector]
    - [`angle_vector()`][angle_vector]
    - [`rotation_vector()`][rotation_vector]
    - [`rotation_around_vector()`][rotation_around_vector]
    - [`rotation_around_line()`][rotation_around_line]
    - [`triple_product()`][triple_product]
    - [`cross_universal()`][cross_universal]
  - [Euclidean norm](#euclidean-norm-)
    - [`reverse_norm()`][reverse_norm]
    - [`norm_sqr()`][norm_sqr]
    - [`max_norm()`][max_norm]
    - [`max_norm_sqr()`][max_norm_sqr]
  - [Vector test functions](#vector-test-functions-)
    - [`is_collinear()`][is_collinear]
    - [`is_nearly_collinear()`][is_nearly_collinear]
    - [`is_coplanar()`][is_coplanar]
    - [`is_nearly_coplanar()`][is_nearly_coplanar]


Vector operations [^][contents]
-------------------------------
[vector]: #vector-operations-

### Buildin vector operations in OpenSCAD [^][contents]
[vector_buildin]: #buildin-vector-operations-in-openscad-

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
[vector_defined]: #defined-operations-

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


### Vector test functions [^][contents]

#### `is_collinear (v1, v2)` [^][contents]
[is_collinear]: #is_collinear-v1-v2-
Return `true` if the 2 vectors are collinear.
This means they are parallel or anti parallel.

#### `is_nearly_collinear (v1, v2)` [^][contents]
[is_nearly_collinear]: #is_nearly_collinear-v1-v2-
Return `true` if the 2 vectors are nearly collinear.
- `deviation`
  - deviation of the target from the normalized vectors,
    as ratio - deviation per longest vector
  - default = `1e-14`, calculation deviation

#### `is_coplanar (v1, v2, v3)` [^][contents]
[is_coplanar]: #is_coplanar-v1-v2-v3-
Returns `true` if the 3 spanned vectors in 3D space are coplanar.
This means they are in the same plane.

#### `is_nearly_coplanar (v1, v2, v3)` [^][contents]
[is_nearly_coplanar]: #is_nearly_coplanar-v1-v2-v3-
Returns `true` if the 3 spanned vectors in 3D space are nearly coplanar.
- `deviation`
  - default = `1e-14`, calculation deviation

