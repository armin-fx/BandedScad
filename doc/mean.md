Functions for working with lists
================================

### defined in file
`banded/list.scad`\
` `| \
` `+--> `banded/list_mean.scad`

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Editing lists ->][edit]
- [Algorithm on lists ->](algorithm)
- [Math on lists ->][math]

- [Calculating mean][mean]
  - [List of mean functions](#list-of-mean-functions-)
    - [`mean_arithmetic()`][mean_arithmetic]
    - [`mean_geometric()`][mean_geometric]
    - [`mean_harmonic()`][mean_harmonic]
    - [`root_mean_square()`][root_mean_square]
    - [`mean_cubic()`][mean_cubic]
    - [`mean_generalized()`][mean_generalized]
  - [Other mean functions](#other-mean-functions-)
    - [`median()`][median]
    - [`mid_range()`][mid_range]
    - [`truncate_outlier()`][truncate_outlier]
    - [`truncate()`][truncate]

[mean]:      #calculating-mean-
[edit]:      list.md#editing-lists-
[algorithm]: list.md#algorithm-on-lists-
[math]:      list.md#math-on-lists-


Calculating mean [^][contents]
==============================

- Calculates mean of a list of numeric values
- Optional with weight list
- weight list can to get normalised,
  - option `normalize`
    - `true` - (standard)
      sum of all values of weight list will be scaled to 1


List of mean functions [^][contents]
------------------------------------

#### `mean_arithmetic (list, weight, normalize)` [^][contents]
[mean_arithmetic]: #mean_arithmetic-list-weight-normalize-
Calculates the arithmetic mean of a list\
[=> Wikipedia - Arithmetic mean](https://en.wikipedia.org/wiki/Arithmetic_mean)

#### `mean_geometric(list, weight, normalize)` [^][contents]
[mean_geometric]: #mean_geometric-list-weight-normalize-
Calculates the geometic mean of a list\
[=> Wikipedia - Geometric mean](https://en.wikipedia.org/wiki/Geometric_mean)

#### `mean_harmonic(list, weight, normalize)` [^][contents]
[mean_harmonic]: #mean_harmonic-list-weight-normalize-
Calculates the harmonic mean of a list\
[=> Wikipedia - Harmonic mean](https://en.wikipedia.org/wiki/Harmonic_mean)

#### `root_mean_square(list, weight, normalize)` [^][contents]
[root_mean_square]: #root_mean_square-list-weight-normalize-
Calculates the root mean square of a list\
[=> Wikipedia - Root mean square](https://en.wikipedia.org/wiki/Root_mean_square)

#### `mean_cubic(list, weight, normalize)` [^][contents]
[mean_cubic]: #mean_cubic-list-weight-normalize-
Calculates the cubic mean of a list\
[=> Wikipedia - Cubic mean](https://en.wikipedia.org/wiki/Cubic_mean)

#### `mean_generalized(list, weight, normalize)` [^][contents]
[mean_generalized]: #mean_generalized-list-weight-normalize-
Calculates the generalized mean (or power mean, or Hölder mean) of a list\
[=> Wikipedia - Generalized mean](https://en.wikipedia.org/wiki/Generalized_mean)


Other mean functions [^][contents]
----------------------------------

#### `median (list)` [^][contents]
[median]: #median-list-
Calculates the median of a list\
[=> Wikipedia - Median](https://en.wikipedia.org/wiki/Median)

#### `mid_range(list)` [^][contents]
[mid_range]: #mid_range-list-
Calculates the mid-range or mid-extreme of a list\
[=> Wikipedia - Mid-range](https://en.wikipedia.org/wiki/Mid-range)

#### `truncate_outlier (list, ratio)` [^][contents]
[truncate_outlier]: #truncate_outlier-list-ratio-
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
[truncate]: #truncate-list-ratio-
- Removes same elements from the ends like [`truncate_outlier()`][truncate_outlier]
  without previous sorting the list.

