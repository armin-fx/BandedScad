Draft objects in a point list
=============================

### defined in file
```tools/draft.scad```\
``` ```| \
``` ```+--> ```tools/draft_curves.scad```\
``` ```| \
``` ```+--> ```tools/draft_transform.scad```\
``` ```| . . . . +--> ```tools/draft_transform_basic.scad```\
``` ```| . . . . +--> ```tools/draft_transform_common.scad```\
``` ```| \
``` ```+--> ```tools/draft_multmatrix.scad```\
``` ```. . . . . +--> ```tools/draft_multmatrix_basic.scad```\
``` ```. . . . . +--> ```tools/draft_multmatrix_common.scad```

### Contents
[contents]: #contents "Up to Contents"
- [Curves](#curves-)
  - [Bezier curve](#bezier-curve-)
  - [Circle](#circle-)
  - [Superellipse](#superellipse-)
  - [Superformula](#superformula-)
  - [Polynom function](#polynom-function-)
  - [Square](#square-)
  - [Helix](#helix-)
- [Transform functions on list](#transform-functions-)
- [Multmatrix](#multmatrix-)

Curves [^][contents]
------

Creates curves in a list

There is a name convention of functions from curves:
- Name of curve type with ending ```_point``` - creates a point of the curve at given position.\
  such as ```circle_point()```
- Name of curve type with ending ```_curve``` - creates a curve with given parameters.\
  such as ```circle_curve()```

### defined in file
```tools/draft_curves.scad```

### Bezier curve [^][contents]

### Circle [^][contents]
Generates a point list for a circle

Functions:
- ```circle_point()```\
  Returns a 2d point of a circle with center at origin.\
  Turns at mathematical direction of rotation = counter clockwise
  
  __Options:__
  - ```r, d```
    - radius or diameter of circle
  - ```angle```
    - point at given angle

- ```circle_curve()```\
  Return a 2d point list of a circle

  __Options:__
  - ```r, d```
    - radius or diameter of circle
  - ```angle```
    - drawed angle in grad, standard=360°
      - as number -> angle from 0 to ```angle``` = opening angle
      - as list   -> range ```[opening angle, begin angle]```
  - ```slices```
     - count of segments, without specification it gets the same like ```circle()```
     - with ```"x"``` includes the extra special variables to automatically control the count of segments
  - ```piece```
    - ```true```  - like a pie, like ```rotate_extrude()``` in OpenScad
    - ```false``` - connect the ends of the circle
    - ```0```     - to work on, ends not connected, no edges, standard
  - ```outer```
    - value ```0```...```1```
      - ```0``` - edges on real circle line, standard like ```circle()``` in OpenScad
      - ```1``` - tangent on real circle line
      - any value between, such as ```0.5``` = middle around inner or outer circle

### Superellipse [^][contents]
### Superformula [^][contents]
### Polynom function [^][contents]
### Square [^][contents]
### Helix [^][contents]


Transform functions [^][contents]
-------------------


Multmatrix [^][contents]
----------

