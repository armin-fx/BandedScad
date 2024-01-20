Calculating with complex numbers
================================

### defined in file
`banded/complex.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

[<-- Math functions](math.md)

### Contents
[contents]: #contents "Up to Contents"
- [Convention](#convention-)
- [Convert functions](#convert-functions-)
  - [`get_cartesian()`, `get_polar()`][c-form]
  - [`get_real()`, `get_imaginary()`][c-part]
  - [`c_abs()`][abs]
  - [`c_abs_sqr()`][abs_sqr]
  - [`c_conjugate()`][conjugate]
- [Calculation functions](#calculation-functions-)
  - [`c_add()`, `c_sub()`][add]
  - [`c_mul()`, `c_div()`][mul]
  - [`c_sqrt()`][sqrt]
  - [`c_sqr()`][sqr]
  - [Complex exponent and logarithmus](#complex-exponent-and-logarithmus-)
    - `c_exp()`, `c_ln()`, `c_log()`
  - [Complex trigonometric functions](#complex-trigonometric-functions-)
    - `c_sin()`, `c_cos()`, `c_tan()`, `c_cot()`
  - [Complex inverse trigonometric functions](#complex-inverse-trigonometric-functions-)
    - `c_asin()`, `c_acos()`, `c_atan()`, `c_acot()`
  - [Complex hyperbolic trigonometric functions](#complex-hyperbolic-trigonometric-functions-)
    - `c_sinh()`, `c_cosh()`, `c_tanh()`, `c_coth()`
  - [Complex inverse hyperbolic trigonometric functions](#complex-inverse-hyperbolic-trigonometric-functions-)
    - `c_asinh()`, `c_acosh()`, `c_atanh()`, `c_acoth()`


Convention [^][contents]
------------------------
The complex numbers are set up as a list.
- As list in cartesian complex plane expressed in the form `z = a + b*i`,
  where `a` is the real part and `b` is the imaginary part.\
  
  `[real part a, imaginary part b]`
  
- As list in polar complex plane expressed in form
  `z = r * e^(i*phi)  = r * ( cos(phi) + i*sin(phi) )`.\
  `r` = distance from origin and\
  `phi` = angle around origin in degrees `0...360` from the positive real axis.\
  In order to be able to distinguish the polar form from the cartesian form,
  an indefinite value without meaning is appended to the list.
  
  `[radius r, angle phi, 0]`
  
If a real number is delivered, a complex number is generated from it.

The common functions accept all number form like
- numeric value
- complex number as list in cartesian form
- complex number as list in polar form
and return a complex number in cartesian or polar form depending on the input number form.

The specialized functions require a fixed number form and return a fixed number form.
They are little faster than the common functions, if you know what you want.

[=> Wikipedia - Complex number](https://en.wikipedia.org/wiki/Complex_number)


Convert functions [^][contents]
-------------------------------

### Get complex number in cartesian or polar form [^][contents]
[c-form]: #get-complex-number-in-cartesian-or-polar-form- "Get complex number in cartesian or polar form"

#### Common function:
`get_cartesian (c)`\
`get_polar (c)`

#### Specialized function:
| input type     | returns cartesian form        | returns polar form
|----------------|-------------------------------|-------------------
| numeric value  | `get_cartesian_from_number()` | `get_polar_from_number()`
| cartesian form | -                             | `get_polar_from_cartesian()`
| polar form     | `get_cartesian_from_polar()`  | -


### Get part from complex number [^][contents]
[c-part]: #get-part-from-complex-number- "Get part from complex number"
Return real part or imaginary part from complex number

#### Common function:
`get_real (c)`\
`get_imaginary (c)`

#### Specialized function:
| input type     | returns real part           | returns imaginary part
|----------------|-----------------------------|------------------------
| numeric value  | `get_real_from_number()`    | `get_imaginary_from_number()`
| cartesian form | `get_real_from_cartesian()` | `get_imaginary_from_cartesian()`
| polar form     | `get_real_from_polar()`     | `get_imaginary_from_polar()`


### Absolute value [^][contents]
[abs]: #absolute-value- "Absolute value"
Return the absolute value as numeric value.

#### Common function:
`c_abs (c)`

#### Specialized function:
| function            | input          | returns       | comment
|---------------------|----------------|---------------|---------
| `abs()`             | numeric value  | numeric value | from OpenSCAD
| `c_abs_cartesian()` | cartesian form | numeric value |
| `c_abs_polar()`     | polar form     | numeric value |


### Squared absolute value [^][contents]
[abs_sqr]: #squared-absolute-value- "Squared absolute value"
Return the squared absolute value as numeric value.

#### Common function:
`c_abs_sqr (c)`

#### Specialized function:
| function                | input          | returns       | comment
|-------------------------|----------------|---------------|---------
| `norm_sqr()`            | numeric value  | numeric value | from `banded/math_vector.scad`
| `c_abs_sqr_cartesian()` | cartesian form | numeric value |
| `c_abs_sqr_polar()`     | polar form     | numeric value |


### Conjugate complex number [^][contents]
[conjugate]: #conjugate-complex-number- "Conjugate complex number"
Swap the sign of the imaginary part of a complex number.

#### Common function:
`c_conjugate (c)`

#### Specialized function:
| function                  | input and output type
|---------------------------|-----------------------
| `c_conjugate_cartesian()` | cartesian form
| `c_conjugate_polar()`     | polar form


Calculation functions [^][contents]
-----------------------------------

### Addition, Subtraction [^][contents]
[add]: #addition-subtraction- "Addition, Subtraction"
Add or subtract complex number `d` from `c`.

#### Common function:
`c_add (c, d)`\
`c_sub (c, d)`
- return a complex number in cartesian form.

#### Specialized function:
`xxx` = `add` or `sub`

| input c   | input d   | output cartesian form               | output polar form
|-----------|-----------|-------------------------------------|-------------------
| cartesian | cartesian | `c_xxx_cartesian()`<br> or `c +- d` | -
| cartesian | number    | `c_xxx_cartesian_number()`          | -
| number    | cartesian | `c_xxx_number_cartesian()`          | -
| polar     | polar     | `c_xxx_polar()`                     | `c_xxx_polar_to_cartesian()`


### Multiplication, Division [^][contents]
[mul]: #multiplication-division- "Multiplication, Division"
Multiplicate or Divide complex number `d` from `c`.

#### Common function:
`c_mul (c, d)`\
`c_div (c, d)`

#### Specialized function:
`xxx` = `mul` or `div`

| input c   | input d   | output cartesian form        | output polar form
|-----------|-----------|------------------------------|-------------------
| cartesian | cartesian | `c_xxx_cartesian()`          | -
| cartesian | number    | `c_xxx_cartesian_number()`   | -
| number    | cartesian | `c_div_number_cartesian()`   | -
| polar     | polar     | `c_xxx_polar_to_cartesian()` | `c_xxx_polar()`
| polar     | number    | -                            | `c_xxx_polar_number()`
| number    | polar     | -                            | `c_div_number_polar()`


### Complex square root [^][contents]
[sqrt]: #complex-square-root- "Complex square root"
Return the square root of a complex number

#### Common function:
`c_sqrt (c)`      - Returns the square root using the principal branch, whose cuts are along the negative real axis.
`c_sqrt_list (c)` - Returns a list with 2 complex number, both results

| input          | result
|----------------|--------
| numeric value  | complex number in cartesian form
| cartesian form | cartesian form
| polar form     | polar form

#### Specialized function:
| function             | input and output type | comment
|----------------------|-----------------------|---------
| `sqrt()`             | numeric value         | from OpenSCAD, only positive value
| `c_sqrt_cartesian()` | cartesian form        |
| `c_sqrt_polar()`     | polar form            |


### Complex square function [^][contents]
[sqr]: #complex-square-function- "Complex square function"

#### Common function:
`c_sqr (c)`

#### Specialized function:
| function            | input and output type | comment
|---------------------|-----------------------|---------
| `sqr()`             | numeric value         | from `banded/math_common.scad`
| `c_sqr_cartesian()` | cartesian form        |
| `c_sqr_polar()`     | polar form            |


### Complex exponent and logarithmus [^][contents]

| function    | description
|-------------|-------------
| `c_exp (c)` | Complex exponent
| `c_ln (c)`  | Complex natural logarithmus
| `c_log (c)` | Complex logarithmus base 10


### Complex trigonometric functions [^][contents]

| function    | description
|-------------|-------------
| `c_sin (c)` | Complex sinus
| `c_cos (c)` | Complex cosinus
| `c_tan (c)` | Complex tangent
| `c_cot (c)` | Complex cotangent


### Complex inverse trigonometric functions [^][contents]

| function     | description
|--------------|-------------
| `c_asin (c)` | Complex area sinus
| `c_acos (c)` | Complex area cosinus
| `c_atan (c)` | Complex area tangent
| `c_acot (c)` | Complex area cotangent


### Complex hyperbolic trigonometric functions [^][contents]

| function     | description
|--------------|-------------
| `c_sinh (c)` | Complex hyperbolic sinus
| `c_cosh (c)` | Complex hyperbolic cosinus
| `c_tanh (c)` | Complex hyperbolic tangent
| `c_coth (c)` | Complex hyperbolic cotangent


### Complex inverse hyperbolic trigonometric functions [^][contents]

| function      | description
|---------------|-------------
| `c_asinh (c)` | Complex area hyperbolic sinus
| `c_acosh (c)` | Complex area hyperbolic cosinus
| `c_atanh (c)` | Complex area hyperbolic tangent
| `c_acoth (c)` | Complex area hyperbolic cotangent

