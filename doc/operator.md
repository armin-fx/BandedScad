Transform and edit objects
==========================

### defined in file

`banded/operator.scad`  
` `|  
` `+--> `banded/operator_edit.scad`  
` `+--> `banded/operator_transform.scad`  
` `+--> `banded/operator_place.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Contents"
- [Transform operator](#transform-operator-)
  - [Transformation modules](#transformation-modules-)
    - [`rotate_new()`][rotate_new]
    - [`rotate_backwards()`][rotate_backwards]
    - [`rotate_at()`][rotate_at]
    - [`rotate_to_vector()`][rotate_to_vector]
    - [`rotate_to_vector_at()`][rotate_to_vector_at]
    - [`mirror_at()`][mirror_at]
    - [`mirror_copy()`][mirror_copy]
    - [`mirror_copy_at()`][mirror_copy_at]
    - [`mirror_repeat()`][mirror_repeat]
    - [`mirror_repeat_copy()`][mirror_repeat]
    - [`skew()`][skew]
    - [`skew_at()`][skew_at]
  - [Transformation with preset defaults](#transformation-with-preset-defaults-)
    - [Transformation operator backwards](#transformation-operator-backwards-)
    - [Transformation at a fixed axis](#transformation-at-a-fixed-axis-)
  - [Comparison same transformation](#comparison-same-transformation-)
    - [Buildin operator modules](#buildin-operator-modules-)
    - [More operator modules](#more-operator-modules-)
- [Place objects](#place-objects-)
  - [`connect()`][connect]
  - [`place()`][place]
  - [`place_line()`][place_line]
  - [`place_copy()`][place_copy]
  - [`place_copy_line()`][place_copy_line]
- [Edit and test objects](#edit-and-test-objects-)
  - [Combine operator](#combine-operator-)
    - [`combine()`][combine]
      - `part_main()`
      - `part_add()`
      - `part_cut()`
      - `part_cut_all()`
      - `part_selfcut()`
      - `part_selfcut_all()`
      - `part_limit()`
    - [`combine_fixed()`][combine_fixed]
    - [`select_object()`][select_object]
  - [Modifying operations](#modifying-operations-)
    - [`xor()`][xor]
    - [`minkowski_difference()`][minkowski_difference]
    - [`hull_difference()`][hull_difference]
    - [`chain()`][chain]
    - [`bounding_box()`][bounding_box]
    - [Split object in 2 parts][split_xxx]
      - `split_top()`
      - `split_bottom()`
      - `split_both()`
  - [2D to 3D extrusion](#2d-to-3d-extrusion-)
    - [`extrude_line()`][extrude_line]
    - [`plain_trace_extrude()`][plain_trace_extrude]
    - [`helix_extrude()`][helix_extrude]


Transform operator [^][contents]
--------------------------------
Contains modules which extend OpenSCAD buildin operator family
and keep the same behavior and option names.

### Transformation modules [^][contents]

#### rotate_new [^][contents]
[rotate_new]: #rotate_new-
Rotate object with additional options.  
Works like `rotate()`.

_Arguments:_
```OpenSCAD
rotate_new (a, v, backwards)
```
- `a` - angle parameter
  - as number: angle to rotate in degrees around an axis, defined in vector `v`
  - as list of 3 angles around a fixed axis `[X,Y,Z]`:
    The rotation is applied in the following order: X then Y then Z.
    Then the argument `v` is ignored.
- `v` - vector where rotating around
- `backwards`
  - `false` - default, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

_You can replace buildin_ `rotate()` _with:_
```OpenSCAD
module rotate(a,v,backwards=false) { rotate_new(a,v,backwards) children(); }
```

#### rotate_backwards [^][contents]
[rotate_backwards]: #rotate_backwards-
Rotate object backwards.

_Arguments:_
```OpenSCAD
rotate_backwards (a, v)
```
Options like `rotate()`.
- `a` - angle
- `v` - vector where rotating around

#### rotate_at [^][contents]
[rotate_at]: #rotate_at-
Rotate object at specific origin position.

_Arguments:_
```OpenSCAD
rotate_at (a, p, v, backwards)
```
- `a` - angle
- `v` - vector where it rotates around
- `p` - origin position at where it rotates
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### rotate_to_vector [^][contents]
[rotate_to_vector]: #rotate_to_vector-
Rotate object from direction Z axis to direction as vector.

_Arguments:_
```OpenSCAD
rotate_to_vector (v, a, backwards, d)
```
- `v` - direction as vector
- `a`
  - angle in degree
  - or rotational orientation vector
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate
- `d` - dimension of the object
  - The operator can not get any data of the children object.
    It must therefore be defined what number of dimensions this has.
  - `3` - 3D object = default
  - `2` - 2D object (must set in this case)

_Way of working in 3D:_
- procedure 1, `a` as angle:
  - vector `v` will split in
    - inclination angle, rotate around Y axis
    - and azimuthal angle, rotate around Z axis
  - make rotation around Y axis with inclination angle
  - make rotation around Z axis with azimuthal angle
  - make rotation around vector `v` with angle `a`

- procedure 2, `a` as orientation vector:
  - make rotation from Z axis to vector `v`
  - make rotation around vector `v`, so that the originally X axis point to
    orientation vector `a`

_Way of working in 2D:_
- rotate the object from direction X axis to vector `v`
- option `a` will be ignored
- the dimension number must be specified with `d=2`,
  since it cannot be determined from the object.

#### rotate_to_vector_at [^][contents]
[rotate_to_vector_at]: #rotate_to_vector_at-
Rotate object from direction Z axis to direction as vector.  
Rotate at a specific origin position.

_Arguments:_
```OpenSCAD
rotate_to_vector_at (v, p, a, backwards)
```
- `v` - direction as vector
- `p` - origin position at where it rotates
- `a` - angle in degree or rotational orientation vector
- `backwards`
  - `false` - standard, normal forward rotate
  - `true`  - rotate backwards, undo forward rotate

#### mirror_at [^][contents]
[mirror_at]: #mirror_at-
Mirror an object along a vector at specific origin position.

_Arguments:_
```OpenSCAD
mirror_at (v, p)
```
- `p` - origin position at where it mirrors
- `v` - mirror along this direction, standard = X axis

#### mirror_copy [^][contents]
[mirror_copy]: #mirror_copy-
Mirror an object at origin along a vector `v`
and keep original object.

_Arguments:_
```OpenSCAD
mirror_copy (v)
```
- `v` - mirror along this direction, standard = X axis

#### mirror_copy_at [^][contents]
[mirror_copy_at]: #mirror_copy_at-
Mirror an object along a vector `v` at origin position `p` and keep original object.

_Arguments:_
```OpenSCAD
mirror_copy_at (v, p)
```
- `p` - origin position at where it mirrors
- `v` - mirror along this direction, standard = X axis

#### mirror_repeat [^][contents]
[mirror_repeat]: #mirror_repeat-
Mirror an object at origin up to 3 times along a vector `v`, then `v2`, `v3`.

_Arguments:_
```OpenSCAD
mirror_repeat (v, v2, v3)
```
- `v`  - mirror along this direction, standard = X axis
- `v2` - 2. mirror direction, optional
- `v3` - 3. mirror direction, optional

#### mirror_repeat_copy [^][contents]
[mirror_repeat_copy]: #mirror_repeat_copy-
Mirror an object at origin up to 3 times along a vector `v`, then `v2`, `v3`
and keep original object.

_Arguments:_
```OpenSCAD
mirror_repeat_copy (v, v2, v3)
```
- `v`  - mirror along this direction, standard = X axis
- `v2` - 2. mirror direction, optional
- `v3` - 3. mirror direction, optional

#### skew [^][contents]
[skew]: #skew-
skew an object.
- default for 3D = shear X along Z
- default for 2D = shear X along Y

_Arguments:_
```OpenSCAD
skew (v, t, m, a, d)
```
- `v` - vector, shear parallel to this axis
  - 3D:
    - as vector
    - standard = Z axis
  - 2D:
    - as vector
    - or as angle in degree
    - same operation like [`rotate_to_vector()`][rotate_to_vector]
    - standard = Y axis
- `t` - target vector, shear direction to this vector
  - 3D:
    - as vector
    - as angle in degree
    - standard = X axis
  - 2D:
    - not needed, undefined
- `m` - skew factor, standard = 0 
- `a` - angle in degree inside (-90 ... 90), alternative to 'm'
- `d` - dimensions of object
  - `3` - spatial (3D)
  - `2` - flat (2D)
  - not set - Try to get this value from the other options.
    Otherwise use 3D.
    It is not possible to get this information from the object.

#### skew_at [^][contents]
[skew_at]: #skew_at-
skew an object in a list at specific origin position.

_Arguments:_
```OpenSCAD
skew_at (v, t, m, a, p, d)
```
see [`skew()`][skew]
- `p` - origin position at where it skews


### Transformation with preset defaults [^][contents]

#### Transformation operator backwards [^][contents]
Contains modules that define known operations with operation backwards.  
Option `backwards` is removed and internally set to `true`.
Name convention: 'base operation' + '_backwards' + 'additional operations'  

| Base function                                  | operation backwards
|------------------------------------------------|---------------------
| `rotate()`, [`rotate_new()`][rotate_new]       | [`rotate_backwards (a, v, d)`][rotate_backwards]
| [`rotate_at()`][rotate_at]                     | `rotate_backwards_at (a, p, v, d)`
| [`rotate_to_vector()`][rotate_to_vector]       | `rotate_backwards_to_vector (v, a)`
| [`rotate_to_vector_at()`][rotate_to_vector_at] | `rotate_backwards_to_vector_at (v, p, a)`

#### Transformation at a fixed axis [^][contents]
Contains modules that define known operations on a fixed axis.  
Name convention: 'function operation name' + '_axis'  
Axis = x, y or z. later named as '?'

##### Basic transformation at fixed axis [^][contents]
| Base module buildin | with fixed axis    | description
|---------------------|--------------------|-------------
| `translate()`       | `translate_? (l)`  | `l` - length to translate
| .                   | `translate_xy (t)` | `t` - 2D position at X and Y axis
| `rotate()`          | `rotate_? (a)`     | `a` - angle to rotate in degree
| `mirror()`          | `mirror_? ()`      |
| `scale()`           | `scale_? (f)`      | `f` - scale factor as numeric value
| `resize()`          | `resize_? (l)`     | `l` - new size of axis

##### More at fixed axis [^][contents]
| Base module                              | with fixed axis                | description
|------------------------------------------|--------------------------------|-------------
| [`rotate_backwards()`][rotate_backwards] | `rotate_backwards_? (a)`       | `a` - angle
| [`rotate_at()`][rotate_at]               | `rotate_at_? (a, p)`           | `a` - angle<br /> `p` - position
| `rotate_backwards_at()`                  | `rotate_backwards_at_? (a, p)` | `a` - angle<br /> `p` - position
| [`mirror_at()`][mirror_at]               | `mirror_at_? (p)`              | `p` - position


### Comparison same transformation [^][contents]

#### Buildin operator modules [^][contents]
[=> OpenSCAD user manual, transformations](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations)

| operator module        | function on lists                        | generating matrix
|------------------------|------------------------------------------|-------------------
| translate()            | [translate_points()][translate_points]   | [matrix_translate()][matrix_translate]
| [rotate()][rotate_new] | [rotate_points()][rotate_points]         | [matrix_rotate()][matrix_rotate]
| mirror()               | [mirror_points()][mirror_points]         | [matrix_mirror()][matrix_mirror]
| scale()                | [scale_points()][scale_points]           | [matrix_scale()][matrix_scale]
| resize()               | [resize_points()][resize_points]         | -
| projection()           | [projection_points()][projection_points] | -
| multmatrix()           | [multmatrix_points()][multmatrix_points] | -

[translate_points]:  draft_transform.md#translate_points-list-v-
[rotate_points]:     draft_transform.md#rotate_points-list-a-v-backwards-
[mirror_points]:     draft_transform.md#mirror_points-list-v-
[scale_points]:      draft_transform.md#scale_points-list-v-
[resize_points]:     draft_transform.md#resize_points-list-newsize-
[projection_points]: draft_transform.md#projection_points-list-plane-
[multmatrix_points]: draft_transform.md#multmatrix_points-list-m-

[matrix_translate]: draft_matrix.md#matrix_translate-v-d-
[matrix_rotate]:    draft_matrix.md#matrix_rotate-a-v-backwards-d-
[matrix_mirror]:    draft_matrix.md#matrix_mirror-v-d-
[matrix_scale]:     draft_matrix.md#matrix_scale-v-d-

#### More operator modules [^][contents]

| operator module                              | function on lists                                          | generating matrix
|----------------------------------------------|------------------------------------------------------------|-------------------
| [rotate_backwards()][rotate_backwards]       | [rotate_backwards_points()][rotate_backwards_points]       | [matrix_rotate_backwards()][matrix_rotate_backwards]
| [rotate_at()][rotate_at]                     | [rotate_at_points()][rotate_at_points]                     | [matrix_rotate_at()][matrix_rotate_at]
| [rotate_to_vector()][rotate_to_vector]       | [rotate_to_vector_points()][rotate_to_vector_points]       | [matrix_rotate_to_vector()][matrix_rotate_to_vector]
| [rotate_to_vector_at()][rotate_to_vector_at] | [rotate_to_vector_at_points()][rotate_to_vector_at_points] | [matrix_rotate_to_vector_at()][matrix_rotate_to_vector_at]
| [mirror_at()][mirror_at]                     | [mirror_at_points()][mirror_at_points]                     | [matrix_mirror_at()][matrix_mirror_at]
| [mirror_copy()][mirror_copy]                 | -                                                          | -
| [mirror_copy_at()][mirror_copy_at]           | -                                                          | -
| [mirror_repeat()][mirror_repeat]             | -                                                          | -
| [mirror_repeat_copy()][mirror_repeat_copy]   | -                                                          | -
| [skew()][skew]                               | [skew_points()][skew_points]                               | [matrix_skew()][matrix_skew]
| [skew_at()][skew_at]                         | [skew_at_points()][skew_at_points]                         | [matrix_skew_at()][matrix_skew_at]

[rotate_backwards_points]:    draft_transform.md#rotate_backwards_points-list-a-v-
[rotate_at_points]:           draft_transform.md#rotate_at_points-list-a-p-v-backwards-
[rotate_to_vector_points]:    draft_transform.md#rotate_to_vector_points-list-v-a-backwards-
[rotate_to_vector_at_points]: draft_transform.md#rotate_to_vector_at_points-list-v-p-a-backwards-
[mirror_at_points]:           draft_transform.md#mirror_at_points-list-v-p-
[skew_points]:                draft_transform.md#skew_points-list-v-t-m-a-
[skew_at_points]:             draft_transform.md#skew_at_points-list-v-t-m-a-p-

[matrix_rotate_backwards]:    draft_matrix.md#matrix_rotate_backwards-a-v-d-
[matrix_rotate_at]:           draft_matrix.md#matrix_rotate_at-a-p-v-backwards-d-
[matrix_rotate_to_vector]:    draft_matrix.md#matrix_rotate_to_vector-v-a-backwards-
[matrix_rotate_to_vector_at]: draft_matrix.md#matrix_rotate_to_vector_at-v-p-a-backwards-
[matrix_mirror_at]:           draft_matrix.md#matrix_mirror_at-v-p-d-
[matrix_skew]:                draft_matrix.md#matrix_skew-v-t-m-a-d-
[matrix_skew_at]:             draft_matrix.md#matrix_skew_at-v-t-m-a-p-d-


Place objects [^][contents]
---------------------------
Modules which place objects in specific position

#### connect [^][contents]
[connect]: #connect-
Move and rotate an object to a specific position.

_Arguments:_
```OpenSCAD
connect (point, direction, orientation)
```

_3D:_  
The origin from the object will be moved to position `point`.  
The Z-axis from the object is the arrow direction, it will be rotated into the vector of `direction`.  
The X-axis is the direction of rotation, it will be rotated around the arrow direction to the point `orientation`.

_2D:_  
The origin from the object will be moved to position `point`.  
The X-axis from the object is the arrow direction, it will be rotated into the vector of `direction`.

#### place [^][contents]
[place]: #place-points-
Places the objects successively at the specified `points` in the list.  
Object 1 set to point 1, object 2 set to point 2, and so on.

_Arguments:_
```OpenSCAD
place (points)
```

#### place_line [^][contents]
[place_line]: #place_line-direction-distances-
Places the objects successively onto a line at the specified distances in the list.

_Arguments:_
```OpenSCAD
place_line (direction, distances)
```
- `direction` - direction of the line
- `distances`
  - distances as a list
    place the specific objects at given distance in a list
  - distances as a numeric value
    place all objects at this distance

_There exist specialized modules which places objects along a fixed axis at the specified distances:_  
`place_? (distances)`  
'?' means the axis. Axis = x, y or z.

#### place_copy [^][contents]
[place_copy]: #place_copy-points-
Places copies of an object at given `points` in the list.  

_Arguments:_
```OpenSCAD
place_copy (points)
```

#### place_copy_line [^][contents]
[place_copy_line]: #place_copy_line-direction-distances-
Places copies of an objects onto a line at given distances in the list.

_Arguments:_
```OpenSCAD
place_copy_line (direction, distances)
```
- `direction` - direction of the line
- `distances` - distances as a list

_There exist specialized modules which places copies of an object along a fixed axis at given distances:_  
`place_copy_? (distances)`  
'?' means the axis. Axis = x, y or z.


Edit and test objects [^][contents]
-----------------------------------

### Combine operator [^][contents]

#### combine [^][contents]
[combine]: #combine-
This will add or remove parts from a main object.  
Inside a combine block you can define multiple parts
to add or remove in any order.
Add a predicate like `part_main()` (for a main object),
`part_add()` or `part_cut()` to each object.

_Example:_
```OpenSCAD
include <banded.scad>

$fn=24;
combine()
{
	part_main()
		cube([5,5,2], center=true);
	part_add()
		cylinder(d=3, h=4, center=true);
	part_cut()
		cylinder(d=4, h=3, center=true);
}
```

You can put these parts into a module, they will selected in the right order.
This is useful to edit a main object with additional parts.
The parts will always edit the main object, defined by `part_main()`.
But you can define elements, they can additional edit the additional parts.
You can put sibling parts together into a module or into an `union()` block
and additional edit these with specialized part predicates.

_Defined part elements:_
- `part_main()`
  - defines the main object to edit
  - all operations will done on this object
- `part_add()`
  - add an object
- `part_cut()`
  - remove a part from the main object
  - do nothing with all added objects
- `part_cut_all()`
  - remove a part from the main object
  - remove from all other parts,
    except from the own sibling parts, defined in the same module
- `part_selfcut()`
  - remove a part from the main object
  - remove from the own sibling parts, defined in the same module
  - do nothing with all other parts
  - this is useful e.g.
    if a hole must bored through the main object _and_ the added part
- `part_selfcut_all()`
  - remove a part from the main object
  - remove from all added parts, inclusive the own sibling parts
- `part_limit()`
  - defines a common hull for the main object,
    all parts they exceed this object will be removed
  - if you use this element, you _must_ set parameter `combine (limit=true)`

_Example:_
```OpenSCAD
include <banded.scad>

$fn=24;
combine()
{
	part_main()
		cube([11,5,4], center=true);
	
	translate_x( 3) tube_element();
	translate_x(-3) tube_element();
}

module tube_element ()
{
	part_add()
		translate_z(1)
		cylinder (d=3, h=5);
	
	part_cut()
		cylinder (d=4, h=5);
	
	part_selfcut()
		translate_z(-3)
		cylinder (d=2, h=10);
}
```

_Arguments:_
```OpenSCAD
combine (limit, type, select)
```
- `limit`
  - if set `true`, combine uses the element `part_limit()`
    to define a common hull for the main object
  - default = `false`, ignore `part_limit()`
  - this is necessary to prevent errors, mostly `part_limit()` is not used
- `type`
  - you can select one part element, only this parts will shows
  - e.g. for debug reason
  - the types are defined in constants:
    - `combine_type_undef` - default, normal working, no selecting
    - `combine_type_main`  - only main part
    - `combine_type_add`   - only added parts
    - `combine_type_cut`   - only removed parts
    - `combine_type_cut_all`
    - `combine_type_selfcut`
    - `combine_type_selfcut_all`
    - `combine_type_limit` - only common hull parts
- `select`
  - you can select a number of children in the combine block,
    then only these are used
  - as number: this children position is used
  - as list: only the children in the list are used
  - a negative number will count from the last children backwards,
    e.g. `-1` = last children

#### combine_fixed [^][contents]
[combine_fixed]: #combine_fixed-
Put parts together to a main object in a fixed order.  
This is helpful, if more than one operator is needed to do this.
You can create a hole to the main object and put a part on this.
Maybe you can define a common hull for the complete object and
cut all parts outside of.
Every place on this operator has his own operator.
You can "jump over" a place with the defined module `empty()`.

_Sequence of operator:_
```OpenSCAD
combine() { main_object(); adding_part(); cutting_part(); common_hull(); }
```

_Example:_
```OpenSCAD
include <banded.scad>
$fn=24;
d_inner=4;

combine()
{
	cube_extend([7,7,2], align=[0,0,-1]);
	tube       (h=2, di=d_inner, w=1);
	cylinder   (h=6, d =d_inner, center=true);
}
```

#### select_object [^][contents]
[select_object]: #select_object-
Chose one object on given position.  

_Arguments:_
```OpenSCAD
select_object (i)
```

_Usage:_
```OpenSCAD
// select one object, in this case number 1, the sphere
i = 1;

select_object (i)
{
	cube();     // i==0
	sphere();   // i==1
	cylinder(); // i==2
}
```


### Modifying operations [^][contents]

#### xor [^][contents]
[xor]: #xor-
Create the exclusive or with objects.  
Experimental, works with up to 8 objects and make sometimes errors.

_Arguments:_
```OpenSCAD
xor (d, skirt)
```
- `d`     - dimension of the objects, default = `3` - 3D object
- `skirt` - optional, create a little skirt around the object to prevent errors
  - default = constant `epsilon`

#### minkowski_difference [^][contents]
[minkowski_difference]: #minkowski_difference-
Removes shapes from a base shape surface.  
Takes a base shape and one or more diff shapes,
carves out the diff shapes from the surface of the base shape,
in a way complementary to how `minkowski()` unions shapes to the surface of its base shape.

_Arguments:_
```OpenSCAD
minkowski_difference (d, convexity)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `convexity`
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.

#### hull_difference [^][contents]
[hull_difference]: #hull_difference-
Create a difference from the convex hull of an object and the object itself.  
Experimental, make sometimes errors.

_Arguments:_
```OpenSCAD
hull_difference (d=3, skirt=epsilon)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `skirt` - optional, create a little skirt around the object to prevent errors
  - default = constant `epsilon`

#### chain [^][contents]
[chain]: #chain-
Fill the space between each object pair.  
Experimental, make sometimes errors.

_Arguments:_
```OpenSCAD
chain (d=3, skirt=epsilon)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `skirt` - optional, create a little skirt around the object to prevent errors
  - default = constant `epsilon`

#### bounding_box [^][contents]
[bounding_box]: #bounding_box-
Create the smallest bounding box of an object.

_Arguments:_
```OpenSCAD
bounding_box (d, height)
```
- `d`
  - dimension of the objects
    - `3` - 3D object, default
    - `2` - 2D object
- `height`
  - for internal use, any size greater then the biggest lenght of the object
  - default = `1000`


#### Split object in 2 parts: [^][contents]
[split_xxx]: #split-object-in-2-parts-
This will split a main object on the contour of a split object.  
There will create 2 objects:
- The inner part = an intersection of main object and split object
- The outer part = cut split object from main object
You can define a gap between both objects.  
If you define a gap, you must make the split object little bigger
then the main object, on parts where you won't carve out the gap.
Another way is to set the balance to `1`, carve the gap only on outer part.

_Operator:_
- `split_inner (gap, balance)`
  - Create the inner part
- `split_outer (gap, balance)`
  - Create the outer part

_Helper operator:_
- `split_both  (gap, balance)`
  - Create the inner part and outer part together
  - Useful for test reason

_Sequence of operator:_
```OpenSCAD
split_xxx() { split_object(); main_object(); }
```

_Arguments:_
- gap     = the gap between both parts, default = `0`
- balance = balance between inner and outer parts `-1 ... 0 ... 1`
  - ` 0` = carve out both parts half, default
  - `-1` = carve only inner part
  - `+1` = carve only outer part

_Example:_
```OpenSCAD
gap    = 0.5;
height = 1;

include <banded.scad>

module main (c)
{
	cube ([15,10,height]);
}
module split () union()
{
	$fn=24;
	translate([ 0,5,-gap]) cylinder (h=height + 2*gap, d=6);
	translate([ 5,5,-gap]) cylinder (h=height + 2*gap, d=6);
	translate([10,5,-gap]) cylinder (h=height + 2*gap, d=6);
}

%split();
//
split_inner (gap=gap) { split(); main(); }
split_outer (gap=gap) { split(); main(); }
```


### 2D to 3D extrusion [^][contents]

#### extrude_line [^][contents]
[extrude_line]: #extrude_line-
Extrudes and rotates the 2D object along the line.  
The object will rotate around the arrow direction of the line
till the stretched surface from X-axis of the 2D-object and the line
will touch the point of `rotational`.

_Arguments:_
```OpenSCAD
extrude_line (line, rotational, convexity, extra_h)
```
- `line` - list with 2 points `[from, to]`
- `rotational` - a vector, standard = X-axis
- `extra_h`
  - the line will make longer this length at both ends
  - default = `0`
- `convexity`
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.

#### plain_trace_extrude [^][contents]
[plain_trace_extrude]: #plain_trace_extrude-
This will extrude an 2D-object in the X-Y plane along a 2D-trace
(keeping only the right half, X >= 0).
Note that the object started on the X-Y plane but is tilted up
(rotated +90 degrees around the X-axis) to extrude,
then the new Y-axis is the direction which will set in the direction of the line.

_Arguments:_
```OpenSCAD
plain_trace_extrude (trace, range, closed, convexity, limit)
```
- `trace` - 2D point list, which compose the line
- `range` - index range of the trace used to extrude
  - You can use a part of the line `[first_point, last_point]`
  - negative indices will count backwards from the end of the trace
  - default = `[0, -1]` the complete trace from the first to last point
- `closed`
  - `true`  - the trace is a closed loop, the last point connect the first point
  - `false` - the trace from first to last point, default
- `convexity`
  - Integer. The convexity parameter specifies the maximum number
    of front sides (or back sides) a ray intersecting the object might penetrate.
- `limit` - internal parameter
  - The module knows nothing about the children to extrude,
    so internal objects to work on this must made much bigger then the
    children could be.
    The `limit` parameter can set to an other value if these internal objects
    are to small.
  - default = `1000`

_Specialized modules:_
- `plain_trace_extrude_open (trace, range, convexity, limit)`
  - This will keep the ends open
  - same as `plain_trace_extrude()` with `closed` set to the default `false`
- `plain_trace_extrude_closed (trace, range, convexity, limit)`
  - This will connect both ends to a closed trace.
  - like `plain_trace_extrude()` with `closed` set to `true`

#### helix_extrude [^][contents]
[helix_extrude]: #helix_extrude-
Creates a helix with a 2D-polygon similar rotate_extrude.  
This will generate every segment with operation `hull()` on the 2D-polygon ends.
It makes sometimes trouble when you want to render the object.
If you can it is maybe better to use the _function_
[`helix_extrude()`](draft_primitives.md#helix_extrude-).

modified from Gael Lafond, <https://www.thingiverse.com/thing:2200395>  
License: CC0 1.0 Universal

_Arguments:_
```OpenSCAD
helix_extrude (angle, rotations, pitch, height, r, opposite, orientation, slices, convexity, scope, step)
```
- `angle`     - angle of helix in degrees - default: `360`
- `rotations` - rotations of helix, can be used instead `angle`
- `height`    - height of helix - default: 0 like `rotate_extrude()`
- `pitch`     - rise per rotation
- `r`
  - radius as number or `[r1, r2]`
  - `r1` = bottom radius, `r2` = top radius
- `opposite`  - if `true` reverse rotation of helix, default = `false`
- `orientation`
  - if `true`, orientation of Y-axis from the 2D-polygon is set along the surface of the cone.
  - `false` = default, orientation of Y-axis from the 2D-polygon is set to Z-axis
- `slices`    - count of segments from helix per full rotation
- `convexity`
  - `0` - only concave polygon (default)
  - `1` - can handle one convex polygon only
  - `2` - can maybe handle more then one convex polygon
    - This will slice the 2D-polygon in little pieces and hope they are concave.  
      Experimental with some problems.  
      It's better to split it in concave helixes with the same parameter
      and make the difference with it.

