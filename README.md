BandedScad
==========

BandedScad is an OpenSCAD library.
It contains functions and modules to extend the OpenSCAD language.
It's a playground for experiments.

### Contents
[contents]: #contents "Up to Contents"
- [What it does](#what-it-does-)
- [Installation](#installation-)
- [Use](#use-)
- [Table of contents -->](doc/contents.md)
- [File overview -->](doc/file_overview.md)


What it does [^][contents]
--------------------------

- [More control of the level of detail for a mesh][extend],
    extend the control of number of facets used to generate an arc
- [Configurable object modules][object]
  - [Figures][figures] (torus, wedge, funnel, ... )
  - [Rounded and chamfered edges][edges]
- [Transform and edit objects][operator]
- Draft objects in data lists
  - [Create curves][curves] into a point list with functions.
    These can load with `polygon()`
  - [Transform objects in a point list][transform] with affine transformations.
    Like transformation operator in OpenSCAD for object modules.
  - Create and edit buildin [primitives from OpenSCAD with functions][primitives]
    as data in a list.\
    _(not finished yet)_
  - [Working with multmatrix][multmatrix]
  - [Convert colors][color]
- [Editing lists][list]
  - Most functions base on the STL from C++
  - [Edit list independent from the data][list_edit_item]
  - [Edit list with use of data, depend on type][list_edit_data]
  - [Use function literal on data][list_edit_pred]
- [Edit and convert strings][string]
- Functions for [Math operations on lists][list_math]
  - [Algorithm on lists][list_algorithm]
  - [Math operation on each list element][list_math]
  - [Calculating mean][mean]
- [Math functions][math]
  - [Various common math functions][math_common]
  - Functions for [vector][vector] and [matrices][matrix]
  - Calculate with [complex numbers][complex]
- [Algorithmus with function literals][function]
- [Helper functions][helper]
- [Benchmark functions for speed][benchmark]

[extend]:      doc/extend.md
[draft]:       doc/draft.md
[curves]:      doc/draft_curves.md
[transform]:   doc/draft_transform.md
[multmatrix]:  doc/draft_matrix.md
[primitives]:  doc/draft_primitives.md
[color]:       doc/color.md
[list]:           doc/list.md
[list_edit_item]: doc/list.md#edit-list-independent-from-the-data-
[list_edit_data]: doc/list.md#edit-list-with-use-of-data-depend-on-type-
[list_edit_pred]: doc/list.md#edit-list-use-function-literal-on-data-
[list_math]:      doc/list_math.md
[list_algorithm]: doc/list_math.md#algorithm-on-lists-
[list_math_each]: doc/list_math.md#math-operation-on_each-list-element-
[mean]:           doc/list_mean.md
[string]:      doc/string.md
[function]:    doc/function.md
[helper]:      doc/helper.md
[benchmark]:   doc/helper.md#benchmark-function-
[math]:        doc/math.md
[math_common]: doc/math.md#various-math-functions-
[vector]:      doc/math_vector.md
[matrix]:      doc/math_matrix.md
[complex]:     doc/math_complex.md
[operator]:    doc/operator.md
[object]:      doc/object.md
[edges]:       doc/object.md#rounded-edges-
[figures]:     doc/object.md#figures-


Installation [^][contents]
--------------------------

You must extract archive and copy 'banded.scad' and folder 'banded/' into a directory
and now you can use it here.

Or you can copy this into the library folder from OpenSCAD for global use.
The path for this directory depends on your system:

| OS       | Path
|----------|------
| Windows: | My Documents\OpenSCAD\libraries
| Linux:   | $HOME/.local/share/OpenSCAD/libraries
| MacOS:   | $HOME/Documents/OpenSCAD/libraries

You can reach this from OpenSCAD menu File->Show Library Folder.


Use [^][contents]
-----------------

### Include library [^][contents]

You can include the whole library with
```OpenSCAD
include <banded.scad>
```
  
You can load a specify libraries with
```OpenSCAD
include <banded/ *** .scad>
```
Or even with `use`. But if you need this defined constants
you must include the file separately.
So you can keep the namespace clean.
```OpenSCAD
use <banded/ ??? .scad>
include <banded/constants.scad>
```


### To consider [^][contents]

This library is designed for OpenSCAD version 2021.01.\
Because of the use of new language features that generates a syntax error
on older OpenSCAD versions, the bibliothek can only used with
version 2021.01 or higher.
OpenSCAD can be downloaded from <https://www.openscad.org/>.


### Compatibility files [^][contents]

If you want to use some new buildin functions from OpenSCAD in older OpenSCAD version
you can include file 'compatibility_???.scad'.
They emulate the missing functions
and don't disturb on newer versions if you have forgotten to remove them.
They are not needed for the library.\
These are in the folder `antiquity`.

#### For OpenSCAD version 2015.03
Emulated functions:
- `is_undef()`
- `is_bool()`
- `is_num()`
- `is_list()`
- `is_string()`
- `is_function()`
- `ord()`
- `assert()` - in another file, generate an error on newer OpenSCAD versions

```OpenSCAD
include <compatibility_v2015.scad>
// If you want use assert()
include <compatibility_v2015_assert.scad>
```

#### For OpenSCAD version 2019.05
Emulated functions:
- `is_function()`
  - returns always `false` in older OpenSCAD versions
    where function literals not exists

```OpenSCAD
include <compatibility_v2019.scad>
```
