Functions for edit lists
========================

### defined in file
`banded/list.scad`  
` `|  
` `+--> `banded/list_edit.scad`  
` `| . . . +--> `banded/list_edit_type.scad`  
` `| . . . +--> `banded/list_edit_item.scad`  
` `| . . . +--> `banded/list_edit_data.scad`  
` `| . . . +--> `banded/list_edit_predicate.scad`  
` `| . . . +--> `banded/list_edit_test.scad`  
` `| . . . +--> `banded/list_edit_pair.scad`  
` `|  
` `. . .  

[<-- file overview](file_overview.md)  
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
      - `type_direct()`
      - `type_list()`
      - `type_function()`
      - `type()`
    - [Info from type identifier](#info-from-type-identifier-)
      - `position_type()`
      - `function_type()`
    - [Get data with type identifier](get-data-with-type-identifier-)
      - `value()`
      - `value_list()`
      - `is_type_direct()`
      - `is_type_list()`
      - `is_type_function()`
      - `is_type_unknown()`
  - [Edit list independent from the data](#edit-list-independent-from-the-data-)
    - [`concat_list()`][concat_list]
    - [`reverse()`][reverse]
    - [`reverse_all()`][reverse_all]
    - [`rotate_list()`][rotate_list]
    - [`rotate_copy()`][rotate_copy]
    - [`remove()`][remove]
    - [`insert()`][insert]
    - [`replace()`][replace]
    - [`extract()`][extract]
    - [`fill()`][fill]
    - [`select()`][select]
    - [`select_all()`][select_all]
    - [`select_link()`][select_link]
    - [`unselect()`][unselect]
    - [`index()`][index]
    - [`index_all()`][index_all]
    - [`remove_unselected()`][remove_unselected]
    - [`compress_selected()`][compress_selected]
  - [Edit list with use of data, depend on type](#edit-list-with-use-of-data-depend-on-type-)
    - [`sort()`][sort]
    - [`merge()`][merge]
    - [`remove_duplicate()`][remove_duplicate]
    - [`remove_value()`][remove_value]
    - [`remove_all_values()`][remove_all_values]
    - [`remove_sequence()`][remove_sequence]
    - [`replace_value()`][replace_value]
    - [`replace_all_values()`][replace_all_values]
    - [`replace_sequence()`][replace_sequence]
    - [`keep_value()`][keep_value]
    - [`keep_all_values()`][keep_all_values]
    - [`unique()`][unique]
    - [`keep_unique()`][keep_unique]
    - [`strip()`][strip]
    - [`extract_value()`][extract_value]
    - [`split()`][split]
  - [Get data from list](#get-data-from-list-)
    - [Minimum or maximum value](#minimum-or-maximum-value-)
      - `min_value()`,    `max_value()`, `bound_value()`
      - `min_entry()`,    `max_entry()`
      - `min_position()`, `max_position()`
    - [`count()`][count]
    - [`find_first()`, `find()`][find_first]
    - [`find_first_once()`][find_first_once]
    - [`find_first_of()`][find_first_of]
    - [`find_first_of_once()`][find_first_of_once]
    - [`find_last()`][find_last]
    - [`find_last_once()`][find_last_once]
    - [`find_last_of()`][find_last_of]
    - [`find_last_of_once()`][find_last_of_once]
    - [`search_sequence()`][search_sequence]
    - [`sequence_positions()`][sequence_positions]
    - [`mismatch()`][mismatch]
    - [`mismatch_list()`][mismatch_list]
    - [`adjacent_find()`][adjacent_find]
    - [`binary_search()`][binary_search]
    - [`sorted_until()`][sorted_until]
    - [`sorted_until_list()`][sorted_until_list]
    - [`lexicographical_compare()`][lexicographical_compare]
  - [Edit list, use function literal on data](#edit-list-use-function-literal-on-data-)
    - [`remove_if()`][remove_if]
    - [`replace_if()`][replace_if]
    - [`partition()`][partition]
    - [`for_each()`][for_each]
    - [`count_if`][count_if]
    - [`find_first_if()`][find_first_if]
    - [`find_first_once_if()`][find_first_once_if]
    - [`find_last_if()`][find_last_if]
    - [`find_last_once_if()`][find_last_once_if]
  - [Test entries of lists](#test-entries-of-lists-)
    - [`all_of()`][all_of]
    - [`none_of()`][none_of]
    - [`any_of()`][any_of]
    - [`equal()`][equal]
    - [`includes()`][includes]
    - [`is_sorted()`][is_sorted]
    - [`is_partitioned()`][is_partitioned]
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
  - uses the coding of language python  
    negative position set the position from the last element backwards  
    `[ 0  1  2  3 ]` same as
    `[-4 -3 -2 -1 ]`  
    But it differs in some cases to reach all elements = -1 is the position
    after the last element, -2 is the last element.
- `type`
  - Specify how the data from an element in a list will be used.
  - [see entry - Different type of data][type]
- `value` - nothing to say, value used for

#### Range arguments: [^][contents]
[range_args]: #range-arguments-
Contain a set of arguments which defines a range in a list.  
Choose which you need.
Default is the full range from first to last element in a list.

Needs only 2 arguments of:
- `begin` - first element from a list
- `last`  - last element
- `count` - count of elements

or:
- `range` - a list with: `[begin, last]`

Encoding is as in python:
- positive values `0, 1 ... n`
  - normal positions in list
- negative values `-1, -2 ... -n`
  - positions backwards from last element
  - `first`, `last`: `-1` = last element
  - `count`: `-1` = full size of list

Priority of the arguments:
- `begin`, `last`
- `begin`, `count`
- `last`, `count`
- `range[0]`, `count`
- `range[1]`, `count`
- `range`
- `[0, -1]` = default


Different type of data [^][contents]
------------------------------------

Define helper functions for type-dependent access to the content of lists.  
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

| function                   | description
|----------------------------|-------------
| `type_direct   ()`         | uses the data direct
| `type_list     (position)` | uses the data as list and uses the value at `position`
| `type_function (fn)`       | call a function literal `fn` with the data as argument, this return the value.<br /> If fn is `undef`, then it calls a defined extern function `fn()`
| `type          (argument)` | generalized function, set the type dependent of the argument


### Info from type identifier [^][contents]

Get the information from type identifier which are needed to read the data.

| function               | description
|------------------------|-------------
| `position_type (type)` | get the position in a list as data
| `function_type (type)` | get the function literal `fn`

Test the type identifier.
Return `true` if it fits.

| test function             | description
|---------------------------|-------------
| `is_type_direct   (type)` | is it for data direct use?
| `is_type_list     (type)` | is it for use with data as list?
| `is_type_function (type)` | is it to call a function?
| `is_type_unknown  (type)` | nothing known?


### Get data with type identifier [^][contents]

| function                  | description
|---------------------------|-------------
| `value      (data, type)` | return the value from the `data` element with specified `type`
| `value_list (list, type)` | return a list with only values from specified `type`


Edit list independent from the data [^][contents]
-------------------------------------------------

#### concat_list [^][contents]
[concat_list]: #concat_list-
Binds lists in a list together.  
Such as `[ [1,2,3], [4,5] ]` goes to `[1,2,3,4,5]`

_Arguments:_
```OpenSCAD
concat_list (list)
```

#### reverse [^][contents]
[reverse]: #reverse-
Reverse a sequence of elements in a list.

_Arguments:_
```OpenSCAD
reverse (list, 'range_args')
```
- [`'range_args'`][range_args]
  - arguments to set the range to reverse
  - default = full range, reverse complete list

_Specialized function with full range of the list:_
- `reverse_full (list)`

#### reverse_all [^][contents]
[reverse_all]: #reverse_all-list-
Reverse a sequence of elements in every list stored in a list.  
Such as `[ [1,2,3], [4,5] ]` goes to `[ [3,2,1], [5,4] ]`

_Arguments:_
```OpenSCAD
reverse_all (list)
```

#### rotate_list [^][contents]
[rotate_list]: #rotate_list-
Rotates the order of the elements in the range `[begin,last]`,
in such a way that the element pointed by `middle` becomes the new first element.
Keep the elements outer the range `[begin,last]` as it is.

_Arguments:_
```OpenSCAD
rotate_list (list, middle, begin, last)
```

#### rotate_copy [^][contents]
[rotate_copy]: #rotate_copy-
Copies the elements from the range `[begin,last]` and
rotates the order of these elements in such a way
that the element pointed by `middle` becomes the first element.

_Arguments:_
```OpenSCAD
rotate_copy (list, middle, begin, last)
```

#### `remove (list, begin, count)` [^][contents]
[remove]: #remove-list-begin-count-
Remove elements from a list

_Arguments:_
```OpenSCAD
```
- `begin`
  - Erases from this position
  - The same coding like in python
- `count`
  - Count of elements which will removed,
  - default = 1 element

#### insert [^][contents]
[insert]: #insert-
Insert a second list into a list at specific position.

_Arguments:_
```OpenSCAD
insert (list, list_insert, position, begin_insert, count_insert)
```
- `list_insert`
  - second list which will inserted into the list
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

#### replace [^][contents]
[replace]: #replace-
Replace elements in a list with `list_insert` or part of it.

_Arguments:_
```OpenSCAD
replace (list, list_insert, begin, count, begin_insert, count_insert)
```
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

#### extract [^][contents]
[extract]: #extract-
Extract a sequence from a list.

_Arguments:_
```OpenSCAD
extract (list, 'range_args')
```
- [`'range_args'`][range_args] - arguments to set the range to extract
  - default = extract full list

#### fill [^][contents]
[fill]: #fill-
Makes a list with `count` elements filled with `value`.

_Arguments:_
```OpenSCAD
fill (count, value)
```

#### select [^][contents]
[select]: #select-base-index-
Create a list with values of list `base` at positions in order of list `index`.  
Run `base[ position ]` with every item in `index` and create a new list.  
`base <-- index`

_Arguments:_
```OpenSCAD
select (base, index)
```

#### select_all [^][contents]
[select_all]: #select_all-
Replace all entries in all lists stored in `indices` with data entries from list `base`.  
Every entry select a value at this position in list `base`.
`base <-- [ indices[0], indices[1], ... ]`

_Arguments:_
```OpenSCAD
select_all (base, indices)
```

#### select_link [^][contents]
[select_link]: #select_link-
Create a list with values of list `base` at positions
in list `link` in order of list `index` to list `link`.  
Run `base[ link[ position ] ]` with every item in `index`.  
`base <-- link <-- index`

_Arguments:_
```OpenSCAD
select_link (base, link, index)
```

#### unselect [^][contents]
[unselect]: #unselect-
Remove all `index` from list `base`.  
Keep all positions in the list which are not listed in `index`.

_Arguments:_
```OpenSCAD
unselect (base, index)
```

_Example:_
```OpenSCAD
include <banded.scad>

// pos:  0   1   2   3   4
list = ["a","b","c","d","e"];
sel  = [0,1,1,2];

echo( select   (list, sel) ); // ECHO: ["a", "b", "b", "c"]
echo( unselect (list, sel) ); // ECHO: ["d", "e"]
```

#### index [^][contents]
[index]: #index-
Returns a list of positions on the data in `list` in ascending order.  
Returns `[ data list, [index] ]`

_Arguments:_
```OpenSCAD
index (list)
```

#### index_all [^][contents]
[index_all]: #index_all-
Appends all data to a list and stores lists with the positions on them.  
Returns `[ data list, [index1, index2, ... ] ]`

_Arguments:_
```OpenSCAD
index_all (list)
```
- `list` - contains lists of data, e.g. point lists as traces

#### remove_unselected [^][contents]
[remove_unselected]: #remove_unselected-
Removes all data items that are not indexed and rewrites all indices.  
Returns `[ data, [index1, index2, ... ] ]`

_Arguments:_
```OpenSCAD
remove_unselected (list, indices)
```
- `indices` - a list that contains lists with positions to select data at this index in `list`

#### compress_selected [^][contents]
[compress_selected]: #compress_selected-
Summarizes all data elements that occur more than once, rewrites all indices.  
Returns `[ data, [index1, index2, ... ] ]`

_Arguments:_
```OpenSCAD
compress_selected (list, indices, comparable)
```
- `indices` - a list that contains lists with positions to select data at this index in `list`
- `comparable` - optional setting how the data can be compared
  - `true`  - default, data entries comparable with `<`
  - `false` - mixed data entries only comparable with `==`, use `str (data)` instead


Edit list with use of data, depend on type [^][contents]
--------------------------------------------------------

#### sort [^][contents]
[sort]: #sort-
Sort a list with a stable sort algorithm.

_Arguments:_
```OpenSCAD
sort (list, type, f)
```
- `f`
  - optional, function literal to compare the values with two arguments
  - returns a numeric value to compare with `0`,
    `f(a,b)` must return a value
    - `< 0` if `a < b`
    - `0`   if `a == b`
    - `> 0` if `a > b`

#### merge [^][contents]
[merge]: #merge-
Merge 2 sorted lists into one list.

_Arguments:_
```OpenSCAD
merge (list1, list2, type, f)
```
- `f`
  - optional, function literal to compare the values with two arguments
  - returns a numeric value to compare with `0`,
    `f(a,b)` must return a value
    - `< 0` if `a < b`
    - `0`   if `a == b`
    - `> 0` if `a > b`

#### remove_duplicate [^][contents]
[remove_duplicate]: #remove_duplicate-
Remove every duplicate in a list, so a value exists only once.

_Arguments:_
```OpenSCAD
remove_duplicate (list, type)
```

#### remove_value [^][contents]
[remove_value]: #remove_value-
Remove every entry with a given value in a list.

_Arguments:_
```OpenSCAD
remove_value (list, value, type)
```

#### remove_all_values [^][contents]
[remove_all_values]: #remove_all_values-
Remove every entry from a list, where a value matches in a list of values.

_Arguments:_
```OpenSCAD
remove_all_values (list, value_list, type)
```
- `value_list` - a list with values to remove

#### remove_sequence [^][contents]
[remove_sequence]: #remove_sequence-
Remove all presence of a data sequence in the list.

_Arguments:_
```OpenSCAD
remove_sequence (list, sequence, type, 'range_args')
```
- `list`     - list with data elements
- `sequence` - sequence with data of given type
- [`'range_args'`][range_args] - arguments to set the range of operation in the list, default = full list

#### replace_value [^][contents]
[replace_value]: #replace_value-
Replace every entry with a given value in a list to a new value.

_Arguments:_
```OpenSCAD
replace_value (list, value, new, type)
```

#### replace_all_values [^][contents]
[replace_all_values]: #replace_all_values-
Replace every entry with a given list of values in a list to a new value.

_Arguments:_
```OpenSCAD
replace_all_values (list, value_list, new, type)
```
- `value_list` - a list with values to replace with value `new`

#### replace_sequence [^][contents]
[replace_sequence]: #replace_sequence-
Replace all presence of a data sequence in the list with another sequence.

_Arguments:_
```OpenSCAD
replace_sequence (list, sequence, new, type, 'range_args')
```
- `list`     - list with data elements
- `sequence` - sequence with data of given type
- `new`      - the new data sequence
- [`'range_args'`][range_args] - arguments to set the range of operation in the list, default = full list

#### keep_value [^][contents]
[keep_value]: #keep_value-
Keep every entry with a given value in a list,
remove all other entries.

_Arguments:_
```OpenSCAD
keep_value (list, value, type)
```

#### keep_all_values [^][contents]
[keep_all_values]: #keep_all_values-
Keep only listed entries, remove all other entries.

_Arguments:_
```OpenSCAD
keep_all_values (list, value_list, type)
```
- `value_list` - a list with values

#### unique [^][contents]
[unique]: #unique-
Remove consecutive duplicates in a list.  
Removes all but the first element from every consecutive group of equivalent elements.
The elements are compared using operator `==` or with function `f` if given.

_Arguments:_
```OpenSCAD
unique (list, type, f)
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### keep_unique [^][contents]
[keep_unique]: #keep_unique-
Remove duplicates in a list.  
Removes all group of equivalent elements, keep only single elements.
The elements are compared using operator `==` or with function `f` if given.

_Arguments:_
```OpenSCAD
keep_unique (list, type, f)
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### strip [^][contents]
[strip]: #strip-
Remove all elements where matching with a list of values
from the beginning and the end of a list.

_Arguments:_
```OpenSCAD
strip (list, value_list, side, type)
```
- `value_list` - a list with values to remove
- `side` - defines the side of the list where the elements were removed
  -  `0` - default, both sides
  - `-1` - left side = beginning of the list
  -  `1` - right side = end of the list

_Specialized Functions:_
- `lstrip (list, value_list, type)`
  - Remove elements only from the begin of the list (left side)
- `rstrip (list, value_list, type)`
  - Remove elements only from the end of the list (right side)

#### extract_value [^][contents]
[extract_value]: #extract_value-
Extract a sequence from a list.  
Return the data of the given type.

_Arguments:_
```OpenSCAD
extract_value (list, type, 'range_args')
```
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### split [^][contents]
[split]: #split-
Splits a list at occurrences of a given value.  
Creates a list with these sublists.
The determined value will be removed.

_Arguments:_
```OpenSCAD
split (list, value, type)
```


Get data from list [^][contents]
--------------------------------

#### Minimum or maximum value: [^][contents]

| function                    | description
|-----------------------------|-------------
| `min_value    (list, type)` | get the minimum value from a list with specified `type`
| `max_value    (list, type)` | get the maximum value from a list with specified `type`
| `bound_value  (list, type)` | get the maximum and maximum value from a list with specified `type`. Returns a list `[min, max]`
| `min_entry    (list, type)` | get the element from a list which has the minimum value with specified `type`
| `max_entry    (list, type)` | get the element from a list which has the maximum value with specified `type`
| `min_position (list, type)` | get the position of minimum value in a list
| `max_position (list, type)` | get the position of maximum value in a list

#### count [^][contents]
[count]: #count-
Count how often a value is in list.

_Arguments:_
```OpenSCAD
count (list, value, type, 'range_args')
```
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list

#### find_first [^][contents]
[find_first]: #find_first-
Search at a value in a list and returns the position.  
Returns the position after the last element in the defined range if nothing was found.

_Arguments:_
```OpenSCAD
find_first (list, value, index, type, 'range_args')
```
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

Function `find()` will be redirected to `find_first()`.

#### find_first_once [^][contents]
[find_first_once]: #find_first_once-
Search at a value in a list and returns the position.  
Returns the position after the last element in the defined range if nothing was found.  
Like [`find_first()`][find_first],
but return always the position of the first hit.

_Arguments:_
```OpenSCAD
find_first_once (list, value, type, 'range_args')
```

#### find_first_of [^][contents]
[find_first_of]: #find_first_of-
Search a list of values in a list and returns the position.  
Returns the position after the last element in the defined range if nothing was found.

_Arguments:_
```OpenSCAD
find_first_of (list, value_list, index, type, 'range_args')
```
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### find_first_of_once [^][contents]
[find_first_of_once]: #find_first_of_once-
Search a list of values in a list and returns the position. 
Returns the position after the last element in the defined range if nothing was found. 
Like [`find_first_of()`][find_first_of],
but return always the position of the first hit.

_Arguments:_
```OpenSCAD
find_first_of_once (list, value_list, type, 'range_args')
```

#### find_last [^][contents]
[find_last]: #find_last-
Search at a value in a list backwards from the end to first value and returns the position.  
Returns the position before the first element in the defined range if nothing was found.

_Arguments:_
```OpenSCAD
find_last (list, value, index, type, 'range_args')
```
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### find_last_once [^][contents]
[find_last_once]: #find_last_once-
Search at a value in a list backwards from the end to first value and returns the position.  
Returns the position before the first element in the defined range if nothing was found.  
Like [`find_last()`][find_last],
but return always the position of the first hit.

_Arguments:_
```OpenSCAD
find_last_once (list, value, type, 'range_args')
```

#### find_last_of [^][contents]
[find_last_of]: #find_last_of-
Search a list of values in a list backwards from the end to first value and returns the position.  
Returns the position before the first element in the defined range if nothing was found.

_Arguments:_
```OpenSCAD
find_last_of (list, value_list, index, type, 'range_args')
```
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### find_last_of_once [^][contents]
[find_last_of_once]: #find_last_of_once-
Search a list of values in a list backwards from the end to first value and returns the position.  
Returns the position before the first element in the defined range if nothing was found.  
Like [`find_last_of()`][find_last_of],
but return always the position of the first hit.

_Arguments:_
```OpenSCAD
find_last_of_once (list, value_list, type, 'range_args')
```

#### search_sequence [^][contents]
[search_sequence]: #search_sequence-
Search a sequence of a given type in the list and return the position of the first presence.  
Returns the position after the last element if nothing was found.

_Arguments:_
```OpenSCAD
search_sequence (list, sequence, type, 'range_args')
```
- `sequence` - sequence with data of given type
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### sequence_positions [^][contents]
[sequence_positions]: #sequence_positions-
Search a sequence of a given type in the list and return all positions of the presence in a list.  
Returns an empty list if nothing was found.

_Arguments:_
```OpenSCAD
sequence_positions (list, sequence, type, 'range_args')
```
- `sequence` - sequence with data of given type
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### mismatch [^][contents]
[mismatch]: #mismatch-
Compares the elements in `list1` and `list2`,
and returns the position of the first element of both sequences that does not match.  
The elements are compared using operator ==  or with function `f` if given.
Returns the position that does not match of both lists as a list like `[position list1, position list2]`

_Arguments:_
```OpenSCAD
mismatch (list1, list2, begin1, begin2, count, type, f)
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### mismatch_list [^][contents]
[mismatch_list]: #mismatch_list-
Compares the elements in `list1` and `list2`,
and returns the positions of all elements of both sequences as list that does not match.  
The elements are compared using operator `==`  or with function `f` if given.
Returns a list of the positions that the sequences does not match of both lists
as a list like `[position list1, position list2]`.

_Arguments:_
```OpenSCAD
mismatch_list (list1, list2, begin1, begin2, count, type, f)
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### adjacent_find [^][contents]
[adjacent_find]: #adjacent_find-
Find equal adjacent elements in a list.  
Searches the list for the first occurrence of two consecutive elements that match,
and returns the position of the first of these two elements,
or one element after the last element if no such pair is found.
The elements are compared using operator `==`  or with function `f` if given.

_Arguments:_
```OpenSCAD
adjacent_find (list, type, 'range_args', f)
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### binary_search [^][contents]
[binary_search]: #binary_search-
Search a value in a sorted list.  
Returns the position of the match,
elsewise returns a negative value if not found.

_Arguments:_
```OpenSCAD
binary_search (list, value, type, f)
```
- `f`
  - optional
  - function literal with two arguments
  - Compare 2 values and return a numeric value that is compared with `0`.
    The return value must be smaller or greater then `0`, or equal `0` if the value is hit.

#### sorted_until [^][contents]
[sorted_until]: #sorted_until-
Returns the first position where the list is not sorted into ascending order.  
The elements are compared using operator `<` or with function `f` if given.

_Arguments:_
```OpenSCAD
sorted_until (list, f, type, 'range_args')
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### sorted_until_list [^][contents]
[sorted_until_list]: #sorted_until_list-
Returns all position as a list at where the list is not sorted into ascending order.  
The elements are compared using operator `<` or with function `f` if given.
Returns an empty list if the list is sorted.
The first position 0 is not included in the returned list.

_Arguments:_
```OpenSCAD
sorted_until_list (list, f, type, 'range_args')
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### lexicographical_compare [^][contents]
[lexicographical_compare]: #lexicographical_compare-
Lexicographical less-than comparison of two lists.  
A lexicographical comparison is the kind of comparison generally
used to sort words alphabetically in dictionaries.
It involves comparing sequentially the elements that have the same position in
both ranges against each other until one element is not equivalent to the other.
The result of comparing these first non-matching elements
is the result of the lexicographical comparison.
If both sequences compare equal until one of them ends,
the shorter sequence is lexicographically less than the longer one.

The elements are compared using operator `<` or with function `f` if given.

_Arguments:_
```OpenSCAD
lexicographical_compare (list1, list2, f, type)
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

_Example:_
```OpenSCAD
include <banded.scad>

comp = function(a,b) a < b;

a = [1,2,3,4];
b = [1,2,3,5];
c = [1,2,3];
echo( lexicographical_compare (a, b, f=comp) ); // ECHO: true
echo( lexicographical_compare (a, b) );         // ECHO: true
echo( lexicographical_compare (a, c, f=comp) ); // ECHO: false
echo( lexicographical_compare (a, c) );         // ECHO: false
```


Edit list, use function literal on data [^][contents]
-----------------------------------------------------

#### remove_if [^][contents]
[remove_if]: #remove_if-list-f-type-
Run function `f()` at the entries in a list and
remove every entry which this function returns `true`.

_Arguments:_
```OpenSCAD
remove_if (list, f, type)
```
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### replace_if [^][contents]
[replace_if]: #replace_if-
Run function `f()` at the entries in a list and
replace every entry which this function returns `true` to a new value.

_Arguments:_
```OpenSCAD
replace_if (list, f, new, type)
```
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### partition [^][contents]
[partition]: #partition-list-
Split a list in two parts.  
Returns 2 lists: `[ [first part], [second part] ]`.  
The _first_ part contains all elements which function `f()` returns `true`.
The _second_ part contains all elements which function `f()` returns `false`.

_Arguments:_
```OpenSCAD
partition (list, f, type, 'range_args')
```
- `f`
  - function literal with one argument
  - returns `true` or `false`
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

_Example:_
```OpenSCAD
include <banded.scad>

pred = function(n) is_odd(n);

a = [1,2,3,4,5,6,7];
echo( partition (a, f=pred) ); // ECHO: [[1, 3, 5, 7], [2, 4, 6]]

```

#### for_each [^][contents]
[for_each]: #for_each-
Run function `f()` on each item in the list.  
Return the list of results.

_Arguments:_
```OpenSCAD
for_each (list, f, type, 'range_args')
```
- [`'range_args'`][range_args] - arguments to set the range of the list, standard = full list

#### count_if [^][contents]
[count_if]: #count_if-
Count how often the function `f()` hits `true` on an entry in a list.

_Arguments:_
```OpenSCAD
count_if (list, f, type, 'range_args')
```
- [`'range_args'`][range_args] - arguments to set the range in which will count, default = full list
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### find_first_if [^][contents]
[find_first_if]: #find_first_if-
Run function `f()` at the entries in a list and
returns the position which this function returns `true`.  
Returns the position after the last element in the defined range if nothing was found.

_Arguments:_
```OpenSCAD
find_first_if (list, f, index, type, 'range_args')
```
- `f`
  - function literal with one argument
  - returns `true` or `false`
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### find_first_once_if [^][contents]
[find_first_once_if]: #find_first_once_if-
Run function `f()` at the entries in a list and
returns the position which this function returns `true`.  
Returns the position after the last element in the defined range if nothing was found.  
Like [`find_first_if()`][find_first_if],
but return always the position of the first hit.

_Arguments:_
```OpenSCAD
find_first_once_if (list, f, type, 'range_args')
```

#### find_last_if [^][contents]
[find_last_if]: #find_last_if-
Run function `f()` at the entries backwards in a list and
returns the position which this function returns `true`.  
Returns the position before the first element in the defined range if nothing was found.

_Arguments:_
```OpenSCAD
find_last_if (list, f, index, type, 'range_args')
```
- `f`
  - function literal with one argument
  - returns `true` or `false`
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

#### find_last_once_if [^][contents]
[find_last_once_if]: #find_last_once_if-
Run function `f()` at the entries backwards in a list and
returns the position which this function returns `true`.  
Returns the position before the first element in the defined range if nothing was found.  
Like [`find_last_if()`][find_last_if],
but return always the position of the first hit.

_Arguments:_
```OpenSCAD
find_last_once_if (list, f, type, 'range_args')
```

Test entries of lists [^][contents]
-----------------------------------

#### all_of [^][contents]
[all_of]: #all_of-
Returns `true` if `f()` returns `true` for all the elements in the range
or if the range is empty, and `false` otherwise.

_Arguments:_
```OpenSCAD
all_of (list, f, type, 'range_args')
```
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### none_of [^][contents]
[none_of]: #none_of-
Returns `true` if `f()` returns `false` for all the elements in the range
or if the range is empty, and `false` otherwise.

_Arguments:_
```OpenSCAD
none_of (list, f, type, 'range_args')
```
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### any_of [^][contents]
[any_of]: #any_of-
Returns `true` if `f()` returns `true` for any elements in the range
or if the range is empty, and `false` otherwise.

_Arguments:_
```OpenSCAD
any_of (list, f, type, 'range_args')
```
- `f`
  - function literal with one argument
  - returns `true` or `false`

#### equal [^][contents]
[equal]: #equal-
Tests the data of two lists for equality and returns `true` on success.  
Compares the data directly or with function `f` if given.

_Arguments:_
```OpenSCAD
equal (list1, list2, f, type, begin1, begin2, count)
```
- `list1`, `list2` - lists to compare
- `f`
  - function literal with two arguments
  - returns `true` or `false`
  - if function is not specified, the data will compared directly (with given type of data)
- `begin1`, `begin2`
  - begin position from respective list
  - default = 0 = from first element
- `count`
  - count of elements to test of both lists
  - default = full list

#### includes [^][contents]
[includes]: #includes-
Returns `true` if the sorted list `list1` contains all the elements in the sorted list `list2`.  
The elements are compared using operator `<` or with function `f` if given.

_Arguments:_
```OpenSCAD
includes (list1, list2, f, type, 'range_args1', 'range_args2')
```
- `list1`, `list2` - sorted lists to compare
- `f`
  - function literal with two arguments
  - returns `true` or `false`
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list
  - 'range_args1' = `begin1`, `last1`, `count1`, `range1` for `list1`
  - 'range_args2' = `begin2`, `last2`, `count2`, `range2` for `list2`

_Example:_
```OpenSCAD
include <banded.scad>

a = sort( [1,2,3,4,5,6] );
b = sort( [2,5] );
c = sort( [2,9] );

echo( includes (a, b) ); // ECHO: true
echo( includes (a, c) ); // ECHO: false
```

#### is_sorted [^][contents]
[is_sorted]: #is_sorted-
Check whether list is sorted.  
Returns `true` if the list is sorted into ascending order.
The elements are compared using operator `<` or with function `f` if given.

_Arguments:_
```OpenSCAD
is_sorted (list, f, type, 'range_args')
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`

#### is_partitioned [^][contents]
[is_partitioned]: #is_partitioned-
Returns `true` if all the elements in the list are split in two parts.  
Where the function `f()` must return `true` on each element of the first part
and `f()` returns `false` on each element of the second part.
If the range is empty, the function returns `true`.

_Arguments:_
```OpenSCAD
is_partitioned (list, f, type, 'range_args')
```
- `f`
  - function literal with two arguments
  - returns `true` or `false`
- [`'range_args'`][range_args] - arguments to set the range of the list, default = full list

_Example:_
```OpenSCAD
include <banded.scad>

pred = function(n) is_odd(n);

a = [1,2,3,4,5,6,7];
b = concat_list( partition (a, f=pred) );

echo( b );                          // ECHO: [1, 3, 5, 7, 2, 4, 6]
echo( is_partitioned (b, f=pred) ); // ECHO: true
echo( is_partitioned (a, f=pred) ); // ECHO: false
```


Pair functions [^][contents]
----------------------------

- Construction of a pair: `[key, value]`
- `list` - list of several key-value-pair s.a. `[ [key1,value1], [key2,value2], ... ]`

#### pair [^][contents]
[pair]: #pair-
Creates a key-value-pair.

_Arguments:_
```OpenSCAD
pair (key, value)
```

#### pair_value [^][contents]
[pair_value]: #pair_value-
Get a value from a pair list with given key.

_Arguments:_
```OpenSCAD
pair_value (list, key, index)
```
- `index`
  - same key are skipped `index` times
  - default = get first hit, `index` = 0

#### pair_key [^][contents]
[pair_key]: #pair_key-
Get a key from a pair list with contained value.

_Arguments:_
```OpenSCAD
pair_key (list, value, index)
```
- `index`
  - same values are skipped `index` times
  - default = get first hit, `index` = 0

