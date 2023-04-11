Antiquity
=========

### defined in file
`antiquity/*`\
` `|\
` `+- `compatibility_v2015.scad`\
` `+- `compatibility_v2015_assert.scad`\
` `|\
` `+- `compatibility_v2019.scad`

[<-- file overview](file_overview.md)\
[<-- table of contents](contents.md)

### Contents
[contents]: #contents "Up to Contents"
- [Compatibility files](#compatibility-files-)
  - [For OpenSCAD version 2015.03](#for-openscad-version-201503-)
  - [For OpenSCAD version 2019.05](#for-openscad-version-201905-)


### Compatibility files [^][contents]

If you want to use some new buildin functions from OpenSCAD in older OpenSCAD version
you can include file 'compatibility_???.scad'.
They emulate the missing functions
and don't disturb on newer versions if you have forgotten to remove them.
They are not needed for the library.\
These are in the folder `antiquity`.

#### For OpenSCAD version 2015.03 [^][contents]
Emulated functions:
- `is_undef()`
- `is_bool()`
- `is_num()`
- `is_list()`
- `is_string()`
- `is_function()`
- `ord()`
- `assert()` - in another file, generate an error on newer OpenSCAD versions

```OpenSCAD
include <compatibility_v2015.scad>
// If you want use assert()
include <compatibility_v2015_assert.scad>
```

#### For OpenSCAD version 2019.05 [^][contents]
Emulated functions:
- `is_function()`
  - returns always `false` in older OpenSCAD versions
    where function literals not exists

```OpenSCAD
include <compatibility_v2019.scad>
```
