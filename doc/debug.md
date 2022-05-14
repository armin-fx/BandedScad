Debug
=====

### defined in file

`banded/debug.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Contents"
- [Debug modules](#debug-modules-)
  - [Echo in console](#echo-in-console-)
    - [`echo_line()`][echo_line]
  - [Make points and lines visible](#make-points-visible-)
    - [`show_point()`][show_point]
    - [`show_points()`][show_points]
    - [`show_trace()`][show_trace]
    - [`show_line()`][show_line]
    - [`show_lines()`][show_lines]
  - [Test parts of objects](#test-parts-of-objects-)
    - [`object_slice()`][object_slice]
    - [`object_pane()`][object_pane]


Debug modules [^][contents]
---------------------------
Objects to make parts of objects and points in variables seeable.


### Echo in console [^][contents]

#### `echo_line (length, char)` [^][contents]
[echo_line]: #echo_line-
Echo a horizontal line into the console.
- `length` - length of line in letter, default = `50`
- `char`   - character of line, default = `-`

___Specialized modules with fixed character:___
- `echo_short_line (length)` - Echo a thinner line
- `echo_bar  (length)`       - Echo a bigger line, character = `=`
- `echo_wall (length)`       - Echo a fat line, character = `#`


### Make points and lines visible [^][contents]

#### `show_point (p, c, d)` [^][contents]
[show_point]: #show_point-p-c-d-
Module to create a visible point.
- `p` - a point
- `c` - optional, the color of the point
- `d` - optional, the diameter of the point, default = `0.2mm`

#### `show_points (p_list, c, d)` [^][contents]
[show_points]: #show_points-
Module to create visible points.
- `p_list` - a list with points
- `c` - optional, the color of the points
- `d` - optional, the diameter of the points, default = `0.2mm`

#### `show_trace (p_list, c, closed, d, dp)` [^][contents]
[show_trace]: #show_trace-p_list-c-closed-d-dp-
Module to create visible points.\
Create a line between the points.
If the same point is twice in order, then it will create a visible point at this position.
- `p_list` - a list with points
- `c`  - optional, the color of the points
- `closed`
  - `true`  - the trace is a closed loop, the last point connect the first point
  - `false` - the trace from first to last point, default
- `d`  - optional, the diameter of the line between the points, default = `0.1mm`
- `dp` - optional, the diameter of the same points, default = `0.15mm`

#### `show_line (l, c, d)` [^][contents]
[show_line]: #show_line-l-c-d-
Module to create a visible line.
- `l` - a line, a list with 2 points
- `c`  - optional, the color of the line
- `d`  - optional, the diameter of the line, default = `0.1mm`

#### `show_lines (l_list, c, d)` [^][contents]
[show_lines]: #show_lines-l_list-c-d-
Module to create visible lines in a list.
- `l_list` - a list with lines, a line is a list with 2 points
- `c`  - optional, the color of a line
- `d`  - optional, the diameter of a line, default = `0.1mm`


### Test parts of objects [^][contents]

#### `object_slice (axis, position, thickness, limit)` [^][contents]
[object_slice]: #object_slice-axis-position-thickness-limit-
Cuts a slice out of an object.\
Useful for testing hidden details of an object.

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

#### `object_pane (position, thickness, limit)` [^][contents]
[object_pane]: #object_pane-position-thickness-limit-
Create a small pane in X-Y-plane of an object at given height.
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

