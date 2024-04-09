Version
=======

### defined in file
`banded/version.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Versioning](#version---)
  - [Current version](#current-version-)
    - [`version_banded()`][version_banded]
    - [`date_banded()`][date_banded]
  - [Version check](#version-check-)
    - [`is_compatible()`][is_compatible]
    - [`is_compatible_openscad()`][is_compatible_openscad]
    - [`required_version()`][required_version]
  - [Convert version format](#convert-version-format-)
    - [`version_to_str()`][version_to_str]
  - [Deprecated functionality](#deprecated-functionality-)
    - [`deprecated()`][deprecated]


Versioning [^][contents]
-----------------------

Contains functions and modules to manage versioning.


### Current version [^][contents]

Get the version data of this bibliothek.

#### function version_banded() [^][contents]
[version_banded]: #function-version_banded-
Returns this version of BandedScad as a list.  
Uses Semantic Versioning.  
Versioning details see: <https://semver.org/>

Given a version number MAJOR.MINOR.PATCH, increment the:
- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

Format: `[ MAJOR, MINOR, PATCH ]`  
or:     `[ MAJOR, MINOR, PATCH, "pre" ]`

This value is even stored in variable `version_banded`.

#### function date_banded() [^][contents]
[date_banded]: #function-date_banded-
Returns the build date of this version as number.  
Number format: year 4 digit - month 2 digit - day 2 digit
- e.g. number `20240227` means date `27.2.2024`

This value is even stored in variable `date_banded`.


### Version check [^][contents]

Functions and modules to check the compatibility of the version.

#### function is_compatible() [^][contents]
[is_compatible]: #function-is_compatible-
Test if this version of BandedScad is compatible with the destinated version.  
Compare Semantic Versioning scheme in a list.

_Arguments:_
```OpenSCAD
is_compatible (version, current)
```
- `version`
  - the desired version
- `current`
  - optional, by default the current version of BandedScad
  - can be used to check other bibliothek versions with the same version scheme

#### function is_compatible_openscad() [^][contents]
[is_compatible_openscad]: #function-is_compatible_openscad-
Test if this version of OpenSCAD is compatible with the destinated version.

_Arguments:_
```OpenSCAD
is_compatible_openscad (version, current)
```
- `version`
  - the desired version as number, e.g. from `version_num()`
- `current`
  - optional, by default the current version of OpenSCAD as number

#### module required_version() [^][contents]
[required_version]: #module-required_version-
Assert if the current version is incompatible with the desired version.  
Compare Semantic Versioning scheme in a list.

_Arguments:_
```OpenSCAD
required_version (version, current)
```
- `version`
  - the desired version
- `current`
  - optional, by default the current version of BandedScad
  - can be used to check other bibliothek versions with the same version scheme

You can use this to ensure that you use the correct version.  
_Example:_
```OpenSCAD
// Assert a message if the current version is incompatible:
required_version ([1.0.0]);
```


### Convert version format [^][contents]

#### function version_to_str() [^][contents]
[version_to_str]: #function-version_to_str-
Convert a version number to a printable string.

_Arguments:_
```OpenSCAD
version_to_str (version)
```
- `version`
  - the version as list in Semantic Versioning scheme


### Deprecated functionality [^][contents]

#### module and function deprecated() [^][contents]
[deprecated]: #module-and-function-deprecated-
Yield a 'deprecated' message in console.  
You can put this in deprecated modules or functions.
Then it will show a message if these are executed.

_Arguments:_
```OpenSCAD
deprecated (old, alternative, message)
```
- `old`
  - old deprecated name of functionality as string
- `alternative`
  - optional, alternative name of functionality as string
- `message`
  - optional, an additional text

