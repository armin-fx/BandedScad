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

Main functionality:
- [More control of the level of detail for a mesh][extend],
    extend the control of number of facets used to generate an arc
- [Useful constants][constants]
- [Configurable object modules][object]
  - [Figures][figures] (torus, wedge, funnel, ... )
  - [Rounded and chamfered edges][edges]
- [Transform and edit objects][operator]
- Draft objects in data lists
  - [Create curves][curves] into a point list with functions.
    These can load with `polygon()`
  - [Create surfaces][surface] as data list with functions.
    These can load with `polyhedron()`
  - [Transform objects in a point list][transform] with affine transformations.
    Like transformation operator in OpenSCAD for object modules.
  - Create and edit buildin [primitives from OpenSCAD with functions][primitives]
    as data in a list.  
    _(not finished yet)_
  - [Generate matrices for multmatrix][multmatrix]
  - [Convert colors][color]
- [Editing lists][list]
  - Most functions base on the STL from C++
- [Edit and convert strings][string]
- [Math functions][math]
  - [Various common math functions][math_common]
  - Functions for [vector][vector] and [matrices][matrix]
  - Functions for [polygons and lines][polygon]
  - Calculate with [complex numbers][complex]
  - [Algorithm with function literals][function]
- [Math operations on lists][list_math]
- [Helper functions][helper]
- [Debug methods][debug]
- [Benchmark functions for speed][benchmark]
- [Versioning methods][version]

Separate stuff:
- [Compatibility files][antiquity]
  to use some new buildin functions from OpenSCAD in older OpenSCAD version

[extend]:      doc/extend.md
[constants]:   doc/constants.md
[draft]:       doc/draft.md
[curves]:      doc/draft_curves.md
[surface]:     doc/draft_surface.md
[transform]:   doc/draft_transform.md
[multmatrix]:  doc/draft_matrix.md
[primitives]:  doc/draft_primitives.md
[color]:       doc/color.md
[list]:        doc/list.md
[list_math]:   doc/list_math.md
[mean]:        doc/list_mean.md
[string]:      doc/string.md
[helper]:      doc/helper.md
[debug]:       doc/debug.md
[benchmark]:   doc/debug.md#benchmark-function-
[math]:        doc/math.md
[math_common]: doc/math.md#various-math-functions-
[vector]:      doc/math_vector.md
[matrix]:      doc/math_matrix.md
[polygon]:     doc/math_polygon.md
[function]:    doc/math_function.md
[complex]:     doc/math_complex.md
[operator]:    doc/operator.md
[object]:      doc/object.md
[edges]:       doc/object.md#rounded-edges-
[figures]:     doc/object.md#figures-
[version]:     doc/version.md
[antiquity]:   doc/antiquity.md


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

You can specify for which version of BandedSCAD you created your model.
Then this will yield an assert, if the current version is not compatible.
```OpenSCAD
include <banded.scad>
required_version ("3.7");
```


### To consider [^][contents]

This library is designed for OpenSCAD version 2021.01.  
Because of the use of new language features that generates a syntax error
on older OpenSCAD versions, the bibliothek can only used with
version 2021.01 or higher.
OpenSCAD can be downloaded from <https://www.openscad.org/>.

