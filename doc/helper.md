Helper functions
================

### defined in file
`banded/helper.scad`\
` `| \
` `+--> `banded/helper_native.scad`\
` `+--> `banded/helper_recondition.scad`\
` `\
`banded/benchmark.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Native helper functions](#native-helper-functions-)
  - [Test functions](test-functions-)
    - `is_nan()`
    - `is_inf()`
    - `is_inf_abs()`
    - `is_range()`
  - [Nesting depth of lists](#nesting-depth-of-lists-)
    - [`is_list_depth()`][is_list_depth]
    - [`is_list_depth_num()`][is_list_depth_num]
    - [`get_list_depth()`][get_list_depth]
  - [Get data](#get-data-)
    - [`extract_axis()`][extract_axis]
    - [`diff_list()`][diff_list]
    - [`diff_axis_list()`][diff_axis_list]
    - [`range()`][range]
  - [Get position on lists](#get-position-on-lists-)
    - [`get_position()`][get_position]
    - [`get_position_safe()`][get_position_safe]
    - [`get_position_insert()`][get_position_insert]
    - [`get_position_insert_safe()`][get_position_insert_safe]
  - [Data consistency](#data-consistency-)
    - [`is_good_list()`][is_good_list]
    - [`is_num_list()`][is_num_list]
  - [Get first good value](#get-first-good-value-)
    - [`get_first_good()`][get_first_good]
    - [`get_first_good_list()`][get_first_good_list]
    - [`get_first_num()`][get_first_num]
    - [`get_first_num_list()`][get_first_num_list]
    - [`get_first_good_in_list()`][get_first_good_in_list]
    - [`get_first_num_in_list()`][get_first_num_in_list]
- [Recondition arguments of functions](#recondition-arguments-of-functions-)
  - [`repair_matrix()`][repair_matrix]
  - [`fill_missing_matrix()`][fill_missing_matrix]
  - [`fill_missing_list()`][fill_missing_list]
  - [`parameter_range()`][parameter_range]
  - [`parameter_range_safe()`][parameter_range_safe]
  - [`parameter_circle_r()`][parameter_circle_r]
  - [`parameter_cylinder_r()`][parameter_cylinder_r]
  - [`parameter_cylinder_r_basic()`][parameter_cylinder_r_basic]
  - [`parameter_ring_2r()`][parameter_ring_2r]
  - [`parameter_ring_2r_basic()`][parameter_ring_2r_basic]
  - [`parameter_funnel_r()`][parameter_funnel_r]
  - [`parameter_helix_to_rp()`][parameter_helix_to_rp]
  - [`parameter_size_3d()`][parameter_size_3d]
  - [`parameter_size_2d()`][parameter_size_2d]
  - [`parameter_scale`][parameter_scale]
  - [`parameter_align()`][parameter_align]
  - [`parameter_numlist()`][parameter_numlist]
  - [`parameter_angle()`][parameter_angle]
  - [`parameter_mirror_vector_2d()`][parameter_mirror_vector_2d]
  - [`parameter_mirror_vector_3d()`][parameter_mirror_vector_3d]
  - [`parameter_edges_radius()`][parameter_edges_radius]
  - [`parameter_edge_radius()`][parameter_edge_radius]
  - [`parameter_types()`][parameter_types]
  - [`parameter_type()`][parameter_type]
- [Benchmark function](#benchmark-function-)
  - `benchmark()`

[range_args]: list.md#range-arguments-


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


### Nesting depth of lists [^][contents]

#### `is_list_depth (value, depth)` [^][contents]
[is_list_depth]: #is_list_depth-value-depth-
Tests a variable to see if it contains a list with a specified nesting depth.
- `depth` - depth of nested lists
  - `1` tests `value` for a simple non-nested list, default
  - if set `0`, `value` is tested to make sure it's not undef and not a list

#### `is_list_depth_num (value, depth)` [^][contents]
[is_list_depth_num]: #is_list_depth_num-value-depth-
Tests a variable to see if it contains a list with a specified nesting depth,
and the last list contains numeric values.
- `depth` - depth of nested lists
  - `1` tests `value` for a simple non-nested list, default
  - if set `0`, `value` is tested to make sure it's not undef and not a list

#### `get_list_depth (list)` [^][contents]
[get_list_depth]: #get_list_depth-list-
Returns the nesting depth of a list.


### Get data [^][contents]

#### `extract_axis (list, axis)` [^][contents]
[extract_axis]: #extract_axis-list-axis-
Extracts a fixed position on every entry in a list.\
Returns a list with this values.
- `axis` - position of element (list or string) on entry in the list

```
extract_axis (list=[[x,y,z], [1,2,3], [11,12,13]], axis=1)  =>  [y,2,12]
                       ^        ^          ^                     ^ ^  ^
                     0 1 2    0 1 2     0  1  2
```

#### `diff_list (list)` [^][contents]
[diff_list]: #diff_list-list-
Returns the largest distance of each value within a list.\
Subtract the smallest value in list from the biggest value in list.
```
diff_list ([3, 2, 4, 7])  ==> 7 - 2 = 5
            ^     ^
```

#### `diff_axis_list (list)` [^][contents]
[diff_axis_list]: #diff_axis_list-list-
Returns the largest distance of each axis in a vector list.\
```
diff_axis_list ([ [1,3],[6,9],[4,2] ])
  6 - 1 = 5        ^     ^
  9 - 2 = 7                ^     ^
  ==>  [5,7]
```

#### `range (value)` [^][contents]
[range]: #range-value-
Converts a range specification to a list.\
`[0:3]  ==>  [0,1,2,3]`


### Get position on lists [^][contents]

#### `get_position (list, position)` [^][contents]
[get_position]: #get_position-list-position-
Returns the real position within a list.\
Coding like in python:
- positive index = list from the beginning
- negative index = list from the end
  - `-1` points on the last element of the list

```
[a, b, c, d]
 |  |  |  |
 0  1  2  3
-4 -3 -2 -1
```

#### `get_position_safe (list, position)` [^][contents]
[get_position_safe]: #get_position_safe-list-position-
Returns the real position within a list.\
Same like [`get_position()`][get_position], but constrain the position to
the first or last element if the value exceed the real size of the list.

#### `get_position_insert (list, position)` [^][contents]
[get_position_insert]: #get_position_insert-list-position-
Returns the real position within a list.\
Coding makes sense for insertion positions:
- positive index = list from the beginning
- negative index = list at the end after the last element
  - `-1` points one element after the last element of the list

```
  [a,  b,  c,  d]
   |   |   |   |
   0   1   2   3
 ^   ^   ^   ^   ^
  \   \   \   \   \
  -5  -4  -3  -2  -1
```

#### `get_position_insert_safe (list, position)` [^][contents]
[get_position_insert_safe]: #get_position_insert_safe-list-position-
Returns the real position within a list.\
Same like [`get_position_insert()`][get_position_insert], but constrain the position to
the first or 1 element after the last element if the value exceed the real size of the list.


### Data consistency [^][contents]

#### `is_good_list (list, begin, end)` [^][contents]
[is_good_list]: #is_good_list-list-begin-end-

___Specialized function with fixed list size:___
- `is_good_1d (list)` - test a list with 1 element
- `is_good_2d (list)` - test a list with 2 elements
- `is_good_3d (list)` - test a list with 3 elements
- `is_good_4d (list)` - test a list with 4 elements

#### `is_num_list (list, begin, end)` [^][contents]
[is_num_list]: #is_good_list-list-begin-end-

___Specialized function with fixed list size:___
- `is_num_1d (list)` - test a list with 1 element
- `is_num_2d (list)` - test a list with 2 elements
- `is_num_3d (list)` - test a list with 3 elements
- `is_num_4d (list)` - test a list with 4 elements


### Get first good value [^][contents]
These functions can be used e.g. if several arguments calculate one
parameter and these argument have a priority order.
So it returns the first argument which matches.

#### `get_first_good (a0, ... , a9)` [^][contents]
[get_first_good]: #get_first_good-a0---a9-
Return the first argument which is not `undef`.\
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.

#### `get_first_good_list (size, a0, ... , a9)` [^][contents]
[get_first_good_list]: #get_first_good_list-size-a0---a9-
Return the first argument which is not `undef`
and contains a list with a defined lenght
and all elements of this list are not `undef`.\
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.
- `size` - lenght the list must have, greater then `0`

___Specialized function with fixed list size:___
- `get_first_good_1d (a0, ... , a9)` - test lists with 1 element
- `get_first_good_2d (a0, ... , a9)` - test lists with 2 elements
- `get_first_good_3d (a0, ... , a9)` - test lists with 3 elements

#### `get_first_num (a0, ... , a9)` [^][contents]
[get_first_num]: #get_first_num-a0---a9-
Return the first argument which contains a numeric value.\
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.

#### `get_first_num_list (size, a0, ... , a9)` [^][contents]
[get_first_num_list]: #get_first_num_list-size-a0---a9-
Return the first argument which is not `undef`
and contains a list with a defined lenght
and all elements of this list contains a numeric value.\
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.
- `size` - size the list must have, greater then `0`

___Specialized function with fixed list lenght:___
- `get_first_num_1d (a0, ... , a9)` - test lists with 1 element
- `get_first_num_2d (a0, ... , a9)` - test lists with 2 elements
- `get_first_num_3d (a0, ... , a9)` - test lists with 3 elements

#### `get_first_good_in_list (list, size, begin)` [^][contents]
[get_first_good_in_list]: #get_first_good_in_list-list-size-begin-
Returns the first valid element in the list.\
The first element that satisfies all the conditions is taken.

Ascents:
- element is not undef
- element is a list of (at least) size `size` with valid values
- if `size`==`0` the item is a valid value and not a list
- ___a valid value:___ any data type except `undef`

Arguments:
- `list` - list of items
- `size` - element must be a list of this size
  - if set `0`, then the item must be a valid value and not a list
- `begin` - testing starts from this position on list. Default = `0`, complete list

#### `get_first_num_in_list (list, size, begin)` [^][contents]
[get_first_num_in_list]: #get_first_num_in_list-list-size-begin-
Returns the first valid element in the list.\
The first element that satisfies all the conditions is taken.

Ascents:
- element is not undef
- element is a list of (at least) size `size` with valid values
- if `size`==`0` the item is a valid value and not a list
- ___a valid value:___ a numeric value

Arguments:
- `list` - list of items
- `size` - element must be a list of this size
  - if set `0`, then the item must be a valid value and not a list
- `begin` - testing starts from this position on list. Default = `0`, complete list


Recondition arguments of functions [^][contents]
------------------------------------------------
Contains functions that evaluate the passed arguments
from modules and functions.

#### `repair_matrix (m, d)` [^][contents]
[repair_matrix]: #-repair_matrix-m-d-
Test an repair matrices for affine transformation.\
Fill missing elements with elements from the unity matrix.
- `d`
  - dimension of the matrix, d×d matrix
  - if not set, use length of first line from the matrix
    to determine the d×d size of the matrix

#### `fill_missing_matrix (m, c)` [^][contents]
[fill_missing_matrix]: #fill_missing_matrix-m-c-
Fill missing elements in matrix `m` with elements from matrix `c`.\
The size of the matrix is used from `c`.
An entry in the matrix must be a numeric value.

#### `fill_missing_list (list, c)` [^][contents]
[fill_missing_list]: #fill_missing_list-list-c-
Fill missing elements in a list with elements from list `c`.
An entry in the list must be a numeric value.

#### `parameter_range (list, 'range_args')` [^][contents]
[parameter_range]: #parameter_range-list-range_args-
Test the range of a list in the ['range_args'][range_args].\
Encoding is as in python (e.g. -1 = last element).
Returns the real range `[begin, last]` for a list.
Default is the full range from first to last element in a list.

- [`'range_args'`][range_args] - a sets of arguments
  - `begin` - first element from a list
  - `last`  - last element
  - `count` - count of elements
  - `range` - a list with: `[begin, last]`

Priority of the arguments:
1. `begin`, `last`
2. `begin`, `count`
3. `last`, `count`
4. `range[0]`, `count`
5. `range[1]`, `count`
6. `range`
7. single argument (`begin`, `last`, `count`), remainder to default
8. `[0, -1]` = default, full range


#### `parameter_range_safe (list, 'range_args')` [^][contents]
[parameter_range_safe]: #parameter_range_safe-list-range_args-
Test the range of a list in the ['range_args'][range_args].\
Encoding as in python (e.g. -1 = last element).
Returns the real range `[begin, last]` for a list.
Default is full range from first to last element in a list.

Same like [`parameter_range()`][parameter_range], but constrain the position to
the first or last element if the value exceed the real size of the list.

#### `parameter_circle_r (r, d, default)` [^][contents]
[parameter_circle_r]: #parameter_circle_r-r-d-default-
Returns the radius of a circle.

Arguments:
- `r` - radius
- `d` - diameter
- `default` - optional, default radius = 1

Rules as for OpenSCAD's `circle()`:
- Diameter comes before radius
- without specification: r=`1`

#### `parameter_cylinder_r (r, r1, r2, d, d1, d2, preset)` [^][contents]
[parameter_cylinder_r]: #parameter_cylinder_r-r-r1-r2-d-d1-d2-preset-
Returns `[radius_bottom, radius_top]` of a cylinder.

Arguments:
- `r`  - radius top and bottom
- `r1` - radius below
- `r2` - radius at top
- `d`  - top and bottom diameter
- `d1` - diameter below
- `d2` - diameter at top
- `preset` - optional, use this value if nothing fits

Rules like OpenSCAD's `cylinder()`
- Diameter comes before radius
- special information (`r1`, `r2`) takes precedence over general information (`r`)
- without specification: r=`1`

#### `parameter_cylinder_r_basic (r, r1, r2, preset)` [^][contents]
[parameter_cylinder_r_basic]: #parameter_cylinder_r_basic-r-r1-r2-preset-
Returns `[radius_bottom, radius_top]` of a cylinder.\
Same like [`parameter_cylinder_r()`][parameter_cylinder_r]
but without argument diameter.

Arguments:
- `r`  - radius top and bottom
- `r1` - radius below
- `r2` - radius at top
- `preset` - optional, use this value as radius if nothing fits

Rules like OpenSCAD's `cylinder()`
- special information (`r1`, `r2`) takes precedence over general information (`r`)
- without specification: r=`1`

#### `parameter_ring_2r (r, w, r1, r2, d, d1, d2)` [^][contents]
[parameter_ring_2r]: #parameter_ring_2r-r-w-r1-r2-d-d1-d2-
Returns `[inner radius, outer radius]` of a Ring.

```
    __-––  ----------+  ------------+
   /       ------+   |  --------+
 ,     .-  --+          --+ r1  r   r2
 |    |      d1  d   d2 --+ ----+ --+
 *     '-  --+          ----+
   \_      ------+   |       w
     `-––  ----------+  ----+
```

Arguments:
- `r`, `d`   - middle radius or middle diameter
- `r1`, `d1` - inner radius or inner diameter
- `r2`, `d2` - outside radius or outside diameter
- `w`        - width of the ring

Must specify:
- exactly 2 specifications of `r` or `r1` or `r2` or `w`

Rules based on OpenSCAD:
- diameter comes before radius
- without specification: `r1`=`1`, `r2`=`2`

#### `parameter_ring_2r_basic (r, w, r1, r2)` [^][contents]
[parameter_ring_2r_basic]: #parameter_ring_2r_basic-r-w-r1-r2-
Returns `[inner radius, outer radius]` of a ring.
Same like [`parameter_ring_2r()`][parameter_ring_2r]
but without argument diameter.

Arguments:
- `r`  - middle radius
- `r1` - inner radius
- `r2` - outside radius
- `w`  - width of the ring

Must specify:
- exactly 2 specifications of `r` or `r1` or `r2` or `w`

Rules based on OpenSCAD:
- without specification: `r1`=`1`, `r2`=`2`

#### `parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2)` [^][contents]
[parameter_funnel_r]: #parameter_funnel_r-ri1-ri2-ro1-ro2-w-di1-di2-do1-do2-
Returns `[ri1, ri2, ro1, ro2]` of a funnel.

Arguments:
- `ri1`, `ri2` - inner radius bottom, top
- `ro1`, `ro2` - outer radius bottom, top
- `w`          - width of the wall. Optional
- `di1`, `di2` - inner diameter bottom, top. Optional
- `do1`, `do2` - outer diameter bottom, top. Optional

Rules:
- Radius comes before diameter
- missing radius or diameter is taken from
  the wall parameter and the opposite radius or diameter

#### `parameter_helix_to_rp (rotations, pitch, height)` [^][contents]
[parameter_helix_to_rp]: #parameter_helix_to_rp-rotations-pitch-height-
Returns `[rotations, pitch]` of a helix

Arguments:
- rotations - number of rotations
- pitch     - pitch difference per revolution
- height    - height of the helix

Notice:
- exactly 2 specifications of `rotations` or `pitch` or `height` are needed
- default = `[1, 0]` - 1 full rotation and no pitch

#### `parameter_size_3d (size)` [^][contents]
[parameter_size_3d]: #parameter_size_3d-size-
Converts the `size` argument to a triple `[1,2,3]`.\
Used for e.g. the argument `size` in `cube()`.
- `size=3`       becomes `[3,3,3]`
- `size=[1,2,3]` remains `[1,2,3]`

#### `parameter_size_2d (size)` [^][contents]
[parameter_size_2d]: #parameter_size_2d-size-
Converts the `size` argument to a duple `[1,2]`.\
Used for e.g. the argument `size` in `square()`.
- `size=3`     becomes `[3,3]`
- `size=[1,2]` remains `[1,2]`

#### `parameter_scale (scale, d, preset)` [^][contents]
[parameter_scale]: parameter_scale-scale-d-preset-
Evaluate the `scale` argument.
- `d`
  - Dimension of the vector `scale`, default = 3
  - Set the scale vector to full `d` dimensions and fill missing values with `1`.
- `scale`
  - A list with scale values for every axis.
  - A numeric value set in `scale` will set for all axis.
  - e.g.
    - `size=3`       becomes `[3,3]`
    - `size=[1,2,2]` remains `[1,2,2]`
    - `size=[2,2]`   becomes `[2,2,1]`, fill missing value with `1`
- `preset`
  - Use this value if scale is not set.
  - A numeric value will set in list for all axis
  - default = 1 for all axis

#### `parameter_align (align, preset, center)` [^][contents]
[parameter_align]: #parameter_align-align-preset-center-
Evaluate the `align` argument.\
Used to align an object from its center to its axis.
Values can be given at the respective axis `-1...0...1`.
- `1` = alignment of the object to the positive side of the respective axis.
- `0` = the object is at the center of the respective axis
- `[0,0,0]` is like `center=true`, default behavior is `center=false` specified in preset.
- Specification of `align` overrides specification of `center`.

#### `parameter_numlist (dimension, value, preset, fill)` [^][contents]
[parameter_numlist]: #parameter_numlist-dimension-value-preset-fill-
Converts the `value` argument to a list of `dimension` elements.\
If that doesn't work, the default value `preset` is used.

Arguments:
- `dimension` - desired size of the list
- `value`     - argument being processed
  - as a list
    - set to `dimension` elements
  - as value
    - a list with `dimension` elements filled with this value will be created
- `preset`    - default value if conversion fails
- `fill`      - handling if list is less than `dimension`
  - true
    - missing values ​​are filled with preset
  - false
    - 'preset' is taken
  - leave undef
    - value as it is (default)
  - a number
    - position specification,
      take a value from `value` at this position and fill up the list with it.
    - If that doesn't work, `preset` is used
  - a list
    - fill with the values from the list 'fill' at the appropriate positions

#### `parameter_angle (angle, angle_std)` [^][contents]
[parameter_angle]: #parameter_angle-angle-angle_std-
Returns the angle parameter as a list `[opening_angle, start_angle]`

Arguments:
- `angle`
  - as a number
    - use as opening angle specification
    - starting angle is set to `0`
  - as a list
    - `[opening_angle, start_angle]`
- `angle_std` - default angle if `angle` is not set (default = `[360, 0]`)

#### `parameter_mirror_vector_2d (v, v_std)` [^][contents]
[parameter_mirror_vector_2d]: #parameter_mirror_vector_2d-v-v_std-
Test 2D vector `v` and may load default for vector in mirror function.
- `v_std`
  - default vector if `v` not correct,
    default = `[1,0]` like OpenSCAD's default

#### `parameter_mirror_vector_3d (v, v_std)` [^][contents]
[parameter_mirror_vector_3d]: #parameter_mirror_vector_3d-v-v_std-
Test 3D vector `v` and may load default for vector in mirror function.
- `v_std`
  - default vector if `v` not correct,
    default = `[1,0,0]` like OpenSCAD's default

#### `parameter_edges_radius (edge_list, r)` [^][contents]
[parameter_edges_radius]: #parameter_edges_radius-edge_list-r-
Evaluates the `edges_xxx` parameters from the module `cube_fillet()`.\
Returns a 4 element list

Arguments:
- `r`         - parameter for the edge, radius or width
- `edge_list` - 4-element selection list of the respective edges,
  - is multiplied by `r` if specified
  - as a number, all edges are set to this value
  - otherwise the value is set to `0` = unchamfered edge
- `n` - a different number of elements than the default 4 can be specified here

#### `parameter_edge_radius (edge, r)` [^][contents]
[parameter_edge_radius]: #parameter_edge_radius-edge-r-
Evaluates one edge parameter.

Arguments:
- `r`    - parameter for the edge, radius or width
- `edge`
  - is multiplied by `r` if specified
  - as a number, all edges are set to this value
  - otherwise the value is set to `0` = unchamfered edge

#### `parameter_types (type_list, type, n)` [^][contents]
[parameter_types]: #parameter_types-type_list-type-n-
Evaluates the `type_xxx` parameters from the module `cube_fillet()`.\
Returns a 4 element list.

Arguments:
- `type_list` - 4-element list with the type of each edge
  - as a single type = this value is taken for all elements
  - as a list        = erroneous values are replaced with `type`
- `type` - predefined type of an edge, default = no corner
- `n`    - a different number of elements than the default 4 can be specified here

#### `parameter_type (type, n)` [^][contents]
[parameter_type]: #parameter_type-type_list-type-n-
Evaluates one `type` parameter.

Arguments:
- `type` - predefined type of an edge, default = `0` = no edge
- `n`    - a different number of elements than the default 4 can be specified here


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

