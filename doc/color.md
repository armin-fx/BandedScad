Color
=====

### defined in file
`banded/color.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Convert colors](#convert-colors-)
  - [`get_color`][get_color]
  - [`color_extend`][color_extend]
  - [`get_color_between`][color_between]
  - [`color_between`][color_between]
  - [`color_hsv_to_rgb()`][color_hsv_to_rgb]
  - [`color_rgb_to_hsv()`][color_rgb_to_hsv]
  - [`color_list_to_hex()`][color_list_to_hex]
  - [`color_hex_to_list()`][color_hex_to_list]
  - [`color_name()`][color_name]
  - [`color_brightness()`][color_brightness]


Convert colors [^][contents]
----------------------------

#### get_color [^][contents]
[get_color]: #get_color-
Return the color as rgb or rgba list from different color arguments.  
The color argument is the same like OpenSCAD module `color()`
```OpenSCAD
get_color (c, alpha, default, colors)
```
- `c`       - color argument
- `alpha`   - optional, alpha value - transparent to opaque: `0...1`, default = `1`.
- `default` - optional, default color if `c` is not set, default = not set
- `colors`  - optional, a list of color names

_Color arguments:_
- color name as string
  - The color names are taken from the
    World Wide Web consortium's [SVG color list](https://www.w3.org/TR/css-color-3/).
  - Additional defined colors
- color as rgb or rgba list
- `rgb` - as list `[r, g, b]` or `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`
- color as hex string
  - Every hex string begin with a `#`
  - The letters are hexadicimal numbers `0-F` (or even `00-FF`)
  - Hex string formats:
    - `"#rgb"`
    - `"#rgba"`
    - `"#rrggbb"`
    - `"#rrggbbaa"`

_Return list:_
- `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`

_Color lists for argument_ `colors`_:_  
You can set a defined _color name list_,
then the function will only use the color names from this list.  
Actually exists the color name lists:
- `color_name_svg`
  - SVG color list
  - defined in file `banded/color/color_svg.scad`
- `color_name_banded`
  - Additional defined colors
  - defined in file: `banded/color/color_other.scad`
The color name lists can be combined to one:  
```OpenSCAD
new_list = [ each name_list_1, each name_list_2, ... ];
```
All color name lists are already combined in:
- `color_list`
This is used as the default if `colors` is not set.

_Additional defined colors:_
- metal:
  - `"aluminium"`
  - `"brass"`
  - `"oldbrass"`
  - `"copper"`
  - `"iron"`
  - `"stainless"`
  - `"steel"`
  - `"chrome"`
  - `"zinc"`
- wood:
  - `"birch"`
  - `"oak"`
  - `"pine"`

#### color_extend [^][contents]
[color_extend]: #color_extend-
Set the color for an object from different color arguments.  
Module to use extra color names, see [`get_color()`][get_color]

```OpenSCAD
color_extend (c, alpha, default, colors)  object();
```

#### color_between [^][contents]
[color_between]: #color_between-
Return a color as rgb or rgba list between colors `c` and `c2`.  
The color will set with parameter `t`.

_Arguments:_
```OpenSCAD
// get color as rgb or rgba value:
get_color_between (c, c2, t, alpha, colors)

// operator to create a colored object:
color_between (c, c2, t, alpha, colors)  object();

// function operator to create a colored object:
use <banded/draft_primitives_operator.scad>
o = color_between (object, c, c2, t, alpha, colors);
```
- `c`       - color 1 argument
- `c2`      - color 2 argument
- `t`
  - parameter to slide between both colors
    `0...1`  ==> `c...c2`
  - default = `0.5`, half between both colors
- `alpha`
  - optional, alpha value for both colors
  - transparent to opaque: `0...1`, default = `undef`.
- `colors`  - optional, a list of color names

#### color_hsv_to_rgb [^][contents]
[color_hsv_to_rgb]: #color_hsv_to_rgb-
Transform color from hsv model to rgb model.

_Arguments:_
```OpenSCAD
color_hsv_to_rgb (hsv, alpha)
```
- `hsv` - as list `[h, s, v]` or `[h, s, v, alpha]`
  - `h` = hue:               `0...360°`
  - `s` = saturation:        `0...1`
  - `v` = value, brightness: `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`
- return list `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`

#### color_rgb_to_hsv [^][contents]
[color_rgb_to_hsv]: #color_rgb_to_hsv-
Transform color from rgb model to hsv model.

_Arguments:_
```OpenSCAD
color_rgb_to_hsv (rgb, alpha)
```
- `rgb` - as list `[r, g, b]` or `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`
- return list `[h, s, v, alpha]`
  - `h` = hue:               `0...360°`
  - `s` = saturation:        `0...1`
  - `v` = value, brightness: `0...1`

#### color_list_to_hex [^][contents]
[color_list_to_hex]: #color_list_to_hex-
Convert a rgb color list to a hex value string.

_Arguments:_
```OpenSCAD
color_list_to_hex (rgb, alpha)
```
- `rgb` - as list `[r, g, b]` or `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`

#### color_hex_to_list [^][contents]
[color_hex_to_list]: #color_hex_to_list-
Convert a hex color string to a rgb color list.

_Arguments:_
```OpenSCAD
color_hex_to_list (hex, alpha)
```

_Description:_
It can be used the same hex values like for OpenSCAD module `color()`.
- optional alpha value - transparent to opaque: `0...1`, default = `1`
- Every hex string begin with a `#`
- The letters are hexadicimal numbers `0-F` (or even `00-FF`)

Hex string formats:
- `"#rgb"`
- `"#rgba"`
- `"#rrggbb"`
- `"#rrggbbaa"`

- `r` = red:   `0-F` (or even `00-FF`)
- `g` = green: `0-F`
- `b` = blue:  `0-F`
- `a` = alpha value, transparent to opaque: `0-F`, default = `F` or `FF`

#### color_name [^][contents]
[color_name]: #color_name-
Return the name of color to rgb value as list.  
The color names are taken from the World Wide Web consortium's SVG color list.
Contains additional defined colors, see [`get_color()`][get_color].

_Arguments:_
```OpenSCAD
color_name (name, alpha)
```
- `alpha` - optional alpha value - transparent to opaque: `0...1`, default = `1`.

#### color_brightness [^][contents]
[color_brightness]: #color_brightness-
Return the brightness of a color from rgb list.

_Arguments:_
```OpenSCAD
color_brightness (rgb, gamma)
```
- `rgb` - as list `[r, g, b]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
- `gamma` - the gamma correctur factor, optional
  - by gefault `1`
  - a typical value for monitors is `2.2`
  - [=> Wikipedia - Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction)
- return a value of brightness `0...1`
  - `0` = black
  - `1` = white

