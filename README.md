BandedScad
==========

BandedScad is an OpenSCAD library.
It contains functions and modules to extend the OpenSCAD language.

### Contents
[contents]: #contents "Up to Contents"
[What it does](#what-it-does-)\
[Installation](#installation-)\
[Use](#use-)


What it does [^][contents]
--------------------------

- [More control of the level of detail for a mesh][extend],
    extend the control of number of facets used to generate an arc
- [Draft objects in a point list][draft]
  - [Create curves][curves] in a point list with functions.
    These can load with `polygon()`
  - Create and edit objects as data in a list (not finished yet)
  - [Transform objects in a point list][transform] with affine transformations.
    Like transformation operator in OpenSCAD for object modules.
  - [Working with multmatrix][multmatrix]
- [Transform and edit objects][operator]
- Configurable object modules
- [Edit and work with lists][list]
- [Edit and convert strings][string]
- [Math functions][math]
  - [More common math functions][math_common]
  - Functions for [matrices and vector][matrix]
  - Work with [complex numbers][complex]
- [Helper functions][helper]
- [Benchmark functions for speed][benchmark]

[file overview -->](doc/file_overview.md)

[extend]:      doc/extend.md
[draft]:       doc/draft.md
[curves]:      doc/draft.md#curves-
[transform]:   doc/draft.md#transform-functions-on-point-lists-
[multmatrix]:  doc/draft.md#multmatrix-
[list]:        doc/list.md
[string]:      doc/string.md
[helper]:      doc/helper.md
[benchmark]:   doc/helper.md#benchmark-function-
[math]:        doc/math.md
[math_common]: doc/math.md#more-math-functions-
[matrix]:      doc/matrix.md
[complex]:     doc/complex.md
[operator]:    doc/operator.md

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
It can used with OpenSCAD version 2019.05 or above but without new language features.\
OpenSCAD can be downloaded from <https://www.openscad.org/>.


### Compatibility files [^][contents]

If you want to use some new buildin functions from OpenSCAD in older OpenSCAD version
you can include file 'compatibility_???.scad'.

#### For OpenSCAD version 2015.03
```OpenSCAD
include <compatibility_v2015.scad>
// If you want use assert()
include <compatibility_v2015_assert.scad>
```

#### For OpenSCAD version 2019.05
```OpenSCAD
include <compatibility_v2019.scad>
```
