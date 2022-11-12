Functions for editing strings
=============================

### defined in file
`banded/string.scad`\
` `| \
` `+--> `banded/string_convert.scad`\
` `| \
` `+--> `banded/string_edit.scad`\
` `. . . . +--> `banded/string_edit_letter.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Convert strings](#convert-strings-)
  - [`to_lower_case()`][to_lower_case]
  - [`to_upper_case()`][to_upper_case]
  - [`value_to_hex()`][value_to_hex]
  - [`hex_to_value()`][hex_to_value]
  - [`hex_letter_to_value()`][hex_letter_to_value]
  - [`str_to_list()`][str_to_list]
  - [`list_to_str()`][list_to_str]
- [Edit letter in strings](#edit-letter-in-strings-)


Convert strings [^][contents]
-----------------------------

#### `to_lower_case (txt)` [^][contents]
[to_lower_case]: #to_lower_case-txt-
Replace every big letter in text `txt` to a low letter

#### `to_upper_case (txt)` [^][contents]
[to_upper_case]: #to_upper_case-txt-
Replace every low letter in text `txt` to an upper letter

#### `value_to_hex (value, size)` [^][contents]
[value_to_hex]: #value_to_hex-value-size-
Turn a positive integer to a hexadecimal string
- `size`
  - set the minimum size of hex string, filled with `0`
  - default = 1 letter

#### `hex_to_value (txt, pos, size, error)` [^][contents]
[hex_to_value]: #hex_to_value-txt-pos-size-error-
Turn a hexadecimal string to an integer\
optional arguments:
- `pos`
  - begin position of hex string
  - default = `0`
- `size`
  - size of hex string, count of letters to convert
  - default = `undef`, means complete string
- `error` - return this value if string is no hex value
  - default = `undef`

#### `hex_letter_to_value (txt, pos, error)` [^][contents]
[hex_letter_to_value]: #hex_letter_to_value-txt-pos-error-
Turn a hexadecimal letter at position `pos` to an integer\
optional arguments:
- `pos`
  - position of hex letter
  - default = `0`
- `error`
  - return this value if string is no hex value
  - default = `undef`

#### `str_to_list (txt)` [^][contents]
[str_to_list]: #str_to_list-txt-
Put every once letter from a string `txt` into a list

#### `list_to_str (list)` [^][contents]
[list_to_str]: #list_to_str-list-
Concat every entry in a `list` to a string


Edit letter in strings [^][contents]
------------------------------------

The [list edit functions](list.md) can used for strings,
because the access to the letter is the same like to the list elements.
As type must use the default type `0` for directly use of elements.
The result is no string, every letter is an entry in the list.
This result can convert to a string with function [`list_to_str()`][list_to_str].

So all functions which returns the edited data
must be embedded in function `list_to_str()`.
For these situation there exist specialized functions for strings,
which returns a string directly.

_The argument names differs:_

| list edit    | string edit
|--------------|-------------
| `list`       | `txt`
| `value`      | `letter`
| `value_list` | `letter_list`


#### Without use of letter:

| base function               | string function                         | description
|-----------------------------|-----------------------------------------|-------------
| [`concat_list()`][cl]       | `concat_str (txt)`, `list_to_str (txt)` | Concat every string in a list
| [`reverse()`][rv]           | `reverse_str (txt, 'range_args')`       | Reverse the sequence of letters in a string in a defined range
| [`reverse_full()`][rf]      | `reverse_full_str (txt)`                | Reverse the sequence of letters in the full string
| [`rotate_list()`][rl]       | `rotate_str (txt, middle, ... )`        | Rotates the order of the letter in a string
| [`rotate_copy()`][rc]       | `rotate_copy_str (list, middle, ... )`  | Copy a range of a string and rotates the order of the letter in this
| [`remove()`][rm]            | `remove_str (txt, begin, count)`        | Remove letter from a string
| [`insert()`][in]            | `insert_str  (txt, txt_insert, ...)`    | Insert a string at given position in a string
| [`replace()`][rp]           | `replace_str (txt, txt_insert, ... )`   | Replace a range in a string with a string
| [`extract()`][ex]           | `extract_str (txt, 'range_args' )`      | Extract a range in a string
| [`fill()`][fi]              | `fill_str (count, value)`               | Make a string filled with count of a string
| [`select()`][se]            | `select_str (base, index)`              | Create a string with letters of `base` at positions in order of list `index`
| [`select_all()`][sa]        | `select_all_str (base, indices)`        | Create a list with strings in order of a list with indices with letter from `base`
| [`select_link()`][sl]       | `select_link_str (base, link, index)`   | Create a string with letters of `base` at positions stored in `link` in order of list `index` which points to `link`
| [`unselect()`][us]          | `unselect_str (base, index)`            | Keep all positions in the string which are not listed in `index`.
| [`index()`][ix]             | `index_str (txt)`                       | Returns a list of positions from every letter in a string in ascending order
| [`index_all()`][ia]         | `index_all_str (list)`                  | Appends all strings to one string and stores lists with the positions on them.
| [`remove_unselected()`][ru] | `remove_unselected_str (txt, indices)`  | Removes all letter that are not indexed and rewrites all indices.
| [`compress_selected()`][cs] | `compress_selected_str (list, indices)` | Summarizes all letter that occur more than once, rewrites all indices.


#### With access to letter:

| base function                 | string function                              | description
|-------------------------------|----------------------------------------------|-------------
| [`sort()`][st]                | `sort_str (txt, f)`                          | Sort every letter in a string with a stable sort algorithm
| [`merge()`][mg]               | `merge_str (txt1, txt2, f)`                  | Merge 2 sorted strings into one string
| [`remove_duplicate()`][rd]    | `remove_duplicate_str (txt)`                 | Remove every duplicate letter in a string, so a letter exists only once
| [`remove_value()`][rmv]       | `remove_letter      (txt, letter)`           | Remove every letter that matches in a string
| [`remove_all_values()`][rma]  | `remove_all_letter  (txt, letter_list)`      | Remove every letter from a string, which matches in a list of letter
| [`replace_value()`][rpv]      | `replace_letter     (txt, letter, new)`      | Replace every letter that matches in a string with a string
| [`replace_all_values()`][rpa] | `replace_all_letter (txt, letter_list, new)` | Replace every letter in a string with a string, which matches a list of letter
| [`keep_value()`][kv]          | `keep_letter     (txt, letter)`              | Keep every letter that matches in a string. Remove the remainder. Makes little sense, for the sake of completeness.
| [`keep_all_values()`][ka]     | `keep_all_letter (txt, letter_list)`         | Keep every letter in a string, which matches in a list of letter. Remove the remainder.
| [`unique()`][uq]              | `unique_str      (txt, f)`                   | Removes all but the first letter from every consecutive group of equivalent
| [`keep_unique()`][ku]         | `keep_unique_str (txt, f)`                   | Removes all group of equivalent letter, keep only single letter.
| [`remove_if()`][rmi]          | `remove_if_str  (txt, f)`                    | Run a function at the letter in a string and remove every letter which this function returns `true`.
| [`replace_if()`][rpi]         | `replace_if_str (txt, f, new)`               | Run a function at the letter in a string and replace every letter wit a string which this function returns `true`.
| [`partition()`][pa]           | `partition_str (txt, f, 'range_args' )`      | Split a string in two parts. Store the 2 result strings in a list.
| [`for_each()`][fe]            | `for_each_str  (txt, f, 'range_args' )`      | Run a function on each letter in the string and return the result string.


#### Info from strings:

Use list functions directly:

| function                            | description
|-------------------------------------|-------------
| [`min_value()`, `min_entry()`][mix] | Get the lowest letter from a string
| [`max_value()`, `max_entry()`][max] | Get the highest letter from a string
| [`min_position()`][mip]             | Get the position of the lowest letter from a string
| [`max_position()`][map]             | Get the position of the highest letter from a string
| [`count()`][ct]                     | Count how often a letter is in a string
| [`find_first()`][ff]                | Search at a letter in a string and returns the first position. Same letter can skipped `index` times.
| [`find_first_once()`][ffo]          | Search at a letter in a string and returns the first position.
| [`find_last()`][fl]                 | Search at a letter in a string and returns the last position. Same letter can skipped `index` times.
| [`find_last_once()`][flo]           | Search at a letter in a string and returns the last position.
| [`mismatch()`][mm]                  | Compares the letter in 2 strings and returns the positions of the first letter of both sequences that does not match.
| [`mismatch_list()`][ml]             | Compares the letter in 2 strings and returns the positions of all letter of both sequences as list that does not match.
| [`adjacent_find()`][af]             | Find equal adjacent letter in a string
| [`binary_search()`][bs]             | Search a letter in a sorted string
| [`sorted_until()`][su]              | Returns the first position where the string is not sorted into ascending order.
| [`sorted_until_list()`][sul]        | Returns all position in a string at where the string is not sorted into ascending order.
| [`lexicographical_compare()`][lc]   | Lexicographical less-than comparison of two strings.
| [`count_if()`][ci]                  | Count how often the function `f()` hits `true` on an letter in a string
| [`find_first_if()`][ffi]            | Run function `f()` at the letter in a string and returns the position which this function returns `true`. Same letter can skipped `index` times.
| [`find_first_once_if()`][ffj]       | Run function `f()` at the letter in a string and returns the position which this function returns `true`.
| [`find_last_if()`][fli]             | Run function `f()` at the letter backwards in a string and returns the position which this function returns `true`. Same letter can skipped `index` times.
| [`find_last_once_if()`][flj]        | Run function `f()` at the letter backwards in a string and returns the position which this function returns `true`.
| [`all_of()`][ao]                    | Returns `true` if `f()` returns `true` for all the letter in the range
| [`none_of()`][no]                   | Returns `true` if `f()` returns `false` for all the letter in the range
| [`any_of()`][so]                    | Returns `true` if `f()` returns `true` for any letter in the range
| [`equal()`][eq]                     | Tests the letter of two strings for equality and returns `true` on success.
| [`includes()`][inc]                 | Returns `true` if the sorted string contains all the elements in the second sorted string.
| [`is_sorted()`][is]                 | Check whether string is sorted.
| [`is_partitioned()`][ip]            | Returns `true` if all the elements in the string are split in two parts.


[cl]:  list.md#concat_list-list-
[rv]:  list.md#reverse-list-range_args-
[rf]:  list.md#reverse-list-range_args-
[rl]:  list.md#rotate_list-list-middle-begin-last-
[rc]:  list.md#rotate_copy-list-middle-begin-last-
[rm]:  list.md#remove-list-begin-count-
[in]:  list.md#insert-list-list_insert-position-begin_insert-count_insert-
[rp]:  list.md#replace-list-list_insert-begin-count-begin_insert-count_insert-
[ex]:  list.md#extract-list-range_args-
[fi]:  list.md#fill-count-value-
[se]:  list.md#select-base-index-
[sa]:  list.md#select_all-base-indices-
[sl]:  list.md#select_link-base-link-index-
[us]:  list.md#unselect-base-index-
[ix]:  list.md#index-list-
[ia]:  list.md#index_all-list-
[ru]:  list.md#remove_unselected-list-indices-
[cs]:  list.md#compress_selected-list-indices-

[st]:  list.md#sort-list-type-f-
[mg]:  list.md#merge-list1-list2-type-f-
[rd]:  list.md#remove_duplicate-list-type-
[rmv]: list.md#remove_value-list-value-type-
[rma]: list.md#remove_all_values-list-value_list-type-
[rpv]: list.md#replace_value-list-value-new-type-
[rpa]: list.md#replace_all_values-list-value_list-new-type-
[kv]:  list.md#keep_value-list-value-type-
[ka]:  list.md#keep_all_values-list-value_list-type-
[uq]:  list.md#unique-list-type-f-
[ku]:  list.md#keep_unique-list-type-f-
[rmi]: list.md#remove_if-list-f-type-
[rpi]: list.md#replace_if-list-f-new-type-
[pa]:  list.md#partition-list-f-type-range_args-
[fe]:  list.md#for_each-list-f-type-range_args-

[mix]: list.md#minimum-or-maximum-value-
[max]: list.md#minimum-or-maximum-value-
[mip]: list.md#minimum-or-maximum-value-
[map]: list.md#minimum-or-maximum-value-
[ct]:  list.md#count-list-value-type-range_args-
[ff]:  list.md#find_first-list-value-index-type-range_args-
[ffo]: list.md#find_first_once-list-value-type-range_args-
[fl]:  list.md#find_last-list-value-index-type-range_args-
[flo]: list.md#find_last_once-list-value-type-range_args-
[mm]:  list.md#mismatch-list1-list2-begin1-begin2-count-type-f-
[ml]:  list.md#mismatch_list-list1-list2-begin1-begin2-count-type-f-
[af]:  list.md#adjacent_find-list-type-range_args-f-
[bs]:  list.md#binary_search-list-value-type-f-
[su]:  list.md#sorted_until-list-f-type-range_args-
[sul]: list.md#sorted_until_list-list-f-type-range_args-
[lc]:  list.md#lexicographical_compare-list1-list2-f-type-
[ci]:  list.md#count_if-list-f-type-range_args-
[ffi]: list.md#find_first_if-list-f-index-type-range_args-
[ffj]: list.md#find_first_once_if-list-f-type-range_args-
[fli]: list.md#find_last_if-list-f-index-type-range_args-
[flj]: list.md#find_last_once_if-list-f-type-range_args-
[ao]:  list.md#all_of-list-f-type-range_args-
[no]:  list.md#none_of-list-f-type-range_args-
[so]:  list.md#any_of-list-f-type-range_args-
[eq]:  list.md#equal-list1-list2-f-type-begin1-begin2-count-
[inc]: list.md#includes-list1-list2-f-type-range_args1-range_args2-
[is]:  list.md#is_sorted-list-f-type-range_args-
[ip]:  list.md#is_partitioned-list-f-type-range_args-
