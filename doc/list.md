Functions for working with lists
================================

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_edit.scad`\
` `| . . . +--> `banded/list_edit_type.scad`\
` `| . . . +--> `banded/list_edit_item.scad`\
` `| . . . +--> `banded/list_edit_data.scad`\
` `| \
` `+--> `banded/list_algorithm.scad`\
` `+--> `banded/list_math.scad`\
` `+--> `banded/list_mean.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Calculating mean ->][mean]

- [Editing lists][edit]
  - [Repeating options](#repeating-options-)
  - [Different type of data][type]
  - [List functions with specified `type`](#list-functions-with-specified-type-)
  - [Edit list independent from the data][list_edit_item]
    - [`concat_list()`][concat_list]
    - [`reverse_list()`][reverse_list]
    - [`erase_list()`][erase_list]
    - [`insert_list()`][insert_list]
    - [`replace_list()`][replace_list]
    - [`extract_list()`][extract_list]
    - [`refer_list()`][refer_list]
    - [`refer_link_list()`][refer_link_list]
  - [Edit list with use of data][list_edit_data]
    - [`sort_list()`][sort_list]
    - [`merge_list()`][merge_list]
    - [`binary_search_list()`][binary_search_list]
    - [`find_first_list()`][find_first_list]
    - [`find_first_once_list()`][find_first_once_list]
    - [`find_last_list()`][find_last_list]
    - [`find_last_once_list()`][find_last_once_list]
    - [`count_list()`][count_list]
    - [`remove_duplicate_list()`][remove_duplicate_list]
    - [`remove_value_list()`][remove_value_list]
    - [`remove_values_list()`][remove_values_list]
    - [`replace_value_list()`][replace_value_list]
    - [`replace_values_list()`][replace_values_list]
  - [Pair functions](#pair-functions-)
- [Algorithm on lists](algorithm)
  - [`summation_list()`][summation_list]
  - [`product_list()`][product_list]
  - [`unit_summation()`][unit_summation]
- [Math on lists][math]
  - [Integrated in Openscad](#integrated-in-openscad-)
  - [Operand with functions from OpenSCAD](#operand-with-functions-from-openscad-)
  - [Extra functions](#extra-functions-)

[mean]:      mean.md
[edit]:      #editing-lists-
[algorithm]: #algorithm-on-lists-
[math]:      #math-on-lists-

[type]:           #different-type-of-data-
[list_edit_item]: #edit-list-independent-from-the-data-
[list_edit_data]: #edit-list-with-use-of-data-


Editing lists [^][contents]
===========================

### Repeating options [^][contents]

- `list`
  - list on which is working for
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


Different type of data [^][contents]
------------------------------------

Define helper functions for type-dependent access to the content of lists.\
These can used to create one functions with the same access on different data.
The data access can be switched with the argument `type`.

### Internal type identifier convention [^][contents]

| value        | description
|--------------|-------------
| `0`          | uses the element as value, standard if `type` not set
| `[position]` | uses the element from the position from a list, (position = `type[0]` -> `[ 0 1 2 ... ]`)
| `[-1, fn]`   | call function literal `fn`, or call direct defined function `fn()` if `fn` is set undef

### Set type identifier of data [^][contents]
This will set the type identifier which will control the data access
in list edit functions.

| function                       | description
|--------------------------------|-------------
| `set_type_direct   ()`         | uses the data direct
| `set_type_list     (position)` | uses the data as list and uses the value at `position`
| `set_type_function (fn)`       | call a function literal `fn` with the data as argument, this return the value.<br /> If fn is `undef`, then it calls a defined extern function `fn()`
| `set_type          (argument)` | generalized function, set the type dependent of the argument

### Test of type identifier [^][contents]
Return `true` if it fits.

| test function             | description
|---------------------------|-------------
| `is_type_direct   (type)` | is it for data direct use?
| `is_type_list     (type)` | is it for use with data as list?
| `is_type_function (type)` | is it to call a function?
| `is_type_unknown  (type)` | nothing known?

### Info from type identifier [^][contents]
Get the information from type identifier which are needed to read the data.

| function                   | description
|----------------------------|-------------
| `get_position_type (type)` | get the position in a list as data
| `get_function_type (type)` | get the function literal `fn`

### Get data with type identifier [^][contents]

| function                  | description
|---------------------------|-------------
| `get_value  (data, type)` | return the value from the `data` element with specified `type`
| `value_list (list, type)` | return a list with only values from specified `type`


List functions with specified `type` [^][contents]
--------------------------------------------------

| function                    | description
|-----------------------------|-------------
| `min_list     (list, type)` | get the minimum value from a list with specified `type`
| `max_list     (list, type)` | get the maximum value from a list with specified `type`
| `min_position (list, type)` | get the position of minimum value in a list
| `max_position (list, type)` | get the position of maximum value in a list


Edit list independent from the data [^][contents]
-------------------------------------------------

#### `concat_list (list)` [^][contents]
[concat_list]: #concat_list-list-
Binds lists in a list together.\
Such as `[ [1,2,3], [4,5] ]` goes to `[1,2,3,4,5]`

#### `reverse_list (list)` [^][contents]
[reverse_list]: #reverse_list-list-
Reverse the sequence of elements in a list

#### `erase_list (list, begin, count)` [^][contents]
[erase_list]: #erase_list-list-begin-count-
Remove elements from a list
- `begin`
  - Erases from this position
  - The same coding like in python
- `count`
  - Count of elements which will erase,
  - default = 1 element

#### `insert_list (list, list_insert, position, begin_insert, count_insert)` [^][contents]
[insert_list]: #insert_list-list-list_insert-position-begin_insert-count_insert-
Insert `list_insert` into a list
- `position`
  - Insert the list `list_insert` into this position,
    shift all elements from here at the end.
  - Position differs from coding in python
  - Positive value = insert at the begin of the element
  - Negative value = insert at the end of the element
  - Standard = -1, append at the end
- `begin_insert`
  - Copy the elements from this position in `list_insert`
  - The same coding like in python
  - default = from first element in `list_insert`
- `count_insert`
  - Count of elements which will insert from `list_insert`
  - default = all elements until last element

#### `replace_list (list, list_insert, begin, count, begin_insert, count_insert)` [^][contents]
[replace_list]: #replace_list-list-list_insert-begin-count-begin_insert-count_insert-
Replace elements in a list with `list_insert` or part of it
- `begin`
  - Insert the list `list_insert` into this position of `list`,
    shift all remain elements from here at the end.
  - Position differs from coding in python
  - Positive value = insert at the begin of the element
  - Negative value = insert at the end of the element
  - Standard = `-1`, append at the end
- `count`
  - Remove this count of elements from `begin` in `list`
  - default = `0`, remove no element, only insert the list
- `begin_insert`
  - Copy the elements from this position in `list_insert`
  - The same coding like in python
  - default = from first element in `list_insert`
- `count_insert`
  - Count of elements which will insert from `list_insert`
  - default = all elements until last element

#### `extract_list (list, 'range_args')` [^][contents]
[extract_list]: #extract_list-list-range_args-
Extract a sequence from a list
- [`'range_args'`](#repeating-options-) - sets the range to extract

#### `fill_list (count, value)` [^][contents]
[fill_list]: #fill_list-count-value-
Makes a list with `count` elements filled with `value`

#### `refer_list (base, positions)` [^][contents]
[refer_list]: #refer_list-base-positions-
Create a list with values of list `base` at positions in order of list `positions`.\
Run `base[ position ]` with every item in `positions`.\
`base <-- positions`

#### `refer_link_list (base, link, positions)` [^][contents]
[refer_link_list]: #refer_link_list-base-link-positions-
Create a list with values of list `base` at positions
in list `link` in order of list `positions` to list `link`.\
Run `base[ link[ position ] ]` with every item in `positions`.\
`base <-- link <-- positions`


Edit list with use of data [^][contents]
--------------------------------------------

#### `sort_list (list, type)` [^][contents]
[sort_list]: #sort_list-list-type-
Sort a list with a stable sort algorithm

#### `merge_list (list1, list2, type)` [^][contents]
[merge_list]: #merge_list-list1-list2-type-
Merge 2 sorted lists into one list

#### `binary_search_list (list, value, type)` [^][contents]
[binary_search_list]: #binary_search_list-list-value-type-
Search a value in a sorted list

#### `find_first_list (list, value, index, type)` [^][contents]
[find_first_list]: #find_first_list-list-value-index-type-
Search at a value in a list and returns the position.\
Returns the size of list if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `find_first_once_list (list, value, index, type)` [^][contents]
[find_first_once_list]: #find_first_once_list-list-value-index-type-
Search at a value in a list and returns the position.\
Returns the size of list if nothing was found.\
Like [`find_first_list()`][find_first_list],
but return always the position of the first hit.

#### `find_last_list (list, value, index, type)` [^][contents]
[find_last_list]: #find_last_list-list-value-index-type-
Search at a value in a list backwards from the end to first value and returns the position.\
Returns `-1` if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `find_last_once_list (list, value, index, type)` [^][contents]
[find_last_once_list]: #find_last_once_list-list-value-index-type-
Search at a value in a list backwards from the end to first value and returns the position.\
Returns `-1` if nothing was found.\
Like [`find_last_list()`][find_last_list],
but return always the position of the first hit.

#### `count_list (list, value, type, 'range_args')` [^][contents]
[count_list]: #count_list-list-value-type-range_args-
Count how often a value is in list
- [`'range_args'`](#repeating-options-) - sets the range in which will count, standard = full list

#### `remove_duplicate_list (list, type)` [^][contents]
[remove_duplicate_list]: #remove_duplicate_list-list-type-
Remove every duplicate in a list, so a value exists only once

#### `remove_value_list (list, value, type)` [^][contents]
[remove_value_list]: #remove_value_list-list-value-type-
Remove every entry with a given value in a list

#### `remove_values_list (list, value_list, type)` [^][contents]
[remove_values_list]: #remove_values_list-list-value_list-type-
Remove every entry with a given list of values in a list
- `value_list` - a list with values to remove

#### `replace_value_list (list, value, new, type)` [^][contents]
[replace_value_list]: #replace_value_list-list-value-new-type-
Replace every entry with a given value in a list to a new value

#### `replace_values_list (list, value_list, new, type)` [^][contents]
[replace_values_list]: #replace_values_list-list-value_list-new-type-
Replace every entry with a given list of values in a list to a new value
- `value_list` - a list with values to replace with value `new`


Pair functions [^][contents]
--------------------------------

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
================================

#### `summation_list (list, n, k)` [^][contents]
[summation_list]: #summation_list-list-n-k-
Summation of a list.\
Add all values in a list from position `k` to `n`.
This function accepts numeric values and vectors in the list.
- `k` - standard = `0`, from first element
- `n` - if undefined, run until the last element

#### `product_list (list, n, k)` [^][contents]
[product_list]: #product_list-list-n-k-
Product of a list.\
Multiply all values in a list from position `k` to `n`
- `k` - standard = `0`, from first element
- `n` - if undefined, run until the last element

#### `unit_summation (list)` [^][contents]
[unit_summation]: #unit_summation-list-
Scale the complete list that the summation of the list equals `1`


Math on lists [^][contents]
===========================

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

