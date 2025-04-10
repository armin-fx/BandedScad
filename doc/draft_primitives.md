Draft objects as data list - Primitives
=======================================

### defined in file
`banded/draft.scad`  
` `|  
` `+--> `banded/draft_primitives.scad`  
` `| . . . . +--> `banded/draft_primitives_basic.scad`  
` `| . . . . +--> `banded/draft_primitives_figure.scad`  
` `| . . . . +--> `banded/draft_primitives_transform.scad`  
` `| . . . . +--> `banded/draft_primitives_operator.scad`  
` `. . .  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Primitives in data lists](#primitives-)
  - [List convention](#list-convention-)
  - [Generate objects](#functions-to-generate-objects-)
    - Buildin OpenSCAD primitives
    - More configurable primitives
    - Create object with [`build()`][build]
  - [Edit objects based on OpenSCAD buildin modules](#edit-objects-based-on-openscad-buildin-modules-)
  - [Edit objects](#edit-objects-)
    - Defined transform operations
    - [`helix_extrude()`][helix_extrude]

[align]:     extend.md#extra-arguments-
[special_x]: extend.md#special-variables-


Primitives [^][contents]
------------------------

Functions to create and edit OpenSCAD primitives in lists.

These list can set as argument for `polygon()` and `polyhedron()`,
this is implemented in module `build()`.
This functions to generate and transform objects have the same behavior
like OpenSCAD modules.

#### List convention: [^][contents]
Default:
- as points-path-list  
  `[  points,              [path, path2, ...], color ]`
- as traces list  
  `[ [trace, trace2, ...], undef,              color ]`

Other:
- `[ points ]`
- `[ points, path ]`
- `[ [points, points2, ...], [path, path2, ...] ]`

Color:
- color as list in `[red, green, blue]` or `[red, green, blue, alpha]`
- color entries as value between `0...1`, where
  - `0` = dark
  - `1` = bright

### Functions to generate objects [^][contents]

2D:
- [`square()`](extend.md#square_extend-)
- [`circle()`](extend.md#circle_extend-)
- [`text()`][text] _not fully implemented_

3D:
- [`cube()`](extend.md#square_extend-)
- [`cylinder()`](extend.md#cylinder_extend-)
- [`sphere()`](extend.md#sphere_extend-)

More objects:
- 2D
  - [`triangle()`](object.md#triangle-)
  - [`ring()`](object.md#ring-)
- 3D
  - [`wedge()`](object.md#wedge-)
  - [`wedge_freecad()`](object.md#wedge_freecad-)
  - [`torus()`](object.md#torus-)
  - [`tube()`](object.md#tube-)
  - [`funnel()`](object.md#funnel-)
- Miscellaneous
  - [`bounding_square()`](object.md#bounding_square-)
  - [`bounding_cube()`](object.md#bounding_cube-)

Example:
```OpenSCAD
include <banded.scad>

a = cylinder (h=10, r=4);
b = translate (a, v=[10,0,0]);
c = color (b, "yellowgreen");

build(a);
build(c);
```

#### build [^][contents]
[build]: #build-
Create a real object from object in list.  
The object can be in 2D or 3D.
It will send to `polygon()` or `polyhedron()` and become the defined color.

_Arguments:_
```OpenSCAD
build (object, convexity)
```

#### text [^][contents]
[text]: #text-
Create a text as 2D object.  
It can only use fonts created as data object in `*.scad` files.

_Arguments:_
```OpenSCAD
text (text, font)
```
- `text`
  - String. The text to generate.
- `font`
  - font data object of the font that should be used.
  - String. The name of the font that should be used.  
    Fonts are specified by their logical font name;
    in addition a style parameter can be added to select
    a specific font style like "__bold__" or "_italic_", such as:  
    `font="Liberation Sans:style=Bold Italic"`
- `$fn`
  - used for subdividing the curved path segments provided by freetype

_Fonts:_
- _Libbard_ family: _Libbard Sans_, _Libbard Serif_, _Libbard Sans Narrow_, and _Libbard Mono_
  - It's a clone of the font family _Liberation_.  
    This font is not finished yet, it contains all letters
    `0x20` (Space) to `0xFF`, different spacing between
    different letters is not implemented but planned.
    Tho goal is to get completely the same behavior like
    the buildin module 'text()'.
  - _Liberation_ is licensed by: SIL Open Font License
  - _Libbard Sans_ style _Regular_ is the default font.
    It's already included.
  - All other fonts are predefined, but must included at first when used,
    before `include <banded.scad>`.
    Elsewise a message will shown with include details.
  - You can write the name "Liberation", this will be renamed to "Libbard"
    for compatibility reason with buildin module `text()`
  - The font files are divided into families.  
    You can load the whole _Libbard_ family with:
    ```OpenSCAD
    include <banded/fonts/libbard.scad>
    ```
    You can load a specific font name, which contains all styles:
    | name                | file
    |---------------------|------
    | Libbard Sans        | `banded/fonts/libbard_sans.scad`
    | Libbard Serif       | `banded/fonts/libbard_serif.scad`
    | Libbard Sans Narrow | `banded/fonts/libbard_sans_narrow.scad`
    | Libbard Mono        | `banded/fonts/libbard_mono.scad`
    
    You can even load a specific font name with a specific style:
    | name                | style       | font data object                       | file in folder `banded/fonts/`
    |---------------------|-------------|----------------------------------------|--------------------------------
    | Libbard Sans        | Regular     | `font_libbard_sans_regular`            | `libbard_sans_regular.scad`
    | .                   | Bold        | `font_libbard_sans_bold`               | `libbard_sans_bold.scad`
    | .                   | Italic      | `font_libbard_sans_italic`             | `libbard_sans_italic.scad`
    | .                   | Bold Italic | `font_libbard_sans_bold_italic`        | `libbard_sans_bold_italic.scad`
    | Libbard Serif       | Regular     | `font_libbard_serif_regular`           | `libbard_serif_regular.scad`
    | .                   | Bold        | `font_libbard_serif_bold`              | `libbard_serif_bold.scad`
    | .                   | Italic      | `font_libbard_serif_italic`            | `libbard_serif_italic.scad`
    | .                   | Bold Italic | `font_libbard_serif_bold_italic`       | `libbard_serif_bold_italic.scad`
    | Libbard Sans Narrow | Regular     | `font_libbard_sans_narrow_regular`     | `libbard_sans_narrow_regular.scad`
    | .                   | Bold        | `font_libbard_sans_narrow_bold`        | `libbard_sans_narrow_bold.scad`
    | .                   | Italic      | `font_libbard_sans_narrow_italic`      | `libbard_sans_narrow_italic.scad`
    | .                   | Bold Italic | `font_libbard_sans_narrow_bold_italic` | `libbard_sans_narrow_bold_italic.scad`
    | Libbard Mono        | Regular     | `font_libbard_mono_regular`            | `libbard_mono_regular.scad`
    | .                   | Bold        | `font_libbard_mono_bold`               | `libbard_mono_bold.scad`
    | .                   | Italic      | `font_libbard_mono_italic`             | `libbard_mono_italic.scad`
    | .                   | Bold Italic | `font_libbard_mono_bold_italic`        | `libbard_mono_bold_italic.scad`


### Edit objects based on OpenSCAD buildin modules [^][contents]

_Argument convention:_
- `transform_function (object, transform_arguments)`

_Implemented functions:_
- `translate (object, v)`
- `rotate    (object, a, v, backwards)`
- `mirror    (object, v)`
- `scale     (object, v)`
- `resize    (object, newsize)`
- `projection()` - not working yet, only on point lists
- `multmatrix(object, m)`
- `color     (object, c, alpha)`
- `hull      (object)`
- [`linear_extrude (object, height, center, twist, slices, scale, align)`][linear_extrude]
- [`rotate_extrude (object, angle, slices)`][rotate_extrude]

_Not yet implemented:_
- `union()`
- `difference()`
- `intersection()`
- `minkowski()`
- `offset()`

#### linear_extrude [^][contents]
[linear_extrude]: #linear_extrude-
Extrudes a 2D object in a list to a 3D solid object.  
Uses the same arguments like buildin module
[`linear_extrude()`](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_the_2D_Subsystem#linear_extrude)
in OpenSCAD.  
Returns a list with object data.

_Arguments:_
```OpenSCAD
linear_extrude (object, height, center, twist, slices, scale, align)
```
- `object` - 2D data object or a trace as point list
- `slices`
   - count of segments, optional, without specification it will set automatically
- `align`
  - Side from origin away that the part should be.
    Configures only the Z-Axis, all other axis will be ignored.
  - [Extra arguments - align][align]

#### rotate_extrude [^][contents]
[rotate_extrude]: #rotate_extrude-
Rotational extrudes a 2D hull as trace in a point list
around the Z axis to a 3D solid object.  
Uses the same arguments like
[`rotate_extrude()`](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_the_2D_Subsystem#rotate_extrude)
in OpenSCAD.  
Returns a list with object data.

_Arguments:_
```OpenSCAD
rotate_extrude (object, angle, slices)
```
- `object` - 2D data object or a trace as point list
- `angle` - drawn angle in degree, default=`360`
  - as number -> angle from `0` to `angle` = opening angle
  - as list   -> range `[opening angle, begin angle]`
- `slices`
   - count of segments, optional, without specification it will set automatically
   - with `"x"` includes the [extra special variables][special_x]
     to automatically control the count of segments

_Modified version:_
- `rotate_extrude_extend (object, angle, slices)`
  - see [`rotate_extrude_extend()`](extend.md#rotate_extrude_extend-)
  - Objects created with `rotate_extrude()` are rotated differently
    as e.g. the object `cylinder()`.
    With `rotate_extrude_extend()` these objects can be connected correctly.
  - `slices` is set by default to `"x"`

### Edit objects [^][contents]

All modules from file
[`operator_transform.scad`](operator.md#transform-operator- "Transform operator for affine transformations")
as function.  
In file `draft_primitives_transform.scad`.

_Implemented transformations:_
- `rotate              (object, a, v, backwards)`
- `rotate_backwards    (object, a, v)`
- `rotate_at           (object, a, p, v, backwards)`
- `rotate_to_vector    (object, v, a, backwards)`
- `rotate_to_vector_at (object, v, p, a, backwards)`
- `mirror_at (object, v, p)`
- `skew    (object, v, t, m, a)`
- `skew_at (object, v, t, m, a, p)`

_Implemented, but needs rework:_
- `mirror_copy        (object, v)`
- `mirror_copy_at     (object, v, p)`
- `mirror_repeat      (object, v, v2, v3)`
- `mirror_repeat_copy (object, v, v2, v3)`

_Implemented operations:_
- [`helix_extrude (object, angle, rotations, pitch, height, r, opposite, orientation, slices)`][helix_extrude]
- [`color_between (object, c, c2, t, alpha)`](color.md#color_between-)

#### helix_extrude [^][contents]
[helix_extrude]: #helix_extrude-
Creates a helix with a 2D-polygon as trace similar rotate_extrude.  
Returns a list with object data.  
[Version as module, experimental](operator.md#helix_extrude-)

_Arguments:_
```OpenSCAD
helix_extrude (object, angle, rotations, pitch, height, r, opposite, orientation, slices)
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

