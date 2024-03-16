Math on lists - mean
====================

### defined in file
`banded/list.scad`  
` `|  
` `+--> `banded/list_mean.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Calculating mean](#calculating-mean-)
  - [List of mean functions](#list-of-mean-functions-)
    - [`mean()`, `mean_arithmetic()`][mean_arithmetic]
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
    - [`variance()`][variance]


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

#### mean_arithmetic, mean [^][contents]
[mean_arithmetic]: #mean_arithmetic-mean-
Calculates the arithmetic mean (or mean or average) of a list.  
[=> Wikipedia - Arithmetic mean](https://en.wikipedia.org/wiki/Arithmetic_mean)

_Arguments:_
```OpenSCAD
mean_arithmetic (list, weight, normalize)
```

_There is a shortcut to function_ `mean_arithmetic()`:
- `mean (list, weight, normalize)`

_Example:_
```OpenSCAD
l = [3, 5, 8, 4];
echo ( mean_arithmetic (l) ); // echo 5
```

#### mean_geometric [^][contents]
[mean_geometric]: #mean_geometric-
Calculates the geometic mean of a list.  
[=> Wikipedia - Geometric mean](https://en.wikipedia.org/wiki/Geometric_mean)

_Arguments:_
```OpenSCAD
mean_geometric (list, weight, normalize)
```

_Example:_
```OpenSCAD
l = [3, 5, 8, 4];
echo ( mean_geometric (l) ); // echo 4.68069
```

#### mean_harmonic [^][contents]
[mean_harmonic]: #mean_harmonic-
Calculates the harmonic mean of a list.  
[=> Wikipedia - Harmonic mean](https://en.wikipedia.org/wiki/Harmonic_mean)

_Arguments:_
```OpenSCAD
mean_harmonic (list, weight, normalize)
```

_Example:_
```OpenSCAD
l = [3, 5, 8, 4];
echo ( mean_harmonic (l) ); // echo 4.40367
```

#### root_mean_square [^][contents]
[root_mean_square]: #root_mean_square-
Calculates the root mean square of a list.  
[=> Wikipedia - Root mean square](https://en.wikipedia.org/wiki/Root_mean_square)

_Arguments:_
```OpenSCAD
root_mean_square (list, weight, normalize)
```

_Example:_
```OpenSCAD
l = [3, 5, 8, 4];
echo ( root_mean_square (l) ); // echo 5.33854
```

#### mean_cubic [^][contents]
[mean_cubic]: #mean_cubic-
Calculates the cubic mean of a list.  
[=> Wikipedia - Cubic mean](https://en.wikipedia.org/wiki/Cubic_mean)

_Arguments:_
```OpenSCAD
mean_cubic (list, weight, normalize)
```

_Example:_
```OpenSCAD
l = [3, 5, 8, 4];
echo ( mean_cubic (l) ); // echo 5.66705
```

#### mean_generalized [^][contents]
[mean_generalized]: #mean_generalized-
Calculates the generalized mean (or power mean, or Hölder mean) of a list.  
[=> Wikipedia - Generalized mean](https://en.wikipedia.org/wiki/Generalized_mean)

_Arguments:_
```OpenSCAD
mean_generalized (p, list, weight, normalize)
```
- `p`
  - a number, set the type of the calculated mean, e.g.
    - `-1` - harmonic mean
    - ` 0` - arithmetic mean
    - ` 1` - geometic mean
    - ` 2` - root mean square
    - ` 3` - cubic mean

_Example:_
```OpenSCAD
l = [3, 5, 8, 4];
echo ( mean_generalized (4, l) ); // echo 5.9632
```


Other mean functions [^][contents]
----------------------------------

#### median [^][contents]
[median]: #median-
Calculates the median of a list.  
[=> Wikipedia - Median](https://en.wikipedia.org/wiki/Median)

_Arguments:_
```OpenSCAD
median (list)
```

#### mid_range [^][contents]
[mid_range]: #mid_range-
Calculates the mid-range or mid-extreme of a list.  
[=> Wikipedia - Mid-range](https://en.wikipedia.org/wiki/Mid-range)

_Arguments:_
```OpenSCAD
mid_range (list)
```

#### truncate_outlier [^][contents]
[truncate_outlier]: #truncate_outlier-
Removes outliers from a data list.
- Sort a list and remove a given ratio of elements from the ends.
  This is useful for mean functions to truncate outliers from a data list.
- Leaves always at minimum 1 element if odd size of list or
  at minimum 2 element if even size of list.

_Arguments:_
```OpenSCAD
truncate_outlier (list, ratio)
```
- `ratio`
  - standard ratio = 0.5, = removes less or equal 50% from the ends\
    (25% from begin and 25% from end)

_Sample:_
```OpenSCAD
include <banded.scad>

data  = [1,9,4,2,15];
trunc = truncate_outlier (data, 0.5);
mean  = mean_arithmetic  (trunc);

echo (trunc); // [2,4,6]
echo (mean);  // 5
```

#### truncate [^][contents]
[truncate]: #truncate-
Removes same elements from the ends like [`truncate_outlier()`][truncate_outlier]
without previous sorting the list.

_Arguments:_
```OpenSCAD
truncate (list, ratio)
```

#### variance [^][contents]
[variance]: #variance-
Calculates the variance of the mean from a list.  
Variance is the expected value of the squared deviation from the mean of a random variable.
The standard deviation is obtained as the square root of the variance.
Variance is a measure of dispersion,
meaning it is a measure of how far a set of numbers is spread out from their average value.  
[=> Wikipedia - Variance](https://en.wikipedia.org/wiki/Variance)

_Arguments:_
```OpenSCAD
variance (list, biased, mean)
```
- `biased`
  - `false` - default, calculates the mean variance
  - `true`  - calculates `n / (n-1)` with the mean variance, gives an unbiased estimator of the variance
  - `undef` - summarize all variances
- `mean`
  - optional
  - If mean was already calculated (e.g. with function [`mean()`][mean_arithmetic]),
    you can set the value here.
    Then the function must not calculate this value again.

