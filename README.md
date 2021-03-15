
BandedScad
==========

BandedScad is a OpenScad library.
It contains functions and modules to make OpenScad easier to use.

### Contents
[contents]: #contents "Up to Contents"
[What it does](#what-it-does-)\
[Installation](#installation-)\
[Use](#use-)


What is does [^][contents]
--------------------------

- [More control of the level of detail for a mesh][extend],
    extend the control of number of facets used to generate an arc
- Contains functions to [draft objects in a point list][draft]
  - Create [curves][curves] in a point list with functions.
    These can load with `polygon()`
  - [Transform][transform] objects in a point list with affine transformations.
    Like transformation operator in OpenScad for object modules.
  - Contains functions for working with [multmatrix][multmatrix]
- Contains some functions for [edit and work with lists][list]
- Contains some [math][math] and helper functions
  - More math functions
  - Functions for [matrices and vector][matrix]
  - Work with [complex numbers][complex]
- Contains modules to [transform and edit objects][operator]
- Contains some configurable object modules

[file overview -->](doc/file_overview.md)

[extend]:     doc/extend.md
[draft]:      doc/draft.md
[curves]:     doc/draft.md#curves-
[transform]:  doc/draft.md#transform-functions-
[multmatrix]: doc/draft.md#multmatrix-
[list]:       doc/list.md
[math]:       doc/math.md
[matrix]:     doc/matrix.md
[complex]:    doc/complex.md
[operator]:   doc/operator.md

Installation [^][contents]
--------------------------

You must extract archive and copy 'banded.scad' and folder 'banded/' into a directory
and now you can use it here.
  
Or you can copy this into the library folder from OpenScad for global use.
The path for this directory depends on your system:

| OS       | Path
|----------|------
| Windows: | My Documents\OpenSCAD\libraries
| Linux:   | $HOME/.local/share/OpenSCAD/libraries
| MacOS:   | $HOME/Documents/OpenSCAD/libraries

You can reach this from OpenScad menu File->Show Library Folder.


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

### Compatibility [^][contents]

If you want to use some new buildin functions from OpenScad in older OpenScad version
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