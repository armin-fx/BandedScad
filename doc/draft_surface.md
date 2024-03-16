Draft objects as data list - Surfaces
=====================================

### defined in file
`banded/draft.scad`  
` `|  
` `+--> `banded/draft_surface.scad`  
` `|  
` `. . .  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Creates curves ->](draft_curves.md)

- [Creates surfaces](#surface-)
  - [Bezier surface](#bezier-surface-)
  - [Bezier triangle](#bezier-triangle-)

[build]: draft_primitives.md#build-


Surface [^][contents]
---------------------
Creates surface data in a list

There is a name convention of functions from curves:
- Name with ending `_point`
  - Creates a point on the surface at given position.
  - Such as `bezier_surface_point()`
- Name with ending `_grid`
  - Creates a grid with points on the surface with given parameters.
  - Such as `bezier_surface_grid()`
  - A grid is a list with lists of points
- Name with ending `_mesh`
  - Creates a surface mesh with points and faces as list `[point list, face list]`.
  - Such as `bezier_surface_mesh()`
  - These data can used as arguments for `polyhedron()`,
    this is implemented in module [`build()`][build].


### Bezier surface [^][contents]
Generates Bézier surfaces.  
[=> Wikipedia - Bézier surface](https://en.wikipedia.org/wiki/B%C3%A9zier_surface)

#### bezier_surface_point [^][contents]
Returns a point of a Bézier surface of (m,n)'th degree.

_Options:_
```OpenSCAD
bezier_surface_point (t, p)
```
- `t`
  - a list `[x,y]` with 2 numeric values between `0`...`1`
  - where `x` controls the position on the X-axis, `y` on the Y-axis
- `p`
  - a grid of control points (n·m), where n, m specify the degree of the Bézier surface
  - `[[p0, ..., pm ]`
    `,[.., ..., ...]`
    `,[pn, ..., pnm]]`

#### bezier_surface_grid [^][contents]
Returns a Bézier surface grid of (m,n)'th degree.

_Options:_
```OpenSCAD
bezier_surface_grid (p, slices)
```
- `p`
  - a grid of control points (n·m), where n, m specify the degree of the Bézier surface
  - `[[p0, ..., pm ]`
    `,[.., ..., ...]`
    `,[pn, ..., pnm]]`
- `slices`
  - Bézier surface is sliced in fragments into this number of points per side of the grid,
    at least 2 points per side
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken (roughly implemented)
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used  (roughly implemented)

#### bezier_surface_mesh [^][contents]
Returns a Bézier surface mesh of (m,n)'th degree.

_Options:_
```OpenSCAD
bezier_surface_mesh (p, slices)
```
- `p`
  - a grid of control points (n·m), where n, m specify the degree of the Bézier surface
  - `[[p0, ..., pm ]`
    `,[.., ..., ...]`
    `,[pn, ..., pnm]]`
- `slices`
  - Bézier surface is sliced in fragments into this number of points per side of the grid,
    at least 2 points per side
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken (roughly implemented)
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used  (roughly implemented)


### Bezier triangle [^][contents]
Generates Bézier triangles.  
[=> Wikipedia - Bézier triangle](https://en.wikipedia.org/wiki/B%C3%A9zier_triangle)

#### bezier_triangle_point [^][contents]
Returns a point of a Bézier triangle of (m,n)'th degree.

_Options:_
```OpenSCAD
bezier_triangle_point (t, p)
```
- `p`
  - a triangle grid of control points, where n specify the degree of the Bézier surface
  - `[[p0, ..., pn ]`
    `,[.., ...]`
    `,[pn]]`
- `t`
  - a list `[a,b,c]` with 3 numeric values between `0`...`1`
  - where `a`, `b`, `c` are barycentric coordinates which describe the point in the triangle
    - `a` means the upper left edge of the triangle grid
    - `b` means the upper right edge
    - `c` means the bottom edge
  - A higher value for one egde, eg. `a` will move the point closer to this edge.
    A lower value for one egde will move the point further away from this.

#### bezier_triangle_grid [^][contents]
Returns a Bézier triangle grid of (m,n)'th degree.

_Options:_
```OpenSCAD
bezier_triangle_grid (p, slices)
```
- `p`
  - a triangle grid of control points, where n specify the degree of the Bézier surface
  - `[[p0, ..., pn ]`
    `,[.., ...]`
    `,[pn]]`
- `slices`
  - Bézier surface is sliced in fragments into this number of points per side of the grid,
    at least 2 points per side
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken (roughly implemented)
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used  (roughly implemented)

#### bezier_triangle_mesh [^][contents]
Returns a Bézier triangle mesh of (m,n)'th degree.

_Options:_
```OpenSCAD
bezier_triangle_mesh (p, slices)
```
- `p`
  - a triangle grid of control points, where n specify the degree of the Bézier surface
  - `[[p0, ..., pn ]`
    `,[.., ...]`
    `,[pn]]`
- `slices`
  - Bézier surface is sliced in fragments into this number of points per side of the grid,
    at least 2 points per side
  - If not specified, the number of points from `$fn`, `$fa`, `$fs` are taken (roughly implemented)
  - If set `"x"`, the information from the extra special variables
    (`$fn_min`, `$fn_max`, `$fd`, ...) are also used  (roughly implemented)

