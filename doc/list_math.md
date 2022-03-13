Math on lists
=============

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_algorithm.scad`\
` `+--> `banded/list_math.scad`\
` `+--> `banded/list_mean.scad`\
` `| \
` `. . .

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Calculating mean ->](mean.md)


- [Algorithm on lists](#algorithm-on-lists-)
  - [`summation_list()`][summation_list]
  - [`product_list()`][product_list]
  - [`unit_summation()`][unit_summation]
- [Math operation on each list element](#math-operation-on_each-list-element-)
  - [Integrated in Openscad](#integrated-in-openscad-)
  - [Operand with functions from OpenSCAD](#operand-with-functions-from-openscad-)
  - [Operand with extra functions](#operand-with-extra-functions-)
  - [Call function on each list element](#call-function-on-each-list-element-)


Algorithm on lists [^][contents]
================================

#### `summation_list (list, n, k)` [^][contents]
[summation_list]: #summation_list-list-n-k-
Summation of a list.\
Add all values in a list from position `k` to `n`.
This function accepts numeric values and vectors in the list.
- `k` - default = `0`, from first element
- `n` - if undefined, run until the last element

#### `product_list (list, n, k)` [^][contents]
[product_list]: #product_list-list-n-k-
Product of a list.\
Multiply all values in a list from position `k` to `n`
- `k` - default = `0`, from first element
- `n` - if undefined, run until the last element

#### `unit_summation (list)` [^][contents]
[unit_summation]: #unit_summation-list-
Scale the complete list that the summation of the list equals `1`


Math operation on each list element [^][contents]
=======================================

Calculates a operation on a list at each position.\
Returns a list with the result.
- `xxx_each (list)`         - do the operator xxx at each position
- `xxx_each (list1, list2)` - operator xxx with 2 arguments gets his 2 argument from both lists at the same index

### Integrated in Openscad [^][contents]

#### Addition / Subtraction [^][contents]
`[1,2,3] + [0,4,2]` -> `[1,6,5]`\
`[6,7,8] - [1,2,3]` -> `[5,5,5]`


### Operand with functions from OpenSCAD [^][contents]

| function                   | description
|----------------------------|-------------
| `sqrt_each (list)`         | square root
| `ln_each (list)`           | natural logarithm
| `log_each (list)`          | logarithm with base 10
| `exp_each (list)`          | natural exponent
| `pow_each (list1,list2) `  | power `list1[*] ^ list2[*]`
| `sin_each (list)`          | sine function
| `cos_each (list)`          | cosine
| `tan_each (list)`          | tangent
| `asin_each (list)`         | arcus sine
| `acos_each (list)`         | arcus cosine
| `atan_each (list)`         | arcus tangent
| `atan2_each (list1,list2)` | 2-argument arcus tangent
| `floor_each (list)`        | floor function
| `ceil_each (list)`         | ceiling function
| `round_each (list)`        | rounding function
| `abs_each (list)`          | absolute values
| `norm_each (list)`         | calculate the norm of a vector in every entry in a list


### Operand with extra functions [^][contents]

| function                      | description
|-------------------------------|-------------
| `multiply_each (list1,list2)` | multiply each value `list1[*] * list2[*]`
| `divide_each (list1, list2)`  | divide each value `list1[*] / list2[*]`
| `reciprocal_each (list)`      | reciprocate each value `1 / list[*]`
| `sqr_each (list)`             | square each value `list[*] ^ 2`
| `sum_each_next (list)`        | every next value contains the summation of all previous values in list


#### Call function on each list element [^][contents]

| function                      | description
|-------------------------------|-------------
| `fn_each   (list, fn)`        | call a function literal `fn` with one argument with every entry in a list
| `fn_2_each (list1,list2, fn)` | call a function literal `fn` with two arguments with every entries from the same position in `list1` and `list2`

