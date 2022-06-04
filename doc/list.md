Functions for edit lists
========================

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_edit.scad`\
` `| . . . +--> `banded/list_edit_type.scad`\
` `| . . . +--> `banded/list_edit_item.scad`\
` `| . . . +--> `banded/list_edit_data.scad`\
` `| . . . +--> `banded/list_edit_predicate.scad`\
` `| . . . +--> `banded/list_edit_test.scad`\
` `| . . . +--> `banded/list_edit_pair.scad`\
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
    - [`reverse()`][reverse]
    - [`rotate_list()`][rotate_list]
    - [`rotate_copy()`][rotate_copy]
    - [`remove()`][remove]
    - [`insert()`][insert]
    - [`replace()`][replace]
    - [`extract()`][extract]
    - [`refer_list()`][refer_list]
    - [`refer_link_list()`][refer_link_list]
  - [Edit list with use of data, depend on type](#edit-list-with-use-of-data-depend-on-type-)
    - [`sort()`][sort]
    - [`merge()`][merge]
    - [`binary_search()`][binary_search]
    - [`find_first()`][find_first]
    - [`find_first_once()`][find_first_once]
    - [`find_last()`][find_last]
    - [`find_last_once()`][find_last_once]
    - [`count()`][count]
    - [`remove_duplicate()`][remove_duplicate]
    - [`remove_value()`][remove_value]
    - [`remove_all_values()`][remove_all_values]
    - [`replace_value()`][replace_value]
    - [`replace_all_values()`][replace_all_values]
  - [Edit list, use function literal on data](#edit-list-use-function-literal-on-data-)
    - [`for_each()`][for_each]
    - [`find_first_if()`][find_first_if]
    - [`find_first_once_if()`][find_first_once_if]
    - [`find_last_if()`][find_last_if]
    - [`find_last_once_if()`][find_last_once_if]
    - [`remove_if()`][remove_if]
    - [`replace_if()`][replace_if]
  - [Test entries of lists](#test-entries-of-lists-)
    - [`all_of()`][all_of]
    - [`none_of()`][none_of]
    - [`any_of()`][any_of]
  - [Pair functions](#pair-functions-)
    - [`pair()`][pair]
    - [`pair_value()`][pair_value]
    - [`pair_key()`][pair_key]

[type]:           #different-type-of-data-


Editing lists [^][contents]
===========================
Most functions base on the STL from C++

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

#### `reverse (list, 'range_args')` [^][contents]
[reverse]: #reverse-list-range_args-
Reverse a sequence of elements in a list
- [`'range_args'`][range_args]
  - arguments to set the range to reverse
  - default = full range, reverse complete list

___Specialized function with full range of the list:___
- `reverse_full (list)`

#### `rotate_list (list, middle, begin, last)` [^][contents]
[rotate_list]: #rotate_list-list-middle-begin-last-
Rotates the order of the elements in the range `[begin,last]`,
in such a way that the element pointed by `middle` becomes the new first element.

#### `rotate_copy (list, middle, begin, last)` [^][contents]
[rotate_copy]: #rotate_list-list-middle-begin-last-
Copies the elements in the range `[begin,last]` to the range beginning at result,
but rotating the order of the elements in such a way
that the element pointed by `middle` becomes the first element in the resulting range.

#### `remove (list, begin, count)` [^][contents]
[remove]: #remove-list-begin-count-
Remove elements from a list
- `begin`
  - Erases from this position
  - The same coding like in python
- `count`
  - Count of elements which will removed,
  - default = 1 element

#### `insert (list, list_insert, position, begin_insert, count_insert)` [^][contents]
[insert]: #insert-list-list_insert-position-begin_insert-count_insert-
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

#### `replace (list, list_insert, begin, count, begin_insert, count_insert)` [^][contents]
[replace]: #replace-list-list_insert-begin-count-begin_insert-count_insert-
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

#### `extract (list, 'range_args')` [^][contents]
[extract]: #extract-list-range_args-
Extract a sequence from a list
- [`'range_args'`][range_args] - arguments to set the range to extract

#### `fill (count, value)` [^][contents]
[fill]: #fill-count-value-
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
--------------------------------------------------------

#### `sort (list, type)` [^][contents]
[sort]: #sort-list-type-
Sort a list with a stable sort algorithm

#### `merge (list1, list2, type)` [^][contents]
[merge]: #merge-list1-list2-type-
Merge 2 sorted lists into one list

#### `binary_search (list, value, type)` [^][contents]
[binary_search]: #binary_search-list-value-type-
Search a value in a sorted list

#### `find_first (list, value, index, type, 'range_args')` [^][contents]
[find_first]: #find_first-list-value-index-type-range_args-
Search at a value in a list and returns the position.\
Returns the position after the last element in the defined range if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list

#### `find_first_once (list, value, type, 'range_args')` [^][contents]
[find_first_once]: #find_first_once-list-value-type-range_args-
Search at a value in a list and returns the position.\
Returns the position after the last element in the defined range if nothing was found.\
Like [`find_first()`][find_first],
but return always the position of the first hit.

#### `find_last (list, value, index, type, 'range_args')` [^][contents]
[find_last]: #find_last-list-value-index-type-range_args-
Search at a value in a list backwards from the end to first value and returns the position.\
Returns the position before the first element in the defined range if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list

#### `find_last_once (list, value, type, 'range_args')` [^][contents]
[find_last_once]: #find_last_once-list-value-type-range_args-
Search at a value in a list backwards from the end to first value and returns the position.\
Returns the position before the first element in the defined range if nothing was found.\
Like [`find_last()`][find_last],
but return always the position of the first hit.

#### `count (list, value, type, 'range_args')` [^][contents]
[count]: #count-list-value-type-range_args-
Count how often a value is in list
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list

#### `remove_duplicate (list, type)` [^][contents]
[remove_duplicate]: #remove_duplicate-list-type-
Remove every duplicate in a list, so a value exists only once

#### `remove_value (list, value, type)` [^][contents]
[remove_value]: #remove_value-list-value-type-
Remove every entry with a given value in a list

#### `remove_all_values (list, value_list, type)` [^][contents]
[remove_all_values]: #remove_all_values-list-value_list-type-
Remove every entry with a given list of values in a list
- `value_list` - a list with values to remove

#### `replace_value (list, value, new, type)` [^][contents]
[replace_value]: #replace_value-list-value-new-type-
Replace every entry with a given value in a list to a new value

#### `replace_all_values (list, value_list, new, type)` [^][contents]
[replace_all_values]: #replace_all_values-list-value_list-new-type-
Replace every entry with a given list of values in a list to a new value
- `value_list` - a list with values to replace with value `new`


Edit list, use function literal on data [^][contents]
-----------------------------------------------------

#### `for_each (list, f, type, 'range_args')` [^][contents]
[for_each]: #for_each-list-f-type-range_args-
Run function `f()` on each item in the list.\
Return the list of results.
- [`'range_args'`][range_args] - arguments to set the range of list, standard = full list

#### `find_first_if (list, f, index, type, 'range_args')` [^][contents]
[find_first_if]: #find_first_if-list-f-index-type-range_args-
Run function `f()` at the entries in a list and returns the position which this function returns `true`.\
Returns the position after the last element in the defined range if nothing was found.
- `f`
  - function literal with one argument
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list

#### `find_first_once_if (list, f, type, 'range_args')` [^][contents]
[find_first_once_if]: #find_first_once_if-list-f-type-range_args-
Run function `f()` at the entries in a list and
returns the position which this function returns `true`.\
Returns the position after the last element in the defined range if nothing was found.\
Like [`find_first_if()`][find_first_if],
but return always the position of the first hit.

#### `find_last_if (list, f, index, type, 'range_args')` [^][contents]
[find_last_if]: #find_last_if-list-f-index-type-range_args-
Run function `f()` at the entries backwards in a list and
returns the position which this function returns `true`.\
Returns the position before the first element in the defined range if nothing was found.
- `f`
  - function literal with one argument
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list

#### `find_last_once_if (list, f, type, 'range_args')` [^][contents]
[find_last_once_if]: #find_last_once_if-list-f-type-range_args-
Run function `f()` at the entries backwards in a list and
returns the position which this function returns `true`.\
Returns the position before the first element in the defined range if nothing was found.\
Like [`find_last_if()`][find_last_if],
but return always the position of the first hit.

#### `count_if (list, f, type, 'range_args')` [^][contents]
[count]: #count-list-value-type-range_args-
Count how often the function `f()` hits `true` on an entry in a list
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list
- `f`
  - function literal with one argument

#### `remove_if (list, f, type)` [^][contents]
[remove_if]: #remove_if-list-f-type-
Run function `f()` at the entries in a list and
remove every entry which this function returns `true`.
- `f`
  - function literal with one argument

#### `replace_if (list, f, new, type)` [^][contents]
[replace_if]: #replace_if-list-f-new-type-
Run function `f()` at the entries in a list and
replace every entry which this function returns `true` to a new value.
- `f`
  - function literal with one argument


Test entries of lists [^][contents]
-----------------------------------

#### `all_of (list, f, type, 'range_args')` [^][contents]
[all_of]: #all_of-list-f-type-range_args-
Returns `true` if `f()` returns `true` for all the elements in the range
or if the range is empty, and `false` otherwise.
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### `none_of (list, f, type, 'range_args')` [^][contents]
[none_of]: #none_of-list-f-type-range_args-
Returns `true` if `f()` returns `false` for all the elements in the range
or if the range is empty, and `false` otherwise.
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### `any_of (list, f, type, 'range_args')` [^][contents]
[any_of]: #any_of-list-f-type-range_args-
Returns `true` if `f()` returns `true` for any elements in the range
or if the range is empty, and `false` otherwise.
- `f`
  - function literal with one argument
  - returns `true` or `false`


Pair functions [^][contents]
----------------------------

- Construction of a pair: `[key, value]`
- `list` - list of several key-value-pair s.a. `[ [key1,value1], [key2,value2], ... ]`

#### `pair (key, value)` [^][contents]
[pair]: #pair-key-value-
creates a key-value-pair

#### `pair_value (list, key, index)` [^][contents]
[pair_value]: #pair_value-list-key-index-
get a value from a pair list with given key
- `index`
  - same key are skipped `index` times
  - default = get first hit, `index` = 0

#### `pair_key (list, value, index)` [^][contents]
[pair_key]: #pair_key-list-key-index-
get a key from a pair list with contained value
- `index`
  - same values are skipped `index` times
  - default = get first hit, `index` = 0

