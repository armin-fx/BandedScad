Control the level of detail of a mesh
=====================================

### defined in file

```tools/extend.scad```

### Contents
[Extra special Variables](#special-variables)<br>
[Defined modules](#defined-modules)<br>
[Functions](#functions)<br>


Special variables
-----------------

The buildin special variables in OpenScad ```$fa```, ```$fs``` and ```$fn``` special variables
control the number of facets used to generate an arc.
This contains extra special variables and functions to control the level of detail
and defines modules to extend the buildin objects like ```circle()``` and ```cylinder()```.
  
By default all extra special variables are set off to keep compatibility with
original functionality from OpenSCAD.
If ```$fn``` is defined, this value will be used and the other variables are ignored,
and a full circle is rendered using this number of fragments.
Variables can set off with ```0```.

 | variable          | description
 |-------------------|-------------
 | ```$fn_min```     | number of fragments which will will never lesser then this value
 | ```$fn_max```     | number of fragments which will never bigger then this value
 | ```$fd```         | to control the distance of deviation from model. created as maximum of distance in mm which will not exceeded
 | ```$fa_enabled``` | ```$fa``` can be switch off when set with ```false```
 | ```$fs_enabled``` | ```$fs``` can be switch off when set with ```false```
 | ```$fn_safe```    | if all special variables are off, this number of fragments will be used. standard = 12

Defined modules
---------------
Keep compatibility with buildin modules in OpenScad with same arguments and can controled with extra
special variables, some modules have extra arguments

 | buildin          | extended
 |------------------|----------
 | ```circle()```   | ```circle_extend()```
 | ```cylinder()``` | ```cylinder_extend()```
 | ```sphere()```   | ```sphere_extend()```

### circle_extend():
### cylinder_extend():
### sphere_extend():

Functions
------------------
...
