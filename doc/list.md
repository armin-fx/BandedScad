Functions for working with lists
================================

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_edit.scad`\
` `| . . . +--> `banded/list_edit_type.scad`\
` `| . . . +--> `banded/list_edit_item.scad`\
` `| . . . +--> `banded/list_edit_data.scad`\
` `+--> `banded/list_algorithm.scad`\
` `+--> `banded/list_math.scad`\
` `+--> `banded/list_mean.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Editing lists](#editing-lists-)
  - [Repeating options](#repeating-options-)
  - [Different type of data][type]
  - [List functions with specified `type`](#list-functions-with-specified-type-)
  - [Edit list independent from the data][list_edit_item]
  - [Edit list with use of data][list_edit_data]
  - [Pair functions](#pair-functions-)
- [Algorithm on lists](#algorithm-on-lists-)
- [Math on lists](#math-on-lists-)
  - [Integrated in Openscad](#integrated-in-openscad-)
  - [Operand with functions from OpenSCAD](#operand-with-functions-from-openscad-)
  - [Extra functions](#extra-functions-)
- [Calculating mean](#calculating-mean-)
  - [List of mean functions](#list-of-mean-functions-)
  - [Other mean functions](#other-mean-functions-)


Editing lists [^][contents]
---------------------------

### Repeating options [^][contents]

- `list`
  - list on witch is working for
- `position`
  - set the position of an element
  - uses the coding of language python\
    negative position set the position from the last element backwards\
    `[ 0  1  2  3 ]` same as
    `[-4 -3 -2 -1 ]`\
    But it differs in some cases to reach all elements = -1 is the position
    after the last element, -2 is the last element
- `type`
  - Specify how the data from an element in a list will be used.
  - [see entry - Different type of data][type]
- `value` - nothing to say, value used for
- `'range_args'`
  - Contain a set of arguments which defines a range in a list. Choose which you need.
  - Needs only 2 arguments of:
    - `begin` - first element from a list
    - `last`  - last element
    - `count` - count of elements
    - `range` - a list with: `[begin, last]`


### Different type of data [^][contents]
[type]: #different-type-of-data-
Define helper functions for type-dependent access to the content of lists.\
These can used to create one functions with the same access on different data.
The data access can be switched with the argument `type`.

#### Internal type identifier convention [^][contents]

| value        | description
|--------------|-------------
| `0`          | uses the element as value, standard if `type` not set
| `[position]` | uses the element from the position from a list, (position = `type[0]` -> `[ 0 1 2 ... ]`)
| `[-1, fn]`   | call function literal `fn`, or call direct defined function `fn()` if `fn` is set undef

#### Set type identifier of data [^][contents]
This will set the type identifier which will control the data access
in list edit functions.

| function                       | description
|--------------------------------|-------------
| `set_type_direct   ()`         | uses the data direct
| `set_type_list     (position)` | uses the data as list and uses the value at `position`
| `set_type_function (fn)`       | call a function literal `fn` with the data as argument, this return the value.<br /> If fn is `undef`, then it calls a defined extern function `fn()`
| `set_type          (argument)` | generalized function, set the type dependent of the argument

#### Test of type identifier [^][contents]
Return `true` if it fits.

| test function             | description
|---------------------------|-------------
| `is_type_direct   (type)` | is it for data direct use?
| `is_type_list     (type)` | is it for use with data as list?
| `is_type_function (type)` | is it to call a function?
| `is_type_unknown  (type)` | nothing known?

#### Info from type identifier [^][contents]
Get the information from type identifier which are needed to read the data.

| function                   | description
|----------------------------|-------------
| `get_position_type (type)` | get the position in a list as data
| `get_function_type (type)` | get the function literal `fn`

#### Get data with type identifier [^][contents]

| function                  | description
|---------------------------|-------------
| `get_value  (data, type)` | return the value from the `data` element with specified `type`
| `value_list (list, type)` | return a list with only values from specified `type`


### List functions with specified `type` [^][contents]

| function                    | description
|-----------------------------|-------------
| `min_list     (list, type)` | get the minimum value from a list with specified `type`
| `max_list     (list, type)` | get the maximum value from a list with specified `type`
| `min_position (list, type)` | get the position of minimum value in a list
| `max_position (list, type)` | get the position of maximum value in a list


### Edit list independent from the data [^][contents]
[list_edit_item]: #edit-list-independent-from-the-data-

#### `concat_list (list)` [^][contents]
Binds lists in a list together.\
Such as `[ [1,2,3], [4,5] ]` goes to `[1,2,3,4,5]`

#### `reverse_list (list)` [^][contents]
Reverse the sequence of elements in a list

#### `erase_list (list, begin, count)` [^][contents]
Remove an element from a list
- `begin` - Erases from this position
- `count` - Count of elements which will erase, standard = 1 element

#### `insert_list (list, list_insert, position, begin, count)` [^][contents]
Insert `list_insert` into a list
- `position`
  - Insert the list into this position, shift all elements from here at the end.
  - Position differs from coding in python
  - Positive value = insert at the begin of the element
  - Negative value = insert at the end of the element
  - Standard = -1, append at the end
- `begin`
  - Copy the elements from this position in `list_insert`
  - The same like in python
- `count` - Count of elements which will insert from `list_insert`

#### `extract_list (list, 'range_args')` [^][contents]
Extract a sequence from a list
- [`'range_args'`](#repeating-options-) - sets the range to extract

#### `fill_list (count, value)` [^][contents]
Makes a list with `count` elements filled with `value`

#### `refer_list (base, positions)` [^][contents]
Create a list with values of list `base` at positions in order of list `positions`.\
Run `base[ position ]` with every item in `positions`.\
`base <-- positions`

#### `refer_link_list (base, link, positions)` [^][contents]
Create a list with values of list `base` at positions
in list `link` in order of list `positions` to list `link`.\
Run `base[ link[ position ] ]` with every item in `positions`.\
`base <-- link <-- positions`


### Edit list with use of data [^][contents]
[list_edit_data]: #edit-list-with-use-of-data-

#### `sort_list (list, type)` [^][contents]
Sort a list with a stable sort algorithm

#### `merge_list (list1, list2, type)` [^][contents]
Merge 2 sorted lists into one list

#### `binary_search_list (list, value, type)` [^][contents]
Search a value in a sorted list

#### `find_first_list (list, value, index, type)` [^][contents]
[find_first_list]: #find_first_list-list-value-index-type-
Search at a value in a list and returns the position.\
Returns the size of list if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `find_first_once_list (list, value, index, type)` [^][contents]
Search at a value in a list and returns the position.\
Returns the size of list if nothing was found.\
Like [`find_first_list()`][find_first_list],
but return always the position of the first hit.

#### `find_last_list (list, value, index, type)` [^][contents]
[find_last_list]: #find_last_list-list-value-index-type-
Search at a value in a list backwards from the end to first value and returns the position.\
Returns -1 if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `find_last_once_list (list, value, index, type)` [^][contents]
Search at a value in a list backwards from the end to first value and returns the position.\
Returns -1 if nothing was found.\
Like [`find_last_list()`][find_last_list],
but return always the position of the first hit.

#### `count_list (list, value, type, 'range_args')` [^][contents]
Count how often a value is in list
- [`'range_args'`](#repeating-options-) - sets the range in which will count, standard = full list

#### `remove_duplicate_list (list, type)` [^][contents]
Remove every duplicate in a list, so a value exists only once

#### `remove_value_list (list, value, type)` [^][contents]
Remove every entry with a given value in a list

#### `remove_values_list (list, value, type)` [^][contents]
Remove every entry with a given list of values in a list


### Pair functions [^][contents]

- Construction of a pair: `[key, value]`
- `list` - list of several key-value-pair s.a. `[ [key1,value1], [key2,value2], ... ]`

#### `pair (key, value)` [^][contents]
creates a key-value-pair

#### `pair_value (list, key, index)` [^][contents]
get a value from a pair list with given key
- `index`
  - Same key are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `pair_key (list, value, index)` [^][contents]
get a key from a pair list with contained value
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0


Algorithm on lists [^][contents]
--------------------------------

#### `summation_list (list, n, k)` [^][contents]
Summation of a list.\
Add all values in a list from position `k` to `n`.
This function accepts numeric values and vectors in the list.
- `k` - standard = `0`, from first element
- `n` - if undefined, run until the last element

#### `product_list (list, n, k)` [^][contents]
Product of a list.\
Multiply all values in a list from position `k` to `n`
- `k` - standard = `0`, from first element
- `n` - if undefined, run until the last element

#### `unit_summation (list)` [^][contents]
Scale the complete list that the summation of the list equals `1`


Math on lists [^][contents]
---------------------------

Calculates a operation on a list at each position.\
Returns a list with the result.
- `xxx_each (list)` - do the operator xxx at each position
- `xxx_each (list1, list2)` - operator xxx with 2 arguments gets his 2 argument from both lists at the same index

### Integrated in Openscad [^][contents]

#### Addition / Subtraction [^][contents]
`[1,2,3] + [0,4,2]` -> `[1,6,5]`\
`[6,7,8] - [1,2,3]` -> `[5,5,5]`


### Operand with functions from OpenSCAD [^][contents]

| function                   | description
|----------------------------|-------------
| `sqrt_each (list)`         | square root
| `ln_each (list)`           | natural logarithm
| `log_each (list)`          | logarithm with base 10
| `exp_each (list)`          | natural exponent
| `pow_each (list1,list2) `  | power `list1[*] ^ list2[*]`
| `sin_each (list)`          | sine function
| `cos_each (list)`          | cosine
| `tan_each (list)`          | tangent
| `asin_each (list)`         | arcus sine
| `acos_each (list)`         | arcus cosine
| `atan_each (list)`         | arcus tangent
| `atan2_each (list1,list2)` | 2-argument arcus tangent
| `floor_each (list)`        | floor function
| `ceil_each (list)`         | ceiling function
| `round_each (list)`        | rounding function
| `abs_each (list)`          | absolute values

### Extra functions [^][contents]

| function                      | description
|-------------------------------|-------------
| `fn_each (list, fn)`          | call a function literal `fn` with one argument with every entry in a list
| `fn_2_each (list1,list2, fn)` | call a function literal `fn` with two arguments with every entries from the same position in `list1` and `list2`
| `multiply_each (list1,list2)` | multiply each value `list1[*] * list2[*]`
| `divide_each (list1, list2)`  | divide each value `list1[*] / list2[*]`
| `reciprocal_each (list)`      | reciprocate each value `1 / list[*]`
| `sqr_each (list)`             | square each value `list[*] ^ 2`
| `norm_each (list)`            | calculate the norm of a vector in every entry in a list
| `sum_each_next (list)`        | every next value contains the summation of all previous values in list


Calculating mean [^][contents]
------------------------------

- Calculates mean of a list of numeric values
- Optional with weight list
- weight list can to get normalised,
  - option `normalize`
    - `true` - (standard)
      sum of all values of weight list will be scaled to 1


### List of mean functions [^][contents]

#### `mean_arithmetic (list, weight, normalize)` [^][contents]
Calculates the arithmetic mean of a list\
[=> Wikipedia - Arithmetic mean](https://en.wikipedia.org/wiki/Arithmetic_mean)

#### `mean_geometric(list, weight, normalize)` [^][contents]
Calculates the geometic mean of a list\
[=> Wikipedia - Geometric mean](https://en.wikipedia.org/wiki/Geometric_mean)

#### `mean_harmonic(list, weight, normalize)` [^][contents]
Calculates the harmonic mean of a list\
[=> Wikipedia - Harmonic mean](https://en.wikipedia.org/wiki/Harmonic_mean)

#### `root_mean_square(list, weight, normalize)` [^][contents]
Calculates the root mean square of a list\
[=> Wikipedia - Root mean square](https://en.wikipedia.org/wiki/Root_mean_square)

#### `mean_cubic(list, weight, normalize)` [^][contents]
Calculates the cubic mean of a list\
[=> Wikipedia - Cubic mean](https://en.wikipedia.org/wiki/Cubic_mean)

#### `mean_generalized(list, weight, normalize)` [^][contents]
Calculates the generalized mean (or power mean, or Hölder mean) of a list\
[=> Wikipedia - Generalized mean](https://en.wikipedia.org/wiki/Generalized_mean)


### Other mean functions [^][contents]

#### `median (list)` [^][contents]
Calculates the median of a list\
[=> Wikipedia - Median](https://en.wikipedia.org/wiki/Median)

#### `mid_range(list)` [^][contents]
Calculates the mid-range or mid-extreme of a list\
[=> Wikipedia - Mid-range](https://en.wikipedia.org/wiki/Mid-range)

#### `truncate_outlier (list, ratio)` [^][contents]
- Sort a list and remove a given ratio of elements from the ends.
  This is useful for mean functions to truncate outliers from a data list.
- Leaves always at minimum 1 element if odd size of list or
  at minimum 2 element if even size of list.

Options:
- `ratio`
  - standard ratio = 0.5, = removes less or equal 50% from the ends\
    (25% from begin and 25% from end)

Sample:
```OpenSCAD
include <banded.scad>

data  = [1,9,4,2,15];
trunc = truncate_outlier (data, 0.5);
mean  = mean_arithmetic  (trunc);

echo (trunc); // [2,4,6]
echo (mean);  // 5
```


#### `truncate (list, ratio)` [^][contents]
- Removes same elements from the ends like `truncate_outlier()`
  without previous sorting the list.
