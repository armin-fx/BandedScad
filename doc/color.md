Color
=====

### defined in file
`banded/draft.scad`\
` `| \
` `+--> `banded/draft_color.scad`\
` `. . .

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Convert colors](#convert-colors-)
  - [`get_color`][get_color]
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
Return the color as rgb or rgba list from different color arguments.\
The color argument is the same like OpenSCAD module `color()`
```OpenSCAD
get_color (c, alpha, default)
```
- `c`       - color argument
- `alpha`   - optional alpha value - transparent to opaque: `0...1`, default = `1`.
- `default` - optional default color if `c` is not set

Color arguments:
- color name as string
  - The color names are taken from the World Wide Web consortium's SVG color list.
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

Return list `[r, g, b, alpha]`:
- `r` = red:   `0...1`
- `g` = green: `0...1`
- `b` = blue:  `0...1`
- `alpha` = transparent to opaque: `0...1`, default = `1`

#### color_hsv_to_rgb [^][contents]
[color_hsv_to_rgb]: #color_hsv_to_rgb-
Transform color from hsv model to rgb model.
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
```OpenSCAD
color_hex_to_list (hex, alpha)
```
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
Return the name of color to rgb value as list.\
The color names are taken from the World Wide Web consortium's SVG color list.
```OpenSCAD
color_name (name, alpha)
```
- `alpha` - optional alpha value - transparent to opaque: `0...1`, default = `1`.

#### color_brightness [^][contents]
[color_brightness]: #color_brightness-
Return the brightness of a color from rgb list.
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

