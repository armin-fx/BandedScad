Functions
=========

### defined in file
`banded/function.scad`\
` `| \
` `+--> `banded/function_algorithmus.scad`\

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Algorithmus with function literals](#algorithmus-with-function-literals-)
  - [`summation_fn()`][#summation_fn]
  - [`summation_auto_fn()`][summation_auto_fn]
  - [`product_fn()`][product_fn]
  - [`taylor()`][taylor]
  - [`taylor_auto()`][taylor_auto]
  - [`integrate()`][integrate]
  - [`derivation()`][derivation]


Algorithmus with function literals [^][contents]
----------------------------------------
This functions needs a function literal.
This needs 1 or 2 arguments depending on the function.

#### `summation_fn (fn, n, k)` [^][contents]
[#summation_fn]: #summation_fn-fn-n-k-
Calculate the summation on function `fn()`.\
Call a function by 1 ascending sequence of numbers from `k` to `n`
and add every result of this.
- `fn` - function literal with 1 argument `fn (a)`
  - `a` = the index number of the ascending sequence
- `n`  - integer, summation until this number
- `k`  - begin of summation, first number, default = `0`

___Example:___
```OpenSCAD
include <banded.scad>

// add every squared number from 0 to 4
// Echo: 30
echo( summation_fn( function (n) n*n, 4) );
```

#### `summation_auto_fn (fn, k)` [^][contents]
[summation_auto_fn]: #summation_auto_fn-fn-k-
Calculate the summation on function `fn()`.\
Call a function by 1 ascending sequence of numbers from `k`
and add every result of this until the result has no changes.
- `fn` - function literal with 1 argument `fn (a)`
  - `a` = the index number of the ascending sequence
- `k`  - begin of summation, first number, default = `0`

___Example:___
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

#### `product_fn (fn, n, k)` [^][contents]
[product_fn]: #product_fn-fn-n-k-
Calculate the product on function `fn()`.\
Call a function by 1 ascending sequence of numbers from `k` to `n`
and multiply every result of this.
- `fn` - function literal with 1 argument `fn (a)`
  - `a` = the index number of the ascending sequence
- `n`  - integer, product until this number
- `k`  - begin of product, first number, default = `0`

___Example:___
```OpenSCAD
include <banded.scad>

// calculate the factorial of 4
// multiply every number from 1 to 4
// Echo: 24
echo( product_fn ( function(n) n*n, 4, 1) );
```

#### `taylor (fn, x, n, k, step)` [^][contents]
[taylor]: #taylor-fn-x-n-k-
Calculate the taylor series with value `x`.\
Call a function `fn()` to calculate every term with value `x`
by ascending sequence of numbers from `k` to `n`.
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

___Example:___
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

#### `taylor_auto (fn, x, n, k, step)` [^][contents]
[taylor_auto]: #taylor_auto-fn-x-n-k-step-
Calculate the taylor series with value `x`.\
Call a function `fn()` to calculate every term with value `x`
by ascending sequence of numbers from `k` up
until the result has no changes.
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

___Example:___
```OpenSCAD
include <banded.scad>

// Calculate cos (PI/4)
// Echo: 0.707107
val = PI/4;
cos_term = function(x, n)
	positiv_if_even(n) * pow(x,n*2) / factorial(n*2);
echo( taylor_auto ( cos_term, val, n=2000) );
```

#### `integrate (fn, begin, end, constant, delta)` [^][contents]
[integrate]: #integrate-fn-begin-end-constant-delta-
Approximate an integral of a function `fn` with value range from `begin` to `end`.
- `fn` - function literal with 1 arguments `fn (x)`
  - `x` = the value to calculate
- `begin`    - first value for function `fn`
- `end`      - last value for function `fn`
- `constant` - constant value, add to result, default = `0`
- `delta`    - step amount between `begin` and `end`
  - default = `delta_std` = `0.001`

___Example:___
```OpenSCAD
include <banded.scad>

val = 4;

fn = function(x) x;
FN = function(x) 0.5*x*x;

// Echo: 8
echo( integrate ( fn, 0, val) );
echo( FN (val) );
```

#### `derivation (fn, value, delta)` [^][contents]
[derivation]: #derivation-fn-value-delta-
Approximate the derivative of a function `fn` on `value`.
- `fn` - function literal with 1 arguments `fn (x)`
  - `x` = the value to calculate
- `value` - value for function `fn` to derivate
- `delta` - step amount around `value`
  - default = `delta_std` = `0.001`

___Example:___
```OpenSCAD
include <banded.scad>

val = 3;

FN = function(x) x*x;
fn = function(x) 2*x;

// Echo: 6
echo( derivation ( FN, val) );
echo( fn (val) );
```

