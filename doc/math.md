Math functions
==============

### defined in file
`banded/math.scad`\
` `| \
` `+--> `banded/math_common.scad`\
` `+--> `banded/math_formula.scad`\
` `+--> `banded/math_number.scad`\
` `| \
` `+--> `banded/math_vector.scad`\
` `+--> `banded/math_matrix.scad`\
` `+--> `banded/math_polygon.scad`\
` `| \
` `+--> `banded/complex.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Complex numbers ->](math_complex.md)
- [Vector operations ->](math_vector.md)
- [Matrix operations ->](math_matrix.md)
- [Math on lists ->](list_math.md)

- [More math functions](#more-math-functions-)
  - [Test and restrict](#test-and-restrict-)
    - [`constrain()`](#constrain-)
    - [`constrain_range()`](#constrain_range-)
    - [`is_constrain()`](#is_constrain-)
    - [`is_nearly()`](#is_nearly-)
    - [`quantize()`](#quantize-)
    - [`lerp()`](#lerp-)
    - [`inv_lerp()`](#inv_lerp-)
  - [Even or odd](#even-or-odd-)
    - [`is_odd()`, `is_even()`](#is_odd-is_even-)
    - [`positiv_if_xxx()`](#positiv_if_xxx-)
  - [Various math functions](#various-math-functions-)
    - [`sqr()`][sqr]
    - [`mod()`][mod]
    - [`sign_plus()`][sign_plus]
    - [`xor()`](#xor-)
    - [`normal_distribution()`](#normal_distribution-)
  - [More trigonometric functions](#more-trigonometric-functions-)
    - [Trigonometric](#trigonometric-)
      - `sec()`
      - `csc()`
      - `cot()`
      - `acot()`
    - [Hyperbolic](#hyperbolic-)
      - `sinh()`
      - `cosh()`
      - `tanh()`
      - `coth()`
    - [Inverse hyperbolic](#inverse-hyperbolic-)
      - `asinh()`
      - `acosh()`
      - `atanh()`
      - `acoth()`
    - [Trigonometric in radians](#trigonometric-in-radians-)
      - `cos_r()`
      - `tan_r()`
      - `cot_r()`
      - `asin_r()`
      - `acos_r()`
      - `atan_r()`
      - `acot_r()`
      - `atan2_r()`
    - [`sinc()`][sinc]
    - [`Si()`][si]
- [Number functions](#number-functions-)
   - [`factorial()`][factorial]
   - [`double_factorial()`][double_factorial]
   - [`multi_factorial()`][multi_factorial]
   - [`binomial_coefficient()`][binomial_coefficient]
   - [`fibonacci()`][fibonacci]
   - [`continued_fraction()`][continued_fraction]
   - [`gcd()`][gcd]
   - [`lcm()`][lcm]
- [Formula functions](#formula-functions-)
  - [`get_radius_from()`](#get_radius_from-)
  - [`get_circle_from_points()`](#get_circle_from_points-)
  - [`get_sphere_from_points()`](#get_sphere_from_points-)
  - [`get_hypersphere_from_points()`](#get_hypersphere_from_points-)
  - [`get_parabola_from_points()`](#get_parabola_from_points-)
  - [`get_parabola_from_midpoint()`](#get_parabola_from_midpoint-)
  - [`get_parabola_zero()`](#get_parabola_zero-)
  - [`get_parabola_zero_from_points()`](#get_parabola_zero-)
  - [`get_parabola_zero_from_midpoint()`](#get_parabola_zero-)


More math functions [^][contents]
---------------------------------

### Test and restrict [^][contents]

#### constrain [^][contents]
Limits a number to a range.
```OpenSCAD
constrain (value, a, b)
```
`a` must be lower (or equal) then `b`
- `value` - The number to restrict.
- `a`     - The lower end of the range.
- `b`     - The upper end of the range.

_Returns:_
- `value` - If number is between `a` and `b`
- `a`     - If number is lower than `a`
- `b`     - If number is higher than `b`

#### constrain_range [^][contents]
Limits a number to a range between `a` and `b`.
```OpenSCAD
constrain_range (value, a, b)
```
- `value`  - The number to restrict.
- `a`, `b` - The range limits, unsorted

_Returns:_
- `value`    - If number is between `a` and `b`
- `a` or `b` - If number exceeds `a` or `b`

#### is_constrain [^][contents]
Test a number and return `true` if this is in a limit (inclusive `a` and `b`).
```OpenSCAD
is_constrain (value, a, b)
```
- `value` - The number to test.
- `a`     - The lower end of the range.
- `b`     - The upper end of the range.

_Other functions:_
- `is_constrain_left  (value, a, b)` - test the number in between `a` and `b`, but _without_ `b`
- `is_constrain_right (value, a, b)` - test the number in between `a` and `b`, but _without_ `a`
- `is_constrain_inner (value, a, b)` - test the number in between `a` and `b`, but _without_ `a` and _without_ `b`

#### is_nearly [^][contents]
Compares two values or two lists of values to see if they approximately match.
```OpenSCAD
is_nearly (a, b, deviation)
```
- `a`, `b`  - Values or lists to compare
- deviation - Maximum deviation of the values, default = `1e-14`, calculation deviation

#### quantize [^][contents]
Quantizes a value within a grid.\
Default = round to an integer
```OpenSCAD
quantize (value, raster, offset)
```
- `value`  - Numeric value
- `raster` - Distance between the grid
- `offset` - Shift from the origin

#### lerp [^][contents]
```OpenSCAD
lerp (a, b, t, range)
```
Computes the linear interpolation between `a` and `b`,\
if the parameter `t` is inside `[0, 1]` (the linear extrapolation otherwise)
- `a`, `b` - value or list with values
- `t`      - interpolate value
  - `0...1` calculate by default a value between `a...b`
- `range`
  - range of value `t`, default = `[0, 1]`
  - can set to another range,
    so value `t` interpolate in this range between `a` and `b`

_Example:_
```OpenSCAD
include <banded.scad>

echo( lerp (0, 100, 0.5) ); // 50
echo( lerp (1,   5, 0.8) ); // 4.2
//
echo( lerp (10, 30, 2, [1,3]) ); // 20
```

#### inv_lerp [^][contents]
```OpenSCAD
inv_lerp (a, b, t, range)
```
Computes the reverse linear interpolation between `a` and `b`,\
get the fraction between `a` and `b` on which `v` resides.
- `a`, `b` - value or list with values
- `v`      - value
  - a value between `a...b` calculate by default a value between `0...1`
- `range`
  - range of return value, default = `[0, 1]`
  - can set to another range,
    so the return value is in this range if `v` is between `a` and `b`

_Example:_
```OpenSCAD
include <banded.scad>

echo( inv_lerp (0, 100, 50 ) ); // 0.5
echo( inv_lerp (1,   5, 4.2) ); // 0.8
//
echo( inv_lerp (10, 30, 20, [1,3]) ); // 2
```


### Even or odd [^][contents]

#### is_odd, is_even [^][contents]
Returns `true` if
- `n` is odd value with `is_odd (n)`
- `n` is even value with `is_even (n)`

#### positiv_if_xxx [^][contents]
Returns `1` or `-1` if the condition of `n` fits

| function             | return `1`   | return `-1`
|----------------------|--------------|-------------
| `positiv_if_odd (n)` | `n` is odd   | `n` is even
| `positiv_if_even(n)` | `n` is even  | `n` is odd
| `negativ_if_odd (n)` | `n` is even  | `n` is odd
| `negativ_if_even(n)` | `n` is odd   | `n` is even


### Various math functions [^][contents]

#### `sqr (x)` [^][contents]
[sqr]: #sqr-x-
Square a value `x`. A function name for `x*x`

#### `mod (x, n)` [^][contents]
[mod]: #mod-x-n-
Calculates the modulo.\
Get the remainder of `x / n` with floored division.
The remainder would have the same sign as the divisor `n`.

#### `sign_plus (x)` [^][contents]
[sign_plus]: #sign_plus-x-
Mathematical positive signum function.\
Returns `-1` if `x<0` and `1` if `x>=0`

#### xor [^][contents]
Return a boolean value of operation xor with 2 boolean values
```OpenSCAD
xor (bool, bool2)
```
- `bool`, `bool2` - boolean value

_Additional functions with more then 2 arguments:_
- `xor_3 (bool, bool2, bool3)`
- `xor_4 (bool, bool2, bool3, bool4)`

#### normal_distribution [^][contents]
Calculate the Gauss normal distribution
```OpenSCAD
normal_distribution (x, mean, sigma)
```
- `x`     - numeric value
- `mean`  - mean value, standard = `0`
- `sigma` - value standard deviation, standard = `1`


### More trigonometric functions [^][contents]

#### Trigonometric [^][contents]
[=> Wikipedia - Trigonometric functions](https://en.wikipedia.org/wiki/Trigonometric_functions)

| function      | description
|---------------|-------------
| `sec (angle)` | Secant of `angle` in degree
| `csc (angle)` | Cosecant of `angle` in degree
| `cot (angle)` | Cotangent of `angle` in degree
| `acot (x)`    | Inverse cotangent of `x`, return angle in degree

#### Hyperbolic [^][contents]
[=> Wikipedia - Hyperbolic functions](https://en.wikipedia.org/wiki/Hyperbolic_functions)

| function   | description
|------------|-------------
| `sinh (x)` | hyperbolic sine of `x`
| `cosh (x)` | hyperbolic cosine of `x`
| `tanh (x)` | hyperbolic tangent of `x`
| `coth (x)` | hyperbolic cotangent of `x`

#### Inverse hyperbolic [^][contents]
[=> Wikipedia - Inverse hyperbolic functions](https://en.wikipedia.org/wiki/Inverse_hyperbolic_functions)

| function    | description
|-------------|-------------
| `asinh (x)` | Inverse hyperbolic sine of `x`
| `acosh (x)` | Inverse hyperbolic cosine of `x`
| `atanh (x)` | Inverse hyperbolic tangent of `x`
| `acoth (x)` | Inverse hyperbolic cotangent of `x`

#### Trigonometric in radians [^][contents]

These functions needs an angle in radians `0...2*PI`:

| function    | description
|-------------|-------------
| `sin_r (x)` | sine of `x`
| `cos_r (x)` | cosine of `x`
| `tan_r (x)` | tangent of `x`
| `cot_r (x)` | cotangent of `x`

These functions return an angle in radians `0...2*PI`:

| function        | description
|-----------------|-------------
| `asin_r (x)`    | Inverse sine of `x`
| `acos_r (x)`    | Inverse cosine of `x`
| `atan_r (x)`    | Inverse tangent of `x`
| `acot_r (x)`    | Inverse cotangent of `x`
| `atan2_r (y,x)` | Inverse tangent. Two-argument version of `atan_r` with Y and X axis.

#### `sinc (x)` [^][contents]
[sinc]: #sinc-x-
Sinc function

[=> Wikipedia - Sinc function](https://en.wikipedia.org/wiki/Sinc_function)

`si (x)`   - unnormalized sinc function\
`sinc (x)` - normalized sinc function

#### `Si (x)` [^][contents]
[si]: #si-x-
Trigonometric integral\
[=> Wikipedia - Trigonometric integral](https://en.wikipedia.org/wiki/Trigonometric_integral)


Number functions [^][contents]
------------------------------

#### `factorial (n)` [^][contents]
[factorial]: #factorial-n-
Calculate the factorial of a positive integer `n`, denoted by n!\
[=> Wikipedia - Factorial](https://en.wikipedia.org/wiki/Factorial)

#### `double_factorial (n)` [^][contents]
[double_factorial]: #double_factorial-n-
Calculate the double factorial or semifactorial of a number `n`, denoted by n‼\
[=> Wikipedia - Double factorial](https://en.wikipedia.org/wiki/Double_factorial)

#### `multi_factorial (n, k)` [^][contents]
[multi_factorial]: #multi_factorial-n-k-
Calculate the multifactorial of a positive integer `n`\
[=> Wikipedia - Multifactorials](https://en.wikipedia.org/wiki/Factorial#Multifactorials)

#### `binomial_coefficient (n, k)` [^][contents]
[binomial_coefficient]: #binomial_coefficient-n-k-
Calculate the binomial coefficient `n` over `k`\
[=> Wikipedia - Binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient)

#### `fibonacci (n)` [^][contents]
[fibonacci]: #fibonacci-n-
Calculate the Fibonacci numbers of a number `n`\
[=> Wikipedia - Fibonacci number](https://en.wikipedia.org/wiki/Fibonacci_number)

#### `continued_fraction (a, b)` [^][contents]
[continued_fraction]: #continued_fraction-a-b-
Calculate the continued fraction\
`a0 + b1 / (a1 + b2 / (a2 + (...))))`\

[=> Wikipedia - Continued fraction](https://en.wikipedia.org/wiki/Continued_fraction)

- `a` - list with the coefficients of the continued fraction
- `b` - list with the numerator of the continued fraction
     -  size of this list is 1 less then list `a`
     -  if not specified value `1` will set
        and it calculate a simple continued fraction

#### `gcd (a, b)` [^][contents]
[gcd]: #gcd-a-b-
Calculate the greatest common divisor of two integers `a` and `b`\
[=> Wikipedia - Greatest common divisor](https://en.wikipedia.org/wiki/Greatest_common_divisor)

#### `lcm (a, b)` [^][contents]
[lcm]: #lcm-a-b-
Calculate the least common multiple of two integers `a` and `b`\
[=> Wikipedia - Least common multiple](https://en.wikipedia.org/wiki/Least_common_multiple)


Formula functions [^][contents]
-------------------------------

#### get_radius_from [^][contents]
Calculate the radius from a circle.
```OpenSCAD
get_radius_from (chord, sagitta, angle)
```
It requires 2 parameters each from these 3:
- `chord`    - length of chord
- `saggitta` - segment height
- `angle`    - central angle from the center of the circle

#### get_circle_from_points [^][contents]
Calculate the parameter of a circle from 3 points.\
Return the result as a list `[center of the circle, radius]`.\
The points can be in 2D or 3D space.

_Parameters:_
```OpenSCAD
get_circle_from_points (p1, p2, p3)
```
- `p1`, `p2`, `p3` - 3 points on a circle line

_Specialized functions:_
- `get_circle_from_points_2d (p1, p2, p3)` - all points must be in 2D space
- `get_circle_from_points_3d (p1, p2, p3)` - all points must be in 3D space

#### get_sphere_from_points [^][contents]
Calculate the parameter of a sphere from 4 points.\
Return the result as a list `[center of the sphere, radius]`.\
The points can be only in 3D space.

```OpenSCAD
get_sphere_from_points (p1, p2, p3, p4)
```
- `p1`, `p2`, `p3`, `p4` - 4 points on a sphere surface

#### get_hypersphere_from_points [^][contents]
Calculate the parameter of a n-sphere (hypersphere) from n+1 points in a list.\
Return the result as a list `[center of the n-sphere, radius]`.\
The points must be in n dimensions.

```OpenSCAD
get_hypersphere_from_points (p)
```
- `p` - a list with points on the hypersphere surface

#### get_parabola_from_points [^][contents]
Calculates the parameter of a parabola from 3 points.\
Parabola from type: `y = Ax² + Bx + C`\
Return the result as a list `[C,B,A]`.\
The result can directly used in function [`polynomial()`](draft_curves.md#polynomial-function-).

```OpenSCAD
get_parabola_from_points (p1, p2, p3)
```
- `p1, p2, p3` - arbitrary points on the parabola in 2D plane

#### get_parabola_from_midpoint [^][contents]
Calculates the parameter of a parabola from 3 points.\
Specialized version of [`get_parabola_from_points()`](#get_parabola_from_points-).
Needs 2 outer points and the height of the midpoint.
The distance in X-axis between the 3 points is the same.\
Parabola from type: `y = Ax² + Bx + C`\
Return the result as a list `[C,B,A]`.\
The result can directly used in function [`polynomial()`](draft_curves.md#polynomial-function-).

```OpenSCAD
get_parabola_from_midpoint (p1, p2, ym)
```
- `p1, p2` - the both outer points on the parabola in 2D plane
- `ym`     - the height on Y-axis on the half way on X-axis between the outer points `p1` and `p2`

#### get_parabola_zero [^][contents]
[get_parabola_zero]: #get_parabola_zero-p-chosen-
Returns the roots of a parabola.\
Parabola from type: `y = Ax² + Bx + C`

_Parameters:_
```OpenSCAD
get_parabola_zero (P, chosen)
```
- `P`    - parameter of a parabola as list `[C,B,A]`
- `chosen`
  - controls the return value of this function
  - `0`  - all existing zero points as list, default
  - `-1` - left zero point as number
  -  `1` - right zero point as number

_Specialized functions:_
- `get_parabola_zero_from_points (p1, p2, p3, chosen)`
  - with parameter from function [`get_parabola_from_points()`](#get_parabola_from_points-)
- `get_parabola_zero_from_midpoint (p1, p2, ym, chosen)`
  - with parameter from function [`get_parabola_from_midpoint()`](#get_parabola_from_midpoint-)
