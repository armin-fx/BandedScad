Helper functions
================

### defined in file
`banded/helper.scad`  
` `|  
` `+--> `banded/helper_native.scad`  
` `+--> `banded/helper_arguments.scad`  
` `+--> `banded/helper_recondition.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Native helper functions](#native-helper-functions-)
  - [Test functions](#test-functions-)
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
    - [`get_position()`, `get_index()`][get_position]
    - [`get_position_safe()`, `get_index_safe()`][get_position_safe]
    - [`get_position_insert()`, `get_index_insert()`][get_position_insert]
    - [`get_position_insert_safe()`, `get_index_insert_safe()`][get_position_insert_safe]
    - [`last_value()`][last_value]
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
- [Configure arguments](#configure-arguments-)
  - [`configure_angle()`][configure_angle]
  - [`configure_edges()`][configure_edges]
  - [`configure_types()`][configure_types]
  - [`configure_corner()`][configure_corner]
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
  - [`parameter_slices_circle()`][parameter_slices_circle]
  - [`parameter_mirror_vector_2d()`][parameter_mirror_vector_2d]
  - [`parameter_mirror_vector_3d()`][parameter_mirror_vector_3d]
  - [`parameter_edges_radius()`][parameter_edges_radius]
  - [`parameter_edge_radius()`][parameter_edge_radius]
  - [`parameter_types()`][parameter_types]
  - [`parameter_type()`][parameter_type]

[range_args]: list.md#range-arguments-
[special_x]:  extend.md#special-variables-


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

#### is_list_depth [^][contents]
[is_list_depth]: #is_list_depth-
Tests a variable to see if it contains a list with a specified nesting depth.

_Arguments:_
```OpenSCAD
is_list_depth (value, depth)
```
- `depth` - depth of nested lists
  - `1` tests `value` for a simple non-nested list, default
  - if set `0`, `value` is tested to make sure it's not undef and not a list

#### is_list_depth_num [^][contents]
[is_list_depth_num]: #is_list_depth_num-
Tests a variable to see if it contains a list with a specified nesting depth,
and the last list contains numeric values.

_Arguments:_
```OpenSCAD
is_list_depth_num (value, depth)
```
- `depth` - depth of nested lists
  - `1` tests `value` for a simple non-nested list, default
  - if set `0`, `value` is tested to make sure it's not undef and not a list

#### get_list_depth [^][contents]
[get_list_depth]: #get_list_depth-
Returns the nesting depth of a list.

_Arguments:_
```OpenSCAD
get_list_depth (list)
```


### Get data [^][contents]

#### extract_axis [^][contents]
[extract_axis]: #extract_axis-
Extracts a fixed position on every entry in a list.  
Returns a list with this values.
```
extract_axis (list=[[x,y,z], [1,2,3], [11,12,13]], axis=1)  =>  [y,2,12]
                       ^        ^          ^                     ^ ^  ^
                     0 1 2    0 1 2     0  1  2
```

_Arguments:_
```OpenSCAD
extract_axis (list, axis)
```
- `axis` - position of element (list or string) on entry in the list

#### diff_list [^][contents]
[diff_list]: #diff_list-
Returns the largest distance of each value within a list.  
Subtract the smallest value in list from the biggest value in list.
```
diff_list ([3, 2, 4, 7])  ==> 7 - 2 = 5
               ^     ^
```

_Arguments:_
```OpenSCAD
diff_list (list)
```

#### diff_axis_list [^][contents]
[diff_axis_list]: #diff_axis_list-
Returns the largest distance of each axis in a vector list.  
```
diff_axis_list ([ [1,3],[6,9],[4,2] ])
  6 - 1 = 5        ^     ^
  9 - 2 = 7                ^     ^
  ==>  [5,7]
```

_Arguments:_
```OpenSCAD
diff_axis_list (list)
```

#### range [^][contents]
[range]: #range-
Converts a range specification to a list.  
`[0:3]  ==>  [0,1,2,3]`

_Arguments:_
```OpenSCAD
range (value)
```


### Get position on lists [^][contents]

#### get_position, get_index [^][contents]
[get_position]: #get_position-get_index-
Returns the real position within a list.  
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

_Arguments:_
```OpenSCAD
get_position (list, position)
get_index    (size, position)
```
Both functions returns the same result, but with different arguments.
- `position` - the position in a list
- `list`     - pass a list directly for calculation
- `size`     - pass the size of a list for calculation

#### get_position_safe, get_index_safe [^][contents]
[get_position_safe]: #get_position_safe-get_index_safe-
Returns the real position within a list.  
Same like [`get_position()`][get_position], but constrain the position to
the first or last element if the value exceed the real size of the list.
Returns `-1` on an empty list.

#### get_position_insert, get_index_insert [^][contents]
[get_position_insert]: #get_position_insert-get_index_insert-
Returns the real position within a list.  
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

_Arguments:_
```OpenSCAD
get_position_insert (list, position)
get_index_insert    (size, position)
```
Both functions returns the same result, but with different arguments.
- `position` - the insertion position in a list
- `list`     - pass a list directly for calculation
- `size`     - pass the size of a list for calculation

#### get_position_insert_safe, get_index_insert_safe [^][contents]
[get_position_insert_safe]: #get_position_insert_safe-get_index_insert_safe-
Returns the real position within a list.  
Same like [`get_position_insert()`][get_position_insert], but constrain the position to
the first or 1 element after the last element if the value exceed the real size of the list.

#### last_value [^][contents]
[last_value]: #last_value-
Return the last element from a list.  
```OpenSCAD
last_value (list, index)
```
- `index` - optional position backwards from the last element position
  - default = 0, last element


### Data consistency [^][contents]

#### is_good_list [^][contents]
[is_good_list]: #is_good_list-
Tests a list if all values in a list are not `undef`.  
Returns `true` on success.

_Arguments:_
```OpenSCAD
is_good_list (list, begin, end)
```
- `begin` - test from this element in the list, default = first element
- `end`   - test until this element in the list, default = last element

_Specialized function with fixed list size:_
- `is_good_1d (list)` - test a list with 1 element
- `is_good_2d (list)` - test a list with 2 elements
- `is_good_3d (list)` - test a list with 3 elements
- `is_good_4d (list)` - test a list with 4 elements

#### is_num_list [^][contents]
[is_num_list]: #is_good_list-
Tests a list if all values in a list has a numeric value.  
Returns `true` on success.

_Arguments:_
```OpenSCAD
is_num_list (list, begin, end)
```
- `begin` - test from this element in the list, default = first element
- `end`   - test until this element in the list, default = last element

_Specialized function with fixed list size:_
- `is_num_1d (list)` - test a list with 1 element
- `is_num_2d (list)` - test a list with 2 elements
- `is_num_3d (list)` - test a list with 3 elements
- `is_num_4d (list)` - test a list with 4 elements


### Get first good value [^][contents]
These functions can be used e.g. if several arguments calculate one
parameter and these argument have a priority order.
So it returns the first argument which matches.

#### get_first_good [^][contents]
[get_first_good]: #get_first_good-
Return the first argument which is not `undef`.  
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.

_Arguments:_
```OpenSCAD
get_first_good (a0, ... , a9)
```

#### get_first_good_list [^][contents]
[get_first_good_list]: #get_first_good_list-
Return the first argument which is not `undef`
and contains a list with a defined lenght
and all elements of this list are not `undef`.  
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.

_Arguments:_
```OpenSCAD
get_first_good_list (size, a0, ... , a9)
```
- `size` - lenght the list must have, greater then `0`

_Specialized function with fixed list size:_
- `get_first_good_1d (a0, ... , a9)` - test lists with 1 element
- `get_first_good_2d (a0, ... , a9)` - test lists with 2 elements
- `get_first_good_3d (a0, ... , a9)` - test lists with 3 elements

#### get_first_num [^][contents]
[get_first_num]: #get_first_num-
Return the first argument which contains a numeric value.  
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.

_Arguments:_
```OpenSCAD
get_first_num (a0, ... , a9)
```

#### get_first_num_list [^][contents]
[get_first_num_list]: #get_first_num_list-
Return the first argument which is not `undef`
and contains a list with a defined lenght
and all elements of this list contains a numeric value.  
Else it returns `undef`.
It tests up to 10 arguments and starts with `a0`.

_Arguments:_
```OpenSCAD
get_first_num_list (size, a0, ... , a9)
```
- `size` - size the list must have, greater then `0`

_Specialized function with fixed list lenght:_
- `get_first_num_1d (a0, ... , a9)` - test lists with 1 element
- `get_first_num_2d (a0, ... , a9)` - test lists with 2 elements
- `get_first_num_3d (a0, ... , a9)` - test lists with 3 elements

#### get_first_good_in_list [^][contents]
[get_first_good_in_list]: #get_first_good_in_list-
Returns the first valid element in the list.  
The first element that satisfies all the conditions is taken.

_Ascents:_
- element is not undef
- element is a list of (at least) size `size` with valid values
- if `size`==`0` the item is a valid value and not a list
- _a valid value:_ any data type except `undef`

_Arguments:_
```OpenSCAD
get_first_good_in_list (list, size, begin)
```
- `list` - list of items
- `size` - element must be a list of this size
  - if set `0`, then the item must be a valid value and not a list
- `begin` - testing starts from this position on list. Default = `0`, complete list

#### get_first_num_in_list [^][contents]
[get_first_num_in_list]: #get_first_num_in_list-
Returns the first valid element in the list.  
The first element that satisfies all the conditions is taken.

_Ascents:_
- element is not undef
- element is a list of (at least) size `size` with valid values
- if `size`==`0` the item is a valid value and not a list
- _a valid value:_ a numeric value

_Arguments:_
```OpenSCAD
get_first_num_in_list (list, size, begin)
```
- `list` - list of items
- `size` - element must be a list of this size
  - if set `0`, then the item must be a valid value and not a list
- `begin` - testing starts from this position on list. Default = `0`, complete list


Configure arguments [^][contents]
---------------------------------

Configure arguments from functions or modules
to expand further control options

#### configure_angle [^][contents]
[configure_angle]: #configure_angle-
Sets the `angle` parameter for a circle.  
Returns a list `[ opening angle, begin angle ]`

_Arguments:_
```OpenSCAD
configure_angle (opening, begin, end, outer)
```
- `opening` - opening angle, central angle
- `outer`   - opposite opening angle, 360° - central angle
- `begin`   - begin angle, angle where the circle starts
- `end`     - end angle

_Ranking of arguments:_
- `opening`, `begin`
- `opening`, `end`
- `outer`, `begin`
- `outer`, `end`
- `begin`, `end`
- fill missing arguments with default `[360, 0]`

#### configure_edges [^][contents]
[configure_edges]: #configure_edges-
Sets the `edges` parameter of the module `cube_fillet()`.

3 groups of edges, each completely encompassing the cuboid:
- bottom, top, around
- left, right, forward
- front, back, sideways

In the 3 groups all edges will be defined 3 times each,
therefore there is a priority, the higher one overrides the lower one.
Individual edges can be set as undefined with `undef`.

Order, those further to the left overwrite those further to the right:
- bottom, top, around, left, right, forward, front, back, sideways

_Arguments:_
```OpenSCAD
configure_edges (bottom,top,around, left,right,forward, front,back,sideways, r, default)
```
- | edge argument | description                                | first edge   | rotation on cube
  |---------------|--------------------------------------------|--------------|------------------
  | `bottom`      | 4 edges around the rectangle on the bottom | front        | left around, seen from above
  | `top`         | 4 edges around the rectangle on the top    | front        | left around, seen from above
  | `around`      | 4 edges vertical from bottom the top       | front left   | left around, seen from above
  | `left`        | 4 edges around the rectangle left side     | bottom left  | left around, seen from the left
  | `right`       | 4 edges around the rectangle right side    | bottom right | left around, seen from the left
  | `forward`     | 4 edges horizontal from left to right      | bottom front | left around, seen from the left
  | `front`       | 4 edges around the rectangle front side    | bottom front | left around, seen from the front
  | `back`        | 4 edges around the rectangle back side     | bottom back  | left around, seen from the front
  | `sideways`    | 4 edges horizontal from front to back      | bottom right | left around, seen from the front
- `r`
  - optional parameter
  - All edges are multiplied by this value if specified.
  - If `r` is set, this value will multiplied with every edge size,
    so you can activate every specific edge with `1` and deactivate with `0`,
    all so activated edges so gets the size `r`.
- `default`
  - value taken for edges that have not been set
  - default = `0`, edge not rounded

_Return:_
- 12 element list:
  - the first 4 elements correspond to:  `bottom` - all 4 edges at the bottom
  - the following 4 elements correspond: `top`    - all 4 edges at the top
  - the last 4 elements correspond to:   `around` - all vertical edges on the side

#### configure_types [^][contents]
[configure_types]: #configure_types-
Sets the `type` parameter of the module `cube_fillet()`.

_Arguments:_
```OpenSCAD
configure_types (bottom,top,around, left,right,forward, front,back,sideways, default)
```
The same like [`configure_edges()`][configure_edges]
(but without parameter `r`)

#### configure_corner [^][contents]
[configure_corner]: #configure_corner-
Sets the `corner` parameter of the module `cube_fillet()`.

3 groups of corner, each completely encompassing the cuboid:
- bottom, top
- left, right
- front, back

In the 3 groups all corner will be defined 3 times each,
therefore there is a priority, the higher one overrides the lower one.
Individual corner can be set as undefined with `undef`.

Order, those further to the left overwrite those further to the right:
- bottom, top, left, right, front, back

_Arguments:_
```OpenSCAD
configure_corner (bottom,top, left,right, front,back, default)
```
- | edge argument | description                                 | first edge   | rotation on cube
  |---------------|---------------------------------------------|--------------|------------------
  | `bottom`      | 4 corner around the rectangle on the bottom | front left   | left around, seen from above
  | `top`         | 4 corner around the rectangle on the top    | front left   | left around, seen from above
  | `left`        | 4 corner around the rectangle left side     | bottom front | left around, seen from the left
  | `right`       | 4 corner around the rectangle right side    | bottom front | left around, seen from the left
  | `front`       | 4 corner around the rectangle front side    | bottom right | left around, seen from the front
  | `back`        | 4 corner around the rectangle back side     | bottom right | left around, seen from the front
- `default`
  - value taken for corner that have not been set
  - default = `0`, corner not rounded

_Return:_
- 8 element list:
  - the first 4 elements correspond to: `bottom` - all 4 corner at the bottom
  - the last  4 elements correspond to: `top`    - all 4 corner at the top


Recondition arguments of functions [^][contents]
------------------------------------------------

Contains functions that evaluate the passed arguments
from modules and functions.

#### repair_matrix [^][contents]
[repair_matrix]: #repair_matrix-
Test an repair matrices for affine transformation.  
Fill missing elements with elements from the unity matrix.

_Arguments:_
```OpenSCAD
repair_matrix (m, d)
```
- `d`
  - dimension of the matrix, d×d matrix
  - if not set, use length of first line from the matrix
    to determine the d×d size of the matrix

#### fill_missing_matrix [^][contents]
[fill_missing_matrix]: #fill_missing_matrix-
Fill missing elements in matrix `m` with elements from matrix `c`.  
The size of the matrix is used from `c`.
An entry in the matrix must be a numeric value.

_Arguments:_
```OpenSCAD
fill_missing_matrix (m, c)
```

#### fill_missing_list [^][contents]
[fill_missing_list]: #fill_missing_list-
Fill missing elements in a list with elements from list `c`.  
An entry in the list must be a numeric value.

_Arguments:_
```OpenSCAD
fill_missing_list (list, c)
```

#### parameter_range [^][contents]
[parameter_range]: #parameter_range-
Test the range of a list in the ['range_args'][range_args].  
Encoding is as in python (e.g. -1 = last element).
Returns the real range `[begin, last]` for a list.
Default is the full range from first to last element in a list.

_Arguments:_
```OpenSCAD
parameter_range (list, begin, last, count, range)
```
- [`'range_args'`][range_args] - a sets of arguments
  - `begin` - first element from a list
  - `last`  - last element
  - `count` - count of elements
  - `range` - a list with: `[begin, last]`

_Priority of the arguments:_
1. `begin`, `last`
2. `begin`, `count`
3. `last`, `count`
4. `range[0]`, `count`
5. `range[1]`, `count`
6. `range`
7. single argument (`begin`, `last`, `count`), remainder to default
8. `[0, -1]` = default, full range


#### parameter_range_safe [^][contents]
[parameter_range_safe]: #parameter_range_safe-
Test the range of a list in the ['range_args'][range_args].  
Encoding as in python (e.g. -1 = last element).
Returns the real range `[begin, last]` for a list.
Default is full range from first to last element in a list.

_Arguments:_
```OpenSCAD
parameter_range_safe (list, begin, last, count, range)
```
Same like [`parameter_range()`][parameter_range], but constrain the position to
the first or last element if the value exceed the real size of the list.

#### parameter_circle_r [^][contents]
[parameter_circle_r]: #parameter_circle_r-
Returns the radius of a circle.

_Arguments:_
```OpenSCAD
parameter_circle_r (r, d, default)
```
- `r` - radius
- `d` - diameter
- `default` - optional, default radius = 1

_Rules as for OpenSCAD's_ `circle()`_:_
- Diameter comes before radius
- without specification: r=`1`

#### parameter_cylinder_r [^][contents]
[parameter_cylinder_r]: #parameter_cylinder_r-
Returns `[radius_bottom, radius_top]` of a cylinder.

_Arguments:_
```OpenSCAD
parameter_cylinder_r (r, r1, r2, d, d1, d2, preset)
```
- `r`  - radius top and bottom
- `r1` - radius below
- `r2` - radius at top
- `d`  - top and bottom diameter
- `d1` - diameter below
- `d2` - diameter at top
- `preset` - optional, use this value if nothing fits

_Rules like OpenSCAD's_ `cylinder()`_:_
- Diameter comes before radius
- special information (`r1`, `r2`) takes precedence over general information (`r`)
- without specification: r=`1`

#### parameter_cylinder_r_basic [^][contents]
[parameter_cylinder_r_basic]: #parameter_cylinder_r_basic-
Returns `[radius_bottom, radius_top]` of a cylinder.  
Same like [`parameter_cylinder_r()`][parameter_cylinder_r]
but without argument diameter.

_Arguments:_
```OpenSCAD
parameter_cylinder_r_basic (r, r1, r2, preset)
```
- `r`  - radius top and bottom
- `r1` - radius below
- `r2` - radius at top
- `preset` - optional, use this value as radius if nothing fits

_Rules like OpenSCAD's_ `cylinder()`_:_
- special information (`r1`, `r2`) takes precedence over general information (`r`)
- without specification: r=`1`

#### parameter_ring_2r [^][contents]
[parameter_ring_2r]: #parameter_ring_2r-
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

_Arguments:_
```OpenSCAD
parameter_ring_2r (r, w, r1, r2, d, d1, d2)
```
- `r`, `d`   - middle radius or middle diameter
- `r1`, `d1` - inner radius or inner diameter
- `r2`, `d2` - outside radius or outside diameter
- `w`        - width of the ring

_Must specify:_
- exactly 2 specifications of `r` or `r1` or `r2` or `w`

_Rules based on OpenSCAD:_
- diameter comes before radius
- without specification: `r1`=`1`, `r2`=`2`

#### parameter_ring_2r_basic [^][contents]
[parameter_ring_2r_basic]: #parameter_ring_2r_basic-
Returns `[inner radius, outer radius]` of a ring.  
Same like [`parameter_ring_2r()`][parameter_ring_2r]
but without argument diameter.

_Arguments:_
```OpenSCAD
parameter_ring_2r_basic (r, w, r1, r2)
```
- `r`  - middle radius
- `r1` - inner radius
- `r2` - outside radius
- `w`  - width of the ring

_Must specify:_
- exactly 2 specifications of `r` or `r1` or `r2` or `w`

_Rules based on OpenSCAD:_
- without specification: `r1`=`1`, `r2`=`2`

#### parameter_funnel_r [^][contents]
[parameter_funnel_r]: #parameter_funnel_r-
Returns `[ri1, ri2, ro1, ro2]` of a funnel.

_Arguments:_
```OpenSCAD
parameter_funnel_r (ri1, ri2, ro1, ro2, w, di1, di2, do1, do2)
```
- `ri1`, `ri2` - inner radius bottom, top
- `ro1`, `ro2` - outer radius bottom, top
- `ri`, `ro`   - inner radius or outer radius for both sides together
- `w`          - width of the wall. Optional
- `di1`, `di2` - inner diameter bottom, top. Optional
- `do1`, `do2` - outer diameter bottom, top. Optional

_Rules:_
- radius comes before diameter
- special values like `ri1` take precedence over general values like `ri`
- missing radius or diameter is taken from
  the wall parameter and the opposite radius or diameter
- missing inner radius is set to `1`,
  missing outer radius is set to `2`

#### parameter_helix_to_rp [^][contents]
[parameter_helix_to_rp]: #parameter_helix_to_rp-
Returns `[rotations, pitch]` of a helix

_Arguments:_
```OpenSCAD
parameter_helix_to_rp (rotations, pitch, height)
```
- rotations - number of rotations
- pitch     - pitch difference per revolution
- height    - height of the helix

_Notice:_
- exactly 2 specifications of `rotations` or `pitch` or `height` are needed
- default = `[1, 0]` - 1 full rotation and no pitch

#### parameter_size_3d [^][contents]
[parameter_size_3d]: #parameter_size_3d-
Converts the `size` argument to a triple `[1,2,3]`.  
Used for e.g. the argument `size` in `cube()`.

_Arguments:_
```OpenSCAD
parameter_size_3d (size)
```
- `size`
  - numeric value: all axis are set to this size
  - 3 element list: size on axis `[ X, Y, Z ]`
  - fill missing values in the list with `0`
  - if not set, returns default value `[1,1,1]`,
    behavior like buildin `cube()` in OpenSCAD
  - e.g.
    - `size=3`       becomes `[3,3,3]`
    - `size=[1,2,3]` remains `[1,2,3]`
    - `size=[2,2]`   becomes `[2,2,0]`

#### parameter_size_2d [^][contents]
[parameter_size_2d]: #parameter_size_2d-
Converts the `size` argument to a duple `[1,2]`.  
Used for e.g. the argument `size` in `square()`.

_Arguments:_
```OpenSCAD
parameter_size_2d (size)
```
- `size`
  - numeric value: all axis are set to this size
  - 2 element list: size on axis `[ X, Y ]`
  - fill missing values in the list with `0`
  - if not set, returns default value `[1,1]`,
    behavior like buildin `square()` in OpenSCAD
  - e.g.
    - `size=3`     becomes `[3,3]`
    - `size=[1,2]` remains `[1,2]`
    - `size=[2]`   becomes `[2,0]`

#### parameter_scale [^][contents]
[parameter_scale]: #parameter_scale-
Evaluate the `scale` argument.

_Arguments:_
```OpenSCAD
parameter_scale (scale, d, preset)
```
- `d`
  - Dimension of the vector `scale`, default = 3
  - Set the scale vector to full `d` dimensions and fill missing values with `1`.
- `scale`
  - A list with scale values for every axis.
  - A numeric value set in `scale` will set for all axis.
  - e.g.
    - `scale=3`       becomes `[3,3]`
    - `scale=[1,2,2]` remains `[1,2,2]`
    - `scale=[2,2]`   becomes `[2,2,1]`, fill missing value with `1`
- `preset`
  - Use this value if scale is not set.
  - A numeric value will set in list for all axis
  - default = 1 for all axis

#### parameter_align [^][contents]
[parameter_align]: #parameter_align-
Evaluate the `align` argument.  
Used to align an object from its center to its axis.

_Arguments:_
```OpenSCAD
parameter_align (align, preset, center)
```
- `center`
  - Centers the object to origin if set `true`
  - `false` is the default behavior, depends on the object
  - Specification of `align` overrides specification of `center`.
- `align`
  - A list with an align value on each respective axis
  - You can set a numeric value, then all axis will set to this align value.
  - Values can be given at the respective axis `-1...0...1`.
    - `1`  = alignment of the object to the positive side of the respective axis.
    - `-1` = alignment of the object to the negative side.
    - `0`  = the object is at the center of the respective axis
  - `[0,0,0]` is like `center=true`, default behavior is `center=false` specified in preset.
- `preset`
  - Specify the default align of the object if `center` or `align` is not set
  - The list size defines the dimension of the object
  - If this parameter is not set a 3 dimensional centered object will set as default

#### parameter_numlist [^][contents]
[parameter_numlist]: #parameter_numlist-
Converts the `value` argument to a list of `dimension` elements.  
If that doesn't work, the default value `preset` is used.

_Arguments:_
```OpenSCAD
parameter_numlist (dimension, value, preset, fill)
```
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

#### parameter_angle [^][contents]
[parameter_angle]: #parameter_angle-
Returns the angle parameter as a list `[opening_angle, start_angle]`

_Arguments:_
```OpenSCAD
parameter_angle (angle, angle_std)
```
- `angle`
  - as a number
    - use as opening angle specification
    - starting angle is set to `0`
  - as a list
    - `[opening_angle, start_angle]`
- `angle_std` - default angle if `angle` is not set (default = `[360, 0]`)

#### parameter_slices_circle [^][contents]
[parameter_slices_circle]: #parameter_slices_circle-
Evaluate the fragments count of a circle (section)

_Arguments:_
```OpenSCAD
parameter_slices_circle (slices, r, angle, piece)
```
- `slices`
   - count of segments, optional
   - without specification it gets the same like module `circle()`
   - with `"x"` includes the [extra special variables][special_x]
     to automatically control the count of segments
   - if an angle is specified, the circle section keeps the count of segments.
     Elsewise with `$fn` the segment count scale down to the circle section,
     the behavior like in `rotate_extrude()` to keep the desired precision.
- `r`     - circle radius, default=`1`
- `angle` - drawed angle in degrees, default=`360`
- `piece`
  - `true`  - like a pie, like `rotate_extrude()` in OpenSCAD, default
  - `false` - connect the ends of the circle,
            - generate an extra edge if count of segments is too small
  - `0`     - curve only, no extra edges if "circle is only a line"

_Specialized function:_
- `parameter_slices_circle_x()`
  - use the [extra special variables][special_x]
    by default if slices is not set

#### parameter_mirror_vector_2d [^][contents]
[parameter_mirror_vector_2d]: #parameter_mirror_vector_2d-
Test 2D vector `v` and may load default for vector in mirror function.

_Arguments:_
```OpenSCAD
parameter_mirror_vector_2d (v, v_std)
```
- `v_std`
  - default vector if `v` not correct,
    default = `[1,0]` like OpenSCAD's default

#### parameter_mirror_vector_3d [^][contents]
[parameter_mirror_vector_3d]: #parameter_mirror_vector_3d-
Test 3D vector `v` and may load default for vector in mirror function.

_Arguments:_
```OpenSCAD
parameter_mirror_vector_3d (v, v_std)
```
- `v_std`
  - default vector if `v` not correct,
    default = `[1,0,0]` like OpenSCAD's default

#### parameter_edges_radius [^][contents]
[parameter_edges_radius]: #parameter_edges_radius-
Evaluates the `edges_xxx` parameters from the module `cube_fillet()`.  
Returns a 4 element list

_Arguments:_
```OpenSCAD
parameter_edges_radius (edge_list, r, n)
```
- `r`
  - parameter for the edge, radius or width
- `edge_list`
  - 4-element selection list of the respective edges,
  - is multiplied by `r` if specified
  - as a number, all edges are set to this value
  - if `r` is set and `edge_list` is undefined, all edges are set to `r`
  - otherwise the value is set to `0` = unchamfered edge
- `n` - a different number of elements than the default 4 can be specified here

#### parameter_edge_radius [^][contents]
[parameter_edge_radius]: #parameter_edge_radius-
Evaluates one edge parameter.  

_Arguments:_
```OpenSCAD
parameter_edge_radius (edge, r)
```
- `r`    - parameter for the edge, radius or width
- `edge`
  - is multiplied by `r` if specified
  - as a number, the edge is set to this value
  - otherwise the value is set to `0` = unchamfered edge

#### parameter_types [^][contents]
[parameter_types]: #parameter_types-
Evaluates the `type_xxx` parameters from the module `cube_fillet()`.  
Returns a 4 element list.

_Arguments:_
```OpenSCAD
parameter_types (type_list, type, n)
```
- `type_list` - 4-element list with the type of each edge
  - as a single type = this value is taken for all elements
  - as a list        = erroneous values are replaced with `type`
- `type` - predefined type of an edge, default = no corner
- `n`    - a different number of elements than the default 4 can be specified here

#### parameter_type [^][contents]
[parameter_type]: #parameter_type-
Evaluates one `type` parameter.  

_Arguments:_
```OpenSCAD
parameter_type (type, n)
```
- `type` - predefined type of an edge, default = `0` = no edge
- `n`    - a different number of elements than the default 4 can be specified here

