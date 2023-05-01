Functions for editing strings
=============================

### defined in file
`banded/string.scad`\
` `| \
` `+--> `banded/string_convert.scad`\
` `+--> `banded/string_character.scad`\
` `+--> `banded/string_edit.scad`\
` `+--> `banded/string_format.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Convert strings](#convert-strings-)
  - [`to_lower_str()`][to_lower_str]
  - [`to_upper_str()`][to_upper_str]
  - [`value_to_hex()`][value_to_hex]
  - [`hex_to_value()`][hex_to_value]
  - [`hex_letter_to_value()`][hex_letter_to_value]
  - [`value_to_octal()`][value_to_octal]
  - [`int_to_str()`][int_to_str]
  - [`str_to_int()`][str_to_int]
  - [`float_to_str()`][float_to_str]
  - [`str_to_float()`][str_to_float]
  - [`str_to_list()`][str_to_list]
  - [`list_to_str()`][list_to_str]
- [Convert and test letter in strings](#convert-and-test-letter-in-strings-)
  - [`to_lower()`][to_lower]
  - [`to_upper()`][to_upper]
  - [`is_digit()`][is_digit]
  - [`is_alpha()`][is_alpha]
  - [`is_alnum()`][is_alnum]
  - [`is_xdigit()`][is_xdigit]
  - [`is_lower()`][is_lower]
  - [`is_upper()`][is_upper]
  - [`is_space()`][is_space]
  - [`is_blanc()`][is_blanc]
  - [`is_punct()`][is_punct]
  - [`is_cntrl`][is_cntrl]
  - [`is_print`][is_print]
  - [`is_graph`][is_graph]
- [Edit letter in strings](#edit-letter-in-strings-)
- [Format strings](#format-strings-)
  - [`add_padding_str()`][add_padding_str]
  - [`print()`][print]


Convert strings [^][contents]
-----------------------------

#### `to_lower_str (txt)` [^][contents]
[to_lower_str]: #to_lower_str-txt-
Replace every uppercase letter in text `txt` to lowercase letter

#### `to_upper_str (txt)` [^][contents]
[to_upper_str]: #to_upper_str-txt-
Replace every lowercase letter in text `txt` to uppercase letter

#### `value_to_hex (value, size, upper)` [^][contents]
[value_to_hex]: #value_to_hex-value-size-upper-
Turn a positive integer to a hexadecimal string
- `size`
  - set the minimum size of hex string, filled with `0`
  - default = 1 letter
- `upper`
  - `true`  - return string in uppercase letters
  - `false` - return string in lowercase letters, default

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

#### `value_to_octal (value, size)` [^][contents]
[value_to_octal]: #value_to_octal-value-size-
Turn a positive integer to a octal number string
- `size`
  - set the minimum size of octal string, filled with `0`
  - default = 1 letter

#### `int_to_str (x, sign)` [^][contents]
[int_to_str]: #int_to_str-x-sign-
Convert an integer to a string.
- `x`    - integer value
- `sign`   - character of positive sign
  - default = empty `""`
  - you can use e.g. a space `" "` or a plus `"+"`

_Specialized function:_
- `uint_to_str (x, count)`
  - returns only the integer number as string without any formatting
  - no negative values, `x` must be positive
  - `count` - maximum number of letters, default = `308`

#### `str_to_int (txt, begin)` [^][contents]
[str_to_int]: #str_to_int-txt-begin-
Convert a string to an integer.
- `begin`
  - optional, position in the string where the number begin
  - default = position `0`

_Specialized function:_
- `str_to_uint (txt, begin)`
  - Convert only numbers in a string to a positive integer.
  - breaks on sign letter like `+` or `-`
- `str_to_int_pos (txt, begin)`
  - like `str_to_int()`, but returns a list with the integer number
    and the next position in string `txt` after the integer string.
    - `[ number, position ]`
- `str_to_uint_pos (txt, begin)`
  - like `str_to_int_pos()`, but returns a list with a positive integer number
    and the next position in string `txt` after the integer string.
    - `[ number, position ]`
  - breaks on sign letter like `+` or `-`

#### `float_to_str (x, digits, compress, sign, point, upper)` [^][contents]
[float_to_str]: #float_to_str-x-digits-compress-sign-point-upper-
Convert a floating point number to a string.\
Result like numbers converted with `str()`.\
This function will automatically switch between:
- show as integer part and fraction part
- show as significand part in normalized form and exponent with base 10

Arguments:
- `x`      - floating point value
- `digits` - count of number letters
  - default = 6 character
- `precision`
  - disables argument `digits` if defined, default = `undef`
  - count of letters in fraction part of the floating point
  - control only the result when show as integer part and fraction part
- `compress`
  - if set `true`: remove appending `"0"` in fraction part to reduce the size of the string
  - default = `true`
- `sign` - character of positive sign
  - default = empty `""`
  - you can use e.g. a space `" "` or a plus `"+"`
- `point`
  - `true`  - show always a decimal point
  - `false` - show decimal point only when needed, default
- `upper`
  - `true`  - return string in uppercase letters
  - `false` - return string in lowercase letters, default

_Specialized function:_
- `float_to_str_comma (x, digits, precision, compress, sign, point)`
  - returns the floating point always as integer part and fraction part
  - `digits` - default = 16 character, machine accuracy
    - defines the significand count of digits
- `float_to_str_exp   (x, digits, compress, sign, point, upper)`
  - returns the floating point always as significand part in normalized form and
    exponent with base 10
  - `digits` - default = 16 character, machine accuracy

#### `str_to_float (txt, begin)` [^][contents]
[str_to_float]: #str_to_float-txt-begin-
Convert a string to a floating point number.
- `begin`
  - optional, position in the string where the number begin
  - default = position `0`

_Specialized function:_
- `str_to_float_pos (txt, begin)`
  - like `str_to_float()`, but returns a list with the floating point number
    and the next position in string `txt` after the floating point string.
    - `[ number, position ]`


#### `str_to_list (txt)` [^][contents]
[str_to_list]: #str_to_list-txt-
Put every once letter from a string `txt` into a list

#### `list_to_str (list)` [^][contents]
[list_to_str]: #list_to_str-list-
Concat every entry in a `list` to a string


Convert and test letter in strings [^][contents]
------------------------------------------------

Functions like in programming language C in file `ctype.h`.
But based on the naming scheme from OpenSCAD.

Arguments:
- `txt`
  - a string, uses only one character
- `pos`
  - optional, position of letter in string `txt`,
  - default = position `0` = first position

#### `to_lower (txt, pos)` [^][contents]
[to_lower]: #to_lower-txt-pos-
Replace an uppercase letter to a lowercase letter.\
Returns one letter.

#### `to_upper (txt, pos)` [^][contents]
[to_upper]: #to_upper-txt-pos-
Replace a lowercase letter to an uppercase letter.\
Returns one letter.

#### `is_digit (txt, pos)` [^][contents]
[is_digit]: #is_digit-txt-pos-
Check if one character at position `pos` is a numeric value.\
Returns `true` if the character is a decimal digit

#### `is_alpha (txt, pos)` [^][contents]
[is_alpha]: #is_alpha-txt-pos-
Check if one character at position `pos` is alphabetic.\
Returns `true` if the character is an uppercase or lowercase letter.

#### `is_alnum (txt, pos)` [^][contents]
[is_alnum]: #is_alnum-txt-pos-
Check if character is alphanumeric.\
Returns `true` if the character is either a decimal digit
or an uppercase or lowercase letter.

#### `is_xdigit (txt, pos)` [^][contents]
[is_xdigit]: #is_xdigit-txt-pos-
Check if character is hexadecimal digit.\
Hexadecimal digits are any of: 0 1 2 3 4 5 6 7 8 9 a b c d e f A B C D E F

#### `is_lower (txt, pos)` [^][contents]
[is_lower]: #is_lower-txt-pos-
Check if character is lowercase letter.

#### `is_upper (txt, pos)` [^][contents]
[is_upper]: #is_upper-txt-pos-
Check if character is uppercase letter.

#### `is_space (txt, pos)` [^][contents]
[is_space]: #is_space-txt-pos-
Check if character is a white-space.

White-space characters are any of:
- `" "` 	(0x20)	space (SPC)
- `"\t"`	(0x09)	horizontal tab (TAB)
- `"\n"`	(0x0a)	newline (LF)
- `"\v"`	(0x0b)	vertical tab (VT)
- `"\f"`	(0x0c)	feed (FF)
- `"\r"`	(0x0d)	carriage return (CR)

#### `is_blanc (txt, pos)` [^][contents]
[is_blanc]: #is_blanc-txt-pos-
Check if character is blanc.\
Blank characters are the tab character (`"\t"`) and the space character (`" "`)

#### `is_punct (txt, pos)` [^][contents]
[is_punct]: #is_punct-txt-pos-
Check if character is a punctuation character.\
Punctuation characters are all graphic characters (as in [`is_graph`][is_graph])
that are not alphanumeric (as in [`is_alnum`][is_alnum]).

#### `is_cntrl (txt, pos)` [^][contents]
[is_cntrl]: #is_cntrl-txt-pos-
Check if character is a control character.

A _control character_ is a character that does not occupy a printing position on a display
(this is the opposite of a printable character, checked with [`is_print`][is_print]).\
For the standard ASCII character set, control characters are those between
ASCII codes 0x00 (NUL) and 0x1f (US), plus 0x7f (DEL).

#### `is_print (txt, pos)` [^][contents]
[is_print]: #is_print-txt-pos-
Check if character is printable.

A _printable character_ is a character that occupies a printing position on a display
(this is the opposite of a control character, checked with [`is_cntrl`][is_cntrl]).\
For the standard ASCII character set, printing characters are all with an
ASCII code greater than 0x1f (US), except 0x7f (DEL).\
[`is_graph`][is_graph] returns `true` for the same cases as `is_print`
except for the space character (`" "`).

#### `is_graph (txt, pos)` [^][contents]
[is_graph]: #is_graph-txt-pos-
Check if character has graphical representation.

The characters with graphical representation are all those characters than can be printed
(as determined by [`is_print`][is_print] except the space character (`" "`).


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


#### Without use of letter: [^][contents]

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


#### With access to letter: [^][contents]

| base function                 | string function                              | description
|-------------------------------|----------------------------------------------|-------------
| [`sort()`][st]                | `sort_str (txt, f)`                          | Sort every letter in a string with a stable sort algorithm
| [`merge()`][mg]               | `merge_str (txt1, txt2, f)`                  | Merge 2 sorted strings into one string
| [`remove_duplicate()`][rd]    | `remove_duplicate_str (txt)`                 | Remove every duplicate letter in a string, so a letter exists only once
| [`remove_value()`][rmv]       | `remove_letter      (txt, letter)`           | Remove every letter that matches in a string
| [`remove_all_values()`][rma]  | `remove_all_letter  (txt, letter_list)`      | Remove every letter from a string, which matches in a list of letter
| [`remove_sequence()`][rs]     | `remove_sequence_str (txt, sequence, 'range_args' )`       | Remove all presence of a sequence in the string.
| [`replace_value()`][rpv]      | `replace_letter     (txt, letter, new)`      | Replace every letter that matches in a string with a string
| [`replace_all_values()`][rpa] | `replace_all_letter (txt, letter_list, new)` | Replace every letter in a string with a string, which matches a list of letter
| [`replace_sequence()`][rps]   | `replace_sequence_str (txt, sequence, new, 'range_args' )` | Replace all presence of a sequence in the string with another sequence.
| [`keep_value()`][kv]          | `keep_letter     (txt, letter)`              | Keep every letter that matches in a string. Remove the remainder. Makes little sense, for the sake of completeness.
| [`keep_all_values()`][ka]     | `keep_all_letter (txt, letter_list)`         | Keep every letter in a string, which matches in a list of letter. Remove the remainder.
| [`unique()`][uq]              | `unique_str      (txt, f)`                   | Removes all but the first letter from every consecutive group of equivalent
| [`keep_unique()`][ku]         | `keep_unique_str (txt, f)`                   | Removes all group of equivalent letter, keep only single letter.
| [`remove_if()`][rmi]          | `remove_if_str  (txt, f)`                    | Run a function at the letter in a string and remove every letter which this function returns `true`.
| [`replace_if()`][rpi]         | `replace_if_str (txt, f, new)`               | Run a function at the letter in a string and replace every letter wit a string which this function returns `true`.
| [`partition()`][pa]           | `partition_str (txt, f, 'range_args' )`      | Split a string in two parts. Store the 2 result strings in a list.
| [`for_each()`][fe]            | `for_each_str  (txt, f, 'range_args' )`      | Run a function on each letter in the string and return the result string.


#### Info from strings: [^][contents]

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
| [`find_first_of()`][fff]            | Search a list of letter in a string and returns the first position. Same letter can skipped `index` times.
| [`find_first_of_once()`][ffg]       | Search a list of letter in a string and returns the first position.
| [`find_last()`][fl]                 | Search at a letter backwards in a string and returns the last position. Same letter can skipped `index` times.
| [`find_last_once()`][flo]           | Search at a letter backwards in a string and returns the last position.
| [`find_last_of()`][flf]             | Search a list of letter backwards in a string and returns the last position. Same letter can skipped `index` times.
| [`find_last_of_once()`][flg]        | Search a list of letter backwards in a string and returns the last position.
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
| [`search_sequence()`][ss]           | Search a sequence in the string and return the position of the first presence.
| [`sequence_positions()`][sp]        | Search a sequence in the string and return all positions of the presence in a list.
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
[rs]:  list.md#remove_sequence-list-sequence-type-range_args-
[rpv]: list.md#replace_value-list-value-new-type-
[rpa]: list.md#replace_all_values-list-value_list-new-type-
[rps]: list.md#replace_sequence-list-sequence-new-type-range_args-
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
[fff]: list.md#find_first_of-list-value_list-index-type-range_args-
[ffg]: list.md#find_first_of_once-list-value_list-type-range_args-
[fl]:  list.md#find_last-list-value-index-type-range_args-
[flo]: list.md#find_last_once-list-value-type-range_args-
[flf]: list.md#find_last_of-list-value_list-index-type-range_args-
[flg]: list.md#find_last_of_once-list-value_list-type-range_args-
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
[ss]:  list.md#search_sequence-list-sequence-type-range_args-
[sp]:  list.md#sequence_positions-list-sequence-type-range_args-
[ao]:  list.md#all_of-list-f-type-range_args-
[no]:  list.md#none_of-list-f-type-range_args-
[so]:  list.md#any_of-list-f-type-range_args-
[eq]:  list.md#equal-list1-list2-f-type-begin1-begin2-count-
[inc]: list.md#includes-list1-list2-f-type-range_args1-range_args2-
[is]:  list.md#is_sorted-list-f-type-range_args-
[ip]:  list.md#is_partitioned-list-f-type-range_args-


Format strings [^][contents]
----------------------------

#### `add_padding_str (txt, pre, size, padding, align)` [^][contents]
[add_padding_str]: #add_padding_str-txt-pos-
Add padding letters to a string.
- `txt` - text to format
- `pre` - text will prepend on `txt`, position depends on the arguments
- `size`
  - minimum count of lettersof text (`pre` and `txt` together)
  - the remainder will be filled with padding letters
  - default = 1 character
- `padding` - padding character to fill the left empty letters
  - default = space `" "`
    you can use an other spaceholder like `"."`
  - if you set number `0`, text `pre` will set left before the padding letter `"0"`
- `align` - align of number
  - `-1` = left
  -  `0` = middle
  -  `1` = right, default

Functions which demonstrate this with appended
extra arguments `size`, `padding` and `align`:
- `int_to_str_format (x, sign, size, padding, align)`
  - base on [`int_to_str()`][int_to_str]
- `float_to_str_format       (x, digits, compress, sign, point, upper, size, padding, align)`
  - base on [`float_to_str()`][float_to_str]
- `float_to_str_comma_format (x, digits, precision, compress, sign, point, size, padding, align)`
  - base on [`float_to_str_comma()`][float_to_str]
- `float_to_str_exp_format   (x, digits, compress, sign, point, upper, size, padding, align)`
  - base on [`float_to_str_exp()`][float_to_str]

#### `print (format, values)` [^][contents]
[print]: #print-format-values-
Composes a string by format the text with format specifiers.\
It's based on the function `sprintf()` from programming language 'C'.
If string `format` includes ___format specifiers___ (subsequences beginning with `%`),
the additional arguments following format are formatted and inserted
in the resulting string replacing their respective specifiers.\
Returns the composed string.

Arguments:
- `format`
  - string to print into the returned string,
    format specifier will be replaced with the associated value
- `values`
  - a list with the values in order

A ___format specifier___ follows this prototype:\
`%[flags][width][.precision][length]specifier`

Where the ___specifier character___ at the end is the most significant component,
since it defines the type and the interpretation of its corresponding argument:

| specifier | meaning
|-----------|---------
| `d`, `i`  | signed integer
| `u`       | obsolete, same as `i` (originally unsigned integer)
| `o`       | unsigned octal value
| `x`       | hexadecimal, lowercase
| `X`       | hexadecimal, uppercase
| `f` `F`   | floating point
| `e`       | scientific notation (mantissa/exponent), lowercase
| `E`       | scientific notation (mantissa/exponent), uppercase
| `g`       | use the shortest representation: `%e` or `%f`
| `G`       | use the shortest representation: `%E` or `%F`
| `c`       | character
| `s`       | string of character
| `%`       | A % followed by another % character will write a single % to the stream.

The ___format specifier___ can also contain sub-specifiers:
___flags___, ___width___, ___.precision___ and ___modifiers___ (in that order),
which are optional and follow these specifications:

___flags:___
- `-`
  - Left-justify within the given field width;
    Right justification is the default (see width sub-specifier).
- `+`
  - Forces to preceed the result with a plus or minus sign (+ or -)
    even for positive numbers.
    By default, only negative numbers are preceded with a - sign.
- (space)
  - If no sign is going to be written, a blank space is inserted before the value.
- `#`
  - Used with `o`, `x` or `X` specifiers the value is preceeded
    with `0`, `0x` or `0X` respectively for values different than zero.
  - Used with `e`, `E`, `f`, `F`, `g` or `G` it forces the written output
    to contain a decimal point even if no more digits follow.
    By default, if no digits follow, no decimal point is written.
- `0`
  - The conversion will be zero padded for numeric values.

___width:___
- (number)
  - Minimum number of characters to be printed.
  - If the value to be printed is shorter than this number,
    the result is padded with blank spaces.
  - The value is not truncated even if the result is larger.
- `*`
  - The width is not specified in the format string,
    but as an additional integer value argument preceding
    the argument that has to be formatted.

___.precision___
- (number)
  - For integer specifiers (`d`, `i`, `o`, `u`, `x`, `X`):
    precision specifies the minimum number of digits to be written.
	If the value to be written is shorter than this number,
	the result is padded with leading zeros.
	The value is not truncated even if the result is longer.
	A precision of 0 means that no character is written for the value 0.
  - For `e`, `E`, `f` and `F` specifiers:
    this is the number of digits to be printed after the decimal point
    (by default, this is 6).
  - For `g` and `G` specifiers:
    This is the maximum number of significant digits to be printed.
  - For `s`:
    this is the maximum number of characters to be printed.
    By default all characters are printed.
  - If the period is specified without an explicit value for precision, 0 is assumed.
- `*`
  - The precision is not specified in the format string,
    but as an additional integer value argument preceding
    the argument that has to be formatted.

___Example:___
```OpenSCAD
include <banded.scad>

echo( print ("String, character: %.4s - %c - %c", ["Testosterone", ord("A"), 9786] ) );
echo( print ("Decimal: %+i - %i", [99, 42] ) );
echo( print ("Proceeding with blanc: %5i" , [42] ) );
echo( print ("Proceeding with zeros: %05i", [42] ) );
echo( print ("Some different radices: %d - %x - %o - %#x - %#o", [100, 100, 100, 100, 100] ) );
echo( print ("Floats: %4.2f - %+.0e - %E", [3.1416, 3.1416, 3.1416] ) );
echo( print ("Width trick: %*d", [5, 10] ) );
```

Output:
```
ECHO: "String, character: Test - A - ☺"
ECHO: "Decimal: +99 - 42"
ECHO: "Proceeding with blanc:    42"
ECHO: "Proceeding with zeros: 00042"
ECHO: "Some different radices: 100 - 64 - 144 - 0x64 - 0144"
ECHO: "Floats: 3.14 - +3e+0 - 3.141600E+0"
ECHO: "Width trick:    10"
```
