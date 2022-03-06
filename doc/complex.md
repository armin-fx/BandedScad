Working with complex numbers
============================

### defined in file
`banded/complex.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Convention](#convention-)
- [Convert functions](#convert-functions-)
  - [`get_cartesian()`, `get_polar()`][c-form]
  - [`get_real()`, `get_imaginary()`][c-part]
  - [`c_abs()`][abs]
  - [`c_conjugate()`][conjugate]
- [Calculation functions](#calculation-functions-)
  - [`c_add()`, `c_sub()`][add]
  - [`c_mul()`, `c_div()`][mul]
  - [`c_sqrt()`][sqrt]
  - [`c_sqr()`][sqr]


Convention [^][contents]
------------------------
The complex numbers are set up as a list.
- As list in cartesian complex plane expressed in the form `z = a + b*i`,
  where `a` is the real part and `b` is the imaginary part.\
  
  `[real part a, imaginary part b]`
  
- As list in polar complex plane expressed in form
  `z = r * e^(i*phi)  = r * ( cos(phi) + i*sin(phi) )`.\
  `r` = distance from origin and\
  `phi` = angle around origin from the positive real axis.\
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
| input          | return cartesian form         | return polar form
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
| input          | return real part            | return imaginary part
|----------------|-----------------------------|-----------------------
| numeric value  | `get_real_from_number()`    | `get_imaginary_from_number()`
| cartesian form | `get_real_from_cartesian()` | `get_imaginary_from_cartesian()`
| polar form     | `get_real_from_polar()`     | `get_imaginary_from_polar()`


### Absolute value [^][contents]
[abs]: #absolute-value- "Absolute value"

#### Common function:
`c_abs (c)`

#### Specialized function:
| input          | return
|----------------|--------
| numeric value  | `abs()` - from OpenSCAD
| cartesian form | `c_abs_cartesian()`
| polar form     | `c_abs_polar()`


### Conjugate complex number [^][contents]
[conjugate]: #conjugate-complex-number- "Conjugate complex number"

#### Common function:
`c_conjugate (c)`

#### Specialized function:
| input          | return
|----------------|--------
| cartesian form | `c_conjugate_cartesian()`
| polar form     | `c_conjugate_polar()`


Calculation functions [^][contents]
-----------------------------------

### Addition, Subtraction [^][contents]
[add]: #addition-subtraction- "Addition, Subtraction"
Add or subtract complex number `d` from `c`.

#### Common function:
`c_add (c, d)`\
`c_sub (c, d)`
- return a complex number list in cartesian form.

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
Return a list with 2 complex number

#### Common function:
`c_sqrt (c)`

#### Specialized function:
| input          | return
|----------------|--------
| numeric value  | `sqrt()` - from OpenSCAD
| cartesian form | `c_sqrt_cartesian()`
| polar form     | `c_sqrt_polar()`


### Complex square function [^][contents]
[sqr]: #complex-square-function- "Complex square function"

#### Common function:
`c_sqr (c)`

#### Specialized function:
| input          | return
|----------------|--------
| numeric value  | `sqr()` - from `banded/math_common.scad`
| cartesian form | `c_sqr_cartesian()`
| polar form     | `c_sqr_polar()`


