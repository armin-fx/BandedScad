Math on lists
=============

### defined in file
`banded/list.scad`  
` `|  
` `+--> `banded/list_algorithm.scad`  
` `+--> `banded/list_math.scad`  
` `|   
` `. . .  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Calculating mean ->](list_mean.md)

- [Algorithm on lists](#algorithm-on-lists-)
  - [`summation()`][summation]
  - [`product()`][product]
  - [`unit_summation()`][unit_summation]
  - [`unit_product()`][unit_product]
  - [`polynomial_division()`][polynomial_division]
  - [`polynomial_division_remainder()`][polynomial_division_remainder]
- [Math operation on each list element](#math-operation-on-each-list-element-)
  - [Integrated in Openscad](#integrated-in-openscad-)
  - [Operand with functions from OpenSCAD](#operand-with-functions-from-openscad-)
  - [Operand with extra functions](#operand-with-extra-functions-)
  - [Operand on a list which containes lists](#operand-on-a-list-which-containes-lists-)
  - [Call function on each list element](#call-function-on-each-list-element-)


Algorithm on lists [^][contents]
================================

#### summation [^][contents]
[summation]: #summation-
Summation of a list.  
Add all values in a list from position `k` to `n`.
This function accepts numeric values and vectors in the list.

_Arguments:_
```OpenSCAD
summation (list, n, k)
```
- `k` - default = `0`, from first element
- `n` - if undefined, run until the last element

#### product [^][contents]
[product]: #product-
Product of a list.  
Multiply all values in a list from position `k` to `n`.

_Arguments:_
```OpenSCAD
product (list, n, k)
```
- `k` - default = `0`, from first element
- `n` - if undefined, run until the last element

#### unit_summation [^][contents]
[unit_summation]: #unit_summation-
Scale the complete list that the summation of the list equals `1`.

_Arguments:_
```OpenSCAD
unit_summation (list)
```

#### unit_product [^][contents]
[unit_product]: #unit_product-
Scale the complete list that the product of the list equals `1`.

_Arguments:_
```OpenSCAD
unit_product (list)
```

#### polynomial_division [^][contents]
[polynomial_division]: #polynomial_division-
Calculates the polynomial division from a polynomial in a list `a` with `b`.  
Returns the result polynomial and the remainder polynomial in a list.
- `[result, remainder]`

_Arguments:_
```OpenSCAD
polynomial_division (a, b)
```

_The coefficients of the polynomial are stored in a list like:_
- `P(x) = a[0] + a[1]*x + a[2]*x^2 + ... + a[n]*x^n`
- The index in the list means the coefficient from `x^index`

[Wikipedia -> Polynomial long division](https://en.wikipedia.org/wiki/Polynomial_long_division)

#### polynomial_division_remainder [^][contents]
[polynomial_division_remainder]: #polynomial_division_remainder-
Calculates the polynomial division from a polynomial in a list `a` with `b`.  
Returns only the remainder polynomial.  
The coefficients of the polynomial are stored in a list like:
- `P(x) = a[0] + a[1]*x + a[2]*x^2 + ... + a[n]*x^n`
- The index in the list means the coefficient from `x^index`

_Arguments:_
```OpenSCAD
polynomial_division_remainder (a, b)
```


Math operation on each list element [^][contents]
=================================================

Calculates a operation on a list at each position.  
Returns a list with the result.
- `xxx_each (list)`         - do the operator xxx at each position
- `xxx_each (list1, list2)` - operator xxx with 2 arguments gets his 2 argument from both lists at the same index
- `xxx_all_each (list)`     - for lists in a list, do the operator xxx at each position in each list


### Integrated in Openscad [^][contents]

#### Addition / Subtraction: [^][contents]
`[1,2,3] + [0,4,2]` -> `[1,6,5]`  
`[6,7,8] - [1,2,3]` -> `[5,5,5]`  


### Operand with functions from OpenSCAD [^][contents]

| function                                 | description
|------------------------------------------|-------------
| `sqrt_each (list)`                       | square root
| `ln_each (list)`                         | natural logarithm
| `log_each (list)`                        | logarithm with base 10
| `exp_each (list)`                        | natural exponent
| `pow_each (base,exponent)`               | power `base[n] ^ exponent[n]`.
| `pow_each_with_base     (base,exponent)` | power numeric value `base` with every entry in list `exponent`.
| `pow_each_with_exponent (base,exponent)` | power every entry in list `base[n]` with numeric value in list `exponent`.
| `sin_each (list)`                        | sine function
| `cos_each (list)`                        | cosine
| `tan_each (list)`                        | tangent
| `asin_each (list)`                       | arcus sine
| `acos_each (list)`                       | arcus cosine
| `atan_each (list)`                       | arcus tangent
| `atan2_each (list_y,list_x)`             | 2-argument arcus tangent.
| `atan2_each_with_x (list_y,x)`           | 2-argument arcus tangent. With `x` as numeric value.
| `atan2_each_with_y (y,list_x)`           | 2-argument arcus tangent. With `y` as numeric value.
| `floor_each (list)`                      | floor function
| `ceil_each (list)`                       | ceiling function
| `round_each (list)`                      | rounding function
| `abs_each (list)`                        | absolute values
| `norm_each (list)`                       | calculate the norm of a vector in every entry in a list


### Operand with extra functions [^][contents]

| function                             | description
|--------------------------------------|-------------
| `add_each_with      (list1,value)`   | add each value in a list with a (numeric) value.
| `sub_each_with      (list1,value)`   | subtract each value in a list with a (numeric) value.
| `multiply_each      (list1,list2)`   | multiply each value `list1[n] * list2[n]`.
| `multiply_each_with (list,value)`    | multiply each value in the list with a (numeric) value.
| `multiply_with_each (value,list)`    | multiply a value with each value in the list.
| `divide_each      (list1,list2)`     | divide each value `list1[n] / list2[n]`.
| `divide_each_with (list,value)`      | divide each value in the list with a numeric value.
| `reciprocal_each (list,numerator=1)` | reciprocate each value `1 / list[n]`. Optional argument `numerator` can set with a value: `numerator / list[n]`
| `sqr_each (list)`                    | square each value `list[n] ^ 2`
| `sum_each_next (list)`               | every next value contains the summation of all previous values in list
| `cot_each (list)`                    | calculate the cotangent on each value in a list.
| `sec_each (list)`                    | calculate the secant on each value in a list.
| `csc_each (list)`                    | calculate the cosecant on each value in a list.
| `exsec_each (list)`                  | calculate the external secant on each value in a list.
| `excsc_each (list)`                  | calculate the external cosecant on each value in a list.
| `versin_each   (list)`               | calculate the versed sine on each value in a list.
| `coversin_each (list)`               | calculate the coversed sine on each value in a list.
| `vercos_each   (list)`               | calculate the versed cosine on each value in a list.
| `covercos_each (list)`               | calculate the coversed cosine on each value in a list.
| `chord_each (list)`                  | Length of the chord between two points on a unit circle separated by that central angle in degree on each value in a list
| `acot_each (list)`                   | calculate the inverse cotangent on each value in a list.
| `asec_each (list)`                   | calculate the inverse secant on each value in a list.
| `acsc_each (list)`                   | calculate the inverse cosecant on each value in a list.
| `aexsec_each (list)`                 | calculate the inverse external secant on each value in a list.
| `aexcsc_each (list)`                 | calculate the inverse external cosecant on each value in a list.
| `aversin_each   (list)`              | calculate the inverse versed sine on each value in a list.
| `acoversin_each (list)`              | calculate the inverse coversed sine on each value in a list.
| `avercos_each   (list)`              | calculate the inverse versed cosine on each value in a list.
| `acovercos_each (list)`              | calculate the inverse coversed cosine on each value in a list.
| `achord (list)`                      | Return the angle from the length of the chord between two points on a unit circle on each value in a list
| `sinh_each (list)`                   | calculate the hyperbolic sine on each value in a list.
| `cosh_each (list)`                   | calculate the hyperbolic cosine on each value.
| `tanh_each (list)`                   | calculate the hyperbolic tangent on each value.
| `coth_each (list)`                   | calculate the hyperbolic cotangent on each value.
| `asinh_each (list)`                  | calculate the area hyperbolic sine on each value.
| `acosh_each (list)`                  | calculate the area hyperbolic cosine on each value.
| `atanh_each (list)`                  | calculate the area hyperbolic tangent on each value.
| `acoth_each (list)`                  | calculate the area hyperbolic cotangent on each value.
| `quantize_each (list,raster,offset)` | quantizes every value within a grid.
| `mod_each (list,n)`                  | calculates the modulo on each value.
| `constrain_each (list,min,max)`      | constrain each value in the list within `min` and `max`. `min` must be smaller then `max`.
| `constrain_range_each (list,a,b)`    | constrain each value in the list within value `a` and `b`


### Operand on a list which containes lists [^][contents]

| function                                 | description
|------------------------------------------|-------------
| `add_all_each_with      (list1,value)`   | add each value in all included lists with a (numeric) value.
| `sub_all_each_with      (list1,value)`   | subtract each value in all included lists with a (numeric) value.
| `multiply_all_each_with (list,value)`    | multiply each value in all included lists with a (numeric) value.
| `divide_all_each_with (list,value)`      | divide each value in all included lists with a numeric value.
| `reciprocal_all_each (list,numerator=1)` | reciprocate each value `1 / list[n]` in all all included lists. Optional argument `numerator` can set with a value: `numerator / list[n]`


### Call function on each list element [^][contents]

| function                           | description
|------------------------------------|-------------
| `fn_each        (list, fn)`        | call a function literal `fn` with one argument with every entry in a list
| `fn_2_each      (list1,list2, fn)` | call a function literal `fn` with two arguments with every entries from the same position in `list1` and `list2`
| `fn_2_each_with (list,value, fn)`  | call a function literal `fn` with two arguments with every entry from `list` with `value`

