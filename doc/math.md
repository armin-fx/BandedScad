Math functions
==============

### defined in file
`banded/math.scad`  
` `|  
` `+--> `banded/math_common.scad`  
` `+--> `banded/math_number.scad`  
` `+--> `banded/math_formula.scad`  
` `|  
` `+--> `banded/math_vector.scad`  
` `+--> `banded/math_matrix.scad`  
` `+--> `banded/math_polygon.scad`  
` `+--> `banded/math_function.scad`  
` `|  
` `+--> `banded/complex.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Complex numbers ->](math_complex.md)
- [Vector operations ->](math_vector.md)
- [Matrix operations ->](math_matrix.md)
- [Polygon operations ->](math_polygon.md)
- [Math with functions ->](math_function.md)
- [Math on lists ->](list_math.md)

- [Common math functions](#common-math-functions-)
  - [Test and restrict](#test-and-restrict-)
    - [`constrain()`][constrain]
    - [`constrain_range()`][constrain_range]
    - [`is_constrain()`][is_constrain]
    - [`is_nearly()`][is_nearly]
    - [`quantize()`][quantize]
    - [`lerp()`][lerp]
    - [`inv_lerp()`][inv_lerp]
  - [Even or odd](#even-or-odd-)
    - [`is_odd()`, `is_even()`][is_odd]
    - [`positiv_if_xxx()`][positiv_if]
  - [Various math functions](#various-math-functions-)
    - [`sqr()`][sqr]
    - [`mod()`][mod]
    - [`sign_plus()`][sign_plus]
    - [`xor()`][xor]
    - [`normal_distribution()`][normal_distribution]
  - [Trigonometric functions](#trigonometric-functions-)
    - [Trigonometric](#trigonometric-)
      - `cot()`
      - `sec()`, `csc()`, `exsec()`, `excsc()`
      - `versin()`, `coversin()`, `vercos()`, `covercos()`
      - `chord()`
      - `acot()`
      - `asec()`, `acsc()`, `aexsec()`, `aexcsc()`
      - `aversin()`, `acoversin()`, `avercos()`, `acovercos()`
      - `achord()`
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
      - `sin_r()`, `cos_r()`, `tan_r()`, `cot_r()`
      - `sec_r()`, `csc_r()`, `exsec_r()`, `excsc_r()`
      - `versin_r()`, `coversin_r()`, `vercos_r()`, `covercos_r()`
      - `chord_r()`
      - `asin_r()`, `acos_r()`, `atan_r()`, `atan2_r()`, `acot_r()`
      - `asec_r()`, `acsc_r()`, `aexsec_r()`, `aexcsc_r()`
      - `aversin_r()`, `acoversin_r()`, `avercos_r()`, `acovercos_r()`
      - `achord_r()`
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
  - [Get data from mathematical figures](#get-data-from-mathematical-figures-)
    - [`get_radius_from()`][get_radius_from]
    - [`get_circle_from_points()`][get_circle_from_points]
    - [`get_sphere_from_points()`][get_sphere_from_points]
    - [`get_hypersphere_from_points()`][get_hypersphere_from_points]
    - [`get_parabola_from_points()`][get_parabola_from_points]
    - [`get_parabola_from_midpoint()`][get_parabola_from_midpoint]
    - [`get_parabola_zero()`][get_parabola_zero]
    - [`get_parabola_zero_from_points()`][get_parabola_zero]
    - [`get_parabola_zero_from_midpoint()`][get_parabola_zero]
  - [Surface area calculation](#surface-area-calculation-)
    - [`area_cube()`][area_cube]
    - [`area_cylinder()`][area_cylinder]
    - [`area_pyramid_quadratic()`][area_pyramid_quadratic]
  - [Volume calculation](#volume-calculation-)
    - [`volume_cube()`][volume_cube]
    - [`volume_cylinder()`][volume_cylinder]
    - [`volume_pyramid()`][volume_pyramid]

[polynomial]: draft_curves.md#polynomial-function-


Common math functions [^][contents]
---------------------------------

### Test and restrict [^][contents]

Defined in file: `banded/math_common.scad`

#### constrain [^][contents]
[constrain]: #constrain-
Limits a number to a range.

_Arguments:_
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
[constrain_range]: #constrain_range-
Limits a number to a range between `a` and `b`.

_Arguments:_
```OpenSCAD
constrain_range (value, a, b)
```
- `value`  - The number to restrict.
- `a`, `b` - The range limits, unsorted

_Returns:_
- `value`    - If number is between `a` and `b`
- `a` or `b` - If number exceeds `a` or `b`

#### is_constrain [^][contents]
[is_constrain]: #is_constrain-
Test a number and return `true` if this is in a limit (inclusive `a` and `b`).

_Arguments:_
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
[is_nearly]: #is_nearly-
Compares two values or two lists of values to see if they approximately match.

_Arguments:_
```OpenSCAD
is_nearly (a, b, deviation)
```
- `a`, `b`
  - Values or lists to compare
  - as lists: Compare each value on the same index on both lists.
    This is useful to test 2 vectors or points.
- deviation
  - Maximum deviation of the values, default = `1e-14`, calculation deviation

#### quantize [^][contents]
[quantize]: #quantize-
Quantizes a value within a grid.  
Default = round to an integer

_Arguments:_
```OpenSCAD
quantize (value, raster, offset)
```
- `value`  - Numeric value
- `raster` - Distance between the grid
- `offset` - Shift from the origin

#### lerp [^][contents]
[lerp]: #lerp-
Computes the linear interpolation between `a` and `b`,  
if the parameter `t` is inside `[0, 1]` (the linear extrapolation otherwise).

_Arguments:_
```OpenSCAD
lerp (a, b, t, range)
```
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
[inv_lerp]: #inv_lerp-
Computes the reverse linear interpolation between `a` and `b`,  
get the fraction between `a` and `b` on which `v` resides.

_Arguments:_
```OpenSCAD
inv_lerp (a, b, t, range)
```
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
[is_odd]: #is_odd-is_even-
Returns `true` if
- `n` is _odd_  value with `is_odd (n)`
- `n` is _even_ value with `is_even (n)`

#### positiv_if_xxx [^][contents]
[positiv_if]: #positiv_if_xxx-
Returns `1` or `-1` if the condition of `n` fits.

| function             | return `1`   | return `-1`
|----------------------|--------------|-------------
| `positiv_if_odd (n)` | `n` is odd   | `n` is even
| `positiv_if_even(n)` | `n` is even  | `n` is odd
| `negativ_if_odd (n)` | `n` is even  | `n` is odd
| `negativ_if_even(n)` | `n` is odd   | `n` is even


### Various math functions [^][contents]

#### sqr [^][contents]
[sqr]: #sqr-
Square a value `x`. A function name for `x*x`

_Arguments:_
```OpenSCAD
sqr (x)
```

#### mod [^][contents]
[mod]: #mod-
Calculates the modulo.  
Get the remainder of `x / n` with floored division.
The remainder would have the same sign as the divisor `n`.

_Arguments:_
```OpenSCAD
mod (x, n)
```

_Example:_
```OpenSCAD
echo(  5%3,  mod( 5,3) );  // ECHO:  2, 2
echo( -4%3,  mod(-4,3) );  // ECHO: -1, 2
echo(  5%-3, mod( 5,-3) ); // ECHO:  2, -1
echo( -4%-3, mod(-4,-3) ); // ECHO: -1, -1
```

#### sign_plus [^][contents]
[sign_plus]: #sign_plus-
Mathematical positive signum function.  
Returns `-1` if `x<0` and `1` if `x>=0`

_Arguments:_
```OpenSCAD
sign_plus (x)
```

#### xor [^][contents]
[xor]: #xor-
Return a boolean value of operation xor with 2 boolean values

_Arguments:_
```OpenSCAD
xor (bool, bool2)
```
- `bool`, `bool2` - boolean value

_Additional functions with more then 2 arguments:_
- `xor_3 (bool, bool2, bool3)`
- `xor_4 (bool, bool2, bool3, bool4)`

#### normal_distribution [^][contents]
[normal_distribution]: #normal_distribution-
Calculate the Gauss normal distribution

_Arguments:_
```OpenSCAD
normal_distribution (x, mean, sigma)
```
- `x`     - numeric value
- `mean`  - mean value, standard = `0`
- `sigma` - value standard deviation, standard = `1`


### Trigonometric functions [^][contents]

#### Trigonometric: [^][contents]
[=> Wikipedia - Trigonometric functions](https://en.wikipedia.org/wiki/Trigonometric_functions)  
[=> Wikipedia - Versine](https://en.wikipedia.org/wiki/Versine)  
[=> Wikipedia - Exsecant](https://en.wikipedia.org/wiki/Exsecant)  
[=> Wikipedia - Chord](https://en.wikipedia.org/wiki/Chord_(geometry))  
![Circle-trig6.svg](https://upload.wikimedia.org/wikipedia/commons/9/9d/Circle-trig6.svg)  
All of the trigonometric functions of the angle θ (theta) can be constructed
geometrically in terms of a unit circle centered at O.  
From Wikipedia, License: CC BY-SA 3.0

| function           | description
|--------------------|-------------
| `cot (angle)`      | Cotangent of `angle` in degree
| `sec (angle)`      | Secant of `angle` in degree
| `csc (angle)`      | Cosecant of `angle` in degree
| `exsec (angle)`    | External secant of `angle` in degree
| `excsc (angle)`    | External cosecant of `angle` in degree
| `versin   (angle)` | Versed sine of `angle` in degree
| `coversin (angle)` | Coversed sine of `angle` in degree
| `vercos   (angle)` | Versed cosine of `angle` in degree
| `covercos (angle)` | Coversed cosine of `angle` in degree
| `chord (angle)`    | Length of the chord between two points on a unit circle separated by that central angle in degree
| `acot (x)`         | Inverse cotangent of `x`, return angle in degree
| `asec (x)`         | Inverse secant of `x`, return angle in degree
| `acsc (x)`         | Inverse cosecant of `x`, return angle in degree
| `aexsec (x)`       | Inverse external secant of `x`, return angle in degree
| `aexcsc (x)`       | Inverse external cosecant of `x`, return angle in degree
| `aversin   (x)`    | Inverse versed sine of `x`, return angle in degree
| `acoversin (x)`    | Inverse coversed sine of `x`, return angle in degree
| `avercos   (x)`    | Inverse versed cosine of `x`, return angle in degree
| `acovercos (x)`    | Inverse coversed cosine of `x`, return angle in degree
| `achord (x)`       | Return the angle from the length of the chord between two points on a unit circle

#### Hyperbolic: [^][contents]
[=> Wikipedia - Hyperbolic functions](https://en.wikipedia.org/wiki/Hyperbolic_functions)

| function   | description
|------------|-------------
| `sinh (x)` | hyperbolic sine of `x`
| `cosh (x)` | hyperbolic cosine of `x`
| `tanh (x)` | hyperbolic tangent of `x`
| `coth (x)` | hyperbolic cotangent of `x`

#### Inverse hyperbolic: [^][contents]
[=> Wikipedia - Inverse hyperbolic functions](https://en.wikipedia.org/wiki/Inverse_hyperbolic_functions)

| function    | description
|-------------|-------------
| `asinh (x)` | Inverse hyperbolic sine of `x`
| `acosh (x)` | Inverse hyperbolic cosine of `x`
| `atanh (x)` | Inverse hyperbolic tangent of `x`
| `acoth (x)` | Inverse hyperbolic cotangent of `x`

#### Trigonometric in radians: [^][contents]
[=> Wikipedia - Trigonometric functions](https://en.wikipedia.org/wiki/Trigonometric_functions)

These functions needs an angle in radians `0...2*PI`:

| function         | description
|------------------|-------------
| `sin_r (x)`      | sine of `x`
| `cos_r (x)`      | cosine of `x`
| `tan_r (x)`      | tangent of `x`
| `cot_r (x)`      | cotangent of `x`
| `sec_r (x)`      | secant of `x`
| `csc_r (x)`      | cosecant of `x`
| `versin_r   (x)` | Versed sine of `x`
| `coversin_r (x)` | Coversed sine of `x`
| `vercos_r   (x)` | Versed cosine of `x`
| `covercos_r (x)` | Coversed cosine of `x`

These functions return an angle in radians `0...2*PI`:

| function          | description
|-------------------|-------------
| `asin_r (x)`      | Inverse sine of `x`
| `acos_r (x)`      | Inverse cosine of `x`
| `atan_r (x)`      | Inverse tangent of `x`
| `atan2_r (y,x)`   | Inverse tangent. Two-argument version of `atan_r` with Y and X axis.
| `acot_r (x)`      | Inverse cotangent of `x`
| `asec_r (x)`      | Inverse secant of `x`
| `acsc_r (x)`      | Inverse cosecant of `x`
| `aversin_r   (x)` | Inverse versed sine of `x`
| `acoversin_r (x)` | Inverse coversed sine of `x`
| `avercos_r   (x)` | Inverse versed cosine of `x`
| `acovercos_r (x)` | Inverse coversed cosine of `x`

#### sinc [^][contents]
[sinc]: #sinc-
Sinc function.

[=> Wikipedia - Sinc function](https://en.wikipedia.org/wiki/Sinc_function)

_Versions:_
`si (x)`   - unnormalized sinc function  
`sinc (x)` - normalized sinc function  

#### Si [^][contents]
[si]: #si-
Trigonometric integral  
[=> Wikipedia - Trigonometric integral](https://en.wikipedia.org/wiki/Trigonometric_integral)

_Arguments:_
```OpenSCAD
Si (x)
```


Number functions [^][contents]
------------------------------

Defined in file: `banded/math_number.scad`

#### factorial [^][contents]
[factorial]: #factorial-
Calculate the factorial of a positive integer `n`, denoted by n!  
[=> Wikipedia - Factorial](https://en.wikipedia.org/wiki/Factorial)

_Arguments:_
```OpenSCAD
factorial (n)
```

#### double_factorial [^][contents]
[double_factorial]: #double_factorial-
Calculate the double factorial or semifactorial of a number `n`, denoted by n‼  
[=> Wikipedia - Double factorial](https://en.wikipedia.org/wiki/Double_factorial)

_Arguments:_
```OpenSCAD
double_factorial (n)
```

#### multi_factorial [^][contents]
[multi_factorial]: #multi_factorial-
Calculate the multifactorial of a positive integer `n`  
[=> Wikipedia - Multifactorials](https://en.wikipedia.org/wiki/Factorial#Multifactorials)

_Arguments:_
```OpenSCAD
multi_factorial (n, k)
```

#### binomial_coefficient [^][contents]
[binomial_coefficient]: #binomial_coefficient-
Calculate the binomial coefficient `n` over `k`  
[=> Wikipedia - Binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient)

_Arguments:_
```OpenSCAD
binomial_coefficient (n, k)
```

#### fibonacci [^][contents]
[fibonacci]: #fibonacci-
Calculate the Fibonacci numbers of a number `n`  
[=> Wikipedia - Fibonacci number](https://en.wikipedia.org/wiki/Fibonacci_number)

_Arguments:_
```OpenSCAD
fibonacci (n)
```

#### continued_fraction [^][contents]
[continued_fraction]: #continued_fraction-
Calculate the continued fraction  
`a0 + b1 / (a1 + b2 / (a2 + (...))))`

[=> Wikipedia - Continued fraction](https://en.wikipedia.org/wiki/Continued_fraction)

_Arguments:_
```OpenSCAD
continued_fraction (a, b)
```
- `a` - list with the coefficients of the continued fraction
- `b` - list with the numerator of the continued fraction
     -  size of this list is 1 less then list `a`
     -  if not specified value `1` will set
        and it calculate a simple continued fraction

#### gcd [^][contents]
[gcd]: #gcd-
Calculate the greatest common divisor of two integers `a` and `b`  
[=> Wikipedia - Greatest common divisor](https://en.wikipedia.org/wiki/Greatest_common_divisor)

_Arguments:_
```OpenSCAD
gcd (a, b)
```

#### lcm [^][contents]
[lcm]: #lcm-
Calculate the least common multiple of two integers `a` and `b`  
[=> Wikipedia - Least common multiple](https://en.wikipedia.org/wiki/Least_common_multiple)

_Arguments:_
```OpenSCAD
lcm (a, b)
```


Formula functions [^][contents]
-------------------------------

Defined in file: `banded/math_formula.scad`


### Get data from mathematical figures [^][contents]

#### get_radius_from [^][contents]
[get_radius_from]: #get_radius_from-
Calculate the radius from a circle.

_Arguments:_
```OpenSCAD
get_radius_from (chord, sagitta, angle)
```
It requires 2 parameters each from these 3:
- `chord`    - length of chord
- `saggitta` - segment height
- `angle`    - central angle from the center of the circle

#### get_circle_from_points [^][contents]
[get_circle_from_points]: #get_circle_from_points-
Calculate the parameter of a circle from 3 points.  
Return the result as a list `[center of the circle, radius]`.  
The points can be in 2D or 3D space.

_Arguments:_
```OpenSCAD
get_circle_from_points (p1, p2, p3)
```
- `p1`, `p2`, `p3` - 3 points on a circle line

_Specialized functions:_
- `get_circle_from_points_2d (p1, p2, p3)` - all points must be in 2D space
- `get_circle_from_points_3d (p1, p2, p3)` - all points must be in 3D space

#### get_sphere_from_points [^][contents]
[get_sphere_from_points]: #get_sphere_from_points-
Calculate the parameter of a sphere from 4 points.  
Return the result as a list `[center of the sphere, radius]`.  
The points can be only in 3D space.

_Arguments:_
```OpenSCAD
get_sphere_from_points (p1, p2, p3, p4)
```
- `p1`, `p2`, `p3`, `p4` - 4 points on a sphere surface

#### get_hypersphere_from_points [^][contents]
[get_hypersphere_from_points]: #get_hypersphere_from_points-
Calculate the parameter of a n-sphere (hypersphere) from n+1 points in a list.  
Return the result as a list `[center of the n-sphere, radius]`.  
The points must be in n dimensions.

_Arguments:_
```OpenSCAD
get_hypersphere_from_points (p)
```
- `p` - a list with points on the hypersphere surface

#### get_parabola_from_points [^][contents]
[get_parabola_from_points]: #get_parabola_from_points-
Calculates the parameter of a parabola from 3 points.  
Parabola from type: `y = Ax² + Bx + C`  
Return the result as a list `[C,B,A]`.  
The result can directly used in function [`polynomial()`][polynomial].

_Arguments:_
```OpenSCAD
get_parabola_from_points (p1, p2, p3)
```
- `p1, p2, p3` - arbitrary points on the parabola in 2D plane

#### get_parabola_from_midpoint [^][contents]
[get_parabola_from_midpoint]: #get_parabola_from_midpoint-
Calculates the parameter of a parabola from 3 points.  
Specialized version of [`get_parabola_from_points()`][get_parabola_from_points].
Needs 2 outer points and the height of the midpoint.
The distance in X-axis between the 3 points is the same.  
Parabola from type: `y = Ax² + Bx + C`  
Return the result as a list `[C,B,A]`.  
The result can directly used in function [`polynomial()`][polynomial].

_Arguments:_
```OpenSCAD
get_parabola_from_midpoint (p1, p2, ym)
```
- `p1, p2` - the both outer points on the parabola in 2D plane
- `ym`     - the height on Y-axis on the half way on X-axis between the outer points `p1` and `p2`

#### get_parabola_zero [^][contents]
[get_parabola_zero]: #get_parabola_zero-
Returns the roots of a parabola.  
Parabola from type: `y = Ax² + Bx + C`

_Arguments:_
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
  - with parameter from function [`get_parabola_from_points()`][get_parabola_from_points]
- `get_parabola_zero_from_midpoint (p1, p2, ym, chosen)`
  - with parameter from function [`get_parabola_from_midpoint()`][get_parabola_from_midpoint]


### Surface area calculation [^][contents]

#### area_cube [^][contents]
[area_cube]: #area_cube-
Calculate the surface area of a cube.  

_Arguments:_
```OpenSCAD
area_cube (size)
```
- `size`
  - Uses the same `size` parameter like `cube()`.
  - A list with the length of each axis `[ X, Y, Z ]`

#### area_cylinder [^][contents]
[area_cylinder]: #area_cylinder-
Calculate the surface area of a cylinder (or a cone).  
Uses the same parameter like `cylinder()`.

_Arguments:_
```OpenSCAD
area_cylinder (h, r1, r2, r, d, d1, d2)
```
- `h`
  - height of cylinder
- `r1`, `r2`
  - _bottom_ radius, _top_ radius
- `r`
  - _both_ radius get the same size
- `d`, `d1`, `d2`
  - diameter (instead radius)

#### area_pyramid_quadratic [^][contents]
[area_pyramid_quadratic]: #area_pyramid_quadratic-
Calculate the surface area of a pyramid in quadratic form.  

_Arguments:_
- `h`
  - height of the pyramid
- `l`
  - bottom length of one side from the pyramid
- `l2`
  - top length of one side from the pyramid
  - optional, default = `0`


### Volume calculation [^][contents]

#### volume_cube [^][contents]
[volume_cube]: #volume_cube-
Calculate the volume of a cube.  

_Arguments:_
```OpenSCAD
volume_cube (size)
```
- `size`
  - Uses the same `size` parameter like `cube()`.
  - A list with the length of each axis `[ X, Y, Z ]`

#### volume_cylinder [^][contents]
[volume_cylinder]: #volume_cylinder-
Calculate the volume of a cylinder (or a cone).  
Uses the same parameter like `cylinder()`.

_Arguments:_
```OpenSCAD
area_cylinder (h, r1, r2, r, d, d1, d2)
```
- `h`
  - height of cylinder
- `r1`, `r2`
  - _bottom_ radius, _top_ radius
- `r`
  - _both_ radius get the same size
- `d`, `d1`, `d2`
  - diameter (instead radius)

#### volume_pyramid [^][contents]
[volume_pyramid]: #volume_pyramid-
Calculate the volume of a pyramid.  
Uses the height `h` and both areas `a`, `a2`.

_Arguments:_
- `h`
  - height of the pyramid
- `a`
  - bottom area of the pyramid
- `a2`
  - top area of the pyramid
  - optional, default = `0`

