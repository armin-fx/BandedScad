Matrix and vector operations
============================

### defined in file
`banded/math.scad`\
` `| \
` `+--> ...\
` `+--> `banded/math_vector.scad`\
` `+--> `banded/math_matrix.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
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
- [Matrix operations][matrix]
  - [Buildin matrix operations in OpenSCAD][matrix_buildin]
    - [Matrix addition and subtraction][matrix_add]
    - [Matrix multiplication][matrix_mul]
  - [Defined matrix operations][matrix_defined]
    - [`identity_matrix()`][identity_matrix]
    - [`determinant()`][determinant]
    - [`transpose()`][transpose]
    - [`inverse()`][inverse]
    - [`gauss_jordan_elimination()`][gauss_jordan_elimination]
    - [`reduced_row_echelon_form()`][reduced_row_echelon_form]
    - [`back_substitution()`][back_substitution]
  - [Edit the content of a matrix][matrix_edit]
    - [`matrix_cut_row()`][matrix_cut_row]
    - [`matrix_cut_column()`][matrix_cut_column]
    - [`matrix_minor()`][matrix_minor]
    - [`matrix_insert_row()`][matrix_insert_row]
    - [`matrix_insert_column()`][matrix_insert_column]
    - [`matrix_replace_row()`][matrix_replace_row]
    - [`matrix_replace_column()`][matrix_replace_column]
    - [`concat_matrix()`][concat_matrix]


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


Matrix operations [^][contents]
-------------------------------
[matrix]: #matrix-operations-

### Buildin matrix operations in OpenSCAD [^][contents]
[matrix_buildin]: #buildin-matrix-operations-in-openscad-

#### Matrix addition and subtraction [^][contents]
[matrix_add]: #matrix-addition-and-subtraction-
```OpenSCAD
a = [ [2,3],[3,4] ];
b = [ [1,1],[2,2] ];

echo( a + b ); // addition,       result [ [3,4],[5,6] ]
echo( a - b ); // subtraction,    result [ [1,2],[1,2] ]
```

#### Matrix multiplication [^][contents]
[matrix_mul]: #matrix-multiplication-
```OpenSCAD
a = [ [2,3],[3,4] ];
b = [ [1,1],[2,2] ];

echo( a * b ); // matrix multiplication, result [ [8,8],[11,11] ]
echo( 2 * a ); // scalar multiplication, result [ [4,6],[6,8] ]
```


### Defined matrix operations [^][contents]
[matrix_defined]: #defined-matrix-operations-

#### `identity_matrix (n)` [^][contents]
[identity_matrix]: #identity_matrix-n-
Generate the identity matrix with size `n` × `n`.\
The identity matrix of size `n` is the n × n square matrix with ones on the main diagonal and zeros elsewhere.
```
[1 0 0]
[0 1 0]
[0 0 1]
```
[=> Wikipedia - Identity matrix](https://en.wikipedia.org/wiki/Identity_matrix)

#### `determinant (m)` [^][contents]
[determinant]: #determinant-m-
Return the determinant of a n × n matrix `m`.\
The entries in matrix `m` accept numeric values and vectors.\
A value of a determinant is the directed n dimensional volume of all
spanned vectors of the matrix.\
[=> Wikipedia - Determinant](https://en.wikipedia.org/wiki/Determinant)

Short name: `det (m)`

___Specialized function with fixed matrix size:___
- `det_2x2 (m)` - determinant of a 2 × 2 matrix
- `det_3x3 (m)` - determinant of a 3 × 3 matrix

#### `transpose (m)` [^][contents]
[transpose]: #transpose-m-
Transpose a matrix `m`.\
The transpose of a matrix is an operator which flips a matrix over its diagonal.\
[=> Wikipedia - Transpose](https://en.wikipedia.org/wiki/Transpose)

```
  [1 2 3]  transpose   [1 4]
  [4 5 6] ---------->  [2 5]
                       [3 6]
```

#### `inverse (m)` [^][contents]
[inverse]: #inverse-m-
Return the inverse of a matrix `m`.\
Return `undef` if `m` is not invertible.\
The multiplication of `m * inverse(m)` get the identity matrix.\
[=> Wikipedia - Invertible matrix](https://en.wikipedia.org/wiki/Invertible_matrix)

#### `gauss_jordan_elimination (m, a, clean)` [^][contents]
[gauss_jordan_elimination]: #gauss_jordan_elimination-m-a-clean-
Gauss-Jordan elimination is an algorithm in linear algebra for solving
a system of linear equations.\
[=> Wikipedia - Gaussian elimination ](https://en.wikipedia.org/wiki/Gaussian_elimination)

First the matrix will set in reduced row echelon form. This means:
- The first entries in a row are filled with zeros and leading with a 1
- Every next row has his leading 1 minimum at 1 step next position

Next the upper triangle will set to zeros with back substitution.\
In the end the matrix should contain the identity matrix in first columns
and the result in the last columns.
```
[2 4 4 10]  reduced row   [1 2 2  5]  back          [1 0 0 -1]
[4 5 2  8]  echelon form  [0 1 2  4]  substitution  [0 1 0  2]
[4 1 8  6] -------------> [0 0 1  1] -------------> [0 0 1  1]
```

Options:
- `m` - n×n or n×o matrix, o>=n
- `a` - optional an additional matrix n×p, p>=1, which will append at the last column at matrix `m`
  - can be a list which will append on `m` as a column
- clean
  - true  - remove identity matrix part and keep only the result
  - false - standard, leave result with identity matrix on the first columns

#### `reduced_row_echelon_form (m)` [^][contents]
[reduced_row_echelon_form]: #reduced_row_echelon_form-m-
Bring a matrix `m` in reduced row echelon form.\
[=> Wikipedia - Row echelon form](https://en.wikipedia.org/wiki/Row_echelon_form)

#### `back_substitution (m)` [^][contents]
[back_substitution]: #back_substitution-m-
Run back substitution on matrix `m` which is set in row echelon form.\
The upper triangle will set to zeros and the main diagonal will set to 1.


### Edit the content of a matrix [^][contents]
[matrix_edit]: #edit-the-content-of-a-matrix-

#### `matrix_cut_row (m, i)` [^][contents]
[matrix_cut_row]: #matrix_cut_row-m-i-
Cut out a row at position `i` from the matrix `m`.
```
matrix_cut_row (m, 1):

    [1 2 3]
--> [2 3 4] <--
    [4 5 6]

Result:

    [1 2 3]
    [4 5 6]
```

#### `matrix_cut_column (m, j)` [^][contents]
[matrix_cut_column]: #matrix_cut_column-m-j-
Cut out a column at position `j` from the matrix `m`.
```
matrix_cut_column (m, 1):
     |
  [1 2 3]  Result:  [1 3]
  [2 3 4] --------> [2 4]
  [4 5 6]           [4 6]
     |
```

#### `matrix_minor (m, i, j)` [^][contents]
[matrix_minor]: #matrix_minor-m-i-j-
Cut out a row `i` and a column `j` from the matrix `m` = minor matrix.
```
matrix_minor (m, 0, 1):
       |
--> [1 2 3] <---
    [2 3 4]
    [4 5 6]
       |
Result:

    [2 4]
    [4 6]
```

#### `matrix_insert_row (m, x, i)` [^][contents]
[matrix_insert_row]: #matrix_insert_row-m-x-i-
Insert a line `x` into matrix `m` at row position `i`.

#### `matrix_insert_column (m, x, j)` [^][contents]
[matrix_insert_column]: #matrix_insert_column-m-x-j-
Insert a line `x` into matrix `m` at column position `j`.

#### `matrix_replace_row (m, x, i)` [^][contents]
[matrix_replace_row]: #matrix_replace_row-m-x-i-
Replace a row in matrix `m` at position `i` with line `x`.

#### `matrix_replace_column (m, x, i)` [^][contents]
[matrix_replace_column]: #matrix_replace_column-m-x-i-
Replace a column in matrix `m` at position `i` with line `x`.

#### `concat_matrix (m, a)` [^][contents]
[concat_matrix]: #concat_matrix-m-a-
Append matrix `a` to matrix `m` in each row.
```
  m:      a:
 [1 2]   [5 5]  Result:  [1 2 5 5]
 [2 3]   [6 6] --------> [2 3 6 6]
```

