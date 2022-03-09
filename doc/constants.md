Constants
=========

### defined in file
`banded/constants.scad`\
` `| \
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
  - [Customizable auxiliary constants](#customizable-auxiliary-constants-)
  - [Auxiliary constants](#auxiliary-constants-)
  - [Functions](#functions-)
    - [`axis()`][axis]


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
| `mm_per_inch`       | 25.4            |
| `degree_per_radian` | 180 / PI        |
| `percent`           | 1 / 100         | e.g. 30% to ratio - `30 * percent`


### Natural constants [^][contents]

| constant            | number          | unit  | description
|---------------------|-----------------|-------|-------------
| `lightspeed`        | 299792458       | m/s   | Speed of light
| `planck`            | 6.62607015E-34  | J*s   | Planck's constant
| `boltzmann`         | 1.380649E-23    | J/K   | Boltzmann constant
| `elementary_charge` | 1.602176634E-19 | C     | Elementary charge
| `avogadro`          | 6.02214076E-23  | 1/mol | Avogadro constant
| `caesium_frequency` | 9192631770      | 1/s   | Frequency of the radiation of the cesium atom


### Customizable auxiliary constants [^][contents]

| constant            | default number
|---------------------|----------------
| `extra`             | 0.02
| `epsilon`           | 0.000075
| `deviation`         | 1e-14

___`extra`:___
- Number to add or subtract if clipping objects need to be slightly larger
  due to prevent Z-fighting.

___`epsilon`:___
- Smallest number to add or subtract, so you can't see it on the object.
- E.g. if 2 objects share a corner and therefore generate errors.

___`deviation`:___
- Smallest number that occurs when calculations are inaccurate.


### Auxiliary constants [^][contents]

| constant | value     | description
|----------|-----------|-------------
| `inf`    |           | value positive infinity
| `nan`    |           | value not-a-number
| `X`      | `[1,0,0]` | X-axis as 3D vextor
| `Y`      | `[0,1,0]` | Y-axis as 3D vextor
| `Z`      | `[0,0,1]` | Z-axis as 3D vextor


### Functions [^][contents]

#### `axis (n, d)` [^][contents]
[axis]: #axis-n-d-
Returns a vector with axis n.
- `n` - number of axis (X=`0`, Y=`1`, Z=`2`)
- `d` - count of dimensions (2D plane = `2`; 3D room, default = `3`)

___Spezialized functions with fixed axis `n`:___
`x (d)` - X-axis
`y (d)` - X-axis
`z (d)` - X-axis

