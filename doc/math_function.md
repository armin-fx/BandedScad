Math with Functions
===================

### defined in file
`banded/math.scad`  
` `|  
` `+--> ...  
` `+--> `banded/math_function.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

[<-- Math functions](math.md)

### Contents
[contents]: #contents "Up to Contents"
- [Algorithm with function literals](#algorithm-with-function-literals-)
  - [`summation_fn()`][summation_fn]
  - [`summation_auto_fn()`][summation_auto_fn]
  - [`product_fn()`][product_fn]
  - [`taylor()`][taylor]
  - [`taylor_auto()`][taylor_auto]
- [Approximate infinitesimal calculus](#approximate-infinitesimal-calculus-)
  - [`integrate()`][integrate]
  - [`derivation()`][derivation]
- [Approximate zero of a function](#approximate-zero-of-a-function-)
  - [`zero_regula_falsi()`][zero_regula_falsi]
  - [`zero_regula_falsi_parabola()`][zero_regula_falsi_parabola]
  - [`zero_bisection()`][zero_bisection]
  - [`zero_secant()`][zero_secant]
  - [`zero_newton()`][zero_newton]
  - [`zero_halley()`][zero_halley]
  - [`zero_euler_tschebyschow()`][zero_euler_tschebyschow]


Algorithm with function literals [^][contents]
----------------------------------------
This functions needs a function literal.
This needs 1 or 2 arguments depending on the function.

#### summation_fn [^][contents]
[summation_fn]: #summation_fn-
Calculate the summation on function `fn()`.  
Call a function by 1 ascending sequence of numbers from `k` to `n`
and add every result of this.

_Arguments:_
```OpenSCAD
summation_fn (fn, n, k)
```
- `fn` - function literal with 1 argument `fn (a)`
  - `a` = the index number of the ascending sequence
- `n`  - integer, summation until this number
- `k`  - begin of summation, first number, default = `0`

_Example:_
```OpenSCAD
include <banded.scad>

// add every squared number from 0 to 4
// Echo: 30
echo( summation_fn( function (n) n*n, 4) );
```

#### summation_auto_fn [^][contents]
[summation_auto_fn]: #summation_auto_fn-
Calculate the summation on function `fn()`.  
Call a function by 1 ascending sequence of numbers from `k`
and add every result of this until the result has no changes.

_Arguments:_
```OpenSCAD
summation_auto_fn (fn, k)
```
- `fn` - function literal with 1 argument `fn (a)`
  - `a` = the index number of the ascending sequence
- `k`  - begin of summation, first number, default = `0`

_Example:_
```OpenSCAD
include <banded.scad>

// calculate the geometric serie with r = 1/2
//
// ---- infinity
//  \    (n)
//   ·  r
//  / 
// ---- n=0
//
// Echo: 2
echo( summation_auto_fn( function (n) pow(1/2, n) ) );
```

#### product_fn [^][contents]
[product_fn]: #product_fn-fn-n-k-
Calculate the product on function `fn()`.  
Call a function by 1 ascending sequence of numbers from `k` to `n`
and multiply every result of this.

_Arguments:_
```OpenSCAD
product_fn (fn, n, k)
```
- `fn` - function literal with 1 argument `fn (a)`
  - `a` = the index number of the ascending sequence
- `n`  - integer, product until this number
- `k`  - begin of product, first number, default = `0`

_Example:_
```OpenSCAD
include <banded.scad>

// calculate the factorial of 4
// multiply every number from 1 to 4
// Echo: 24
echo( product_fn ( function(n) n*n, 4, 1) );
```

#### taylor [^][contents]
[taylor]: #taylor-
Calculate the taylor series with value `x`.  
Call a function `fn()` to calculate every term with value `x`
by ascending sequence of numbers from `k` to `n`.

_Arguments:_
```OpenSCAD
taylor (fn, x, n, k, step)
```
- `fn` - function literal with 2 arguments `fn (x, a)`
  - `x` = the value to calculate
  - `a` = the index number of taylor serie
- `x`  - value to calculate
- `n`  - integer, last index number, default = `0`
  - set this high enough to calculate good results
  - but not too high to prevent loss of significance
- `k`  - first index number, default = `0`
- `step`
  - increasing the index number by this step from `k` to `n`
  - default = `1`

_Example:_
```OpenSCAD
include <banded.scad>

// Calculate sin (PI/4)
// Echo: 0.707107
val = PI/4;
sin_term = function(x, n)
	let (m = n*2 + 1)
	positiv_if_even(n) * pow(x,m) / factorial(m);
echo( taylor ( sin_term, val, n=10) );
```

#### taylor_auto [^][contents]
[taylor_auto]: #taylor_auto-
Calculate the taylor series with value `x`.  
Call a function `fn()` to calculate every term with value `x`
by ascending sequence of numbers from `k` up
until the result has no changes.

_Arguments:_
```OpenSCAD
taylor_auto (fn, x, n, k, step)
```
- `fn` - function literal with 2 arguments `fn (x, a)`
  - `x` = the value to calculate
  - `a` = the index number of taylor serie
- `x`  - value to calculate
- `n`  - integer, last index number as security limit
  - default = `10000`
- `k`  - first index number, default = `0`
- `step`
  - increasing the index number by this step from `k` to `n`
  - default = `1`

_Example:_
```OpenSCAD
include <banded.scad>

// Calculate cos (PI/4)
// Echo: 0.707107
val = PI/4;
cos_term = function(x, n)
	positiv_if_even(n) * pow(x,n*2) / factorial(n*2);
echo( taylor_auto ( cos_term, val, n=2000) );
```


Approximate infinitesimal calculus [^][contents]
------------------------------------

#### integrate [^][contents]
[integrate]: #integrate-
Approximate an integral of a function `fn` with value range from `begin` to `end`.

_Arguments:_
```OpenSCAD
integrate (fn, begin, end, constant, delta)
```
- `fn` - function literal with 1 arguments `fn (x)`
  - `x` = the value to calculate
- `begin`    - first value for function `fn`
- `end`      - last value for function `fn`
- `constant` - constant value, add to result, default = `0`
- `delta`    - step amount between `begin` and `end`
  - default = `delta_std` = `0.001`

_Example:_
```OpenSCAD
include <banded.scad>

val = 4;

fn = function(x) x;
FN = function(x) 0.5*x*x;

// Echo: 8
echo( integrate ( fn, 0, val) );
echo( FN (val) );
```

#### derivation [^][contents]
[derivation]: #derivation-
Approximate the derivative of a function `fn` on `value`.

_Arguments:_
```OpenSCAD
derivation (fn, value, delta)
```
- `fn` - function literal with 1 argument `fn (x)`
  - `x` = the value to calculate
- `value` - value for function `fn` to derivate
- `delta` - step amount around `value`
  - default = `delta_std` = `0.001`

_Example:_
```OpenSCAD
include <banded.scad>

val = 3;

FN = function(x) x*x;
fn = function(x) 2*x;

// Echo: 6
echo( derivation ( FN, val) );
echo( fn (val) );
```


Approximate zero of a function [^][contents]
--------------------------------------------
The following root-finding algorithm find zeros of functions.

##### Repeating options:
- `fn`
  - function literal with 1 argument
- `fn_d`
  - first derivation of function `fn`
  - function literal with 1 argument
- `fn_dd`
  - second derivation of function `fn`
    (first derivation of function `fn_d`)
  - function literal with 1 argument
- `deviation`
  - optional, repeat the procedure until the result is at maximum
    this value away from zero
  - default = user defined constant `deviation`
- `iteration`
  - optional, repeat the procedure this count at maximum
  - prevent too much cycles if the algorithm not works
  - default = 200 cycles


#### zero_regula_falsi [^][contents]
[zero_regula_falsi]: #zero_regula_falsi-
Find zero of a function with method regula falsi.  
This will get the next value by connect the 2 points `[a, fn(a)]` and `[b, fn(b)]` with a line.
The point of the line which cross zero will used as next end-point
together with the one of the last end-points which has the other sign.
The next point is always between `a` and `b`.
And then it will repeat the procedure.

_Arguments:_
```OpenSCAD
zero_regula_falsi (fn, a, b, m, deviation, iteration)
```
- `a`, `b` - the initial end-points as X-value.
  - One of the result of `fn(a)` or `fn(b)` must be negative
    and the other one must be positive.
- `m`
  - Optional function literal to modify the regula falsi algorithm.
    These are improvements for better convergence.
  - default = `undef`
  - Function literal with 3 arguments `function (a,b,c)`.
    Where `a` and `b` are the 2 initial end-points
    and `c` is the new calculated point.
    All 3 arguments are points e.g. `[a, fn(a)]`.

There exist predefined function literals to set parameter `m`:
- Illinois algorithm:
  - `regula_falsi_m_illinois`
- Pegasus algorithm:
  - `regula_falsi_m_pegasus`
- Anderson-Björck algorithm:
  - `regula_falsi_m_anderson_bjorck`
- Anderson-Björck algorithm modified with Pegasus algorithm:
  - `regula_falsi_m_anderson_bjorck_pegasus`

Spezialized functions with fixed modified algorithm:
- `zero_regula_falsi_illinois                (fn, a, b, deviation, iteration)`
- `zero_regula_falsi_pegasus                 (fn, a, b, deviation, iteration)`
- `zero_regula_falsi_anderson_bjorck         (fn, a, b, deviation, iteration)`
- `zero_regula_falsi_anderson_bjorck_pegasus (fn, a, b, deviation, iteration)`

[=> Wikipedia - Regula falsi](https://en.wikipedia.org/wiki/Regula_falsi)

#### zero_regula_falsi_parabola [^][contents]
[zero_regula_falsi_parabola]: #zero_regula_falsi_parabola-
Find zero of a function with method regula falsi.  
This get a third point half between `a` and `b` and calculate the
zero of a parabola, which fits to all 3 points.
This position is set as next end-point
together with the one of the last end-points which has the other sign.
The next point is always between `a` and `b`.
And then it will repeat the procedure.

_Arguments:_
```OpenSCAD
zero_regula_falsi_parabola (fn, a, b, deviation, iteration)
```
- `a`, `b` - the initial end-points.
  - One of the result of `fn(a)` or `fn(b)` must be negative
    and the other one must be positive.

#### zero_bisection [^][contents]
[zero_bisection]: #zero_bisection-
Find zero of a function with bisection method.  
This set the next end-point half between `a` and `b`.
The next point is always between `a` and `b`.
This new point will used together with the one of the last end-points which has the other sign.
And then it will repeat the procedure.

_Arguments:_
```OpenSCAD
zero_bisection (fn, a, b, deviation, iteration)
```
- `a`, `b` - the initial end-points.
  - One of the result of `fn(a)` or `fn(b)` must be negative
    and the other one must be positive.

[=> Wikipedia - Bisection method](https://en.wikipedia.org/wiki/Bisection_method)

#### zero_secant [^][contents]
[zero_secant]: #zero_secant-
Find zero of a function with secant method.  
This will get the next value by connect the 2 points `a` and `b` with a line.
The point of the line which cross zero will used as next point
together with the last point.
And then it will repeat the procedure.
The next point must not be between `a` and `b`.
Both points must not have a different sign.

_Arguments:_
```OpenSCAD
zero_secant (fn, a, b, deviation, iteration)
```
- `a` - first initial point
- `b` - last initial point

[=> Wikipedia - Secant method](https://en.wikipedia.org/wiki/Secant_method)

#### zero_newton [^][contents]
[zero_newton]: #zero_newton-
Find zero of a function with Newton's method.  
This needs the first derivation of function `fn`.
This method will calculate the tangent line on point `x`.
The point of the line which cross zero will used as next point.

_Arguments:_
```OpenSCAD
zero_newton (fn, fn_d, x, deviation, iteration)
```
- `fn_d`
  - first derivation of function `fn`
  - if not defined (set with `undef`), then function `derivation (fn)` will used instead.
- `x` - initial guess point

[=> Wikipedia - Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method)

#### zero_newton_auto [^][contents]
[zero_newton_auto]: #zero_newton_auto-
Find zero of a function with Newton's method.  
Specialized version of [`zero_newton()`][zero_newton]
where the first derivation of `fn` will calculated with function `derivation (fn)`.

_Arguments:_
```OpenSCAD
zero_newton_auto (fn, x, deviation, iteration)
```

#### zero_halley [^][contents]
[zero_halley]: #zero_halley-
Find zero of a function with Halleys's method.  
This needs the first and the second derivation of function `fn`.
This method is motivated by unbend the function `fn` around position `x`
with: `g(x) = fn(x) / sqrt(abs(fn_d(x)))`.

_Arguments:_
```OpenSCAD
zero_halley (fn, fn_d, fn_dd, x, deviation, iteration)
```
- `fn_d`
  - first derivation of function `fn`
  - if not defined (set with `undef`), then function `derivation (fn)` will used instead.
- `fn_dd`
  - second derivation of function `fn`
  - if not defined (set with `undef`), then function `derivation (fn_d)` will used instead.
- `x` - initial guess point

[=> Wikipedia - Halleys's method](https://en.wikipedia.org/wiki/Halley%27s_method)

#### zero_halley_auto [^][contents]
[zero_halley_auto]: #zero_halley_auto-
Find zero of a function with Halleys's method.  
Specialized version of [`zero_halley()`][zero_halley]
where the first derivation of `fn` will calculated with function `derivation (fn)`
and second derivation of `fn` will calculated with function `derivation (fn_d)`.

_Arguments:_
```OpenSCAD
zero_halley_auto (fn, x, deviation, iteration)
```

#### zero_euler_tschebyschow [^][contents]
[zero_euler_tschebyschow]: #zero_euler_tschebyschow-
Find zero of a function with Euler-Tschebyschow's method.

_Arguments:_
```OpenSCAD
zero_euler_tschebyschow (fn, fn_d, fn_dd, x, deviation, iteration)
```
- `fn_d`
  - first derivation of function `fn`
  - if not defined (set with `undef`), then function `derivation (fn)` will used instead.
- `fn_dd`
  - second derivation of function `fn`
  - if not defined (set with `undef`), then function `derivation (fn_d)` will used instead.
- `x` - initial guess point

[=> Wikipedia - Euler-Tschebyschow-Verfahren](https://de.wikipedia.org/wiki/Euler-Tschebyschow-Verfahren)

#### zero_euler_tschebyschow_auto [^][contents]
[zero_euler_tschebyschow_auto]: #zero_euler_tschebyschow_auto-
Find zero of a function with Euler-Tschebyschow's method.  
Specialized version of [`zero_euler_tschebyschow()`][zero_euler_tschebyschow]
where the first derivation of `fn` will calculated with function `derivation (fn)`
and second derivation of `fn` will calculated with function `derivation (fn_d)`.

_Arguments:_
```OpenSCAD
zero_euler_tschebyschow_auto (fn, x, deviation, iteration)
```

