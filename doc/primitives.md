Draft objects as data list - Primitives
=======================================

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_primitives.scad`\
` `| . . . . +--> `banded/draft_primitives_basic.scad`\
` `| . . . . +--> `banded/draft_primitives_figure.scad`\
` `| . . . . +--> `banded/draft_primitives_transform.scad`\
` `. . .

[<-- file overview](file_overview.md)

### Contents
[contents]: #contents "Up to Contents"
- [Curves in a point list ->][curves]
- [Transform functions on point list ->][transform]
- [Convert colors ->][color]
- [Multmatrix ->][multmatrix]

- [Primitives in data lists][primitives]
  - [List convention](#list-convention-)
  - [Generate objects](#functions-to-generate-objects-)
  - [Functions to transform objects](#functions-to-transform-objects-)

[curves]:     curves.md
[transform]:  transform.md
[multmatrix]: multmatrix.md
[color]:      color.md
[primitives]: #primitives-


Primitives [^][contents]
------------------------
Functions to create and edit OpenSCAD primitives in lists

These list can set as argument for `polygon()` and `polyhedron()`,
this is implemented in module `build_object()`.
This functions to generate and transform objects have the same behavior
like OpenSCAD modules.

#### List convention [^][contents]
- default:
  - `[ points, [path, path2, ...] ]`
- other:
  - `[ points ]`
  - `[ points, path ]`
  - `[ [points, points2, ...], [path, path2, ...] ]`


### Functions to generate objects [^][contents]
- 2D:
  - `square()`
  - `circle()`
- 3D:
  - `cube()`
  - `cylinder()`
  - `sphere()`
- more objects:
  - `wedge()`

___example:___
```OpenSCAD
include <banded.scad>
x = cylinder (h=10, r=4);
build_object(x);
```


### Functions to transform objects [^][contents]
- `translate()`
- `rotate()`
- `mirror()`
- `scale()`
- `resize()`
- `projection()` - not working yet, only on point lists
- `multmatrix()`


### More functions to transform objects [^][contents]
- All modules from file `operator_transform.scad` as function.
- In file `draft_primitives_transform.scad`.


### Functions to edit objects [^][contents]

. . .


### Not yet implemented, but planned [^][contents]
- `hull()`
- `minkowski()`

- `linear_extrude()`
- `rotate_extrude()`

- `union()`
- `difference()`
- `intersection()`