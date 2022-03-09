Math functions
==============

### defined in file
`banded/math.scad`\
` `| \
` `+--> `banded/math_common.scad`\
` `+--> `banded/math_vector.scad`\
` `+--> `banded/math_matrix.scad`\
` `+--> `banded/math_formula.scad`\
` `+--> `banded/complex.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Complex numbers ->][complex]
- [Matrix and vector operations ->][matrix]

- [More math functions][math]
  - [Test and restrict](#test-and-restrict-)
    - [`constrain()`][constrain]
    - [`constrain_bidirectional()`][constrain_bi]
    - [`is_nearly()`][is_nearly]
    - [`quantize()`][quantize]
  - [Even or odd](#even-or-odd-)
    - [`is_odd()`, `is_even()`][is_odd]
    - [`positiv_if_xxx()`][positiv_if]
  - [Various math functions](#various-math-functions-)
    - [`sqr()`][sqr]
    - [`reverse_norm()`][reverse_norm]
    - [`mod()`][mod]
    - [`xor()`][xor]
    - [`normal_distribution()`][normal_distribution]
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
      - `arsinh()`
      - `arcosh()`
      - `artanh()`
      - `arcoth()`
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
- [Formula functions][formula]

[complex]: complex.md
[matrix]:  matrix.md
[math]:    #more-math-functions-
[formula]: #formula-functions-


More math functions [^][contents]
---------------------------------

### Test and restrict [^][contents]

#### `constrain (value, a, b)` [^][contents]
[constrain]: #constrain-value-a-b-
Limits a number to a range.
- `value` - The number to restrict.
- `a`     - The lower end of the range.
- `b`     - The upper end of the range.

Returns:
- `value` - If number is between `a` and `b`
- `a`     - If number is lower than `a`
- `b`     - If number is higher than `b`

#### `constrain_bidirectional (value, a, b)` [^][contents]
[constrain_bi]: #constrain_bidirectional-value-a-b-
Limits a number to a range.
- `value`  - The number to restrict.
- `a`, `b` - The range limits, unsorted

Returns:
- `value`    - If number is between `a` and `b`
- `a` or `b` - If number exceeds `a` or `b`

#### `is_nearly (a, b, deviation)` [^][contents]
[is_nearly]: #is_nearly-a-b-deviation-
Compares two values or two lists of values to see if they approximately match
- `a`, `b`  - Values or lists to compare
- deviation - Maximum deviation of the values, default = `1e-14`

#### `quantize (value, raster, offset)` [^][contents]
[quantize]: #quantize-value-raster-offset-
Quantizes a value within a grid.\
Default = round to an integer
- `value`  - Numeric value
- `raster` - Distance between the grid
- `offset` - Shift from the origin


### Even or odd [^][contents]

#### `is_odd (n)`, `is_even (n)` [^][contents]
[is_odd]: #is_odd-n-is_even-n-
Returns `true` if
- `n` is odd value with `is_odd()`
- `n` is even value with `is_even()`

#### `positiv_if_xxx (n)` [^][contents]
[positiv_if]: #positiv_if_xxx-n-
Returns `1` or `-1` if the condition of `n` fits

| function            | return `1`   | return `-1`
|---------------------|--------------|-------------
| `positiv_if_odd()`  | `n` is odd   | `n` is even
| `positiv_if_even()` | `n` is even  | `n` is odd
| `negativ_if_odd()`  | `n` is even  | `n` is odd
| `negativ_if_even()` | `n` is odd   | `n` is even


### Various math functions [^][contents]

#### `sqr (x)` [^][contents]
[sqr]: #sqr-x-
Square a value `x`. A function name for `x*x`

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

#### `mod (x, n)` [^][contents]
[mod]: #mod-x-n-
Calculates the modulo.\
Get the remainder of `x / n` with floored division.
The remainder would have the same sign as the divisor `n`.

#### `xor (bool, bool2)` [^][contents]
[xor]: #xor-bool-bool2-
return a boolean value of operation xor
- `bool`, `bool2` - boolean value

#### `normal_distribution (x, mean, sigma)` [^][contents]
[normal_distribution]: #normal_distribution-x-mean-sigma-
Calculate the Gauss normal distribution
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

| function     | description
|--------------|-------------
| `arsinh (x)` | Inverse hyperbolic sine of `x`
| `arcosh (x)` | Inverse hyperbolic cosine of `x`
| `artanh (x)` | Inverse hyperbolic tangent of `x`
| `arcoth (x)` | Inverse hyperbolic cotangent of `x`

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


### Number functions [^][contents]

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

#### `get_radius_from (chord, sagitta, angle)` [^][contents]
[get_radius_from]: #get_radius_from-chord-saggitta-angle-
Calculate the radius from a circle.\
It requires 2 parameters each from these 3:
- `chord`    - length of chord
- `saggitta` - segment height
- `angle`    - central angle from the center of the circle

#### `get_circle_from_points (p1, p2, p3)` [^][contents]
[get_circle_from_points]: #get_circle_from_points-p1-p2-p3-
Calculate the parameter of a circle from 3 points.\
Return the result as a list `[center of the circle, radius]`.
