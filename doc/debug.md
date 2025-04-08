Debug
=====

### defined in file

`banded/debug.scad`

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Contents"
- [Debug modules](#debug-modules-)
  - [Echo in console](#echo-in-console-)
    - [`echo_line()`][echo_line]
    - [`echo_list()`][echo_list]
  - [Make points and lines visible](#make-points-and-lines-visible-)
    - [`show_point()`][show_point]
    - [`show_points()`][show_points]
    - [`show_points_grid()`][show_points_grid]
    - [`show_line()`][show_line]
    - [`show_lines()`][show_lines]
    - [`show_trace()`][show_trace]
    - [`show_traces()`][show_traces]
    - [`show_vector()`][show_vector]
    - [`show_label()`][show_label]
  - [Show parts of objects](#show-parts-of-objects-)
    - [`virtual()`][virtual]
    - [`object_slice()`][object_slice]
    - [`object_pane()`][object_pane]


Debug modules [^][contents]
---------------------------

Objects to make parts of objects and points in variables seeable.


### Echo in console [^][contents]

#### echo_line [^][contents]
[echo_line]: #echo_line-
Echo a horizontal line into the console.  
As module or as function to generate the text for `echo()`.

_Arguments:_
```OpenSCAD
echo_line (length, char)
```
- `length` - length of line in letter, default = `50`
- `char`   - character of line, default = `-`

_Specialized modules with fixed character:_
- `echo_thin_line (length)` - Echo a thinner line
- `echo_bar  (length)`      - Echo a bigger line, character = `=`
- `echo_wall (length)`      - Echo a fat line, character = `#`

#### echo_list [^][contents]
[echo_list]: #echo_list-
Echo every entry from a list into the console.  
Every entry will start in a new line.
As module or as function to generate the text for `echo()`.
As default you can copy and paste the output text and use it as code.

_Arguments:_
```OpenSCAD
echo_list (list, txt, pre, first, next, last)
```
- `txt`
  - optional text that echoes at first
- `pre`
  - text that is preposed at every list entry
  - default = 1 tab `"\t"`
- `first`
  - text after `pre` and before the first list entry
  - default = `"["`, begin of a list
- `next`
  - text after `pre` and before every list entry, except the first list entry
  - default = `","`, next list entry
- `last`
  - text after the last list entry
  - default = `"]"`, end of a list

_Example:_
``` OpenSCAD
include <banded.scad>

echo_list( identity_matrix (4) );
```

_Output:_
```
ECHO: "
	[[1, 0, 0, 0]
	,[0, 1, 0, 0]
	,[0, 0, 1, 0]
	,[0, 0, 0, 1]]"
```

### Make points and lines visible [^][contents]

All following objects are only shown
in preview mode (F5) and are hidden in render mode (F6).
The default color of these objects is "orange".

#### show_point [^][contents]
[show_point]: #show_point-
Module to create a visible point.

_Arguments:_
```OpenSCAD
show_point (p, c, d, auto)
```
- `p` - a point, defined by a list `[X,Y,Z]` or `[X,Y]`
- `c` - optional, the color of the point
- `d` - optional, the diameter of the point, default = `0.2mm`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

#### show_points [^][contents]
[show_points]: #show_points-
Module to create visible points.

_Arguments:_
```OpenSCAD
show_points (p_list, c, d, auto)
```
- `p_list` - a list with points
- `c` - optional, the color of the points
  - if set `true`, every point get an other color
- `d` - optional, the diameter of the points, default = `0.2mm`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

_Specialized module:_
- `show_points_colored (p_list, d, auto)`
  - every point get an other color by default

#### show_points_grid [^][contents]
[show_points_grid]: #show_points_grid-
Module to create visible points in a grid.  
A grid is defined by a list with lists which contains points.

_Arguments:_
```OpenSCAD
show_points_grid (p_list, c, d, auto)
```
- `p_list` - a list with lists with points
- `c` - optional, the color of the points
  - if set `true`, every point get an other color
- `d` - optional, the diameter of the points, default = `0.2mm`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

_Specialized module:_
- `show_points_grid_colored (p_list, d, auto)`
  - every point get an other color by default

#### show_line [^][contents]
[show_line]: #show_line-
Module to create a visible line.

_Arguments:_
```OpenSCAD
show_line (l, c, direction, d, auto)
```
- `l` - a line, a list with 2 points
- `c` - optional, the color of the line
- `d` - optional, the diameter of the line, default = `0.1mm`
- `direction` - show the direction of the line with an arrow if set `true`
  - default = `false`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

#### show_lines [^][contents]
[show_lines]: #show_lines-
Module to create visible lines in a list.

_Arguments:_
```OpenSCAD
show_lines (l_list, c, direction, d, auto)
```
- `l_list` - a list with lines, a line is a list with 2 points
- `c`  - optional, the color of a line
  - if set `true`, every line get an other color
- `d`  - optional, the diameter of a line, default = `0.1mm`
- `direction` - show the direction of the line with an arrow if set `true`
  - default = `false`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

_Specialized module:_
- `show_lines_colored (l_list, direction, d, auto)`
  - every line get an other color by default

#### show_vector [^][contents]
[show_vector]: #show_vector-
Module to create a visible line to show a vector.

_Arguments:_
```OpenSCAD
show_vector (v, p, c, direction, d, auto)
```
- `v` - a vector
- `p` - starting point of the vector, default = from origin
- `c` - optional, the color of the line
- `d` - optional, the diameter of the line, default = `0.1mm`
- `direction` - show the direction of the line with an arrow if set `true`
  - default = `true`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

#### show_trace [^][contents]
[show_trace]: #show_trace-
Module to create a visible trace.  
Create a line between the points.
If the same point is twice in order, then it will create a visible point at this position.

_Arguments:_
```OpenSCAD
show_trace (p_list, c, closed, direction, d, p_factor, auto)
```
- `p_list`  - a list with points in order
- `c`       - optional, the color of the points
  - if set `true`, every line of the trace get an other color
- `closed`
  - `true`  - the trace is a closed loop, the last point connect the first point
  - `false` - the trace from first to last point, default
- `d`       - optional, the diameter of the line between the points, default = `0.1mm`
- `p_factor`
  - optional, the factor to multiplicate with diameter `d`,
    to calculate the diameter of the visible same points
  - default = `1.5 * d`
- `direction` - show the direction of every line with an arrow if set `true`
  - default = `false`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

_Specialized module:_
- `show_trace_colored (p_list, closed, direction, d, p_factor, auto)`
 - every line of the trace get an other color by default

#### show_traces [^][contents]
[show_traces]: #show_traces-
Module to create visible traces.  
Create a line between the points of ervery trace.
If the same point is twice in order, then it will create a visible point at this position.

_Arguments:_
```OpenSCAD
show_traces (p_lists, c, closed, direction, d, p_factor, auto)
```
- `p_lists` - a list with traces, every trace is a list with points in order
- `c`       - optional, the color of the traces
  - if set `true`, every trace get an other color
- `closed`
  - `true`  - every trace is a closed loop, the last point connect the first point
  - `false` - every trace from first to last point, default
- `d`       - optional, the diameter of the line between the points, default = `0.1mm`
- `p_factor`
  - optional, the factor to multiplicate with diameter `d`,
    to calculate the diameter of the visible same points
  - default = `1.5 * d`
- `direction` - show the direction of every line with an arrow if set `true`
  - default = `false`
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size

_Specialized module:_
- `show_traces_colored (p_lists, closed, direction, d, p_factor, auto)`
  - every trace get an other color by default

#### show_label [^][contents]
[show_label]: #show_label-
Show a label with text.

_Arguments:_
```OpenSCAD
show_label (txt, h, a, valign, halign, auto)
```
- `txt` - the text as string
- `h` - the height of the letter, default = `3.3mm`
- `a` - the angle of the label
  - default = `$vpr`,
    rotates on every preview update that the text always faces the camera
- `valign` - The vertical alignment for the text, default = "baseline"
- `halign` - The horizontal alignment for the text, default = "left"
- `auto` - optional, change the size in dependency of the displayed distance
  - value range `0...1`, where
    - `0` = don't change the size
    - `1` = size is always the same size in display
  - default = `0`, don't change the size
  - In default view (then`$vpd` = 140), the text displays
    in the same size, when `auto` is set `1` like it is set `0`.


### Show parts of objects [^][contents]

#### virtual [^][contents]
[virtual]: #virtual-
Show an object only in preview mode.  
This is useful if you create a component object and
you want to see the main object for what it is.

_Arguments:_
```OpenSCAD
virtual (c, alpha)
```
- `c`
  - optional, color argument
  - default = `"lightgrey"`
- `alpha`
  - optional, alpha value - transparent to opaque: `0...1`
  - default = `0.5`

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

#### object_slice [^][contents]
[object_slice]: #object_slice-
Cuts a slice out of an object.  
Useful for testing hidden details of an object.

_Arguments:_
```OpenSCAD
object_slice (axis, position, thickness, limit)
```
- `axis` - vector orthogonal out of the object_pane
  - currently only exactly the X, Y and Z - axis
  - default = Y-axis
- `position`  - position of the slice along the axis away from origin
- `thickness` - thickness of the pane, default = `1`
- `limit` - internal parameter
  - The module knows nothing about the children to slice,
    so internal objects to work on this must made much bigger then the
    children could be.
    The `limit` parameter can set to an other value if these internal objects
    are to small.
  - default = `1000`

#### object_pane [^][contents]
[object_pane]: #object_pane-
Create a small pane in X-Y-plane of an object at given height.

_Arguments:_
```OpenSCAD
object_pane (position, thickness, limit)
```
- `position`  - position of the slice along the Z-axis away from origin
- `thickness` - thickness of the pane, default = constant `2 * epsilon`
- `limit` - internal parameter
  - The module knows nothing about the children to slice,
    so internal objects to work on this must made much bigger then the
    children could be.
    The `limit` parameter can set to an other value if these internal objects
    are to small.
  - default = `1000`
  - can set as size `[X, Y]`

