Functions for edit lists
========================

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_edit.scad`\
` `| . . . +--> `banded/list_edit_type.scad`\
` `| . . . +--> `banded/list_edit_item.scad`\
` `| . . . +--> `banded/list_edit_data.scad`\
` `| \
` `. . .

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Math on lists ->](list_math.md)


- [Editing lists](#editing-lists-)
  - [Repeating options](#repeating-options-)
    - [Range Arguments][range_args]
  - [Different type of data][type]
    - [Internal type identifier convention](#internal-type-identifier-convention-)
    - [Set type identifier of data](#set-type-identifier-of-data-)
    - [Info from type identifier](#info-from-type-identifier-)
  - [List functions with specified `type`](#list-functions-with-specified-type-)
    - [Get data with type identifier](get-data-with-type-identifier-)
    - [Min or max value](#min-or-max-value-)
  - [Edit list independent from the data](#edit-list-independent-from-the-data-)
    - [`concat_list()`][concat_list]
    - [`reverse_list()`][reverse_list]
    - [`erase_list()`][erase_list]
    - [`insert_list()`][insert_list]
    - [`replace_list()`][replace_list]
    - [`extract_list()`][extract_list]
    - [`refer_list()`][refer_list]
    - [`refer_link_list()`][refer_link_list]
  - [Edit list with use of data, depend on type](#edit-list-with-use-of-data-depend-on-type-)
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

[type]:           #different-type-of-data-


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

#### Range arguments [^][contents]
[range_args]: #range-arguments-
Contain a set of arguments which defines a range in a list.
Choose which you need.

Needs only 2 arguments of:
- `begin` - first element from a list
- `last`  - last element
- `count` - count of elements

or:
- `range` - a list with: `[begin, last]`


Different type of data [^][contents]
------------------------------------

Define helper functions for type-dependent access to the content of lists.\
These can used to create one functions with the same access on different data.
The data access can be switched with the argument `type`.


### Internal type identifier convention [^][contents]

| value        | description
|--------------|-------------
| `0`          | Uses the entry as value = direct access to the value, standard if `type` not set.
| `[position]` | Considers the entry as list and uses the element from the position in this list.
| `[-1, fn]`   | Call function literal `fn` with the entry as argument, or call direct defined function `fn()` if `fn` is set undef.


### Set type identifier of data [^][contents]
This will set the type identifier which will control the data access
in list edit functions.

| function                       | description
|--------------------------------|-------------
| `set_type_direct   ()`         | uses the data direct
| `set_type_list     (position)` | uses the data as list and uses the value at `position`
| `set_type_function (fn)`       | call a function literal `fn` with the data as argument, this return the value.<br /> If fn is `undef`, then it calls a defined extern function `fn()`
| `set_type          (argument)` | generalized function, set the type dependent of the argument


### Info from type identifier [^][contents]

Get the information from type identifier which are needed to read the data.

| function                   | description
|----------------------------|-------------
| `get_position_type (type)` | get the position in a list as data
| `get_function_type (type)` | get the function literal `fn`

Test the type identifier.
Return `true` if it fits.

| test function             | description
|---------------------------|-------------
| `is_type_direct   (type)` | is it for data direct use?
| `is_type_list     (type)` | is it for use with data as list?
| `is_type_function (type)` | is it to call a function?
| `is_type_unknown  (type)` | nothing known?


List functions with specified `type` [^][contents]
--------------------------------------------------

### Get data with type identifier [^][contents]

| function                  | description
|---------------------------|-------------
| `get_value  (data, type)` | return the value from the `data` element with specified `type`
| `value_list (list, type)` | return a list with only values from specified `type`

### Min or max value [^][contents]

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
- [`'range_args'`][range_args] - sets the range to extract

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


Edit list with use of data, depend on type [^][contents]
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
- [`'range_args'`][range_args] - sets the range in which will count, standard = full list

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
  - same key are skipped `index` times
  - default = get first hit, `index` = 0

#### `pair_key (list, value, index)` [^][contents]
get a key from a pair list with contained value
- `index`
  - same values are skipped `index` times
  - default = get first hit, `index` = 0

