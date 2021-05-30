Helper functions
================

### defined in file
`banded/helper.scad`\
` `| \
` `+--> `banded/helper_native.scad`\
` `+--> `banded/helper_recondition.scad`\
` `\
`banded/benchmark.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Native helper functions](#native-helper-functions-)
  - [Test functions](test-functions-)
- [Recondition arguments of functions](recondition-arguments-of-functions-)
- [Benchmark function](#benchmark-function-)


Native helper functions [^][contents]
-------------------------------------

### Test functions [^][contents]
Returns `true` if the argument is OK

| function             | description
|----------------------|-------------
| `is_nan (value)`     | test a numeric value is Not-A-Number
| `is_inf (value)`     | test a numeric value is posivive infinity
| `is_inf_abs (value)` | test a numeric value is posivive or negative infinity
| `is_range (value)`   | test if value is a range like `[0:1:10]`

 . . .


Recondition arguments of functions [^][contents]
------------------------------------------------

 . . .


Benchmark function [^][contents]
--------------------------------

#### `benchmark (count, fn_test)` [^][contents]
Call a function `count` often to measure speed in time.\
The test function `fn_test()` must defined therefor.
1. `fn_test()` as function
   ```OpenSCAD
   function fn_test() = "do something . . . " ;
   
   echo (benchmark(0));
   ```
2. since OpenSCAD version 2021.01:\
   commit a function literal to option `fn_test`
   ```OpenSCAD
   echo (benchmark(0, function() "do something . . . " ));
   ```
- `count`
  - count of loops
  - value `0` is 1 call, `1` -> 2 calls, and so on

If is defined a variable
```OpenSCAD
benchmark_trial = true;
```
the test function `fn_test()` will only called 1 times
independently what is set in `count`.\
This is useful to test the function before mesure the speed.

