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


Convert colors [^][contents]
----------------------------

#### `get_color (c, alpha, default)` [^][contents]
[get_color]: #get_color-c-alpha-default-
Return the color as rgb or rgba list from different color arguments.\
The color argument is the same like OpenSCAD module `color()`
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
  - Every hex string begin with a "#"
  - The letters are hexadicimal numbers `0-F` (or even `00-FF`)
  - Hex string formats:
    - "#rgb"
    - "#rgba"
    - "#rrggbb"
    - "#rrggbbaa"

Return list `[r, g, b, alpha]`:
- `r` = red:   `0...1`
- `g` = green: `0...1`
- `b` = blue:  `0...1`
- `alpha` = transparent to opaque: `0...1`, default = `1`

#### `color_hsv_to_rgb (hsv, alpha)` [^][contents]
[color_hsv_to_rgb]: #color_hsv_to_rgb-hsv-alpha-
Transform color from hsv model to rgb model.

- `hsv` - as list `[h, s, v]` or `[h, s, v, alpha]`
  - `h` = hue:               `0...360°`
  - `s` = saturation:        `0...1`
  - `v` = value, brightness: `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`
- return list `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`

#### `color_rgb_to_hsv (rgb, alpha)` [^][contents]
[color_rgb_to_hsv]: #color_rgb_to_hsv-rgb-alpha-
Transform color from rgb model to hsv model.

- `rgb` - as list `[r, g, b]` or `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`
- return list `[h, s, v, alpha]`
  - `h` = hue:               `0...360°`
  - `s` = saturation:        `0...1`
  - `v` = value, brightness: `0...1`

#### `color_list_to_hex (rgb, alpha)` [^][contents]
[color_list_to_hex]: #color_list_to_hex-rgb-alpha-
Convert a rgb color list to a hex value string.

- `rgb` - as list `[r, g, b]` or `[r, g, b, alpha]`
  - `r` = red:   `0...1`
  - `g` = green: `0...1`
  - `b` = blue:  `0...1`
  - `alpha` = transparent to opaque: `0...1`, default = `1`

#### `color_hex_to_list (hex, alpha)` [^][contents]
[color_hex_to_list]: #color_hex_to_list-hex-alpha-
Convert a hex color string to a rgb color list.
As hex values can used the same like for OpenSCAD module `color()`.
- optional alpha value - transparent to opaque: `0...1`, default = `1`
- Every hex string begin with a "#"
- The letters are hexadicimal numbers `0-F` (or even `00-FF`)

Hex string formats:
- "#rgb"
- "#rgba"
- "#rrggbb"
- "#rrggbbaa"

- `r` = red:   `0-F` (or even `00-FF`)
- `g` = green: `0-F`
- `b` = blue:  `0-F`
- `a` = alpha value, transparent to opaque: `0-F`, default = `F` or `FF`

#### `color_name (name, alpha)` [^][contents]
[color_name]: #color_name-name-alpha-
Return the name of color to rgb value as list.\
The color names are taken from the World Wide Web consortium's SVG color list.
- `alpha` - optional alpha value - transparent to opaque: `0...1`, default = `1`.

