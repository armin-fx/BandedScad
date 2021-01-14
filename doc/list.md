Functions for working with lists
================================

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_edit.scad`\
` `+--> `banded/list_algorithm.scad`\
` `+--> `banded/list_math.scad`\
` `+--> `banded/list_mean.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Editing lists](#editing-lists-)
  - [Repeating options](#repeating-options-)
  - [Independent from the data](#edit-list-independent-from-the-data-)
  - [Use data in list](#use-data-in-list-)
  - [List functions with specified `type`](#list-functions-with-specified-type-)
  - [Pair functions](#pair-functions-)
- [Algorithm on lists](#algorithm-on-lists-)
- [Math on lists](#math-on-lists-)
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
  - `0`     - uses the element as value, standard if `type` not set
  - `1...n` - uses the element from the position from a list, (position = `type - 1` -> `[ 1 2 3 ]`)
- `value` - nothing to say, value used for
- `'range_args'`
  - Contain a set of arguments which defines a range in a list. Choose which you need.
  - Needs only 2 arguments of:
    - `begin` - first element from a list
    - `last`  - last element
    - `count` - count of elements
    - `range` - a list with: `[begin, last]`


### Edit list independent from the data [^][contents]

#### `concat_list (list)`
Binds lists in a list together.\
Such as `[ [1,2,3], [4,5] ]` goes to `[1,2,3,4,5]`

#### `reverse_list (list)`
Reverse the sequence of elements in a list

#### `erase_list (list, begin, count)`
Remove an element from a list
- `begin` - Erases from this position
- `count` - Count of elements which will erase, standard = 1 element

#### `insert_list (list, list_insert, position, begin, count)`
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

#### `extract_list (list, 'range_args')`
Extract a sequence from a list
- [`'range_args'`](#repeating-options-) - sets the range to extract

#### `fill_list (count, value)`
Makes a list with `count` elements filled with `value`


### Use data in list [^][contents]

#### `sort_list (list, type)`
Sort a list with a stable sort algorithm

#### `merge_list (list1, list2, type)`
Merge 2 sorted lists into one list

#### `binary_search_list (list, value, type)`
Search a value in a sorted list

#### `find_first_list (list, value, index, type)`
Search at a value in a list and returns the position
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `count_list (list, value, type, 'range_args')`
Count how often a value is in list
- [`'range_args'`](#repeating-options-) - sets the range in which will count, standard = full list


### List functions with specified `type` [^][contents]

#### `get_value (data, type)`
return the value from the `data` element with specified `type`

#### `value_list (list, type)`
return a list with only values from specified `type`

#### `min_list (list, type)`
get the minimum value from a list at specified `type`

#### `max_list (list, type)`
get the maximum value from a list at specified `type`


### Pair functions [^][contents]

- Construction of a pair: `[key, value]`
- `list` - list of several key-value-pair s.a. `[ [key1,value1], [key2,value2], ... ]`

#### `pair (key, value)`
creates a key-value-pair

#### `pair_value (list, key, index)`
get a value from a pair list with given key
- `index`
  - Same key are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `pair_key (list, value, index)`
get a key from a pair list with contained value
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0


Algorithm on lists [^][contents]
--------------------------------

#### `summation_list (list, n, k)`
Summation of a list.\
Add all values in a list from position `k` to `n`
- `k` - standard = `0`, from first element
- `n` - if undefined, run until the last element

#### `product_list (list, n, k)`
Product of a list.\
Multiply all values in a list from position `k` to `n`
- `k` - standard = `0`, from first element
- `n` - if undefined, run until the last element

#### `unit_summation (list)`
Scale the complete list that the summation of the list equals `1`


Math on lists [^][contents]
---------------------------

Calculates a operation on a list at each position.\
Returns a list with the result.
- `xxx_each (list)` - do the operator xxx at each position
- `xxx_each (list1, list2)` - operator xxx with 2 arguments gets his 2 argument from both lists at the same index

### Integrated in Openscad [^][contents]

#### Addition / Subtraction
`[1,2,3] + [0,4,2]` -> `[1,6,5]`\
`[6,7,8] - [1,2,3]` -> `[5,5,5]`


### Operand with functions from OpenScad [^][contents]
- `sqrt_each (list)` - square root
- `ln_each (list)`   - natural logarithm
- `log_each (list)`  - logarithm with base 10
- `exp_each (list)`  - natural exponent
- `pow_each (list1,list2)`  - power `list1[*] ^ list2[*]`
- `sin_each (list)`  - sine function
- `cos_each (list)`  - cosine
- `tan_each (list)`  - tangent
- `asin_each (list)` - arcus sine
- `acos_each (list)` - arcus cosine
- `atan_each (list)` - arcus tangent
- `atan2_each (list1,list2)` - 2-argument arcus tangent
- `floor_each (list)` - floor function
- `ceil_each (list)`  - ceiling function
- `round_each (list)` - rounding function
- `abs_each (list)`   - absolute values

### Extra functions [^][contents]
- `multiply_each (list1,list2)` - multiply each value `list1[*] * list2[*]`
- `divide_each (list1, list2)`  - divide each value `list1[*] / list2[*]`
- `reciprocal_each (list)`      - reciprocate each value `1 / list[*]`
- `sqr_each (list)`             - square each value `list[*] ^ 2`


Calculating mean [^][contents]
------------------------------

- Calculates mean of a list of numeric values
- Optional with weight list
- weight list can to get normalised,
  - option `normalize`, standard = true
  - sum of all values of weight list will be scaled to 1


### List of mean functions [^][contents]

#### `mean_arithmetic (list, weight, normalize)`
Calculates the arithmetic mean of a list\
[=> Wikipedia - Arithmetic mean](https://en.wikipedia.org/wiki/Arithmetic_mean)

#### `mean_geometric(list, weight, normalize)`
Calculates the geometic mean of a list\
[=> Wikipedia - Geometric mean](https://en.wikipedia.org/wiki/Geometric_mean)

#### `mean_harmonic(list, weight, normalize)`
Calculates the harmonic mean of a list\
[=> Wikipedia - Harmonic mean](https://en.wikipedia.org/wiki/Harmonic_mean)

#### `root_mean_square(list, weight, normalize)`
Calculates the root mean square of a list\
[=> Wikipedia - Root mean square](https://en.wikipedia.org/wiki/Root_mean_square)

#### `mean_cubic(list, weight, normalize)`
Calculates the cubic mean of a list\
[=> Wikipedia - Cubic mean](https://en.wikipedia.org/wiki/Cubic_mean)

#### `mean_generalized(list, weight, normalize)`
Calculates the generalized mean (or power mean, or Hölder mean) of a list\
[=> Wikipedia - Generalized mean](https://en.wikipedia.org/wiki/Generalized_mean)


### Other mean functions [^][contents]

#### `median (list)`
Calculates the median of a list\
[=> Wikipedia - Median](https://en.wikipedia.org/wiki/Median)

#### `mid_range(list)`
Calculates the mid-range or mid-extreme of a list\
[=> Wikipedia - Mid-range](https://en.wikipedia.org/wiki/Mid-range)

#### `truncate_outlier (list, ratio)`
- Sort a list and remove a given ratio of elements from the ends.
  This is useful for mean functions to truncate outliers from a data list.
- Leaves always at minimum 1 element if odd size of list or
  at minimum 2 element if even size of list.

Options:
- `ratio`
  - standard ratio = 0.5, = removes less or equal 50% from the ends\
    (25% from begin and 25% from end)

Sample:
```OpenScad
include <banded.scad>

data  = [1,9,4,2,15];
trunc = truncate_outlier (data, 0.5);
mean  = mean_arithmetic  (trunc);

echo (trunc); // [2,4,6]
echo (mean);  // 5
```


#### `truncate (list, ratio)`
- Removes same elements from the ends like `truncate_outlier()`
  without previous sorting the list.
