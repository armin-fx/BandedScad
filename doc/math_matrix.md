Matrix and vector operations
============================

### defined in file
`banded/math.scad`  
` `|  
` `+--> ...  
` `+--> `banded/math_matrix.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

[<-- Math functions](math.md)

### Contents
[contents]: #contents "Up to Contents"
- [Vector operations ->](math_vector.md)

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


Matrix operations [^][contents]
-------------------------------
[matrix]: #matrix-operations-

### Buildin matrix operations in OpenSCAD [^][contents]
[matrix_buildin]: #buildin-matrix-operations-in-openscad-

#### Matrix addition and subtraction: [^][contents]
[matrix_add]: #matrix-addition-and-subtraction-
```OpenSCAD
a = [ [2,3],[3,4] ];
b = [ [1,1],[2,2] ];

echo( a + b ); // addition,       result [ [3,4],[5,6] ]
echo( a - b ); // subtraction,    result [ [1,2],[1,2] ]
```

#### Matrix multiplication: [^][contents]
[matrix_mul]: #matrix-multiplication-
```OpenSCAD
a = [ [2,3],[3,4] ];
b = [ [1,1],[2,2] ];

echo( a * b ); // matrix multiplication, result [ [8,8],[11,11] ]
echo( 2 * a ); // scalar multiplication, result [ [4,6],[6,8] ]
```


### Defined matrix operations [^][contents]
[matrix_defined]: #defined-matrix-operations-

#### identity_matrix [^][contents]
[identity_matrix]: #identity_matrix-
Generate the identity matrix with size `n` × `n`.  
The identity matrix of size `n` is the n × n square matrix with ones on the main diagonal and zeros elsewhere.
```
[1 0 0]
[0 1 0]
[0 0 1]
```
[=> Wikipedia - Identity matrix](https://en.wikipedia.org/wiki/Identity_matrix)

_Arguments:_
```OpenSCAD
identity_matrix (n)
```

#### determinant [^][contents]
[determinant]: #determinant-
Return the determinant of a n × n matrix `m`.  
The entries in matrix `m` accept numeric values and vectors.  
A value of a determinant is the directed n dimensional volume of all
spanned vectors of the matrix.  
[=> Wikipedia - Determinant](https://en.wikipedia.org/wiki/Determinant)

_Arguments:_
```OpenSCAD
determinant (m)
```

_Short name:_
- `det (m)`

_Specialized function with fixed matrix size:_
- `det_2x2 (m)` - determinant of a 2 × 2 matrix
- `det_3x3 (m)` - determinant of a 3 × 3 matrix

#### transpose [^][contents]
[transpose]: #transpose-
Transpose a matrix `m`.  
The transpose of a matrix is an operator which flips a matrix over its diagonal.  
[=> Wikipedia - Transpose](https://en.wikipedia.org/wiki/Transpose)

```
  [1 2 3]  transpose   [1 4]
  [4 5 6] ---------->  [2 5]
                       [3 6]
```

_Arguments:_
```OpenSCAD
transpose (m)
```

#### inverse [^][contents]
[inverse]: #inverse-
Return the inverse of a matrix `m`.  
Return `undef` if `m` is not invertible.  
The multiplication of `m * inverse(m)` get the identity matrix.  
[=> Wikipedia - Invertible matrix](https://en.wikipedia.org/wiki/Invertible_matrix)

_Arguments:_
```OpenSCAD
inverse (m)
```

#### gauss_jordan_elimination [^][contents]
[gauss_jordan_elimination]: #gauss_jordan_elimination-
Gauss-Jordan elimination is an algorithm in linear algebra for solving
a system of linear equations.  
[=> Wikipedia - Gaussian elimination ](https://en.wikipedia.org/wiki/Gaussian_elimination)

First the matrix will set in reduced row echelon form. This means:
- The first entries in a row are filled with zeros and leading with a 1
- Every next row has his leading 1 minimum at 1 step next position

Next the upper triangle will set to zeros with back substitution.  
In the end the matrix should contain the identity matrix in first columns
and the result in the last columns.
```
[2 4 4 10]  reduced row   [1 2 2  5]  back          [1 0 0 -1]
[4 5 2  8]  echelon form  [0 1 2  4]  substitution  [0 1 0  2]
[4 1 8  6] -------------> [0 0 1  1] -------------> [0 0 1  1]
```

_Arguments:_
```OpenSCAD
gauss_jordan_elimination (m, a, clean)
```
- `m` - n×n or n×o matrix, o>=n
- `a` - optional an additional matrix n×p, p>=1, which will append at the last column at matrix `m`
  - can be a list which will append on `m` as a column
- clean
  - true  - remove identity matrix part and keep only the result
  - false - standard, leave result with identity matrix on the first columns

#### reduced_row_echelon_form [^][contents]
[reduced_row_echelon_form]: #reduced_row_echelon_form-
Bring a matrix `m` in reduced row echelon form.  
[=> Wikipedia - Row echelon form](https://en.wikipedia.org/wiki/Row_echelon_form)

_Arguments:_
```OpenSCAD
reduced_row_echelon_form (m)
```

#### back_substitution [^][contents]
[back_substitution]: #back_substitution-
Run back substitution on matrix `m` which is set in row echelon form.  
The upper triangle will set to zeros and the main diagonal will set to 1.

_Arguments:_
```OpenSCAD
back_substitution (m)
```


### Edit the content of a matrix [^][contents]
[matrix_edit]: #edit-the-content-of-a-matrix-

#### matrix_cut_row [^][contents]
[matrix_cut_row]: #matrix_cut_row-
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

_Arguments:_
```OpenSCAD
matrix_cut_row (m, i)
```

#### matrix_cut_column [^][contents]
[matrix_cut_column]: #matrix_cut_column-
Cut out a column at position `j` from the matrix `m`.
```
matrix_cut_column (m, 1):
     |
  [1 2 3]  Result:  [1 3]
  [2 3 4] --------> [2 4]
  [4 5 6]           [4 6]
     |
```

_Arguments:_
```OpenSCAD
matrix_cut_column (m, j)
```

#### matrix_minor [^][contents]
[matrix_minor]: #matrix_minor-
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

_Arguments:_
```OpenSCAD
matrix_minor (m, i, j)
```

#### matrix_insert_row [^][contents]
[matrix_insert_row]: #matrix_insert_row-
Insert a line `x` into matrix `m` at row position `i`.

_Arguments:_
```OpenSCAD
matrix_insert_row (m, x, i)
```

#### matrix_insert_column [^][contents]
[matrix_insert_column]: #matrix_insert_column-
Insert a line `x` into matrix `m` at column position `j`.

_Arguments:_
```OpenSCAD
matrix_insert_column (m, x, j)
```

#### matrix_replace_row [^][contents]
[matrix_replace_row]: #matrix_replace_row-
Replace a row in matrix `m` at position `i` with line `x`.

_Arguments:_
```OpenSCAD
matrix_replace_row (m, x, i)
```

#### matrix_replace_column [^][contents]
[matrix_replace_column]: #matrix_replace_column-
Replace a column in matrix `m` at position `i` with line `x`.

_Arguments:_
```OpenSCAD
matrix_replace_column (m, x, i)
```

#### concat_matrix [^][contents]
[concat_matrix]: #concat_matrix-
Append matrix `a` to matrix `m` in each row.
```
  m:      a:
 [1 2]   [5 5]  Result:  [1 2 5 5]
 [2 3]   [6 6] --------> [2 3 6 6]
```

_Arguments:_
```OpenSCAD
concat_matrix (m, a)
```

