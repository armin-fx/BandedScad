Functions for editing strings
=============================

### defined in file
`banded/string.scad`\
` `| \
` `+--> `banded/string_convert.scad`\
` `| \
` `+--> `banded/string_edit.scad`\
` `. . . . +--> `banded/string_edit_item.scad`\
` `. . . . +--> `banded/string_edit_data.scad`

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
- [Edit strings independent from data][string_edit_item]
  - [`reverse_str()`][reverse_str]
  - [`erase_str()`][erase_str]
  - [`insert_str()`][insert_str]
  - [`replace_str()`][replace_str]
  - [`extract_str()`][extract_str]
  - [`fill_str()`][fill_str]
- [Edit strings with use of data][string_edit_data]
  - [`find_first_str()`][find_first_str]
  - [`find_last_str()`][find_last_str]
  - [`count_str()`][count_str]
  - [`remove_duplicate_str()`][remove_duplicate_str]
  - [`remove_value_str()`][remove_value_str]
  - [`remove_values_str()`][remove_values_str]
  - [`replace_value_str()`][replace_value_str]
  - [`replace_values_str()`][replace_values_str]


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


Edit strings independent from data [^][contents]
---------------------------------------------------
[string_edit_item]: #edit-strings-independent-from-data-
Do the same things like the [list edit functions](list.md#edit-list-independent-from-the-data-),
but on strings.

#### `reverse_str (txt)` [^][contents]
[reverse_str]: #reverse_str-txt-
Reverse the sequence of letter in a string

#### `erase_str (txt, begin, count)` [^][contents]
[erase_str]: #erase_str-txt-begin-count-
Remove letter from a string
- `begin`
  - Erases from this position
  - The same coding like in python
- `count`
  - Count of elements which will erase,
  - default = 1 element

#### `insert_str (txt, txt_insert, position, begin_insert, count_insert)` [^][contents]
[insert_str]: #insert_str-txt-txt_insert-position-begin_insert-count_insert-
Insert string `txt_insert` into a string `txt`
- `position`
  - Insert the string `txt_insert` into this position,
    shift all elements from here at the end.
  - Position differs from coding in python
  - Positive value = insert at the begin of the element
  - Negative value = insert at the end of the element
  - Standard = -1, append at the end
- `begin_insert`
  - Copy the elements from this position in `txt_insert`
  - The same coding like in python
  - default = from first element in `txt_insert`
- `count_insert`
  - Count of elements which will insert from `txt_insert`
  - default = all elements until last element

#### `replace_str (txt, txt_insert, begin, count, begin_insert, count_insert)` [^][contents]
[replace_str]: #replace_str-txt-txt_insert-begin-count-begin_insert-count_insert-
Replace elements in a string `txt` with `txt_insert` or part of it
- `begin`
  - Insert the string `txt_insert` into this position of string `txt`,
    shift all remain elements from here at the end.
  - Position differs from coding in python
  - Positive value = insert at the begin of the element
  - Negative value = insert at the end of the element
  - Standard = `-1`, append at the end
- `count`
  - Remove this count of elements from `begin` in `txt`
  - default = `0`, remove no element, only insert the string
- `begin_insert`
  - Copy the elements from this position in `txt_insert`
  - The same coding like in python
  - default = from first element in `txt_insert`
- `count_insert`
  - Count of elements which will insert from `txt_insert`
  - default = all elements until last element

#### `extract_str (txt, 'range_args')` [^][contents]
[extract_str]: #extract_str-txt-range_args-
Extract a sequence from a string `txt`
- [`'range_args'`](list.md#repeating-options-) - arguments to set the range to extract

#### `fill_str (count, value)` [^][contents]
[fill_str]: #fill_str-count-value-
Makes a string with `count` elements filled with `value`


Edit strings with use of data [^][contents]
----------------------------------------
[string_edit_data]: #edit-strings-with-use-of-data-
Do the same things like the [list edit functions](list.md#edit-list-with-use-of-data-),
but on strings.

#### `find_first_str (txt, letter, index)` [^][contents]
[find_first_str]: #find_first_str-txt-letter-index-
Search at a letter in a string and returns the position.\
Returns the size of string if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `find_first_once_str (txt, letter)` [^][contents]
[find_first_once_str]: #find_first_once_str-txt-letter-
Search at a letter in a string and returns the position.\
Returns the size of string if nothing was found.\
Like [`find_first_str()`][find_first_str],
but return always the position of the first hit.

#### `find_last_str (txt, letter)` [^][contents]
[find_last_str]: #find_last_str-txt-letter-
Search at a letter in a string backwards from the end to first letter and returns the position.\
Returns `-1` if nothing was found.
- `index`
  - Same values are skipped `index` times
  - Standard = get first hit, `index` = 0

#### `find_last_once_str()` [^][contents]
[find_last_once_str]: #find_last_once_str-
Search at a letter in a string backwards from the end to first letter and returns the position.\
Returns `-1` if nothing was found.\
Like [`find_last_str()`][find_last_str],
but return always the position of the first hit.

#### `count_str (txt, letter, 'range_args')` [^][contents]
[count_str]: #count_str-txt-letter-range_args-
Count how often a `letter` is in string `txt`
- [`'range_args'`](list.md#repeating-options-) - arguments to set the range in which will count, standard = full list

#### `remove_duplicate_str (txt)` [^][contents]
[remove_duplicate_str]: #remove_duplicate_str-txt-
Remove every duplicate in a string, so a letter exists only once

#### `remove_value_str (txt, letter)` [^][contents]
[remove_value_str]: #remove_value_str-txt-letter-
Remove every given `letter` in a string `txt`

#### `remove_values_str (txt, letter_list)` [^][contents]
[remove_values_str]: #remove_values_str-txt-letter_list-
Remove every entry with a given list of letter in a string `txt`
- `letter_list` - a list with letter to remove

#### `replace_value_str (txt, letter, new)` [^][contents]
[replace_value_str]: #replace_value_str-txt-letter-new-
Replace every given `letter` in a string `txt` to a new string

#### `replace_values_str (txt, letter_list, new)` [^][contents]
[replace_values_str]: #replace_values_str-txt-letter_list-new-
Replace every entry with a given list of letter in a string `txt` to a new string
- `letter_list` - a list with letter to remove

