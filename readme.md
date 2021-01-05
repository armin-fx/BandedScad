ScadTools
=========

ScadTools is a OpenScad library.
It contains functions and modules to make OpenScad easier to use.


What is does
------------

- extend the control of number of facets used to generate an arc
- contains some math and helper functions
- contains some functions for editing lists
- contains some functions and modules transform and edit objects
- contains some configurable object modules


Installation
------------

You must extract archive 'tools.scad' and folder 'tools/' into a directory
and now you can use it here.
  
Or you can copy this into the library folder from OpenScad for global use
The path for this directory depends on your system:

| OS       | Path |
|----------|------|
| Windows: | My Documents\OpenSCAD\libraries       |
| Linux:   | $HOME/.local/share/OpenSCAD/libraries |
| MacOS:   | $HOME/Documents/OpenSCAD/libraries    |
  
You can reach this from OpenScad menu File->Show Library Folder.


Use
---

You can include the whole library with
```OpenSCAD
include <tools.scad>
```
  
You can load a specify libraries with
```OpenSCAD
include <tools. *** .scad>
```
Or even with `use`. But if you need this defined constants
you must include the file separately.
So you can keep the namespace clean.
```OpenSCAD
use <tools. *** .scad>
include <tools/constants.scad>
```
  
If you want to use some new functions from OpenScad from version 2019.05 in version 2015.03
you can include file 'compatibility.scad'.
```OpenSCAD
include <compatibility.scad>
```

