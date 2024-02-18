Constants
=========

### defined in file
`banded/constants.scad`\
` `| \
` `+--> `banded/constants_user.scad`\
` `+--> `banded/constants_technical.scad`\
` `+--> `banded/constants_helper.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Defined constants](#defined-constants-)
  - [Integrated in OpenSCAD](#integrated-in-openscad-)
  - [Mathematical constants](#mathematical-constants-)
  - [Convert units of measure](#convert-units-of-measure-)
  - [Natural constants](#natural-constants-)
  - [Auxiliary constants](#auxiliary-constants-)
  - [Functions](#functions-)
    - [`axis()`][axis]
    - [`origin()`][origin]
  - [Customizable constants](#customizable-constants-)
  - [Technical constants](#technical-constants-)
    - [Paper size](#paper-size-)


Defined constants [^][contents]
-------------------------------
The file `banded/constants.scad` must be included with:
```OpenSCAD
include <banded/constants.scad>
```
With `use` the constants can not be seen.

On load it will test the constant and show a message
in console if constants has changed.


### Integrated in OpenSCAD [^][contents]

| constant | number        | description
|----------|---------------|-------------
| `PI`     | 3.14159265359 | circular number = circumference divided by diameter


### Mathematical constants [^][contents]

| constant            | number          | description
|---------------------|-----------------|-------------
| `tau`               | 2 * PI          | circumference divided by radius <https://tauday.com/>
| `euler`             | 2.71828182846   | Euler's number, the base of the natural logarithms
| `euler_mascheroni`  | 0.577215664901  | Euler-Mascheroni constant [=> Wikipedia - Euler's constant](https://en.wikipedia.org/wiki/Euler%27s_constant)
| `golden`            | 1.61803398875   | Golden ratio [=> Wikipedia - Golden ratio](https://en.wikipedia.org/wiki/Golden_ratio)


### Convert units of measure [^][contents]

| constant            | number          | description
|---------------------|-----------------|-------------
| `mm_per_inch`       | 25.4            | multiplicate to get mm from inch
| `inch_per_mm`       | 1 / 25.4        | multiplicate to get inch from mm
| `mm_per_foot`       | 25.4 * 12       | multiplicate to get mm from foot
| `foot_per_mm`       | 1 / mm_per_foot | multiplicate to get foot from mm
| `mm_per_yard`       | 25.4 * 12 * 3   | multiplicate to get mm from yard
| `yard_per_mm`       | 1 / mm_per_yard | multiplicate to get yard from mm
| `degree_per_radian` | 180 / PI        | multiplicate to get angle in degree from angle in radian
| `radian_per_degree` | PI / 180        | multiplicate to get angle in radian from angle in degree
| `percent`           | 1 / 100         | e.g. 30% to ratio - `30 * percent`
| `permille`          | 1 / 1000        | e.g.  2% to ratio - `2 * permille`
| `ppm`               | 1 / 1000000     | e.g. 10ppm to ratio - `10 * ppm`


### Natural constants [^][contents]

| constant            | number          | unit  | description
|---------------------|-----------------|-------|-------------
| `lightspeed`        | 299792458       | m/s   | Speed of light
| `planck`            | 6.62607015E-34  | J*s   | Planck's constant
| `boltzmann`         | 1.380649E-23    | J/K   | Boltzmann constant
| `elementary_charge` | 1.602176634E-19 | C     | Elementary charge
| `avogadro`          | 6.02214076E-23  | 1/mol | Avogadro constant
| `caesium_frequency` | 9192631770      | 1/s   | Frequency of the radiation of the cesium atom


### Auxiliary constants [^][contents]

| constant | value     | description
|----------|-----------|-------------
| `inf`    |           | value positive infinity
| `nan`    |           | value not-a-number
| `X`      | `[1,0,0]` | X-axis as 3D vector
| `Y`      | `[0,1,0]` | Y-axis as 3D vector
| `Z`      | `[0,0,1]` | Z-axis as 3D vector
| `O`      | `[0,0,0]` | origin as 3D vector
| `A`      | `[1,1,1]` | all axis set as 3D vector


### Functions [^][contents]

#### `axis (n, d)` [^][contents]
[axis]: #axis-n-d-
Returns a vector with axis n.
- `n` - number of axis (X=`0`, Y=`1`, Z=`2`)
- `d` - count of dimensions
  - `2` = 2D plane
  - `3` = 3D room, default

`axis (1)` returns `[0,1,0]`

_Spezialized functions with fixed axis `n`:_
- `x (d)` - X-axis
- `y (d)` - Y-axis
- `z (d)` - Z-axis

#### `origin (d, v)` [^][contents]
[origin]: #origin-d-v-
Returns a zero vector. Point = origin.
- `d` - count of dimensions
  - `2` = 2D plane, returns `[0,0]`
  - `3` = 3D room, returns `[0,0,0]`, default
- `v` - value of zero, default = `0`


### Customizable constants [^][contents]
These constants can be adjusted to the needs.\
Defined in file: `banded/constants_user.scad`

| constant            | default number
|---------------------|----------------
| `extra`             | 0.02
| `epsilon`           | 0.000075
| `deviation`         | 1e-14
| `deviation_sqr`     | 7.45058e-9
| `delta_std`         | 0.001

___`extra`:___
- Number to add or subtract if clipping objects need to be slightly larger
  due to prevent Z-fighting.

___`epsilon`:___
- Smallest number to add or subtract, so you can't see it on the object.
- E.g. if 2 objects share a corner and therefore generate errors.

___`deviation`:___
- Smallest number that occurs when calculations are inaccurate.

___`deviation_sqr`:___
- Smallest number that occurs when calculations with squared numbers are inaccurate.

___`delta_std`:___
- Step amount for calculation of approximate values.
- Used in functions `integrate()` and `derivation()`.


### Technical constants [^][contents]
Contains constants and functions for standard sizes and measures.
Defined in file: `banded/constants_technical.scad`

#### Paper size: [^][contents]
Defines paper size in ISO 216.\
ISO 216 is an international standard for paper sizes.
The standard defines the __"A"__, __"B"__ and __"C"__ series of paper sizes,
including __A4__, the most commonly available paper size worldwide.

_Function:_\
__`iso_216 (serie, number)`__
- Returns the paper size as list: `[smallest size, biggest size]`
- Arguments:
  - `serie`  - format `"A"`, `"B"` or `"C"`
  - `number` - size as numeric value `0`...`10`
- Example for paper size __A4__:
  - `iso_216 ("A",4)`

_Defined Constants_:
| size | A series formats | B series formats | C series formats
|------|------------------|------------------|------------------
|  0   | `ISO_A0`         | `ISO_B0`         | `ISO_C0`
|  1   | `ISO_A1`         | `ISO_B1`         | `ISO_C1`
| ...  | ...              | ...              | ...
|  9   | `ISO_A9`         | `ISO_B9`         | `ISO_C9`
| 10   | `ISO_A10`        | `ISO_B10`        | `ISO_C10`

